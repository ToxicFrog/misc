-- Intents for hacker factions: factions that require us to manually hack
-- a server to join them.

local log = require 'log'
local fc = require 'intent.faction-common'

local factions = {
  { name = 'CyberSec'; server = 'CSEC'; };
  { name = 'NiteSec'; server = 'avmnite-02h'; };
  { name = 'The Black Hand'; server = 'I.I.I.I'; };
  { name = 'BitRunners'; server = 'run4theh111z'; };
}

local function canHack(host)
  return ns:hasRootAccess(host)
     and ns:getServerRequiredHackingLevel(host) <= ns:getHackingLevel()
end

local function joinFaction(target)
  if fc.haveInvite(target.name) then
    return { activity = "joinFaction", target.name, delay = 1 }
  end

  if fc.inFaction(target.name) then
    return nil
  elseif not canHack(target.server) then
    return { activity = "GRIND_HACK"; goal = "ℍ"..ns:getServerRequiredHackingLevel(target.server) }
  else
    return { activity = 'HACK_SERVER'; delay = 1; target.server; }
  end
end

return function()
  local target = fc.chooseTarget(factions)
  if not target then
    return { activity = 'IDLE'; priority = -1; source = "hacker factions" }
  end

  local intent = joinFaction(target)
              or fc.getFactionRep(target.name, target.reputation)
              or fc.getAugs(target.name)
              or { activity = 'IDLE'; priority = -1 }

  intent.priority = intent.priority or target.priority
  intent.source = intent.source or "hacker faction: %s" % target.name
  return intent
end

