RegisterServerEvent("XCEL:stretcherAttachPlayer")
AddEventHandler('XCEL:stretcherAttachPlayer', function(playersrc)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('XCEL:stretcherAttachPlayer', source, playersrc)
    end
end)

RegisterServerEvent("XCEL:toggleAmbulanceDoors")
AddEventHandler('XCEL:toggleAmbulanceDoors', function(stretcherNetid)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('XCEL:toggleAmbulanceDoorStatus', -1, stretcherNetid)
    end
end)

RegisterServerEvent("XCEL:updateHasStretcherInsideDecor")
AddEventHandler('XCEL:updateHasStretcherInsideDecor', function(stretcherNetid, status)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('XCEL:setHasStretcherInsideDecor', -1, stretcherNetid, status)
    end
end)

RegisterServerEvent("XCEL:updateStretcherLocation")
AddEventHandler('XCEL:updateStretcherLocation', function(a,b)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('XCEL:XCEL:setStretcherInside', -1, a,b)
    end
end)

RegisterServerEvent("XCEL:removeStretcher")
AddEventHandler('XCEL:removeStretcher', function(stretcher)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('XCEL:deletePropClient', -1, stretcher)
    end
end)

RegisterServerEvent("XCEL:forcePlayerOnToStretcher")
AddEventHandler('XCEL:forcePlayerOnToStretcher', function(id, stretcher)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('XCEL:forcePlayerOnToStretcher', id, stretcher)
    end
end)