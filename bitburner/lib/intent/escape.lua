local function canHack(host)
  return ns:hasRootAccess(host)
     and ns:getServerRequiredHackingLevel(host) <= ns:getHackingLevel()
end

return function()
  if not canHack('w0r1d_d43m0n') then return nil end
  ns:kill("/bin/init.L.ns", "home")
  return {
    priority = 9999;
    source = 'escape';
    delay = math.huge;
    activity = 'HACK_SERVER', 'w0r1d_d43m0n'
  }
end
