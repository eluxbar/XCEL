RegisterNetEvent('XCEL:sendSharedEmoteRequest')
AddEventHandler('XCEL:sendSharedEmoteRequest', function(playersrc, emote)
    local source = source
    TriggerClientEvent('XCEL:sendSharedEmoteRequest', playersrc, source, emote)
end)

RegisterNetEvent('XCEL:receiveSharedEmoteRequest')
AddEventHandler('XCEL:receiveSharedEmoteRequest', function(i, a)
    local source = source
    if a == -1 then 
        XCEL.ACBan(15,user_id,'XCEL:receiveSharedEmoteRequest')
    end
    TriggerClientEvent('XCEL:receiveSharedEmoteRequestSource', i)
    TriggerClientEvent('XCEL:receiveSharedEmoteRequest', source, a)
end)


local shavedPlayers = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(shavedPlayers) do
            if shavedPlayers[k] then
                if shavedPlayers[k].cooldown > 0 then
                    shavedPlayers[k].cooldown = shavedPlayers[k].cooldown - 1
                else
                    shavedPlayers[k] = nil
                end
            end
        end
    end
end)

AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = XCEL.getUserId(source)
        if first_spawn and shavedPlayers[user_id] then
            TriggerClientEvent('XCEL:setAsShaved', source, (shavedPlayers[user_id].cooldown*60*1000))
        end
    end)
end)

function XCEL.ShaveHead(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.getInventoryItemAmount(user_id, 'Shaver') >= 1 then
        XCELclient.getNearestPlayer(source,{4},function(nplayer)
            if nplayer then
                XCELclient.isPlayerSurrenderedNoProgressBar(nplayer,{},function(surrendering)
                    if surrendering then
                        XCEL.tryGetInventoryItem(user_id, 'Shaver', 1)
                        TriggerClientEvent('XCEL:startShavingPlayer', source, nplayer)
                        shavedPlayers[XCEL.getUserId(nplayer)] = {
                            cooldown = 30,
                        }
                    else
                        XCELclient.notify(source,{'~r~This player is not on their knees.'})
                    end
                end)
            else
                XCELclient.notify(source, {"~r~No one nearby."})
            end
        end)
    end
end

local radioCreated = {}

Citizen.CreateThread(function()
    while true do
        for _, player in ipairs(GetPlayers()) do
            local user_id = XCEL.getUserId(player)
            if user_id then
                if radioCreated[user_id] == nil and XCEL.getInventoryItemAmount(user_id, 'civilian_radio') >= 1 then
                    syncRadio(player)
                    radioCreated[user_id] = true
                elseif radioCreated[user_id] and XCEL.getInventoryItemAmount(user_id, 'civilian_radio') == 0 then
                    removeRadio(player)
                    TriggerClientEvent('XCEL:radiosClearAll', player)
                    radioCreated[user_id] = nil
                end
            end
        end
        Citizen.Wait(1000)
    end
end)