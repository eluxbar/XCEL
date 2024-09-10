local weapons = module("cfg/weapons").weapons
local whitelists = XCEL.getWhitelistGuns()
local cfg = module("cfg/cfg_wagers").settings
local wagerTeam = {}
local wagerCurrentlyIn = {}

local function getOwnerDetails(id)
    if wagerTeam[id] then
        return wagerTeam[id]
    end
    return false
end

RegisterNetEvent("XCEL:getWagerWhitelists", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local cfg_whitelists = {}
    for k,v in pairs(whitelists) do
        for a,b in pairs(v) do
            if weapons[a] and b[6] == user_id and not weapons[a].policeWeapon and weapons[a].class ~= "Melee" then
                cfg_whitelists[a] = weapons[a].name
            end
        end
    end
    TriggerClientEvent("XCEL:gotWagerWhitelists", source, cfg_whitelists, true)
end)

RegisterServerEvent("XCEL:createWager", function(bestOf, wagerWeapon, WagerWeaponCategory, betAmount, armourValues,mapLoc)
    local source = source
    local user_id = XCEL.getUserId(source)
    for k,v in pairs(wagerTeam) do
        if v.teamA.players[user_id] then
            v.teamA.players[user_id] = nil
        elseif v.teamB.players[user_id] then
            v.teamB.players[user_id] = nil
        end
        if v.owner_id == user_id then
            wagerTeam[user_id] = nil
        end
    end
    wagerTeam[user_id] = {
        teamA = {
            players = {
                [user_id] = {source = source, user_id = user_id, name = XCEL.GetPlayerName(user_id)},
            },
            wins = 0,
        },
        teamB = {
            players = {},
            wins = 0
        },
        currentRound = 0,
        owner = true,
        owner_id = user_id,
        name = XCEL.GetPlayerName(user_id),
        bestOf = bestOf,
        armourValues = armourValues,
        wagerWeapon = wagerWeapon,
        WagerWeaponCategory = WagerWeaponCategory,
        betAmount = betAmount,
        teamALoc = mapLoc.A,
        teamBLoc = mapLoc.B,
        Radius = mapLoc.radius,
        inProgress = false
    }
    TriggerClientEvent("XCEL:sendWagerData", -1, wagerTeam)
end)

RegisterServerEvent("XCEL:joinWager", function(wager_owner, team)
    local source = source
    local user_id = XCEL.getUserId(source)
    wager_owner = tonumber(wager_owner)
    local ownerDetails = getOwnerDetails(wager_owner)
    if not ownerDetails.inProgress then
        if XCEL.getBankMoney(user_id) + XCEL.getMoney(user_id) < tonumber(ownerDetails.betAmount) then
            XCELclient.notify(source, {"~r~You cannot afford to join this wager!"})
            return
        end
        if ownerDetails.owner_id ~= user_id and wagerTeam[user_id] then
            wagerTeam[user_id] = nil
        end
        if table.count(ownerDetails[team].players) == 2 then
            XCELclient.notify(source, {"~r~"..team.." is full!"})
            return
        end
        for k,v in pairs(wagerTeam) do
            if v.teamA.players[user_id] then
                v.teamA.players[user_id] = nil
            elseif v.teamB.players[user_id] then
                v.teamB.players[user_id] = nil
            end
        end
        if ownerDetails then
            local isOwner = user_id == wager_owner
            local otherTeam = team == "teamA" and "teamB" or "teamA"
            if ownerDetails[otherTeam].players[user_id] then
                ownerDetails[otherTeam].players[user_id] = nil
            end
            wagerTeam[wager_owner][team].players[user_id] = {
                source = source,
                user_id = user_id,
                name = XCEL.GetPlayerName(user_id),
                owner = isOwner
            }
            TriggerClientEvent("XCEL:sendWagerData", -1, wagerTeam)
        else
            XCELclient.notify(source, {"~r~Couldn't find the owner for this wager."})
        end
    else
        XCELclient.notify(source, {"~r~This wager is currently in progress."})
    end
end)

RegisterServerEvent("XCEL:leaveTeam", function(wager_owner, team)
    local source = source
    local user_id = XCEL.getUserId(source)
    wager_owner = tonumber(wager_owner)
    local ownerDetails = getOwnerDetails(wager_owner)
    if ownerDetails and ownerDetails[team] and ownerDetails[team].players[user_id] then
        wagerTeam[wager_owner][team].players[user_id] = nil
        if ownerDetails.owner_id == user_id then
            wagerTeam[user_id] = nil
        end
        TriggerClientEvent("XCEL:sendWagerData", -1, wagerTeam)
    else
        XCELclient.notify(source, {"~r~You are not in a team to leave!"})
    end
end)

RegisterServerEvent("XCEL:cancelWager", function(wager_owner)
    local source = source
    local user_id = XCEL.getUserId(source)
    wager_owner = tonumber(wager_owner)
    local ownerDetails = getOwnerDetails(wager_owner)
    if ownerDetails and ownerDetails.owner_id == user_id then
        for k,v in pairs(ownerDetails.teamA.players) do
            XCELclient.notify(v.source, {"~r~" .. XCEL.GetPlayerName(ownerDetails.owner_id) .. " has cancelled the wager!"})
        end
        for k,v in pairs(ownerDetails.teamB.players) do
            XCELclient.notify(v.source, {"~r~" .. XCEL.GetPlayerName(ownerDetails.owner_id) .. " has cancelled the wager!"})
        end
        wagerTeam[user_id] = nil
        TriggerClientEvent("XCEL:sendWagerData", -1, wagerTeam)
    end
end)

local function startDistCheck(source)
    Citizen.CreateThread(function()
        while getOwnerDetails(wagerCurrentlyIn[source]) and getOwnerDetails(wagerCurrentlyIn[source]).inProgress do
            local ownerDetails = getOwnerDetails(wagerCurrentlyIn[source])
            
            if ownerDetails.teamA.players[XCEL.getUserId(source)] then
                if #(GetEntityCoords(GetPlayerPed(source)) - vector(ownerDetails.teamALoc[1].x,ownerDetails.teamALoc[1].y,ownerDetails.teamALoc[1].z)) > ownerDetails.Radius then
                    XCELclient.notify(source, {"~r~You've gone too far away from the wager location!"})
                    XCELclient.teleport(source, {ownerDetails.teamALoc[1].x,ownerDetails.teamALoc[1].y,ownerDetails.teamALoc[1].z})
                end
            elseif ownerDetails.teamB.players[XCEL.getUserId(source)] then
                if #(GetEntityCoords(GetPlayerPed(source)) - vector(ownerDetails.teamBLoc[1].x,ownerDetails.teamBLoc[1].y,ownerDetails.teamBLoc[1].z)) > ownerDetails.Radius then
                    XCELclient.notify(source, {"~r~You've gone too far away from the wager location!"})
                    XCELclient.teleport(source, {ownerDetails.teamBLoc[1].x,ownerDetails.teamBLoc[1].y,ownerDetails.teamBLoc[1].z})
                end
            end
            Wait(ownerDetails and 1000 or 0)
        end
    end)
end

RegisterServerEvent("XCEL:startWager", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local ownerDetails = getOwnerDetails(user_id)
    if wagerTeam[user_id] then
        local allPlayersCanAfford = true
        local allPlayersInRadius = true
        local playerTables = {
            ownerDetails.teamA.players,
            ownerDetails.teamB.players
        }
        for a,b in pairs(playerTables) do
            for _, playerDetails in pairs(b) do
                if XCEL.getBankMoney(playerDetails.user_id) + XCEL.getMoney(playerDetails.user_id) < tonumber(ownerDetails.betAmount) then
                    allPlayersCanAfford = false
                end
                if #(GetEntityCoords(GetPlayerPed(playerDetails.source)) - cfg.wagerStartLoc) > 10 then
                    allPlayersInRadius = false
                end
            end
        end
        if allPlayersCanAfford then
            if allPlayersInRadius then
                if table.count(ownerDetails.teamA.players) == 0 or table.count(ownerDetails.teamB.players) == 0 then
                    XCELclient.notify(source,{"~r~Cannot start the wager one of the teams are empty!"})
                    return
                end
                if table.count(ownerDetails.teamA.players) ~= table.count(ownerDetails.teamB.players) then
                    XCELclient.notify(source,{"~r~Teams must be balanced to start the wager!"})
                    return
                end
                local function preparePlayerForWager(playerDetails, location)
                    XCEL.tryFullPayment(playerDetails.user_id, tonumber(ownerDetails.betAmount))
                    XCEL.setBucket(playerDetails.source, 5555+ownerDetails.owner_id)
                    XCELclient.removeAllWeapons(playerDetails.source,{})
                    XCELclient.teleport(playerDetails.source, {location.x,location.y,location.z})
                    XCELclient.playAnim(playerDetails.source, {true, {{"mini@triathlon", "idle_d", 1}}, true})
                    Citizen.Wait(50)
                    FreezeEntityPosition(GetPlayerPed(playerDetails.source), true)
                    XCELclient.giveWeapons(playerDetails.source, {{[ownerDetails.wagerWeapon] = {ammo = 250}}, true})
                    local armourValue = ownerDetails.armourValues and (ownerDetails.armourValues):gsub("%%", "") or 0
                    XCELclient.setArmour(playerDetails.source, {tonumber(armourValue), true})
                    XCELclient.showCountdownTimer(playerDetails.source, {3})
                    XCELclient.isStaffedOn(playerDetails.source, {}, function(staffedOn) 
                        if staffedOn then
                            XCELclient.staffMode(playerDetails.source, {false})
                        end
                    end)
                    TriggerClientEvent("XCEL:toggleInWager", playerDetails.source, true)
                    SetTimeout(4000, function()      
                        wagerCurrentlyIn[playerDetails.source] = ownerDetails.owner_id
                        local inTeam = ownerDetails.teamA.players[playerDetails.user_id] and "teamA" or "teamB"
                        TriggerClientEvent("XCEL:startWager", playerDetails.source, inTeam)
                        TriggerClientEvent('XCEL:smallAnnouncement', playerDetails.source, "~r~Round 1/" .. ownerDetails.bestOf, "", 2, 3000)
                        startDistCheck(playerDetails.source)
                        FreezeEntityPosition(GetPlayerPed(playerDetails.source), false)
                    end)
                end
                local i = 1
                for _, playerDetails in pairs(ownerDetails.teamA.players) do
                    preparePlayerForWager(playerDetails, ownerDetails.teamALoc[i])
                    i = i + 1
                end
                i = 1
                for _, playerDetails in pairs(ownerDetails.teamB.players) do
                    preparePlayerForWager(playerDetails, ownerDetails.teamBLoc[i])
                    i = i + 1
                end
                wagerTeam[user_id].inProgress = true
                TriggerClientEvent("XCEL:sendWagerData", -1, wagerTeam)
            else
                XCELclient.notify(source, {"~r~Not all players are close enough to start the wager!"})
            end
        else
            XCELclient.notify(source, {"~r~Not all players can afford the wager!"})
        end
    else
        XCELclient.notify(source, {"~r~Only the leader can start the wager!"})
    end
end)
 
function XCEL.inWager(source)
    local user_id = XCEL.getUserId(source)
    for _,details in pairs(wagerTeam) do
        if details.teamA.players[user_id] or details.teamB.players[user_id] then
            if details.inProgress then
                return true
            end
        end
    end
    return false
end

local function FinishWager(src, names, win, cancelled)
    local user_id = XCEL.getUserId(src)
    local ownerDetails = getOwnerDetails(wagerCurrentlyIn[src])
    XCEL.setBucket(src, 0)
    XCELclient.getWeapons(src,{true})
    if cancelled then
        XCELclient.notify(src, {"~r~Wager has been cancelled!"})
    elseif names ~= nil then
        TriggerClientEvent('XCEL:smallAnnouncement', src, win and "WAGER WON " or "WAGER LOST ", names.." has won the wager!", win and 33 or 6, 5000)
    end
    XCELclient.setPlayerCombatTimer(src, {0, false})
    XCELclient.removeAllWeapons(src,{})
    XCELclient.teleport(src, {cfg.wagerStartLoc.x,cfg.wagerStartLoc.y,cfg.wagerStartLoc.z})
    XCELclient.RevivePlayer(src, {})
    XCELclient.setArmour(src, {0})
    Wait(50)
    wagerCurrentlyIn[src] = nil
    if wagerTeam[user_id] then
       wagerTeam[user_id] = nil
    end
    TriggerClientEvent("XCEL:sendWagerData", -1, wagerTeam)
    TriggerClientEvent("XCEL:toggleInWager", src, false)
end

local function preparePlayerForDuel(playerDetails, teleportLocation, wagerOwner)
    local ownerDetails = getOwnerDetails(wagerOwner)
    if ownerDetails then
        XCELclient.RevivePlayer(playerDetails.source, {})
        XCELclient.teleport(playerDetails.source, teleportLocation)
        XCELclient.playAnim(playerDetails.source, {true, {{"mini@triathlon", "idle_d", 1}}, true})
        FreezeEntityPosition(GetPlayerPed(playerDetails.source), true)
        XCELclient.giveWeapons(playerDetails.source, {{[ownerDetails.wagerWeapon] = {ammo = 250}}, true})
        local armourValue = ownerDetails.armourValues and (ownerDetails.armourValues):gsub("%%", "") or 0
        XCELclient.setArmour(playerDetails.source, {tonumber(armourValue), true})
        XCELclient.showCountdownTimer(playerDetails.source, {3})
        SetTimeout(4000, function()      
            TriggerClientEvent("XCEL:toggleInWager", playerDetails.source, true)
            TriggerClientEvent('XCEL:startWager', playerDetails.source)
            TriggerClientEvent('XCEL:smallAnnouncement', playerDetails.source, "~r~Round " .. ownerDetails.currentRound + 1 .. "/" .. ownerDetails.bestOf, "", 2, 3000) 
            FreezeEntityPosition(GetPlayerPed(playerDetails.source), false)
        end)
    end
end

local function isTeamDead(players)
    for _, playerDetails in pairs(players) do
        if GetEntityHealth(GetPlayerPed(playerDetails.source)) > 102 then
            return false
        end
    end
    return true
end

local function GetPlayerNames(players)
    local names = {}
    for _, playerDetails in pairs(players) do
        table.insert(names, playerDetails.name)
    end
    return table.concat(names, " and ")
end

function XCEL.handleWagerDeath(civsource, killersource)
    local killerID = XCEL.getUserId(killersource)
    local ownerDetails = getOwnerDetails(wagerCurrentlyIn[civsource])
    if not ownerDetails then return end
    local teamADead, teamBDead = false, false
    teamADead = isTeamDead(ownerDetails.teamA.players)
    teamBDead = isTeamDead(ownerDetails.teamB.players)
    if teamBDead or teamADead then
        if teamADead then
            ownerDetails.teamB.wins = ownerDetails.teamB.wins + 1
        elseif teamBDead then
            ownerDetails.teamA.wins = ownerDetails.teamA.wins + 1
        end
        ownerDetails.currentRound = ownerDetails.currentRound + 1
        if ownerDetails then
            if ownerDetails.teamA.wins > ownerDetails.bestOf/2 or ownerDetails.teamB.wins > ownerDetails.bestOf/2 or tonumber(ownerDetails.currentRound) >= tonumber(ownerDetails.bestOf) then
                local winningTeam = ownerDetails.teamA.wins > ownerDetails.teamB.wins and ownerDetails.teamA.players or ownerDetails.teamB.players
                local losingTeam = ownerDetails.teamA.wins > ownerDetails.teamB.wins and ownerDetails.teamB.players or ownerDetails.teamA.players
                for _, playerDetails in pairs(winningTeam) do
                    FinishWager(playerDetails.source, GetPlayerNames(winningTeam), true)
                    XCELclient.notify(playerDetails.source, {"~g~Received £" .. getMoneyStringFormatted(ownerDetails.betAmount*2) .. " from the wager!"})
                    XCEL.giveBankMoney(playerDetails.user_id, tonumber(ownerDetails.betAmount*2))
                end
                for _, playerDetails in pairs(losingTeam) do
                    FinishWager(playerDetails.source, GetPlayerNames(winningTeam), false)
                end
                if ownerDetails.betAmount*2 >= 500000 then
                   TriggerClientEvent('chatMessage', -1, "^7XCEL Arena | " .. GetPlayerNames(winningTeam) .. " has WON £" .. getMoneyStringFormatted(ownerDetails.betAmount*2) .. " from a wager!", { 128, 128, 128 }, message, "green")
                end
            else
                local i = 1
                for _, playerDetails in pairs(ownerDetails.teamA.players) do
                    preparePlayerForDuel(playerDetails, {ownerDetails.teamALoc[i].x, ownerDetails.teamALoc[i].y, ownerDetails.teamALoc[i].z}, ownerDetails.owner_id)
                    i = i + 1
                end
                i = 1
                for _, playerDetails in pairs(ownerDetails.teamB.players) do
                    preparePlayerForDuel(playerDetails, {ownerDetails.teamBLoc[i].x, ownerDetails.teamBLoc[i].y, ownerDetails.teamBLoc[i].z}, ownerDetails.owner_id)
                    i = i + 1
                end
            end
        end
        TriggerClientEvent("XCEL:sendWagerData", -1, wagerTeam)
    end
end

RegisterServerEvent("XCEL:getWagerData", function()
    local source = source
    if wagerTeam then
        TriggerClientEvent("XCEL:sendWagerData", source, wagerTeam)
    end
end)

AddEventHandler("XCEL:playerLeave", function(user_id, source)
    local ownerDetails = getOwnerDetails(wagerCurrentlyIn[source])
    if ownerDetails then
        if ownerDetails.teamA.players[user_id] then
            ownerDetails.teamA.players[user_id] = nil
        end
        if ownerDetails.teamB.players[user_id] then
            ownerDetails.teamB.players[user_id] = nil
        end
        if ownerDetails.teamA.players then
            for _, playerDetails in pairs(ownerDetails.teamA.players) do
                FinishWager(playerDetails.source, nil, false, true)
            end
        end
        if ownerDetails.teamB.players then
            for _, playerDetails in pairs(ownerDetails.teamB.players) do
                FinishWager(playerDetails.source, nil, false, true)
            end
        end
    end
    if wagerTeam[user_id] then
        wagerTeam[user_id] = nil
    end
    TriggerClientEvent("XCEL:sendWagerData", -1, wagerTeam)
end)