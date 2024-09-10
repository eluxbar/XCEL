local a = GetGameTimer() - 30000
local b = {
    ["city"] = vector3(309.04260253906, -592.22509765625, 42.284008026123),
    ["vip"] = vector3(3542.5090332031, 2570.2302246094, 6.9896578788757),
    ["sandy"] = vector3(1833.0328369141, 3682.8110351563, 33.270057678223),
    ["paleto"] = vector3(-251.9546661377, 6334.146484375, 31.427177429199),
    ["london"] = vector3(355.45614624023, -1416.0190429688, 32.510429382324),
    ["VIPisland"] = vector3(-2056.68359375,-1031.7133789062,11.907557487488),
    ["mountzenah"] = vector3(-436.04296875, -326.27416992188, 33.910766601562)
}
Citizen.CreateThread(
    function()
        if true then
            local c = function(d)
                tXCEL.drawNativeNotification("Press ~INPUT_PICKUP~ to receive medical attention.")
            end
            local e = function(d)
            end
            local f = function(d)
                if IsControlJustPressed(1, 51) then
                    local g = tXCEL.getPlayerPed()
                    if not tXCEL.isInComa() then
                        if tXCEL.getPlayerVehicle() == 0 then
                            if tXCEL.getPlayerCombatTimer() == 0 then
                                if GetGameTimer() > a + 30000 then
                                    tXCEL.setHealth(200)
                                    tXCEL.notify("~g~Healed, free of charge by the NHS.")
                                    a = GetGameTimer()
                                else
                                    tXCEL.notify("~r~Healing cooldown, come back later.")
                                end
                            else
                                tXCEL.notify("~r~You can not heal whilst you have a combat timer.")
                            end
                        else
                            tXCEL.notify("~r~You can not heal whilst in a vehicle.")
                        end
                    else
                        tXCEL.notify("~r~You are bleeding out, call a doctor ASAP!")
                    end
                end
            end
            for h, i in pairs(b) do
                tXCEL.addMarker(i.x, i.y, i.z, 1.0, 1.0, 1.0, 0, 0, 255, 100, 50, 27, false, false, true)
                tXCEL.createArea(h .. "_hospital", i, 1.5, 6, c, e, f, {})
            end
        end
    end
)
local j = 0
function tXCEL.setHealth(k)
    if k ~= nil then
        if tXCEL.isPedScriptGuidChanging() and k < 200 then
            return
        end
        local l = math.floor(k)
        j = l
        SetEntityHealth(PlayerPedId(), l)
    end
end
function tXCEL.getHealth()
    return GetEntityHealth(PlayerPedId())
end
Citizen.CreateThread(
    function()
        Wait(60000)
        while true do
            if not spawning then
                if tXCEL.getHealth() > j then
                    if tXCEL.getHealth() - 2 == j then
                        return
                    end
                    tXCEL.setHealth(j)
                end
            end
            Wait(0)
        end
    end
)
