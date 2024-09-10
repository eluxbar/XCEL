local announceTables = {
    {permission = 'admin.managecommunitypot', info = {name = "Server Announcement", desc = "Announce something to the server", price = 0}, image = 'https://i.imgur.com/FZMys0F.png'},
    {permission = 'police.announce', info = {name = "PD Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/I7c5LsN.png'},
    {permission = 'nhs.announce', info = {name = "NHS Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/SypLbMo.png'},
    {permission = 'lfb.announce', info = {name = "LFB Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/AFqPgYk.png'},
    {permission = 'hmp.announce', info = {name = "HMP Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/rPF5FgQ.png'},
}

RegisterServerEvent("XCEL:getAnnounceMenu")
AddEventHandler("XCEL:getAnnounceMenu", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local hasPermsFor = {}
    for k,v in pairs(announceTables) do
        if XCEL.hasPermission(user_id, v.permission) or XCEL.hasGroup(user_id, 'Founder') or XCEL.hasGroup(user_id, 'Lead Developer') or XCEL.hasGroup(user_id,"Developer") then
            table.insert(hasPermsFor, v.info)
        end
    end
    if #hasPermsFor > 0 then
        TriggerClientEvent("XCEL:buildAnnounceMenu", source, hasPermsFor)
    end
end)

RegisterServerEvent("XCEL:serviceAnnounce")
AddEventHandler("XCEL:serviceAnnounce", function(announceType)
    local source = source
    local user_id = XCEL.getUserId(source)
    for k,v in pairs(announceTables) do
        if v.info.name == announceType then
            if XCEL.hasPermission(user_id, v.permission) or XCEL.getStaffLevel(user_id) >= 5 then
                if XCEL.tryFullPayment(user_id, v.info.price) then
                    XCEL.prompt(source,"Input text to announce","",function(source,data) 
                        if data ~= "" and data ~= nil then
                        -- TriggerClientEvent('XCEL:serviceAnnounceCl', -1, v.image, data)
                            TriggerClientEvent('XCEL:smallAnnouncement', -1, "XCEL ANNOUNCEMENT", data, 2, 10000) 
                            if v.info.price > 0 then
                                XCELclient.notify(source, {"~g~Purchased a "..v.info.name.." for £"..v.info.price.." with content ~b~"..data})
                                XCEL.sendWebhook('announce', "XCEL Announcement Logs", "```"..data.."```".."\n> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
                            else
                                XCELclient.notify(source, {"~g~Sending a "..v.info.name.." with content ~b~"..data})
                                XCEL.sendWebhook('announce', "XCEL Announcement Logs", "```"..data.."```".."\n> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
                            end
                        else
                            XCELclient.notify(source, {"~r~Invalid input."})
                        end
                    end)
                else
                    XCELclient.notify(source, {"~r~You do not have enough money to do this."})
                end
            else
                XCEL.ACBan(15,user_id,'XCEL:serviceAnnounce')
            end
        end
    end
end)



RegisterCommand("consoleannounce", function(source, args)
    local source = source
    if source == 0 then
        local data = table.concat(args, " ")
        print("[XCEL Announcement] "..data)
        TriggerClientEvent('XCEL:serviceAnnounceCl', -1, 'https://i.imgur.com/FZMys0F.png', data)
        XCEL.sendWebhook('announce', "XCEL Announcement Logs", "```"..data.."```")
    else
        XCELclient.notify(source, {"~r~You do not have permission to do this."})
    end
end)