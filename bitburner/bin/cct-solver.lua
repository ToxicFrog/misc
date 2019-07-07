-- Automatically discover and solve CCTs on the network.
--

local TIME_BETWEEN_SCANS = 60*60

local cct = require 'cct'
local net = require 'net'

local function solveCCTs(host, depth)
  for file in js.of(ns:ls(host)) do
    if file:match("%.cct$") then
      cct.solve(host, file)
    end
  end
  return true
end

function main(...)
  while true do
    net.walk(solveCCTs, "home")
    ns:sleep(TIME_BETWEEN_SCANS)
  end
end

return main(...)