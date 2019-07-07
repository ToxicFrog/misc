return function(data)
  local n = data[0]
  local max = n
  for i=1,data.length-1 do
    n = math.max(data[i], data[i] + n)
    max = math.max(max, n)
  end
  return max
end
