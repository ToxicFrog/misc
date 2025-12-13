local vstruct = require 'vstruct'
require 'util'

-- Base addresses of skill table in RAM, in game executable, and in ISO/BIN.
local RAM = 0x8004B9F8
local EXE = 0x0003C1DC
local ISO = 0x0000C000 + EXE

local function exe_addr(idx) return EXE + idx * 0x34 end
local function ram_addr(idx) return RAM + idx * 0x34 end
local function iso_addr(idx) return ISO + idx * 0x34 end

-- Decoder for VS strings. Barebones, only handles ascii alphanumerics + the
-- punctuation needed for skill names.
function decode(text)
  local eof = false
  local charmap = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
  local charmap2 = { [0xB6] = 'Lv.', [0x96] = "'", [0xA7] = '-', [0x95] = '&' }
  local function aux(c)
    c = c:byte()
    if c == 0xE7 then eof = true end
    if eof then return '' end
    if c < #charmap then
      return charmap:sub(c+1,c+1)
    else
      return charmap2[c] or ('<%02X>'):format(c)
    end
  end
  -- Spaces are encoded as the two-byte pair FA 06
  return (text:gsub('.', aux):gsub('<FA>6', ' '))
end

-- Turn a targeting prerequisite ID into a textual description. There is more
-- nuance than is captured here; see "skill hitrate prereqs" on datacrystal.
local function prereq(id)
  if 1 <= id and id <= 3 then
    return 'vs. any'
  elseif id == 4 then
    return 'vs. undead'
  elseif id == 5 then
    return 'vs. living'
  elseif 6 <= id and id <= 8 then
    return 'never'
  elseif 9 <= id and id <= 25 then
    return 'status'
  elseif 34 <= id and id <= 36 then
    return 'vs. slayable'
  else
    return tostring(id)
  end
end

-- Skill hitrate calculation ID. See "skill hitrate calc" on datacrystal.
local hitrate = {
  [0] = 'nothing';
  'doublehit', 'seeking', 'normal', 'death', 'warlock', 'scan', 'chain'
}

-- "type" field in struct (not to be confused with "hit.type" which B/E/P).
-- Determines what resource the skill consumes and probably some other stuff.
local skilltypes = {
  [0] = '';
  [3] = 'spell'; -- Ashley's spells
  [4] = 'chain'; -- Ashley's chain skills and defence skills
  [5] = 'power'; -- spell-like ability e.g. breath weapons
  [7] = 'break'; -- break art, consumes HP
  [10] = 'bite'; -- basic physical attack using natural features
  [11] = 'item'; -- item use
  [12] = 'attack'; -- basic physical attack using weapon, increases risk
  [14] = 'trap'; -- used by trap panels
}

-- "type" field in hit. 0 means either "as weapon" or "untyped" depending on skill type.
local attacktypes = { [0] = 'untyped', 'blunt', 'edged', 'piercing' }
-- "affinity" field in hit.
local affinities = { [0] = 'as weapon', 'physical', 'air', 'fire', 'earth', 'water', 'light', 'dark' }
-- "effect" field in hit. For many of these the "damage" field is irrelevant
-- and only the effect matters.
local effects = {
  -- Temporary buffs and debuffs
  [ 1] = 'debuff STR';
  [ 2] = 'debuff INT';
  [ 3] = 'debuff AGL';
  [ 4] = 'debuff equipment';
  [ 6] = 'buff STR';
  [ 7] = 'buff INT';
  [ 8] = 'buff AGL';
  [ 9] = 'buff equipment';
  [10] = 'quickness';
  [11] = 'silence';
  [12] = 'ward'; -- block next spell, used by Magic Ward
  [13] = 'regen';
  [14] = 'analyze'; -- used by the Analyze spell
  [15] = 'paralyze';
  [16] = 'poison';
  [17] = 'numbness';
  [18] = 'curse';
  -- Weapon affinity modification
  [19] = 'air brand';
  [20] = 'fire brand';
  [21] = 'earth brand';
  [22] = 'water brand';
  -- Armour affinity modification
  [23] = 'air shield';
  [24] = 'fire shield';
  [25] = 'earth shield';
  [26] = 'water shield';
  -- Status cures
  [27] = 'cure paralysis';
  [28] = 'cure poison';
  [29] = 'cure curse';
  [30] = 'cure numbness';
  [31] = 'dispel magic';
  [32] = 'cure all';
  -- Miscellaneous utility effects
  [33] = 'reveal traps'; -- used by Eureka
  [34] = 'kill'; -- used by Banish/Exorcism
  [35] = 'damage DP?'; -- used by Iron Ripper & Giga Tempest
  [36] = 'stop cloudstones';
  [38] = 'destroy traps';
  [39] = 'unlock chest';
  -- Defence skills
  [40] = 'block magic 20%';
  [41] = 'block non-magic 20%';
  [42] = 'block physical 40%';
  [43] = 'block air 40%';
  [44] = 'block fire 40%';
  [45] = 'block earth 40%';
  [46] = 'block water 40%';
  [47] = 'block light 40%';
  [48] = 'block dark 40%';
  [49] = 'block using PP'; -- used by Phantom Shield
  -- Permanent stat increases, e.g. using elixirs
  [50] = 'increase STR';
  [51] = 'increase INT';
  [52] = 'increase AGL';
  [53] = 'increase max HP';
  [54] = 'increase max MP';
  -- Permanent stat decreases, not sure anything uses these
  [55] = 'reduce STR';
  [56] = 'reduce INT';
  [57] = 'reduce AGL';
  -- Damage
  [58] = 'damage HP';
  [59] = 'damage MP';
  [60] = 'attack using PP'; -- used by Phantom Pain
  [61] = 'block using PP'; -- used by Phantom Shield
  -- Restoration
  [62] = 'restore HP';
  [63] = 'restore MP';
  [64] = 'restore PP';
  [65] = 'restore DP';
  [66] = 'reduce RISK';
}

-- Struct layouts for targeting envelope data and hit characteristics.
vstruct.compile("range", [[ x:u1 y:u1 z:u1 [1| angle:u5 shape:u3 ] ]])
vstruct.compile("hit", [[
  [4| affinity:u3 type:u2 dmult:u5 damage:u6 acctype:u3 prereqs:u6 effect:u7 ]
]])

-- Struct layout for actual skill table entries.
vstruct.compile("skill", [[
{
  id:u1
  x1
  [1| targeting:u4 type:u4 ]
  cost:i1
  range:{ &range }
  aoe:{ &range }
  [2| WT:u8 x7 learned:b1 ]
  x6
  hit1:{ &hit }
  hit2:{ &hit }
  name:s24
}
]])

assert(vstruct.sizeof('&skill') == 0x34, vstruct.sizeof('&skill'))

-- Print an info line for a single hit
function hitinfo(n, hit)
  if hit.prereqs == 0 then return end
  printf('%25s %s %s, %d%s dmg, %s %s, %s\n', '-',
    hitrate[hit.acctype], prereq(hit.prereqs), hit.damage,
    hit.dmult > 0 and '×1.' .. hit.dmult or '',
    attacktypes[hit.type], affinities[hit.affinity], effects[hit.effect] or tostring(hit.effect))
end

function print_skills(skills, getaddr)
  for _,skill in ipairs(skills) do
    skill.name = decode(skill.name)
    printf('%3d $%08X [%2d]\x1B[1m%7s\x1B[0m %s\n',
      skill.id, getaddr(skill.id), skill.cost,
      skilltypes[skill.type] or tostring(skill.type), skill.name)
    hitinfo(1, skill.hit1)
    hitinfo(2, skill.hit2)
  end
end

local file = ...
local addr = EXE
local getaddr = exe_addr
if file:match('%.iso$') or file:match('%.bin$') then
  addr = ISO
  getaddr = iso_addr
end
skills = vstruct.read('@'..addr..' 256*&skill', io.open(file, 'rb'))
print_skills(skills, getaddr)