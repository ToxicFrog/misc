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

for r,region in all_regions() do
  printf('  \n//// region: %s ////\n', r)

  for _,room in ipairs(region.children) do
    printf('  %s [label="%s"];\n', gv_name(room.name), gv_label(room))
    for _,child in ipairs(room.children) do
      if child.tag == 'exit' then
        if child.key then
          printf('    %s -- %s [color=red,label="%s"];\n', gv_name(room.name), gv_name(child.to), child.key)
        elseif not region.rooms[child.to] then
          printf('    %s -- %s [color=blue];\n', gv_name(room.name), gv_name(child.to))
        else
          printf('    %s -- %s;\n', gv_name(room.name), gv_name(child.to))
        end
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
