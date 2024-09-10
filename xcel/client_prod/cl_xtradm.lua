local counter = 0
RegisterNetEvent("Kerr:Arena:GotCounter",function(timer)
    counter = timer
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if counter > 0 then
            counter = counter - 1
        end
    end
end)

tXCEL.createThreadOnTick(function()
    if counter > 0 then
        drawNativeText("~b~" .. formatTimeString(formatTime(counter)) .. " remaining",255,0,0,255,true)
    end
end)