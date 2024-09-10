function getPlayerFaction(user_id)
    if XCEL.hasPermission(user_id, 'police.armoury') then
        return 'pd'
    elseif XCEL.hasPermission(user_id, 'nhs.menu') then
        return 'nhs'
    elseif XCEL.hasPermission(user_id, 'hmp.menu') then
        return 'hmp'
    elseif XCEL.hasPermission(user_id, 'lfb.onduty.permission') then
        return 'lfb'
    end
    return nil
end

RegisterServerEvent('XCEL:factionAfkAlert')
AddEventHandler('XCEL:factionAfkAlert', function(text)
    local source = source
    local user_id = XCEL.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        XCEL.sendWebhook(getPlayerFaction(user_id)..'-afk', 'XCEL AFK Logs', "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('XCEL:setNoLongerAFK')
AddEventHandler('XCEL:setNoLongerAFK', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        XCEL.sendWebhook(getPlayerFaction(user_id)..'-afk', 'XCEL AFK Logs', "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('kick:AFK')
AddEventHandler('kick:AFK', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if not XCEL.hasPermission(user_id, 'group.add') then
        DropPlayer(source, 'You have been kicked for being AFK for too long.')
    end
end)