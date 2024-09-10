local currenttests = {}
local dvsamodule = module("cfg/cfg_dvsa")


local dvsaAlerts = {
    --{title = 'DVSA', message = 'No current alerts.', date = 'Wednesday 7th September 2022'},
}

AddEventHandler("playerJoining", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    exports['xcel']:execute("SELECT * FROM xcel_dvsa WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if next(result) then 
            for k,v in pairs(result) do
                if v.user_id == user_id then
                    local data1 = {}
                    local licence = {}
                    local date = os.date("%d/%m/%Y")
                    local updateddata = exports['xcel']:executeSync("SELECT * FROM xcel_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
                    if updateddata ~= nil then
                        licence = {
                            ["banned"] = updateddata.licence == "banned",
                            ["full"] = updateddata.licence == "full",
                            ["active"] = updateddata.licence == "active",
                            ["points"] = updateddata.points or 0,
                            ["id"] = updateddata.id or "No Licence",
                            ["date"] = date or os.date("%d/%m/%Y")
                        }
                    end
                    if updateddata.penalties == nil then
                        updateddata.penalties = {}
                    end
                    if updateddata.testsaves == nil then
                        updateddata.testsaves = {}
                    end
                    TriggerClientEvent('XCEL:dvsaData',source,licence,updateddata.penalties,updateddata.testsaves,dvsaAlerts)
                    return
                end
            end
        else
            exports['xcel']:execute("INSERT INTO xcel_dvsa (user_id,licence,datelicence) VALUES (@user_id, 'none',"..os.date("%d/%m/%Y")..")", {user_id = user_id})
            local data1 = {}
            local licence = {}
            local date = os.date("%d/%m/%Y")
            local updateddata = exports['xcel']:executeSync("SELECT * FROM xcel_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
            if updateddata ~= nil then
                licence = {
                    ["banned"] = updateddata.licence == "banned",
                    ["full"] = updateddata.licence == "full",
                    ["active"] = updateddata.licence == "active",
                    ["points"] = updateddata.points or 0,
                    ["id"] = updateddata.id or "No Licence",
                    ["date"] = date or os.date("%d/%m/%Y")
                }
            end
            TriggerClientEvent('XCEL:dvsaData',source,licence,{},{},dvsaAlerts)
            return
        end
    end)
end)

function dvsaUpdate(user_id)
    local source = XCEL.getUserSource(user_id)
    local data = exports['xcel']:executeSync("SELECT * FROM xcel_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    local licence = {}
    local date = os.date("%d/%m/%Y")
    if data ~= nil then
        licence = {
            ["banned"] = data.licence == "banned",
            ["full"] = data.licence == "full",
            ["active"] = data.licence == "active",
            ["points"] = data.points or 0,
            ["id"] = data.id or "No Licence",
            ["date"] = date or os.date("%d/%m/%Y")
        }
    end
    TriggerClientEvent('XCEL:updateDvsaData',source,licence,json.decode(data.penalties),json.decode(data.testsaves),dvsaAlerts)
end
RegisterServerEvent("XCEL:dvsaBucket")
AddEventHandler("XCEL:dvsaBucket", function(bool)
    local source = source
    local user_id = XCEL.getUserId(source)
    if bool then
        if currenttests[user_id] ~= nil then
            currenttests[user_id] = nil
        end
        XCEL.setBucket(source, 0)
    elseif not bool then
        if currenttests[user_id] ~= nil then
            XCELclient.notify(source,{'~r~You already have a test in progress.'})
            return
        end
        local bucket = math.random(21,300)
        local highestcount = 21
        if table.count(currenttests) > 0 then
            for k,v in pairs(currenttests) do
                if v.bucket == bucket then
                    repeat highestcount = math.random(21,300) until highestcount ~= bucket
                end
            end
        end
        currenttests[user_id] = {
            ["bucket"] = highestcount
        }
        XCEL.setBucket(source, currenttests[user_id].bucket)
    end
end)

RegisterServerEvent("XCEL:candidatePassed")
AddEventHandler("XCEL:candidatePassed", function(seriousissues,minorissues,minorreasons)
    local localday = os.date("%A (%d/%m/%Y) at %X")
    local source = source
    local licence
    local user_id = XCEL.getUserId(source)
    exports['xcel']:execute('SELECT * FROM xcel_dvsa WHERE user_id = @user_id', {user_id = user_id}, function(GotLicence)
        licence = GotLicence[1].licence
        local previoustests = {}
        local testsaves = json.decode(GotLicence[1].testsaves)
        if testsaves ~= nil then
            previoustests = testsaves
            table.insert(previoustests, {date = localday, serious = seriousissues, minor = minorissues, minorsReason = minorreasons, pass = true}) 
        else
            table.insert(previoustests, {date = localday, serious = seriousissues,  minor = minorissues, minorsReason = minorreasons, pass = true})
        end
        if licence == "active" then
            exports['xcel']:execute("UPDATE xcel_dvsa SET licence = 'full', testsaves = @testsaves WHERE user_id = @user_id", {user_id = user_id,testsaves=json.encode(previoustests)}, function() end)
            Wait(100)
            dvsaUpdate(user_id)
        end
    end)
end)

RegisterServerEvent("XCEL:candidateFailed")
AddEventHandler("XCEL:candidateFailed", function(seriousissues,minorissues,seriousreasons,minorreasons)    
    local localday = os.date("%A (%d/%m/%Y) at %X")
    local source = source
    local licence
    local user_id = XCEL.getUserId(source)
    exports['xcel']:execute('SELECT * FROM xcel_dvsa WHERE user_id = @user_id', {user_id = user_id}, function(GotLicence)
        licence = GotLicence[1].licence
        local previoustests = {}
        local testsaves = json.decode(GotLicence[1].testsaves)
        if testsaves ~= nil then
            previoustests = testsaves
            table.insert(previoustests, {date = localday, serious = seriousissues, seriousReason = seriousreasons, minor = minorissues, minorsReason = minorreasons})
        else
            table.insert(previoustests, {date = localday, serious = seriousissues, seriousReason = seriousreasons, minor = minorissues, minorsReason = minorreasons})
        end
        if licence == "active" then
            exports['xcel']:execute("UPDATE xcel_dvsa SET testsaves = @testsaves WHERE user_id = @user_id", {user_id = user_id,testsaves=json.encode(previoustests)}, function() end)
            Wait(100)
            dvsaUpdate(user_id)
        end
    end)
end)

RegisterServerEvent("XCEL:beginTest")
AddEventHandler("XCEL:beginTest", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local data = exports['xcel']:executeSync("SELECT * FROM xcel_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    if data.licence == ("full" or "banned") then
        TriggerClientEvent('XCEL:beginTestClient', source, false)
        return
    end
    if data.licence == "active" then
        TriggerClientEvent('XCEL:beginTestClient', source,true,math.random(1,3))
    else
        XCEL.ACBan(15,user_id,'XCEL:beginTest')
    end
end)

RegisterServerEvent("XCEL:surrenderLicence")
AddEventHandler("XCEL:surrenderLicence", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local uuid = math.random(1,9999999999)
    local data = exports['xcel']:executeSync("SELECT * FROM xcel_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    if data.licence == "banned" then
        XCELclient.notify(source,{'~r~You are already banned from driving.'})
        XCEL.ACBan(15,user_id,'XCEL:surrenderLicence')
        return
    end
    if data.licence == "active" or data.licence == "full" then
        exports['xcel']:execute("UPDATE xcel_dvsa SET licence = @licence WHERE user_id = @user_id", {licence = "none", user_id = user_id})
        exports['xcel']:execute("UPDATE xcel_dvsa SET id = @id WHERE user_id = @user_id", {id = uuid, user_id = user_id})
        Wait(100)
        dvsaUpdate(user_id)
    end
end)

RegisterServerEvent("XCEL:activateLicence")
AddEventHandler("XCEL:activateLicence", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local uuid = math.random(1,9999999999)
    local data = exports['xcel']:executeSync("SELECT * FROM xcel_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    if data == nil then return end
    if data.licence == "none" then
        exports['xcel']:execute("UPDATE xcel_dvsa SET licence = @licence, datelicence = @datelicense WHERE user_id = @user_id", {licence = "active", datelicense = os.date("%d/%m/%Y"), user_id = user_id})
        exports['xcel']:execute("UPDATE xcel_dvsa SET id = @id WHERE user_id = @user_id", {id = uuid, user_id = user_id})
        Wait(100)
        dvsaUpdate(user_id)
    end
end)

RegisterServerEvent("XCEL:speedCameraFlashServer",function(speed)
    local source = source
    local user_id = XCEL.getUserId(source)
    local name = XCEL.GetPlayerName(user_id)
    local bank = XCEL.getBankMoney(user_id)
    local speed = tonumber(speed)
    local overspeed = speed-100
    local fine = 10000
    if XCEL.hasPermission(user_id,"police.armoury") then
        return
    end
    if tonumber(bank) > fine then
        XCEL.setBankMoney(user_id,bank-fine)
        XCEL.addToCommunityPot(math.floor(fine))
        TriggerClientEvent('XCEL:dvsaMessage', source,"DVSA","UK Government","You were fined £"..getMoneyStringFormatted(fine).." for going "..overspeed.."MPH over the speed limit.")
        return
    else
        XCELclient.notify(source,{'~r~You could not afford the fine. Benefits paid.'})
        return
    end
end)

RegisterServerEvent('XCEL:speedGunFinePlayer')
AddEventHandler('XCEL:speedGunFinePlayer', function(temp, speed)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') then
      local fine = speed*100
      XCEL.tryBankPayment(XCEL.getUserId(temp), fine)
      TriggerClientEvent('XCEL:speedGunPlayerFined', temp)
      TriggerClientEvent('XCEL:dvsaMessage', temp,"DVSA","UK Government","You were fined £"..getMoneyStringFormatted(fine).." for going "..speed.."MPH over the speed limit.")
      XCELclient.notify(source, { "~r~Fined "..XCEL.GetPlayerName(XCEL.getUserId(temp)).." £"..getMoneyStringFormatted(fine).." for going "..speed.."MPH over the speed limit."})
    end
end)

local speedTraps = {}
RegisterCommand('setup', function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') then
        if speedTraps[user_id] then
            XCELclient.removeBlipAtCoords(-1,speedTraps[user_id])
            speedTraps[user_id] = nil
            XCELclient.notify(source,{'~r~Speed Trap Removed.'})
        else
            local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(source)))
            XCELclient.addBlip(-1,{x,y,z,419,0,"Speed Camera",2.5})
            speedTraps[user_id] = {x,y,z}
            XCELclient.notify(source,{'~g~Speed Trap Setup.'})
        end
    end
end)