
local function paths_from(grid, row, col)
  if row > grid.rows or col > grid.cols then return 0 end
  if not grid[row][col] then
    grid[row][col] = paths_from(grid, row+1, col) + paths_from(grid, row, col+1)
  end
  return grid[row][col]
end

local function solve(data)
  local grid = { rows = data.length; cols = data[0].length; }
  for r in js.of(data) do
    local row = {}
    for cell in js.of(r) do
      table.insert(row, cell == 1 and 0 or false)
    end
    table.insert(grid, row)
  end
  grid[grid.rows][grid.cols] = 1

  return paths_from(grid, 1, 1)
end

return solve
