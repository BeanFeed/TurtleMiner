geo = peripheral.wrap("left")

local dir
local modemLoc
local scannerLoc
local picLoc
local chunkLoc

function toBlock(dis)
    turtle.select(picLoc)
    turtle.equipLeft()
    if dis.x ~= 0 then
        if dis.x < 0 then
            while dir ~= "west" do
                turnLeft()
            end
        else
            while dir ~= "east" do
                turnLeft()
            end
        end
        for i = 1, math.abs(dis.x) do
            turtle.dig()
            turtle.forward()
        end
    end

    while dis.y ~= 0 do
        if dis.y < 0 then
            turtle.digDown()
            turtle.down()
        else
            turtle.digUp()
            turtle.up()
        end
    end

    if dis.z ~= 0 then
        if dis.z < 0 then
            while dir ~= "north" do
                turnLeft()
            end
        else
            while dir ~= "south" do
                turnLeft()
            end
        end
        for i = 1, math.abs(dis.z) do
            turtle.dig()
            turtle.forward()
        end
    end
    turtle.equipLeft()
    geo = peripheral.wrap("left")
end

function getDir()
    for i = 1, 16 do
        if turtle.getItemDetail(i) == nil then
            turtle.select(i)
            turtle.equipLeft()
        end
    end

    for i = 1, 16 do
        if turtle.getItemDetail(i) == nil then
            turtle.select(i)
            turtle.equipRight()
        end
    end

    for i = 1, 16 do
        if turtle.getItemDetail(i) ~= nil then
            if string.match(turtle.getItemDetail(i).name, "modem") ~= nil then
                modemLoc = i
            end
        end
    end

    for i = 1, 16 do
        if turtle.getItemDetail(i) ~= nil then
            if string.match(turtle.getItemDetail(i).name, "geo_scanner") ~= nil then
                scannerLoc = i
            end
        end
    end

    for i = 1, 16 do
        if turtle.getItemDetail(i) ~= nil then
            if string.match(turtle.getItemDetail(i).name, "diamond_pickaxe") ~= nil then
                picLoc = i
            end
        end
    end

    for i = 1, 16 do
        if turtle.getItemDetail(i) ~= nil then
            if string.match(turtle.getItemDetail(i).name, "chunk_controller") ~= nil then
                chunkLoc = i
            end
        end
    end

    print(modemLoc)
    print(scannerLoc)
    print(picLoc)
    print(chunkLoc)
    turtle.select(chunkLoc)
    turtle.equipRight()
    turtle.select(modemLoc)
    turtle.equipLeft()

    local x1,y1,z1 = gps.locate()
    turtle.forward()
    local x2,y2,z2 = gps.locate()
    
    if x1 ~= x2 then
        if x1 < x2 then
            dir = "east"    
        else
            dir = "west"
        end
    else
        if z1 < z2 then
            dir = "south"
        else
            dir = "north"
        end
    end
    print(dir)
    turtle.select(scannerLoc)
    turtle.equipLeft()

end

function turnLeft()
    turtle.turnLeft()
    if dir == "north" then
        dir = "west"
    elseif dir == "west" then
        dir = "south"
    elseif dir == "south" then
        dir = "east"
    elseif dir == "east" then
        dir = "north"
    end
end    
--[[
function turnRight()
    turtle.turnRight()
    if dir == "north" then
        dir = "east"
    elseif dir == "east" then
        dir = "south"
    elseif dir == "south" then
        dir = "west"
    elseif dir == "west" then
        dir = "north"
    end
end
]]
getDir()
while true do
sleep(2)
targ = nil
blocks = geo.scan(8)

for key,value in pairs(blocks) do
 if value.name == "minecraft:diamond_ore" then
  if targ ~= nil then
   if (math.abs(blocks[targ].x) + math.abs(blocks[targ].z)) > (math.abs(blocks[key].x) + math.abs(blocks[key].z)) then
    targ = key
   end
  else
   targ = key
  end
 end
end
if blocks[targ] ~= nil then
print(textutils.serialise(blocks[targ].y))
local getBlock = {}
getBlock.x = blocks[targ].x
getBlock.y = blocks[targ].y
getBlock.z = blocks[targ].z
toBlock(getBlock)
else
print("No Diamonds Found")
end
end
