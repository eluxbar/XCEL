local a = false
RegisterCommand(
    "flipcar",
    function()
        local b, c = tXCEL.getPlayerVehicle()
        if b == 0 then
            tXCEL.notify("You are not in a vehicle")
            return
        end
        if not c then
            tXCEL.notify("You are not the driver of this vehicle")
            return
        end
        if GetIsVehicleEngineRunning(b) then
            tXCEL.notify("You must have the engine off to flip the vehicle")
            return
        end
        if IsVehicleOnAllWheels(b) then
            tXCEL.notify("Your vehicle does not require flipping")
            return
        end
        if a then
            tXCEL.notify("Your vehicle is already waiting to be flipped")
            return
        end
        a = true
        tXCEL.notify("Flipping your vehicle in 30 seconds. Please remain stationary")
        local d = tXCEL.getPlayerPed()
        local e = GetEntityHealth(d)
        local f = GetGameTimer()
        while GetGameTimer() - f < 10000 do
            if tXCEL.getPlayerVehicle() ~= b then
                tXCEL.notify("Cancelling flip as you left the vehicle")
                a = false
                return
            end
            if GetEntityHealth(d) ~= e then
                tXCEL.notify("Cancelling flip as you recieved damage")
                a = false
                return
            end
            if GetEntitySpeed(b) >= 4.4704 then
                tXCEL.notify("Cancelling flip as you are not stationary")
                a = false
                return
            end
            if GetIsVehicleEngineRunning(b) then
                tXCEL.notify("Cancelling flip as you turned the engine on")
                a = false
                return
            end
            Citizen.Wait(0)
        end
        SetVehicleOnGroundProperly(b)
        tXCEL.notify("Your vehicle has been flipped")
        a = false
    end
)
