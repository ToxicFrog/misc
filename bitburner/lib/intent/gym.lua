local gyms = {}
local function Gym(name)
  return function(init)
    init.name = name
    gyms[name] = init
    table.insert(gyms, init)
  end
end

Gym 'Millenium Fitness Gym' { city = 'Volhaven'; cost = 840 }
Gym 'Crush Fitness' { city = 'Aevum'; cost = 360 }
Gym 'Snap Fitness Gym' { city = 'Aevum'; cost = 1.2e3 }
Gym 'Iron Gym' { city = 'Sector-12'; cost = 120 }
Gym 'Powerhouse Gym' { city = 'Sector-12'; cost = 2.4e3 }

local function gymIntent(self)
  local budget = ns:getServerMoneyAvailable('home')/5
  local city = ns:getCharacterInformation().city
  -- Pick a gym. If we're above the travel budget, pick the most expensive gym we
  -- can afford anywhere. If not, pick the most expensive one we can afford in this city.
  local gym = table.List(gyms)
    :filter(budget > 200e3 and constantly(true) or function(x) return x.city == city end)
    :filter(function(x) return x.cost * 60 <= budget end)
    :sort(f'x,y => x.cost > y.cost')
    :some(identity)
  if not gym then return { activity = "IDLE", priority=self.priority, source=self.source, goal=self.goal } end
  if gym.city ~= city then
    ns:travelToCity(gym.city)
  end
  local stats = ns:getStats()
  local stat = table.List({ "strength", "dexterity", "defense", "agility" })
    :sort(function(x,y) return stats[x] < stats[y] end)
    :some(identity)
  return { activity = "gymWorkout", gym.name, stat, priority=self.priority, source=self.source,
           goal=self.goal }
end

return gymIntent
