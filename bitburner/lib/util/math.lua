-- math-related functions

inf = math.huge

-- Allow math methods, e.g. x:bound(0, 100)
local mt = {}
debug.setmetatable(0, mt)
mt.__index = math

-- degree-based trig:
-- dcos dsin dtan dacos dasin datan
for k,v in ipairs({ "cos", "sin", "tan", "tan2" }) do
  math["d"..v] = function(r) return math[v](math.rad(r)) end
  math["da"..v] = function(r) return math.deg(math["a"..v](r)) end
end
math.dtan2 = nil

-- It's max and min in one!
-- bound(min, n, max) would make more sense in some ways (because then it looks
-- like (min <= n <= max), but putting n first lets us method-call it.
function math.bound(n, min, max)
  return n:min(max):max(min)
end
