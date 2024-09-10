local spikes = 0
local speedzones = 0

RegisterNetEvent("XCEL:placeSpike")
AddEventHandler("XCEL:placeSpike", function(heading, coords)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('XCEL:addSpike', -1, coords, heading)
    end
end)

RegisterNetEvent("XCEL:removeSpike")
AddEventHandler("XCEL:removeSpike", function(entity)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('XCEL:deleteSpike', -1, entity)
        TriggerClientEvent("XCEL:deletePropClient", -1, entity)
    end
end)

RegisterNetEvent("XCEL:requestSceneObjectDelete")
AddEventHandler("XCEL:requestSceneObjectDelete", function(prop)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') or XCEL.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent("XCEL:deletePropClient", -1, prop)
    end
end)

RegisterNetEvent("XCEL:createSpeedZone")
AddEventHandler("XCEL:createSpeedZone", function(coords, radius, speed)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') or XCEL.hasPermission(user_id, 'hmp.menu') then
        speedzones = speedzones + 1
        TriggerClientEvent('XCEL:createSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

RegisterNetEvent("XCEL:deleteSpeedZone")
AddEventHandler("XCEL:deleteSpeedZone", function(speedzone)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') or XCEL.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent('XCEL:deleteSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

