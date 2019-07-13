local log = require 'log'

local MAX_RAM = 256
local TIME_BETWEEN_BUYS = 5.0

while true do
  local money = ns:getServerMoneyAvailable 'home'
  if ns:getServerRam('home')[0] >= MAX_RAM then
    -- If we've hit our RAM target, only upgrade when it's cheap to do so.
    money = money * 0.1
  end
  local cost = ns:getUpgradeHomeRamCost()
  if cost <= money then
    ns:upgradeHomeRam()
  end
  ns:sleep(TIME_BETWEEN_BUYS)
end
