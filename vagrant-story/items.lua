-- Generate a tsv of all items in the game

require 'main'

local function chest_name(chest, i)
  local name = 'Chest'
  if chest.locked then
    name = 'Locked Chest'
  elseif chest.warded then
    name = 'Warded Chest'
  end
  if i > 1 then
    name = name..' #'..i
  end
  return name
end

local function enemy_name(enemy)
  if enemy.boss then
    return enemy.name..' (BOSS)'
  elseif enemy.miniboss then
    return enemy.name..' (miniboss)'
  else
    return enemy.name
  end
end

local function item_parts(item)
  local name,tail = item.name:match('^(.-):(.*)$')
  if not name then tail = item.name end
  local parts = {}
  for part in tail:gmatch('[^/]+') do
    table.insert(parts, part)
  end
  if #parts <= 1 then return nil end
  if not name then name = parts[1]:match('(.*)%..') end
  return name,parts
end

local function print_item_parts(region, room, location, item)
  local name,parts = item_parts(item)
  if not name then
    printf('%s\t%s\t%s\t%s\n', region, room, location, item.name)
  else
    printf('%s\t%s\t%s\t%s\n', region, room, location, name)
    for _,part in ipairs(parts) do
      printf('%s\t%s\t%s\t+ %s\n', region, room, location, part)
    end
  end
end

for r,region in ipairs(REGIONS) do
  for _,room in ipairs(region.children) do
    for i,chest in ipairs(room.chest or {}) do
      for _,item in ipairs(chest.children) do
        print_item_parts(region.name, room.name, chest_name(chest, i), item)
      end
    end
    for i,enemy in ipairs(room.enemy or {}) do
      for _,item in ipairs(enemy.children) do
        print_item_parts(region.name, room.name, enemy_name(enemy), item)
      end
    end
  end
end
