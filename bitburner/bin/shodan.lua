--[[
New SHODAN design.
Primary dataloop:
- map network including running tasks
- annotate map entries with:
  - desired tasks
  - tasks in progress (from the ps of other nodes)
  - priority level
- generate ordered task queue and unordered thread queue from network map
- assign tasks, keeping track of the one that's meant to finish soonest
- sleep until then + 1 second

To handle system upgrades:
- SHODAN needs to have its own copy of the "is this server ready for upgrade" logic,
  or the autoupgrader needs to have some way of marking a system as "ready for upgrade",
  either by writing a file on that system (which ls() will pick up) or by writing
  a file on home that SHODAN will find.
- when it is, it stops scheduling workers on that host by setting free_threads=0
- when the host is running nothing, the autoupgrader will upgrade it
]]

---- Immutable setting stuff ----

-- How much money we want to try to hack from a system each time we hack it.
local HACK_RATIO = 0.1
-- Server needs at least this much money before we even consider hacking it.
local MIN_MONEY_FOR_HACK = 2e6

-- SPU information.
local SPU_NAME = "/bin/spu.luaI.ns"
local SPU_RAM = ns:getScriptRam(SPU_NAME)
local SPU_FILES = { "/lib/lua.ns", SPU_NAME };

---- Mutable state ----

-- Map from hostname to how much money we want the host to have before we hack it.
-- Stored separately from the network map as the only inherently stateful part of
-- the whole thing, since we can't figure this out just by looking at each host.
local TARGET_MONEY = {}

---- Setup ----

local log = require 'log'
local net = require 'net'

for _,fn in ipairs {
    "sleep", "getServerRam", "getServerNumPortsRequired", "scan", "exec",
    "getServerSecurityLevel", "getServerMinSecurityLevel", "getServerMoneyAvailable",
    "getServerMaxMoney", "getServerRequiredHackingLevel", "getHackingLevel",
} do
  ns:disableLog(fn)
end

function main(...)
  log.setlevel("debug", "warn")
  while true do
    local network = analyzeNetwork(mapNetwork())
    local tasks = generateTasks(network)
    printf("Sleep time: %f", assignTasks(network, tasks))
    ns:sleep(10.0)
    break
  end
end

---- Network mapping and host analysis ----

-- Return a hostname => host_stat_t map with information about everything we
-- can reach on the network.
function mapNetwork()
  local network = {}
  local swarm_size = 0

  local function scanHost(host, depth)
    if host == "home" then return true end
    tryPwn(host)
    local info = net.stat(host)
    if not info.root then
      info.threads = 0
    else
      info.threads = math.floor((info.ram - info.ram_used)/SPU_RAM)
      swarm_size = swarm_size + math.floor(info.ram/SPU_RAM)
    end
    preTask(info)
    installSPU(info)
    network[host] = info
  end

  log.debug("Performing full network scan.");
  net.walk(scanHost, ns:getHostname())
  log.info("Network scan complete. %d threads available for SPUs.", swarm_size);
  return network,swarm_size
end

-- Appease the RAM checker
-- ns:brutessh() ns:ftpcrack() ns:relaysmtp() ns:httpworm() ns:sqlinject()
function tryPwn(host)
  if ns:hasRootAccess(host) then return end
  local ports = ns:getServerNumPortsRequired(host)
  for _,spike in ipairs { "brutessh", "ftpcrack", "relaysmtp", "httpworm", "sqlinject" } do
    if ns:fileExists(spike .. ".exe") then
      ns[spike](ns, host)
      ports = ports - 1
    end
  end
  if ports <= 0 then
    ns:nuke(host)
    log.info("Root access gained on %s", host)
  end
end

function isHackable(info)
  return info.root and info.max_money > 0 and info.hack_level <= ns:getHackingLevel()
end

-- Generate "pre-task" information about how much we want to weaken/hack/grow this
-- host and how much money we want it to have.
function preTask(info)
  local host = info.host
  if isHackable(info) then
    TARGET_MONEY[host] = TARGET_MONEY[host] or math.max(info.money, MIN_MONEY_FOR_HACK)
    info.weaken = math.ceil((info.security - info.min_security) / 0.05)
    if info.money > 0 then
      info.grow = math.ceil(math.max(0, ns:growthAnalyze(host, TARGET_MONEY[host]/info.money)))
    else
      -- If the target has no money, only generate a "probing" grow to generate
      -- *some* money so that growthAnalyze will work the next time.
      info.grow = 1
    end
    info.hack = info.money >= TARGET_MONEY[host] and math.ceil(HACK_RATIO/info.hack_fraction) or 0
    log.debug("%s T=%d WGH %f/%f/%f %s/%s",
      info.host, info.threads, info.weaken, info.grow, info.hack,
      tomoney(info.money), TARGET_MONEY[host])
  else
    TARGET_MONEY[host] = nil
  end
end

function installSPU(info)
  for _,file in ipairs(info.ls) do
    if file == SPU_NAME then return end
  end
  for _,file in ipairs(SPU_FILES) do
    ns:scp(file, info.host)
  end
  log.info("SPU software installed on %s", info.host)
end

-- Generate ancillary data about the network that requires analyzing the whole
-- network: the per-host priority and the pending tasks per target.
function analyzeNetwork(network, swarm_size)
  -- First calculate priority based on the *desired* weaken/grow/hack
  -- jobs in conjunction with the swarm size.
  for host,info in pairs(network) do
    if TARGET_MONEY[host] then
      info.priority = calcEfficiency(info, TARGET_MONEY[host], swarm_size)
      log.debug("Calculating priority for %s: %f", host, info.priority)
    end
  end

  -- Then calculate how much we're doing already, and thus, how much we actually
  -- want to do.
  for host,info in pairs(network) do
    for _,proc in ipairs(info.ps) do
      if proc.filename == SPU_NAME then
        local task,target = proc.args[0],proc.args[1]
        network[target][task] = math.max(0, network[target][task] - proc.threads)
      end
    end
  end

  return network
end

-- Attempt to determine the priority (i.e money-per-time) of focusing hacks
-- on this server.
-- This is based on:
-- - the per-hack money, based on the HACK_RATIO or the amount of money we'll hack
--   with one thread, whichever is more
-- - the time it takes to hack it
-- - the time it takes to execute all pending weaken tasks divided by the total
--   size of the swarm
-- - the time it takes to execute all pending grow tasks, plus the time it takes
--   to execute the weaken tasks that would generate
function calcEfficiency(info, target_money, swarm_size)
  return target_money * math.max(info.hack_fraction, HACK_RATIO)
       / (info.hack_time * math.ceil(info.hack/swarm_size)
          + info.weaken_time * (info.weaken + 0.004 * info.grow) * math.ceil(info.weaken/swarm_size)
          + info.grow_time * info.grow * math.ceil(info.grow/swarm_size))
end

---- Task generation ----

-- Return a sorted list of tasks, all of the form
-- { host=foo, action=bar, threads=N, priority=P }
function generateTasks(network)
  local tasks = {}
  for host,info in pairs(network) do
    generateTasksForHost(tasks, info)
  end
  table.sort(tasks, taskOrdering)
  return tasks
end

function generateTasksForHost(tasks, info)
  if not TARGET_MONEY[info.host] then return end
  -- Rank is more significant than priority when ordering.
  -- We have these separate fields because it's hard to come up with a constant
  -- factor we can modify priority by that will consistently give us the right
  -- results no matter how weird the server money numbers get.
  local rank = 3
  for _,action in ipairs {"weaken", "grow", "hack"} do
    if info[action] > 0 then
      local task = { host=info.host; action=action; threads=info[action];
                     rank=rank; priority=info.priority; time=info[action.."_time"] }
      log.debug("Task: %s %s (x%d) t=%f P=%d/%f", task.action, task.host, task.threads,
                task.time, task.rank, task.priority)
      table.insert(tasks, task)
      rank = rank - 1
    end
  end
  -- Insert a "fallback" task for growing the host, ordered by how far each host
  -- is away from its max money.
  local fallback_grow = math.ceil(ns:growthAnalyze(info.host, info.max_money/(math.max(info.money, 0.01)))) - info.grow
  if fallback_grow > 0 then
    local task = { host=info.host; action="grow"; threads=fallback_grow;
                   rank=0; priority=-fallback_grow; time=info.grow_time }
    log.debug("Fallback: %s %s (x%d) t=%f P=%d/%f", task.action, task.host, task.threads,
              task.time, task.rank, task.priority)
    table.insert(tasks, task)
  end
end

-- Ordering function for individual tasks.
-- Rank is given the biggest weight, with higher rank => more important task.
-- Within rank, we order by priority.
-- In practice, this means that it will bin together all hacks on systems that
-- need neither grow nor weaken, all grows on systems that don't need weakens,
-- and all weakens on the remainder, then order them by priority.
-- After those, it bins together grows blocked on weakens and hacks blocked on grows
-- And after those, hacks blocked on both grow and weaken.
function taskOrdering(t1, t2)
  if t1.rank ~= t2.rank then return t1.rank < t2.rank end
  return t1.priority < t2.priority
end

---- Task assignment ----

-- Given a network of hosts we can possibly run SPUs on, and an ordered list of
-- tasks, most important at the end, attempts to run SPUs to attack as many of
-- the tasks as possible.
function assignTasks(network, tasks)
  local function next_task() return table.remove(tasks) end
  local task = next_task()
  local min_time = math.huge
  for host,info in pairs(network) do
    while task do
      if info.threads <= 0 then break end -- next host
      if task.threads <= 0 then
        task = next_task() -- next task
      else
        local threads = math.min(task.threads, info.threads)
        runSPU(host, threads, task.action, task.host)
        task.threads = task.threads - threads
        info.threads = info.threads - threads
        min_time = math.min(min_time, task.time)
      end
    end
  end
  return min_time
end

function runSPU(host, threads, action, target)
  log.debug("SPU: %s[%d]: %s %s", host, threads, action, target)
  ns:exec(SPU_NAME, host, threads, action, target)
end

return main(...)
