local a = module("cfg/cfg_purge")
local b = a.coords[a.location]
local function c()
    math.random()
    math.random()
    math.random()
    return b[math.random(1, #b)]
end
local d = false
function tXCEL.hasSpawnProtection()
    return d
end
local function e()
    d = true
    SetTimeout(
        10000,
        function()
            d = false
        end
    )
    Citizen.CreateThread(
        function()
            SetLocalPlayerAsGhost(true)
            while d do
                SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true)
                SetEntityAlpha(PlayerPedId(), 100, false)
                Wait(0)
            end
            SetEntityAlpha(PlayerPedId(), 255, false)
            SetLocalPlayerAsGhost(false)
            ResetGhostedEntityAlpha()
            tXCEL.notify("~g~Spawn protection ended!")
            SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
        end
    )
end
local f
RegisterNetEvent("XCEL:purgeSpawnClient")
AddEventHandler(
    "XCEL:purgeSpawnClient",
    function(g)
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
        e()
        DoScreenFadeOut(250)
        tXCEL.hideUI()
        SetBigmapActive(false)
        Wait(500)
        TriggerScreenblurFadeIn(100.0)
        f = c()
        RequestCollisionAtCoord(f.x, f.y, f.z)
        local h = GetGameTimer()
        while HaveAllStreamingRequestsCompleted(PlayerPedId()) ~= 1 and GetGameTimer() - h < 5000 do
            Wait(0)
          --  print("[XCEL] Waiting for streaming requests to complete!")
        end
        tXCEL.checkCustomization()
        TriggerServerEvent("XCEL:getPlayerHairstyle")
        TriggerServerEvent("XCEL:getPlayerTattoos")
        DoScreenFadeIn(1000)
        tXCEL.showUI()
        local i = tXCEL.getPlayerCoords()
        SetEntityCoordsNoOffset(PlayerPedId(), i.x, i.y, 1200.0, false, false, false)
        SetEntityVisible(PlayerPedId(), false, false)
        FreezeEntityPosition(PlayerPedId(), true)
        SetEntityVisible(PlayerPedId(), true, true)
        SetFocusPosAndVel(f.x, f.y, f.z + 1000, 0.0, 0.0, 0.0)
        spawnCam = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", f.x, f.y, f.z + 1000, 0.0, 0.0, 0.0, 65.0, 0, 2)
        SetCamActive(spawnCam, true)
        RenderScriptCams(true, true, 0, true, false)
        spawnCam2 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", f.x, f.y, f.z, 0.0, 0.0, 0.0, 65.0, 0, 2)
        SetCamActiveWithInterp(spawnCam2, spawnCam, 5000, 0, 0)
        Wait(2500)
        ClearFocus()
        if not g then
            SetEntityCoords(PlayerPedId(), f.x, f.y, f.z)
        end
        FreezeEntityPosition(PlayerPedId(), false)
        TriggerScreenblurFadeOut(2000.0)
        Wait(2000)
        DestroyCam(spawnCam, false)
        DestroyCam(spawnCam2, false)
        RenderScriptCams(false, true, 2000, 0, 0)
        tXCEL.setHealth(200)
        tXCEL.setArmour(200)
        TriggerServerEvent("XCEL:purgeClientHasSpawned")
    end
)
RegisterNetEvent("XCEL:purgeGetWeapon")
AddEventHandler(
    "XCEL:purgeGetWeapon",
    function()
        tXCEL.notify("~o~Random weapon received!")
        PlaySoundFrontend(-1, "Weapon_Upgrade", "DLC_GR_Weapon_Upgrade_Soundset", true)
    end
)
Citizen.CreateThread(
    function()
        if tXCEL.isPurge() then
            local j = AddBlipForRadius(0.0, 0.0, 0.0, 50000.0)
            SetBlipColour(j, 1)
            SetBlipAlpha(j, 180)
        end
    end
)

RegisterCommand("purge",function()
        if tXCEL.isPurge() then
            TriggerEvent("XCEL:purgeSpawnClient")
            local k = tXCEL.getPlayerCoords()
            tXCEL.notify("~g~Teleporting to airport... please wait.")
            Wait(5000)
            if k == tXCEL.getPlayerCoords() then
                tXCEL.teleport(-1113.495, -2917.377, 13.94363)
                tXCEL.notify("~g~Teleported to airport, use /suicide to return to the purge.")
            else
                tXCEL.notify("~r~Teleportation failed, please remain still when teleporting.")
            end
        end
    end
)
RegisterCommand("airport",function()
        if tXCEL.isPurge() then
            local k = tXCEL.getPlayerCoords()
            tXCEL.notify("~g~Teleporting to airport... please wait.")
            Wait(5000)
            if k == tXCEL.getPlayerCoords() then
                tXCEL.teleport(-1113.495, -2917.377, 13.94363)
                tXCEL.notify("~g~Teleported to airport, use /suicide to return to the purge.")
            else
                tXCEL.notify("~r~Teleportation failed, please remain still when teleporting.")
            end
        end
    end
)
