#!/usr/bin/env luajit
--[[
Tool for importing data from VGMDB into Beets.

This is meant to run as a Beets editing tool. It reads the data from beets, then
waits for you to paste the contents of the vgmdb page. It then drops you into
the actual editor to validate the results.
]]

local function printf(...)
  return print(string.format(...))
end

local function fprintf(fd, ...)
  return fd:write(string.format(...))
end

--[[ the data we get from beets looks like:
album: <album title>
albumartist: <album artist>
---
artist: <track artist>
id: N
title: <track title>
track: N
---
artist: <track artist>
id: N
title: <track title>
track: N
]]
local function read_beets(path)
  local album = { tracks = {} }
  local track = nil
  local function flush_track()
    table.insert(album.tracks, track)
    track = {}
  end
  for line in io.lines(path) do
    if line == "---" then
      flush_track()
    else
      local key,value = line:match('(.-): (.*)')
      if track then
        track[key] = value
      else
        album[key] = value
      end
    end
  end
  flush_track()
  return album
end

--[[ the data we get from vgmdb looks like:
...noise...
Discuss .* | Edit
<album title>
...noise...

Credits    ; optional, not present on all albums; values are comma-separated
Composer ...
Arranger ...
Lyricist ...
Vocals ...
Starring ...
Performer ...
Featuring ...

Tracklist

...

Disc N ...

NN title
NN title
NN title
...

Disc N ...

...

  Total tracks N
Notes
...

Album Stats
...noise...
Site code and design copyright VGMdb.net
]]
local function read_vgmdb(album)
  os.execute('stty -echo')
  local lines = io.lines()
  local function read_until(...)
    local patterns = {...}
    for line in lines do
      for _,pattern in ipairs(patterns) do
        if line:match(pattern) then return line end
      end
    end
    return nil
  end

  read_until('^Discuss.*Edit')
  album.album = lines() -- line after Discuss|Edit is the album title

  local block = read_until('^Credits$', '^Tracklist$')
  if block == 'Credits' then
    for line in lines do
      local key,value = line:match('(.-)\t(.*)')
      if key == 'Artist' then
        album.albumartist = value
      elseif not key then
        break
      end
    end
    block = read_until('^Tracklist$')
  end

  assert(block == 'Tracklist', 'No tracklist found')
  local disc = 1
  for line in lines do
    disc = line:match('^Disc (%d+)') or disc
    local track,title = line:match('^0*(%d+)%s+(.-)%s+%d+:%d+%s*$')
    if track then
      for _,trackinfo in ipairs(album.tracks) do
        if (trackinfo.disc == disc or trackinfo.disc == "0") and trackinfo.track == track then
          printf('Updating %s-%s with title: %s', disc, track, title)
          trackinfo.title = title
          track = nil
          break
        end
      end
      if track then
        printf('Warning: no match for [%s-%s %s] in [%s]', disc, track, title, album.album)
      end
    elseif line:match('^%s*Total tracks %d+') then break end
  end
  -- drain input to avoid broken pipe warnings
  for line in lines do end
  os.execute('stty echo')
  return album
end

local function write_beets(fd, album)
  for k,v in pairs(album) do
    if k ~= 'tracks' then
      fprintf(fd, '%s: %s\n', k, v)
    end
  end
  for _,track in ipairs(album.tracks) do
    fprintf(fd, '---\n')
    for k,v in pairs(track) do
      if v:match(':') then
        if not v:match('"') then v = '"'..v..'"'
        elseif not v:match("'") then v = "'"..v.."'"
        end
      end
      fprintf(fd, '%s: %s\n', k, v)
    end
  end
end

local editor,file = ...
printf('Reading beets data from %s', file)
local album = read_beets(file)
printf('Read album [%s - %s] containing %d tracks.\nPaste VGMDB data, then press ctrl-D:', album.albumartist, album.album, #album.tracks)
album = read_vgmdb(album)

do
  local fd = io.open(file, 'w')
  write_beets(fd, album)
  fd:close()
end

print('Executing: ', editor..' '..file)
os.execute(editor..' '..file)
