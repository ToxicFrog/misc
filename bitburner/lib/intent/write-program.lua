local spikes = {
  { name = "BruteSSH.exe",  hack = 50,  cost = 500e3 };
  { name = "FTPCrack.exe",  hack = 100, cost = 1.5e6 };
  { name = "relaySMTP.exe", hack = 250, cost =   5e6 };
  { name = "HTTPWorm.exe",  hack = 500, cost =  30e6 };
  { name = "SQLInject.exe", hack = 750, cost = 250e6 };
}

return function()
  for _,spike in ipairs(spikes) do
    if not ns:fileExists(spike.name)
       and ns:getHackingLevel() >= spike.hack
       and ns:getServerMoneyAvailable('home') < spike.cost/2
    then
      return { source = "write programs"; priority = 10; activity = 'createProgram'; spike.name }
    end
  end
  return { source = "write programs"; priority = -1; activity = 'IDLE' }
end
