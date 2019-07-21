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

local fc = require 'intent.faction-common'
local log = require 'log'

local intent_generators = {
  require 'intent.write-program';
  require 'intent.hacker-factions';
  require 'intent.city-factions';
  -- requir 'intent.gang';
  -- requir 'intent.corp';
}

local intent_handlers = {
  GRIND_HACK = function() end;
  GRIND_COMBAT = function() end;
  GRIND_MONEY = function() end; -- Assume SHODAN will get us money. May need to rewrite for other BNs.
  BUY_AUGS_AND_RESET = fc.getAugs;
}

local SLEEP_TIME = 60

local function executeIntent(intent)
  local name = ("%s(%s)"):format(intent.activity, table.concat(intent, ", "))
  -- if ns:isBusy() then ns:stopAction() end
  printf("Activity: %s", name)
  if intent_handlers[intent.activity] then
    -- intent_handlers[intent.activity]
  else
    -- ns[intent.activity](ns, unpack(intent))
  end
end

function main(...)
  while true do
    local intents = table.List {}
    -- This ensures that faction/corp reputation levels are correctly updated
    -- based on the work we've been doing. Ideally we'd read workRepGain from
    -- the character sheet, but we have no way of knowing who we're working for;
    -- we know what our previous activity was, but that's not sufficient, because
    -- the player might have overridden it.
    --if ns:isBusy() then ns:stopAction() end
    for _,generator in ipairs(intent_generators) do
      table.insert(intents, generator())
    end
    local intent = intents:sort(f'x,y => x.priority < y.priority')
      :map(function(intent)
        printf("%1.6f %s(%s)", intent.priority, intent.activity, table.concat(intent, ", "))
        return intent
      end)
      :remove()
    if intent then
      executeIntent(intent)
    else
      log.warn('No generator produced an intent.')
    end
    ns:sleep(SLEEP_TIME)
  end
end

return main(...)
