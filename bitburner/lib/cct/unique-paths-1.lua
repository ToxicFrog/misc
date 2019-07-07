
local function paths_from(grid, row, col)
  if not grid[row][col] then
    grid[row][col] = paths_from(grid, row+1, col) + paths_from(grid, row, col+1)
  end
  return grid[row][col]
end

local function solve(data)
  local grid = {
    rows = data[0]; cols = data[1];
  }
  for r=1,grid.rows do
    table.insert(grid, { [grid.cols] = 1 })
  end
  for c=1,grid.cols do
    grid[grid.rows][c] = 1
  end
  return paths_from(grid, 1, 1)
end

return solve
