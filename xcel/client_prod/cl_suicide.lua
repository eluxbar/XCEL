local a = module("cfg/weapons")
local b = Citizen.Wait
local c = Citizen.CreateThread
local SetEntityHealth = SetEntityHealth
function KillYourself()
    c(
        function()
            local d = tXCEL.getPlayerPed()
            local e = false
            local f = nil
            for g, h in pairs(a.weapons) do
                if h.class == "Pistol" then
                    local i = GetHashKey(g)
                    if HasPedGotWeapon(d, i, false) then
                        if GetAmmoInPedWeapon(d, i) > 0 then
                            e = true
                            f = i
                            break
                        end
                    end
                end
            end
            if e then
                if not HasAnimDictLoaded("mp_suicide") then
                    RequestAnimDict("mp_suicide")
                    while not HasAnimDictLoaded("mp_suicide") do
                        b(1)
                    end
                end
                tXCEL.setWeapon(d, f, true)
                TaskPlayAnim(d, "mp_suicide", "pistol", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                RemoveAnimDict("mp_suicide")
                b(750)
                SetPedShootsAtCoord(d, 0.0, 0.0, 0.0, 0)
                tXCEL.setHealth(0)
            end
        end
    )
end
RegisterCommand(
    "suicide",
    function()
        if tXCEL.isPurge() then
            tXCEL.setHealth(0)
        else
            KillYourself()
        end
    end,
    false
)
