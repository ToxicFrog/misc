local augs = require 'augs'
local log = require 'log'

local fc = {}

-- appease ram checker
-- ns:workForFaction()

function fc.haveAug(target_aug)
  return ns:getOwnedAugmentations(true):includes(target_aug)
end

function fc.haveInvite(faction)
  return ns:checkFactionInvitations():includes(faction)
end

function fc.inFaction(faction)
  return ns:getCharacterInformation().factions:includes(faction)
end

function fc.haveMoney(money)
  return ns:getServerMoneyAvailable('home') >= money
end

function fc.haveHackingLevel(hack)
  return ns:getHackingLevel() >= hack
end

function fc.haveJobAt(corp)
  return ns:getCharacterInformation().jobs:includes(corp)
end

function fc.haveCombatLevel(combat)
  local stats = ns:getStats()
  return math.min(stats.strength, stats.defense, stats.dexterity, stats.agility) >= combat
end

-- This is meant to be used as part of a table.filter() on a list of faction
-- structs. The only requirement is that each faction have a 'name' field.
-- For factions that are not valid targets, it returns false.
-- For ones that are, it annotates them with 'reputation' and 'priority' fields
-- and returns true.
local function prioritize(faction)
  local rep = 0
  local pri = 0
  for aug in js.of(ns:getAugmentationsFromFaction(faction.name)) do
    assert(augs[aug], "faction "..faction.name.." has aug "..aug..", which I can't find in the aug table")
    if augs[aug].priority > 0 and not fc.haveAug(aug) then
      local cost = ns:getAugmentationCost(aug)
      rep = rep:max(cost[0])
      pri = pri + augs[aug].priority
      rep = math.max(rep, cost[0])
    end
  end
  if rep > 0 then
    rep_remaining = math.max(0.1, rep - ns:getFactionRep(faction.name))
                  / (1 + ns:getFactionFavor(faction.name)/100)
    faction.reputation = rep + (faction.invite_rep or 0)
    faction.priority = pri/rep_remaining
    return true
  else
    return false
  end
end

function fc.chooseTarget(factions)
  local targets = table.filter(factions, prioritize)
  table.sort(targets, f'x,y => x.priority < y.priority')
  return table.remove(targets)
end

function fc.getFactionRep(faction, rep, priority)
  if ns:getFactionRep(faction) >= rep then
    -- Requirement already met
    return nil
  elseif ns:getFactionFavor(faction) >= ns:getFavorToDonate() then
    -- Donate for reputation
    return fc.donateForReputation(faction, rep, priority)
  elseif ns:getFactionFavor(faction) + ns:getFactionFavorGain(faction) >= ns:getFavorToDonate() then
    -- We'll have enough favor to donate if we reset.
    return { activity = 'BUY_AUGS_AND_RESET'; faction }
  else
    return { activity = 'workForFaction'; goal = "ℝ"..rep, faction, 'hacking' }
  end
end

function fc.donateForReputation(faction, rep, priority)
  local earned = ns:getFactionRep(faction)
  local cost = (rep - earned) * 1e6 / ns:getCharacterInformation().mult.factionRep;

  -- printf("donateForReputation: target=%.0f, earned=%.0f, cost=%s",
  --   rep, earned, tomoney(cost))

  if fc.haveMoney(cost) then
    ns:donateToFaction(faction, cost)
    return nil
  else
    return { activity = 'workForFaction', goal = tomoney(cost), priority = priority, faction, 'hacking' }
  end
end

local function buyAugmentation(faction, aug)
  if fc.haveAug(aug) then return end
  for prereq in js.of(ns:getAugmentationPrereq(aug)) do
    local intent = buyAugmentation(faction, prereq)
    if intent then
      log.warn("Couldn't buy prerequisite augmentation %s for %s", prereq, aug)
      return intent
    end
  end
  local cost = ns:getAugmentationCost(aug)
  if ns:getFactionRep(faction) < cost[0] then
    -- aug is in the list but we don't have the rep to buy it.
    -- means it's a P0 aug with higher rep cost than any P1 aug and should be skipped.
    return
  elseif fc.haveMoney(cost[1]) then
    log.info("Buying %s from %s for %s", aug, faction, tomoney(cost[1]))
    ns:purchaseAugmentation(faction, aug)
  else
    log.debug("Grinding %s to buy %s from %s", tomoney(cost[1]), aug, faction)
    return { activity = 'GRIND_MONEY'; goal = tomoney(cost[1]) }
  end
end

-- TODO: assess augs in increasing order, multiplying total by 1.9 (the aug price increase
-- factor) for each one; stop once either
-- (a) we have all the augs
-- (b) we've run out of money but have at least MIN_AUGS_PER_RESET (8?) augs
function fc.getAugs(faction)
  local intent = js.toList(ns:getAugmentationsFromFaction(faction))
    :map(function(aug)
      local cost = ns:getAugmentationCost(aug)
      return { name = aug, rep = cost[0], cost = cost[1] }
    end)
    :sort(f'x,y => x.cost > y.cost')
    :map(f'x => x.name')
    :filter(function(name) return augs[name].priority >= 0 end)
    :some(partial(buyAugmentation, faction))
  if intent then
    -- We couldn't buy one of the augmentations and it returned an intent to
    -- satisfy the prerequisites
    -- intent.priority = self.priority
    -- intent.source = self.source
    return intent
  end

  -- We bought all the 'real' augs. Spend the rest on NFGs.
  while fc.haveMoney(ns:getAugmentationCost("NeuroFlux Governor")[1]) do
    log.info("Buying NeuroFlux Governor for %s", tomoney(ns:getAugmentationCost("NeuroFlux Governor")[1]))
    if not ns:purchaseAugmentation(faction, "NeuroFlux Governor") then
      break
    end
  end
  log.warn("Sleeping before installing augmentations. This is your chance to bail.")
  ns:sleep(60)
  ns:installAugmentations("/bin/init.ns")
end

return fc
