local cfg = module('cfg/cfg_organheist')
local organlocation = {["police"] = {}, ["civ"] = {}}
local playersInOrganHeist = {}
local timeTillOrgan = 0
local inWaitingStage = false
local inGamePhase = false
local policeInGame = 0
local civsInGame = 0




RegisterNetEvent("XCEL:joinOrganHeist")
AddEventHandler("XCEL:joinOrganHeist", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if not playersInOrganHeist[source] then
        if inWaitingStage then
            if XCEL.hasPermission(user_id, 'police.armoury') then
                playersInOrganHeist[source] = { type = 'police' }
                policeInGame = policeInGame + 1
                TriggerClientEvent('XCEL:addOrganHeistPlayer', -1, source, 'police')
                TriggerClientEvent('XCEL:teleportToOrganHeist', source, organlocation["police"], timeTillOrgan, 'police', 1)
            elseif XCEL.hasPermission(user_id, 'nhs.menu') then
                XCELclient.notify(source, {'~r~You cannot enter Organ Heist whilst clocked on NHS.'})
            else
                playersInOrganHeist[source] = { type = 'civ' }
                civsInGame = civsInGame + 1
                TriggerClientEvent('XCEL:addOrganHeistPlayer', -1, source, 'civ')
                TriggerClientEvent('XCEL:teleportToOrganHeist', source, organlocation["civ"], timeTillOrgan, 'civ', 2)
                XCELclient.giveWeapons(source, { { ['WEAPON_MOSIN'] = { ammo = 250 } }, false })
            end
            XCEL.setBucket(source, 15)
            XCELclient.setArmour(source, { 100, true })
        else
            XCELclient.notify(source, {'~r~Organ Heist Has Not Started Yet! Starts at 7PM!'})
        end
    else
        XCELclient.notify(source, {'~r~You have already joined the Organ Heist!'})
    end
end)


RegisterNetEvent("XCEL:diedInOrganHeist")
AddEventHandler("XCEL:diedInOrganHeist", function(killer)
    local source = source
    local playerid = XCEL.getUserId(source)
    if playersInOrganHeist[source] then
        if XCEL.getUserId(killer) ~= nil then
            local killerID = XCEL.getUserId(killer)
            XCEL.giveBankMoney(killerID, grindBoost*100000)
            TriggerClientEvent('XCEL:organHeistKillConfirmed', killer, XCEL.GetPlayerName(killerID),grindBoost*100000)
        end
        TriggerClientEvent('XCEL:endOrganHeist', source)
        TriggerClientEvent('XCEL:removeFromOrganHeist', -1, source)
        Wait(2000)
        XCEL.setBucket(source, 0)
        playersInOrganHeist[source] = nil
    end
end)


AddEventHandler('playerDropped', function(reason)
    local source = source
    if playersInOrganHeist[source] then
        playersInOrganHeist[source] = nil
        TriggerClientEvent('XCEL:removeFromOrganHeist', -1, source)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t")
        if inGamePhase then
            local policeAlive = 0
            local civAlive = 0
            
            for k, v in pairs(playersInOrganHeist) do
                if v.type == 'police' then
                    policeAlive = policeAlive + 1
                elseif v.type == 'civ' then
                    civAlive = civAlive + 1
                end
            end
            
            if policeAlive == 0 or civAlive == 0 then
                for k, v in pairs(playersInOrganHeist) do
                    if policeAlive == 0 then
                        TriggerClientEvent('XCEL:endOrganHeistWinner', k, 'Civilians')
                    elseif civAlive == 0 then
                        TriggerClientEvent('XCEL:endOrganHeistWinner', k, 'Police')
                    end
                    TriggerClientEvent('XCEL:endOrganHeist', k)
                    XCEL.setBucket(k, 0)
                    local user_id = XCEL.getUserId(k)
                    if user_id then
                        XCEL.giveBankMoney(user_id, 250000)
                    end
                    playersInOrganHeist[k] = nil
                end
                playersInOrganHeist = {}
                inWaitingStage = false
                inGamePhase = false
            end
        else
            if timeTillOrgan > 0 then
                timeTillOrgan = timeTillOrgan - 1
            end
            if tonumber(time["hour"]) == 18 and tonumber(time["min"]) >= 50 and tonumber(time["sec"]) == 0 then
                inWaitingStage = true
                timeTillOrgan = ((60 - tonumber(time["min"])) * 60)
                TriggerClientEvent('chatMessage', -1, "^7Organ Heist begins in " .. math.floor((timeTillOrgan / 60)) .. " minutes! Make your way to the Morgue with a weapon!", { 128, 128, 128 }, message, "alert")
            elseif tonumber(time["hour"]) == 19 and tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then
                if civsInGame > 0 and policeInGame > 0 then
                    TriggerClientEvent('XCEL:startOrganHeist', -1)
                    inGamePhase = true
                    inWaitingStage = false
                else
                    for k, v in pairs(playersInOrganHeist) do
                        TriggerClientEvent('XCEL:endOrganHeist', k)
                        XCELclient.notify(k, {'~r~Organ Heist was cancelled as not enough players joined.'})
                        SetEntityCoords(GetPlayerPed(k), 240.31098937988, -1379.8699951172, 33.741794586182)
                        XCEL.setBucket(k, 0)
                    end
                end
            end
        end
    end
end)








-- Start Organ Command Event 

RegisterCommand("startorgan", function(source, args, rawCommand)
    local user_id = XCEL.getUserId(source)
    if user_id == 1 
     then
        if not inGamePhase then
            inWaitingStage = true
            for i = 10, 1, -1 do
                TriggerClientEvent('chatMessage', -1, "^7Organ Heist begins in " .. i .. " minutes! Make your way to the Morgue with a weapon!", { 128, 128, 128 }, message, "alert")
                Citizen.Wait(60 * 1000)
            end
                
            inGamePhase = true
            inWaitingStage = false
            TriggerClientEvent('XCEL:startOrganHeist', -1)
        else
            XCELclient.notify(source, {"~r~An Organ Heist event is already in progress."})
        end
    else
        XCELclient.notify(source, {"~r~You are not authorized to use this command."})
    end
end)


-- Function For Changing The Organ Location

function XCEL.SetOrganLocations()
    local dayOfMonth = tonumber(os.date("%d"))
    
    if dayOfMonth % 2 == 1 then
        organlocation["police"] = cfg.locations[1].safePositions[math.random(2)] -- Bottom Floor
        organlocation["civ"] = cfg.locations[2].safePositions[math.random(2)] -- Top Floor
    else
        organlocation["police"] = cfg.locations[2].safePositions[math.random(2)] -- Top Floor
        organlocation["civ"] = cfg.locations[1].safePositions[math.random(2)] -- Bottom Floor
    end
end
XCEL.SetOrganLocations() -- Set the organ locations on server start
