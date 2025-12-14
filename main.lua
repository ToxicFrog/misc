-- Regenerate map with:
-- luajit main.lua | tee vs.dot | fdp -Tpng > vs.png
require 'util'
require 'nodes'

require 'wine-cellar'
require 'catacombs'
require 'sanctum'
require 'town-center-west'
require 'city-walls-west'
require 'abandoned-mines-b1'

function gv_name(str)
  return (str:gsub('%W+', ''))
end

function append_children(buf, node)
  if not node.children then return end
  for _,child in ipairs(node.children) do
    if child.tag == 'enemy' then
      table.insert(buf, '! '..child.name)
      if child.after then
        table.insert(buf, '  ? '..child.after)
      end
    elseif child.tag == 'item' then
      table.insert(buf, '+ '..child.name)
    end
    append_children(buf, child)
  end
end

function gv_label(room)
  local buf = { (room.name:gsub('"', '\\"')) }
  append_children(buf, room)
  return table.concat(buf, '\\l')..'\\l'
end

print [[
strict graph {
  node [shape=box];
  edge [len=2];
]]

local directions = {
  nw = {-1,1};  n = {0,1};  ne = {1,1};
   w = {-1,0};               e = {1,0};
  sw = {-1,-1}; s = {0,-1}; se = {1,-1};
}

function gv_pos(region, room)
  local scale = 3;
  if not room.x then
    for to,exit in pairs(room.exit or {}) do
      other = ROOMS[to]
      if other and other.x and exit.dir then
        local dx,dy = table.unpack(directions[exit.dir])
        room.x = other.x - dx
        room.y = other.y - dy
        eprintf('set %s to (%d,%d) b/c %s (%d,%d) to %s\n',
          room.name, room.x, room.y, to, other.x, other.y, exit.dir)
        break
      end
    end
  end
  if room.x and room.y then
    return ",pos=\""..room.x*scale..","..room.y*scale.."!\""
  else
    return ""
  end
end

for r,region in all_regions() do
  printf('  \n//// region: %s ////\n', r)

  for _,room in ipairs(region.children) do
    printf('  %s [label="%s"%s];\n', gv_name(room.name), gv_label(room), gv_pos(region, room))
    for to,exit in pairs(room.exit or {}) do
      local dir = ''
      if exit.dir then dir = ':'..exit.dir end
      if exit.key then
        printf('    %s%s -- %s [color=red,label="%s"];\n', gv_name(room.name), dir, gv_name(to), exit.key)
      elseif not region.rooms[to] then
        printf('    %s%s -- %s [color=blue];\n', gv_name(room.name), dir, gv_name(to))
      else
        printf('    %s%s -- %s;\n', gv_name(room.name), dir, gv_name(to))
      end
    end
  end
end

print('}')

--     print('  '..room.name)
--     if room.desc then
--       print('    '..room.desc)
--     end
--     for _,child in ipairs(room.children) do
--       if child.tag == 'enemy' then
--         print('    - '..child.name)
--       elseif child.tag == 'chest' then
--         print('    + chest: '..#child.children..' items')
--       elseif child.tag == 'exit' then
--         if child.key then
--           print('    > exit to '..child.to..': '..child.key)
--         else
--           print('    > exit to '..child.to)
--         end
--       elseif child.tag == 'trap' then
--         print('    ! trap: '..child.name)
--       end
--     end
--   end
-- end
