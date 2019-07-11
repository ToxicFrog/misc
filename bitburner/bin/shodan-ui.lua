local SHODAN_NAME = "/bin/shodan.L.ns"

local cmd = {}

-- string... split(string, pattern. max) - break up string on pattern
-- default value for pattern is to split on whitespace
-- default value for max is infinity
function string.split(s, pat, max)
  pat = pat or "%s+"
  max = max or nil
  local count = 0
  local i = 1
  local result = { 1 }

  local function splitter(sof, eof)
    result[#result] = s:sub(result[#result], sof-1)
    result[#result+1] = eof
  end

  if pat == "" then return s end

  s:gsub("()"..pat.."()", splitter, max)

  result[#result] = s:sub(result[#result], #s)

  return table.unpack(result)
end

local function readTSV(file)
  local buf = ns:read(file)
  local lines = buf:gmatch("[^\n]+")
  local fields = {lines():split("\t")}
  local records = {}
  for line in lines do
    local record = {}
    for i,v in ipairs{line:split("\t")} do
      if tonumber(v) then
        record[fields[i]] = tonumber(v)
      elseif v == "nil" then
        record[fields[i]] = nil
      else
        record[fields[i]] = v
      end
    end
    table.insert(records, record)
  end
  return records
end

-- Print all active SPU processes and what they're working on.
function cmd.spus()
  printf("Not implemented yet.")
end

-- Print contents of last task allocation table and which tasks are being worked on.
function cmd.tasks()
  local tasks = readTSV("/run/shodan/tasks.txt")
  printf("<u>%6s  %-39s %9s</u>", "threads", "    command", "duration")
  for _,task in ipairs(tasks) do
    task.threads = tonumber(task.threads)
    task.time = tonumber(task.time)
    printf("%5d×  %6s %-32s  %8.3fs",
      task.threads,
      task.action,
      task.host,
      task.time)
  end
end

-- Print information about all nodes SHODAN can schedule SPUs on.
function cmd.nodes()
  local nodes = readTSV("/run/shodan/network.txt")
  local nrof_nodes,nrof_threads = 0,0
  table.sort(nodes, function(x,y) return x.max_threads < y.max_threads end)
  printf("<u>%8s  %s</u>", "Threads", "Host")
  for _,node in ipairs(nodes) do
    if node.max_threads > 0 then
      nrof_nodes = nrof_nodes + 1
      nrof_threads = nrof_threads + node.max_threads
      printf("%8d  %s", node.max_threads, node.host)
    end
  end
  printf("%d nodes (of %d scanned) with %d total threads available for SPUs.",
    nrof_nodes, #nodes, nrof_threads)
end

-- Print information about all nodes SHODAN can target for hacks.
function cmd.targets()
  printf("Not implemented yet.")
end

function cmd.log()
  for line in js.of(ns:getScriptLogs(SHODAN_NAME)) do
    printf("%s", line)
  end
end

function cmd.stop()
  ns:kill(SHODAN_NAME, ns:getHostname())
  while ns:scriptRunning(SHODAN_NAME, ns:getHostname()) do ns:sleep(100) end
  printf("SHODAN stopped.");
end

function cmd.start()
  if ns:scriptRunning(SHODAN_NAME, ns.getHostname()) then
    printf("SHODAN already running.");
  else
    ns:run(SHODAN_NAME)
    printf("SHODAN starting.")
  end
end

function cmd.restart()
  cmd.stop()
  cmd.start()
end

function cmd.help()
  local cmds = {}
  for k in pairs(cmd) do
    table.insert(cmds, k)
  end
  table.sort(cmds)

  printf("Usage: shodan (%s)", table.concat(cmds, "|"))
end

command = ...
if cmd[command] then
  cmd[command]()
else
  printf("Unknown command: %s", command)
  cmd.help()
end

--[[
function cmd.spus() {
  tprintf("%20.20s  %4s  %3s  %s",
    "hostname", "Thr", "Ver", "Task");
  let statii = rpc.readStatus();
  for (let name in statii) {
    if (!name.match("^spu.ns")) continue;
    let status = statii[name];
    let [host,shard] = status.host.split(":");
    if (!ns.serverExists(host)) continue;
    if (ns.isRunning("spu.ns", host, status.host, status.threads, status.version)) {
      tprintf("%20.20s  %4s  %3s  %s",
        status.host, status.threads, status.version, status.task ? status.task.join(" ") : "(idle)");
    }
  }
}
]]
