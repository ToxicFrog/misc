-- Assorted global functions that don't belong in their own file.

-- 5.3 compatibility
local unpack = table.unpack

-- fast one-liner lambda creation
function f(src)
  return assert(load(
    "return function(" .. src:gsub(" ?=> ?", ") return ", 1) .. " end"
  ))()
end

-- partially apply f with ...
function partial(f, ...)
  if select('#', ...) == 0 then
    return f
  end
  local head = (...)
  return partial(function(...) return f(head, ...) end, select(2, ...))
end

-- given bind(obj, 'method', ...), equivalent to
-- partial(obj.method, obj, ...)
function bind(self, method, ...)
  return partial(self[method], self, ...)
end

-- As tonumber/tostring, but casts to bool
function toboolean(v)
  return not not v
end

-- formatting-aware versions of assert and error
-- the assert one is named "check" so as not to
do
  local _assert,_error = assert,error

  function assert(exp, err, ...)
    if select('#', ...) > 0 and not exp then
      return _error(err:format(...))
    end
    return _assert(exp,err,...)
  end

  function error(err, ...)
    if select('#', ...) > 0 then
      return _error(err:format(...))
    end
    return _error(err)
  end
end

-- table.sort should return the sorted table
do
  local _sort = table.sort
  function table:sort(...)
    _sort(self, ...)
    return self
  end
end

function identity(x) return x end
function constantly(x) return function() return x end end
