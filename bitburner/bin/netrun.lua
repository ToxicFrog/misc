-- Run a command on every reachable system.
-- Usage: netrun <command> <args...>
-- Supported commands: ls, kill, killall, rm, ps, run
-- n.b. does not run anything on home.

local net = require 'net'

local commands = {
  kill = function(host, script, ...) return ns:kill(script, host, ...) end;
  killall = function(host) return ns:killall(host) end;
  rm = function(host, file) return ns:rm(file, host) end;
  run = function(host, script, ...)
    return ns:exec(script, host, 1, ...)
  end;
  ls = function(host)
    for file in js.of(ns:ls(host)) do
      ns:tprint(file)
    end
  end;
  ps = function(host)
    for proc in js.of(ns:ps(host)) do
      printf("%s %s", proc.filename, proc.args:join(" "))
    end
  end;
}

local command = (...)
local argv = {select(2,...)}
if not commands[command] then
  printf("Unrecognized command: %s", command)
  return
end

local function runCommandOn(host, depth)
  if host == "home" then return true end
  printf("=== %s ===", host)
  commands[command](host, table.unpack(argv))
  return true
end

net.walk(runCommandOn, "home")
