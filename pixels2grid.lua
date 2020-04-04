#!/usr/bin/env luajit
-- Convert Colour Pixels puzzle files and graphics into Postscript charts.

require "util"

-- A puzzle entry is a string of the format:
-- Title: :XX_YY:W:H:<grid data>:ncolors:<colour data>
-- grid data is a series of colon-separated indexes into the palette, WxH wide
-- the palette is a series of 8-bit RGB triples
-- 0 is used for transparent, the palette starts at 1
-- So a very simple 3x3 grey on white + sign would be:
-- Plus: :00_00:3:3:1:2:1:2:2:2:1:2:1:2:255:255:255:128:128:128:
local function read_puzzle(data)
  local function nexts()
    local s; s,data = assert(data:match('^([^:]+):(.*)%s*$'))
    return s
  end
  local function nextn()
    return assert(tonumber(nexts()), "error converting numeric field!")
  end

  local puzzle = {
    name = assert(nexts(),nexts());
    id = nexts();
    w = nextn();
    h = nextn();
    grid = {};
    palette = {};
  }

  if puzzle.w > 72 or puzzle.h > 72 then
    -- 70x70 is probably the biggest we can reasonably hope to print on normal
    -- paper. If we go much above 128x128 the PDF conversion dies, but this might
    -- be solvable with smarter SVG generation...
    return
  end

  -- We store the grid row-major with northwest gravity since that's convenient
  -- for writing it out. However, internally, it's stored column-major.
  local grid = puzzle.grid
  for col=1,puzzle.w do
    for row=1,puzzle.h do
      grid[row] = grid[row] or {}
      grid[row][col] = nextn()
    end
  end

  local ncolours = nextn()
  for idx=1,ncolours do
    table.insert(puzzle.palette, { r=nextn(); g=nextn(); b=nextn() })
  end

  assert(data == '', "extra data at end of puzzle entry: " .. data)
  return puzzle
end

local function puzzle_info(puzzle)
  return string.format("%16s %s %3d×%-3d %3d colours",
    puzzle.name, puzzle.id, puzzle.w, puzzle.h, #puzzle.palette)
end

local function print_grid(puzzle)
  for row=1,puzzle.h do
    for col=1,puzzle.w do
      printf(" %2d", puzzle.grid[row][col])
    end
    print()
  end
end

-- Load the puzzle from the command line.
local puzzles = {}
local file,puzz = ...
local buf = io.readfile(file):match('m_Script = \"(.*)\"%s*$'):gsub('\\n', '\n'):gsub('\\r', '')
print("Reading:", file)
for data in buf:gmatch('[^\n]+') do
  local puzzle = read_puzzle(data)
  if puzzle then
    print(puzzle_info(puzzle))
    puzzles[puzzle.name] = puzzle
  end
end

local function fprintf(fd, ...)
  return fd:write(string.format(...))
end

local function tag(fd, name, content)
  return function(attrs)
    local attr_str = {}
    for name,val in pairs(attrs) do
      table.insert(attr_str, '%s="%s"' % {name:gsub('_', '-'), val})
    end
    if content then
      fprintf(fd, '<%s %s>%s</%s>\n',
        name, table.concat(attr_str, ' '), content, name)
    else
      fprintf(fd, '<%s %s />\n',
        name, table.concat(attr_str, ' '))
    end
  end
end

local function puzzleToSVG(name, puzzle, solved)
  -- Write out the puzzle grid as an SVG
  local svg = io.open(name, 'wb')
  fprintf(svg, '<!-- width:%d height:%d colours:%d -->\n', puzzle.w, puzzle.h, #puzzle.palette)

  local SCALE = 8
  local width,height = puzzle.w * SCALE, puzzle.h * SCALE
  local px,py -- starting palette x/y
  local pw,ph -- width/height of palette entries
  local pdx,pdy -- palette x/y delta

  if not solved then
    if width/height > 8.5/11 then
      -- put the palette at the bottom if it's squatter than 8.5×11
      height = height + 1.5*SCALE
      px,py = 0,height - SCALE
      pw,ph = SCALE*2,SCALE
      pdx,pdy = pw,0
    else
      width = width + 1.5*SCALE
      px,py = width - SCALE,0
      pw,ph = SCALE,SCALE*2
      pdx,pdy = 0,ph
    end
  end

  fprintf(svg, '<svg width="%d" height="%d">\n', width, height)
  tag(svg, 'rect') {
    x = 0; y = 0; width = width; height = height; stroke = 'none'; fill = '#FFF';
  }

  -- Bounding rect for the image
  -- tag(svg, 'rect') {
  --   x = 0; y = 0; width = puzzle.w*SCALE; height = puzzle.h*SCALE; stroke_width = 1; stroke = '#000'; fill='none';
  -- }

  -- Grid contents.
  for row=1,puzzle.h do
    for col=1,puzzle.w do
      -- Skip index 0 (transparent) cells
      if puzzle.grid[row][col] > 0 then
        if solved then
          local colour = puzzle.palette[puzzle.grid[row][col]]
          tag(svg, 'rect') {
            x = (col-1)*SCALE; y = (row-1)*SCALE; width = SCALE; height = SCALE;
            stroke_width = 0.1; stroke = 'none';
            fill = 'rgb(%d,%d,%d)' % { colour.r, colour.g, colour.b }
          }
        else
          tag(svg, 'rect') {
            x = (col-1)*SCALE; y = (row-1)*SCALE; width = 8; height = 8;
            stroke_width = 0.1; stroke = '#888'; fill = 'none';
          }
          tag(svg, 'text', puzzle.grid[row][col]) {
            x = (col-1)*SCALE+SCALE/2; y = (row-1)*SCALE + SCALE/2+2;
            stroke = '#444'; fill = '#FFF'; stroke_width = 0.05;
            text_anchor = 'middle'; font_size = 6; font_weight = 'bold'; font_family = 'sans-serif';
          }
        end
      end
    end
  end

  -- Palette
  if not solved then
    for n,colour in ipairs(puzzle.palette) do
      tag(svg, 'rect') {
        x = px; y = py; width = pw; height = ph; stroke_width = 1; stroke = '#000';
        fill = 'rgb(%d,%d,%d)' % { colour.r, colour.g, colour.b };
      }
      tag(svg, 'text', n) {
        x = px + pw/2; y = py + ph/2 + 2; stroke = '#000'; fill = '#FFF'; stroke_width = 0.2;
        text_anchor = 'middle'; font_size = 6; font_weight = 'bold'; font_family = 'sans-serif';
        -- style="dominant-baseline:middle;"; -- doesn't do anything
      }
      px = px + pdx
      py = py + pdy
    end
  end
  fprintf(svg, '</svg>\n')
end

if puzz then
  puzzleToSVG(puzzles[puzz].name .. '.svg', puzzles[puzz], false)
  puzzleToSVG(puzzles[puzz].name .. '-Solved.svg', puzzles[puzz], true)
  return
end

printf('Writing SVGs:')
for _,puzzle in pairs(puzzles) do
  local name = puzzle.name
  while io.exists(name..'.svg') do
    name = name.."2"
    -- printf(' \x1B[31m%s\x1B[0m', puzzle.name)
  end
  printf(' %s', name)
  puzzleToSVG(name..'.svg', puzzle, false)
  puzzleToSVG(name..'-Solved.svg', puzzle, true)
end
print()
print()
