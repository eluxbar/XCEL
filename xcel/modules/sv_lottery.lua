local ticketPrice = 50000
local potAmount = 0
local participantCount = 0
local personalAmountBought = {}
local participants = {}

RegisterServerEvent('XCEL:getLotteryInfo')
AddEventHandler('XCEL:getLotteryInfo', function()
    local source = source
    TriggerClientEvent('XCEL:setLotteryInfo', source, ticketPrice, potAmount, participantCount)
end)

RegisterServerEvent('XCEL:setPersonalAmountBought')
AddEventHandler('XCEL:setPersonalAmountBought', function(user_id, amount)
    local amount = tonumber(amount)
    local ticketPrice = 50000
    if user_id then
        if not participants[user_id] then
            participantCount = participantCount + 1
        end
        participants[user_id] = true
        potAmount = potAmount + ticketPrice * amount
        personalAmountBought[user_id] = (personalAmountBought[user_id] or amount) + amount
        updateLotteryInfo(ticketPrice, potAmount, participantCount)
        TriggerClientEvent('XCEL:setPersonalAmountBought', XCEL.getUserSource(user_id), personalAmountBought[user_id])
    end
end)

function updateLotteryInfo(newTicketPrice, newPotAmount, newParticipantCount)
    ticketPrice = newTicketPrice
    potAmount = newPotAmount
    participantCount = newParticipantCount
    TriggerClientEvent('XCEL:setLotteryInfo', -1, ticketPrice, potAmount, participantCount)
end

function updatePersonalAmountBought(playerId, amount)
    personalAmountBought[playerId] = amount
    TriggerClientEvent('XCEL:setPersonalAmountBought', playerId, personalAmountBought[playerId])
end

AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if not personalAmountBought[user_id] then
            personalAmountBought[user_id] = 0
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(6000)
        local hour = os.date("%H")

        if hour == "12" then
            if #participants > 0 then
                local winner
                repeat
                    winner = math.random(#participants)
                until XCEL.getUserSource(winner)
            
                XCEL.notify(XCEL.getUserSource(winner), "~g~You have won the lottery! £" .. getMoneyStringFormatted(potAmount) .. "!")
                TriggerClientEvent('XCEL:setPersonalAmountBought', XCEL.getUserSource(winner), 0)
            end
            ticketPrice = 0
            potAmount = 0
            participantCount = 0
            personalAmountBought = {}
            participants = {}
            updateLotteryInfo(ticketPrice, potAmount, participantCount)
        end
    end
end)