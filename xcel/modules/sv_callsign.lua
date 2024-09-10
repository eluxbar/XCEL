function getCallsign(guildType, source, user_id, type)
    local discord_id = exports['xcel']:Get_Client_Discord_ID(source)
    if discord_id then
        local guilds_info = exports['xcel']:Get_Guilds()
        for guild_name, guild_id in pairs(guilds_info) do
            if guild_name == guildType then
                local nick_name = exports['xcel']:Get_Guild_Nickname(guild_id, discord_id)
                if nick_name then
                    local open_bracket = string.find(nick_name, '[', nil, true)
                    local closed_bracket = string.find(nick_name, ']', nil, true)
                    if open_bracket and closed_bracket then
                        local callsign_value = string.sub(nick_name, open_bracket + 1, closed_bracket - 1)
                        return callsign_value, string.gsub(getGroupInGroups(user_id, type), ' Clocked', ''), XCEL.GetPlayerName(user_id)
                    else
                        return 'N/A', string.gsub(getGroupInGroups(user_id, type), ' Clocked', ''), XCEL.GetPlayerName(user_id)
                    end
                end
            end
        end
    end
end

RegisterServerEvent("XCEL:getCallsign")
AddEventHandler("XCEL:getCallsign", function(type)
    local source = source
    local user_id = XCEL.getUserId(source)
    Wait(1000)
    if type == 'police' and XCEL.hasPermission(user_id, 'police.armoury') then
        if getCallsign('Police', source, user_id, 'Police') then
            TriggerClientEvent("XCEL:receivePoliceCallsign", source, getCallsign('Police', source, user_id, 'Police'))
        end
        TriggerClientEvent("XCEL:setPoliceOnDuty", source, true)
    elseif type == 'prison' and XCEL.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent("XCEL:receiveHmpCallsign", source, getCallsign('HMP', source, user_id, 'HMP'))
        TriggerClientEvent("XCEL:setPrisonGuardOnDuty", source, true)
    end
end)
