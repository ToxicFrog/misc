-- run me with:
-- rpc-test.lua 10
-- rpc-test.lua
-- the former will send 10 messages to the latter and then both will exit.

local rpc = require 'rpc'
local log = require 'log'

log.setlevel("DEBUG", "DEBUG")
rpc.init()

local n = tonumber((...))
if n then
  rpc.create("test", 1)
  rpc.publish("test", "hello")
  for i=1,n do
    rpc.send("test", tostring(i))
  end
else
  repeat
    local msg = rpc.recv("test", 5)
    log.info("received: %s", msg)
  until not msg
  log.info("status read: %s", rpc.read("test"))
end
log.info("shutting down")
