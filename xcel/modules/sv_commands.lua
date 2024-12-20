RegisterCommand("a", function(source,args, rawCommand)
    if #args <= 0 then return end
    local message = table.concat(args, " ")
    local user_id = XCEL.getUserId(source)
    local name = XCEL.GetPlayerName(user_id)
    if XCEL.hasPermission(user_id, "admin.tickets") then
        XCEL.sendWebhook('staff', "XCEL Chat Logs", "```"..message.."```".."\n> Admin Name: **"..name.."**\n> Admin PermID: **"..user_id.."**\n> Admin TempID: **"..source.."**")
        for k, v in pairs(XCEL.getUsers({})) do
            if XCEL.hasPermission(k, 'admin.tickets') then
                TriggerClientEvent('chatMessage', v, "^3Admin Chat | " .. name..": " , { 128, 128, 128 }, message, "ooc")
            end
        end
    end
end)
RegisterServerEvent("XCEL:PoliceChat", function(source, args, rawCommand)
    if #args <= 0 then return end
    local source = source
    local user_id = XCEL.getUserId(source)   
    local message = args
    if XCEL.hasPermission(user_id, "police.armoury") then
        local callsign = ""
        if getCallsign('Police', source, user_id, 'Police') then
            callsign = "["..getCallsign('Police', source, user_id, 'Police').."]"
        end
        local playerName =  "^4Police Chat | "..callsign.." "..XCEL.GetPlayerName(user_id)..": "
        for k, v in pairs(XCEL.getUsers({})) do
            if XCEL.hasPermission(k, 'police.armoury') then
                TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, message, "ooc", "Police")
            end
        end
    end
end)

RegisterCommand("p", function(source, args)
    local message = table.concat(args, " ")
    TriggerEvent("XCEL:PoliceChat", source, message)
end)
RegisterServerEvent("XCEL:Nchat", function(source, args, rawCommand)
    if #args <= 0 then return end
    local source = source
    local user_id = XCEL.getUserId(source)   
    local message = args
    if XCEL.hasPermission(user_id, "nhs.menu") then
        local playerName =  "^2NHS Chat | "..XCEL.GetPlayerName(user_id)..": "
        for k, v in pairs(XCEL.getUsers({})) do
            if XCEL.hasPermission(k, 'nhs.menu') then
                TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, message, "ooc", "NHS")
            end
        end
    end
end)
RegisterCommand("n", function(source, args)
    local message = table.concat(args, " ")
    TriggerEvent("XCEL:Nchat", source, message)
end)

RegisterCommand("g", function(source, args)
    local message = table.concat(args, " ")
    TriggerEvent("XCEL:GangChat", source, message)
end)
RegisterServerEvent("XCEL:GangChat", function(source, message)
    local source = source
    local user_id = XCEL.getUserId(source)   
    local msg = message
    if XCEL.hasGroup(user_id,"Gang") then
        local gang = exports['xcel']:executeSync('SELECT gangname FROM xcel_user_gangs WHERE user_id = @user_id', {user_id = user_id})[1].gangname
        if gang then
            exports["xcel"]:execute("SELECT * FROM xcel_user_gangs WHERE gangname = @gangname", {gangname = gang},function(ganginfo)
                for A,B in pairs(ganginfo) do
                    local playersource = XCEL.getUserSource(B.user_id)
                    if playersource then
                        TriggerClientEvent('chatMessage',playersource,"^2[Gang Chat] " .. XCEL.GetPlayerName(user_id)..": ",{ 128, 128, 128 },msg,"ooc", "Gang")
                    end
                end
                XCEL.sendWebhook('gang', "XCEL Chat Logs", "```"..msg.."```".."\n> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
            end)
        end
    end
end)

