local EventTypes = {
    ["Battle Royale"] = {"Legion","Sandy Shores","Paleto","Cayo Perico"}, -- Event Locations for Battle Royale
   -- ["Dropzone"] = {"Sandy Airfield","Grapeseed Airfield","LSD South","Kortz","Rebel Hill","H Bunker"}, -- Event Locations for Dropzone
    -- ["FFA"] = {"Heroin","LSD ATM"}, -- Event Locations for FFA
    -- ["Race"] = {"Forest Playground","Sanchez Parkour","Total Wipeout","District Afterglow","BMX Parkour","Blazer Shootin","Rally Racing","Heathrow Grand Prix","Devil's Breath","Batman Begins","DuneLoader Hell","TNT (Parkour)","Atomic Circuit","City Rooftop","Rainbowland","Sandy Run","Valley Valentine"}, -- Event Locations for Races
  --  ["Musket Wars"] = {"Map"},
}

CurrentEvent = {
    players = {}, -- Players in the event
    isActive = false, -- Is the event active
    eventName = "", -- Name of the event
    eventID = 0, -- Count Up 1 for each event
    eventData = {}, -- Event Data
    winners = {}, -- Winners of the event
    losers = {}, -- Losers of the event
}

local function CreateEvent(catagory,location,spawncode,user_id)
    if not CurrentEvent.isActive then
        CurrentEvent.isActive = true
        CurrentEvent.eventName = catagory
        CurrentEvent.eventLocation = location
        CurrentEvent.eventID = CurrentEvent.eventID + 1
        CurrentEvent.eventData.spawncode = spawncode or ""
        TriggerClientEvent("chatMessage",-1,"^7^*[XCEL Events]",{180,0,0},catagory.." event has started, type /joinevent to join", "eventalert")
        TriggerClientEvent("XCEL:announceEventJoinable", -1, catagory, 15)
        if user_id ~= "Console" then
            CurrentEvent.players[user_id] = {name = XCEL.GetPlayerName(user_id),source = source, user_id = user_id}
            TriggerClientEvent("XCEL:EventSequence",source)
            TriggerClientEvent("XCEL:addEventPlayer",-1,tbl)
            TriggerClientEvent("XCEL:OpentHostEventMenu",source,true,CurrentEvent.eventID)
            TriggerClientEvent("XCEL:syncPlayers",source,CurrentEvent.players,CurrentEvent.eventID)
        end
    else
        XCELclient.notify(XCEL.getuserSource(user_id),{"~r~There is already an event active"})
    end
end

local function count(tbl)
    local count = 0
    for k,v in pairs(tbl) do
        count = count + 1
    end
    return count
end

local function StartEvent()
    if count(CurrentEvent.players) >= 1 then
        if CurrentEvent.eventName == "Battle Royale" then
            TriggerEvent("XCEL:Event:BattleRoyale",CurrentEvent.eventLocation)
        end
    else
        TriggerClientEvent("chatMessage",-1,"^7^*[XCEL Events]",{180,0,0},CurrentEvent.eventName.." event has been cancelled due to not enough players", "eventalert")
        XCEL.ResetEvent()
    end
end

local function CanJoinEvent(user_id)
    for k,v in pairs(CurrentEvent.players) do
        if v.user_id == user_id then
            return true
        end
    end
    return false
end

-- [[ Commands ]] --

-- XCEL.GetStaffLevel(user_id) >=4 or

RegisterCommand("eventmenu",function(source) -- Event Menu for Devs
    local source = source
    if XCEL.getStaffLevel(XCEL.getUserId(source)) >= 5 then
        TriggerClientEvent("XCEL:OpenEventMenu",source,EventTypes)
        TriggerClientEvent("XCEL:IsAnyEventActive",source,CurrentEvent.isActive)
    end
end)

RegisterCommand("joinevent",function(source) -- Join the event if there is one active
    local source = source
    local user_id = XCEL.getUserId(source)
    if CurrentEvent.isActive then
        if not CurrentEvent.players[user_id] then
            local tbl = {name = XCEL.GetPlayerName(user_id),source = source, user_id = user_id}
            CurrentEvent.players[user_id] = tbl
            TriggerClientEvent("XCEL:EventSequence",source)
            TriggerClientEvent("XCEL:addEventPlayer",-1,tbl)
            TriggerClientEvent("XCEL:OpentHostEventMenu",source,false,CurrentEvent.eventID)
            TriggerClientEvent("XCEL:syncPlayers",source,CurrentEvent.players,CurrentEvent.eventID)
        else
            XCELclient.notify(source, (CurrentEvent.players[user_id] and {"~r~You are already in the event"}) or {"~r~You do not meet the requirements to join this event"})
        end
    else
        XCELclient.notify(source, {"~r~There is no event active"})
    end
end)

RegisterCommand("leaveevent",function(source) -- Leave the event if there is one active
    local source = source
    local user_id = XCEL.getUserId(source)
    if CurrentEvent.isActive then
        if CurrentEvent.players[user_id] then
            if CurrentEvent.eventName == "Battle Royale" then
                TriggerClientEvent("XCEL:removePlayerFromBR",-1,source)
                TriggerClientEvent("XCEL:BattleGrounds:Cleanup",source)
            elseif CurrentEvent.eventName == "Dropzone" then
                XCEL.LeaveDropzone(source)
            elseif CurrentEvent.eventName == "FFA" then
                TriggerClientEvent("XCEL:FFA:RemovePlayer",-1,source)
            elseif CurrentEvent.eventName == "Musket Wars" then
                TriggerClientEvent("XCEL:MusketWars:Leave",-1,source)
                TriggerClientEvent("XCEL:MusketWars:End",source)
            end
            SetPlayerRoutingBucket(source,0)
            TriggerClientEvent("XCEL:ClearEventData",source)
            TriggerClientEvent("XCEL:Teleport",source,vector3(-2265.09, 3224.25, 32.81))
            TriggerClientEvent("XCEL:removeEventPlayer",-1, CurrentEvent.players[user_id])
            if #CurrentEvent.players <= 1 then
                TriggerClientEvent("chatMessage",-1,"^7^*[XCEL Events]",{180,0,0},CurrentEvent.eventName.." event has ended", "eventalert")
                XCEL.ResetEvent()
            end
            CurrentEvent.players[user_id] = nil
        else
            XCELclient.notify(source, {"~r~You are not in the event"})
        end
    else
        XCELclient.notify(source, {"~r~There is no event active"})
    end
end)

-- [[ Events ]] --

RegisterServerEvent("XCEL:RequestActiveEvent",function() -- Request if there is an active event
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.getStaffLevel(XCEL.getUserId(source)) >= 5 then
        TriggerClientEvent("XCEL:IsAnyEventActive",source,CurrentEvent.isActive)
    else
        XCELclient.notify(source, {"~r~You do not have permission to do this"})
    end
end)

RegisterServerEvent("XCEL:CreateEvent",function(catagory,location,spawncode)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.getStaffLevel(XCEL.getUserId(source)) >= 5 then
        CreateEvent(catagory,location,spawncode,user_id)
        TriggerClientEvent("XCEL:Closemenu",source)
    else
        XCELclient.notify(source, {"~r~You do not have permission to do this"})
    end
end)

RegisterServerEvent("XCEL:StartEvent",function(eventID,leave)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.getStaffLevel(XCEL.getUserId(source)) >= 5 and CurrentEvent.isActive then
        if CurrentEvent.eventID == eventID then
            if leave then
                TriggerClientEvent("XCEL:ClearEventData",source)
                TriggerClientEvent("XCEL:Teleport",source,vector3(-2265.09, 3224.25, 32.81))
                TriggerClientEvent("XCEL:removeEventPlayer",-1, CurrentEvent.players[user_id])
                CurrentEvent.players[user_id] = nil
            end
            StartEvent()
        else
            XCELclient.notify(source, {"~r~This event is not active"})
        end
    else
        XCEL.ACBan(15,user_id,"XCEL:StartEvent")
    end
end)

RegisterServerEvent("XCEL:EndEvent",function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.getStaffLevel(XCEL.getUserId(source)) >= 5 then
        if CurrentEvent.isActive then
            TriggerClientEvent("chatMessage",-1,"^7^*[XCEL Events]",{180,0,0},"Event has been ended by "..XCEL.GetPlayerName(user_id), "eventalert")
            XCEL.ResetEvent()
        else
            XCELclient.notify(source, {"~r~There is no event active"})
        end
    else
        XCEL.ACBan(15,user_id,"XCEL:EndEvent")
    end
end)
function XCEL.diedInEvent(killedsource,killersource)
    local user_id = XCEL.getUserId(killedsource)
    local killer_id = XCEL.getUserId(killersource)
    local killedname = XCEL.GetPlayerName(user_id)
    local killername = XCEL.GetPlayerName(killer_id)
    if CurrentEvent.eventName == "Battle Royale" then
        TriggerClientEvent("XCEL:removeEventPlayer",-1, CurrentEvent.players[user_id])
        if killersource ~= nil then
           TriggerClientEvent("XCEL:addBRKill",-1,killersource,XCEL.GetPlayerName(killer_id))
        end
        TriggerClientEvent("XCEL:removePlayerFromBR",-1,killedsource)
        TriggerClientEvent("XCEL:BattleGrounds:Cleanup",killedsource)--, false, {name=XCEL.GetPlayerName(user_id),source=killedsource})
        TriggerClientEvent("XCEL:ClearEventData",killedsource)
        XCELclient.notify(killedsource, {"~r~You have been eliminated from the event"})
        SetPlayerRoutingBucket(killedsource,0)
        XCELclient.RevivePlayer(killedsource, {})
        CurrentEvent.players[user_id] = nil
        CurrentEvent.losers[user_id] = {name = killedname, source = killedsource}
        if count(CurrentEvent.players) <= 1 then
            if killersource ~= nil and killername ~= nil and killer_id ~= nil then
                TriggerClientEvent("chatMessage",-1,"^7^*[XCEL Events]",{180,0,0},killername.." has won the "..CurrentEvent.eventName.." event", "eventalert")
                CurrentEvent.winners[killer_id] = {name = killername, source = killersource}
                XCEL.giveBankMoney(killer_id, math.random(250000,450000))
            else
                TriggerClientEvent("chatMessage",-1,"^7^*[XCEL Events]",{180,0,0},"The "..CurrentEvent.eventName.." event has ended", "eventalert")
            end
            XCEL.ResetEvent()
        end
    end
end

RegisterCommand("testbrkills",function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasGroup(user_id, "Founder") then
        TriggerClientEvent("XCEL:addBRKill",-1,source,XCEL.GetPlayerName(user_id))
    end
end)

AddEventHandler("playerDropped",function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if CurrentEvent.isActive then
        if CurrentEvent.players[user_id] then
            if CurrentEvent.eventName == "Battle Royale" then
                TriggerClientEvent("XCEL:removePlayerFromBR",-1,source)
            elseif CurrentEvent.eventName == "Dropzone" then
                TriggerClientEvent("XCEL:removeLootcrate",source,1)
                TriggerClientEvent("XCEL:removeCrateRedzone",source)
            elseif CurrentEvent.eventName == "FFA" then
                TriggerClientEvent("XCEL:FFA:RemovePlayer",-1,source)
            end
            if #CurrentEvent.players <= 1 then
                TriggerClientEvent("chatMessage",-1,"^7^*[XCEL Events]",{180,0,0},CurrentEvent.eventName.." event has ended", "eventalert")
                XCEL.ResetEvent()
            end
            TriggerClientEvent("XCEL:removeEventPlayer",-1, CurrentEvent.players[user_id])
        end
    end
end)

-- [[ Functions ]] --

function XCEL.InEvent(user_id)
    if CurrentEvent.players[user_id] then
        return true
    else
        return false
    end
end

function table.MaxKeys(table)
    local count = 0
    for k,v in pairs(table) do
        count = count + 1
    end
    return count
end

function XCEL.ResetEvent()
    for k,v in pairs(CurrentEvent.players) do
        SetPlayerRoutingBucket(v.source,0)
        TriggerClientEvent("XCEL:syncPlayers",v.source,{},CurrentEvent.eventID)
        TriggerClientEvent("XCEL:ClearEventData",v.source)
        TriggerClientEvent("XCEL:Teleport",v.source,vector3(-2265.09, 3224.25, 32.81))
        if CurrentEvent.eventName == "Battle Royale" then
            TriggerClientEvent("XCEL:BattleGrounds:Cleanup",v.source)
            TriggerClientEvent("XCEL:ClearEventData",v.source)
        elseif CurrentEvent.eventName == "Dropzone" then
            XCEL.LeaveDropzone(v.source)
        elseif CurrentEvent.eventName == "Musket Wars" then
            TriggerClientEvent("XCEL:MusketWars:End",v.source)
        end
    end
    local function callPodium(source)
        local id = XCEL.getUserId(source)
        if CurrentEvent.eventName == "Battle Royale" then
            TriggerClientEvent("XCEL:BattleGrounds:Cleanup",source)
        end
        if next(CurrentEvent.winners) ~= nil and count(CurrentEvent.players) - count(CurrentEvent.losers) <= 1 then
            SetPlayerRoutingBucket(source,55)
            TriggerClientEvent("XCEL:CallPodium",source,CurrentEvent.winners,CurrentEvent.losers)
            if CurrentEvent.winners[id] then
                TriggerClientEvent("XCEL:celebrationScreen",source, CurrentEvent.winners[id].name, (CurrentEvent.winners[id] and 1 or 2))
            end
            SetTimeout(18000,function()
                SetPlayerRoutingBucket(source,0)
                XCELclient.setPlayerCombatTimer(source, {0})
                XCELclient.teleport(source, {153.33256530762,-1036.1697998047,29.330490112305,globalpasskey})
                TriggerClientEvent("XCEL:ClearEventData",source)
            end)
        else
            TriggerClientEvent("XCEL:ClearEventData",source)
            XCELclient.teleport(source, {153.33256530762,-1036.1697998047,29.330490112305,globalpasskey})
        end
    end
    for k,v in pairs(CurrentEvent.winners) do
        callPodium(v.source)
    end
    for k,v in pairs(CurrentEvent.losers) do
        callPodium(v.source)
    end
    CurrentEvent.isActive = false
    CurrentEvent.eventName = ""
    CurrentEvent.eventLocation = ""
    CurrentEvent.players = {}
    CurrentEvent.winners = {}
    CurrentEvent.losers = {}
end


-- Citizen.CreateThread(function()
--     Wait(30*60*1000)
--     while true do
--         local players = GetPlayers()
--         if not CurrentEvent.isActive then -- and #players >= 3 then
--             local catagory,location = "",""
--             if #players >= 10 then
--                 catagory = "Battle Royale"
--                 location = EventTypes["Battle Royale"][math.random(1,#EventTypes["Battle Royale"])]
--             elseif #players >= 3 then
--                 catagory = "Dropzone"
--                 location = EventTypes["Dropzone"][math.random(1,#EventTypes["Dropzone"])]
--             end
--             CreateEvent(catagory,location,nil,"Console")
--             Wait(60000)
--             StartEvent()
--         end
--         Wait(30*60*1000)
--     end
-- end)