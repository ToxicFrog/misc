local log = require 'log'

-- Settings
-- Smallest server we can buy
local RAM_MIN = 4
-- Biggest server we can buy
local RAM_MAX = 2^20
-- A hacknet node needs to produce (cost of upgrade * this) before we'll buy the
-- next upgrade.
local HACKNET_COST_FACTOR = 2
-- Time to wait between checks, seconds.
local TIME_BETWEEN_BUYS = 5.0

local function sizeServerToMoney(budget)
  local ram = 1
  while ns:getPurchasedServerCost(ram*2) <= budget do
    ram = ram*2
  end
  return ram
end

local function buyNewServer(budget)
  log.debug("BuyNewServer(budget=%.0f)", budget)
  local nservers = ns:getPurchasedServers().length
  if nservers >= ns:getPurchasedServerLimit() then return false end

  local ram = sizeServerToMoney(budget)
  if ram < RAM_MIN then return false end

  local name = ("spu%.0f"):format(nservers)
  local cost = ns:getPurchasedServerCost(ram)

  log.info("Buying server %s (%.0fGB) for $%.0f", name, ram, cost)
  ns:purchaseServer(name, ram)
  return true
end

-- Array mapping hacknet index -> money at last upgrade.
-- Used to decide whether to buy a hacknet node upgrade.
local hacknets
local function scanHacknets()
  hacknets = {}
  for i=0,ns.hacknet:numNodes()-1 do
    hacknets[i] = ns.hacknet:getNodeStats(i).totalProduction
  end
end

local function upgradeHacknet(budget)
  log.debug("UpgradeHacknet(budget=%.0f)", budget)
  for i=0,ns.hacknet:numNodes()-1 do
    local production = ns.hacknet:getNodeStats(i).totalProduction - hacknets[i];

    for _,stat in ipairs { "Level", "Ram", "Core" } do
      local cost = ns.hacknet["get"..stat.."UpgradeCost"](ns.hacknet, i, 1)
      log.debug("  Checking %s: %.2f", stat, cost)
      if cost <= budget and cost * HACKNET_COST_FACTOR <= production then
        log.info("Upgrading %s on hacknet-node-%.0f for $%.0f", stat, i, cost)
        ns.hacknet["upgrade"..stat](ns.hacknet, i, 1)
        hacknets[i] = ns.hacknet:getNodeStats(i).totalProduction
        return true
      end
    end
  end

  return false
end

-- TODO: this should buy nodes based on how much money *all* nodes have made since
-- the last upgrade/node purchase.
local function buyNewHacknet(budget)
  -- Make it more reluctant to buy more nodes the more nodes we have.
  local nhacknets = ns.hacknet:numNodes()
  budget = budget / (1 + nhacknets)
  log.debug("BuyNewHacknet(budget=%.0f)", budget)
  local cost = ns.hacknet:getPurchaseNodeCost()
  if cost > budget then return false end
  log.info("Buying hacknet-node-%.0f for $%.0f", nhacknets, cost)
  ns.hacknet:purchaseNode()
  hacknets[nhacknets] = 0
end

local BUYS = {
  {buyNewServer, 0.1};
  -- no upgradeServer -- SHODAN handles that.
  {upgradeHacknet, 0.001};
  {buyNewHacknet, 0.001};
}

scanHacknets()
ns:disableLog "sleep"
ns:disableLog "getServerMoneyAvailable"

while true do
  local money = ns:getServerMoneyAvailable 'home'
  for _,buy in ipairs(BUYS) do
    if buy[1](money * buy[2]) then break end
  end
  ns:sleep(TIME_BETWEEN_BUYS)
end
