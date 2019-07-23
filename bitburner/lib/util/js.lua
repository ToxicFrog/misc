-- Add convenient table-to-generic-Object creator.
function js.Object(t)
  local obj = js.new(js.global.Object)
  for k,v in pairs(t) do
    obj[k] = v
  end
  return obj
end

-- Same for arrays.
function js.Array(t)
  local arr = js.new(js.global.Array)
  for i,v in ipairs(t) do
    arr:push(v)
  end
  return arr
end

-- Convert JS array to Lua table.
function js.totable(arr)
  local T = {}
  for v in js.of(arr) do T[#T+1] = v end
  return T
end

-- Convert JS array to List (table with metatable attached)
function js.toList(arr)
  return table.List(js.totable(arr))
end
