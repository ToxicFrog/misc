// Program for reading DHT11 temperature/humidity sensor data on the NTC CHIP.
// Uses sysfs for reading, so may sometimes fail due to timing issues. Recommend
// running with a very aggressive nice value to mitigate this.

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

// open(2)/close(2)
#include <fcntl.h>
// pread/pwrite
#define _XOPEN_SOURCE 500
#include <unistd.h>

#define BUFSIZE 256

typedef struct GPIO {
	// We keep that as a char here because everything that needs to interact with
	// it uses strings, so there's no point in turning it from a string to an int
	// when parsing argv and then back into a string everywhere we use it.
	const char* pin;
	// FDs for pin direction (write-only) and value (read-write).
	int direction;
	int value;
} GPIO;

typedef enum GPIO_DIRECTION {
	IN = 0,
	OUT = 1,
} GPIO_DIRECTION;

void GPIO_direction(GPIO* gpio, GPIO_DIRECTION dir) {
	if (dir == IN) {
		pwrite(gpio->direction, "in", 2, 0);
	} else {
		pwrite(gpio->direction, "out", 3, 0);
	}
}

uint8_t GPIO_read(GPIO* gpio) {
	char buf;
	pread(gpio->value, &buf, 1, 0);
	return buf == '1';
}

void GPIO_write(GPIO* gpio, uint8_t val) {
	static const char vals[] = { '0', '1' };
	pwrite(gpio->value, &vals[val], 1, 0);
}

// Open a file, write the string to it, and close it. Don't use in performance-
// sensitive code!
int tryWrite(const char* path, const char* buf) {
	FILE* fd = fopen(path, "wb");
	if (!fd) {
		perror(path);
		return 0;
	}
	if (fprintf(fd, "%s", buf) < 0) {
		perror(path);
		fclose(fd);
		return 0;
	}
	if (fclose(fd) < 0) {
		perror(path);
		return 0;
	}
	return 1;
}

// Open the GPIO pin with the given pin identifier.
// On success, returns nonzero and initializes *gpio for use.
// On failure, outputs an error message, returns 0, and leaves *gpio in an
// unspecified but invalid state.
int GPIO_open(GPIO* gpio, const char* pin) {
	static char buf[BUFSIZE];

	if (!tryWrite("/sys/class/gpio/export", pin)) {
		return 0;
	}

	snprintf(buf, BUFSIZE, "/sys/class/gpio/gpio%s/direction", pin);
	gpio->direction = open(buf, O_WRONLY);
	if (gpio->direction < 0) {
		perror(buf);
		return 0;
	}
	snprintf(buf, BUFSIZE, "/sys/class/gpio/gpio%s/value", pin);
	gpio->value = open(buf, O_RDWR);
	if (gpio->value < 0) {
		perror(buf);
		close(gpio->direction);
		return 0;
	}
	gpio->pin = pin;
	return 1;
}

// Shut down a GPIO handle.
int GPIO_close(GPIO* gpio) {
	int errors = 0;
	if (close(gpio->direction) < 0) {
		perror("Closing GPIO direction channel");
		++errors;
	}
	if (close(gpio->value) < 0) {
		perror("Closing GPIO value channel");
		++errors;
	}
	gpio->value = gpio->direction = -1;

	if (!tryWrite("/sys/class/gpio/unexport", gpio->pin)) {
		perror("Unexporting GPIO");
		++errors;
	}
	gpio->pin = NULL;
	return !errors;
}

// Wait for the given GPIO to have the corresponding val.
// Waits for at most 255 cycles. Returns the number of cycles waited, or 0 if
// we exceed that limit.
int GPIO_wait(GPIO* gpio, uint8_t val) {
	for (uint8_t us = 0; us < 32; ++us) {
		if (GPIO_read(gpio) == val) return us;
	}
	return 0;
}

uint8_t DHT11_read_byte(GPIO* gpio) {
	uint8_t byte = 0;
	GPIO_wait(gpio, 0);
	for (int i = 0; i < 8; ++i) {
		// wait for end of lead-in
		GPIO_wait(gpio, 1);
		// measure size of payload
		unsigned int cycles = GPIO_wait(gpio, 0);
		// 4 cycles is a good cutoff for running on the CHIP compiled with -O0 -g
		// it's 1-2 for 0 and 5-6 for 1
		byte = (byte << 1) | (cycles >= 4);
	}
	return byte;
}

// The DHT11 uses a custom one-wire protocol.
// The host initiates a read by pulling the pin low for at least 18ms, then
// high for 20-40us, then lets it float.
// The guest responds by pulling it low for 80us, then high for 80us, then
// sending 40 bits of data.
// Each bit consists of 50us of lead-in where the line is pulled low, then
// a payload where it is pulled high for 27us (0) or 70us (1).
// When the transmission is complete it pulls it low for 50us and then pulls
// it high until the next transmission.
// If after attempting to initiate a read the connection remains high, something
// has gone wrong.
int readDHT11Frame(GPIO* gpio, float* temperature, float* humidity) {
	*temperature = 0.0f;
	*humidity = 0.0f;

	// send initial request to communicate: _18ms ^20us -float
	GPIO_direction(gpio, OUT);
	GPIO_write(gpio, 0);
	usleep(20*1000);
	GPIO_write(gpio, 1);
	usleep(20);
	GPIO_direction(gpio, IN);

	// The DHT11 is meant to hold it low for 80us, then high for 80us, before
	// sending the first bit. In practice if we look for this header we miss the
	// first bit -- maybe setting the direction to IN takes too long?
	// if (!GPIO_wait(gpio, 0)) return 0;  // should go to 0 ~immediately
	// if (!GPIO_wait(gpio, 1)) return 0; // then stay low for 80us
	// if (!GPIO_wait(gpio, 0)) return 0; // then stay high for 80us
	// once it goes back to 0 we're into the lead-in

	uint8_t humidity_h, humidity_l, temperature_h, temperature_l, check;
	humidity_h = DHT11_read_byte(gpio);
	humidity_l = DHT11_read_byte(gpio);
	temperature_h = DHT11_read_byte(gpio);
	temperature_l = DHT11_read_byte(gpio);
	check = DHT11_read_byte(gpio);

	if (check != ((humidity_h + humidity_l + temperature_h + temperature_l) & 0xFF)) {
		// checksum failure
		return 0;
	}

	*humidity = humidity_h + (humidity_l / 10.0);
	*temperature = temperature_h + (temperature_l / 10.0);
	// printf("DHT11 frame read complete: %d %d %d %d %d\n", humidity_h, humidity_l, temperature_h, temperature_l, check);
	if (humidity_h == 0 && temperature_h == 0) return 0; // if we get all zeroes, the checksum will pass but it was not a good read
	return 1;
}

int main(int argc, const char** argv) {
  if (argc < 2) {
    fprintf(stderr, "Usage: dht11-read <pin-id>\n");
    return 1;
  }

  const char* pin = argv[1];
  GPIO gpio;
  if (!GPIO_open(&gpio, pin)) return 2;

  float temperature, humidity;
  for (int i = 0; i < 16; ++i) {
  	// Retry a bunch of times until we successfully read from it.
  	if (readDHT11Frame(&gpio, &temperature, &humidity)) {
		  printf("temperature\t%f\n", temperature);
		  printf("humidity\t%f\n", humidity);
		  if (!GPIO_close(&gpio)) return 4;
		  return 0;
		}
		usleep(10000);
  }
	printf("Error reading from DHT11\n");

  if (!GPIO_close(&gpio)) return 4;
  return 8;
}
