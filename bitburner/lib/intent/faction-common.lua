local augs = require 'augs'

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

-- This is meant to be used as part of a table.filter() on a list of faction
-- structs. The only requirement is that each faction have a 'name' field.
-- For factions that are not valid targets, it returns false.
-- For ones that are, it annotates them with 'reputation' and 'priority' fields
-- and returns true.
local function prioritize(faction)
  local rep = 0
  local pri = 0
  for aug in js.of(ns:getAugmentationsFromFaction(faction.name)) do
    if augs[aug].priority > 0 and not fc.haveAug(aug) then
      local cost = ns:getAugmentationCost(aug)
      rep = rep:max(cost[0])
      pri = pri + augs[aug].priority
      rep = math.max(rep, cost[0])
    end
  end
  if rep > 0 then
    faction.reputation = rep
    faction.priority = pri/rep
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

function fc.getFactionRep(faction, target)
  if ns:getFactionRep(faction) >= target then
    -- Requirement already met
    return nil
  elseif ns:getFactionFavor(faction) >= ns:getFavorToDonate() then
    -- Donate for reputation
    return fc.donateForReputation(faction, target)
  elseif ns:getFactionFavor(faction) + ns:getFactionFavorGain(faction) >= ns:getFavorToDonate() then
    -- We'll have enough favor to donate if we reset.
    -- FIXME priorities here are wrong
    return { activity = 'BUY_AUGS_AND_RESET'; priority = 1; faction }
  else
    return { activity = 'workForFaction'; priority = 1; faction, 'hacking' }
  end
end

function fc.donateForReputation(faction, target)
  local earned = ns:getFactionRep(target)
  local cost = (rep - earned) * 1e6 / ns:getCharacterInformation().mult.factionRep;

  if fc.haveMoney(cost) then
    ns:donateToFaction(faction, cost)
    return nil
  else
    return { activity = 'workForFaction', faction, 'hacking' }
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
  local cost = ns:getAugmentationCost(aug)[1]
  if fc.haveMoney(cost) then
    log.info("Buying %s from %s for %s", aug, faction, tomoney(cost))
    ns:purchaseAugmentation(faction, aug)
  else
    return { activity = 'GRIND_MONEY'; }
  end
end

function fc.getAugs(faction)
  local intent = js.toList(ns:getAugmentationsFromFaction(faction))
    :map(function(aug)
      local cost = ns:getAugmentationCost(aug)
      return { name = aug, rep = cost[0], cost = cost[1] }
    end)
    :sort(f'x,y => x.cost > y.cost')
    :some(partial(buyAugmentation, faction))
  if intent then
    -- We couldn't buy one of the augmentations and it returned an intent to
    -- satisfy the prerequisites
    return intent
  end

  -- We bought all the 'real' augs. Spend the rest on NFGs.
  while fc.haveMoney(ns:getAugmentationCost("NeuroFlux Governor")[1]) do
    log.info("Buying NeuroFlux Governor for %s", tomoney(ns:getAugmentationCost("NeuroFlux Governor")[1]))
    if not ns:purchaseAugmentation(target, "NeuroFlux Governor") then
      break
    end
  end
  log.info("Sleeping before installing augmentations. This is your chance to bail.")
  ns:sleep(60)
  ns:installAugmentations("/bin/init.ns")
end

return fc
