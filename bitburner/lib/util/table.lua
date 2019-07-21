-- new functions related to tables
-- functions that handle tables-as-lists go in list.lua

-- map over keys
-- if multiple calls return the same key the result is undefined
function table.mapk(t, f)
  local tprime = {}
  for k,v in pairs(t) do
    tprime[f(k)] = v
  end
  return tprime
end

-- map over values
function table.mapv(t, f)
  local tprime = {}
  for k,v in pairs(t) do
    tprime[k] = f(v)
  end
  return tprime
end

-- map over keys and values
function table.mapkv(t, f)
  local tprime = {}
  for k,v in pairs(t) do
    k,v = f(k,v)
    tprime[k] = v
  end
  return tprime
end

-- Return a list of table keys in unspecified order
function table.keys(t)
  local r = {}
  for k in pairs(t) do r[#r+1] = k end
  return r
end

-- map over table as list
function table.map(t, f)
  local r = table.List {}
  for i,v in ipairs(t) do
    r[i] = f(v)
  end
  return r
end

-- Returns a list containing only elements for which p(elem) is logical true
function table.filter(t, p)
  local r = table.List {}
  for _,v in ipairs(t) do
    if p(v) then table.insert(r, v) end
  end
  return r
end

-- Similar to filter() but instead returns the first element which p accepts
function table.some(t, p)
  for _,v in ipairs(t) do
    local v = p(v)
    if v then return v end
  end
  return nil
end

function table.List(t)
  t = t or {}
  return setmetatable(t, {
    __index = function(self, key)
      return rawget(table, key)
    end;
  })
end

