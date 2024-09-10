netObjects = {}

RegisterServerEvent("XCEL:spawnVehicleCallback")
AddEventHandler('XCEL:spawnVehicleCallback', function(a, b)
    netObjects[b] = {source = XCEL.getUserSource(a), id = a, name = XCEL.GetPlayerName(a)}
end)

RegisterServerEvent("XCEL:delGunDelete")
AddEventHandler("XCEL:delGunDelete", function(object)
    local source = source
    local user_id = XCEL.getUserId(user_id)
    if XCEL.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("XCEL:deletePropClient", -1, object)
        if netObjects[object] then
            TriggerClientEvent("XCEL:returnObjectDeleted", source, 'This object was created by ~b~'..netObjects[object].name..'~w~. Temp ID: ~b~'..netObjects[object].source..'~w~.\nPerm ID: ~b~'..netObjects[object].id..'~w~.')
        end
    end
end)