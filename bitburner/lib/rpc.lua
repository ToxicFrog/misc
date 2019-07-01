-- Library for RPC and remote status handling.
-- All RPC uses port 20, which is configured to hold a single mutable object
-- containing all of the channel contents, as a map from channel name to
-- channel content.
-- The special channel 0 (the actual number 0, not "0") holds status publications.
-- Users must call rpc.init() to initialize the RPC port before making any RPC
-- calls.
-- Uses ns:peek() and ns:write(), and thus has 2GB memory footprint.

local log = require 'log'
local json = require 'json'

local RPC_PORT = 20
local RPCS = nil
local STATUS_CHANNEL = 0
local RPC_RETRY_TIME = 0.1 -- seconds between retries while blocking

local rpc = {}

-- Initialize the RPC library. Creates a new RPCS object if this is the first
-- time it's been called in this session; otherwise fetches the existing one
-- out of RPC_PORT.
-- Note that we use JS Objects and Arrays throughout here, as otherwise they
-- don't make it through the Netscript port intact. As far as Lua objects go
-- we can only send strings, numbers, and booleans.
-- TODO: use ser or bitser or luatexts or sth for serialization.
function rpc.init()
  if ns:peek(RPC_PORT) == "NULL PORT DATA" then
    RPCS = js.new(js.global.Object)
    RPCS[STATUS_CHANNEL] = js.new(js.global.Object)
    ns:write(RPC_PORT, RPCS)
  else
    RPCS = ns:peek(RPC_PORT)
  end
  log.info("RPC %s initialized using port %d", RPCS, RPC_PORT)
end

-- Create a new RPC channel with the specified size (0=unlimited).
-- This must be called before any attempt to send or recv on it is made.
-- If the channel already exists, it is cleared.
function rpc.create(name, size)
  size = size or 20
  log.info("Creating RPC channel %s (size=%d)", name, size)
  RPCS[name] = js.new(js.global.Array)
  RPCS[name].size = size
end

-- Send a message on the given channel. If the channel is full or missing,
-- blocks until it can write the message, or until timeout seconds have
-- elapsed; if timeout is set, it retries every 100ms.
-- Returns true if the message was sent, false if a timeout occurred.
function rpc.send(name, message, timeout)
  message = json.encode(message)
  timeout = timeout or math.huge
  log.debug("Sending (timeout=%f) %s <- %s", timeout, name, message)
  while timeout > 0 do
    local channel = RPCS[name]
    log.trace("channel=%s", channel)
    if channel and channel.length < channel.size then
      channel:push(message)
      log.trace("Message written.")
      return true
    end
    log.trace("Channel missing or full, retrying in %f seconds.", RPC_RETRY_TIME)
    ns:sleep(RPC_RETRY_TIME)
    timeout = timeout - RPC_RETRY_TIME
  end
  return false
end

-- Receive a message from the given channel. If the channel is empty or missing,
-- blocks until a message is available or until timeout seconds have elapsed.
-- Returns the message, or nil if a timeout occurred.
function rpc.recv(name, timeout)
  timeout = timeout or math.huge
  log.debug("Receiving <- %s (timeout=%f)", name, timeout)
  while timeout > 0 do
    local channel = RPCS[name]
    log.trace("channel=%s", channel)
    if channel and #channel > 0 then
      local message = json.decode(channel:shift())
      log.trace("Message received: %s", message)
      return message
    end
    log.trace("Channel missing or empty, retrying in %f seconds.", RPC_RETRY_TIME)
    ns:sleep(RPC_RETRY_TIME)
    timeout = timeout - RPC_RETRY_TIME
  end
end

-- Publish a status update.
-- This is written to a special RPC "channel" that is actually a map from
-- keys to statii.
-- Passing nil as the status deletes it from the status table entirely.
-- Unlike send-receive, there's no queueing and no blocking; writing a new status
-- overwrites the original, and once published a status can be read as many times
-- as desired.
-- There's also no attempt to enforce that one program can't overwrite another's
-- status, or to clean up statii on exit. Beware.
function rpc.publish(key, status)
  log.info("Publishing status %s <- %s", key, status)
  RPCS[STATUS_CHANNEL][key] = json.encode(status)
end

-- Read a status update from another program.
function rpc.read(key)
  return json.decode(RPCS[STATUS_CHANNEL][key])
end

-- Return an iterator over all (key,value) statuses.
function rpc.readAll()
  return coroutine.wrap(function()
    for k,v in pairs(RPCS[STATUS_CHANNEL]) do
      coroutine.yield(k, json.decode(v))
    end
  end)
end

return rpc
