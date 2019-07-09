local log = require 'log'

local spikes = {
  "BruteSSH.exe", "FTPCrack.exe", "relaySMTP.exe", "HTTPWorm.exe", "SQLInject.exe",
}
local utils = {
  "AutoLink.exe", "DepscanV1.exe", "DeepscanV2.exe",
  "ServerProfiler.exe"
}

local TIME_BETWEEN_BUYS = 5.0
local BUDGET = 0.9

local function buyTor(budget)
  if ns:getCharacterInformation().tor then return false end
  if budget < 2e5 then return true end
  ns:purchaseTor()
  return true
end

local function buySpikes(budget)
  for _,program in pairs(spikes) do
    if not ns:fileExists(program) and ns:purchaseProgram(program) then
      return true
    end
  end
  return false
end

local function buyUtilities(budget)
  for _,program in pairs(utils) do
    if not ns:fileExists(program) and ns:purchaseProgram(program) then
      return true
    end
  end
  return false
end

local BUYS = {
  {buyTor, 0.9};
  {buySpikes, 0.9};
  {buyUtilities, 0.05};
}

ns:disableLog("getServerMoneyAvailable")

while true do
  local money = ns:getServerMoneyAvailable 'home'
  for _,buy in ipairs(BUYS) do
    if buy[1](money * buy[2]) then break end
  end
  ns:sleep(TIME_BETWEEN_BUYS)
end
