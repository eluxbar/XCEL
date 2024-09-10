local gangWithdraw = {}
local gangDeposit = {}
local gangTable = {}
local playerinvites = {}
local fundscooldown = {}
local cooldown = 5
MySQL.createCommand("xcel_edituser", "UPDATE xcel_user_gangs SET gangname = @gangname WHERE user_id = @user_id")
MySQL.createCommand("xcel_adduser", "INSERT IGNORE INTO xcel_user_gangs (user_id,gangname) VALUES (@user_id,@gangname)")
function addGangLog(playername,userid,action,actionvalue)
    local gangname = XCEL.getGangName(userid)
    if gangname and gangname ~= "" then
        exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
            if ganginfo ~= nil and #ganginfo > 0 then
                local ganglogs = {}
                if ganginfo[1].logs == "NOTHING" or ganginfo[1].logs == nil then
                    ganglogs = {}
                else
                    ganglogs = json.decode(ganginfo[1].logs) or {}
                    if ganglogs == nil then
                        ganglogs = {}
                    end
                end
                if ganginfo[1].webhook then
                    XCEL.sendWebhook(ganginfo[1].webhook, "(".. gangname..") Gang Logs", "**Name:** " ..playername.. "**\n**User ID:** " ..userid.. "\n**Action:** " ..actionvalue .. "**")
                else
                    XCEL.sendWebhook("gang-info", "(".. gangname..") Gang Logs", "**Name:** " ..playername.. "**\n**User ID:** " ..userid.. "\n**Action:** " .. action.. " ("..actionvalue.. ")**")
                end
                table.insert(ganglogs,1,{playername,userid,os.date("%d/%m/%Y at %X"),action,actionvalue})
                exports["xcel"]:execute("UPDATE xcel_gangs SET logs = @logs WHERE gangname = @gangname", {logs = json.encode(ganglogs), gangname = gangname})
                TriggerClientEvent("XCEL:ForceRefreshData",XCEL.getUserSource(userid))
            end
        end)
    end
end
RegisterServerEvent('XCEL:CreateGang', function(gangName)
    local source = source
    local user_id = XCEL.getUserId(source)
    local currenttime = os.time()
    
    if XCEL.hasGroup(user_id,"Gang") then
        if not fundscooldown[source] or (currenttime - fundscooldown[source]) >= cooldown then
            fundscooldown[source] = currenttime
            local hasgang = XCEL.getGangName(user_id)
            if hasgang == nil or hasgang == "" then
                exports['xcel']:execute("SELECT * FROM xcel_user_gangs WHERE gangname = @gang", {gang = gangName}, function(gangData)
                    if #gangData <= 0 then
                        local gangTable = {[tostring(user_id)] = {["rank"] = 4,["gangPermission"] = 4,["color"] = "White"}}
                        gangTables = json.encode(gangTable)
                        XCELclient.notify(source, {"~g~Gang created."})
                        MySQL.execute("xcel_edituser", {user_id = user_id, gangname = gangName})
                        exports['xcel']:execute("INSERT INTO xcel_gangs (gangname,gangmembers,funds,logs) VALUES(@gangname,@gangmembers,@funds,@logs)", {gangname=gangName,gangmembers=gangTables,funds=0,logs="NOTHING"}, function() end)
                        TriggerClientEvent("XCEL:gangNameNotTaken",source)
                        TriggerClientEvent("XCEL:ForceRefreshData",source)
                    else
                        XCELclient.notify(source, {"~r~Gang already exists."})
                    end
                end)
            else
                XCELclient.notify(source, {"~r~You already have a gang, If not contact a developer."})
            end
        else
            XCELclient.notify(source, {"~r~You are being rate limited, please wait"})
        end
    else
        XCELclient.notify(source, {"~r~You do not have gang licence."})
    end
    syncRadio(source)
end)

RegisterServerEvent("XCEL:GetGangData", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local gangName = XCEL.getGangName(user_id)
    if gangName and gangName ~= "" then
        local gangmembers = {}
        local gangData = {}
        local ganglogs = {}
        local memberids = {}
        local gangpermission = {}  -- Initialize gangpermission as a table
        exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangName}, function(gangInfo)
            if gangInfo ~= nil and #gangInfo > 0 then
                local gangInfo = gangInfo[1]
                local gangMembers = json.decode(gangInfo.gangmembers)
                gangData["money"] = math.floor(gangInfo.funds)
                gangData["id"] = gangName
                if gangMembers[tostring(user_id)] then
                    gangpermission = tonumber(gangMembers[tostring(user_id)].gangPermission) or 0 
                else
                    gangpermission = 0
                end
                ganglogs = json.decode(gangInfo.logs)
                ganglock = tobool(gangInfo.lockedfunds)
                for member_id, member_data in pairs(gangMembers) do
                    memberids[#memberids + 1] = tostring(member_id)
                end
                local placeholders = string.rep('?,', #memberids):sub(1, -2)
                local playerData = exports['xcel']:executeSync('SELECT * FROM xcel_users WHERE id IN (' .. placeholders .. ')', memberids)
                local userData = exports['xcel']:executeSync('SELECT * FROM xcel_user_data WHERE user_id IN (' .. placeholders .. ')', memberids)
                for _, playerRow in ipairs(playerData) do
                    local member_id = tonumber(playerRow.id)
                    local member_gangpermission = tonumber(gangMembers[tostring(member_id)].gangPermission) or 0  
                    local online
                    if playerRow.banned then
                        online = '~r~Banned'
                    elseif XCEL.getUserSource(member_id) then
                        online = '~g~Online'
                    elseif playerRow.last_login then
                        online = '~y~Offline'
                    else
                        online = '~r~Never joined'
                    end
                    local playtime = 0

                    for _, userData in ipairs(userData) do
                        if userData.user_id == member_id and userData.dkey == 'XCEL:datatable' then
                            local data = json.decode(userData.dvalue)

                            playtime = math.ceil((data.PlayerTime or 0) / 60)
                            if playtime < 1 then
                                playtime = 0
                            end
                            break
                        end
                    end
                    table.insert(gangmembers, { playerRow.username, member_id, member_gangpermission, online, playtime })
                end
                for _, member_id in ipairs(memberids) do
                    local tempid = XCEL.getUserSource(tonumber(member_id))
                    if tempid then
                        TriggerClientEvent('XCEL:GotGangData', tempid, gangData, gangmembers, gangpermission, ganglogs, ganglock, false)
                    end
                end
            end
        end)
    end
end)

RegisterServerEvent("XCEL:addUserToGang",function(gangName)
    local source = source
    local user_id = XCEL.getUserId(source)
    if table.includes(playerinvites[source],gangName) then
        exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname",{gangname = gangName}, function(ganginfo)
            if json.encode(ganginfo) == "[]" and ganginfo == nil and json.encode(ganginfo) == nil then
                XCELclient.notify(source, {"~b~Gang no longer exists."})
                return
            end
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(ganginfo) do
                gangmembers[tostring(user_id)] = {["rank"] = 1,["gangPermission"] = 1,["color"] = "White"}
                exports["xcel"]:execute("UPDATE xcel_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname",{gangmembers = json.encode(gangmembers),gangname = gangName})
                MySQL.execute("xcel_edituser", {user_id = user_id, gangname = gangName})
                TriggerClientEvent("XCEL:ForceRefreshData",source)
                syncRadio(source)
            end
        end)
    else
        XCELclient.notify(source, {"~r~You have not been invited to this gang."})
    end
end)
local colourwait = false
RegisterServerEvent("XCEL:setPersonalGangBlipColour")
AddEventHandler("XCEL:setPersonalGangBlipColour", function(color)
    local source = source
    local user_id = XCEL.getUserId(source)
    local gangName = XCEL.getGangName(user_id)
    if gangName and gangName ~= "" then
        exports['xcel']:execute('SELECT * FROM xcel_gangs WHERE gangname = @gangname', {gangname = gangName}, function(gangs)
            if #gangs > 0 then
                local gangmembers = json.decode(gangs[1].gangmembers)
                gangmembers[tostring(user_id)] = {["rank"] = gangmembers[tostring(user_id)].rank, ["gangPermission"] = gangmembers[tostring(user_id)].gangPermission,["color"] = color}
                exports['xcel']:execute("UPDATE xcel_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = json.encode(gangmembers), gangname = gangName})
                TriggerClientEvent("XCEL:setGangMemberColour",-1,user_id,color)
            end
        end)
    end
end)

RegisterServerEvent("XCEL:depositGangBalance",function(gangname, amount)
    local source = source
    local user_id = XCEL.getUserId(source)
    exports['xcel']:execute('SELECT * FROM xcel_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local funds = V.funds
                    local gangname = V.gangname
                    if tonumber(amount) < 0 then
                        XCELclient.notify(source,{"~r~Invalid Amount"})
                        return
                    end
                    if tonumber(XCEL.getBankMoney(user_id)) < tonumber(amount) then
                        XCELclient.notify(source,{"~r~Not enough Money."})
                    else
                        XCEL.setBankMoney(user_id, (XCEL.getBankMoney(user_id))-tonumber(amount))
                        XCELclient.notify(source,{"~g~Deposited £"..getMoneyStringFormatted(amount)})
                        addGangLog(XCEL.GetPlayerName(user_id),user_id,"Deposited","£"..getMoneyStringFormatted(amount))
                        exports['xcel']:execute("UPDATE xcel_gangs SET funds = @funds WHERE gangname = @gangname", {funds = tonumber(amount)+tonumber(funds), gangname = gangname})
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("XCEL:depositAllGangBalance", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local gangName = exports['xcel']:executeSync("SELECT * FROM xcel_user_gangs WHERE user_id = @user_id", {user_id = user_id})[1].gangname
    local currenttime = os.time()

    if gangName and gangName ~= "" then
        if not fundscooldown[source] or (currenttime - fundscooldown[source]) >= cooldown then
            fundscooldown[source] = currenttime
            local bank = XCEL.getBankMoney(user_id)
            exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
                if #ganginfo > 0 then
                    local gangmembers = json.decode(ganginfo[1].gangmembers)
                    for A, B in pairs(gangmembers) do
                        if tostring(user_id) == A then
                            local gangfunds = ganginfo[1].funds
                            if tonumber(bank) < 0 then
                                XCELclient.notify(source, {"~r~Invalid Amount"})
                                return
                            end
                            XCEL.setBankMoney(user_id, 0)
                            XCELclient.notify(source, {"~g~Deposited £" .. getMoneyStringFormatted(bank)})
                            XCELclient.notify(source, {"~g~£" .. getMoneyStringFormatted(tonumber(bank) * 0.02) .. " tax paid."})
                            addGangLog(XCEL.GetPlayerName(user_id), user_id, "Deposited", "£" .. getMoneyStringFormatted(bank))
                            local newbal = tonumber(bank) + tonumber(gangfunds) - tonumber(bank) * 0.02
                            exports["xcel"]:execute("UPDATE xcel_gangs SET funds = @funds WHERE gangname = @gangname", {funds = tostring(newbal), gangname = gangName})
                        end
                    end
                end
            end)
        else
            XCELclient.notify(source, {"~r~You are being rate limited, please wait"})
        end
    end
end)

RegisterServerEvent("XCEL:withdrawAllGangBalance", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local gangName = exports['xcel']:executeSync("SELECT * FROM xcel_user_gangs WHERE user_id = @user_id", {user_id = user_id})[1].gangname
    local currenttime = os.time()
    if gangName and gangName ~= "" then
        if not gangWithdraw[source] then
            gangWithdraw[source] = true
            exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
                if #ganginfo > 0 then
                    local gangmembers = json.decode(ganginfo[1].gangmembers)
                    for A, B in pairs(gangmembers) do
                        if tostring(user_id) == A then
                            local gangfunds = ganginfo[1].funds
                            if tonumber(gangfunds) < 0 then
                                XCELclient.notify(source, {"~r~Invalid Amount"})
                                return
                            end
                            XCEL.setBankMoney(user_id, (XCEL.getBankMoney(user_id)) + tonumber(gangfunds))
                            XCELclient.notify(source, {"~g~Withdrew £" .. getMoneyStringFormatted(gangfunds)})
                            addGangLog(XCEL.GetPlayerName(user_id), user_id, "Withdrew", "£" .. getMoneyStringFormatted(gangfunds))
                            exports["xcel"]:execute("UPDATE xcel_gangs SET funds = @funds WHERE gangname = @gangname", {funds = 0, gangname = gangName})
                        end
                    end
                end
            end)
            SetTimeout(3500,function()
                gangWithdraw[source] = false
            end)
        else
            XCELclient.notify(source, {"~r~You are being rate limited, please wait"})
        end
    end
end)



RegisterServerEvent("XCEL:withdrawGangBalance",function(amount)
    local source = source
    local user_id = XCEL.getUserId(source)
    local gangName = XCEL.getGangName(user_id)
    if gangName and gangName ~= "" then
        if not gangWithdraw[source] then
            gangWithdraw[source] = true
            exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
                if #ganginfo > 0 then
                    local gangmembers = json.decode(ganginfo[1].gangmembers)
                    for A,B in pairs(gangmembers) do
                        if tostring(user_id) == A then
                            local gangfunds = ganginfo[1].funds
                            if tonumber(amount) < 0 then
                                XCELclient.notify(source,{"~r~Invalid Amount"})
                                return
                            end
                            if tonumber(gangfunds) < tonumber(amount) then
                                XCELclient.notify(source,{"~r~Not enough Money."})
                            else
                                XCEL.setBankMoney(user_id, (XCEL.getBankMoney(user_id))+tonumber(amount))
                                XCELclient.notify(source,{"~g~Withdrew £"..getMoneyStringFormatted(amount)})
                                addGangLog(XCEL.GetPlayerName(user_id),user_id,"Withdrew","£"..getMoneyStringFormatted(amount))
                                exports["xcel"]:execute("UPDATE xcel_gangs SET funds = @funds WHERE gangname = @gangname", {funds = tonumber(gangfunds)-tonumber(amount), gangname = gangName})
                            end
                        end
                    end
                    SetTimeout(3500,function()
                        gangWithdraw[source] = false
                    end)
                end
            end)
        end
    end
end)

RegisterServerEvent("XCEL:PromoteUser",function(gangname,memberid)
    local source = source
    local user_id = XCEL.getUserId(source)
    exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank >= 4 then
                        local rank = gangmembers[tostring(memberid)].rank
                        local gangpermission = gangmembers[tostring(memberid)].gangPermission
                        if rank < 4 and gangpermission < 4 and tostring(user_id) ~= A then
                            XCELclient.notify(source, {"~r~Only the leader can promote."})
                            return
                        end
                        if gangmembers[tostring(memberid)].rank == 3 and gangpermission == 3 and tostring(user_id) == A then
                            XCELclient.notify(source, {"~r~There can only be one leader."})
                            return
                        end
                        if tonumber(memberid) == tonumber(user_id) and rank == 4 and gangpermission == 4 then
                            XCELclient.notify(source, {"~r~You are already the highest rank."})
                            return
                        end
                        gangmembers[tostring(memberid)].rank = tonumber(rank) + 1
                        gangmembers[tostring(memberid)].gangPermission = tonumber(gangpermission) + 1
                        XCELclient.notify(source, {"~g~Promoted User."})
                        addGangLog(XCEL.GetPlayerName(user_id),user_id,"Promoted","ID: "..memberid)
                        exports["xcel"]:execute("UPDATE xcel_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = json.encode(gangmembers), gangname = gangname})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("XCEL:DemoteUser", function(gangname,member)
    local source = source
    local user_id = XCEL.getUserId(source)
    exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangname},function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank >= 4 then
                        local rank = gangmembers[tostring(member)].rank
                        local gangpermission = gangmembers[tostring(member)].gangPermission
                        if rank < 4 and gangpermission < 4 and tostring(user_id) ~= A then
                            XCELclient.notify(source, {"~r~Only the leader can demote."})
                            return
                        end
                        if gangmembers[tostring(member)].rank == 1 and gangpermission == 1 and tostring(user_id) == A then
                            XCELclient.notify(source, {"~r~There can only be one leader."})
                            return
                        end
                        if tonumber(member) == tonumber(user_id) and rank == 1 and gangpermission == 1 then
                            XCELclient.notify(source, {"~r~You are already the lowest rank."})
                            return
                        end
                        gangmembers[tostring(member)].rank = tonumber(rank)-1
                        gangmembers[tostring(member)].gangPermission = tonumber(gangpermission)-1
                        gangmembers = json.encode(gangmembers)
                        XCELclient.notify(source, {"~g~Demoted User."})
                        addGangLog(XCEL.GetPlayerName(user_id),user_id,"Demoted","ID: "..member)
                        exports["xcel"]:execute("UPDATE xcel_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = gangmembers, gangname = gangname})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("XCEL:KickUser",function(gangname,member)
    local source = source
    local user_id = XCEL.getUserId(source)
    local membersource = XCEL.getUserSource(member)
    exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    local memberrank = gangmembers[tostring(member)].rank
                    local leaderrank = gangmembers[tostring(user_id)].rank
                    if B.rank >= 3 then
                        if tonumber(member) == tonumber(user_id) then
                            XCELclient.notify(source, {"~r~You cannot kick yourself."})
                            return
                        end
                        if tonumber(memberrank) >= leaderrank then
                            XCELclient.notify(source, {"~r~You do not have permission to kick this member from this gang"})
                            return
                        end
                        gangmembers[tostring(member)] = nil
                        addGangLog(XCEL.GetPlayerName(user_id),user_id,"Kicked","ID: "..member)
                        exports["xcel"]:execute("UPDATE xcel_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = json.encode(gangmembers), gangname = gangname})
                        MySQL.execute("xcel_edituser", {user_id = member, gangname = nil})
                        if membersource then
                            XCELclient.notify(membersource, {"~r~You have been kicked from the gang."})
                            syncRadio(membersource)
                            TriggerClientEvent("XCEL:disbandedGang",membersource)
                        end
                    else
                        XCELclient.notify(source, {"~r~You do not have permission to kick this member from this gang"})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("XCEL:LeaveGang", function(gangname)
    local source = source
    local user_id = XCEL.getUserId(source)
    exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank == 4 then
                        XCELclient.notify(source, {"~r~You cannot leave the gang as you are the leader."})
                        return
                    end
                    gangmembers[tostring(user_id)] = nil
                    exports["xcel"]:execute("UPDATE xcel_gangs SET gangmembers = @gangmembers WHERE gangname = @gangname", {gangmembers = json.encode(gangmembers), gangname = gangname})
                    MySQL.execute("xcel_edituser", {user_id = user_id, gangname = nil})
                    if XCEL.getUserSource(user_id) then
                        XCELclient.notify(source, {"~r~You have left the gang."})
                        syncRadio(source)
                        TriggerClientEvent("XCEL:disbandedGang",source)
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("XCEL:InviteUser",function(gangname,playerid)
    local source = source
    local user_id = XCEL.getUserId(source)
    local playersource = XCEL.getUserSource(tonumber(playerid))
    if source ~= playersource then
        if playersource == nil then
            XCELclient.notify(source, {"~r~Player is not online."})
            return
        else
            table.insert(playerinvites[playersource],gangname)
            addGangLog(XCEL.GetPlayerName(user_id),user_id,"Invited","ID: "..playerid)
            TriggerClientEvent("XCEL:InviteReceived",playersource,"~g~Gang invite received from: " ..XCEL.GetPlayerName(user_id),gangname)
            XCELclient.notify(source, {"~g~Successfully invited " ..XCEL.GetPlayerName(playerid).. " to the gang."})
        end
    else
        XCELclient.notify(source, {"~r~You cannot invite yourself."})
    end
end)

RegisterServerEvent("XCEL:DeleteGang",function(gangname)
    local source = source
    local user_id = XCEL.getUserId(source)
    exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank == 4 then
                        exports["xcel"]:execute("DELETE FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangname})
                        for A,B in pairs(gangmembers) do
                            MySQL.execute("xcel_edituser", {user_id = A, gangname = nil})
                            if XCEL.getUserSource(tonumber(A)) then
                                syncRadio(XCEL.getUserSource(tonumber(A)))
                                TriggerClientEvent("XCEL:disbandedGang",XCEL.getUserSource(tonumber(A)))
                            else
                                print("User is not online, unable to disbanded gang for them.")
                            end
                        end
                        
                        XCELclient.notify(source, {"~r~You have disbanded the gang."})
                    else
                        XCELclient.notify(source, {"~r~You do not have permission to disband this gang."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("XCEL:RenameGang", function(gangname,newname)
    local source = source
    local user_id = XCEL.getUserId(source)
    local gangnamecheck = exports["xcel"]:scalarSync("SELECT gangname FROM xcel_gangs WHERE gangname = @gangname", {gangname = newname})
    if gangnamecheck == nil then
        exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
            if #ganginfo > 0 then
                local gangmembers = json.decode(ganginfo[1].gangmembers)
                for A,B in pairs(gangmembers) do
                    if tostring(user_id) == A then
                        if B.rank == 4 then
                            exports["xcel"]:execute("UPDATE xcel_gangs SET gangname = @gangname WHERE gangname = @oldgangname", {gangname = newname, oldgangname = gangname})
                            for A,B in pairs(gangmembers) do
                                MySQL.execute("xcel_edituser", {user_id = A, gangname = newname})
                                syncRadio(XCEL.getUserSource(tonumber(A)))
                            end
                            XCELclient.notify(source, {"~g~You have renamed the gang to: " ..newname})
                            addGangLog(XCEL.GetPlayerName(user_id),user_id,"Renamed gang",newname)
                        else
                            XCELclient.notify(source, {"~r~You do not have permission to rename this gang."})
                        end
                    end
                end
            end
        end)
    else
        XCELclient.notify(source, {"~r~Gang name is already taken."})
        return
    end
end)

RegisterServerEvent("XCEL:SetGangWebhook")
AddEventHandler("XCEL:SetGangWebhook", function(gangid)
    local source = source 
    local user_id = XCEL.getUserId(source)
    exports['xcel']:execute('SELECT * FROM xcel_gangs WHERE gangname = @gangname', {gangname = gangid}, function(G)
        for K, V in pairs(G) do
            local array = json.decode(V.gangmembers) -- Convert the JSON string to a table
            for I, L in pairs(array) do
                if tostring(user_id) == I then
                    if L["rank"] == 4 then
                        XCEL.prompt(source, "Webhook (Enter the webhook here): ", "", function(source, webhook)
                            local pattern = "^https://discord.com/api/webhooks/%d+/%S+$"
                            if webhook and string.match(webhook, pattern) then 
                                exports['xcel']:execute("UPDATE xcel_gangs SET webhook = @webhook WHERE gangname = @gangname", {gangname = gangid, webhook = webhook}, function(gotGangs) end)
                                XCELclient.notify(source, {"~g~Webhook set."})
                                TriggerClientEvent('XCEL:ForceRefreshData', -1)
                            else
                                XCELclient.notify(source, {"~r~Invalid value."})
                            end
                        end)
                    else
                        XCELclient.notify(source, {"~r~You do not have permission."})
                    end
                end
            end
        end
    end)
end)


RegisterServerEvent("XCEL:LockGangFunds", function(gangname)
    local source = source
    local user_id = XCEL.getUserId(source)
    exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank == 4 then
                        local newlocked = not tobool(ganginfo[1].lockedfunds)
                        exports["xcel"]:execute("UPDATE xcel_gangs SET lockedfunds = @lockedfunds WHERE gangname = @gangname", {lockedfunds = newlocked, gangname = gangname}) 
                        XCELclient.notify(source, {"~g~You have " ..(newlocked and "locked" or "unlocked") .." the gang funds."})
                        TriggerClientEvent("XCEL:ForceRefreshData",source)
                        addGangLog(XCEL.GetPlayerName(user_id),user_id,"Locked Funds","")
                    else
                        XCELclient.notify(source, {"~r~You do not have permission to lock the gang funds."})
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent("XCEL:sendGangMarker",function(Gangname,coords)
    local source = source
    local user_id = XCEL.getUserId(source)
    exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = Gangname}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    for C,D in pairs(gangmembers) do
                        local temp = XCEL.getUserSource(tonumber(C))
                        if temp then
                            TriggerClientEvent("XCEL:drawGangMarker",temp,XCEL.GetPlayerName(user_id),coords)
                        end
                    end
                    break
                end
            end
        end
    end)
end)

RegisterServerEvent("XCEL:setGangFit",function(gangName)
    local source = source
    local user_id = XCEL.getUserId(source)
    exports["xcel"]:execute("SELECT * FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
        if #ganginfo > 0 then
            local gangmembers = json.decode(ganginfo[1].gangmembers)
            for A,B in pairs(gangmembers) do
                if tostring(user_id) == A then
                    if B.rank == 4 then
                        XCELclient.getCustomization(source,{},function(customization)
                            exports["xcel"]:execute("UPDATE xcel_gangs SET gangfit = @gangfit WHERE gangname = @gangname", {gangfit = json.encode(customization), gangname = gangName})
                            XCELclient.notify(source, {"~g~You have set the gang fit."})
                            addGangLog(XCEL.GetPlayerName(user_id),user_id,"Set Gang Fit","")
                            TriggerClientEvent("XCEL:ForceRefreshData",source)
                        end)
                    else
                        XCELclient.notify(source, {"~r~You do not have permission to set the gang fit."})
                    end
                end
            end
        end
    end)
end)


RegisterServerEvent("XCEL:applyGangFit", function(gangName)
    local source = source
    local user_id = XCEL.getUserId(source)
    exports["xcel"]:execute("SELECT gangfit FROM xcel_gangs WHERE gangname = @gangname", {gangname = gangName}, function(ganginfo)
        if #ganginfo > 0 then
            XCELclient.setCustomization(source, {json.decode(ganginfo[1].gangfit)}, function()
                XCELclient.notify(source, {"~g~You have applied the gang fit."})
                addGangLog(XCEL.GetPlayerName(user_id),user_id,"Apply Gang Fit","")
            end)
        end
    end)
end)

AddEventHandler("XCEL:playerSpawn", function(user_id,source,fspawn)
    if fspawn then
        playerinvites[source] = {}
        exports["xcel"]:execute("INSERT IGNORE INTO xcel_user_gangs (user_id) VALUES (@user_id)", {user_id = user_id})
    end
end)

function XCEL.getGangName(user_id)
    return exports["xcel"]:scalarSync("SELECT gangname FROM xcel_user_gangs WHERE user_id = @user_id", {user_id = user_id}) or ""
end
RegisterServerEvent("XCEL:newGangPanic")
AddEventHandler("XCEL:newGangPanic", function(a,playerName)
    local source = source
    local user_id = XCEL.getUserId(source)   
    local peoplesids = {}
    local gangmembers = {}
    exports['xcel']:execute('SELECT * FROM xcel_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    isingang = true
                    for U,D in pairs(array) do
                        peoplesids[tostring(U)] = tostring(D.gangPermission)
                    end
                    exports['xcel']:execute('SELECT * FROM xcel_users', function(gotUser)
                        for J,G in pairs(gotUser) do
                            if peoplesids[tostring(G.id)] then
                                local player = XCEL.getUserSource(tonumber(G.id))
                                if player then
                                    TriggerClientEvent("XCEL:returnPanic", player, player, a, playerName,V.gangname)
                                    addGangLog(XCEL.GetPlayerName(user_id),user_id,"Panic","ID: "..G.id)
                                end
                            end
                        end
                    end)
                    break
                end
            end
        end
    end)
end)

local gangtable = {}
Citizen.CreateThread(function()
    while true do
        Wait(10000)
        for _,a in pairs(GetPlayers()) do
            local user_id = XCEL.getUserId(a)
            if user_id then
                gangtable[user_id] = {health = GetEntityHealth(GetPlayerPed(a)), armor = GetPedArmour(GetPlayerPed(a))}
            end
        end
        TriggerClientEvent("XCEL:sendGangHPStats", -1, gangtable)
    end
end)

AddEventHandler("playerDropped", function(reason)
    local source = source
    local user_id = XCEL.getUserId(source)
    if gangtable[user_id] ~= nil then
        gangtable[user_id] = nil
        TriggerClientEvent("XCEL:sendGangHPStats", -1, gangtable)
        syncRadio(source)
    end
end)

Citizen.CreateThread(function()
    Wait(2500)
    exports['xcel']:execute([[
    CREATE TABLE IF NOT EXISTS `xcel_user_gangs` (
    `user_id` int(11) NOT NULL,
    `gangname` VARCHAR(100) NULL,
    PRIMARY KEY (`user_id`)
    );]])
end)

RegisterCommand("gangconvert",function(source)
    if source == 0 then
        exports['xcel']:execute("SELECT * FROM xcel_gangs",{},function(gangs)
            for A,B in pairs(gangs) do
                local gangmembers = json.decode(B.gangmembers)
                for C,D in pairs(gangmembers) do
                    print("Setting gang for user: "..C.." to "..B.gangname)
                    MySQL.execute("xcel_adduser", {user_id = C, gangname = B.gangname})
                end
            end
        end)
    end
end)

AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    local source = source
    syncRadio(source)
end)