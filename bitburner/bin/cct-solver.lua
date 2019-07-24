-- Automatically discover and solve CCTs on the network.
--

local TIME_BETWEEN_SCANS = 60*10

local cct = require 'cct'
local net = require 'net'

-- Disable the watchdog timer, since it interferes with the coroutines used
-- by some of the solvers.
function atwatchdog() end

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
