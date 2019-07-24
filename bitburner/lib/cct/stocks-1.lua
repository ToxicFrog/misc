-- given a js array of stock prices, generate an array showing what
local function best_sell(prices)
  local best_sell = {}
  local current_sell = 0
  for i=#prices,1,-1 do
    current_sell = current_sell:max(prices[i])
    best_sell[i] = current_sell
  end
  return best_sell
end

local function max_profit(prices)
  local sells = best_sell(prices)
  local profit = 0
  for i,price in ipairs(prices) do
    profit = profit:max(sells[i] - prices[i])
  end
  return profit
end

local function solve(data)
  return max_profit(js.totable(data))
end

return solve
