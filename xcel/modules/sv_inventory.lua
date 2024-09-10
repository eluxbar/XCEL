MySQL = module("modules/MySQL")

local Inventory = module("xcel-vehicles", "cfg/cfg_inventory")
local Housing = module("xcel", "cfg/cfg_housing")
local InventorySpamTrack = {}
local LootBagEntities = {}
local InventoryCoolDown = {}
local a = module("cfg/weapons")
local AmmoItems = {
    ["9mm Bullets"] = true,
    ["12 Gauge Bullets"] = true,
    [".308 Sniper Rounds"] = true,
    ["7.62mm Bullets"] = true,
    ["5.56mm NATO"] = true,
    [".357 Bullets"] = true,
    ["Police Issued 5.56mm"] = true,
    ["Police Issued .308 Sniper Rounds"] = true,
    ["Police Issued 9mm"] = true,
    ["Police Issued 12 Gauge"] = true
}

AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if not InventorySpamTrack[source] then
            InventorySpamTrack[source] = true;
            local user_id = XCEL.getUserId(source) 
            local data = XCEL.getUserDataTable(user_id)
            if data and data.inventory then
                local FormattedInventoryData = {}
                for i,v in pairs(data.inventory) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                end
                TriggerClientEvent('XCEL:FetchPersonalInventory', source, FormattedInventoryData, XCEL.computeItemsWeight(data.inventory), XCEL.getInventoryMaxWeight(user_id))
                InventorySpamTrack[source] = false;
            else 
                --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
            end
        end
    end
end)

RegisterNetEvent('XCEL:FetchPersonalInventory')
AddEventHandler('XCEL:FetchPersonalInventory', function()
    local source = source
    if not InventorySpamTrack[source] then
        InventorySpamTrack[source] = true;
        local user_id = XCEL.getUserId(source) 
        local data = XCEL.getUserDataTable(user_id)
        if data and data.inventory then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
            end
            TriggerClientEvent('XCEL:FetchPersonalInventory', source, FormattedInventoryData, XCEL.computeItemsWeight(data.inventory), XCEL.getInventoryMaxWeight(user_id))
            InventorySpamTrack[source] = false;
        else 
            --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
        end
    end
end)


AddEventHandler('XCEL:RefreshInventory', function(source)
    local user_id = XCEL.getUserId(source) 
    local data = XCEL.getUserDataTable(user_id)
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
        end
        TriggerClientEvent('XCEL:FetchPersonalInventory', source, FormattedInventoryData, XCEL.computeItemsWeight(data.inventory), XCEL.getInventoryMaxWeight(user_id))
        InventorySpamTrack[source] = false;
    else 
        --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)

RegisterNetEvent('XCEL:GiveItem')
AddEventHandler('XCEL:GiveItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  XCELclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        XCEL.RunGiveTask(source, itemId)
        TriggerEvent('XCEL:RefreshInventory', source)
    else
        XCELclient.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)
RegisterNetEvent('XCEL:GiveItemAll')
AddEventHandler('XCEL:GiveItemAll', function(itemId, itemLoc)
    local source = source
    if not itemId then  XCELclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        XCEL.RunGiveAllTask(source, itemId)
        TriggerEvent('XCEL:RefreshInventory', source)
    else
        XCELclient.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)

RegisterNetEvent('XCEL:TrashItem')
AddEventHandler('XCEL:TrashItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  XCELclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        XCEL.RunTrashTask(source, itemId)
        TriggerEvent('XCEL:RefreshInventory', source)
    else
        XCELclient.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
end)

RegisterNetEvent('XCEL:FetchTrunkInventory')
AddEventHandler('XCEL:FetchTrunkInventory', function(spawnCode)
    local source = source
    local user_id = XCEL.getUserId(source)
    if InventoryCoolDown[source] then XCELclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    XCEL.getSData(carformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
        TriggerEvent('XCEL:RefreshInventory', source)
    end)
end)


RegisterNetEvent('XCEL:viewTrunk')
AddEventHandler('XCEL:viewTrunk', function(spawnCode)
    local source = source
    local user_id = XCEL.getUserId(source)
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    XCEL.getSData(carformat, function(cdata)
        cdata = json.decode(cdata) or {}
        local AmmoTable = {}
        local OtherTable = {}
        local WeaponTable = {}
        
        for i, v in pairs(cdata) do
            local itemName = XCEL.getItemName(i)
            if string.find(i, "wbody") then
                table.insert(WeaponTable, {
                    amount = v.amount,
                    WeaponName = itemName
                })
            elseif AmmoItems[itemName] then
                table.insert(AmmoTable, {
                    amount = v.amount,
                    AmmoName = itemName
                })
            else
                table.insert(OtherTable, {
                    amount = v.amount,
                    ItemName = itemName
                })
            end
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        local totalWeight = XCEL.computeItemsWeight(cdata)
        
        local viewTrunk = {
            Ammo = AmmoTable,
            Weapons = WeaponTable,
            Other = OtherTable,
        }
        
        TriggerClientEvent("XCEL:ReturnFetchedCarsBoot", source, viewTrunk)
    end)
end)



RegisterNetEvent('XCEL:WipeBoot')
AddEventHandler('XCEL:WipeBoot', function(spawnCode)
    local source = source
    local user_id = XCEL.getUserId(source)
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    XCEL.prompt(source, "Please replace text with YES or NO to confirm", "Wipe Boot For Vehicle: " .. spawnCode, function(source, wipeboot)
        if string.upper(wipeboot) == 'YES' then
            XCEL.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                for i, v in pairs(cdata) do
                    cdata[i] = nil
                end
                XCEL.setSData(carformat, json.encode(cdata))
                TriggerEvent('XCEL:RefreshInventory', source)
                XCELclient.notify(source, {'~g~You have wiped the boot of this vehicle.'})
            end)
        else
            XCELclient.notify(source, {'~r~You did not confirm the wipe.'})
        end
    end)
end)








local inHouse = {}
RegisterNetEvent('XCEL:FetchHouseInventory')
AddEventHandler('XCEL:FetchHouseInventory', function(nameHouse)
    local source = source
    local user_id = XCEL.getUserId(source)
    getUserByAddress(nameHouse, 1, function(huser_id)
        if huser_id == user_id then
            inHouse[user_id] = nameHouse
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            XCEL.getSData(homeformat, function(cdata)
                local processedChest = {};
                cdata = json.decode(cdata) or {}
                local FormattedInventoryData = {}
                for i, v in pairs(cdata) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                end
                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
            end)
        else
            XCELclient.notify(player,{"~r~You do not own this house!"})
        end
    end)
end)

local currentlySearching = {}

RegisterNetEvent('XCEL:cancelPlayerSearch')
AddEventHandler('XCEL:cancelPlayerSearch', function()
    local source = source
    local user_id = XCEL.getUserId(source) 
    if currentlySearching[user_id] ~= nil then
        TriggerClientEvent('XCEL:cancelPlayerSearch', currentlySearching[user_id])
    end
end)

RegisterNetEvent('XCEL:searchPlayer')
AddEventHandler('XCEL:searchPlayer', function(playersrc)
    local source = source
    local user_id = XCEL.getUserId(source) 
    local data = XCEL.getUserDataTable(user_id)
    local their_id = XCEL.getUserId(playersrc) 
    local their_data = XCEL.getUserDataTable(their_id)
    if data and data.inventory and not currentlySearching[user_id] then
        currentlySearching[user_id] = playersrc
        TriggerClientEvent('XCEL:startSearchingSuspect', source)
        TriggerClientEvent('XCEL:startBeingSearching', playersrc, source)
        XCELclient.notify(playersrc, {'~b~You are being searched.'})
        Wait(5000)
        if currentlySearching[user_id] then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
            end
            exports['xcel']:execute("SELECT * FROM xcel_subscriptions WHERE user_id = @user_id", {user_id = user_id}, function(vipClubData)
                if #vipClubData > 0 then
                    if their_data and their_data.inventory then
                        local FormattedSecondaryInventoryData = {}
                        for i,v in pairs(their_data.inventory) do
                            FormattedSecondaryInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                        end
                        if XCEL.getMoney(their_id) then
                            FormattedSecondaryInventoryData['cash'] = {amount = XCEL.getMoney(their_id), ItemName = 'Cash', Weight = 0.00}
                        end
                        TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedSecondaryInventoryData, XCEL.computeItemsWeight(their_data.inventory), 200)
                    end
                    if vipClubData[1].plathours > 0 then
                        TriggerClientEvent('XCEL:FetchPersonalInventory', source, FormattedInventoryData, XCEL.computeItemsWeight(data.inventory), XCEL.getInventoryMaxWeight(user_id)+20)
                    elseif vipClubData[1].plushours > 0 then
                        TriggerClientEvent('XCEL:FetchPersonalInventory', source, FormattedInventoryData, XCEL.computeItemsWeight(data.inventory), XCEL.getInventoryMaxWeight(user_id)+10)
                    else
                        TriggerClientEvent('XCEL:FetchPersonalInventory', source, FormattedInventoryData, XCEL.computeItemsWeight(data.inventory), XCEL.getInventoryMaxWeight(user_id))
                    end
                    TriggerClientEvent('XCEL:InventoryOpen', source, true)
                    currentlySearching[user_id] = nil
                end
            end)
        end
    end
end)

RegisterNetEvent('XCEL:robPlayer')
AddEventHandler('XCEL:robPlayer', function(playersrc)
    local source = source
    XCELclient.isPlayerSurrendered(playersrc, {}, function(is_surrendering) 
        if is_surrendering then
            if not InventorySpamTrack[source] then
                InventorySpamTrack[source] = true;
                local user_id = XCEL.getUserId(source) 
                local data = XCEL.getUserDataTable(user_id)
                local their_id = XCEL.getUserId(playersrc) 
                local their_data = XCEL.getUserDataTable(their_id)
                if data and data.inventory then
                    local FormattedInventoryData = {}
                    for i,v in pairs(data.inventory) do
                        FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                    end
                    exports['xcel']:execute("SELECT * FROM xcel_subscriptions WHERE user_id = @user_id", {user_id = user_id}, function(vipClubData)
                        if #vipClubData > 0 then
                            if their_data and their_data.inventory then
                                local FormattedSecondaryInventoryData = {}
                                for i,v in pairs(their_data.inventory) do
                                    XCEL.giveInventoryItem(user_id, i, v.amount)
                                    XCEL.tryGetInventoryItem(their_id, i, v.amount)
                                end
                            end
                            if XCEL.getMoney(their_id) > 0 then
                                XCEL.giveMoney(user_id, XCEL.getMoney(their_id))
                                XCEL.tryPayment(their_id, XCEL.getMoney(their_id))
                            end
                            if vipClubData[1].plathours > 0 then
                                TriggerClientEvent('XCEL:FetchPersonalInventory', source, FormattedInventoryData, XCEL.computeItemsWeight(data.inventory), XCEL.getInventoryMaxWeight(user_id)+20)
                            elseif vipClubData[1].plushours > 0 then
                                TriggerClientEvent('XCEL:FetchPersonalInventory', source, FormattedInventoryData, XCEL.computeItemsWeight(data.inventory), XCEL.getInventoryMaxWeight(user_id)+10)
                            else
                                TriggerClientEvent('XCEL:FetchPersonalInventory', source, FormattedInventoryData, XCEL.computeItemsWeight(data.inventory), XCEL.getInventoryMaxWeight(user_id))
                            end
                            TriggerClientEvent('XCEL:InventoryOpen', source, true)
                            InventorySpamTrack[source] = false;
                        end
                    end)
                else 
                    --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
                end
            end
        end
    end)
end)
RegisterNetEvent('XCEL:UseItem')
AddEventHandler('XCEL:UseItem', function(itemId, itemLoc)
    local source = source
    local user_id = XCEL.getUserId(source) 
    local data = XCEL.getUserDataTable(user_id)
    if not itemId then XCELclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        XCEL.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                local invcap = 30
                if plathours > 0 then
                    invcap = 50
                elseif plushours > 0 then
                    invcap = 40
                end
                if XCEL.getInventoryMaxWeight(user_id) ~= nil then
                    if XCEL.getInventoryMaxWeight(user_id) > invcap then
                        return
                    end
                end
                if itemId == "offwhitebag" then
                    XCEL.tryGetInventoryItem(user_id, itemId, 1, true)
                    XCEL.updateInvCap(user_id, invcap+15)
                    TriggerClientEvent('XCEL:boughtBackpack', source, 5, 92, 0,40000,15, 'Off White Bag (+15kg)')
                elseif itemId == "guccibag" then 
                    XCEL.tryGetInventoryItem(user_id, itemId, 1, true)
                    XCEL.updateInvCap(user_id, invcap+20)
                    TriggerClientEvent('XCEL:boughtBackpack', source, 5, 94, 0,60000,20, 'Gucci Bag (+20kg)')
                elseif itemId == "nikebag" then 
                    XCEL.tryGetInventoryItem(user_id, itemId, 1, true)
                    XCEL.updateInvCap(user_id, invcap+30)
                elseif itemId == "huntingbackpack" then 
                    XCEL.tryGetInventoryItem(user_id, itemId, 1, true)
                    XCEL.updateInvCap(user_id, invcap+35)
                    TriggerClientEvent('XCEL:boughtBackpack', source, 5, 91, 0,100000,35, 'Hunting Backpack (+35kg)')
                elseif itemId == "greenhikingbackpack" then 
                    XCEL.tryGetInventoryItem(user_id, itemId, 1, true)
                    XCEL.updateInvCap(user_id, invcap+40)
                elseif itemId == "rebelbackpack" then 
                    XCEL.tryGetInventoryItem(user_id, itemId, 1, true)
                    XCEL.updateInvCap(user_id, invcap+70)
                    TriggerClientEvent('XCEL:boughtBackpack', source, 5, 90, 0,250000,70, 'Rebel Backpack (+70kg)')
                elseif itemId == "Shaver" then 
                    XCEL.ShaveHead(source)
                elseif itemId == "handcuffkeys" then 
                    XCEL.handcuffKeys(source)
                elseif itemId == "armourplate" or itemId == "pd_armourplate" then 
                    XCEL.ArmourPlate(source)
                end
                TriggerEvent('XCEL:RefreshInventory', source)
            end
        end)  
    end
    if itemLoc == "Plr" then
        XCEL.RunInventoryTask(source, itemId)
        TriggerEvent('XCEL:RefreshInventory', source)
    else
        XCELclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)

RegisterNetEvent('XCEL:UseAllItem')
AddEventHandler('XCEL:UseAllItem', function(itemId, itemLoc)
    local source = source
    local user_id = XCEL.getUserId(source) 
    if not itemId then XCELclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        XCEL.LoadAllTask(source, itemId)
        TriggerEvent('XCEL:RefreshInventory', source)
    else
        XCELclient.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)


RegisterNetEvent('XCEL:MoveItem')
AddEventHandler('XCEL:MoveItem', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local user_id = XCEL.getUserId(source) 
    local data = XCEL.getUserDataTable(user_id)
    if XCEL.isPurge() then return end
    if InventoryCoolDown[source] then XCELclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if not itemId then XCELclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
            XCEL.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount >= 1 then
                    local weightCalculation = XCEL.getInventoryWeight(user_id)+XCEL.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= XCEL.getInventoryMaxWeight(user_id) then
                        if cdata[itemId].amount > 1 then
                            cdata[itemId].amount = cdata[itemId].amount - 1; 
                            XCEL.giveInventoryItem(user_id, itemId, 1, true)
                        else 
                            cdata[itemId] = nil;
                            XCEL.giveInventoryItem(user_id, itemId, 1, true)
                        end 
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('XCEL:RefreshInventory', source)
                        InventoryCoolDown[source] = false;
                        XCEL.setSData(carformat, json.encode(cdata))
                    else 
                        InventoryCoolDown[source] = false;
                        XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    InventoryCoolDown[source] = false;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end)
        elseif inventoryType == "LootBag" then  
            if itemId ~= nil then  
                if LootBagEntities[inventoryInfo] and LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = XCEL.getInventoryWeight(user_id)+XCEL.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= XCEL.getInventoryMaxWeight(user_id) then
                        if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > 1 then
                            LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - 1 
                            XCEL.giveInventoryItem(user_id, itemId, 1, true)
                        else 
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            XCEL.giveInventoryItem(user_id, itemId, 1, true)
                        end
                        local FormattedInventoryData = {}
                        for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                        end
                        local maxVehKg = 200
                        TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                        TriggerEvent('XCEL:RefreshInventory', source)
                        InventoryCoolDown[source] = false
                        if not next(LootBagEntities[inventoryInfo].Items) then
                            CloseInv(source)
                        end
                    else 
                        XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end
        elseif inventoryType == "Housing" then
            InventoryCoolDown[source] = true
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            XCEL.getSData(homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount >= 1 then
                    local weightCalculation = XCEL.getInventoryWeight(user_id)+XCEL.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= XCEL.getInventoryMaxWeight(user_id) then
                        if cdata[itemId].amount > 1 then
                            cdata[itemId].amount = cdata[itemId].amount - 1; 
                            XCEL.giveInventoryItem(user_id, itemId, 1, true)
                        else 
                            cdata[itemId] = nil;
                            XCEL.giveInventoryItem(user_id, itemId, 1, true)
                        end 
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                        end
                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                        TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('XCEL:RefreshInventory', source)
                        InventoryCoolDown[source] = false;
                        XCEL.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                    else 
                        XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the home.')
                end
            end)
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitem)
                        local homeFormat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                        XCEL.getSData(homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = XCEL.computeItemsWeight(cdata)+XCEL.getItemWeight(itemId)
                                if weightCalculation == nil then return end
                                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                if weightCalculation <= maxVehKg then
                                    if XCEL.tryGetInventoryItem(user_id, itemId, 1, true) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                                    end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('XCEL:RefreshInventory', source)
                                    XCEL.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                                    InventoryCoolDown[source] = false;
                                else 
                                    XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the home.')
                            end
                        end) --end of housing intergration (moveitem)
                    else
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                        XCEL.getSData(carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = XCEL.computeItemsWeight(cdata)+XCEL.getItemWeight(itemId)
                                if weightCalculation == nil then return end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if XCEL.tryGetInventoryItem(user_id, itemId, 1, true) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('XCEL:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    XCEL.setSData(carformat, json.encode(cdata))
                                else 
                                    InventoryCoolDown[source] = nil;
                                    XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                            end
                        end)
                    end
                else
                    InventoryCoolDown[source] = nil;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
        --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)



RegisterNetEvent('XCEL:MoveItemX')
AddEventHandler('XCEL:MoveItemX', function(inventoryType, itemId, inventoryInfo, Lootbag, Quantity)
    local source = source
    local user_id = XCEL.getUserId(source) 
    local data = XCEL.getUserDataTable(user_id)
    if XCEL.isPurge() then return end
    if InventoryCoolDown[source] then XCELclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if not itemId then  XCELclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            if Quantity >= 1 then
                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                XCEL.getSData(carformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                        local weightCalculation = XCEL.getInventoryWeight(user_id)+(XCEL.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= XCEL.getInventoryMaxWeight(user_id) then
                            if cdata[itemId].amount > Quantity then
                                cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                XCEL.giveInventoryItem(user_id, itemId, Quantity, true)
                            else 
                                cdata[itemId] = nil;
                                XCEL.giveInventoryItem(user_id, itemId, Quantity, true)
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                            end
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('XCEL:RefreshInventory', source)
                            InventoryCoolDown[source] = nil;
                            XCEL.setSData(carformat, json.encode(cdata))
                        else 
                            InventoryCoolDown[source] = nil;
                            XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        InventoryCoolDown[source] = nil;
                        XCELclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end
                end)
            else
                InventoryCoolDown[source] = nil;
                XCELclient.notify(source, {'~r~Invalid Amount!'})
            end
        elseif inventoryType == "LootBag" then    
            if itemId and LootBagEntities[inventoryInfo] then
                -- Check if Items field exists and contains the itemId
                if LootBagEntities[inventoryInfo].Items and LootBagEntities[inventoryInfo].Items[itemId] then
                    Quantity = parseInt(Quantity)
                    if Quantity then
                        local weightCalculation = XCEL.getInventoryWeight(user_id) + (XCEL.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= XCEL.getInventoryMaxWeight(user_id) then
                            if Quantity <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                                if LootBagEntities[inventoryInfo].Items[itemId].amount > Quantity then
                                    LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - Quantity
                                    XCEL.giveInventoryItem(user_id, itemId, Quantity, true)
                                else 
                                    LootBagEntities[inventoryInfo].Items[itemId] = nil
                                    XCEL.giveInventoryItem(user_id, itemId, Quantity, true)
                                end
                                local FormattedInventoryData = {}
                                for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                                end
                                local maxVehKg = 200
                                TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                                TriggerEvent('XCEL:RefreshInventory', source)
                                if not next(LootBagEntities[inventoryInfo].Items) then
                                    CloseInv(source)
                                end
                            else 
                                XCELclient.notify(source, {'~r~You are trying to move more than there actually is!'})
                            end 
                        else 
                            XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        XCELclient.notify(source, {'~r~Invalid input!'})
                    end
                else
                    -- Add an appropriate action or notification when the condition fails
                    print("Item or LootBagEntities inventory info not found.")
                end
            end
        
        elseif inventoryType == "Housing" then
            Quantity = parseInt(Quantity)
            if Quantity then
                local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                XCEL.getSData(homeformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                        local weightCalculation = XCEL.getInventoryWeight(user_id)+(XCEL.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= XCEL.getInventoryMaxWeight(user_id) then
                            if cdata[itemId].amount > Quantity then
                                cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                XCEL.giveInventoryItem(user_id, itemId, Quantity, true)
                            else 
                                cdata[itemId] = nil;
                                XCEL.giveInventoryItem(user_id, itemId, Quantity, true)
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                            end
                            local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                            TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('XCEL:RefreshInventory', source)
                            XCEL.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                            InventoryCoolDown[source] = false;
                        else 
                            XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        XCELclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end
                end)
            else 
                XCELclient.notify(source, {'~r~Invalid input!'})
            end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitemx)
                        Quantity = parseInt(Quantity)
                        if Quantity then
                            local homeFormat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                            XCEL.getSData(homeFormat, function(cdata)
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                    local weightCalculation = XCEL.computeItemsWeight(cdata)+(XCEL.getItemWeight(itemId) * Quantity)
                                    if weightCalculation == nil then return end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    if weightCalculation <= maxVehKg then
                                        if XCEL.tryGetInventoryItem(user_id, itemId, Quantity, true) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + Quantity
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = Quantity
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                                        end
                                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                        TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
                                        TriggerEvent('XCEL:RefreshInventory', source)
                                        XCEL.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                                        InventoryCoolDown[source] = false;
                                    else 
                                        XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    XCELclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end)
                        else 
                            XCELclient.notify(source, {'~r~Invalid input!'})
                        end
                    else
                        InventoryCoolDown[source] = true;
                        Quantity = parseInt(Quantity)
                        if Quantity then
                            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                            XCEL.getSData(carformat, function(cdata)
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                    local weightCalculation = XCEL.computeItemsWeight(cdata)+(XCEL.getItemWeight(itemId) * Quantity)
                                    if weightCalculation == nil then return end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    if weightCalculation <= maxVehKg then
                                        if XCEL.tryGetInventoryItem(user_id, itemId, Quantity, true) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + Quantity
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = Quantity
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                                        end
                                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                        TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
                                        TriggerEvent('XCEL:RefreshInventory', source)
                                        InventoryCoolDown[source] = nil;
                                        XCEL.setSData(carformat, json.encode(cdata))
                                    else 
                                        InventoryCoolDown[source] = nil;
                                        XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    InventoryCoolDown[source] = nil;
                                    XCELclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end)
                        else 
                            XCELclient.notify(source, {'~r~Invalid input!'})
                        end
                    end
                else
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)


RegisterNetEvent('XCEL:MoveItemAll')
AddEventHandler('XCEL:MoveItemAll', function(inventoryType, itemId, inventoryInfo, vehid)
    local source = source
    local user_id = XCEL.getUserId(source) 
    local data = XCEL.getUserDataTable(user_id)
    if XCEL.isPurge() then return end
    if not itemId then XCELclient.notify(source, {'~r~You need to select an item, first!'}) return end
    if InventoryCoolDown[source] then XCELclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local idz = NetworkGetEntityFromNetworkId(vehid)
            if DoesEntityExist(idz) then
                local user_id = XCEL.getUserId(NetworkGetEntityOwner(idz))
                if user_id then
                    local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                    XCEL.getSData(carformat, function(cdata)
                        cdata = json.decode(cdata) or {}
                        if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                            local weightCalculation = XCEL.getInventoryWeight(user_id)+(XCEL.getItemWeight(itemId) * cdata[itemId].amount)
                            if weightCalculation == nil then return end
                            local amount = cdata[itemId].amount
                            if weightCalculation > XCEL.getInventoryMaxWeight(user_id) and XCEL.getInventoryWeight(user_id) ~= XCEL.getInventoryMaxWeight(user_id) then
                                amount = math.floor((XCEL.getInventoryMaxWeight(user_id)-XCEL.getInventoryWeight(user_id)) / XCEL.getItemWeight(itemId))
                            end
                            if math.floor(amount) > 0 or (weightCalculation <= XCEL.getInventoryMaxWeight(user_id)) then
                                XCEL.giveInventoryItem(user_id, itemId, amount, true)
                                local FormattedInventoryData = {}
                                if (cdata[itemId].amount - amount) > 0 then
                                    cdata[itemId].amount = cdata[itemId].amount - amount
                                else
                                    cdata[itemId] = nil
                                end
                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                                end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
                                TriggerEvent('XCEL:RefreshInventory', source)
                                InventoryCoolDown[source] = nil;
                                XCEL.setSData(carformat, json.encode(cdata))
                            else 
                                InventoryCoolDown[source] = nil;
                                XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                            end
                        else 
                            InventoryCoolDown[source] = nil;
                            XCELclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end
                    end)
                end
            end
        elseif inventoryType == "LootBag" then
            if itemId and LootBagEntities[inventoryInfo] then
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = XCEL.getInventoryWeight(user_id)+(XCEL.getItemWeight(itemId) *  LootBagEntities[inventoryInfo].Items[itemId].amount)
                    if weightCalculation == nil then return end
                    if weightCalculation <= XCEL.getInventoryMaxWeight(user_id) then
                        if  LootBagEntities[inventoryInfo].Items[itemId].amount <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                            XCEL.giveInventoryItem(user_id, itemId, LootBagEntities[inventoryInfo].Items[itemId].amount, true)
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            local FormattedInventoryData = {}
                            for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                            end
                            local maxVehKg = 200
                            TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                            TriggerEvent('XCEL:RefreshInventory', source)
                            if not next(LootBagEntities[inventoryInfo].Items) then
                                CloseInv(source)
                            end
                        else 
                            XCELclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end 
                    else 
                        XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end
        elseif inventoryType == "Housing" then
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            XCEL.getSData(homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = XCEL.getInventoryWeight(user_id)+(XCEL.getItemWeight(itemId) * cdata[itemId].amount)
                    if weightCalculation == nil then return end
                    if weightCalculation <= XCEL.getInventoryMaxWeight(user_id) then
                        XCEL.giveInventoryItem(user_id, itemId, cdata[itemId].amount, true)
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                        end
                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                        TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('XCEL:RefreshInventory', source)
                        XCEL.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                    else 
                        XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    XCELclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end)
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then
                        local homeFormat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                        XCEL.getSData(homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local itemAmount = data.inventory[itemId].amount
                                local weightCalculation = XCEL.computeItemsWeight(cdata)+(XCEL.getItemWeight(itemId) * itemAmount)
                                if weightCalculation == nil then return end
                                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                if weightCalculation <= maxVehKg then
                                    if XCEL.tryGetInventoryItem(user_id, itemId, itemAmount, true) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + itemAmount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = itemAmount
                                        end 
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                                    end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('XCEL:RefreshInventory', source)
                                    XCEL.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                                else 
                                    XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                XCELclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end) --end of housing intergration (moveitemall)
                    else 
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                        XCEL.getSData(carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local itemAmount = data.inventory[itemId].amount
                                local weightCalculation = XCEL.computeItemsWeight(cdata)+(XCEL.getItemWeight(itemId) * itemAmount)
                                if weightCalculation == nil then return end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if XCEL.tryGetInventoryItem(user_id, itemId, itemAmount, true) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + itemAmount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = itemAmount
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('XCEL:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    XCEL.setSData(carformat, json.encode(cdata))
                                else 
                                    InventoryCoolDown[source] = nil;
                                    XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                XCELclient.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end)
                    end
                else
                    InventoryCoolDown[source] = nil;
                    --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This is usually caused by cheating as the item does not exist in the car boot.')
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
        --print('An error has occured while trying to move an item. Inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
end)

-- LOOTBAGS CODE BELOW HERE 

RegisterNetEvent('XCEL:InComa')
AddEventHandler('XCEL:InComa', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.inArena(source) or XCEL.inWager(source) then return end
    XCELclient.isInComa(source, {}, function(in_coma) 
        if in_coma then
            Wait(1500)
            local weight = XCEL.getInventoryWeight(user_id)
            if weight == 0 then return end
            local model = `xs_prop_arena_bag_01`
            local name1 = XCEL.GetPlayerName(user_id)
            local position = GetEntityCoords(GetPlayerPed(source)) + vector3(0.0, 0.0, 0.00) -- do not edit. 
            local lootbag = CreateObjectNoOffset(model, position.x, position.y, position.z, true, true, false)
            local lootbagnetid = NetworkGetNetworkIdFromEntity(lootbag)
            SetEntityRoutingBucket(lootbag, GetPlayerRoutingBucket(source))
            local ndata = XCEL.getUserDataTable(user_id)
            local stored_inventory = nil;
            TriggerEvent('XCEL:StoreWeaponsRequest', source)
            LootBagEntities[lootbagnetid] = {lootbag, lootbag, false, source}
            LootBagEntities[lootbagnetid].Items = {}
            LootBagEntities[lootbagnetid].name = name1 
            if ndata ~= nil then
                if ndata.inventory ~= nil then
                    stored_inventory = ndata.inventory
                    XCEL.clearInventory(user_id)
                    for k, v in pairs(stored_inventory) do
                        LootBagEntities[lootbagnetid].Items[k] = {}
                        LootBagEntities[lootbagnetid].Items[k].amount = v.amount
                    end
                end
            end
        end
    end)
end)

local alreadyEquiping = {}
local EquipBullets = {
    [".357 Bullets"] = true,
    ["12 Gauge Bullets"] = true,
    ["5.56mm NATO"] = true,
    ["7.62mm Bullets"] = true,
    ["9mm Bullets"] = true,
    [".308 Sniper Rounds"] = true,
    ["Police Issued 5.56mm"] = true,
    ["Police Issued 9mm"] = true,
    ["Police Issued .308 Sniper Rounds"] = true,
    ["Police Issued 12 Gauge"] = true,
}


RegisterNetEvent('XCEL:EquipAll')
AddEventHandler('XCEL:EquipAll', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    
    if alreadyEquiping[user_id] then
        XCELclient.notify(source, {'~r~You are already equipping all items'})
        return
    end
    
    alreadyEquiping[user_id] = true
    local data = XCEL.getUserDataTable(user_id)
    local sortedTable = {}
    
    for item, _ in pairs(data.inventory) do
        if string.find(item, 'wbody|') or EquipBullets[item] then
            table.insert(sortedTable, item)
        end
    end
    
    table.sort(sortedTable, function(a, b)
        local aIsWeapon = string.find(a, 'wbody|')
        local bIsWeapon = string.find(b, 'wbody|')
        
        if aIsWeapon and bIsWeapon then
            return a < b
        elseif aIsWeapon then
            return true
        elseif bIsWeapon then
            return false
        else
            return a < b
        end
    end)
    
    for _, item in ipairs(sortedTable) do
        if string.find(item:lower(), 'wbody|') then
            XCEL.RunInventoryTask(source, item)
        elseif EquipBullets[item] then
            XCEL.LoadAllTask(source, item)
        end
        Wait(500)
    end
    
    TriggerEvent('XCEL:RefreshInventory', source)
    alreadyEquiping[user_id] = false
end)

local alreadyTransfering = {}
RegisterNetEvent("XCEL:TransferAll")
AddEventHandler("XCEL:TransferAll", function(spawncode)
    local source = source
    local user_id = XCEL.getUserId(source)
    if not alreadyTransfering[user_id] then
        alreadyTransfering[user_id] = true
        local inventory = XCEL.getUserDataTable(user_id).inventory
        local carformat = "chest:u1veh_" .. spawncode .. "|" .. user_id
        local maxVehKg = Inventory.vehicle_chest_weights[spawncode] or Inventory.default_vehicle_chest_weight

        XCEL.getSData(carformat, function(cardata)
            cardata = json.decode(cardata) or {}
            local carweight = XCEL.computeItemsWeight(cardata)

            -- Create a copy of the keys to iterate safely
            local inventoryKeys = {}
            for key, _ in pairs(inventory) do
                table.insert(inventoryKeys, key)
            end

            for _, A in ipairs(inventoryKeys) do
                local B = inventory[A]
                if B then  -- Ensure the item still exists in inventory
                    local amount = B.amount
                    local itemweight = XCEL.getItemWeight(A) * amount
                    if carweight + itemweight <= maxVehKg then
                        if XCEL.tryGetInventoryItem(user_id, A, amount, true) then
                            if cardata[A] then
                                cardata[A].amount = cardata[A].amount + amount
                            else
                                cardata[A] = {}
                                cardata[A].amount = amount
                            end
                            local FormattedInventoryData = {}
                            for i, v in pairs(cardata) do
                                FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
                            end
                            TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(cardata), maxVehKg)
                            carweight = carweight + itemweight
                            Wait(500)
                        end
                    else
                        XCELclient.notify(source, {'~r~You cannot move this item.'})
                    end
                end
            end

            alreadyTransfering[user_id] = false
            XCEL.setSData(carformat, json.encode(cardata))
        end)
    else
        XCELclient.notify(source, {'~r~You are already transferring all items'})
    end
end)


RegisterNetEvent('XCEL:LootItemAll')
AddEventHandler('XCEL:LootItemAll', function(inventoryInfo)
    local source = source
    local user_id = XCEL.getUserId(source)
    local data = XCEL.getUserDataTable(user_id)
    local weightCalculation = 0
    if not LootBagEntities[inventoryInfo] then 
        XCELclient.notify(source, {'~r~This loot bag items are unavailable.'})
        return
    end
    for itemId, itemData in pairs(LootBagEntities[inventoryInfo].Items) do
        weightCalculation = weightCalculation + (XCEL.getItemWeight(itemId) * itemData.amount)
    end
    if weightCalculation > XCEL.getInventoryMaxWeight(user_id) then
        XCELclient.notify(source, {'~r~You do not have enough inventory space.'})
        return
    end
    if InventoryCoolDown[source] then XCELclient.notify(source, {'~r~Please wait before moving more items.'}) return end
    InventoryCoolDown[source] = true;
    for itemId, itemData in pairs(LootBagEntities[inventoryInfo].Items) do
        local amount = itemData.amount

        if weightCalculation > XCEL.getInventoryMaxWeight(user_id) and XCEL.getInventoryWeight(user_id) ~= XCEL.getInventoryMaxWeight(user_id) then
            amount = math.floor((XCEL.getInventoryMaxWeight(user_id) - XCEL.getInventoryWeight(user_id)) / XCEL.getItemWeight(itemId))
        end

        XCEL.giveInventoryItem(user_id, itemId, amount, true)
        LootBagEntities[inventoryInfo].Items[itemId] = nil
    end

    local FormattedInventoryData = {}

    for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
        FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i) * v.amount}
    end
    --TriggerClientEvent('XCEL:FetchPersonalInventory', source, FormattedInventoryData, XCEL.computeItemsWeight(LootBagEntities[inventoryInfo].Items), 200)
    TriggerEvent('XCEL:RefreshInventory', source)
    InventoryCoolDown[source] = false;
    if not next(LootBagEntities[inventoryInfo].Items) then
        CloseInv(source)
    end
end)







RegisterNetEvent('XCEL:LootBag')
AddEventHandler('XCEL:LootBag', function(netid)
    local source = source
    XCELclient.isInComa(source, {}, function(in_coma) 
        if not in_coma and not tXCEL.createCamera then
            if LootBagEntities[netid] then
                LootBagEntities[netid][3] = true;
                local user_id = XCEL.getUserId(source)
                if user_id ~= nil then
                    LootBagEntities[netid][5] = source
                    if XCEL.hasPermission(user_id, "police.armoury") then
                        local bagData = LootBagEntities[netid].Items
                        if bagData == nil then return end
                        for a,b in pairs(bagData) do
                            if string.find(a, 'wbody|') then
                                c = a:gsub('wbody|', '')
                                bagData[c] = b
                                bagData[a] = nil
                            end
                        end
                        for k,v in pairs(a.weapons) do
                            if bagData[k] ~= nil then
                                if not v.policeWeapon then
                                    XCELclient.notify(source, {'~r~Seized '..v.name..' x'..bagData[k].amount..'.'})
                                    bagData[k] = nil
                                end
                            end
                        end
                        for c,d in pairs(bagData) do
                            if seizeBullets[c] then
                                XCELclient.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                bagData[c] = nil
                            end
                        end
                        LootBagEntities[netid].Items = bagData
                        XCELclient.notify(source,{"~r~You have seized " .. LootBagEntities[netid].name .. "'s items"})
                        if #LootBagEntities[netid].Items > 0 then
                            OpenInv(source, netid, LootBagEntities[netid].Items)
                        end
                    else
                        OpenInv(source, netid, LootBagEntities[netid].Items)
                    end 
                    TriggerClientEvent("XCEL:playZipperSound",-1,GetEntityCoords(GetPlayerPed(source)))
                end
            else
                XCELclient.notify(source, {'~r~This loot bag is unavailable.'})
            end
        else 
            XCELclient.notify(source, {'~r~You cannot open this while dead silly.'})
        end
    end)
end)


Citizen.CreateThread(function()
    while true do 
        Wait(250)
        for i,v in pairs(LootBagEntities) do 
            if v[5] then 
                local coords = GetEntityCoords(GetPlayerPed(v[5]))
                local objectcoords = GetEntityCoords(v[1])
                if #(objectcoords - coords) > 5.0 then
                    CloseInv(v[5])
                    Wait(3000)
                    v[3] = false; 
                    v[5] = nil;
                end
            end
        end
    end
end)

RegisterNetEvent('XCEL:CloseLootbag')
AddEventHandler('XCEL:CloseLootbag', function()
    local source = source
    for i,v in pairs(LootBagEntities) do 
        if v[5] and v[5] == source then 
            CloseInv(v[5])
            Wait(3000)
            v[3] = false; 
            v[5] = nil;
        end
    end
end)

function CloseInv(source)
    TriggerClientEvent('XCEL:InventoryOpen', source, false, false)
end

function OpenInv(source, netid, LootBagItems)
    local user_id = XCEL.getUserId(source)
    local data = XCEL.getUserDataTable(user_id)
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
        end
        TriggerClientEvent('XCEL:FetchPersonalInventory', source, FormattedInventoryData, XCEL.computeItemsWeight(data.inventory), XCEL.getInventoryMaxWeight(user_id))
        InventorySpamTrack[source] = false;
    else 
        --print('An error has occured while trying to fetch inventory data from: ' .. user_id .. ' This may be a saving / loading data error you will need to investigate this.')
    end
    TriggerClientEvent('XCEL:InventoryOpen', source, true, true, netid)
    local FormattedInventoryData = {}
    for i, v in pairs(LootBagItems) do
        FormattedInventoryData[i] = {amount = v.amount, ItemName = XCEL.getItemName(i), Weight = XCEL.getItemWeight(i)}
    end
    local maxVehKg = 200
    TriggerClientEvent('XCEL:SendSecondaryInventoryData', source, FormattedInventoryData, XCEL.computeItemsWeight(LootBagItems), maxVehKg)
end


-- Garabge collector for empty lootbags.
Citizen.CreateThread(function()
    while true do 
        Wait(500)
        for i,v in pairs(LootBagEntities) do 
            local itemCount = 0;
            for i,v in pairs(v.Items) do
                itemCount = itemCount + 1
            end
            if itemCount == 0 then
                if DoesEntityExist(v[1]) then 
                    DeleteEntity(v[1])
                    LootBagEntities[i] = nil;
                end
            end
        end
    end
end)


local useing = {}

RegisterNetEvent('XCEL:attemptLockpick')
AddEventHandler('XCEL:attemptLockpick', function(veh, netveh)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.tryGetInventoryItem(user_id, 'Lockpick', 1, true) then
        local chance = math.random(1,8)
        if chance == 1 then
            TriggerClientEvent('XCEL:lockpickClient', source, veh, true)
        else
            TriggerClientEvent('XCEL:lockpickClient', source, veh, false)
        end
    end
end)

RegisterNetEvent('XCEL:lockpickVehicle')
AddEventHandler('XCEL:lockpickVehicle', function(spawncode, ownerid)
    local source = source
    local user_id = XCEL.getUserId(source)
    
end)

RegisterNetEvent('XCEL:setVehicleLock')
AddEventHandler('XCEL:setVehicleLock', function(netid)
    local source = source
    local user_id = XCEL.getUserId(source)
    if usersLockpicking[user_id] then
        SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(netid), false)
    end
end)

function XCEL.GetAmmoNameForWeapon(spawncode)
    for weapon,weapondata in pairs(a.weapons) do
        if weapon == spawncode then
            return weapondata.ammo
        end
    end
end