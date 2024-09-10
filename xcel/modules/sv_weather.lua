voteCooldown = 1800
currentWeather = "EXCELSUNNY"

weatherVoterCooldown = voteCooldown

RegisterServerEvent("XCEL:vote") 
AddEventHandler("XCEL:vote", function(weatherType)
    TriggerClientEvent("XCEL:voteStateChange",-1,weatherType)
end)

RegisterServerEvent("XCEL:tryStartWeatherVote")
AddEventHandler("XCEL:tryStartWeatherVote", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    
    if weatherVoterCooldown >= voteCooldown then
        TriggerClientEvent("XCEL:startWeatherVote", -1)
        weatherVoterCooldown = 0
    else
        TriggerClientEvent("chatMessage", source, "Another vote can be started in " .. tostring(voteCooldown - weatherVoterCooldown) .. " seconds!", {255, 0, 0})
    end

    if XCEL.hasGroup(user_id,"eventmanager") or XCEL.hasGroup(user_id,"Developer") then
        TriggerClientEvent("XCEL:startWeatherVote", -1)
        weatherVoterCooldown = 0
    else
        XCELclient.notify(source, {'~r~You do not have permission for this.'})
    end
end)


RegisterServerEvent("XCEL:getCurrentWeather") 
AddEventHandler("XCEL:getCurrentWeather", function()
    local source = source
    TriggerClientEvent("XCEL:voteFinished",source,currentWeather)
end)

RegisterServerEvent("XCEL:setCurrentWeather")
AddEventHandler("XCEL:setCurrentWeather", function(newWeather)
	currentWeather = newWeather
end)

Citizen.CreateThread(function()
	while true do
		weatherVoterCooldown = weatherVoterCooldown + 1
		Citizen.Wait(1000)
	end
end)