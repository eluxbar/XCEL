local rpZones = {}
local numRP = 0
RegisterServerEvent("XCEL:createRPZone")
AddEventHandler("XCEL:createRPZone", function(a)
	local source = source
	local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'group.remove') then
        numRP = numRP + 1
        a['uuid'] = numRP
        rpZones[numRP] = a
        TriggerClientEvent('XCEL:createRPZone', -1, a)
    end
end)

RegisterServerEvent("XCEL:removeRPZone")
AddEventHandler("XCEL:removeRPZone", function(b)
	local source = source
	local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'group.remove') then
        if next(rpZones) then
            for k,v in pairs(rpZones) do
                if v.uuid == b then
                    rpZones[k] = nil
                    TriggerClientEvent('XCEL:removeRPZone', -1, b)
                end
            end
        end
    end
end)

AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        for k,v in pairs(rpZones) do
            TriggerClientEvent('XCEL:createRPZone', source, v)
        end
    end
end)
