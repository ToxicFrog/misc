#!/usr/bin/env luajit
-- Patch tool to generate a subtitles-hacked version of Mercenaries.
-- Requires Lua 5.x or LuaJIT to run.
-- Run as `lua subtitles.lua /path/to/mercenaries.iso`. Note that it will
-- modify the iso IN-PLACE rather than creating a copy; make a backup of your
-- iso first.

-- This STRING_TABLES is for the original NTSC-U release of Mercenaries, serial
-- number SLUS-20932. If you need to support a different release, you'll need
-- to figure out the correct sizes and offsets and edit the contents of
-- STRING_TABLES accordingly.
-- It has the format [address] = size; where <address> is the offset in the ISO
-- of the .DSK file containing the subtitles, and <size> is the total size of
-- the file. You can get this information from ISO inspection tools like
-- `isodump`.
-- The DSK files can be found in the DATAPS2 directory of the ISO, and are
-- named [language].DSK, e.g. ENGLISH.DSK or FRENCH.DSK.
-- For releases that have multiple subtitle files for different languages, you
-- can add multiple entries; it will patch them all.
local STRING_TABLES = {
  -- DATAPS2/ENGLISH.DSK
  [0x09fb5f000] = 1161396;
}

local function printf(fmt, ...)
  return io.write(string.format(fmt, ...))
end

local iso = (...)
local fd = assert(io.open(iso, 'r+b'))
printf('Opened %s\n', iso)

for offset,size in pairs(STRING_TABLES) do
  assert(fd:seek('set', offset))
  printf('Reading %d bytes at 0x%x\n', size, offset)
  local buf = assert(fd:read(size))
  printf('  Applying patch:')
  local pbuf,n = buf:gsub('{%z[krc]%z}%z', ' \x00 \x00 \x00')
  assert(#buf == #pbuf, 'buffer size mismatch after patching')
  printf(' %d entries patched\n  Writing %d bytes at 0x%x\n', n, size, offset)
  assert(fd:seek('set', offset))
  assert(fd:write(pbuf))
end
printf('Closing file...')
assert(fd:close())
printf('done!\n')
