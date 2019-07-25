local function solve(data)
  local ways = setmetatable({[0] = 1}, {__index = function() return 0 end})
  for i=1,data-1 do
    for j=i,data do
      ways[j] = ways[j] + ways[j-i]
    end
  end
  return ways[#ways]
end

-- print(solve(4))
-- print(solve(44))

return solve
