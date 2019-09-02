local wait = {}

function wait.allOf(...)
  local ps = {...}
  return function()
    for _,P in ipairs(ps) do
      if not P() then return false end
    end
    return true
  end
end

function wait.haveHackingLevel(hack)
  return function()
    return ns:getHackingLevel() >= hack
  end
end

function wait.canHack(host)
  return function()
    return ns:hasRootAccess(host)
       and ns:getServerRequiredHackingLevel(host) <= ns:getHackingLevel()
  end
end

function wait.haveInvite(faction)
  return function()
    return ns:checkFactionInvitations():includes(faction)
  end
end

function wait.haveMoney(amount)
  return function()
    return ns:getServerMoneyAvailable('home') > amount
  end
end

function wait.waitUntil(P, delay)
  while not P() do
    ns:sleep(delay or 60)
  end
end

return wait
