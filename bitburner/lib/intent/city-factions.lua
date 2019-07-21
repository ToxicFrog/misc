-- Intents for hacker factions: factions that require us to manually hack
-- a server to join them.

local log = require 'log'
local sh = require 'shell'
local fc = require 'intent.faction-common'

local TRAVEL_COST = 200e3

local factions = {
  { name = 'Sector-12', money = 15e6 };
  { name = 'Chongqing', money = 20e6 };
  { name = 'New Tokyo', money = 20e6 };
  { name = 'Ishima', money = 30e6 };
  { name = 'Aevum', money = 40e6 };
  { name = 'Volhaven', money = 50e6 };
  { name = 'Tian Di Hui', money = 1e6, hack = 50, city = 'Chongqing' };
}

local function joinFaction(target)
  if fc.haveInvite(target.name) then
      ns:joinFaction(target.name)
  end

  if fc.inFaction(target.name) then
    return nil
  elseif not fc.haveMoney(target.money + TRAVEL_COST) then
    return { activity = 'GRIND_MONEY'; priority = target.priority }
  elseif ns:getHackingLevel() < (target.hack or 0) then
    return { activity = 'GRIND_HACK'; priority = target.priority }
  else
    ns:travelToCity(target.city or target.name)
    repeat ns:sleep(5) until fc.haveInvite(target.name)
    return joinFaction(target)
  end
end

return function()
  local target = fc.chooseTarget(factions)
  if not target then return nil end

  local intent = joinFaction(target)
              or fc.getFactionRep(target.name, target.reputation)
              or fc.getAugs(target.name)

  if not intent then
    log.error('Targeting faction %s: no intent subgenerator returned an intent.', target.name)
  end
  intent.priority = target.priority
  return intent
end
