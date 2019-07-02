-- SHODAN processing unit.
-- This runs on a machine we have root on (but are not necessarily capable of hacking).
-- It is meant to be invoked as: spu.ns spu_name threads version
-- but in practice you shouldn't run it directly; it should be automatically
-- installed and launched by SHODAN.

local rpc = require 'rpc'

local name,threads,version = ...; threads = tonumber(threads)
local HEARTBEAT_CHANNEL = "shodan"
local TASK_CHANNEL = "SPU@"..name
local TIMEOUT = 60.0

local function mkHeartbeat(task)
  return { name = name, threads = threads, version = version, task = task }
end

-- Tasks have the format { command=foo, args={...} }
local function recvTask()
  local task = rpc.recv(TASK_CHANNEL, TIMEOUT)
  if task then
    log.info("Received task '%s(%s)' from SHODAN.", task.command, table.concat(task.args, " "))
  else
    log.debug("Timed out waiting for task, re-sending heartbeat.")
  end
  return task
end

local task_handlers = {
  hack = function(target) return ns:hack(target) end;
  grow = function(target) return ns:grow(target) end;
  weaken = function(target) return ns:weaken(target) end;
  exit = function()
    rpc.send(HEARTBEAT_CHANNEL, mkHeartbeat { command="exit", args={} })
    ns:exit()
  end;
}


ns:disableLog("sleep");
rpc.init()
rpc.create(TASK_CHANNEL);

local task = { command = "idle", args = {} }
while true do
  rpc.send(HEARTBEAT_CHANNEL, mkHeartbeat(task))
  task = recvTask();
  -- If it returns null, the controller didn't respond to us fast enough and we
  -- just send another heartbeat.
  -- TODO: there's an issue here where if the controller didn't respond not
  -- because it crashed, but because it's overloaded, we'll just end up pushing
  -- more heartbeats into the queue, overloading it even more and causing it to
  -- get duplicate heartbeats. Synchronous RPC would fix this...
  if task then
    local fn = task_handlers[task.command]
    if fn then
      fn(unpack(task.args))
    else
      log.error("Received task '%s', which I don't understand.", task.command)
    end
  end
}
