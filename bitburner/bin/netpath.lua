local net = require 'net'
local sh = require 'shell'

local argv = {...}
local dst = table.remove(argv, 1)

local path = net.path("home", dst)
table.remove(path,1)
sh.execute("connect " .. table.concat(path, "; connect ")
           .. '; '..table.concat(argv, "; "))
