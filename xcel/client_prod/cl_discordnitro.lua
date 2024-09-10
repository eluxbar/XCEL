local a = GetGameTimer()
RegisterNetEvent(
    "XCEL:spawnNitroBMX",
    function()
        if not tXCEL.isInComa() and not tXCEL.isHandcuffed() and not insideDiamondCasino then
            if GetTimeDifference(GetGameTimer(), a) > 10000 then
                a = GetGameTimer()
                tXCEL.notify("~g~Crafting a BMX")
                local b = tXCEL.getPlayerPed()
                TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
                Wait(5000)
                ClearPedTasksImmediately(b)
                local c = GetEntityCoords(b)
                XCEL.spawnVehicle("bmx", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
            else
                tXCEL.notify("~r~Nitro BMX cooldown, please wait.")
            end
        else
            tXCEL.notify("~r~Cannot craft a BMX right now.")
        end
    end
)
RegisterNetEvent(
    "XCEL:spawnMoped",
    function()
        if not tXCEL.isInComa() and not tXCEL.isHandcuffed() and not insideDiamondCasino then
            if GetTimeDifference(GetGameTimer(), a) > 10000 then
                a = GetGameTimer()
                tXCEL.notify("~g~Crafting a Moped")
                local b = tXCEL.getPlayerPed()
                TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
                Wait(5000)
                ClearPedTasksImmediately(b)
                local c = GetEntityCoords(b)
                XCEL.spawnVehicle("faggio", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
            else
                tXCEL.notify("~r~Nitro BMX cooldown, please wait.")
            end
        else
            tXCEL.notify("~r~Cannot craft a Moped right now.")
        end
    end
)
