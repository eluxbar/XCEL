local tickets = {}
local callID = 0
local cooldown = {}
local permid = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(cooldown) do
            if cooldown[k].time > 0 then
                cooldown[k].time = cooldown[k].time - 1
            end
        end
    end
end)

RegisterCommand("calladmin", function(source)
    local user_id = XCEL.getUserId(source)
    local user_source = XCEL.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            XCELclient.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    XCEL.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 5 then
                callID = callID + 1
                tickets[callID] = {
                    name = XCEL.GetPlayerName(user_id),
                    permID = user_id,
                    tempID = user_source,
                    reason = reason,
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(XCEL.getUsers({})) do
                    TriggerClientEvent("XCEL:addEmergencyCall", v, callID, XCEL.GetPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                XCELclient.notify(user_source,{"~b~Your request has been sent."})
            else
                XCELclient.notify(user_source,{"~r~Please enter a minimum of 5 characters."})
            end
        else
            XCELclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)
RegisterCommand("calladmin", function(source)
    local user_id = XCEL.getUserId(source)
    local user_source = XCEL.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            XCELclient.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    XCEL.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 5 then
                callID = callID + 1
                tickets[callID] = {
                    name = XCEL.GetPlayerName(user_id),
                    permID = user_id,
                    tempID = user_source,
                    reason = reason,
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(XCEL.getUsers({})) do
                    TriggerClientEvent("XCEL:addEmergencyCall", v, callID, XCEL.GetPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                XCELclient.notify(user_source,{"~b~Your request has been sent."})
            else
                XCELclient.notify(user_source,{"~r~Please enter a minimum of 5 characters."})
            end
        else
            XCELclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("help", function(source)
    local user_id = XCEL.getUserId(source)
    local user_source = XCEL.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            XCELclient.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    XCEL.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 5 then
                callID = callID + 1
                tickets[callID] = {
                    name = XCEL.GetPlayerName(user_id),
                    permID = user_id,
                    tempID = user_source,
                    reason = reason,
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(XCEL.getUsers({})) do
                    TriggerClientEvent("XCEL:addEmergencyCall", v, callID, XCEL.GetPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                XCELclient.notify(user_source,{"~b~Your request has been sent."})
            else
                XCELclient.notify(user_source,{"~r~Please enter a minimum of 5 characters."})
            end
        else
            XCELclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("report", function(source)
    local user_id = XCEL.getUserId(source)
    local user_source = XCEL.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            XCELclient.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    XCEL.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 5 then
                callID = callID + 1
                tickets[callID] = {
                    name = XCEL.GetPlayerName(user_id),
                    permID = user_id,
                    tempID = user_source,
                    reason = reason,
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(XCEL.getUsers({})) do
                    TriggerClientEvent("XCEL:addEmergencyCall", v, callID, XCEL.GetPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                XCELclient.notify(user_source,{"~b~Your request has been sent."})
            else
                XCELclient.notify(user_source,{"~r~Please enter a minimum of 5 characters."})
            end
        else
            XCELclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("999", function(source)
    local user_id = XCEL.getUserId(source)
    local user_source = XCEL.getUserSource(user_id)
    XCEL.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = XCEL.GetPlayerName(user_id),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'met'
            }
            for k, v in pairs(XCEL.getUsers({})) do
                TriggerClientEvent("XCEL:addEmergencyCall", v, callID, XCEL.GetPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'met')
            end
            XCELclient.notify(user_source,{"~b~Sent Police Call."})
        else
            XCELclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("111", function(source)
    local user_id = XCEL.getUserId(source)
    local user_source = XCEL.getUserSource(user_id)
    XCEL.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = XCEL.GetPlayerName(user_id),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'nhs'
            }
            for k, v in pairs(XCEL.getUsers({})) do
                TriggerClientEvent("XCEL:addEmergencyCall", v, callID, XCEL.GetPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'nhs')
            end
            XCELclient.notify(user_source,{"~g~Sent NHS Call."})
        else
            XCELclient.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

local savedPositions = {}
RegisterCommand("return", function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.tickets') then
        TriggerEvent('XCEL:Return', source)
    end
end)
local adminFeedback = {} 
AddEventHandler("XCEL:Return", function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.tickets') then
        local v = adminFeedback[user_id]
        if savedPositions[user_id] then
            XCEL.setBucket(source, savedPositions[user_id].bucket)
            XCELclient.teleport(source, {table.unpack(savedPositions[user_id].coords)})
            XCELclient.notify(source, {'~g~Returned to position.'})
            savedPositions[user_id] = nil
        else
            XCELclient.notify(source, {"~r~Unable to find last location."})
        end
        TriggerClientEvent('XCEL:sendTicketInfo', source)
        XCELclient.staffMode(source, {false})
        SetTimeout(1000, function() 
            XCELclient.setPlayerCombatTimer(source, {0}) 
        end)
    end
end)

RegisterNetEvent("XCEL:TakeTicket")
AddEventHandler("XCEL:TakeTicket", function(ticketID)
    local user_id = XCEL.getUserId(source)
    local admin_source = XCEL.getUserSource(user_id)
    if tickets[ticketID] ~= nil then
        for k, v in pairs(tickets) do
            if ticketID == k then
                if tickets[ticketID].type == 'admin' and XCEL.hasPermission(user_id, "admin.tickets") then
                    if XCEL.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            local tempID = v.tempID
                            local adminbucket = GetPlayerRoutingBucket(admin_source)
                            local playerbucket = GetPlayerRoutingBucket(v.tempID)
                            savedPositions[user_id] = {bucket = adminbucket, coords = GetEntityCoords(GetPlayerPed(admin_source))}
                            if adminbucket ~= playerbucket then
                                XCEL.setBucket(admin_source, playerbucket)
                                XCELclient.notify(admin_source, {'~g~Player was in another bucket, you have been set into their bucket.'})
                            end
                            XCELclient.getPosition(v.tempID, {}, function(coords)
                                XCELclient.staffMode(admin_source, {true})
                                adminFeedback[user_id] = {playersource = tempID, ticketID = ticketID}
                                TriggerClientEvent('XCEL:sendTicketInfo', admin_source, v.permID, v.name, v.reason)
                                local ticketPay = 0
                                if os.date('%A') == 'Saturday' or os.date('%A') == 'Sunday' then
                                    ticketPay = 30000
                                else
                                    ticketPay = 20000
                                end
                                exports['xcel']:execute("SELECT * FROM `xcel_staff_tickets` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                                    if result ~= nil then 
                                        for k,v in pairs(result) do
                                            if v.user_id == user_id then
                                                exports['xcel']:execute("UPDATE xcel_staff_tickets SET ticket_count = @ticket_count, username = @username WHERE user_id = @user_id", {user_id = user_id, ticket_count = v.ticket_count + 1, username = XCEL.GetPlayerName(user_id)}, function() end)
                                                return
                                            end
                                        end
                                        exports['xcel']:execute("INSERT INTO xcel_staff_tickets (`user_id`, `ticket_count`, `username`) VALUES (@user_id, @ticket_count, @username);", {user_id = user_id, ticket_count = 1, username = XCEL.GetPlayerName(user_id)}, function() end) 
                                    end
                                end)
                                XCEL.giveBankMoney(user_id, ticketPay)
                                XCELclient.notify(admin_source,{"~g~£"..getMoneyStringFormatted(ticketPay).." earned for taking a ticket."})
                                XCELclient.notify(v.tempID,{"~g~An admin has taken your ticket."})
                                TriggerClientEvent('XCEL:smallAnnouncement', v.tempID, 'ticket accepted', "Your admin ticket has been accepted by "..XCEL.GetPlayerName(user_id), 33, 10000)
                                XCEL.sendWebhook('ticket-logs',"XCEL Ticket Logs", "> Admin Name: **"..XCEL.GetPlayerName(user_id).."**\n> Admin TempID: **"..admin_source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..v.name.."**\n> Player PermID: **"..v.permID.."**\n> Player TempID: **"..v.tempID.."**\n> Reason: **"..v.reason.."**")
                                XCELclient.teleport(admin_source, {table.unpack(coords)})
                                TriggerClientEvent("XCEL:removeEmergencyCall", -1, ticketID)
                                tickets[ticketID] = nil
                            end)
                        else
                            XCELclient.notify(admin_source,{"~r~You can't take your own ticket!"})
                        end
                    else
                        XCELclient.notify(admin_source,{"~r~You cannot take a ticket from an offline player."})
                        TriggerClientEvent("XCEL:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'met' and XCEL.hasPermission(user_id, "police.armoury") then
                    if XCEL.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            if v.tempID ~= nil then
                                XCELclient.notify(v.tempID,{"~b~Your MET Police call has been accepted!"})
                            end
                            tickets[ticketID] = nil
                            TriggerClientEvent("XCEL:removeEmergencyCall", -1, ticketID)
                        else
                            XCELclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("XCEL:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'nhs' and XCEL.hasPermission(user_id, "nhs.menu") then
                    if XCEL.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            XCELclient.notify(v.tempID,{"~g~Your NHS call has been accepted!"})
                            tickets[ticketID] = nil
                            TriggerClientEvent("XCEL:removeEmergencyCall", -1, ticketID)
                        else
                            XCELclient.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("XCEL:removeEmergencyCall", -1, ticketID)
                    end
                end
            end
        end
    end         
end)

RegisterNetEvent("XCEL:PDRobberyCall")
AddEventHandler("XCEL:PDRobberyCall", function(source, store, position)
    local source = source
    local user_id = XCEL.getUserId(source)
    callID = callID + 1
    tickets[callID] = {
        name = 'Store Robbery',
        permID = 999,
        tempID = nil,
        reason = 'Robbery in progress at '..store,
        type = 'met'
    }
    for k, v in pairs(XCEL.getUsers({})) do
        TriggerClientEvent("XCEL:addEmergencyCall", v, callID, 'Store Robbery', 999, position, 'Robbery in progress at '..store, 'met')
    end
end)

RegisterNetEvent("XCEL:NHSComaCall")
AddEventHandler("XCEL:NHSComaCall", function()
    local user_id = XCEL.getUserId(source)
    local user_source = XCEL.getUserSource(user_id)
    if XCEL.getUsersByPermission("nhs.menu") == nil then
        XCELclient.notify(user_source,{"~r~There are no NHS on duty."})
        return
    end
    XCELclient.notify(user_source,{"~g~NHS have been notified."})
    callID = callID + 1
    tickets[callID] = {
        name = XCEL.GetPlayerName(user_id),
        permID = user_id,
        tempID = user_source,
        reason = "Immediate Attention",
        type = 'nhs'
    }
    for k, v in pairs(XCEL.getUsers({})) do
        TriggerClientEvent("XCEL:addEmergencyCall", v, callID, XCEL.GetPlayerName(user_id), user_id, GetEntityCoords(GetPlayerPed(user_source)),"Immediate Attention", 'nhs')
    end
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    local user_id = XCEL.getUserId(source)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            exports['xcel']:ticketdm(source, { discordid, user_id }, function() end)
        end
    end
end)