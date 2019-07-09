local log = require 'log'

local MAX_RAM = 256
local TIME_BETWEEN_BUYS = 5.0

while true do
  if ns:getServerRam('home')[0] < MAX_RAM then
    local money = ns:getServerMoneyAvailable 'home'
    local cost = ns:getUpgradeHomeRamCost()
    if cost < money then
      ns:upgradeHomeRam()
    end
  end
  ns:sleep(TIME_BETWEEN_BUYS)
end
