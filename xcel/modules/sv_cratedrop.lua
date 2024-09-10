local crateLocations = {
    vector3(375.0662, 6852.992, 4.083869), -- Paleto 
    vector3(-3032.489, 3402.802, 8.417397), -- mil base 
    vector3(36.50002, 4344.443, 41.47789), -- Large arms bridge
    vector3(-1518.191, 2140.92, 55.53791), -- wine mansion
    vector3(-191.0104, 1477.419, 288.4325), -- Vinewood 1
    vector3(828.4253, 1300.878, 363.6823), -- Vinewood sign
    vector3(2348.622, 2138.061, 104.3607), -- wind turbines
    vector3(2836.016, -1447.626, 10.45845), -- island near lsd
    vector3(2543.626, 3615.884, 96.89672), -- Youtool hill
    vector3(2856.744, 4631.319, 48.39237), -- H Bunker
    vector3(254.3428, 3583.882, 33.73079), -- Biker city
    vector3(3276.3171386719,5193.2314453125,19.110595703125), -- Biker city
    vector3(3806.5471191406,4463.0146484375,4.4948878288269), -- Biker city
    vector3(-49.600318908691,2997.2009277344,39.7170753479), -- Biker city
    vector3(1247.8603515625,6580.7358398438,2.4832246303558),
    vector3(1170.8328857422,3073.9099121094,40.907836914062),
    vector3(-1897.5454101562,3069.9389648438,32.810520172119),
    vector3(-1781.1745605469,-815.00543212891,8.096378326416),
    vector3(2763.9165039062,1430.3477783203,24.481925964355),
}
local rigLocations = {
    vector3(-1716.5004882812,8886.94921875,27.144144058228),
    vector3(-2182.3957519531,5184.517578125,16.798009872437),
}
local activeCrates = {}
local spawnTime = 20*60 -- Time between each airdrop

local availableItems = {
    "WEAPON_UMP45",
    "WEAPON_MOSIN",
    "WEAPON_AK200",
    "WEAPON_SPAR16",
    "WEAPON_MXM",
    "WEAPON_MK14"
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(activeCrates) do
            if activeCrates[k].timeTillOpen > 0 then
                activeCrates[k].timeTillOpen = activeCrates[k].timeTillOpen - 1
            end
        end
    end
end)


AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
       if #activeCrates > 0 then
            for k,v in pairs(activeCrates) do
                TriggerClientEvent('XCEL:addCrateDropRedzone', source, v, crateLocations[v])
            end
       end
    end
end)

RegisterServerEvent('XCEL:openCrate', function(crateID)
    local source = source
    local user_id = XCEL.getUserId(source)
    if activeCrates[crateID] == nil then return end
    if activeCrates[crateID].timeTillOpen > 0 then
        XCELclient.notify(source, {'~r~Loot crate unlocking in '..activeCrates[crateID].timeTillOpen..' seconds.'})
    else
        local coords = GetEntityCoords(GetPlayerPed(source))
        if (crateLocations[crateID] and #(coords - crateLocations[crateID]) < 2.0) or (rigLocations[crateID] and #(coords - rigLocations[crateID]) < 2.0) then
            TriggerClientEvent("XCEL:removeLootcrate", -1, crateID)
            FreezeEntityPosition(GetPlayerPed(source), true)
            XCELclient.startCircularProgressBar(source, {"", 15000, nil})
            local anims = {
                {'amb@medic@standing@kneel@base', 'base', 1},
                {'anim@gangops@facility@servers@bodysearch@', 'player_search', 1},
            }
            XCELclient.playAnim(source,{true,anims,false})
            Wait(15000)
            local lootAmount = nil
            if activeCrates[crateID].oilrig then
                lootAmount = 9
            else
                lootAmount = 5
            end
            while lootAmount > 0 do
                local randomItem = math.random(1, #availableItems)
                for k,v in pairs(availableItems) do
                    if k == randomItem then
                        XCEL.giveInventoryItem(user_id, "wbody|"..v,1,true)
                        XCEL.giveInventoryItem(user_id, XCEL.GetAmmoNameForWeapon(v),250,true)
                    end
                end
                lootAmount = lootAmount - 1
            end
            activeCrates[crateID] = nil
            XCEL.giveMoney(user_id,math.random(50000,150000))
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "Crate drop has been looted.", "alert")
            FreezeEntityPosition(GetPlayerPed(source), false)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(30*60*1000)
        local crateID = math.random(1, #crateLocations)
        local crateCoords = crateLocations[crateID]
        TriggerClientEvent('XCEL:crateDrop', -1, crateCoords, crateID, false)
        activeCrates[crateID] = {oilrig = false, timeTillOpen = 300}
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "A cartel plane carrying supplies has had to bail and is parachuting to the ground! Get to it quick, check your GPS!", "alert")
        Wait(20*60*1000)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The airdrop has disappeared.", "alert")
            activeCrates[crateID] = nil
            TriggerClientEvent("XCEL:removeLootcrate", -1, crateID)
        end
        Wait(1000)
    end
end)

RegisterCommand('startoildrop', function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id == 1 or user_id == 9 then
        local crateID = math.random(1, #rigLocations)
        local crateCoords = rigLocations[crateID]
        TriggerClientEvent('XCEL:crateDrop', -1, crateCoords, crateID, true)
        activeCrates[crateID] = {oilrig = true, timeTillOpen = 300}
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "An Oil Rig off the coast of paleto is hiding a hidden cache of high tier weaponry and sapphires. Get to it quick, check your GPS!", "alert")
        Wait(20*60*1000)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The Oil Rig has disappeared.", "alert")
            activeCrates[crateID] = nil
            TriggerClientEvent("XCEL:removeLootcrate", -1, crateID)
        end
        Wait(1000)
    else
        XCELclient.notify(source, {'~r~You do not have permission to do this.'})
    end
end)

RegisterCommand('startdrop', function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id == 1 or user_id == 9 then
        local crateID = math.random(1, #crateLocations)
        local crateCoords = crateLocations[crateID]
        TriggerClientEvent('XCEL:crateDrop', -1, crateCoords, crateID, false)
        activeCrates[crateID] = {oilrig = false, timeTillOpen = 300}
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "A cartel plane carrying supplies has had to bail and is parachuting to the ground! Get to it quick, check your GPS!", "alert")
        Wait(20*60*1000)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The airdrop has disappeared.", "alert")
            activeCrates[crateID] = nil
            TriggerClientEvent("XCEL:removeLootcrate", -1, crateID)
        end
        Wait(1000)
    else
        XCELclient.notify(source, {'~r~You do not have permission to do this.'})
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(3*60*60*1000)
        local crateID = math.random(1, #rigLocations)
        local crateCoords = rigLocations[crateID]
        TriggerClientEvent('XCEL:crateDrop', -1, crateCoords, crateID, true)
        activeCrates[crateID] = {oilrig = true, timeTillOpen = 300}
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "An Oil Rig off the coast of paleto is hiding a hidden cache of high tier weaponry and sapphires. Get to it quick, check your GPS!", "alert")
        Wait(20*60*1000)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The Oil Rig has disappeared.", "alert")
            activeCrates[crateID] = nil
            TriggerClientEvent("XCEL:removeLootcrate", -1, crateID)
        end
        Wait(1000)
    end
end)