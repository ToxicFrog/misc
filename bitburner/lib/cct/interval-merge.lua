local function intervalOrder(x,y)
  if x[1] == y[1] then return x[2] < y[2] end
  return x[1] < y[1]
end

local function tryMerge(x,y)
  if x[2] >= y[1] then
    return {x[1], math.max(x[2], y[2])}
  else
    return nil
  end
end

local function intervalMerge(intervals)
  table.sort(intervals, intervalOrder)
  local i=1
  while i < #intervals do
    local merged = tryMerge(intervals[i], intervals[i+1])
    if merged then
      table.remove(intervals, i)
      table.remove(intervals, i)
      table.insert(intervals, i, merged)
    else
      i = i+1
    end
  end
  return intervals
end

local function solve(data)
  local intervals = {}
  for interval in js.of(data) do
    table.insert(intervals, {interval[0], interval[1]})
  end

  local answer = js.Array {}
  for _,interval in ipairs(intervalMerge(intervals)) do
    answer:push(js.Array(interval))
  end
  return answer
end

return solve
-- local test = {{7,16},{20,26},{1,6},{16,17},{16,20},{17,22},{7,10},{17,22},{4,5},{10,19}}
-- for _,int in ipairs(intervalMerge(test)) do
--   print(unpack(int))
-- end
