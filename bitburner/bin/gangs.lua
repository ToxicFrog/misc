local log = require "log"

local GANG_EQUIPMENT_BUDGET = 0.1

ns:disableLog("getServerMoneyAvailable")
ns:disableLog("setMemberTask")
ns:disableLog("sleep")

if not ns.gang:getGangInformation() then
  print("Not currently running a gang.")
  return
end

local function getEquipment()
  local equipment = {}
  for eqp in js.of(ns.gang:getEquipmentNames()) do
    table.insert(equipment, {
      name = eqp;
      type = ns.gang:getEquipmentType(eqp);
      cost = ns.gang:getEquipmentCost(eqp);
    })
  end
  table.sort(equipment, f'x,y=>x.cost<y.cost')
  return equipment
end

local function recruit()
  while ns.gang:canRecruitMember() do
    local name = ("SSU-%d"):format(math.random(0,2^24))
    if not ns.gang:recruitMember(name) then break end
    printf("Recruiting %s", name)
    -- ns.gang:setMemberTask(name, "Strongarm Civilians")
  end
end

local function buyGear()
  local equipment = getEquipment()
  for member in js.of(ns.gang:getMemberNames()) do
    local info = ns.gang:getMemberInformation(member)
    local ascendable = true
    for _,eqp in ipairs(equipment) do
      if eqp.cost > ns:getServerMoneyAvailable('home') * GANG_EQUIPMENT_BUDGET then
        ascendable = ascendable and eqp.type == 'Augmentation'
      elseif not info.augmentations:includes(eqp.name) and not info.equipment:includes(eqp.name) then
        log.info("Buying %s for %s (%s)", eqp.name, member, tomoney(eqp.cost))
        ns.gang:purchaseEquipment(member, eqp.name)
      end
    end
    if ascendable then
      local stats = 0
      local mults = 0
      for _,stat in ipairs { 'agility', 'defense', 'dexterity', 'strength', 'charisma' } do
        stats = stats + info[stat]/info[stat..'AscensionMult'] -- stat without asc multipliers
        mults = mults + info[stat..'AscensionMult']
      end
      stats,mults = stats/5,mults/5
      mults = (mults - 1.0)/2 + 1.0
      log.info("Ascendable: %s with stats=%.2f mults=%.2f", member, stats, mults)
      if stats >= (50 * mults) then -- increase threshold with each ascension
        printf("Ascending %s", member)
        ns.gang:ascendMember(member)
      end
    end
  end
end

local nrof_vigilantes = math.huge
local nrof_warriors = 0
local function assignJobs()
  local info = ns.gang:getGangInformation()
  local enemies = ns.gang:getOtherGangInformation()
  local members = ns.gang:getMemberNames()

  if info.wantedLevelGainRate > 0 then
    nrof_vigilantes = nrof_vigilantes + 1
  elseif info.wantedLevel < 2 then
    nrof_vigilantes = nrof_vigilantes - 1
  end
  nrof_vigilantes = nrof_vigilantes:bound(0, members.length)

  local min_chance = math.huge
  for gang in pairs(enemies) do
    if gang ~= info.faction then
      min_chance = min_chance:min(ns.gang:getChanceToWinClash(gang))
    end
  end
  if members.length < 20 then
    nrof_warriors = 0
  elseif min_chance < 0.75 then
    nrof_warriors = nrof_warriors + 1
  elseif min_chance > 0.80 then
    nrof_warriors = nrof_warriors - 1
  end
  nrof_warriors = nrof_warriors:bound(0, members.length - nrof_vigilantes)

  local job = ns:read("/run/gang.txt"):gsub("^%s+",""):gsub("%s+$","")
  if #job == 0 then job = "Mug People" end

  log.info("Vigilantes: %d -- Warriors: %d (%.2f) -- %s: %d",
    nrof_vigilantes, nrof_warriors, min_chance, job, members.length - nrof_vigilantes - nrof_warriors)

  local active_vigilantes,active_warriors = 0,0
  for member in js.of(members) do
    if active_vigilantes < nrof_vigilantes then
      ns.gang:setMemberTask(member, "Vigilante Justice")
      active_vigilantes = active_vigilantes + 1
    elseif active_warriors < nrof_warriors then
      ns.gang:setMemberTask(member, "Territory Warfare")
      active_warriors = active_warriors + 1
    else
      ns.gang:setMemberTask(member, job)
    end
  end
end

while true do
  recruit()
  buyGear()
  assignJobs()

  -- TODO: if we have lots of territory, don't enable warfare and don't assign warriors
  -- if the odds are bad, don't enable warfare and do assign warriors
  if ns.gang:getGangInformation().territory > 0.95 then
  end
  ns:sleep(5)
end
