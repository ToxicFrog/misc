local log = require 'log'

-- Settings
-- A hacknet node needs to produce (cost of upgrade * this) before we'll buy the
-- next upgrade.
local HACKNET_COST_FACTOR = 0 --2
-- Time to wait between checks, seconds.
local TIME_BETWEEN_BUYS = 5.0

local function upgradeHacknet(budget, did_upgrade)
  log.debug("UpgradeHacknet(budget=%.0f)", budget)
  local nodes = {}
  for i=0,ns.hacknet:numNodes()-1 do
    local node = { id=i; cost = math.huge }

    for _,stat in ipairs { "Level", "Ram", "Core", "Cache" } do
      local cost = ns.hacknet["get"..stat.."UpgradeCost"](ns.hacknet, i, 1)
      if cost < node.cost then
        node.cost = cost
        node.upgrade = stat
      end
    end
    table.insert(nodes, node)
  end
  table.sort(nodes, f'x,y => x.cost < y.cost')
  local node = nodes[1]
  if node and node.upgrade and node.cost < budget then
    ns.hacknet["upgrade"..node.upgrade](ns.hacknet, node.id, 1)
    return upgradeHacknet(budget - node.cost)
  end
  return did_upgrade
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
  return true
end

local last_hashes = 0
local function spendHashes(budget)
  -- Figure out how many hashes we produced since last time we spent them, and
  -- how fast we're producing new hashes.
  local produced = ns.hacknet:numHashes() - last_hashes
  local rate = 0
  for i=0,ns.hacknet:numNodes()-1 do
    rate = rate + ns.hacknet:getNodeStats(i).production
  end
  log.info("spend hashes, prd=%.0f, rate=%.5f", produced, rate)
  -- Based on hash production rate, figure out how many we're willing to spend
  -- on money that can be folded back into the hacknet network.
  -- We want this to be 100% if we're producing less than one hash per second,
  -- gradually dropping off past that.
  local hash_budget = produced / math.log(math.max(2,rate), 2)
  log.info("hash_budget %f", hash_budget)
  while ns.hacknet:hashCost('Generate Coding Contract') < ns.hacknet:numHashes() do
    ns.hacknet:spendHashes('Generate Coding Contract')
    hash_budget = hash_budget - ns.hacknet:hashCost('Generate Coding Contract')
  end
  while ns.hacknet:hashCost('Sell for Money') < hash_budget do
    ns.hacknet:spendHashes('Sell for Money')
    hash_budget = hash_budget - ns.hacknet:hashCost('Sell for Money')
  end
  last_hashes = last_hashes:min(ns.hacknet:numHashes())
  return false
end

local BUYS = {
  {spendHashes, 1.0};
  {buyNewHacknet, 0.5};
  {upgradeHacknet, 0.1};
}

ns:disableLog "ALL"

while true do
  local money = ns:getServerMoneyAvailable 'home'
  for _,buy in ipairs(BUYS) do
    if buy[1](money * buy[2]) then break end
  end
  ns:sleep(TIME_BETWEEN_BUYS)
end
