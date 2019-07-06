local wrap,yield = coroutine.wrap,coroutine.yield

getmetatable("").__call = string.sub

local function isValidOctet(s)
  local n = tonumber(s)
  if s(1,1) == '0' then
    return n == 0 and s == '0'
  else
    return n <= 255
  end
end

local function isValidIP(s)
  for octet in s:gmatch("%d+") do
    if not isValidOctet(octet) then return false end
  end
  return true
end

local function IPs(s)
  return wrap(function()
    for dot1=1,#s-3 do
      for dot2=dot1+1,#s-2 do
        for dot3=dot2+1,#s-1 do
          local ip = s(1,dot1) .. "." .. s(dot1+1,dot2) .. "." .. s(dot2+1,dot3) .. "." .. s(dot3+1)
          if isValidIP(ip) then yield(ip) end
        end
      end
    end
  end)
end

return function(data)
  local answer = js.new(js.global.Array)
  for ip in IPs(data) do
    answer:push(ip)
  end
  return answer
end
