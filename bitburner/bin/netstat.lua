-- Display a tree of network information.

local net = require 'net'

local maxdepth = tonumber((...)) or 5

local function showHost(host, depth)
  local stat = net.stat(host)
  printf("%-26.26s  %d %4d %s  %3.0f/%-3.0f  (%0.2f) %16s",
    (" "):rep(depth) ..  host,
    stat.ports, stat.hack_level, stat.root and "R" or " ",
    stat.security, stat.min_security,
    stat.money/(stat.max_money > 0 and stat.max_money or 1), -- makes 0/0 show up as 0 rather than inf
    tomoney(stat.money));
  return depth < maxdepth
end

printf("<u>%26s  %s %s %s  %3s/%-3s  %s %15s</u>",
  "hostname", "P", "Hack", "R", "Sec", "Min", "$Ratio", "$Total");
net.walk(showHost, ns:getHostname())
