geo = peripheral.wrap("left")

local dir
local modemLoc
local scannerLoc
local picLoc
local chunkLoc
local chatLoc
local periphs = {'chat_box','geo_scanner','modem','diamond_pickaxe','chunk_controller'}
local wanted = {'minecraft:diamond_ore','minecraft:redstone_ore','minecraft:deepslate_diamond_ore'}

function inTable (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

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

    for i = 1, math.abs(dis.y) do
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
    turtle.select(modemLoc)
    turtle.equipLeft()
    x,y,z = gps.locate()
    turtle.equipLeft()
    turtle.select(chatLoc)
    turtle.equipLeft()
    chatty = peripheral.wrap("left")
    chatty.sendMessageToPlayer("Position: "..x .." "..y.." "..z, "BeanFeed")
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

    for i = 1, 16 do
        if turtle.getItemDetail(i) ~= nil then
            if string.match(turtle.getItemDetail(i).name, "advancedperipherals:chat_box") ~= nil then
                chatLoc = i
            end
        end
    end

    print(modemLoc)
    print(scannerLoc)
    print(picLoc)
    print(chunkLoc)
    print(chatLoc)
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
geo = peripheral.wrap("left")



while true do
    sleep(2)
    targ = nil
    blocks = geo.scan(8)

    for key,value in pairs(blocks) do
        if inTable(wanted,value.name) then
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
        
        local getBlock = {}
        getBlock.x = blocks[targ].x
        getBlock.y = blocks[targ].y
        getBlock.z = blocks[targ].z
        toBlock(getBlock)
    else
        turtle.select(picLoc)
        turtle.equipLeft()
        print("No Diamonds Found")
        for i = 1, 16 do
            turtle.dig()
            turtle.forward()
        end
        turtle.equipLeft()
        geo = peripheral.wrap("left")
    end
end
