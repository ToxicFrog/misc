-- Library for interacting with CCTs (coding contracts).

local log = require 'log'

local solvers = {
  ["Find Largest Prime Factor"] = require 'cct.prime-factors';
  ["Subarray with Maximum Sum"] = require 'cct.subarray-sum';
  ["Total Ways to Sum"] = nil;
  ["Spiralize Matrix"] = require 'cct.spiralize-matrix';
  ["Array Jumping Game"] = nil;
  ["Merge Overlapping Intervals"] = require 'cct.interval-merge';
  ["Generate IP Addresses"] = require 'cct.ip-addresses';
  ["Algorithmic Stock Trader I"] = nil;
  ["Algorithmic Stock Trader II"] = nil;
  ["Algorithmic Stock Trader III"] = nil;
  ["Algorithmic Stock Trader IV"] = nil;
  ["Minimum Path Sum in a Triangle"] = require 'cct.triangle-paths';
  ["Unique Paths in a Grid I"] = require 'cct.unique-paths-1';
  ["Unique Paths in a Grid II"] = require 'cct.unique-paths-2';
  ["Sanitize Parentheses in Expression"] = nil;
  ["Find All Valid Math Expressions"] = require 'cct.valid-expressions';
}

local cct = {}

function cct.solve(host, path)
  local t = ns.codingcontract:getContractType(path, host)
  local solver = solvers[t]
  if not solver then
    log.info("Can't solve %s:%s, no solver for '%s'", host, path, t)
  elseif ns.codingcontract:getNumTriesRemaining(path, host) <= 3 then
    log.info("Skipping %s:%s, not enough tries left.", host, path)
  else
    log.info("Attempting to solve %s:%s using solver for '%s'", host, path, t)
    -- local opts = js.Object { returnReward = true }
    local opts = js.new(js.global.Object)
    opts.returnReward = true
    local answer = solver(ns.codingcontract:getData(path, host))
    log.info("Solver returned answer: %s", js.global.JSON:stringify(answer))
    local reward = ns.codingcontract:attempt(answer, path, host, opts)
    if reward ~= "" then
      log.info("Solved %s:%s: %s", host, path, reward)
      printf("Solved %s:%s: %s", host, path, reward)
    else
      log.info("Failed to solve %s:%s", host, path)
      printf("Failed to solve %s:%s", host, path)
    end
  end
end

return cct
