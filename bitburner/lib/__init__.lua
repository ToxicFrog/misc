-- Lua runtime startup code.
-- Runs after libraries and ns are loaded, but before the main program is.

-- Set up wrappers around async functions to turn them into coroutine yields.
local function asyncToCoro(f)
  return function(...)
    return coroutine.yield(f(...))
  end
end
for _,name in ipairs { "sleep", "hack", "grow", "weaken", "run", "exec", "prompt", "wget" } do
  ns[name] = asyncToCoro(ns[name])
end

-- Make sleep take fractional seconds rather than millis.
local _sleep = ns.sleep
ns.sleep = function(self, time) return _sleep(self, time*1000) end

-- Add convenient table-to-generic-Object creator.
function js.Object(t)
  local obj = js.new(js.global.Object)
  for k,v in pairs(t) do
    obj[k] = v
  end
  return obj
end

-- Set up package searchers.
package.searchers = {
  package.searchers[1]; -- package.preload
  function(name)
    local file = "/lib/" .. name:gsub("%.", "/") .. ".lua.txt"
    if ns:fileExists(file) then
      return load(ns:read(file), "@"..file)
    else
      return "no file '"..file.."';"
    end
  end;
  -- remaining searchers for lua/C files on disk removed
}

-- Error handler. Called when an error is thrown inside lua, just before the
-- script terminates.
-- It'll be called with the erroring thread as the first argument and the error
-- message as the second.
-- User code can replace this, but note that in order for Bitburner error
-- windows to work properly:
-- (1) the original error message should be included at the *front*
-- (2) whatever you append to it should not include the | character
aterror = debug.traceback

-- Override print() to do something useful, and define printf()
function print(...)
  return ns:tprint(table.concat({...}, " "))
end
function printf(fmt, ...)
  return print(fmt:format(...))
end

