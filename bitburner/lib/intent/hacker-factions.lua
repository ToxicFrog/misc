-- Intents for hacker factions: factions that require us to manually hack
-- a server to join them.

local log = require 'log'
local sh = require 'shell'
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

local function manualHack(target)
  sh.execute('netpath '..target.server)
  while not fc.haveInvite(target.name) do
    sh.execute('hack')
    ns:sleep(5)
  end
  sh.execute('home')
end

local function joinFaction(target)
  if fc.haveInvite(target.name) then
      ns:joinFaction(target.name)
  end

  if fc.inFaction(target.name) then
    return nil
  elseif not canHack(target.server) then
    return { activity = "GRIND_HACK"; priority = target.priority }
  else
    manualHack(target)
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

