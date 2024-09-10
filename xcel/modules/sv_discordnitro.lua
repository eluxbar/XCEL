RegisterCommand('craftbmx', function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("XCEL:spawnNitroBMX", source)
    else
        if XCEL.checkForRole(user_id, '1224336529191600202') then
            TriggerClientEvent("XCEL:spawnNitroBMX", source)
        end
    end
end)

RegisterCommand('craftmoped', function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    XCELclient.isPlatClub(source, {}, function(isPlatClub)
        if isPlatClub then
            TriggerClientEvent("XCEL:spawnMoped", source)
        end
    end)
end)

function CheckDiscordActivity()
    for i = 0, GetNumPlayerIndices() - 1 do
        local source = GetPlayerFromIndex(i)
        local user_id = XCEL.getUserId(source)

        if user_id then
            local kickReason = '[XCEL] Connection Refused \nReason: Not Present In The Discord \nPlease Contact management if this was a mistake \nUser ID:' .. user_id

            if not tXCEL.checkForRole(user_id, '1195851569472741441') then
                print("[XCEL] Player " .. XCEL.GetPlayerName(user_id) .. " was not detected in the discord!")
                XCEL.sendWebhook('kick-player', 'XCEL Kick Logs', "> Player Name: **" .. XCEL.GetPlayerName(user_id).. "**\n> Player PermID: **" .. user_id .. "**\n> Player TempID: **" .. source .. "**\n> Reason: **Not Detected in the discord**")
                DropPlayer(source, kickReason)
            end
        else
            print("[XCEL] No one online to check discord activity.")
        end
    end
end
exports('CheckDiscordActivity', CheckDiscordActivity)

