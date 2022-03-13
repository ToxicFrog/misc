// Program for reading DHT11 temperature/humidity sensor data on the NTC CHIP.
// Uses sysfs for reading, so may sometimes fail due to timing issues. Recommend
// running with a very aggressive nice value to mitigate this.

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <sys/param.h>

// open(2)/close(2)
#include <fcntl.h>
// pread/pwrite
#define _XOPEN_SOURCE 500
#include <unistd.h>

#define BUFSIZE 256
#define MAX_EDGES 128

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


uint8_t read_bits(const uint8_t* edges, size_t start_at, int gap) {
	uint8_t byte = 0;
	for (int i = 0; i < 8; ++i) {
		byte <<= 1;
		byte |= (edges[start_at+i*2] < gap?0:1);
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
	// usleep(20);
	GPIO_direction(gpio, IN);

	uint8_t edges[MAX_EDGES];
	uint8_t last_seen = 0;
	uint8_t cycles = 0;
	uint8_t edge = 0;

	// Read in state changes from the pin.
	// We start by looking for a rising edge, and record the gaps between successive
	// edges.
	// So edges[0] will be how long before we saw the start of the first bit; edges[1]
	// will be the length of the transmission for that bit; edges[2] will be the gap
	// between the first two bits, edges[3] the length of the second bit; etc.
	while(edge < MAX_EDGES && cycles < 255) {
		cycles = 0;
		uint8_t this;
		while ((this = GPIO_read(gpio)) == last_seen && cycles < 255) { ++cycles; }
		last_seen = this;
		edges[edge++] = cycles;
	}
	--edge;

	// fprintf(stderr, "Edges:");
	// for (int i = 0; i < edge; ++i) {
	// 	fprintf(stderr, " %d", edges[i]);
	// }
	// fprintf(stderr, "\n");

	// Now we have all the edges. Ideally, we should have recorded 83 edges -- 2
	// edges for the initial ACK pulse, 2 edges for each bit, and a final edge as
	// the line returns to high idle.
	// If we're missing the ack (81 edges) that's fine. We can even be missing the
	// first bit (79-80) and compensate, because the first bit of the humidity
	// will always be 0, since humidity can't exceed 100. If we're missing more
	// than that we have to give up.
	uint8_t start_at;
	if (edge < 79) {
		fprintf(stderr, "Not enough edges from sensor: got %d, needed at least 79\n", edge);
		return 0;
	} else if (edge < 81) {
		fprintf(stderr, "Not enough edges from sensor: got %d, needed at least 79\n", edge);
		return 0;
		// insert a synthetic 0 bit at the start
		memmove(&edges[2], &edges[0], edge*sizeof(uint8_t));
		edges[0] = edges[2];
		edges[1] = 1;
		start_at = 1;
	} else {
		start_at = edge - 80;
	}

	// Figure out how wide the breaks between each bit is. Skip the first break
	// because it might be super long.
	int max_gap = 0;
	int min_gap = 255;
	for (int i = 1; i < 40; ++i) {
		max_gap = MAX(max_gap, edges[start_at-1+2*i]);
		min_gap = MIN(min_gap, edges[start_at-1+2*i]);
		// fprintf(stderr, "gap: %d [%d - %d]\n", edges[start_at-1+2*i], min_gap, max_gap);
	}
	int nominal_gap = (max_gap+min_gap)/2;
	// fprintf(stderr, "Gap width inferred: %d\n", nominal_gap);

	uint8_t humidity_h, humidity_l, temperature_h, temperature_l, check;
	humidity_h = read_bits(edges, start_at, nominal_gap);
	humidity_l = read_bits(edges, start_at+16, nominal_gap);
	temperature_h = read_bits(edges, start_at+32, nominal_gap);
	temperature_l = read_bits(edges, start_at+48, nominal_gap);
	check = read_bits(edges, start_at+64, nominal_gap);

	// fprintf(stderr, "DHT11 read complete: %d %d %d %d %d\n", humidity_h, humidity_l, temperature_h, temperature_l, check);

	if (check != ((humidity_h + humidity_l + temperature_h + temperature_l) & 0xFF)) {
		fprintf(stderr, "Checksum failure.\n");
		return 0;
	}

	*humidity = humidity_h + (humidity_l / 10.0);
	*temperature = temperature_h + (temperature_l / 10.0);

	if (humidity_h == 0 && temperature_h == 0) {
		fprintf(stderr, "Got all zeroes from sensor.\n");
		return 0;
	}
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
  // for (int i = 0; i < 16; ++i) {
  	// Retry a bunch of times until we successfully read from it.
  	if (readDHT11Frame(&gpio, &temperature, &humidity)) {
		  printf("temperature\t%f\n", temperature);
		  printf("humidity\t%f\n", humidity);
		  if (!GPIO_close(&gpio)) return 4;
		  return 0;
		}
		// usleep(10000);
  // }
	// fprintf("Error reading from DHT11.\n");

  if (!GPIO_close(&gpio)) return 4;
  return 8;
}
