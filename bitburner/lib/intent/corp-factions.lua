-- Intents for corp factions, which require us to grind rep working for the corp first.

local log = require 'log'
local fc = require 'intent.faction-common'

-- appease ram checker
-- ns:joinFaction()
-- ns:workForCompany()

local function CorpFaction(t)
  t.corp = t.corp or t.name
  -- "invite_rep" is the amount of reputation we have to have in the faction's
  -- corp before they let us in.
  -- it's doubled because we're not going to work 8-hour shifts, which means all
  -- corporate reputation gains are halved.
  t.invite_rep = ((t.invite_rep or 200e3) - ns:getCompanyRep(t.corp)):max(0) * 2.0
  t.job = t.job or "software"
  return t
end

local factions = table.List {
  CorpFaction { name = "Bachman & Associates"; };
  CorpFaction { name = "Blade Industries"; };
  CorpFaction { name = "Clarke Incorporated"; };
  CorpFaction { name = "ECorp"; };
  CorpFaction { name = "Four Sigma"; };
  CorpFaction { name = "Fulcrum Secret Technologies"; corp = "Fulcrum Technologies";
                invite_rep = 250e3; server = "fulcrumassets"; };
  CorpFaction { name = "KuaiGong International"; };
  CorpFaction { name = "MegaCorp"; };
  CorpFaction { name = "NWO"; };
  CorpFaction { name = "OmniTek Incorporated"; };
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
    return { activity = "joinFaction", delay = 1, target.name }
  end

  if fc.inFaction(target.name) then
    return nil
  elseif ns:getCompanyRep(target.corp) < target.invite_rep then
    -- We don't have enough reputation with the corresponding company to get an invite.
    ns:applyToCompany(target.corp, target.job)
    if fc.haveJobAt(target.corp) then
      return { activity = "workForCompany", target.corp }
    else
      return { activity = "GRIND_HACK" }
    end
  elseif target.server then
    -- We have enough reputation, but we haven't hacked the faction's server.
    if not canHack(target.server) then
      return { priority = 1/1e16; activity = "GRIND_HACK", goal = 'ℍ'..ns:getServerRequiredHackingLevel(target.server) }
    else
      return { activity = 'HACK_SERVER', delay = 1, target.server }
    end
  end
  -- We meet the requirements but don't have an invite yet. Go back to working I guess.
  return { activity = "workForCompany", target.corp }
end

return function()
  local target = fc.chooseTarget(factions)
  if not target then
    return { activity = 'IDLE'; priority = -1; source = "corp factions" }
  end

  local intent = joinFaction(target)
              or fc.getFactionRep(target.name, target.reputation)
              or fc.getAugs(target.name)
              or { activity = 'IDLE'; priority = -1 }

  intent.priority = intent.priority or target.priority
  intent.source = intent.source or "corp faction: %s" % target.name
  return intent
end
