-- Intents for plot/endgame factions.

-- appease ram checker
-- ns:joinFaction()

local log = require 'log'
local fc = require 'intent.faction-common'

local factions = table.List {
  -- TODO take into account how long it'll take to grind up these stats based on
  -- character multipliers and stuff
  { name = "The Covenant"; augs = 20; money = 75e9; hack = 850; combat = 850; };
  { name = "Daedalus"; augs = 30; money = 100e9; hack = 2500; combat = 0; };
  { name = "Illuminati"; augs = 30; money = 150e9; hack = 1500; combat = 1200; };
  -- This gets stuffed into plot factions because it shares most of its code with
  -- them, even though it isn't really plot related.
  -- { name = "Netburners"; augs = 0; money = 0; hack = 80; combat = 0; };
}

local function joinFaction(target)
  if fc.haveInvite(target.name) then
    return { activity = "joinFaction"; priority = target.priority; delay = 1; target.name }
  elseif fc.inFaction(target.name) then
    return nil
  end

  if not fc.haveCombatLevel(target.combat) then
    return { activity = "GRIND_COMBAT", goal = "⚔"..target.combat }
  elseif not fc.haveHackingLevel(target.hack) then
    return { activity = "GRIND_HACK", goal = 'ℍ'..target.hack }
  elseif not fc.haveMoney(target.money) then
    return { activity = "GRIND_MONEY", goal = '$'..target.money }
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
