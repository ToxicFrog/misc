-- Lua runtime startup code.
-- Runs after libraries and ns are loaded, but before the main program is.

-- Use strict
setmetatable(_ENV, {__index = function(self, key)
  error("Attempt to read undeclared global: "..tostring(key), 2)
end})

require 'util.ns'
require 'util.js'
require 'util.math'
require 'util.string'
require 'util.misc'
require 'util.table'
require 'util.ui-wrappers'

-- Error handler. Called when an error is thrown inside lua, just before the
-- script terminates.
-- It'll be called with the erroring thread as the first argument and the error
-- message as the second.
-- User code can replace this, but note that in order for Bitburner error
-- windows to work properly:
-- (1) the original error message should be included at the *front*
-- (2) whatever you append to it should not include the | character
aterror = debug.traceback

-- Exit handler. Called when ns:exit() is called, or just after the top level
-- returns.
-- In case of error this is NOT called, as (depending on where the error occurred)
-- it may not be safe to do so, e.g. the lua VM may be inconsistent.
-- Error handlers can call atexit() manually if they want to take that chance.
atexit = function() end

-- Watchdog timer handler. Called when a script executes for too long without
-- yielding.
-- A watchdog handler can do one of three things:
--  * Return a string. This will raise an error containing that string.
--  * Return nothing or nil. Execution continues as normal.
--  * Return a JS Promise. The script will be suspended until the promise is
--    resolved, then resume from the point where the watchdog timer fired.
--    THIS IS NOT SAFE TO USE IN SCRIPTS THAT MAKE USE OF COROUTINES.
-- If the script does anything else, an error will be raised.
atwatchdog = function(thread)
  -- return ns:_sleep(1000)
  return debug.traceback(thread, "watchdog timer fired")
end

-- Set up package searchers.
package.searchers = {
  package.searchers[1]; -- package.preload
  function(name)
    local file = "/lib/" .. name:gsub("%.", "/") .. ".lua.txt"
    error("Attempt to perform runtime load of %s", file)
    -- Currently disabled due to RAM cost of fileExists and read
    -- if ns_fileExists(file) then
    --   ns:tprint("Warning: performing runtime load of "..file)
    --   return load(ns_read(file), "@"..file)
    -- else
    --   return "no file '"..file.."';"
    -- end
  end;
  -- remaining searchers for lua/C files on disk removed
}
