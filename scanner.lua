local DiscordHook = require("DiscordHook")
local success, hook = DiscordHook.createWebhook("hidden")
if not success then
    error("Webhook connection failed! Reason: " .. hook)
    exit()
end


geo = peripheral.wrap("left")
local haLoc
local dir
local modemLoc
local scannerLoc
local picLoc
local chunkLoc
local chatLoc
local run = true
local keep = {'minecraft:diamond_pickaxe','advancedperipherals:chat_box','advancedperipherals:geo_scanner','computercraft:wireless_modem_advanced','advancedperipherals:chunk_controller','minecraft:coal','minecraft:diamond','minecraft:redstone','minecraft:raw_iron','minecraft:raw_gold','minecraft:lapis_lazuli'}
local wanted = {'minecraft:diamond_ore','minecraft:deepslate_diamond_ore'}
function dumpItems()
    local highestAmount = 0
    for i = 1, 16 do
        if(turtle.getItemDetail(i) ~= nil and inTable(keep, turtle.getItemDetail(i).name) == false) then
            turtle.select(i)
            turtle.drop()
        end
    end
    haLoc = 0
    for i = 1, 16 do
        if turtle.getItemDetail(i) ~= nil and turtle.getItemDetail(i).name == "minecraft:diamond" and turtle.getItemCount(i) ~= 64 and turtle.getItemCount(i) > haLoc then
            haLoc = i
        end
    end
    if haLoc ~= 0 then
        moveDiamonds(haLoc)
    end
end
function moveDiamonds(loc)
    for i = 1, 16 do
        if turtle.getItemDetail(i) ~= nil and turtle.getItemDetail(i).name == "minecraft:diamond" and i ~= loc then
            turtle.select(i)
            turtle.transferTo(loc)
        end
    end
end
function equipItem(itemName)
    local didDrop = false
    for i = 1, 16 do
        if turtle.getItemDetail(i) == nil then
            turtle.select(i)
            turtle.equipLeft()
            didDrop = true
        end
    end
    print(didDrop)
    if didDrop == false then
        dumpItems()
    end
    for i = 1, 16 do
        if turtle.getItemDetail(i) == nil then
            turtle.select(i)
            turtle.equipLeft()
            didDrop = true
        end
    end

    if didDrop == false then
        getPLocs()
        turtle.select(modemLoc)
        turtle.equipLeft()
        x,y,z = gps.locate()
        updateDiscord("Full")
        turtle.select(chatLoc)
        turtle.equipLeft()
        chatty = peripheral.wrap("left")
        chatty.sendMessageToPlayer("Full: "..x.." "..y.." "..z, "BeanFeed")
        os.sleep(0.5)
        chatty.sendMessageToPlayer("Full: "..x.." "..y.." "..z, "Kingofmemes1020")
        print("error 2")
        exit()
    end
    for i = 1, 16 do
        if turtle.getItemDetail(i) ~= nil and string.match(turtle.getItemDetail(i).name, itemName) == itemName then
            turtle.select(i)
            turtle.equipLeft()
        end
    end
end
function goUp()
    for i = 1, 30 do
        turtle.digUp()
        turtle.up()
    end
end
function inTable (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end
function getPLocs()
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
    turtle.select(chunkLoc)
    turtle.equipRight()
end

function toBlock(dis)
    equipItem("minecraft:diamond_pickaxe")
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
    os.sleep(0.5)
    equipItem("modem")
    rednet.open("left")
    x,y,z = gps.locate()
    os.sleep(0.5)
    equipItem("chat_box")
    chatty = peripheral.wrap("left")
    chatty.sendMessageToPlayer("Position: "..x.." "..y.." "..z, "BeanFeed")
    os.sleep(0.5)
    chatty.sendMessageToPlayer("Position: "..x.." "..y.." "..z, "Kingofmemes1020")
    os.sleep(0.5)
    updateDiscord()
    print("error 1")
    equipItem("geo_scanner")
    geo = peripheral.wrap("left")
    dumpItems()
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

function updateDiscord(args)
    equipItem("modem")
    rednet.open("left")
    x,y,z = gps.locate()
    print(x..y..z)
    turtle.equipLeft()
    if args == nil then
        hook.send("Postion [X: "..x..", Y: "..y..", Z: "..z.."], Fuel Level: "..turtle.getFuelLevel())
    else
        if args == "Full" then
            hook.send("@BeanFeed @Jerrry Full!! Postion [X: "..x..", Y: "..y..", Z: "..z.."], Fuel Level: "..turtle.getFuelLevel())
    
        end
    end
end

function tryRefuel()
    for i = 1, 16 do
        if(turtle.getItemDetail(i) ~= nil and turtle.getItemDetail(i).name == 'minecraft:coal') then
            turtle.select(i)
            turtle.refuel()
            print("Refuel Success")
        end
    end
    phoneHome()
    print("Phone Home")
end

function phoneHome()
    equipItem("modem")
    rednet.open("left")
    x,y,z = gps.locate()
    equipItem("chat_box")
    chatty = peripheral.wrap("left")
    chatty.sendMessageToPlayer("Out Of Fuel At: "..x.." "..y.." "..z,"BeanFeed")
    os.sleep(0.5)
    chatty.sendMessageToPlayer("Out Of Fuel At: "..x.." "..y.." "..z,"Kingofmemes1020")
    updateDiscord()
    run = false
    exit()
end

while run do
    sleep(2)
    targ = nil
    blocks = geo.scan(8)
    if(turtle.getFuelLevel() < 1)then
        tryRefuel()
        print("Try Refuel")
    end
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
        dumpItems()
        equipItem("minecraft:diamond_pickaxe")
        toBlock(getBlock)
    else
        updateDiscord()
        equipItem("minecraft:diamond_pickaxe")
        print("No Diamonds Found")
        for i = 1, 16 do
            turtle.dig()
            turtle.forward()
    end
    equipItem("modem")
    rednet.open("left")
    x,y,z = gps.locate()
    if y <= -50 then
        goUp()
    end
    equipItem("scanner")
    geo = peripheral.wrap("left")
    end
end
