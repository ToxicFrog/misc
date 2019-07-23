for _,key in ipairs {
  'universityCourse', 'gymWorkout', 'workForCompany', 'workForFaction',
  'createProgram', 'commitCrime',
} do
  local _fn = ns[key]
  ns[key] = function(...)
    local r = _fn(...)
    js.global:restoreUI(true, true)
    return r
  end
end

local _fn = ns.stopAction
ns.stopAction = function(...)
  local r = _fn(...)
  js.global:restoreUI(true, false)
  return r
end
