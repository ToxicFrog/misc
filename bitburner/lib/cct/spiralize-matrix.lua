local function append(dst, src)
  for _,v in ipairs(src) do
    table.insert(dst, v)
  end
end

local function reverse(t)
  local result = {}
  while #t > 0 do
    table.insert(result, table.remove(t))
  end
  return result
end

local function spiralize(grid)
  local result = {}
  while #grid > 0 do
    -- top row
    append(result, table.remove(grid, 1))
    if #grid == 0 then break end

    -- right column
    for _,row in ipairs(grid) do table.insert(result, table.remove(row)) end
    if #grid[1] == 0 then break end

    -- bottom row
    append(result, reverse(table.remove(grid)))
    if #grid == 0 then break end

    -- left column
    for r=#grid,1,-1 do table.insert(result, table.remove(grid[r], 1)) end
    if #grid[1] == 0 then break end
  end
  return result
end

local function solve(data)
  local grid = { rows = data.length; cols = data[0].length; }
  for r in js.of(data) do
    local row = {}
    for cell in js.of(r) do
      table.insert(row, cell)
    end
    table.insert(grid, row)
  end

  return js.Array(spiralize(grid))
end

return solve
-- for _,v in ipairs(spiralize {
-- {39,23,25,18,20,};
-- {6,15,40,25,23,};
-- {36,34,31,15,36,};
-- {42,21,49,25,46,};
-- {8,36,6,44,20,};
-- {38,20,8,32,23,};
-- {13,10,39,17,37,};
-- {39,36,7,38,13,};
-- {15,39,4,13,38,};
-- {4,38,11,47,21,};
-- {9,18,13,48,34,};
-- {12,6,46,34,7,};
-- {48,11,29,30,2,};
-- {33,18,31,43,6,};
-- {31,26,11,4,50,};
-- }) do
--   io.write(v..",")
-- end
