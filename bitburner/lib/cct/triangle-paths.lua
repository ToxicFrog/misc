--[[
You are given a 2D array of numbers (array of array of numbers) that represents a
triangle (the first array has one element, and each array has one more element than
the one before it, forming a triangle). Find the minimum path sum from the top to the
bottom of the triangle. In each step of the path, you may only move to adjacent
numbers in the row below.
]]

local function path_cost(costs, triangle, row, index)
  if row == #triangle then
    return triangle[row][index]
  elseif not costs[row][index] then
    costs[row][index] = triangle[row][index]
        + math.min(path_cost(costs, triangle, row+1, index), path_cost(costs, triangle, row+1, index+1))
  end
  return costs[row][index]
end

-- data is a javascript array of arrays
return function(data)
  local costs = setmetatable({}, {__index = function(self, k) self[k] = {}; return self[k] end})
  local tri = {}
  for row in js.of(data) do
    table.insert(tri, js.totable(row))
  end
  return path_cost(costs, tri, 1, 1)
end
