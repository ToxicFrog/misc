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
  local ram = RAM_MIN/2
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

local function upgradeServer(budget)
  log.debug("UpgradeServer(budget=%.0f)", budget)
  local servers = ns:getPurchasedServers()
  if servers.length < ns:getPurchasedServerLimit() then return false end

  local smallest = {ram=math.huge,host=nil}
  for host in js.of(servers) do
    local ram = ns:getServerRam(host)[0]
    if ram < smallest.ram then
      smallest = {ram=ram,host=host}
    end
  end

  local new_ram = sizeServerToMoney(budget)
  if new_ram <= smallest.ram then return false end
  local cost = ns:getPurchasedServerCost(new_ram);
  log.info("Upgrading %s (%dGB) to %dGB for %s",
    smallest.host, smallest.ram, new_ram, tomoney(cost));

  while ns:ps(smallest.host).length > 0 do
    ns:killall(smallest.host)
    ns:sleep(0.1)
  end

  if not ns:deleteServer(smallest.host) then
    log.error("Couldn't delete server %s, aborting upgrade.", smallest.host)
    return false
  end

  return ns:purchaseServer(smallest.host, new_ram) ~= ""
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
  {upgradeServer, 0.004};
  {upgradeHacknet, 0.001};
  {buyNewHacknet, 0.001};
}

scanHacknets()
ns:disableLog "ALL"

while true do
  local money = ns:getServerMoneyAvailable 'home'
  for _,buy in ipairs(BUYS) do
    if buy[1](money * buy[2]) then break end
  end
  ns:sleep(TIME_BETWEEN_BUYS)
end
