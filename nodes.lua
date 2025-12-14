-- Most builders in the logic file look like: room 'name' { ...room fields and children... }
-- This function supports uses like that; it's expected to be called by the
-- first function, and returns a function that takes the table of fields-and-children
-- and turns it into something a bit more ergonomic.
local function node_builder(tag, name, has_desc)
  return function(info)
    local node = { tag = tag; name = name; children = {}; }
    if not info then return node end

    for i,v in ipairs(info) do
      if type(v) == 'string' and has_desc then
        node.desc = (node.desc or '') .. v
      elseif type(v) == 'string' then
        table.insert(node.children, item(v))
      else
        while type(v) == 'function' do v = v() end
        assert(v, 'child of '..tag..' became nil during evaluation')
        table.insert(node.children, v)
        if v.tag then
          node[v.tag] = node[v.tag] or {}
          if v.name then
            node[v.tag][v.name] = v
          else
            table.insert(node[v.tag], v)
          end
        end
      end
      info[i] = nil
    end

    for k,v in pairs(info) do
      node[k] = v
    end
    return node
  end
end

local function node_type(tag)
  return function(name) return node_builder(tag, name) end
end

REGIONS = {}
ROOMS = {}
function region(name)
  return function(info)
    local node = node_builder('region', name, true)(info)
    REGIONS[node.name] = node
    node.rooms = {}
    for _,room in ipairs(node.children) do
      node.rooms[room.name] = room
      ROOMS[room.name] = room
    end
    return node
  end
end

room = function(name) return node_builder('room', name, true) end
-- Enemies can be flagged "boss" if they do not respawn and give a score screen,
-- or "miniboss" if they don't respawn but don't have a score screen. Enemies
-- with neither flag are assumed to infinitely respawn on leaving the area.
enemy = function(name) return node_builder('enemy', name, false) end
dummy = function(name) return node_builder('dummy', name, false) end
chest = node_builder('chest', nil, false)

function item(name)
  return { tag = 'item'; name = name; }
end

function exit(to)
  return function(key)
    return { tag = 'exit'; name = to; key = key; }
  end
end

for _,dir in ipairs { 'n', 'nw', 'w', 'sw', 's', 'se', 'e', 'ne' } do
  _G['exit'..dir] = function(to)
    return function(key)
      return { tag = 'exit'; name = to; key = key; dir = dir; }
    end
  end
end

function trap(type)
  return { tag = 'trap'; name = type; }
end

function sphere0() end

function all_regions() return pairs(REGIONS) end
