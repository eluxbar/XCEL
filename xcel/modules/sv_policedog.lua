RegisterCommand('k9', function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('XCEL:policeDogMenu', source)
    end
end)

RegisterCommand('k9attack', function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('XCEL:policeDogAttack', source)
    end
end)

RegisterNetEvent("XCEL:serverDogAttack")
AddEventHandler("XCEL:serverDogAttack", function(player)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('XCEL:sendClientRagdoll', player)
    end
end)

RegisterNetEvent("XCEL:policeDogSniffPlayer")
AddEventHandler("XCEL:policeDogSniffPlayer", function(playerSrc)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasGroup(user_id, 'K9 Trained') then
       -- check for drugs
        local player_id = XCEL.getUserId(playerSrc)
        local cdata = XCEL.getUserDataTable(player_id)
        for a,b in pairs(cdata.inventory) do
            for c,d in pairs(seizeDrugs) do
                if a == c then
                    TriggerClientEvent('XCEL:policeDogIndicate', source, playerSrc)
                end
            end
        end
    end
end)

RegisterNetEvent("XCEL:performDogLog")
AddEventHandler("XCEL:performDogLog", function(text)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasGroup(user_id, 'K9 Trained') then
        XCEL.sendWebhook('police-k9', 'XCEL Police Dog Logs',"> Officer Name: **"..XCEL.GetPlayerName(user_id).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)