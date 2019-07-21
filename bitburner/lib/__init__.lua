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
-- This is invoked from a JS debug hook, and as soon as it returns the hook
-- will yield via ns:sleep(); the only way to avoid this is by not returning,
-- e.g. by calling ns:exit() or by throwing.
-- The watchdog handler should return the number of seconds to sleep. If it
-- returns nil, 1 will be assumed. Numbers <1 will be clamped at 1.
atwatchdog = function()
  error 'Watchdog timer fired.'
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
