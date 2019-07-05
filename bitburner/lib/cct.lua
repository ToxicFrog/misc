-- Library for interacting with CCTs (coding contracts).

local solvers = {
  ["Find Largest Prime Factor"] = require 'cct.prime-factors';
  ["Subarray with Maximum Sum "] = nil;
  ["Total Ways to Sum"] = nil;
  ["Spiralize Matrix"] = nil;
  ["Array Jumping Game"] = nil;
  ["Merge Overlapping Intervals"] = nil;
  ["Generate IP Addresses"] = nil;
  ["Algorithmic Stock Trader I"] = nil;
  ["Algorithmic Stock Trader II"] = nil;
  ["Algorithmic Stock Trader III"] = nil;
  ["Algorithmic Stock Trader IV"] = nil;
  ["Minimum Path Sum in a Triangle"] = require 'cct.triangle-paths';
  ["Unique Paths in a Grid I"] = nil;
  ["Unique Paths in a Grid II"] = nil;
  ["Sanitize Parentheses in Expression"] = nil;
  ["Find All Valid Math Expressions"] = require 'cct.valid-expressions';
}

local cct = {}

function cct.solve(host, path)
  local t = ns.codingcontract:getContractType(path, host)
  local solver = solvers[t]
  if not solver then
    printf("Can't solve %s:%s, no solver for '%s'", host, path, t)
  elseif ns.codingcontract:getNumTriesRemaining(path, host) <= 3 then
    printf("Skipping %s:%s, not enough tries left.", host, path)
  else
    printf("Attempting to solve %s:%s using solver for '%s'", host, path, t)
    -- local opts = js.Object { returnReward = true }
    local opts = js.new(js.global.Object)
    opts.returnReward = true
    local answer = solver(ns.codingcontract:getData(path, host))
    printf("Solver returned answer: %s", js.global.JSON:stringify(answer))
    local reward = ns.codingcontract:attempt(answer, path, host, opts)
    if reward ~= "" then
      printf("Solved %s:%s: %s", host, path, reward)
    else
      printf("Failed to solve %s:%s", host, path)
    end
  end
end

return cct
