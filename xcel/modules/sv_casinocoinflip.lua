local coinflipTables = {
    [1] = false,
    [2] = false,
    [5] = false,
    [6] = false,
}

local linkedTables = {
    [1] = 2,
    [2] = 1,
    [5] = 6,
    [6] = 5,
}

local coinflipGameInProgress = {}
local coinflipGameData = {}

local betId = 0

function giveChips(source,amount)
    local user_id = XCEL.getUserId(source)
    MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
    TriggerClientEvent('XCEL:chipsUpdated', source)
end

AddEventHandler('playerDropped', function (reason)
    local source = source
    for k,v in pairs(coinflipTables) do
        if v == source then
            coinflipTables[k] = false
            coinflipGameData[k] = nil
        end
    end
end)

RegisterNetEvent("XCEL:requestCoinflipTableData")
AddEventHandler("XCEL:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("XCEL:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("XCEL:requestSitAtCoinflipTable")
AddEventHandler("XCEL:requestSitAtCoinflipTable", function(chairId)
    local source = source
    if source ~= nil then
        for k,v in pairs(coinflipTables) do
            if v == source then
                coinflipTables[k] = false
                return
            end
        end
        coinflipTables[chairId] = source
        local currentBetForThatTable = coinflipGameData[chairId]
        TriggerClientEvent("XCEL:sendCoinflipTableData",-1,coinflipTables)
        TriggerClientEvent("XCEL:sitAtCoinflipTable",source,chairId,currentBetForThatTable)
    end
end)

RegisterNetEvent("XCEL:leaveCoinflipTable")
AddEventHandler("XCEL:leaveCoinflipTable", function(chairId)
    local source = source
    if source ~= nil then 
        for k,v in pairs(coinflipTables) do 
            if v == source then 
                coinflipTables[k] = false
                coinflipGameData[k] = nil
            end
        end
        TriggerClientEvent("XCEL:sendCoinflipTableData",-1,coinflipTables)
    end
end)

RegisterNetEvent("XCEL:proposeCoinflip")
AddEventHandler("XCEL:proposeCoinflip",function(betAmount)
    local source = source
    local user_id = XCEL.getUserId(source)
    betId = betId+1
    if betAmount ~= nil then 
        if coinflipGameData[betId] == nil then
            coinflipGameData[betId] = {}
        end
        if not coinflipGameInProgress[betId] then
            if tonumber(betAmount) then
                betAmount = tonumber(betAmount)
                if betAmount >= 100000 then
                    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
                        chips = rows[1].chips
                        if chips >= betAmount then
                            TriggerClientEvent('XCEL:chipsUpdated', source)
                            if coinflipGameData[betId][source] == nil then
                                coinflipGameData[betId][source] = {}
                            end
                            coinflipGameData[betId] = {betId = betId, betAmount = betAmount, user_id = user_id}
                            for k,v in pairs(coinflipTables) do
                                if v == source then
                                    TriggerClientEvent('XCEL:addCoinflipProposal', source, betId, {betId = betId, betAmount = betAmount, user_id = user_id})
                                    if coinflipTables[linkedTables[k]] then
                                        TriggerClientEvent('XCEL:addCoinflipProposal', coinflipTables[linkedTables[k]], betId, {betId = betId, betAmount = betAmount, user_id = user_id})
                                    end
                                end
                            end
                            XCELclient.notify(source,{"~g~Bet placed: " .. getMoneyStringFormatted(betAmount) .. " chips."})
                        else 
                            XCELclient.notify(source,{"~r~Not enough chips!"})
                        end
                    end)
                else
                    XCELclient.notify(source,{'~r~Minimum bet at this table is £100,000.'})
                    return
                end
            end
        end
    else
       XCELclient.notify(source,{"~r~Error betting!"})
    end
end)

RegisterNetEvent("XCEL:requestCoinflipTableData")
AddEventHandler("XCEL:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("XCEL:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("XCEL:cancelCoinflip")
AddEventHandler("XCEL:cancelCoinflip", function()   
    local source = source
    local user_id = XCEL.getUserId(source)
    for k,v in pairs(coinflipGameData) do
        if v.user_id == user_id then
            coinflipGameData[k] = nil
            TriggerClientEvent("XCEL:cancelCoinflipBet",-1,k)
        end
    end
end)

RegisterNetEvent("XCEL:acceptCoinflip")
AddEventHandler("XCEL:acceptCoinflip", function(gameid)   
    local source = source
    local user_id = XCEL.getUserId(source)
    for k,v in pairs(coinflipGameData) do
        if v.betId == gameid then
            MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
                chips = rows[1].chips
                if chips >= v.betAmount then
                    MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = v.betAmount})
                    TriggerClientEvent('XCEL:chipsUpdated', source)
                    MySQL.execute("casinochips/remove_chips", {user_id = v.user_id, amount = v.betAmount})
                    TriggerClientEvent('XCEL:chipsUpdated', XCEL.getUserSource(v.user_id))
                    local coinFlipOutcome = math.random(0,1)
                    if coinFlipOutcome == 0 then
                        local game = {amount = v.betAmount, winner = XCEL.GetPlayerName(user_id), loser = XCEL.GetPlayerName(XCEL.getUserSource(v.user_id))}
                        TriggerClientEvent('XCEL:coinflipOutcome', source, true, game)
                        TriggerClientEvent('XCEL:coinflipOutcome', XCEL.getUserSource(v.user_id), false, game)
                        Wait(10000)
                        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = v.betAmount*2})
                        TriggerClientEvent('XCEL:chipsUpdated', source)
                        if v.betAmount > 10000000 then
                            TriggerClientEvent('chatMessage', -1, "^7Coin Flip |", { 124, 252, 0 }, ""..XCEL.GetPlayerName(user_id).." has WON a coin flip against "..XCEL.GetPlayerName(XCEL.getUserSource(v.user_id)).." for "..getMoneyStringFormatted(v.betAmount).." chips!")
                        end
                        XCEL.sendWebhook('coinflip-bet',"XCEL Coinflip Logs", "> Winner Name: **"..XCEL.GetPlayerName(user_id).."**\n> Winner TempID: **"..source.."**\n> Winner PermID: **"..user_id.."**\n> Loser Name: **"..XCEL.GetPlayerName(XCEL.getUserSource(v.user_id)).."**\n> Loser TempID: **"..XCEL.getUserSource(v.user_id).."**\n> Loser PermID: **"..v.user_id.."**\n> Amount: **"..getMoneyStringFormatted(v.betAmount).."**")
                    else
                        local game = {amount = v.betAmount, winner = XCEL.GetPlayerName(XCEL.getUserSource(v.user_id)), loser = XCEL.GetPlayerName(user_id)}
                        TriggerClientEvent('XCEL:coinflipOutcome', source, false, game)
                        TriggerClientEvent('XCEL:coinflipOutcome', XCEL.getUserSource(v.user_id), true, game)
                        Wait(10000)
                        MySQL.execute("casinochips/add_chips", {user_id = v.user_id, amount = v.betAmount*2})
                        TriggerClientEvent('XCEL:chipsUpdated', XCEL.getUserSource(v.user_id))
                        if v.betAmount > 10000000 then
                            TriggerClientEvent('chatMessage', -1, "^7Coin Flip |", { 124, 252, 0 }, ""..XCEL.GetPlayerName(user_id).." has WON a coin flip against "..XCEL.GetPlayerName(XCEL.getUserSource(v.user_id)).." for "..getMoneyStringFormatted(v.betAmount).." chips!")
                        end
                        XCEL.sendWebhook('coinflip-bet',"XCEL Coinflip Logs", "> Winner Name: **"..XCEL.GetPlayerName(XCEL.getUserSource(v.user_id)).."**\n> Winner TempID: **"..XCEL.getUserSource(v.user_id).."**\n> Winner PermID: **"..v.user_id.."**\n> Loser Name: **"..XCEL.GetPlayerName(user_id).."**\n> Loser TempID: **"..source.."**\n> Loser PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(v.betAmount).."**")
                    end
                else 
                    XCELclient.notify(source,{"~r~Not enough chips!"})
                end
            end)
        end
    end
end)

RegisterCommand('tables', function(source)
    print(json.encode(coinflipTables))
end)