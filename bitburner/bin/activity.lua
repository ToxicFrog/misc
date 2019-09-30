--[[
Long-running activity manager.
Every SLEEP_TIME seconds, wakes up and tries to figure out what we should be
doing, by running a bunch of intent generators. Each of these returns either
nil or an intent structure of the form:
  { name = 'intent name'; activity = 'ns or handler function name'; priority = 0.0;
    args... }
E.g. { name = 'grind rep CyberSec'; activity = 'workForFaction'; priority = 1.0; 'CyberSec', 'hacking' }
If the highest priority intent does not match whatever we're currently doing,
it cancels the current activity and replaces it with the new one.
]]

-- appease ram checker
-- ns:workForCompany()
-- ns:joinFaction()
-- ns:createProgram()
-- ns:universityCourse()
-- ns:gymWorkout()
-- ns:installAgumentations()

local fc = require 'intent.faction-common'
local log = require 'log'
local sh = require 'shell'
local universityIntent = require 'intent.university'
local gymIntent = require 'intent.gym'

local intent_generators = table.List {
  require 'intent.write-program';
  require 'intent.hacker-factions';
  require 'intent.city-factions';
  require 'intent.plot-factions';
  require 'intent.corp-factions';
  require 'intent.gang-factions';
  require 'intent.escape';
}

local function jobGrinder(jobs)
  return function(self)
    for job=#jobs,1,-1 do
      local job_name = jobs[job].job
      for corp=#jobs[job],1,-1 do
        local corp = jobs[job][corp]
        ns:applyToCompany(corp, job_name)
        if fc.haveJobAt(corp) then
          return { activity = 'workForCompany', corp, priority=self.priority, source=self.source }
        end
      end
    end
    return jobs.fallback(self)
  end
end

local function manualHack(intent, host)
  sh.execute('netpath '..host)
  sh.execute('hack')
  ns:sleep(ns:getHackTime(host))
  sh.execute('home')
end

local function Crime(name, time_ms, money, karma, kills)
  return {
    name = name; time = time_ms/1000; money = money; karma = karma, kills = kills and 1 or 0;
    -- money_efficiency = money/(time_ms/1000);
    -- karma_efficiency = karma/(time_ms/1000);
  }
end

local crimes = {
  Crime("rob store", 60e3, 400e3, 0.5);
  Crime("shoplift", 2e3, 15e3, 0.1);
  Crime("larceny", 90e3, 800e3, 1.5);
  Crime("mug", 4e3, 36e3, 0.25);
  Crime("deal drugs", 10e3, 120e3, 0.5);
  Crime("Bond Forgery", 300e3-1, 4.5e6, 0.1); -- tie with homicide, but slower
  Crime("Traffick Arms", 40e3-1, 600e3, 1); -- tie with homicide, but slower
  Crime("homicide", 3e3, 45e3, 3, true);
  Crime("grand theft auto", 80e3, 1.6e6, 5);
  Crime("kidnap", 120e3, 3.6e6, 6);
  Crime("assassinate", 300e3, 12e6, 10, true); -- best one that generates kills
  Crime("heist", 600e3, 120e6, 15); -- best one outright
}

local function crimeGrinder(goal)
  return function(self)
    table.sort(crimes, function(x,y)
      if x[goal] ~= y[goal] then return x[goal]/x.time > y[goal]/y.time end
      return x.money/x.time > y.money/y.time
    end)
    for i,crime in ipairs(crimes) do
      if ns:getCrimeChance(crime.name:lower()) >= 1.0 then
        return { activity = 'commitCrime', crime.name,
          priority = self.priority, source = self.source, delay = 'UNTIL_IDLE' }
      end
    end
    return { activity = 'GRIND_COMBAT', priority = self.priority, source = self.source }
  end
end

-- When jobgrinding, we always prefer Blade, ECorp, or MegaCorp, because those have
-- the best payouts and give us augments, so grinding favour with them is worthwhile.
-- If we don't meet the prerequisites, we pick whatever gives the best XP.
-- TODO: if we have a high-priority jobgrind and a lower-priority activity that's
-- compatible with it, do the lowpri activity, e.g. given this:
-- 0.6 GRIND_HACK [prerequisite: NiteSec]
-- 0.2 workForFaction(chongquing)
-- it should prefer working for chongquing to grinding hack.
local intent_handlers = {
  GRIND_HACK = jobGrinder {
    { job='waiter', 'Noodle Bar' }; --re-enabled for BN2
    { job='software', 'Blade Industries', 'MegaCorp' };
    fallback = function(self) return universityIntent(self, 'hack') end
  };
  GRIND_COMBAT = jobGrinder {
    { job='waiter', 'Noodle Bar' }; --re-enabled for BN2
    -- { job='agent', 'Carmichael Security', 'Watchdog Security', 'NSA' };
    { job='agent', 'Carmichael Security', 'Watchdog Security', };  --re-enabled for BN2
    { job='security', 'Blade Industries', 'MegaCorp' };
    fallback = gymIntent;
  };
  GRIND_MONEY = jobGrinder {
    { job='waiter', 'Noodle Bar' }; --re-enabled for BN2
    { job='software', 'Rho Construction', 'LexoCorp', 'Universal Energy', 'Blade Industries', 'ECorp' }; --re-enabled for BN2
    { job='security', 'Blade Industries', 'MegaCorp' };
    { job='software', 'Blade Industries', 'ECorp' };
    fallback = function() return { activity = 'IDLE'; } end;
  };
  GRIND_MONEY = crimeGrinder("money");
  GRIND_KARMA = crimeGrinder("karma");
  GRIND_MURDER = crimeGrinder("kills");
  BUY_AUGS_AND_RESET = function(intent, faction) return fc.getAugs(faction) end;
  HACK_SERVER = manualHack;
  IDLE = function(self) return universityIntent(self, 'hack') end;
}

local SLEEP_TIME = 60

local current = ''
local function executeIntent(intent)
  local name = ("%s(%s)%s [%s]"):format(
    intent.activity, table.concat(intent, ", "),
      intent.goal and " -> "..intent.goal or "",
      intent.source or '???')
  -- printf("Activity: %s", name)
  if intent_handlers[intent.activity] then
    local next_intent = intent_handlers[intent.activity](intent, table.unpack(intent))
    if next_intent then
      next_intent.source = intent.source .. ' -> ' .. intent.activity
      next_intent.priority = intent.priority
      next_intent.goal = intent.goal
      return executeIntent(next_intent)
    end
  else
    if name ~= current then
      log.info("Activity: %s", name)
      current = name
    end
    ns[intent.activity](ns, table.unpack(intent))
  end
  return intent.delay
end

function main(...)
  log.setlevel('debug', 'info')
  while true do
    -- This ensures that faction/corp reputation levels are correctly updated
    -- based on the work we've been doing. Ideally we'd read workRepGain from
    -- the character sheet, but we have no way of knowing who we're working for;
    -- we know what our previous activity was, but that's not sufficient, because
    -- the player might have overridden it.
    if ns:isBusy() then ns:stopAction() end
    local intent =
      intent_generators:map(f'f => f()')
      :sort(f'x,y => x.priority < y.priority')
      :map(function(intent)
        log.debug("%2.6f %s(%s)  [%s]",
          intent.priority, intent.activity, table.concat(intent, ", "), intent.source or "???")
        return intent
      end)
      :remove()
    if intent then
      delay = executeIntent(intent) or SLEEP_TIME
      if delay == 'UNTIL_IDLE' then
        while ns:isBusy() do ns:sleep(0.1) end
      else
        ns:sleep(delay)
      end
    else
      log.warn('No generator produced an intent.')
      ns:sleep(SLEEP_TIME)
    end
  end
end

return main(...)
