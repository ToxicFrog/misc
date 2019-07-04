local SHODAN_NAME = "/bin/shodan.L.ns"

-- Print all active SPU processes and what they're working on.
function cmd_spus()
  printf("Not implemented yet.")
end

-- Print contents of last task allocation table and which tasks are being worked on.
function cmd_tasks()
  printf("Not implemented yet.")
end

-- Print information about all nodes SHODAN can schedule SPUs on.
function cmd_nodes()
  printf("Not implemented yet.")
end

-- Print information about all nodes SHODAN can target for hacks.
function cmd_targets()
  printf("Not implemented yet.")
end

function cmd_log()
  for line in js.of(ns:getScriptLogs(SHODAN_NAME)) do
    printf("%s", line)
  end
end

function cmd_stop()
  ns:kill(SHODAN_NAME, ns:getHostname())
  while ns:scriptRunning(SHODAN_NAME, ns:getHostname()) do ns:sleep(100) end
  printf("SHODAN stopped.");
end

function cmd_start()
  if ns:scriptRunning(SHODAN_NAME, ns.getHostname()) then
    printf("SHODAN already running.");
  else
    ns:run(SHODAN_NAME)
    printf("SHODAN starting.")
  end
end

function cmd_restart()
  cmd_stop()
  cmd_start()
end

function cmd_help()
  local cmds = {}
  for k in pairs(_ENV) do
    if k:match("^cmd_") then table.insert(cmds, (k:gsub("^cmd_",""))) end
  end
  table.sort(cmds)

  printf("Usage: shodan (%s)", table.concat(cmds, "|"))
end

--[[
function cmd_spus() {
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

function cmd_tasks() {
  let tasks = rpc.readStatus("shodan.ns").tasks;
  tprintf("%18.18s | %9s | %6s | %9s | %18s",
    "hostname", " weaken  ", " hack ", "  grow   ", "   target money   ");
  tprintf("-".repeat(18 + 3 + 9 + 3 + 6 + 3 + 9 + 3 + 18 + 1));
  for (let task of tasks) {
    tprintf("%18.18s | %4d/%-4d | %4d/%-1d | %4d/%-4d | %18s$",
      task.host, task.pending_weaken, task.weaken,
      task.pending_hack, task.hack,
      task.pending_grow, task.grow,
      task.target_money.toLocaleString(undefined, {maximumFractionDigits:0}));
      // ns.getServerMoneyAvailable(task.host).toLocaleString(undefined, {maximumFractionDigits:0}));
  }
}

]]
