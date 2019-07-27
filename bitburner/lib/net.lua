-- Utility library for getting information about the network and hosts on it.

local net = {}

-- helper for net.walk
local function walkOne(fn, host, depth, seen, ...)
  seen[host] = true
  if host:match("hacknet%-node%-%d+") then return end
  if not fn(host, depth, ...) then return end
  for peer in js.of(ns:scan(host)) do
    if not seen[peer] then
      walkOne(fn, peer, depth+1, seen, peer, ...)
    end
  end
end

-- Traverse the net, starting at root, and call fn(hostname, depth, path...) on each
-- host reachable from it. Depth is the number of hops away from root the given
-- host is; it is 0 for root. Path is the path from this node back to the root,
-- and can be reversed to get the path from the root to this node.
-- The fn should return true if traversal should continue through that host,
-- false to stop traversal.
function net.walk(fn, root)
  return walkOne(fn, root, 0, {}, root)
end

-- Return the path from src to dst, i.e. the sequence of hostnames you'd have to
-- feed to 'connect' to get from src to dst.
function net.path(src, dst)
  local path
  local function findPath(host, depth, ...)
    if host == src then
      path = { ... }
    end
    if path then return false end
    return true
  end
  net.walk(findPath, dst)
  return path
end

-- Scan a single host and return information about it.
function net.stat(host)
  local stat = {}
  stat.host = host
  stat.ps = js.totable(ns:ps(host))
  stat.ls = js.totable(ns:ls(host))
  stat.root = ns:hasRootAccess(host)
  stat.ports = ns:getServerNumPortsRequired(host)
  stat.ram = ns:getServerRam(host)[0]
  stat.ram_used = ns:getServerRam(host)[1]
  stat.security = ns:getServerSecurityLevel(host)
  stat.min_security = ns:getServerMinSecurityLevel(host)
  stat.money = ns:getServerMoneyAvailable(host)
  stat.max_money = ns:getServerMaxMoney(host)
  stat.hack_level = ns:getServerRequiredHackingLevel(host)
  stat.hack_fraction = ns:hackAnalyzePercent(host)/100
  stat.hack_time = ns:getHackTime(host)
  stat.grow_time = ns:getGrowTime(host)
  stat.weaken_time = ns:getWeakenTime(host)
  return stat
end

return net
