local net = require 'net'
local sh = require 'shell'

local src,dst = ...
if not dst then
  src,dst = "home",src
end
local path = net.path(src, dst)
table.remove(path,1)
sh.execute("connect " .. table.concat(path, "; connect "))
