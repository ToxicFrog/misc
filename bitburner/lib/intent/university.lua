local schools,courses,list = {},{},{}

local function School(name)
  return function(init)
    init.name = name
    schools[name] = init
  end
end

local function Course(name)
  return function(init)
    init.name = name
    courses[name] = init
    for _,school in pairs(schools) do
      table.insert(list,
        { name = name; school = school; cost = init.cost * school.cost; stat = init.stat })
    end
  end
end

School 'Rothman University' {
  city = 'Sector-12';
  cost = 120;
}
School 'Summit University' {
  city = 'Aevum';
  cost = 160;
}
School 'ZB Institute of Technology' {
  city = 'Volhaven';
  cost = 200;
}

Course 'Study Computer Science' { cost = 0; stat = 'hack'; }
Course 'Data Structures' { cost = 1; stat = 'hack' }
Course 'Networks' { cost = 2; stat = 'hack' }
Course 'Algorithms' { cost = 8; stat = 'hack' }
Course 'Management' { cost = 4; stat = 'charisma' }
Course 'Leadership' { cost = 8; stat = 'charisma' }

local function universityIntent(intent, stat)
  local budget = ns:getServerMoneyAvailable('home')/5
  local city = ns:getCharacterInformation().city
  -- pick a course
  -- if we're above the travel budget, this can be anything offered at any school
  -- if we're not, this can only be something offered in our current location
  local class = table.List(list)
    :filter(function(x) return x.stat == stat end)
    :filter(
      budget > 200e3
      and f'=> true'
      or function(x) return x.school.city == city end)
    :filter(function(x) return x.cost * 60 <= budget end)
    :sort(f'x,y => x.cost > y.cost')
    :some(f'x => x')
  if not class then return nil end
  if class.school.city ~= city then
    ns:travelToCity(class.school.city)
  end
  return {
    priority = intent.priority; source = intent.source;
    activity = "universityCourse", class.school.name, class.name
  }
end

return universityIntent
