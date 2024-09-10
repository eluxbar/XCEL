local a = false
function DisplayHelpText(b)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(b)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end
function goParachuting()
    if not a then
        a = true
        CreateThread(
            function()
                XCEL.allowWeapon("GADGET_PARACHUTE")
                GiveWeaponToPed(PlayerPedId(), "GADGET_PARACHUTE")
                DoScreenFadeOut(3000)
                while not IsScreenFadedOut() do
                    Wait(0)
                end
                local c = GetEntityCoords(tXCEL.getPlayerPed())
                SetEntityCoords(tXCEL.getPlayerPed(), c.x, c.y, c.z + 1000.0)
                DoScreenFadeIn(2000)
                Wait(2000)
                SetPlayerInvincible(tXCEL.getPlayerPed(), true)
                SetEntityProofs(tXCEL.getPlayerPed(), true, true, true, true, true, false, 0, false)
                while true do
                    if a then
                        if
                            IsPedInParachuteFreeFall(tXCEL.getPlayerPed()) and
                                not HasEntityCollidedWithAnything(tXCEL.getPlayerPed())
                         then
                            ApplyForceToEntity(
                                tXCEL.getPlayerPed(),
                                true,
                                0.0,
                                200.0,
                                2.5,
                                0.0,
                                0.0,
                                0.0,
                                false,
                                true,
                                false,
                                false,
                                false,
                                true
                            )
                        else
                            a = false
                        end
                    else
                        break
                    end
                    Wait(0)
                end
                Wait(3000)
                SetPlayerInvincible(tXCEL.getPlayerPed(), false)
                SetEntityProofs(tXCEL.getPlayerPed(), false, false, false, false, false, false, 0, false)
            end
        )
    end
end
local d = {vector3(-2152.298828125,5235.2236328125,25.409055709839)}
AddEventHandler(
    "XCEL:onClientSpawn",
    function(e, f)
        if f then
            local g = function()
                drawNativeNotification("Press ~INPUT_PICKUP~ to go parachuting! (£5,000)")
            end
            local h = function()
            end
            local i = function()
                if IsControlJustPressed(1, 51) then
                    TriggerServerEvent("XCEL:takeAmount", 5000)
                    goParachuting()
                end
            end
            for j, k in pairs(d) do
                tXCEL.createArea("parachute_" .. j, k, 1.5, 6, g, h, i, {})
                tXCEL.addMarker(k.x, k.y, k.z, 1.0, 1.0, 1.0, 255, 0, 0, 4, 50, 40, false, false, true)
            end
        end
    end
)
