RegisterNetEvent("XTRA:requestPlayerBankMoney")
AddEventHandler("XTRA:requestPlayerBankMoney", function()
    local sourceId = source
    local player = GetPlayerFromId(sourceId)
    local bankMoney = GetPlayerBankMoney(player)
    
    TriggerClientEvent("XTRA:receivePlayerBankMoney", sourceId, bankMoney)
end)

RegisterNetEvent("XTRA:transferMoneyViaPermID")
AddEventHandler("XTRA:transferMoneyViaPermID", function(permId, moneyAmount)
    local sourceId = source
    local sender = GetPlayerFromId(sourceId)
    local receiver = GetPlayerFromId(permId)

    if not sender or not receiver then
        TriggerClientEvent('chat:addMessage', sourceId, { args = { "Monzo", "Invalid player ID." } })
        return
    end

    local senderMoney = GetPlayerBankMoney(sender)
    if senderMoney >= moneyAmount then
        RemovePlayerBankMoney(sender, moneyAmount)
        AddPlayerBankMoney(receiver, moneyAmount)
        TriggerClientEvent('chat:addMessage', sourceId, { args = { "Monzo", "Transfer successful!" } })
        TriggerClientEvent('chat:addMessage', permId, { args = { "Monzo", "You have received $" .. moneyAmount .. " from " .. GetPlayerName(sender) } })
    else
        TriggerClientEvent('chat:addMessage', sourceId, { args = { "Monzo", "Insufficient funds." } })
    end
end)

-- Example implementation for player data management
local players = {
    [1] = { name = "PlayerOne", bankMoney = 5000 },
    [2] = { name = "PlayerTwo", bankMoney = 3000 }
}

function GetPlayerFromId(id)
    return players[id]
end

function GetPlayerBankMoney(player)
    return player.bankMoney
end

function RemovePlayerBankMoney(player, amount)
    player.bankMoney = player.bankMoney - amount
end

function AddPlayerBankMoney(player, amount)
    player.bankMoney = player.bankMoney + amount
end

function GetPlayerName(player)
    return player.name
end