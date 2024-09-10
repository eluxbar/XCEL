local function a()
    local b = tXCEL.getPlayerPed()
    if GetEntityHealth(b) > 102 then
        local c, d = tXCEL.getNearestOwnedVehicle(8)
        if d ~= nil then
            if c then
                tXCEL.vc_toggleLock(d)
                tXCEL.playSound("HUD_MINI_GAME_SOUNDSET", "5_SEC_WARNING")
                Citizen.Wait(1000)
            else
                Citizen.Wait(1000)
            end
        else
            tXCEL.notify("No owned vehicle found nearby to lock/unlock")
        end
    else
        tXCEL.notify("You may not lock/unlock your vehicle whilst dead.")
    end
end
Citizen.CreateThread(
    function()
        while true do
            if IsDisabledControlPressed(0, 82) then
                a()
            end
            Wait(0)
        end
    end
)
AddEventHandler(
    "XCEL:lockNearestVehicle",
    function()
        a()
    end
)
