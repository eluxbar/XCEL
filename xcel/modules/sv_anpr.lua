local flaggedVehicles = {}

AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if XCEL.hasPermission(user_id, 'police.armoury') then
            TriggerClientEvent('XCEL:setFlagVehicles', source, flaggedVehicles)
        end
    end
end)

RegisterServerEvent("XCEL:flagVehicleAnpr")
AddEventHandler("XCEL:flagVehicleAnpr", function(plate, reason)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') then
        flaggedVehicles[plate] = reason
        TriggerClientEvent('XCEL:setFlagVehicles', -1, flaggedVehicles)
    end
end)