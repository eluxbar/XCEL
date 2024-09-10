local over = true
local theString = ""
local theReward = 0

Citizen.CreateThread(function()
    while true do
        if over then
            over = false
            local Code = generateUUID("mini-event", 5, "alphanumeric")
          --  print("Generated string: " .. theString)
            theReward = math.random(10000, 50000) * 2
            theString = Code
            TriggerClientEvent('chatMessage', -1, "^2[Mini-Event]",  { 255, 255, 255 }, "Who writes the word: " .. theString .. " first gets £" .. getMoneyStringFormatted(theReward),  "ooc")
            SetTimeout(10000, function()
                if not over then
                    TriggerClientEvent('chatMessage', -1, "^2[Mini-Event]",  { 255, 255, 255 }, "Time is over, no one wrote the word!",  "ooc")
                    over = true
                    theReward = 0
                    theString = ""
                end
            end)
        end
        Citizen.Wait(1800000)
    end
end)

RegisterNetEvent('_chat:messageEntered')
AddEventHandler('_chat:messageEntered', function(author, color, text, msgType, modeName)
    local source = source
    --print("Text: " .. text, "String: " .. theString, "Over: " .. tostring(over), string.upper(text) == theString)
    if not over and string.upper(text) == theString then
        TriggerClientEvent('chatMessage', -1, "^2[Mini-Event]",  { 255, 255, 255 }, XCEL.GetPlayerName(XCEL.getUserId(source)) .. " wrote the word and won £" .. getMoneyStringFormatted(theReward),  "ooc")
        theReward = 0
        theString = "" 
        over = true
    end
end)