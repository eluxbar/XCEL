local ticketPrice = 50000
local potAmount = 0
local participantCount = 0
local personalAmountBought = 0

RMenu.Add("lottery","mainmenu",RageUI.CreateMenu("","Main Menu",tXCEL.getRageUIMenuWidth(),tXCEL.getRageUIMenuHeight(),"xcel_lotteryui","xcel_lotteryui"))

RageUI.CreateWhile(1.0, true, function()
        if RageUI.Visible(RMenu:Get("lottery","mainmenu")) then
            RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            RageUI.Separator("------------------")
            RageUI.Separator("Pot £" .. getMoneyStringFormatted(potAmount))
            if participantCount > 0 then
                RageUI.Separator(tostring(participantCount) .. " Participant" .. (participantCount > 1 and "s" or ""))
            else
                RageUI.Separator("No Participants")
            end
            if personalAmountBought > 0 then
                local ticketShare = math.floor(potAmount / ticketPrice)
                local ticketText = personalAmountBought > 1 and " tickets" or " ticket"
                RageUI.Separator("You have purchased " .. tostring(personalAmountBought) .. ticketText .. " (" .. tostring(math.floor(personalAmountBought / ticketShare * 100)) .. "%)")
            else
                RageUI.Separator("You haven't purchased any tickets")
            end
            RageUI.Separator("------------------")
            RageUI.Separator("~y~Drawn at 8:00PM UK Time")
            RageUI.Separator("~y~Tickets can be purchased at a convenience store")
        end)
    end
end)

RegisterNetEvent("XCEL:setLotteryInfo",function(newTicketPrice, newPotAmount, newParticipantCount)
    ticketPrice = newTicketPrice
    potAmount = newPotAmount
    participantCount = newParticipantCount
end)

RegisterNetEvent("XCEL:setPersonalAmountBought")
AddEventHandler("XCEL:setPersonalAmountBought", function(newPersonalAmountBought)
    personalAmountBought = newPersonalAmountBought
end)

RegisterCommand("lottery",function()
    RageUI.Visible(RMenu:Get("lottery", "mainmenu"), true)
    TriggerServerEvent("XCEL:getLotteryInfo")
end,false)

function tXCEL.getLotteryTicketPrice()
    return ticketPrice
end