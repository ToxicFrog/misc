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
require 'undercity-west'
require 'snowfly-forest'
require 'city-walls-south'
require 'the-keep'
require 'town-centre-south'
require 'city-walls-east'
require 'snowfly-forest-east'
require 'iron-maiden-b1'
require 'abandoned-mines-b2'
require 'town-centre-east'
require 'city-walls-north'
require 'undercity-east'
require 'limestone-quarry'
require 'temple-of-kiltia'
require 'great-cathedral'

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

local directions = {
  nw = {-1,1};  n = {0,1};  ne = {1,1};
   w = {-1,0};               e = {1,0};
  sw = {-1,-1}; s = {0,-1}; se = {1,-1};
}

function gv_pos(region, room)
  local scale = 3;
  if not room.x or not room.y then
    for _,exit in ipairs(room.exit or {}) do
      local to = exit.name
      local other = ROOMS[to]
      if other and other.x and exit.dir then
        local dx,dy = table.unpack(directions[exit.dir])
        room.x = room.x or (other.x - dx + (room.dx or 0))
        room.y = room.y or (other.y - dy + (room.dy or 0))
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

function gv_arrow(room, to)
  if not ROOMS[to] or not ROOMS[to].exit then
    return ""
  end
  if ROOMS[to].exit[room.name] then
    return ""
  else
    return ",dir=forward"
  end
end

function gv_key(room, exit)
  if exit.key then return exit.key end
  local dest = ROOMS[exit.name]
  if dest and dest.exit and dest.exit[room.name] and dest.exit[room.name].key then
    return dest.exit[room.name].key
  end
  return nil
end

print [[
strict graph {
  bgcolor=black;
  color=white;
  fontcolor=white;
  splines=ortho;
  node [shape=box,color=magenta,fontcolor=white];
  edge [fontcolor=white,penwidth=3];
]]

for r,region in ipairs(REGIONS) do

  -- Define a cluster for the region and place all nodes within it
  printf([[
 //// region: %s ////
 subgraph cluster_%s {
  label = "%s";
  labeljust = l;
  pad=2; margin=2;
]],
  region.name, gv_name(region.name), region.name)

  for _,room in ipairs(region.children) do
    printf('  %s [color=white,label="%s"%s];\n', gv_name(room.name), gv_label(room), gv_pos(region, room))
  end
  print(' }')

  -- Now define all edges outside the region
  for _,room in ipairs(region.children) do
    printf('  %s [color=white,label="%s"%s];\n', gv_name(room.name), gv_label(room), gv_pos(region, room))
    for _,exit in ipairs(room.exit or {}) do
      local to = exit.name
      local dir = ''
      local gv_to = gv_name(to)
      local gv_room = gv_name(room.name)
      local gv_key = gv_key(room, exit)
      local arrow = gv_arrow(room, to)
      if exit.dir then dir = ':'..exit.dir end

      local colour = 'white,penwidth=2'
      if not ROOMS[to] then
        colour = 'magenta'
      elseif exit.pos_only then
        colour = 'black'
      elseif not region.rooms[to] then
        if gv_key then
          colour = 'red,style=dashed'
        else
          colour = 'blue,style=dashed'
        end
      elseif gv_key then
        colour = 'red'
      end

      if gv_key then
        printf('    %s%s -- %s [color=%s,label="%s"%s];\n',
          gv_room, dir, gv_to, colour, gv_key, arrow)
      else
        printf('    %s%s -- %s [color=%s%s];\n',
          gv_room, dir, gv_to, colour, arrow)
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
