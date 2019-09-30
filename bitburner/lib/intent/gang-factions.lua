-- Intents for corp factions, which require us to grind rep working for the corp first.

local log = require 'log'
local fc = require 'intent.faction-common'

-- appease ram checker
-- ns:joinFaction()
-- ns:workForCompany()

local function GangFaction(t)
  return t
end

local factions = table.List {
  GangFaction { name = "Slum Snakes"; combat = 30; karma = -9; };
  -- GangFaction { name = "Tetrads"; combat = 75; karma = -18; city = "Chongqing" };
  -- --GangFaction { name = "Silhouette"; money = 15e6; karma = -22; }; requires company creation
  -- GangFaction { name = "Speakers for the Dead"; combat = 300; hack = 100; kills = 30; karma = -45; };
  -- GangFaction { name = "The Dark Army"; combat = 300; hack = 300; city = "Chongqing"; kills = 5; karma = -45 };
  -- GangFaction { name = "The Syndicate"; combat = 300; hack = 300; city = "Sector-12"; money = 10e6; karma = -90 };
}

local function inGang()
  return pcall(function() return ns.gang:getGangInformation() end) == true
end

local function joinFaction(target)
  if fc.haveInvite(target.name) then
    return { activity = "joinFaction"; priority = target.priority; delay = 1; target.name }
  elseif fc.inFaction(target.name) then
    return nil
  end

  if target.combat and not fc.haveCombatLevel(target.combat) then
    return { activity = "GRIND_COMBAT", goal = "⚔"..target.combat }
  elseif target.hack and not fc.haveHackingLevel(target.hack) then
    return { activity = "GRIND_HACK", goal = 'ℍ'..target.hack }
  elseif target.money and not fc.haveMoney(target.money) then
    return { activity = "GRIND_MONEY", goal = '$'..target.money }
  end

  if target.city and ns:getCharacterInformation().city ~= target.city then
    ns:travelToCity(target.city)
  end

  -- TODO support kill tracking
  return { activity = "GRIND_KARMA"; goal = '🕱'..(target.kills or 0)..' ♆'..target.karma:abs() }
end

-- -54,000 is the threshold for creating a new gang outside BN2.
local function grindKarma()
  if ns:karma() > -54e3 and not inGang then
    return { activity = "GRIND_KARMA" }
  end
end

-- TODO once we meet some threshold amount of reputation/money, buy a bunch of
-- augs and reset
-- if we wait until we can get ALL of them, it'll be too long, since gang
-- factions have all the augs available
return function()
  local target = fc.chooseTarget(factions)
  if not target then
    return { activity = 'IDLE'; priority = -1; source = "BE GAY DO CRIMES" }
  end

  -- This needs a bunch of work. Outside BN2, we need -54k karma to form a gang.
  -- This is about 15 hours of grinding homicide, which I think is the fastest
  -- approach; and it's worth switching from mugging to homicide as soon as the
  -- success rate goes above 10% (!).
  -- Conversely, once we HAVE formed the gang, we don't need to grind crimes anymore,
  -- because the gang will grind things for us.
  local intent = joinFaction(target)
              or grindKarma()
              -- or fc.getFactionRep(target.name, target.reputation)
              -- or fc.getAugs(target.name)
              or { activity = 'IDLE'; priority = -1 }

  intent.priority = intent.priority or target.priority
  intent.source = intent.source or "gang faction: %s" % target.name
  return intent
end
