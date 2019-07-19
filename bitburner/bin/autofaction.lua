--[[
Basic algorithm:
- look at all the factions we could join
- get a list of augs for each of them
- get the rep cost of the most expensive PRI_NORMAL aug each one has that we don't have
- pick the cheapest faction based on this
- do whatever is needed to get the faction invite
- join the faction
- once joined:
  - if we have favour bit, pay the cost
  - otherwise, if the rep cost is <= 465k, grind up that much rep
  - otherwise, grind to 465k and break (we'll have favour after reset)
- buy all the augs that are PRI_NORMAL or PRI_LOW, in descending price order
- spend the rest of the money on NeuroFlux Governor
- reset
]]

local log = require 'log'
local factions = require 'factions'
local augs = require 'augs'
local w = require 'wait'

local function haveAug(target_aug)
  return ns:getOwnedAugmentations(true):includes(target_aug)
end

local function inFaction(target_faction)
  return ns:getCharacterInformation().factions:includes(target_faction)
end

local state = {}

-- Pick a faction to eat.
-- Currently picks the one with the lowest total reputation cost to get all
-- the augments we don't have.
function state.choose_target()
  log.info("Choosing a faction...")
  local target_name,target_rep = nil,math.huge
  for faction in pairs(factions) do
    local rep = 0
    for aug in js.of(ns:getAugmentationsFromFaction(faction)) do
      if augs[aug].priority > 0 and not haveAug(aug) then
        local cost = ns:getAugmentationCost(aug)
        rep = math.max(rep, cost[0])
      end
    end
    log.info("Faction %s has reputation cost %.0f", faction, rep)
    if rep > 0 and rep < target_rep then
      target_name,target_rep = faction,rep
    end
  end
  if not target_name then
    log.warn("Couldn't find any factions to eat!")
    return
  else
    log.info("Picked %s with %.0f required reputation.", target_name, target_rep)
    return state.join_faction(target_name, target_rep)
  end
end

-- Join the faction, getting an invite first if needed.
function state.join_faction(target, rep)
  if ns:getCharacterInformation().factions:includes(target) then
    log.info("Already in faction.")
    return state.assess(target, rep)
  elseif ns:checkFactionInvitations():includes(target) then
    log.info("Accepted pending faction invite.")
    ns:joinFaction(target)
    return state.assess(target, rep)
  else
    log.info("Getting invitation for faction.")
    factions[target].getInvite()
    ns:joinFaction(target)
    return state.assess(target, rep)
  end
end

-- Assess the state of the faction. Determine whether we need to grind rep up
-- to 'rep', or up to the favour point (and then reset), or whether we can just
-- donate for rep.
function state.assess(target, rep)
  if ns:getFactionRep(target) >= rep then
    log.info("Rep requirement already met.")
    return state.loot_augs(target, rep)
  elseif ns:getFactionFavor(target) >= ns:getFavorToDonate() then
    log.info("Favour requirement for donation met.")
    return state.donate_for_rep(target, rep)
  elseif rep > 465e3 then
    log.info("Faction has high rep requirements. Grinding for favour and then resetting.")
    return state.grind_rep(target, 465e3)
  else
    return state.grind_rep(target, rep)
  end
end

function state.grind_rep(target, rep)
  log.info("Grind %d reputation from %s", rep, target)
  ns:workForFaction(target, 'hacking')
  w.waitUntil(function()
    return ns:getCharacterInformation().workRepGain + ns:getFactionRep(target) >= rep
  end)
  return state.loot_augs(target, rep)
end

function state.donate_for_rep(target, rep)
  ns:workForFaction(target, 'hacking')
  w.waitUntil(function()
    local earned = ns:getCharacterInformation().workRepGain + ns:getFactionRep(target)
    local cost = (rep - earned) * 1e6 / ns:getCharacterInformation().mult.factionRep;
    log.info("Donating %s to %s for %.0f reputation", tomoney(cost), target, rep - earned)
    return w.haveMoney(cost)()
  end)
  local earned = ns:getCharacterInformation().workRepGain + ns:getFactionRep(target)
  local cost = (rep - earned) * 1e6 / ns:getCharacterInformation().mult.factionRep;
  ns:donateToFaction(target, cost)
  return state.loot_augs(target, rep)
end

local function buyAugmentation(faction, aug)
  if haveAug(aug) then return true end
  for prereq in js.of(ns:getAugmentationPrereq(aug)) do
    if not buyAugmentation(faction, prereq) then
      log.info("Couldn't buy prerequisite augmentation %s for %s", prereq, aug)
      return false
    end
  end
  local price = ns:getAugmentationCost(aug)[1]
  log.info("Buying %s from %s for %s", aug, faction, tomoney(price))
  w.waitUntil(w.haveMoney(price))
  return ns:purchaseAugmentation(faction, aug)
end

function state.loot_augs(target, rep)
  ns:stopAction()
  log.info("Buy all augs from %s", target)
  local faction_augs = js.totable(ns:getAugmentationsFromFaction(target))
  for i,aug in ipairs(faction_augs) do
    local cost = ns:getAugmentationCost(aug)
    faction_augs[i] = { name = aug, rep = cost[0], price = cost[1] }
  end
  table.sort(faction_augs, function(x,y) return x.price > y.price end)
  for _,aug in ipairs(faction_augs) do
    if aug.rep <= rep and augs[aug.name].priority >= 0 then
      buyAugmentation(target, aug.name)
    end
  end
  log.info("Done buying primary augs, spending the rest on NFGs.")
  while ns:getAugmentationCost("NeuroFlux Governor")[1] <= ns:getServerMoneyAvailable 'home' do
    log.info("Buying NeuroFlux Governor for %s", tomoney(ns:getAugmentationCost("NeuroFlux Governor")[1]))
    if not ns:purchaseAugmentation(target, "NeuroFlux Governor") then
      log.error("Failed to buy NeuroFlux Governor from %s, cost=%.0f rep=%.0f",
        target, ns:getAugmentationCost("NeuroFlux Governor")[1],
        ns:getAugmentationCost("NeuroFlux Governor")[0])
      break
    end
  end
  log.info("Sleeping before installing augmentations. This is your chance to bail.")
  -- write out logs for later debugging
  ns:rm("/run/autofaction.log.txt")
  for line in js.of(ns:getScriptLogs()) do
    ns:write("/run/autofaction.log.txt", line.."\n")
  end
  ns:sleep(60)
  ns:installAugmentations("/bin/init.ns")
end

log.setlevel('debug', 'debug')
return state.choose_target()
