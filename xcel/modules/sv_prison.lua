MySQL.createCommand("XCEL/get_prison_time","SELECT prison_time FROM xcel_prison WHERE user_id = @user_id")
MySQL.createCommand("XCEL/set_prison_time","UPDATE xcel_prison SET prison_time = @prison_time WHERE user_id = @user_id")
MySQL.createCommand("XCEL/add_prisoner", "INSERT IGNORE INTO xcel_prison SET user_id = @user_id")
MySQL.createCommand("XCEL/get_current_prisoners", "SELECT * FROM xcel_prison WHERE prison_time > 0")
MySQL.createCommand("XCEL/add_jail_stat","UPDATE xcel_police_hours SET total_player_jailed = (total_player_jailed+1) WHERE user_id = @user_id")

local cfg = module("cfg/cfg_prison")
local newDoors = {}
for k,v in pairs(cfg.doors) do
    for a,b in pairs(v) do
        newDoors[b.doorHash] = b
        newDoors[b.doorHash].currentState = 0
    end
end  
local prisonItems = {"toothbrush", "blade", "rope", "metal_rod", "spring"}
local lastCellUsed = 0


AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        MySQL.execute("XCEL/add_prisoner", {user_id = user_id})
        Wait(500)
        MySQL.query("XCEL/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime and #prisontime > 0 and prisontime[1] and prisontime[1].prison_time then 
                if prisontime[1].prison_time > 0 then
                    if lastCellUsed == 27 then
                        lastCellUsed = 0
                    end
                    TriggerClientEvent('XCEL:putInPrisonOnSpawn', source, lastCellUsed+1)
                    TriggerClientEvent('XCEL:forcePlayerInPrison', source, true)
                    TriggerClientEvent('XCEL:prisonCreateBreakOutAreas', source)
                    TriggerClientEvent('XCEL:prisonUpdateClientTimer', source, prisontime[1].prison_time)

                    local prisonItemsTable = {}
                    if cfg.prisonItems and prisonItems and #prisonItems > 0 then
                        for k,v in pairs(cfg.prisonItems) do
                            local item = math.random(1, #prisonItems)
                            prisonItemsTable[prisonItems[item]] = v
                        end
                    end
                    TriggerClientEvent('XCEL:prisonCreateItemAreas', source, prisonItemsTable)
                end
            end
        end)
        TriggerClientEvent('XCEL:prisonUpdateGuardNumber', -1, #XCEL.getUsersByPermission('hmp.menu'))
        TriggerClientEvent('XCEL:prisonSyncAllDoors', source, newDoors)
    end
end)


RegisterNetEvent("XCEL:getNumOfNHSOnline")
AddEventHandler("XCEL:getNumOfNHSOnline", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    MySQL.query("XCEL/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime and #prisontime > 0 then
            if prisontime[1].prison_time > 0 then
                TriggerClientEvent('XCEL:prisonSpawnInMedicalBay', source)
                XCELclient.RevivePlayer(source, {})
            else
                TriggerClientEvent('XCEL:getNumberOfDocsOnline', source, #XCEL.getUsersByPermission('nhs.menu'))
            end
        end
    end)
end)

RegisterServerEvent("XCEL:prisonArrivedForJail")
AddEventHandler("XCEL:prisonArrivedForJail", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    MySQL.query("XCEL/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                XCEL.setBucket(source, 0)
                TriggerClientEvent('XCEL:unHandcuff', source, false)
                TriggerClientEvent('XCEL:toggleHandcuffs', source, false)
                TriggerClientEvent('XCEL:forcePlayerInPrison', source, true)
                TriggerClientEvent('XCEL:prisonCreateBreakOutAreas', source)
                TriggerClientEvent('XCEL:prisonUpdateClientTimer', source, prisontime[1].prison_time)
            end
        end
    end)
end)

local prisonPlayerJobs = {}

RegisterServerEvent("XCEL:prisonStartJob")
AddEventHandler("XCEL:prisonStartJob", function(job)
    local source = source
    local user_id = XCEL.getUserId(source)
    prisonPlayerJobs[user_id] = job
end)

RegisterServerEvent("XCEL:prisonEndJob")
AddEventHandler("XCEL:prisonEndJob", function(job)
    local source = source
    local user_id = XCEL.getUserId(source)
    if prisonPlayerJobs[user_id] == job then
        prisonPlayerJobs[user_id] = nil
        MySQL.query("XCEL/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 21 then
                    MySQL.execute("XCEL/set_prison_time", {user_id = user_id, prison_time = prisontime[1].prison_time - 20})
                    TriggerClientEvent('XCEL:prisonUpdateClientTimer', source, prisontime[1].prison_time - 20)
                    XCELclient.notify(source, {"~g~Prison time reduced by 20s."})
                end
            end
        end)
    end
end)

RegisterServerEvent("XCEL:jailPlayer")
AddEventHandler("XCEL:jailPlayer", function(player)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') then
        XCELclient.getNearestPlayers(source,{15},function(nplayers)
            if nplayers[player] then
                XCELclient.isHandcuffed(player,{}, function(handcuffed)  -- check handcuffed
                    if handcuffed then
                        -- check for gc in cfg 
                        MySQL.query("XCEL/get_prison_time", {user_id = XCEL.getUserId(player)}, function(prisontime)
                            if prisontime ~= nil then 
                                if prisontime[1].prison_time == 0 then
                                    XCEL.prompt(source,"Jail Time (in minutes):","",function(source,jailtime) 
                                        local jailtime = math.floor(tonumber(jailtime) * 60)
                                        if jailtime > 3 and jailtime <= cfg.maxTimeNotGc then
                                            MySQL.execute("XCEL/set_prison_time", {user_id = XCEL.getUserId(player), prison_time = jailtime})
                                            if lastCellUsed == 27 then
                                                lastCellUsed = 0
                                            end
                                            TriggerClientEvent('XCEL:prisonTransportWithBus', player, lastCellUsed+1)
                                            XCEL.setBucket(player, lastCellUsed+1)
                                            local prisonItemsTable = {}
                                            for k,v in pairs(cfg.prisonItems) do
                                                local item = math.random(1, #prisonItems)
                                                prisonItemsTable[prisonItems[item]] = v
                                            end
                                            exports['xcel']:execute("SELECT * FROM `xcel_police_hours` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                                                if result ~= nil then 
                                                    for k,v in pairs(result) do
                                                        if v.user_id == user_id then
                                                            exports['xcel']:execute("UPDATE xcel_police_hours SET total_players_jailed = @total_players_jailed WHERE user_id = @user_id", {user_id = user_id, total_players_jailed = v.total_players_jailed + 1}, function() end)
                                                            return
                                                        end
                                                        TriggerClientEvent('XCEL:toggleHandcuffs', XCEL.getUserSource(v.user_id), false)
                                                    end
                                                    exports['xcel']:execute("INSERT INTO xcel_police_hours (`user_id`, `total_players_jailed`, `username`) VALUES (@user_id, @total_players_jailed, @username);", {user_id = user_id, total_players_jailed = 1}, function() end) 
                                                end
                                            end)
                                            TriggerClientEvent('XCEL:prisonCreateItemAreas', player, prisonItemsTable)
                                            TriggerClientEvent('XCEL:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                                            XCELclient.notify(source, {"~g~Jailed Player."})
                                            XCEL.sendWebhook('jail-player', 'XCEL Jail Logs',"> Officer Name: **"..XCEL.GetPlayerName(user_id).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Criminal Name: **"..XCEL.GetPlayerName(user_id).."**\n> Criminal PermID: **"..XCEL.getUserId(player).."**\n> Criminal TempID: **"..player.."**\n> Duration: **"..math.floor(jailtime/60).." minutes**")
                                        else
                                            XCELclient.notify(source, {"~r~Invalid time."})
                                        end
                                    end)
                                else
                                    XCELclient.notify(source, {"~r~Player is already in prison."})
                                end
                            end
                        end)
                    else
                        XCELclient.notify(source, {"~r~You must have the player handcuffed."})
                    end
                end)
            else
                XCELclient.notify(source, {"~r~Player not found."})
            end
        end)
    end
end)


Citizen.CreateThread(function()
    while true do
        MySQL.query("XCEL/get_current_prisoners", {}, function(currentPrisoners)
            if currentPrisoners and #currentPrisoners > 0 then
                for k,v in pairs(currentPrisoners) do
                    if XCEL.getUserSource(v.user_id) and v.prison_time > 0 then
                        MySQL.execute("XCEL/set_prison_time", {user_id = v.user_id, prison_time = v.prison_time-1})
                        if v.prison_time-1 == 0 then
                            TriggerClientEvent('XCEL:prisonStopClientTimer', XCEL.getUserSource(v.user_id))
                            TriggerClientEvent('XCEL:prisonReleased', XCEL.getUserSource(v.user_id))
                            TriggerClientEvent('XCEL:forcePlayerInPrison', XCEL.getUserSource(v.user_id), false)
                            XCELclient.setHandcuffed(XCEL.getUserSource(v.user_id), {false})
                        end
                    end
                end
            end
        end)
        Citizen.Wait(1000)
    end
end)

RegisterCommand('unjail', function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.noclip') then
        XCEL.prompt(source,"Enter Temp ID:","",function(source, player) 
            local player = tonumber(player)
            if player ~= nil then
                MySQL.execute("XCEL/set_prison_time", {user_id = XCEL.getUserId(player), prison_time = 0})
                TriggerClientEvent('XCEL:prisonStopClientTimer', player)
                TriggerClientEvent('XCEL:prisonReleased', player)
                TriggerClientEvent('XCEL:forcePlayerInPrison', player, false)
                XCELclient.setHandcuffed(player, {false})
                XCELclient.notify(source, {"~g~Target will be released soon."})
            else
                XCELclient.notify(source, {"~r~Invalid ID."})
            end
        end)
    end
end)


AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent('XCEL:prisonUpdateGuardNumber', -1, #XCEL.getUsersByPermission('hmp.menu'))
    end
end)

local currentLockdown = false
RegisterServerEvent("XCEL:prisonToggleLockdown")
AddEventHandler("XCEL:prisonToggleLockdown", function(lockdownState)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'dev.menu') then -- change this to the hmp hq permission
        currentLockdown = lockdownState
        if currentLockdown then
            TriggerClientEvent('XCEL:prisonSetAllDoorStates', -1, 1)
        else
            TriggerClientEvent('XCEL:prisonSetAllDoorStates', -1)
        end
    end
end)

RegisterServerEvent("XCEL:prisonSetDoorState")
AddEventHandler("XCEL:prisonSetDoorState", function(doorHash, state)
    local source = source
    local user_id = XCEL.getUserId(source)
    TriggerClientEvent('XCEL:prisonSyncDoor', -1, doorHash, state)
end)

RegisterServerEvent("XCEL:enterPrisonAreaSyncDoors")
AddEventHandler("XCEL:enterPrisonAreaSyncDoors", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    TriggerClientEvent('XCEL:prisonAreaSyncDoors', source, doors)
end)

-- on pickup 
-- XCEL:prisonRemoveItemAreas(item)

-- hmp should be able to see all prisoners
-- XCEL:requestPrisonerData