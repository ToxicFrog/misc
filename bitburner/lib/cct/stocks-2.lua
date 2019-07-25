local function max_profit(prices)
  local total = 0
  for i=1,#prices-1 do
    total = total + math.max(0, prices[i+1] - prices[i])
  end
  return total
end

local function solve(data)
  return max_profit(js.totable(data))
end

return solve
