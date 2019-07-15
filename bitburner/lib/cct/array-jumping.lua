local function solve(data)
  local max = 0
  for i=0,data.length-1 do
    if i > max then break end
    max = math.max(max, i + data[i])
  end
  return max >= data.length-1 and 1 or 0
end

return solve
