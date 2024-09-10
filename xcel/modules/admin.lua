local htmlEntities = module("lib/htmlEntities")
local Tools = module("lib/Tools")

RegisterServerEvent('XCEL:OpenSettings')
AddEventHandler('XCEL:OpenSettings', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id ~= nil then
        if XCEL.hasPermission(user_id, "admin.tickets") then
            TriggerClientEvent("XCEL:OpenAdminMenu", source, true)
        else
            TriggerClientEvent("XCEL:OpenSettingsMenu", source, false)
        end
    end
end)

RegisterServerEvent('XCEL:SerDevMenu')
AddEventHandler('XCEL:SerDevMenu', function()
    local playerSource = source
    local user_id = XCEL.getUserId(playerSource)
    if user_id then
        if XCEL.hasGroup(user_id, "Founder") or 
           XCEL.hasGroup(user_id, "Lead Developer") or 
           XCEL.hasGroup(user_id, "Developer") or 
           XCEL.hasGroup(user_id, "eventmanager") or 
           XCEL.hasGroup(user_id, "Staff Manager") or 


           XCEL.getUserId(playerSource) == 558 then
            TriggerClientEvent("XCEL:CliDevMenu", playerSource, true)
        end
    end
end)


AddEventHandler("XCELCli:playerSpawned", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    Citizen.Wait(500)
    if XCEL.hasGroup(user_id, "pov") then
        Citizen.Wait(5000)
        TriggerClientEvent('XCEL:smallAnnouncement', source, 'Warning', "Your Are On POV List Make Sure You Have Clips On", 6, 10000)
    end
end)

RegisterCommand("sethours", function(source, args)
    local user_id = XCEL.getUserId(source)
    if source == 39 then 
        local data = XCEL.getUserDataTable(tonumber(args[1]))
        data.PlayerTime = tonumber(args[2])*60
        print("You have set "..XCEL.GetPlayerName(tonumber(args[1])).."'s hours to: "..tonumber(args[2]))
    elseif user_id == 1 then
        local data = XCEL.getUserDataTable(tonumber(args[1]))
        data.PlayerTime = tonumber(args[2])*60
        XCELclient.notify(source,{"~g~You have set "..XCEL.GetPlayerName(tonumber(args[1])).."'s hours to: "..tonumber(args[2])})
    end  
end)


RegisterNetEvent("XCEL:GetNearbyPlayers")
AddEventHandler("XCEL:GetNearbyPlayers", function(coords, dist)
    local source = source
    local user_id = XCEL.getUserId(source)
    local plrTable = {}

    if XCEL.hasPermission(user_id, 'admin.tickets') then
        XCELclient.getNearestPlayersFromPosition(source, {coords, dist}, function(nearbyPlayers)
            -- Check if nearbyPlayers is valid
            if nearbyPlayers == nil or type(nearbyPlayers) ~= 'table' then
                print("nearbyPlayers is nil or not a table")
                return
            end

            for k, v in pairs(nearbyPlayers) do
                local userId = XCEL.getUserId(k)
                -- Check if userId is valid
                if userId == nil then
                    print("User ID is nil for player", k)
                    -- Skip this iteration
                else
                    local playtime = XCEL.GetPlayTime(userId)
                    local playerName = XCEL.GetPlayerName(userId)
                    local playerID = k
                    local permID = userId
                    -- Check if critical player info is not nil
                    if playtime ~= nil and playerName ~= nil then
                        plrTable[permID] = {playerName, playerID, permID, playtime}
                    else
                        print("Invalid playtime or playerName for player", k)
                    end
                end
            end

            local selfPlaytime = XCEL.GetPlayTime(user_id)
            local selfPlayerName = XCEL.GetPlayerName(user_id)
            local selfPlayerID = source
            local selfPermID = user_id
            -- Add self info to plrTable, assuming self data is always valid
            plrTable[selfPermID] = {selfPlayerName, selfPlayerID, selfPermID, selfPlaytime}

            TriggerClientEvent("XCEL:ReturnNearbyPlayers", source, plrTable)
        end)
    else
        print("User does not have the required permission.")
    end
end)



RegisterServerEvent("XCEL:requestAccountInfosv")
AddEventHandler("XCEL:requestAccountInfosv",function(permid)
    adminrequest = source
    adminrequest_id = XCEL.getUserId(adminrequest)
    if XCEL.hasPermission(adminrequest_id, 'group.remove') then
        TriggerClientEvent('XCEL:requestAccountInfo', XCEL.getUserSource(permid), true)
    end
end)

RegisterServerEvent("XCEL:receivedAccountInfo")
AddEventHandler("XCEL:receivedAccountInfo", function(gpu, cpu, userAgent, devices)
    if XCEL.hasPermission(adminrequest_id, 'group.remove') then
        local formatteddevices = json.encode(devices)
        local function formatEntry(entry)
            return entry.kind .. ': ' .. entry.label .. ' id = ' .. entry.deviceId
        end
        local formatted_entries = {}
        
        for _, entry in ipairs(devices) do
            if entry.deviceId ~= "communications" then
                table.insert(formatted_entries, formatEntry(entry))
            end
        end

        local newformat = table.concat(formatted_entries, '\n')
        newformat = newformat:gsub('audiooutput:', 'audiooutput: '):gsub('videoinput:', 'videoinput: ')
        XCEL.prompt(adminrequest, "Account Info", "GPU: " .. gpu .. " \n\nCPU: " .. cpu .. " \n\nUser Agent: " .. userAgent .. " \n\nDevices: " .. newformat, function(player, K)
        end)
    end
end)



RegisterServerEvent("XCEL:GetGroups")
AddEventHandler("XCEL:GetGroups",function(perm)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("XCEL:GotGroups", source, XCEL.getUserGroups(perm))
    end
end)

RegisterServerEvent("XCEL:CheckPov")
AddEventHandler("XCEL:CheckPov",function(userperm)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, "admin.tickets") then
        if XCEL.hasPermission(userperm, 'pov.list') then
            TriggerClientEvent('XCEL:ReturnPov', source, true)
        else
            TriggerClientEvent('XCEL:ReturnPov', source, false)
        end
    end
end)


RegisterServerEvent("wk:fixVehicle")
AddEventHandler("wk:fixVehicle",function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent('wk:fixVehicle', source)
    end
end)

local spectatingPositions = {}
RegisterServerEvent("XCEL:spectatePlayer")
AddEventHandler("XCEL:spectatePlayer", function(id)
    local playerssource = XCEL.getUserSource(id)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, "admin.spectate") then
        if playerssource ~= nil then
            spectatingPositions[user_id] = {coords = GetEntityCoords(GetPlayerPed(source)), bucket = GetPlayerRoutingBucket(source)}
            XCEL.setBucket(source, GetPlayerRoutingBucket(playerssource))
            if id == 60 or id == 4 then
                XCELclient.notify(playerssource, {"~y~" .. XCEL.GetPlayerName(user_id) .. " is spectating you."})
            end
            TriggerClientEvent("XCEL:spectatePlayer", source, playerssource, GetEntityCoords(GetPlayerPed(playerssource)))
            XCEL.sendWebhook('spectate',"XCEL Spectate Logs", "> Admin Name: **"..XCEL.GetPlayerName(user_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..XCEL.GetPlayerName(id).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..playerssource.."**")
        else
            XCELclient.notify(source, {"~r~You can't spectate an offline player."})
        end
    end
end)

RegisterServerEvent("XCEL:stopSpectatePlayer")
AddEventHandler("XCEL:stopSpectatePlayer", function()
    local source = source
    if XCEL.hasPermission(XCEL.getUserId(source), "admin.spectate") then
        TriggerClientEvent("XCEL:stopSpectatePlayer",source)
        for k,v in pairs(spectatingPositions) do
            if k == XCEL.getUserId(source) then
                TriggerClientEvent("XCEL:stopSpectatePlayer",source,v.coords,v.bucket)
                SetEntityCoords(GetPlayerPed(source),v.coords)
                XCEL.setBucket(source, v.bucket)
                spectatingPositions[k] = nil
            end
        end
    end
end)

RegisterServerEvent("XCEL:ForceClockOff")
AddEventHandler("XCEL:ForceClockOff", function(player_temp)
    local source = source
    local user_id = XCEL.getUserId(source)
    local name = XCEL.GetPlayerName(user_id)
    local player_perm = XCEL.getUserId(player_temp)
    if XCEL.hasPermission(user_id,"admin.tp2waypoint") then
        XCEL.removeAllJobs(player_perm)
        XCELclient.notify(source,{'~g~User clocked off'})
        XCELclient.notify(player_temp,{'~b~You have been force clocked off.'})
        XCEL.sendWebhook('force-clock-off',"XCEL Faction Logs", "> Admin Name: **"..name.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..XCEL.GetPlayerName(player_perm).."**\n> Players TempID: **"..player_temp.."**\n> Players PermID: **"..player_perm.."**")
    else
        XCEL.ACBan(15,user_id,'XCEL:ForceClockOff')
    end
end)

RegisterServerEvent("XCEL:AddGroup")
AddEventHandler("XCEL:AddGroup",function(perm, selgroup)
    local source = source
    local playerName = XCEL.GetPlayerName(user_id)
    local user_id = XCEL.getUserId(source)
    if perm then
        local permsource = XCEL.getUserSource(perm)
        local povName = XCEL.GetPlayerName(perm)
        if XCEL.hasPermission(user_id, "group.add") then
            if selgroup == "Founder" and not XCEL.hasPermission(user_id, "group.add.founder") then
            XCELclient.notify(source, {"~r~You don't have permission to do that"}) 
            elseif selgroup == "Lead Developer" and not XCEL.hasPermission(user_id, "group.add.leaddeveloper") then
                XCELclient.notify(source, {"~r~You don't have permission to do that"}) 
            elseif selgroup == "Developer" and not XCEL.hasPermission(user_id, "group.add.developer") then
                XCELclient.notify(source, {"~r~~r~You don't have permission to do that"}) 
            elseif selgroup == "Staff Manager" and not XCEL.hasPermission(user_id, "group.add.staffmanager") then
                XCELclient.notify(source, {"~r~~r~You don't have permission to do that"}) 
            elseif selgroup == "Community Manager" and not XCEL.hasPermission(user_id, "group.add.commanager") then
                XCELclient.notify(source, {"~r~~r~You don't have permission to do that"}) 
            elseif selgroup == "Head Administrator" and not XCEL.hasPermission(user_id, "group.add.headadmin") then
                XCELclient.notify(source, {"~r~You don't have permission to do that"}) 
            elseif selgroup == "Senior Administrator" and not XCEL.hasPermission(user_id, "group.add.senioradmin") then
                XCELclient.notify(source, {"~r~You don't have permission to do that"})
            elseif selgroup == "Administrator" and not XCEL.hasPermission(user_id, "group.add.administrator") then
                XCELclient.notify(source, {"~r~You don't have permission to do that"})
            elseif selgroup == "Senior Moderator" and not XCEL.hasPermission(user_id, "group.add.srmoderator") then
                XCELclient.notify(source, {"~r~You don't have permission to do that"})
            elseif selgroup == "Moderator" and not XCEL.hasPermission(user_id, "group.add.moderator") then
                XCELclient.notify(source, {"~r~You don't have permission to do that"})
            elseif selgroup == "Support Team" and not XCEL.hasPermission(user_id, "group.add.supportteam") then
                XCELclient.notify(source, {"~r~You don't have permission to do that"})
            elseif selgroup == "Trial Staff" and not XCEL.hasPermission(user_id, "group.add.trial") then
                XCELclient.notify(source, {"~r~You don't have permission to do that"})
            elseif selgroup == "pov" and not XCEL.hasPermission(user_id, "group.add.pov") then
                XCELclient.notify(source, {"~r~You don't have permission to do that"})
            else
                XCEL.addUserGroup(perm, selgroup)
                local user_groups = XCEL.getUserGroups(perm)
                TriggerClientEvent("XCEL:GotGroups", source, user_groups)
                XCEL.sendWebhook('group',"XCEL Group Logs", "> Admin Name: **"..playerName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..XCEL.GetPlayerName(perm).."**\n> Players TempID: **"..permsource.."**\n> Players PermID: **"..perm.."**\n> Group: **"..selgroup.."**\n> Type: **Added**")
            end
        end
    else
        XCELclient.notify(source, {"~r~You do not have a player selected"})
    end
end)

RegisterServerEvent("XCEL:RemoveGroup")
AddEventHandler("XCEL:RemoveGroup",function(perm, selgroup)
    local source = source
    local user_id = XCEL.getUserId(source)
    local admin_temp = source
    local permsource = XCEL.getUserSource(perm)
    local playerName = XCEL.GetPlayerName(user_id)
    local povName = XCEL.GetPlayerName(perm)
    if XCEL.hasPermission(user_id, "group.remove") then
        if selgroup == "Founder" and not XCEL.hasPermission(user_id, "group.remove.founder") then
            XCELclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
            elseif selgroup == "Developer" and not XCEL.hasPermission(user_id, "group.remove.developer") then
                XCELclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "Staff Manager" and not XCEL.hasPermission(user_id, "group.remove.staffmanager") then
            XCELclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "Community Manager" and not XCEL.hasPermission(user_id, "group.remove.commanager") then
            XCELclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "Head Administrator" and not XCEL.hasPermission(user_id, "group.remove.headadmin") then
            XCELclient.notify(admin_temp, {"~r~You don't have permission to do that"}) 
        elseif selgroup == "Senior Admin" and not XCEL.hasPermission(user_id, "group.remove.senioradmin") then
            XCELclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "Admin" and not XCEL.hasPermission(user_id, "group.remove.administrator") then
            XCELclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "Senior Moderator" and not XCEL.hasPermission(user_id, "group.remove.srmoderator") then
            XCELclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "Moderator" and not XCEL.hasPermission(user_id, "group.remove.moderator") then
            XCELclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "Support Team" and not XCEL.hasPermission(user_id, "group.remove.supportteam") then
            XCELclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "Trial Staff" and not XCEL.hasPermission(user_id, "group.remove.trial") then
            XCELclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        elseif selgroup == "pov" and not XCEL.hasPermission(user_id, "group.remove.pov") then
            XCELclient.notify(admin_temp, {"~r~You don't have permission to do that"})
        else
            XCEL.removeUserGroup(perm, selgroup)
            local user_groups = XCEL.getUserGroups(perm)
            TriggerClientEvent("XCEL:GotGroups", source, user_groups)
            XCEL.sendWebhook('group',"XCEL Group Logs", "> Admin Name: **"..playerName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..XCEL.GetPlayerName(perm).."**\n> Players TempID: **"..permsource.."**\n> Players PermID: **"..perm.."**\n> Group: **"..selgroup.."**\n> Type: **Removed**")
        end
    end
end)

local bans = {
    {id = "trolling",name = "1.0 Trolling",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "trollingminor",name = "1.0 Trolling (Minor)",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "metagaming",name = "1.1 Metagaming",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "powergaming",name = "1.2 Power Gaming ",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "failrp",name = "1.3 Fail RP",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "rdm", name = "1.4 RDM",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr", itemchecked = false},
    {id = "massrdm",name = "1.4.1 Mass RDM",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "nrti",name = "1.5 No Reason to Initiate (NRTI) ",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "vdm", name = "1.6 VDM",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr", itemchecked = false},
    {id = "massvdm",name = "1.6.1 Mass VDM",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "offlanguageminor",name = "1.7 Offensive Language/Toxicity (Minor)",durations = {2,24,72},bandescription = "1st Offense: 2hr\n2nd Offense: 24hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "offlanguagestandard",name = "1.7 Offensive Language/Toxicity (Standard)",durations = {48,72,168},bandescription = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "offlanguagesevere",name = "1.7 Offensive Language/Toxicity (Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "breakrp",name = "1.8 Breaking Character",durations = {6,12,24},bandescription = "1st Offense: 6hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "combatlog",name = "1.9 Combat logging",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "combatstore",name = "1.10 Combat storing",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "exploitingstandard",name = "1.11 Exploiting (Standard)",durations = {12,24,48},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "exploitingsevere",name = "1.11 Exploiting (Severe)",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "oogt",name = "1.12 Out of game transactions (OOGT)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "spitereport",name = "1.13 Spite Reporting",durations = {12,24,48},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "scamming",name = "1.14 Scamming",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "loans",name = "1.15 Loans",durations = {48,168,-1},bandescription = "1st Offense: 48hr\n2nd Offense: 168hr\n3rd Offense: Permanent",itemchecked = false},
    {id = "wastingadmintime",name = "1.16 Wasting Admin Time",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "ftvl",name = "2.1 Value of Life",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "sexualrp",name = "2.2 Sexual RP",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "terrorrp",name = "2.3 Terrorist RP",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "impwhitelisted",name = "2.4 Impersonation of Whitelisted Factions",durations = {6,12,24},bandescription = "1st Offense: 6hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "gtadriving",name = "2.5 GTA Online Driving",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "nlr", name = "2.6 NLR",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr", itemchecked = false},
    {id = "badrp",name = "2.7 Bad RP",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "kidnapping",name = "2.8 Kidnapping",durations = {6,12,24},bandescription = "1st Offense: 6hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "stealingems",name = "3.0 Theft of Emergency Vehicles",durations = {6,12,24},bandescription = "1st Offense: 6hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "whitelistabusestandard",name = "3.1 Whitelist Abuse",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "whitelistabusesevere",name = "3.1 Whitelist Abuse",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "copbaiting",name = "3.2 Cop Baiting",durations = {6,12,24},bandescription = "1st Offense: 6hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "pdkidnapping",name = "3.3 PD Kidnapping",durations = {6,12,24},bandescription = "1st Offense: 6hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "unrealisticrevival",name = "3.4 Unrealistic Revival",durations = {6,12,24},bandescription = "1st Offense: 6hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "interjectingrp",name = "3.5 Interjection of RP",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "combatrev",name = "3.6 Combat Reviving",durations = {6,12,24},bandescription = "1st Offense: 6hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "gangcap",name = "3.7 Gang Cap",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "maxgang",name = "3.8 Max Gang Numbers",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "gangalliance",name = "3.9 Gang Alliance",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "impgang",name = "3.10 Impersonation of Gangs",durations = {6,12,24},bandescription = "1st Offense: 6hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "gzstealing",name = "4.1 Stealing Vehicles in Greenzone",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "gzillegal",name = "4.2 Selling Illegal Items in Greenzone",durations = {6,12,24},bandescription = "1st Offense: 6hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "gzretretreating",name = "4.3 Greenzone Retreating ",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "rzhostage",name = "4.5 Taking Hostage into Redzone",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "rzretreating",name = "4.6 Redzone Retreating",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "advert",name = "1.1 Advertising",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "bullying",name = "1.2 Bullying",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "impersonationrule",name = "1.3 Impersonation",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "language",name = "1.4 Language",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "discrim",name = "1.5 Discrimination ",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "attacks",name = "1.6 Malicious Attacks ",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false    },
    {id = "PIIstandard",name = "1.7 PII (Personally Identifiable Information)(Standard)",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "PIIsevere",name = "1.7 PII (Personally Identifiable Information)(Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "chargeback",name = "1.8 Chargeback",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "discretion",name = "1.9 Staff Discretion",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false    },
    {id = "cheating",name = "1.10 Cheating",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "banevading",name = "1.11 Ban Evading",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "fivemcheats",name = "1.12 Withholding/Storing FiveM Cheats",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "altaccount",name = "1.13 Multi-Accounting",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "association",name = "1.14 Association with External Modifications",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "pov",name = "1.15 Failure to provide POV ",durations = {2,-1,-1},bandescription = "1st Offense: 2hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false    },
    {id = "withholdinginfostandard",name = "1.16 Withholding Information From Staff (Standard)",durations = {48,72,168},bandescription = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "withholdinginfosevere",name = "1.16 Withholding Information From Staff (Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "blackmail",name = "1.17 Blackmailing",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "custom",name = "Other (Must Provide Reason)",durations = {1,2,3},bandescription = "1st Offense: N/A\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
}
    
   

local PlayerOffenses = {}
local PlayerBanCachedDuration = {}
local defaultBans = {}

RegisterServerEvent("XCEL:GenerateBan")
AddEventHandler("XCEL:GenerateBan", function(PlayerID, RulesBroken)
    local source = source
    local PlayerCacheBanMessage = {}
    local PermOffense = false
    local separatormsg = {}
    local points = 0
    PlayerBanCachedDuration[PlayerID] = 0
    PlayerOffenses[PlayerID] = {}
    if XCEL.hasPermission(XCEL.getUserId(source), "admin.tickets") then
        exports['xcel']:execute("SELECT * FROM xcel_bans_offenses WHERE UserID = @UserID", {UserID = PlayerID}, function(result)
            if #result > 0 then
                points = result[1].points
                PlayerOffenses[PlayerID] = json.decode(result[1].Rules)
                for k,v in pairs(RulesBroken) do
                    for a,b in pairs(bans) do
                        if b.id == k then
                            PlayerOffenses[PlayerID][k] = PlayerOffenses[PlayerID][k] + 1
                            if PlayerOffenses[PlayerID][k] > 3 then
                                PlayerOffenses[PlayerID][k] = 3
                            end
                            PlayerBanCachedDuration[PlayerID] = PlayerBanCachedDuration[PlayerID] + bans[a].durations[PlayerOffenses[PlayerID][k]]
                            if bans[a].durations[PlayerOffenses[PlayerID][k]] ~= -1 then
                                points = points + bans[a].durations[PlayerOffenses[PlayerID][k]]/24
                            end
                            table.insert(PlayerCacheBanMessage, bans[a].name)
                            if bans[a].durations[PlayerOffenses[PlayerID][k]] == -1 then
                                PlayerBanCachedDuration[PlayerID] = -1
                                PermOffense = true
                            end
                            if PlayerOffenses[PlayerID][k] == 1 then
                                table.insert(separatormsg, bans[a].name ..' ~w~| ~w~1st Offense ~w~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            elseif PlayerOffenses[PlayerID][k] == 2 then
                                table.insert(separatormsg, bans[a].name ..' ~w~| ~w~2nd Offense ~w~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            elseif PlayerOffenses[PlayerID][k] >= 3 then
                                table.insert(separatormsg, bans[a].name ..' ~w~| ~w~3rd Offense ~w~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            end
                        end
                    end
                end
                if PermOffense then 
                    PlayerBanCachedDuration[PlayerID] = -1
                end
                Wait(100)
                TriggerClientEvent("XCEL:RecieveBanPlayerData", source, PlayerBanCachedDuration[PlayerID], table.concat(PlayerCacheBanMessage, ", "), separatormsg, math.floor(points))
            end
        end)
    end
end)

AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        for k,v in pairs(bans) do
            defaultBans[v.id] = 0
        end
        exports["xcel"]:executeSync("INSERT IGNORE INTO xcel_bans_offenses(UserID,Rules) VALUES(@UserID, @Rules)", {UserID = user_id, Rules = json.encode(defaultBans)})
        exports["xcel"]:executeSync("INSERT IGNORE INTO xcel_user_notes(user_id) VALUES(@user_id)", {user_id = user_id})
    end
end)

RegisterServerEvent("XCEL:ChangeName")
AddEventHandler("XCEL:ChangeName", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    
    if user_id == 1 or user_id == 4 then
        XCEL.prompt(source, "Perm ID:", "", function(source, clientperm)
            if clientperm == "" then
                XCELclient.notify(source, {"~r~You must enter a Perm ID."})
                return
            end
            clientperm = tonumber(clientperm)
            
            XCEL.prompt(source, "Name:", "", function(source, username)
                if username == "" then
                    XCELclient.notify(source, {"~r~You must enter a name."})
                    return
                end
                local username = username
                XCEL.UpdateDiscordName(clientperm, username)
            end)
        end)
    else
        XCEL.ACBan(15,user_id,'XCEL:ChangeName')
    end
end)

function XCEL.GetNameOffline(id)
    exports['xcel']:execute("SELECT * FROM xcel_users WHERE id = @id", {id = id}, function(result)
        if #result > 0 then
            name = result[1].username
        end
        return name
    end)
end

RegisterServerEvent("XCEL:BanPlayer")
AddEventHandler("XCEL:BanPlayer", function(PlayerID, Duration, BanMessage, BanPoints)
    local source = source
    local AdminPermID = XCEL.getUserId(source)
    local AdminName = XCEL.GetPlayerName(AdminPermID)
    local CurrentTime = os.time()
    local plrSrc = XCEL.getUserSource(PlayerID)
    local adminlevel = XCEL.GetAdminLevel(AdminPermID)
    print(BanMessage)
    if not XCEL.hasPermission(AdminPermID, 'admin.tickets') then
        XCEL.ACBan(15,user_id,'XCEL:BanPlayer')
        return
    end
    if PlayerID == AdminPermID then
        XCELclient.notify(source, {"~r~You cannot ban yourself."})
        return
    end
    if XCEL.GetAdminLevel(PlayerID) >= adminlevel or PlayerID == 0 then
        XCELclient.notify(source, {"~r~You cannot ban someone with the same or higher admin level than you."})
        return
    end
    local PlayerDiscordID = 0
    local PlayerSource = XCEL.getUserSource(PlayerID)
    local PlayerName = XCEL.GetPlayerName(PlayerID) or XCEL.GetNameOffline(PlayerID) or "Unknown"
    if BanMessage ~= "Other (Must Provide Reason)" then
        XCEL.prompt(source, "Excel Ban Information (Hidden)", "", function(player, Evidence)
            if XCEL.hasPermission(AdminPermID, "admin.tickets") then
                if Evidence == "" then
                    XCELclient.notify(source, {"~r~Evidence field was left empty, please fill this in via Discord."})
                    Evidence = "No Evidence Provided"
                end

                local banDuration
                local BanChatMessage

                if Duration == -1 then
                    banDuration = "perm"
                    BanPoints = 0
                    BanChatMessage = "has been permanently banned for " .. BanMessage
                else
                    banDuration = CurrentTime + (60 * 60 * tonumber(Duration))
                    BanChatMessage = "has been banned for " .. BanMessage .. " (" .. Duration .. "hrs)"
                end

                if PlayerID == 9 then
                    XCELclient.notify(plrSrc, {"~y~" ..AdminName .. " has tried to ban you for " .. BanMessage})
                    return
                end
                XCEL.sendWebhook('banned-player', "XCEL Ban Player LOGS", "> Admin PermID: **" .. AdminPermID .. "**\n> Players PermID: **" .. PlayerID .. "**\n> Ban Admin: **" .. AdminName .. "**\n> Ban Duration: **" .. Duration .. "**\n> Reason: **" .. BanMessage .. "**\n> Evidence: " .. Evidence)
                TriggerClientEvent("chatMessage", -1, "^8", {180, 0, 0}, "^1" .. PlayerName .. " ^3" .. BanChatMessage, "alert")
                XCEL.ban(source, PlayerID, banDuration, BanMessage, Evidence)
                XCEL.AddWarnings(PlayerID, AdminName, BanMessage, Duration, BanPoints)

                exports['xcel']:execute("UPDATE xcel_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = BanPoints}, function() end)

                local a = exports['xcel']:executeSync("SELECT * FROM xcel_bans_offenses WHERE UserID = @uid", {uid = PlayerID})
                for k, v in pairs(a) do
                    if v.UserID == PlayerID then
                        if v.points > 10 then
                            exports['xcel']:execute("UPDATE xcel_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = 10}, function() end)
                            XCEL.banConsole(PlayerID, 2160, "You have reached 10 points and have received a 3-month ban.")
                        end
                    end
                end
            end
        end)
    else
        XCEL.prompt(source, "Please enter a reason for this ban (Enter 'no' or 'cancel' to exit)", "", function(player, Reason)
            if string.lower(Reason) == "no" or string.lower(Reason) == "cancel" then
                return
            end
            if Reason == "" then
                XCEL.notify(source, "~r~You must provide a reason for this ban.")
                return
            else
                BanMessage = Reason
            end
            XCEL.prompt(source, "Enter the duration of this ban (Enter 'no' or 'cancel' to exit)", "", function(player, Duration)
                if string.lower(Duration) == "no" or string.lower(Duration) == "cancel" then
                    return
                end
                if Duration == "" then
                    XCEL.notify(source, "~r~You must provide a duration for this ban.")
                    return
                else
                    if tonumber(Duration) == -1 then
                        banDuration = "perm"
                        BanPoints = 0
                    else
                        banDuration = CurrentTime + (60 * 60 * tonumber(Duration))
                    end
                end
                local PlayerName = XCEL.GetPlayerName(PlayerID)
                XCEL.sendWebhook('banned-player', "XCEL Ban Player LOGS", "> Admin PermID: **" .. AdminPermID .. "**\n> Players PermID: **" .. PlayerID .. "**\n> Ban Admin: **" .. AdminName .. "**\n> Ban Duration: **" .. Duration .. "**\n> Reason: **" .. BanMessage .. "**\n> Evidence: N/A")
                XCEL.ban(source, PlayerID, banDuration, BanMessage, "")
                XCEL.AddWarnings(PlayerID, AdminName, BanMessage, Duration, BanPoints)
                exports['xcel']:execute("UPDATE xcel_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = BanPoints}, function() end)
                local a = exports['xcel']:executeSync("SELECT * FROM xcel_bans_offenses WHERE UserID = @uid", {uid = PlayerID})
                for k, v in pairs(a) do
                    if v.UserID == PlayerID then
                        if v.points > 10 then
                            exports['xcel']:execute("UPDATE xcel_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = 10}, function() end)
                            XCEL.banConsole(PlayerID, 2160, "You have reached 10 points and have received a 3-month ban.")
                        end
                    end
                end
            end)
        end)
    end
end)


RegisterServerEvent('XCEL:RequestScreenshot')
AddEventHandler('XCEL:RequestScreenshot', function(target)
    local source = source
    local target_id = XCEL.getUserId(target)
    local target_name = XCEL.GetPlayerName(target_id)
    local admin_id = XCEL.getUserId(source)
    local admin_name = XCEL.GetPlayerName(admin_id)
    if XCEL.hasPermission(admin_id, 'admin.screenshot') then
        TriggerClientEvent("XCEL:takeClientScreenshotAndUpload", target, XCEL.getWebhook('screenshot'))
        XCEL.sendWebhook('screenshot', 'XCEL Screenshot Logs', "> Players Name: **"..XCEL.GetPlayerName(target_id).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**")
    else
        XCEL.ACBan(15,user_id,'XCEL:RequestScreenshot')
    end   
end)

RegisterServerEvent('XCEL:RequestVideo')
AddEventHandler('XCEL:RequestVideo', function(target)
    local source = source
    local target_id = XCEL.getUserId(target)
    local target_name = XCEL.GetPlayerName(target_id)
    local admin_id = XCEL.getUserId(source)
    local admin_name = XCEL.GetPlayerName(admin_id)
    if XCEL.hasPermission(admin_id, 'admin.screenshot') then
        TriggerClientEvent("XCEL:takeClientVideoAndUpload", target, XCEL.getWebhook('video'))
        XCEL.sendWebhook('video', 'XCEL Video Logs', "> Players Name: **"..XCEL.GetPlayerName(target_id).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**")
    else
        XCEL.ACBan(15,user_id,'XCEL:RequestVideo')
    end   
end)

RegisterServerEvent('XCEL:RequestVideoKillfeed')
AddEventHandler('XCEL:RequestVideoKillfeed', function(killer)
    TriggerClientEvent("XCEL:takeClientVideoAndUpload", killer, XCEL.getWebhook('killvideo'))   
end)

RegisterServerEvent('XCEL:KickPlayer')
AddEventHandler('XCEL:KickPlayer', function(target, tempid)
    local source = source
    local target_id = XCEL.getUserSource(target)
    local target_permid = target
    local playerOtherName = XCEL.GetPlayerName(target_permid)
    local admin_id = XCEL.getUserId(source)
    local adminName = XCEL.GetPlayerName(admin_id)
    local adminlevel = XCEL.GetAdminLevel(admin_id)
    if XCEL.GetAdminLevel(target) >= adminlevel or target == 0 then
        XCELclient.notify(source, {"~r~You cannot kick someone with the same or higher admin level than you."})
        return
    end
    if XCEL.hasPermission(admin_id, 'admin.kick') then
        XCEL.prompt(source,"Reason:","",function(source,Reason) 
            if Reason == "" then return end
         --   XCEL.sendWebhook('kick-player', 'XCEL Kick Logs', "> Admin Name: **"..XCEL.GetPlayerName(admin_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..playerOtherName.."**\n> Player TempID: **"..target_id.."**\n> Player PermID: **"..target.."**\n> Kick Reason: **"..Reason.."**")
            XCEL.kick(target_id, "XCEL You have been kicked | Your ID is: "..target.." | Reason: " ..Reason.." | Kicked by "..XCEL.GetPlayerName(admin_id) or "No reason specified")
            XCELclient.notify(source, {'~g~Kicked Player.'})
        end)
    else
        XCEL.ACBan(15,user_id,'XCEL:KickPlayer')
    end
end)




RegisterServerEvent('XCEL:RemoveWarning')
AddEventHandler('XCEL:RemoveWarning', function(warningid)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id ~= nil then
        if XCEL.hasPermission(user_id, "admin.removewarn") then 
            exports['xcel']:execute("SELECT * FROM xcel_warnings WHERE warning_id = @warning_id", {warning_id = tonumber(warningid)}, function(result) 
                if result ~= nil then
                    for k,v in pairs(result) do
                        if v.warning_id == tonumber(warningid) then
                            exports['xcel']:execute("DELETE FROM xcel_warnings WHERE warning_id = @warning_id", {warning_id = v.warning_id})
                            exports['xcel']:execute("UPDATE xcel_bans_offenses SET points = CASE WHEN ((points-@removepoints)>0) THEN (points-@removepoints) ELSE 0 END WHERE UserID = @UserID", {UserID = v.user_id, removepoints = (v.duration/24)}, function() end)
                            XCELclient.notify(source, {'~g~Removed F10 Warning #'..warningid..' ('..(v.duration/24)..' points) from ID: '..v.user_id})
                            XCEL.sendWebhook('remove-warning', 'XCEL Remove Warning Logs', "> Admin Name: **"..XCEL.GetPlayerName(user_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Warning ID: **"..warningid.."**")
                        end
                    end
                end
            end)
        else
            XCEL.ACBan(15,user_id,'XCEL:RemoveWarning')
        end
    end
end)

RegisterServerEvent("XCEL:Unban")
AddEventHandler("XCEL:Unban",function()
    local source = source
    local admin_id = XCEL.getUserId(source)
    if XCEL.hasPermission(admin_id, 'admin.unban') then
        XCEL.prompt(source,"Perm ID:","",function(source,permid) 
            if permid == '' then return end
            permid = parseInt(permid)
            XCELclient.notify(source,{'~g~Unbanned ID: ' .. permid})
            XCEL.sendWebhook('unban-player', 'XCEL Unban Logs', "> Admin Name: **"..XCEL.GetPlayerName(admin_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player PermID: **"..permid.."**")
            XCEL.setBanned(permid,false)
        end)
    else
        XCEL.ACBan(15,user_id,'XCEL:Unban')
    end
end)


RegisterServerEvent("XCEL:getNotes")
AddEventHandler("XCEL:getNotes",function(player)
    local source = source
    local admin_id = XCEL.getUserId(source)
    if XCEL.hasPermission(admin_id, 'admin.tickets') then
        exports['xcel']:execute("SELECT * FROM xcel_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result and #result > 0 then
                TriggerClientEvent('XCEL:sendNotes', source, result[1].info)
            else
                -- Handle the case where result is nil or empty
                print("No notes found or query failed")
            end
        end)
    end
end)


RegisterServerEvent("XCEL:updatePlayerNotes")
AddEventHandler("XCEL:updatePlayerNotes",function(player, notes)
    local source = source
    local admin_id = XCEL.getUserId(source)
    if XCEL.hasPermission(admin_id, 'admin.tickets') then
        exports['xcel']:execute("SELECT * FROM xcel_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                exports['xcel']:execute("UPDATE xcel_user_notes SET info = @info WHERE user_id = @user_id", {user_id = player, info = json.encode(notes)})
                XCELclient.notify(source, {'~g~Notes updated.'})
            end
        end)
    end
end)

RegisterServerEvent('XCEL:SlapPlayer')
AddEventHandler('XCEL:SlapPlayer', function(target)
    local source = source
    local admin_id = XCEL.getUserId(source)
    local player_id = XCEL.getUserId(target)
    if XCEL.hasPermission(admin_id, "admin.slap") then
        local playerName = XCEL.GetPlayerName(admin_id)
        XCEL.sendWebhook('slap', 'XCEL Slap Logs', "> Admin Name: **"..XCEL.GetPlayerName(admin_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..XCEL.GetPlayerName(player_id).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..player_id.."**")
        TriggerClientEvent('XCEL:SlapPlayer', target)
        XCELclient.notify(source, {'~g~Slapped Player.'})
    else
        XCEL.ACBan(15,user_id,'XCEL:SlapPlayer')
    end
end)

RegisterServerEvent('XCEL:RevivePlayer')
AddEventHandler('XCEL:RevivePlayer', function(player_id, reviveall)
    local source = source
    local admin_id = XCEL.getUserId(source)
    local target = XCEL.getUserSource(player_id)
    if target ~= nil then
        if XCEL.hasPermission(admin_id, "admin.revive") then
            XCELclient.RevivePlayer(target, {})
            XCELclient.setPlayerCombatTimer(target, {0})
            XCELclient.RevivePlayer(source, {})
            XCELclient.setPlayerCombatTimer(source, {0})
            if not reviveall then
                local playerName = XCEL.GetPlayerName(admin_id)
                XCEL.sendWebhook('revive', 'XCEL Revive Logs', "> Admin Name: **"..XCEL.GetPlayerName(admin_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..XCEL.GetPlayerName(player_id).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..player_id.."**")
                XCELclient.notify(source, {'~g~Revived Player.'})
                return
            end
            XCELclient.notify(source, {'~g~Revived all Nearby.'})
        else
            XCEL.ACBan(15,user_id,'XCEL:RevivePlayer')
        end
    end
end)

frozenplayers = {}
RegisterServerEvent('XCEL:FreezeSV')
AddEventHandler('XCEL:FreezeSV', function(newtarget, isFrozen)
    local source = source
    local admin_id = XCEL.getUserId(source)
    local player_id = XCEL.getUserId(newtarget)
    if XCEL.hasPermission(admin_id, 'admin.freeze') then
        local playerName = XCEL.GetPlayerName(admin_id)
        local playerOtherName = XCEL.GetPlayerName(player_id)
        if isFrozen then
            XCEL.sendWebhook('freeze', 'XCEL Freeze Logs', "> Admin Name: **"..XCEL.GetPlayerName(admin_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..playerOtherName.."**\n> Player TempID: **"..newtarget.."**\n> Player PermID: **"..player_id.."**\n> Type: **Frozen**")
            XCELclient.notify(source, {'~g~Froze Player.'})
            frozenplayers[user_id] = true
            XCELclient.notify(newtarget, {'~g~You have been frozen.'})
        else
            XCEL.sendWebhook('freeze', 'XCEL Freeze Logs', "> Admin Name: **"..XCEL.GetPlayerName(admin_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..playerOtherName.."**\n> Player TempID: **"..newtarget.."**\n> Player PermID: **"..player_id.."**\n> Type: **Unfrozen**")
            XCELclient.notify(source, {'~g~Unfrozen Player.'})
            XCELclient.notify(newtarget, {'~g~You have been unfrozen.'})
            frozenplayers[user_id] = nil
        end
        TriggerClientEvent('XCEL:Freeze', newtarget, isFrozen)
    else
        XCEL.ACBan(15,user_id,'XCEL:FreezeSV')
    end
end)

RegisterServerEvent('XCEL:TeleportToPlayer')
AddEventHandler('XCEL:TeleportToPlayer', function(newtarget)
    local source = source
    local coords = GetEntityCoords(GetPlayerPed(newtarget))
    local user_id = XCEL.getUserId(source)
    local player_id = XCEL.getUserId(newtarget)
    local name = XCEL.GetPlayerName(user_id)
    if XCEL.hasPermission(user_id, 'admin.tp2player') then
        local adminbucket = GetPlayerRoutingBucket(source)
        local playerbucket = GetPlayerRoutingBucket(newtarget)
        if adminbucket ~= playerbucket then
            XCEL.setBucket(source, playerbucket)
            XCELclient.notify(source, {'~g~Player was in another bucket, you have been set into their bucket.'})
        end
        XCELclient.teleport(source, coords)
        XCELclient.notify(newtarget, {'~g~An admin has teleported to you.'})
    else
        XCEL.ACBan(15,user_id,'XCEL:TeleportToPlayer')
    end
end)
local wagercfg = module("cfg/cfg_wagers").settings
RegisterServerEvent('XCEL:TeleportAdmin', function(type, target)
    local source = source
    local user_id = XCEL.getUserId(source)
    local player_id = target and XCEL.getUserId(target)
    local adminbucket, playerbucket, coords
    if XCEL.hasPermission(user_id, 'admin.tp2player') then
        if XCEL.inWager(source) or XCEL.inWager(target) then
            XCELclient.notify(source, {'~r~You cannot teleport while in a wager.'})
            return
        end
        local player = type == "toPlayer" and {source, target} or {target, source}
        local coords
        if type == 'toPlayer' or type == 'bring' then
            coords = GetEntityCoords(GetPlayerPed(player[2]))
        elseif type == 'toLegion' then
            coords = vector3(152.66354370117,-1035.9771728516,29.337995529175)
        elseif type == 'toAdminIsland' then
            savedCoordsBeforeAdminZone = GetEntityCoords(GetPlayerPed(player[1]))
            coords = vector3(3059.6469726563,-4720.6259765625,15.261601448059)
            XCEL.setBucket(target, 256)
        elseif type == 'backFromAdminZone' and savedCoordsBeforeAdminZone ~= nil then
            coords = savedCoordsBeforeAdminZone
            XCEL.setBucket(target, "default")
            XCELclient.teleport(player[1],{coords.x, coords.y, coords.z,globalpasskey})
            savedCoordsBeforeAdminZone = nil
        elseif type == 'toPaleto' then
            coords = vector3(-114.29886627197,6459.7553710938,31.468437194824)
        elseif type == 'toWagers' then
            coords = wagercfg.wagerStartLoc
        elseif type == 'toSimeons' then
            coords = vector3(-41.223133087158,-1112.6409912109,26.438196182251)
        elseif type == 'toCasino' then
            coords = vector3(921.11297607422,48.770889282227,80.898551940918)
        end
        if GetPlayerRoutingBucket(player[1]) ~= GetPlayerRoutingBucket(player[2]) then
            XCEL.setBucket(player[1], GetPlayerRoutingBucket(player[2]))
        end
        if type ~= 'backFromAdminZone' then
            XCELclient.teleport(player[1], {coords.x, coords.y, coords.z, globalpasskey})
            if type == 'bring' then
                type = 'toAnAdmin'
            elseif type == 'toPlayer' then
                type = 'to'
            end
            XCELclient.notify(target, {'~g~You have been teleported '.. type:gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2"):gsub("^%l", string.upper) ..' by an admin.'})
            XCELclient.setPlayerCombatTimer(target, {0})
        end
        local target_user_id = XCEL.getUserId(target)
        local target_name = target_user_id and XCEL.GetPlayerName(target_user_id) or "Unknown"
        XCEL.sendWebhook('tp-to-'..type, 'XCEL Teleport '..type:gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2"):gsub("^%l", string.upper)..' Logs', "> Admin Name: **"..XCEL.GetPlayerName(user_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..target_name.."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..(target_user_id or "Unknown").."**")
    else
        XCEL.ACBan(15,user_id,"XCEL:TeleportAdmin")
    end
end)

RegisterServerEvent('XCEL:StaffSendMsg')
AddEventHandler('XCEL:StaffSendMsg', function(their_source,msg)
    local source = source
    local user_id = XCEL.getUserId(source)
    local their_id = XCEL.getUserId(their_source)
    if XCEL.hasPermission(user_id, 'admin.tp2player') then
        TriggerClientEvent("XCEL:smallAnnouncement", their_source, "STAFF MESSAGE FROM "..XCEL.GetPlayerName(user_id), msg, 6, 15000)
        XCELclient.notify(source, {'~g~Message sent to '.. XCEL.GetPlayerName(their_id)})
        XCEL.sendWebhook('staff-msg', 'XCEL Staff Message Logs', "> Admin Name: **"..XCEL.GetPlayerName(user_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Target ID: **"..their_id.."**\n> Target TempID: **"..their_source.."**\n> Message: **"..msg.."**")
    else
        XCEL.ACBan(15,user_id,'XCEL:StaffSendMsg')
    end
end)

RegisterNetEvent('XCEL:BringPlayer')
AddEventHandler('XCEL:BringPlayer', function(id)
    local source = source 
    local SelectedPlrSource = XCEL.getUserSource(id) 
    local user_id = XCEL.getUserId(source)
    local source = source 
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.tp2player') then
        if id then  
            local ped = GetPlayerPed(source)
            local pedCoords = GetEntityCoords(ped)
            XCELclient.teleport(id, pedCoords)
            local adminbucket = GetPlayerRoutingBucket(source)
            local playerbucket = GetPlayerRoutingBucket(id)
            if adminbucket ~= playerbucket then
                XCEL.setBucket(id, adminbucket)
                XCELclient.notify(source, {'~g~Player was in another bucket, they have been set into your bucket.'})
            end
            XCELclient.setPlayerCombatTimer(id, {0})
        else 
            XCELclient.notify(source,{"~r~This player may have left the game."})
        end
    else
        XCEL.ACBan(15,user_id,'XCEL:BringPlayer')
    end
end)

RegisterNetEvent('XCEL:GetCoords')
AddEventHandler('XCEL:GetCoords', function()
    local source = source 
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, "admin.tickets") then
        XCELclient.getPosition(source,{},function(coords)
            local x,y,z = table.unpack(coords)
            XCEL.prompt(source,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) 
            end)
        end)
    else
        XCEL.ACBan(15,user_id,'XCEL:GetCoords')
    end
end)

RegisterServerEvent('XCEL:Tp2Coords')
AddEventHandler('XCEL:Tp2Coords', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, "admin.tp2coords") then
        XCEL.prompt(source,"Coords x,y,z:","",function(player,fcoords) 
            local coords = {}
            for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
            table.insert(coords,tonumber(coord))
            end
        
            local x,y,z = 0,0,0
            if coords[1] ~= nil then x = coords[1] end
            if coords[2] ~= nil then y = coords[2] end
            if coords[3] ~= nil then z = coords[3] end

            if x and y and z == 0 then
                XCELclient.notify(source, {"~r~We couldn't find those coords, try again!"})
            else
                XCELclient.teleport(player,{x,y,z})
            end 
        end)
    else
       XCEL.ACBan(15,user_id,'XCEL:GetCoords')
    end
end)

RegisterServerEvent("XCEL:Teleport2AdminIsland")
AddEventHandler("XCEL:Teleport2AdminIsland",function(id)
    local source = source
    local admin = source
    local admin_id = XCEL.getUserId(source)
    if id ~= nil then
        local player_id = XCEL.getUserId(id) or {}
        local player_name = XCEL.GetPlayerName(player_id)
        if XCEL.hasPermission(admin_id, 'admin.tp2player') then
            local playerName = XCEL.GetPlayerName(admin_id)
            XCEL.sendWebhook('tp-to-admin-zone', 'XCEL Teleport Logs', "> Admin Name: **"..playerName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..player_name.."**\n> Player TempID: **"..id.."**\n> Player PermID: **"..player_id.."**")
            local ped = GetPlayerPed(source)
            local ped2 = GetPlayerPed(id)
            SetEntityCoords(ped2, 3049.3842773438,-4703.3764648438,15.26159954071)
            XCEL.setBucket(id, 5)
            XCELclient.notify(XCEL.getUserSource(player_id),{'~g~You are now in an admin situation, do not leave the game.'})
            XCELclient.setPlayerCombatTimer(id, {0})
        else
            XCEL.ACBan(15,admin_id,'XCEL:Teleport2AdminIsland')
        end
    end -- fixed
end)

RegisterServerEvent("XCEL:TeleportBackFromAdminZone")
AddEventHandler("XCEL:TeleportBackFromAdminZone",function(id, savedCoordsBeforeAdminZone)
    local source = source
    local admin_id = XCEL.getUserId(source)
    if id ~= nil and savedCoordsBeforeAdminZone ~= nil then
        if XCEL.hasPermission(admin_id, 'admin.tp2player') then
            local ped = GetPlayerPed(id)
            SetEntityCoords(ped, savedCoordsBeforeAdminZone)
            XCEL.setBucket(id, 0)
            XCEL.sendWebhook('tp-back-from-admin-zone', 'XCEL Teleport Logs', "> Admin Name: **"..XCEL.GetPlayerName(admin_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..XCEL.GetPlayerName(id).."**\n> Player TempID: **"..id.."**\n> Player PermID: **"..XCEL.getUserId(id).."**")
        else
            XCEL.ACBan(15,admin_id,'XCEL:TeleportBackFromAdminZone')
        end
    end
end)

RegisterNetEvent('XCEL:AddCar')
AddEventHandler('XCEL:AddCar', function()
    local source = source
    local admin_id = XCEL.getUserId(source)
    local admin_name = XCEL.GetPlayerName(admin_id)
    if XCEL.hasPermission(admin_id, 'admin.addcar') then
        XCEL.prompt(source,"Add to Perm ID:","",function(source, permid)
            if permid == "" then return end
            permid = tonumber(permid)
            XCEL.prompt(source,"Car Spawncode:","",function(source, car) 
                if car == "" then return end
                local car = car
                XCEL.prompt(source,"Locked:","",function(source, locked) 
                    if locked == '0' or locked == '1' then
                        if permid and car ~= "" then  
                            XCELclient.generateUUID(source, {"plate", 5, "alphanumeric"}, function(uuid)
                                local uuid = string.upper(uuid)
                                exports['xcel']:execute("SELECT * FROM `xcel_user_vehicles` WHERE vehicle_plate = @plate", {plate = uuid}, function(result)
                                    if #result > 0 then
                                        XCELclient.notify(source, {'~r~Error adding car, please try again.'})
                                        return
                                    else
                                        MySQL.execute("XCEL/add_vehicle", {user_id = permid, vehicle = car, registration = uuid, locked = locked})
                                        XCELclient.notify(source,{'~g~Successfully added Player\'s car'})
                                        XCEL.sendWebhook('add-car', 'XCEL Add Car To Player Logs', "> Admin Name: **"..admin_name.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player PermID: **"..permid.."**\n> Spawncode: **"..car.."**")
                                    end
                                end)
                            end)
                        else 
                            XCELclient.notify(source,{'~r~Failed to add Player\'s car'})
                        end
                    else
                        XCELclient.notify(source,{'~g~Locked must be either 1 or 0'}) 
                    end
                end)
            end)
        end)
    else
        XCEL.ACBan(15,admin_id,'XCEL:AddCar')
    end
end)
RegisterCommand('cartoall', function(source, args)
    if source == 0 then
        if tostring(args[1]) then
            local car = tostring(args[1])
            for k, v in pairs(XCEL.getUsers()) do
                local plate = string.upper(generateUUID("plate", 5, "alphanumeric"))
                local locked = true -- You should define 'locked' here or retrieve it from somewhere
                MySQL.execute("XCEL/add_vehicle", {user_id = k, vehicle = car, registration = plate, locked = locked})
                print('Added Car To ' .. k .. ' With Plate: ' .. plate)
            end
        else
            print('Incorrect usage: cartoall [spawncode]')
        end
    end
end)

local cooldowncleanup = {}
RegisterNetEvent('XCEL:CleanAll')
AddEventHandler('XCEL:CleanAll', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.noclip') then
        if cooldowncleanup[source] then
            XCELclient.notify(source, {'~r~You can only use this command once every 60 seconds.'})
            return
        end
        cooldowncleanup[source] = true
        for i,v in pairs(GetAllVehicles()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllPeds()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllObjects()) do
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, 'XCEL^7 │ ', {255, 255, 255}, "Cleanup Completed by ^3" .. XCEL.GetPlayerName(user_id) .. "^0!", "alert")
        Wait(60000)
        cooldowncleanup[source] = false
    end
end)

RegisterNetEvent('XCEL:noClip')
AddEventHandler('XCEL:noClip', function()
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.noclip') then 
        XCELclient.toggleNoclip(source,{})
    end
end)

RegisterServerEvent("XCEL:GetPlayerData")
AddEventHandler("XCEL:GetPlayerData",function()
    local source = source
    user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.tickets') then
        players = GetPlayers()
        players_table = {}
        useridz = {}
        for i, p in pairs(XCEL.getUsers()) do
            if XCEL.getUserId(p) ~= nil then
                name = XCEL.GetPlayerName(XCEL.getUserId(p))
                user_idz = XCEL.getUserId(p)
                playtime = XCEL.GetPlayTime(user_idz)
                players_table[user_idz] = {name, p, user_idz, playtime}
                table.insert(useridz, user_idz)
            else
                DropPlayer(p, "XCEL - The Server Was Unable To Get Your User ID, Please Reconnect.")
            end
        end
        TriggerClientEvent("XCEL:getPlayersInfo", source, players_table, bans)
    end
end)

RegisterNetEvent("XCEL:searchByCriteria")
AddEventHandler("XCEL:searchByCriteria", function(searchtype)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.tickets') then
        local players_table = {}
        local user_ids = {}
        local group = {}
        if searchtype == "Police" then
            group = XCEL.getUsersByPermission("police.armoury")
        elseif searchtype == "POV List" then
            group = XCEL.getUsersByPermission("pov.list")
        elseif searchtype == "Cinematic" then
            group = XCEL.getUsersByGroup("Cinematic")
        elseif searchtype == "NHS" then
            group = XCEL.getUsersByPermission("nhs.menu")
        end

        if group then
            for k, v in pairs(group) do
                local usersource = XCEL.getUserSource(v)
                local name = XCEL.GetPlayerName(v)
                local user_idz = v
                local data = XCEL.getUserDataTable(user_idz)
                local playtime = XCEL.GetPlayTime(user_idz)
                players_table[user_idz] = {name, usersource, user_idz, playtime}
                table.insert(user_ids, user_idz)
            end
        end
        TriggerClientEvent("XCEL:returnCriteriaSearch", source, players_table)
    end
end)



local Playtimes = {}

function XCEL.GetPlayTime(user_id)
    -- Initialize PlayerTimeInHours at the start to ensure its scope covers the entire function
    local PlayerTimeInHours = 0
    
    -- Check if the playtime for the user has already been calculated and stored
    if Playtimes[user_id] == nil then
        -- Fetch user data
        local data = XCEL.getUserDataTable(user_id)
        if data then
            -- If data exists, calculate playtime
            local playtime = data.PlayerTime or 0
            PlayerTimeInHours = math.floor(playtime / 60)
            -- No need to check if PlayerTimeInHours < 1, as math.floor ensures it's always an integer >= 0
        end
        -- Save calculated playtime to avoid recalculating in future calls
        Playtimes[user_id] = PlayerTimeInHours
    else
        -- Use previously stored playtime
        PlayerTimeInHours = Playtimes[user_id]
    end
    
    -- Return the calculated or stored playtime in hours
    return PlayerTimeInHours
end







RegisterCommand("staffon", function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, "admin.tickets") then
        XCELclient.staffMode(source, {true})
    end
end)

RegisterCommand("staffoff", function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, "admin.tickets") then
        XCELclient.staffMode(source, {false})
    end
end)
local stafflevels = {}
RegisterServerEvent('XCEL:getAdminLevel')
AddEventHandler('XCEL:getAdminLevel', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local adminlevel = 0
    if XCEL.hasGroup(user_id,"Founder") then
        adminlevel = 12
        TriggerClientEvent("XCEL:SetDev", source)
    elseif XCEL.hasGroup(user_id,"Lead Developer") or XCEL.hasGroup(user_id,"Developer") then
        adminlevel = 11
        TriggerClientEvent("XCEL:SetDev", source)
    elseif XCEL.hasGroup(user_id,"Community Manager") then
        adminlevel = 10
    elseif XCEL.hasGroup(user_id,"Staff Manager") then    
        adminlevel = 9
    elseif XCEL.hasGroup(user_id,"Head Administrator") then
        adminlevel = 7
    elseif XCEL.hasGroup(user_id,"Senior Administrator") then
        adminlevel = 6
    elseif XCEL.hasGroup(user_id,"Administrator") then
        adminlevel = 5
    elseif XCEL.hasGroup(user_id,"Senior Moderator") then
        adminlevel = 4
    elseif XCEL.hasGroup(user_id,"Moderator") then
        adminlevel = 3
    elseif XCEL.hasGroup(user_id,"Support Team") then
        adminlevel = 2
    elseif XCEL.hasGroup(user_id,"Trial Staff") then
        adminlevel = 1
    end
    stafflevels[user_id] = adminlevel
    --print("Admin Level: "..stafflevels[user_id])
    TriggerClientEvent("XCEL:SetStaffLevel", source, adminlevel)
end)
function XCEL.getStaffLevel(user_id)
    if stafflevels[user_id] then
        return stafflevels[user_id]
    end
    return 0
end
RegisterServerEvent("XCEL:VerifyDev")
AddEventHandler("XCEL:VerifyDev", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasGroup(user_id, 'Founder') or XCEL.hasGroup(user_id, 'Developer') or XCEL.hasGroup(user_id, 'Lead Developer') or user_id == 63 then
        return
    else
        XCEL.ACBan(15,user_id,'XCEL:VerifyDev')
    end
end)
RegisterServerEvent("XCEL:VerifyStaff")
AddEventHandler("XCEL:VerifyStaff", function(stafflevel)
    local source = source
    local user_id = XCEL.getUserId(source)
    if stafflevel == 0 then
        return
    elseif XCEL.hasGroup(user_id, 'Founder') or XCEL.hasGroup(user_id, 'Developer') or XCEL.hasGroup(user_id, 'Lead Developer') or XCEL.hasGroup(user_id,"Community Manager") or XCEL.hasGroup(user_id,"Staff Manager") or XCEL.hasGroup(user_id,"Head Administrator") or XCEL.hasGroup(user_id,"Senior Administrator") or XCEL.hasGroup(user_id,"Administrator") or XCEL.hasGroup(user_id,"Senior Moderator") or XCEL.hasGroup(user_id,"Moderator") or XCEL.hasGroup(user_id,"Support Team") or XCEL.hasGroup(user_id,"Trial Staff")  then
        return
    else
        XCEL.ACBan(15,user_id,'XCEL:VerifyStaff')
    end
end)
function XCEL.GetAdminLevel(user_id)
    local adminlevel = 0
    if XCEL.hasGroup(user_id, "Founder") then
        adminlevel = 13
    elseif XCEL.hasGroup(user_id, "Lead Developer") or XCEL.hasGroup(user_id,"Developer") then
        adminlevel = 12
    elseif XCEL.hasGroup(user_id, "Community Manager") then
        adminlevel = 10
    elseif XCEL.hasGroup(user_id, "Staff Manager") then
        adminlevel = 9
    elseif XCEL.hasGroup(user_id, "Head Administrator") then
        adminlevel = 7
    elseif XCEL.hasGroup(user_id, "Senior Administrator") then
        adminlevel = 6
    elseif XCEL.hasGroup(user_id, "Administrator") then
        adminlevel = 5
    elseif XCEL.hasGroup(user_id, "Senior Moderator") then
        adminlevel = 4
    elseif XCEL.hasGroup(user_id, "Moderator") then
        adminlevel = 3
    elseif XCEL.hasGroup(user_id, "Support Team") then
        adminlevel = 2
    elseif XCEL.hasGroup(user_id, "Trial Staff") then
        adminlevel = 1
    end

    return adminlevel
end

RegisterCommand("icarwipe", function(source, args) -- these events are gonna be used for vehicle cleanup in future also
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup complete.", "alert")
        TriggerClientEvent('XCEL:clearVehicles', -1)
        TriggerClientEvent('XCEL:clearBrokenVehicles', -1)
    end 
end)
RegisterCommand("carwipe", function(source, args) -- these events are gonna be used for vehicle cleanup in future also
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup in 10 seconds! All unoccupied vehicles will be deleted.", "alert")
        Citizen.Wait(10000)
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup complete.", "alert")
        TriggerClientEvent('XCEL:clearVehicles', -1)
        TriggerClientEvent('XCEL:clearBrokenVehicles', -1)
    end 
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)  -- Wait for 5 minutes (300,000 milliseconds)
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup in 10 seconds! All unoccupied vehicles will be deleted.", "alert")
        Citizen.Wait(10000)  -- Wait for 10 seconds (10,000 milliseconds)
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup complete.", "alert")
        TriggerClientEvent('XCEL:clearVehicles', -1)
        TriggerClientEvent('XCEL:clearBrokenVehicles', -1)
    end
end)


RegisterCommand("getbucket", function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    XCELclient.notify(source, {'~g~You are currently in Bucket: '..GetPlayerRoutingBucket(source)})
end)

RegisterCommand("setbucket", function(source, args)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.managecommunitypot') then
        XCEL.setBucket(source, tonumber(args[1]))
        XCELclient.notify(source, {'~g~You are now in Bucket: '..GetPlayerRoutingBucket(source)})
    end 
end)

RegisterCommand("openurl", function(source, args)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id == 4 or user_id == 1 then
        local permid = tonumber(args[1])
        local data = args[2]
        XCELclient.OpenUrl(XCEL.getUserSource(permid), {'https://'..data})
    end 
end)

RegisterCommand("clipboard", function(source, args)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'group.remove') then
        local permid = tonumber(args[1])
        table.remove(args, 1)
        local msg = table.concat(args, " ")
        XCELclient.CopyToClipBoard(XCEL.getUserSource(permid), {msg})
    end 
end)

RegisterCommand("staffdm", function(source, args)
    local sourcePlayer = source
    local user_id = XCEL.getUserId(sourcePlayer)

    if XCEL.hasPermission(user_id, 'admin.tickets') then
        local targetPlayerId = tonumber(args[1])
        local message = table.concat(args, " ", 2)
        if targetPlayerId and message then
            local targetPlayerSource = XCEL.getUserSource(targetPlayerId)

            if targetPlayerSource then
                XCEL.sendWebhook('staffdm',"XCEL Staff DM Logs", "> Admin Name: **"..XCEL.GetPlayerName(user_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..XCEL.GetPlayerName(targetPlayerId).."**\n> Player PermID: **"..targetPlayerId.."**\n> Player TempID: **"..targetPlayerSource.."**\n> Message: **"..message.."**")
                TriggerClientEvent('XCEL:StaffDM', targetPlayerSource, message)
                XCELclient.notify(sourcePlayer, {'~g~Sent: ' .. message .. ' to ' ..XCEL.GetPlayerName(targetPlayerId)})
            else
                XCELclient.notify(sourcePlayer, {'~r~Player is not online.'})
            end
        end
    else
        XCELclient.notify(sourcePlayer, {'~r~You do not have permission to use this command.'})
    end
end)


RegisterNetEvent("XCEL:GetTicketLeaderboard")
AddEventHandler("XCEL:GetTicketLeaderboard", function(state)
    local source = source
    local user_id = XCEL.getUserId(source)
    if state then
        exports['xcel']:execute("SELECT * FROM xcel_staff_tickets WHERE user_id = @user_id", {user_id = user_id}, function(result)
            if result ~= nil then
                TriggerClientEvent('XCEL:GotTicketLeaderboard', source, result)
            end
        end)
    else
        exports['xcel']:execute("SELECT * FROM xcel_staff_tickets ORDER BY ticket_count DESC LIMIT 10", {}, function(result)
            if result ~= nil then
                TriggerClientEvent('XCEL:GotTicketLeaderboard', source, result)
            end
        end)
    end
end)

RegisterServerEvent("XCEL:transferMoneyViaPermID")
AddEventHandler('XCEL:transferMoneyViaPermID', function(playerid, price)
    local source = source
    local userid = XCEL.getUserId(source)
    local reciever = XCEL.getUserSource(tonumber(playerid))
    local recieverid = XCEL.getUserId(reciever)
    local totalprice = price
    if recieverid == nil then
        XCELclient.notify(source, {"~r~This ID does not exist/ is offline!"})
    else
        if userid == recieverid then 
            XCELclient.notify(source, {"~r~Unable to send money to yourself!"})
        else
            if XCEL.tryBankPayment(userid, tonumber(price)) then 
                XCELclient.notify(source, {"~g~Successfully transfered: ~w~£" .. totalprice .. " ~g~to ~w~" .. XCEL.GetPlayerName(reciever)})
                XCEL.giveBankMoney(tonumber(playerid), tonumber(price))
                XCELclient.notify(reciever, {"~g~You have recieved: ~w~£" .. totalprice .. "~g~ from ~w~".. XCEL.GetPlayerName(user_id)})
            else 
                XCELclient.notify(source, {"~r~You do not have enough money complete transaction!"})
            end
        end
    end
end)

RegisterServerEvent("XCEL:depositOffshoreMoney")
AddEventHandler('XCEL:depositOffshoreMoney', function(amount)
    local source = source
    local UserID = XCEL.getUserId(source)
    local amount = tonumber(amount)
    if amount and amount > 0 then
        if UserID ~= nil then
            if XCEL.tryBankPayment(UserID, amount) then
                XCEL.giveOffshoreMoney(UserID, amount)
                local newOffshoreMoney = XCEL.getOffshoreMoney(UserID)
                TriggerClientEvent("XCEL:phoneNotification", source, "You have deposited £"..getMoneyStringFormatted(amount), "Offshore")
                TriggerClientEvent("XCEL:setDisplayOffshore", source, newOffshoreMoney)
            else 
                XCELclient.notify(source, {"~r~You do not have enough money to deposit."})
            end
        end
    end
end)

RegisterServerEvent("XCEL:depositAllOffshoreMoney")
AddEventHandler('XCEL:depositAllOffshoreMoney', function()
    local source = source
    local UserID = XCEL.getUserId(source)
    if UserID ~= nil then
        local bankMoney = XCEL.getBankMoney(UserID)
        if bankMoney > 0 then
            if XCEL.tryBankPayment(UserID, bankMoney) then
                XCEL.giveOffshoreMoney(UserID, bankMoney)
                TriggerClientEvent("XCEL:phoneNotification", source, "You have deposited £"..getMoneyStringFormatted(bankMoney), "Offshore")
                TriggerClientEvent("XCEL:setDisplayOffshore", source, bankMoney)
            else 
                XCELclient.notify(source, {"~r~You do not have enough money to deposit."})
            end
        else
            XCELclient.notify(source, {"~r~You have no money in your bank account to deposit."})
        end
    end
end)

RegisterServerEvent("XCEL:withdrawOffshoreMoney")
AddEventHandler('XCEL:withdrawOffshoreMoney', function(amount)
    local source = source 
    local UserID = XCEL.getUserId(source)
    local amount = tonumber(amount)
    local offshoremoney = XCEL.getOffshoreMoney(UserID)
    if UserID ~= nil then 
        if amount and amount > 0 then
            if offshoremoney >= amount then
                XCEL.giveBankMoney(UserID, amount)
                XCEL.setOffshoreMoney(UserID, offshoremoney - amount)
                TriggerClientEvent("XCEL:phoneNotification", source, "You have withdrew £"..getMoneyStringFormatted(amount), "Offshore")
                TriggerClientEvent("XCEL:setDisplayOffshore", source, offshoremoney - amount)
            else 
                XCELclient.notify(source, {"~r~You are trying to withdraw more than you have."})
            end
        else
            XCELclient.notify(source, {"~r~Invalid amount."})
        end
    else
        XCELclient.notify(source, {"~r~Unable to identify user."})
    end
end)

RegisterServerEvent("XCEL:withdrawAllOffshoreMoney")
AddEventHandler('XCEL:withdrawAllOffshoreMoney', function()
    local source = source 
    local UserID = XCEL.getUserId(source)
    local offshoremoney = XCEL.getOffshoreMoney(UserID)
    if UserID ~= nil then 
        if offshoremoney > 0 then
            XCEL.giveBankMoney(UserID, offshoremoney)
            XCEL.setOffshoreMoney(UserID, 0)
            TriggerClientEvent("XCEL:phoneNotification", source, "You have withdrawn £"..getMoneyStringFormatted(offshoremoney), "Offshore")
            TriggerClientEvent("XCEL:setDisplayOffshore", source, 0)
        else 
            XCELclient.notify(source, {"~r~You have no offshore money to withdraw."})
        end
    else
        XCELclient.notify(source, {"~r~Unable to identify user."})
    end
end)