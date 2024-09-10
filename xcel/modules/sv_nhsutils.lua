local bodyBags = {}

RegisterServerEvent("XCEL:requestBodyBag")
AddEventHandler('XCEL:requestBodyBag', function(playerToBodyBag)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('XCEL:placeBodyBag', playerToBodyBag)
    end
end)

RegisterServerEvent("XCEL:removeBodybag")
AddEventHandler('XCEL:removeBodybag', function(bodybagObject)
    local source = source
    local user_id = XCEL.getUserId(source)
    TriggerClientEvent('XCEL:removeIfOwned', -1, NetworkGetEntityFromNetworkId(bodybagObject))
end)

RegisterServerEvent("XCEL:playNhsSound")
AddEventHandler('XCEL:playNhsSound', function(sound)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('XCEL:clientPlayNhsSound', -1, GetEntityCoords(GetPlayerPed(source)), sound)
    else
        XCEL.ACBan(15,user_id,'XCEL:playNhsSound')
    end
end)


-- a = coma
-- c = userid
-- b = permid
-- 4th ready to revive
-- name

local lifePaksConnected = {}

RegisterServerEvent("XCEL:attachLifepakServer")
AddEventHandler('XCEL:attachLifepakServer', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'nhs.menu') then
        XCELclient.getNearestPlayer(source, {3}, function(nplayer)
            local nuser_id = XCEL.getUserId(nplayer)
            if nuser_id ~= nil then
                XCELclient.isInComa(nplayer, {}, function(in_coma)
                    TriggerClientEvent('XCEL:attachLifepak', source, in_coma, nuser_id, nplayer, XCEL.GetPlayerName(nuser_id))
                    lifePaksConnected[user_id] = {permid = nuser_id} 
                end)
            else
                XCELclient.notify(source, {"~r~There is no player nearby"})
            end
        end)
    else
        XCEL.ACBan(15,user_id,'XCEL:attachLifepakServer')
    end
end)


RegisterServerEvent("XCEL:finishRevive")
AddEventHandler('XCEL:finishRevive', function(permid)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'nhs.menu') then 
        if next(lifePaksConnected) then
            for k,v in pairs(lifePaksConnected) do
                if k == user_id and v.permid == permid then
                    TriggerClientEvent('XCEL:returnRevive', source)
                    XCEL.giveBankMoney(user_id, 5000)
                    XCELclient.notify(source, {"~g~You have been paid £5,000 for reviving this person."})
                    lifePaksConnected[k] = nil
                    Wait(15000)
                    XCELclient.RevivePlayer(XCEL.getUserSource(permid), {})
                end
            end
        else
            XCELclient.notify(source, {"~r~There is currently no one to revive."})
        end
    else
        XCEL.ACBan(15,user_id,'XCEL:finishRevive')
    end
end)


RegisterServerEvent("XCEL:nhsRevive") -- nhs radial revive
AddEventHandler('XCEL:nhsRevive', function(playersrc)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'nhs.menu') then
        XCELclient.isInComa(playersrc, {}, function(in_coma)
            if in_coma then
                TriggerClientEvent('XCEL:beginRevive', source, in_coma, XCEL.getUserId(playersrc), playersrc, XCEL.GetPlayerName(XCEL.getUserId(playersrc)))
                lifePaksConnected[user_id] = {permid = XCEL.getUserId(playersrc)} 
            end
        end)
    else
        XCEL.ACBan(15,user_id,'XCEL:nhsRevive')
    end
end)

local playersInCPR = {}

RegisterServerEvent("XCEL:attemptCPR")
AddEventHandler('XCEL:attemptCPR', function(playersrc)
    local source = source
    local user_id = XCEL.getUserId(source)

    XCELclient.getNearestPlayers(source, {15}, function(nplayers)
        local targetPlayer = nplayers[playersrc]

        if targetPlayer then
            local targetPed = GetPlayerPed(playersrc)
            local targetHealth = GetEntityHealth(targetPed)

            if targetHealth > 102 then
                XCELclient.notify(source, {"~r~This person is already healthy."})
            else
                playersInCPR[user_id] = true
                TriggerClientEvent('XCEL:attemptCPR', source)

                Citizen.Wait(15000) -- Wait for 15 seconds

                if playersInCPR[user_id] then
                    local cprChance = math.random(1, 5)
                    if cprChance == 1 then
                        XCELclient.RevivePlayer(playersrc, {})
                        XCELclient.notify(playersrc, {"~b~Your life has been saved."})
                        XCELclient.notify(source, {"~b~You have saved this person's life."})
                    else
                        XCELclient.notify(source, {'~r~Failed to perform CPR.'})
                    end

                    playersInCPR[user_id] = nil
                    XCELclient.notify(source, {"~r~CPR has been canceled."})
                    TriggerClientEvent('XCEL:cancelCPRAttempt', source)
                end
            end
        else
            XCELclient.notify(source, {"~r~Player not found."})
        end
    end)
end)


RegisterServerEvent("XCEL:cancelCPRAttempt")
AddEventHandler('XCEL:cancelCPRAttempt', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if playersInCPR[user_id] then
        playersInCPR[user_id] = nil
        XCELclient.notify(source, {"~r~CPR has been canceled."})
        TriggerClientEvent('XCEL:cancelCPRAttempt', source)
    end
end)

RegisterServerEvent("XCEL:syncWheelchairPosition")
AddEventHandler('XCEL:syncWheelchairPosition', function(netid, coords, heading)
    local source = source
    local user_id = XCEL.getUserId(source)
    entity = NetworkGetEntityFromNetworkId(netid)
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    SetEntityHeading(entity, heading)
end)

RegisterServerEvent("XCEL:wheelchairAttachPlayer")
AddEventHandler('XCEL:wheelchairAttachPlayer', function(entity)
    local source = source
    local user_id = XCEL.getUserId(source)
    TriggerClientEvent('XCEL:wheelchairAttachPlayer', -1, entity, source)
end)