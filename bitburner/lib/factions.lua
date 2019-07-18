local sh = require 'shell'
local w = require 'wait'

local factions = {}

local function Faction(name)
  return function(init)
    factions[name] = init
  end
end

local function manualHack(server, faction)
  sh.execute('netpath '..server)
  while not w.haveInvite(faction)() do
    sh.execute('hack')
    ns:sleep(5)
  end
  sh.execute('home')
end

local function Hackers(name, server)
  return Faction(name) {
    getInvite = function()
      w.waitUntil(w.canHack(server))
      ns:stopAction()
      manualHack(server, name)
    end;
  }
end

local function City(name, money)
  return Faction(name) {
    getInvite = function()
      w.waitUntil(w.haveMoney(money))
      ns:travelToCity(name)
      w.waitUntil(w.haveInvite(name))
    end;
  }
end

Hackers('CyberSec', 'CSEC')
Hackers('NiteSec', 'avmnite-02h')
Hackers('The Black Hand', 'I.I.I.I')
Hackers('BitRunners', 'run4theh111z')

City('Sector-12', 15e6)
City('Chongqing', 20e6)
City('New Tokyo', 20e6)
City('Ishima', 30e6)
City('Aevum', 40e6)
City('Volhaven', 50e6)

Faction 'Tian Di Hui' {
  getInvite = function()
    w.waitUntil(w.allOf(w.haveMoney(1e6), w.haveHackingLevel(50)))
    local city = ns:getCharacterInformation().city
    if city ~= 'Chongqing' and city ~= 'New Tokyo' and city ~= 'Ishima' then
      ns:travelToCity('Chongqing')
    end
    w.waitUntil(w.haveInvite('Tian Di Hui'))
  end;
}

Faction 'Daedalus' {
  -- FIXME: we should have something here to indicate that the faction is not
  -- joinable until we have 30 augs, so that we don't even attempt to join it
  -- until we hit that point.
  -- In practice it should be ok because the 2.5M reputation requirement for
  -- The Red Pill will keep it lower priority than all the other factions.
  getInvite = function()
    w.waitUntil(w.haveHackingLevel(2500))
    w.waitUntil(w.haveInvite('Daedalus'))
  end;
}

-- Faction 'Netburners' {
--   getInvite = function()
--     -- Our autohacknet script should gradually buy hacknet nodes until we reach
--     -- the point where this happens.
--     w.waitUntil(w.haveInvite('Netburners'))
--   end
-- }

return factions
