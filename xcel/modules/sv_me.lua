RegisterCommand("me", function(source, args)
    local text = table.concat(args, " ")
    local user_id = XCEL.getUserId(source)
    TriggerClientEvent('XCEL:sendLocalChat', -1, source, XCEL.GetPlayerName(user_id), text)
end)