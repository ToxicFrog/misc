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

local intent_generators = table.List {
  require 'intent.write-program';
  require 'intent.hacker-factions';
  require 'intent.city-factions';
  require 'intent.plot-factions';
  require 'intent.corp-factions';
  -- requir 'intent.gang';
}

local intent_handlers = {
  GRIND_HACK = function() end; -- TODO
  GRIND_COMBAT = function() end; -- TODO
  GRIND_MONEY = function() end; -- Assume SHODAN will get us money. May need to rewrite for other BNs.
  BUY_AUGS_AND_RESET = fc.getAugs;
  IDLE = function() end;
}

local SLEEP_TIME = 60

local current = ''
local function executeIntent(intent)
  local name = ("%s(%s)"):format(intent.activity, table.concat(intent, ", "))
  if name ~= current then
    printf("Activity: %s", name)
    current = name
  end
  if intent_handlers[intent.activity] then
    intent_handlers[intent.activity](table.unpack(intent))
  else
    ns[intent.activity](ns, table.unpack(intent))
  end
end

function main(...)
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
        printf("%2.6f %s(%s)  [%s]",
          intent.priority, intent.activity, table.concat(intent, ", "), intent.source or "???")
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
