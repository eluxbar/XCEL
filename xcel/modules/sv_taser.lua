RegisterServerEvent('XCEL:playTaserSound')
AddEventHandler('XCEL:playTaserSound', function(coords, sound)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') or XCEL.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent('playTaserSoundClient', -1, coords, sound)
    end
end)

RegisterServerEvent('XCEL:reactivatePed')
AddEventHandler('XCEL:reactivatePed', function(id)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') or XCEL.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('XCEL:receiveActivation', id)
      TriggerClientEvent('TriggerTazer', id)
    end
end)

RegisterServerEvent('XCEL:arcTaser')
AddEventHandler('XCEL:arcTaser', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') or XCEL.hasPermission(user_id, 'hmp.menu') then
      XCELclient.getNearestPlayer(source, {3}, function(nplayer)
        local nuser_id = XCEL.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('XCEL:receiveBarbs', nplayer, source)
            TriggerClientEvent('TriggerTazer', id)
        end
      end)
    end
end)

RegisterServerEvent('XCEL:barbsNoLongerServer')
AddEventHandler('XCEL:barbsNoLongerServer', function(id)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') or XCEL.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('XCEL:barbsNoLonger', id)
    end
end)

RegisterServerEvent('XCEL:barbsRippedOutServer')
AddEventHandler('XCEL:barbsRippedOutServer', function(id)
    local source = source
    local user_id = XCEL.getUserId(source)
    TriggerClientEvent('XCEL:barbsRippedOut', id)
end)

RegisterCommand('rt', function(source, args)
  local source = source
  local user_id = XCEL.getUserId(source)
  if XCEL.hasPermission(user_id, 'police.armoury') or XCEL.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('XCEL:reloadTaser', source)
  end
end)