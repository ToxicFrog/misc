-- Set up wrappers around async functions to turn them into coroutine yields.
local function asyncToCoro(f)
  return function(...)
    return coroutine.yield(f(...))
  end
end
for _,name in ipairs { "sleep", "hack", "grow", "weaken", "prompt", "wget" } do
  ns['_'..name] = ns[name]
  ns[name] = asyncToCoro(ns[name])
end

-- Make sleep take fractional seconds rather than millis.
local _sleep = ns.sleep
ns.sleep = function(self, time) return _sleep(self, time*1000) end

-- Make exit call atexit() first
ns._exit = ns.exit
ns.exit = function(self) atexit(); return ns:_exit() end

-- Override print() to do something useful, and define printf() as a formatting
-- alias for ns:tprint().
function print(...)
  return ns:tprint(table.concat(table.List({...}):map(tostring), " "))
end
function printf(fmt, ...)
  return print(fmt:format(...))
end

function ns.karma()
  return ns.heart['break'](ns.heart)
end
