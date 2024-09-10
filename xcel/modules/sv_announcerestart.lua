RegisterCommand('restartserver', function(source, args)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasGroup(user_id, 'Founder') or XCEL.hasGroup(user_id, 'Lead Developer') or XCEL.hasGroup(user_id,"Developer") or source == '' then
        if args[1] ~= nil then
            timeLeft = args[1]
            local shutdownTime = timeLeft - 10
            print(shutdownTime)
            TriggerClientEvent('XCEL:announceRestart', -1, tonumber(timeLeft), false)
            Online = false
            TriggerEvent('XCEL:restartTime', timeLeft)
            TriggerClientEvent('XCEL:CloseToRestart', -1)
        end
    end
end)
RegisterCommand('consolerestart', function(source, args)
    local source = source
    if source == 0 then
        timeLeft = args[1]
        local shutdownTime = timeLeft - 10
        print('Restarting in ' .. timeLeft .. ' seconds.')
        TriggerClientEvent('XCEL:announceRestart', -1, tonumber(timeLeft), false)
        Online = false
        TriggerEvent('XCEL:restartTime', timeLeft)
        Wait(10000)
        TriggerClientEvent('XCEL:CloseToRestart', -1)
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t") -- 0-23 (24 hour format)
        local hour = tonumber(time["hour"])
        if hour == 10 then
            if tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then
                TriggerClientEvent('XCEL:announceRestart', -1, 60, true)
                TriggerEvent('XCEL:restartTime', 60)
                TriggerClientEvent('XCEL:CloseToRestart', -1)
                Online = false
            end
            if os.date('%A') == 'Monday' then
                exports['xcel']:executeSync("UPDATE xcel_staff_tickets SET weekly_tickets = 0")
            end
        end
    end
end)

RegisterServerEvent("XCEL:restartTime")
AddEventHandler("XCEL:restartTime", function(time)
    time = tonumber(time)
    if source ~= '' then return end
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            time = time - 1
            if time == 0 then
                for k,v in pairs(XCEL.getUsers({})) do
                    DropPlayer(v, "Server restarting, please join back in a few minutes.")
                end
                os.exit()
            end
        end
    end)
end)
