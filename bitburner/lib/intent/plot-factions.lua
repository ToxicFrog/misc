-- Intents for plot/endgame factions.

local log = require 'log'
local fc = require 'intent.faction-common'

local factions = table.List {
  { name = "The Covenant"; augs = 20; money = 75e9; hack = 850; combat = 850; };
  { name = "Daedalus"; augs = 30; money = 100e9; hack = 2500; combat = 0; };
  { name = "Illuminati"; augs = 30; money = 150e9; hack = 1500; combat = 1200; };
  -- This gets stuffed into plot factions because it shares most of its code with
  -- them, even though it isn't really plot related.
  { name = "Netburners"; augs = 0; money = 0; hack = 80; combat = 0; };
}

local function joinFaction(target)
  if fc.haveInvite(target.name) then
    return { activity = "joinFaction"; priority = target.priority; target.name }
  elseif fc.inFaction(target.name) then
    return nil
  end

  if not fc.haveCombatLevel(target.combat) then
    return { activity = "GRIND_COMBAT"; priority = 0 }
  elseif not fc.haveHackingLevel(target.hack) then
    return { activity = "GRIND_HACK"; priority = 0 }
  elseif not fc.haveMoney(target.money) then
    return { activity = "GRIND_MONEY"; priority = 0 }
  end
  return { activity = "IDLE"; priority = -1; }
end

return function()
  local target = fc.chooseTarget(
    factions:filter(f'f => ns:getOwnedAugmentations().length >= f.augs'))
  if not target then return { activity = 'IDLE'; priority = -1; source = "plot factions" } end

  local intent = joinFaction(target)
              or fc.getFactionRep(target.name, target.reputation)
              or fc.getAugs(target.name)
              or { activity = 'IDLE'; priority = -1 }

  intent.priority = target.priority
  intent.source = intent.source or "plot factions"
  return intent
end