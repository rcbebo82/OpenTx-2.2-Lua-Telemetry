--#######################################################################
--##   Script by rcbebo82
--##   Rev 0.1, Dec. 2016
--#######################################################################

-- Define your gauge scala here
local celminv = 3.46
local celmaxv = 4.26

-- Define the names of your sensors here
local liposensor1 = "Cels"
local liposensor2 = "Cel1"
local receiverVoltage = "RxBt"


-- Functions
local options = {
  { "CelMinV", VALUE, 346 }, 
  { "CelMaxV", VALUE, 426 },
  { "Cels1", SOURCE, 1 },
  { "Cels2", SOURCE, 2 }
}

-- This size is for top bar widgets
local function zoneTiny(zone)
  lcd.drawText(zone.zone.x, zone.zone.y+10, "Area too small...", LEFT + SMLSIZE + INVERS + CUSTOM_COLOR)
  return
end

--- Size is 160x30
local function zoneSmall(zone)
  lcd.drawText(zone.zone.x, zone.zone.y+10, "Area too small...", LEFT + SMLSIZE + INVERS + CUSTOM_COLOR)
  return
end

--- Size is 180x70
local function zoneMedium(zone)
  lcd.drawText(zone.zone.x, zone.zone.y+10, "Area too small...", LEFT + SMLSIZE + INVERS + CUSTOM_COLOR)
  return
end

--- Size is 190x150
local function zoneLarge(zone)
  -- Cels1
  cellResult1 = getValue(zone.options.Cels1)
  
  local pos = {{x=111, y=38}, {x=164, y=38}, {x=217, y=38}, {x=111, y=57}, {x=164, y=57}, {x=217, y=57}}
  
  for i = 1, 6, 1 do
    --lcd.drawText(zone.zone.x + 10, zone.zone.y, string.format("C%i", 1), SMLSIZE)
    --print(string.format("X=%d, Y=%d", zone.zone.x+10, zone.zone.y))
    lcd.drawText(zone.zone.x + pos[i].x+10, zone.zone.y + pos[i].y, string.format("%dV", i))
  end
  
  --FLV1voltage = 0
  --if (type(cellResult1) == "table") then  
    --for i=1, getCellCount(cellResult1), 1 do
      --lcd.drawText(zone.zone.x + 10, zone.zone.y + y, string.format("%.2f", mySensor[i]), CUSTOM_COLOR)
      --lcd.drawText(zone.zone.x + 10, zone.zone.y + 2, string.format("C%i", i), SMLSIZE)
      --lcd.drawText(zone.zone.x + pos[i].x+10, zone.zone.y + pos[i].y, string.format("%.2f", cellResult1[i]), CUSTOM_COLOR)
      
      --lcd.drawText(zone.zone.x + 30, zone.zone.y + y, "v", SMLSIZE)
      --lcd.drawNumber(zone.zone.x + 15, zone.zone.y + y, v * 100, SMLSIZE + PREC2 + LEFT)
      --lcd.drawGauge(zone.zone.x + 45, zone.zone.y + y, 26, 6, setGaugeFill(v), 100)
      
      --lcd.drawGauge(45, x, 26, 6, setGaugeFill(v), 100)
      --x = x + 10
      --FLV1voltage = FLV1voltage + v
    --end
  --else
   --   lcd.drawText(2,2, "Telemetry from sensor not available.", SMLSIZE)
  --end

  --lcd.drawText(zone.zone.x, zone.zone.y+10, CUSTOM_COLOR, LEFT + SMLSIZE)
  --lcd.drawText(zone.zone.x, zone.zone.y+30, "(Size 190x150)", LEFT + SMLSIZE + INVERS + CUSTOM_COLOR)
  return
end

--- Size is 390x170
local function zoneXLarge(zone)
  lcd.drawText(zone.zone.x, zone.zone.y+10, CUSTOM_COLOR, LEFT + SMLSIZE)
  lcd.drawText(zone.zone.x, zone.zone.y+30, "(Size 390x170)", LEFT + SMLSIZE + INVERS + CUSTOM_COLOR)
  return
end

local function create(zone, options)
  local myZone  = { zone=zone, options=options, counter=0 }
  histCellData = {}
  return myZone
end

local function update(myZone, options)
  myZone.options = options
end

local function background(myZone)
  return
end

function refresh(myZone)
  if myZone.zone.w  > 380 and myZone.zone.h > 165 then zoneXLarge(myZone)
  elseif myZone.zone.w  > 180 and myZone.zone.h > 145  then zoneLarge(myZone)
  elseif myZone.zone.w  > 170 and myZone.zone.h > 65 then zoneMedium(myZone)
  elseif myZone.zone.w  > 150 and myZone.zone.h > 28 then zoneSmall(myZone)
  elseif myZone.zone.w  > 65 and myZone.zone.h > 35 then zoneTiny(myZone)
  end
end

local function getCellCount(cellData)
  return #cellData
end

function getlowestvaluefromTable(table)
  if (type(table) == "table") then
    local key, min = 1, table[1]
    for k, v in ipairs(table) do
      if table[k] < min then
        key, min = k, v
      end
    end
    return key, min
  else
    return 0, 0
  end
end

function getTelemetryId(name)
  field = getFieldInfo(name)
  if getFieldInfo(name) then return field.id end
  return -1
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function setGaugeFill(cel)
  -- to get a good scale at the drawn gauge we have to do this 
  -- by example we want to have the gauge displaying 0 percent if the voltage drops below celminv
  -- the complete scala goes from celminv = 0% to celmaxv = 100%
  local percent = round(100 * (cel-celminv) / (celmaxv-celminv), 0)  
  if percent <= 0 then
    percent = 0
  elseif percent >= 100 then
    percent = 100
  else
    percent = percent
  end  
  return percent
end

return { name="TeleLipo", options=options, create=create, update=update, background=background, refresh=refresh }

