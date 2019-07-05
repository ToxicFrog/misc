

local wrap,yield = coroutine.wrap,coroutine.yield

local sieve = { [2] = true; [3] = true; max = 3; }

local isPrime
local function primes(max)
  return wrap(function()
    yield(2)
    for n=3,max do
      if isPrime(n) then
        sieve[n] = true
        sieve.max = math.max(sieve.max, n)
        yield(n)
      end
    end
  end)
end

function isPrime(n)
  if n <= sieve.max then
    return sieve[n] or false
  end

  for p in primes(n^0.5) do
    if n % p == 0 then return false end
  end
  return true
end

local function biggest_factor(n)
  local factor = 0
  while not isPrime(n) do
    for p in primes(n^0.5) do
      if n % p == 0 then
        factor = math.max(factor, p)
        n = n/p
        break
      end
    end
  end
  return math.max(n, factor)
end

return biggest_factor
