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
  rpc.publish("test", {status="hello", n=n})
  for i=1,n do
    rpc.send("test", {index=i})
  end
else
  repeat
    local msg = rpc.recv("test", 5)
    log.info("received: index=%d", msg and msg.index or -1)
  until not msg
  log.info("status read: status=%s n=%d", rpc.read("test").status, rpc.read("test").n)
  for k,v in rpc.readAll() do
    log.info("status: k=%s v=%s", k, v)
  end
end
log.info("shutting down")
