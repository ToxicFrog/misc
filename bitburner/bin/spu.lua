-- SHODAN processing unit.
-- This runs on a machine we have root on (but are not necessarily capable of hacking).
-- Run as: /bin/spu.luaI.ns <operation> <target>
-- It will run <operation> on <target> and then exit.
-- It is kept deliberately very, very simple to minimize RAM footprint. SHODAN
-- is responsible for starting and stopping them.

local handlers = {
  hack = function(target) return ns:hack(target) end;
  grow = function(target) return ns:grow(target) end;
  weaken = function(target) return ns:weaken(target) end;
}

local op,target = ...

return handlers[op](target)
