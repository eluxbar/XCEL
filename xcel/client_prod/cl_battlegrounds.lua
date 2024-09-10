local cfg = module("cfg/cfg_battleroyale")
local inplane = false
local locationID
local D = false
local function Reset()
    return {
        gas = {radius = 0.0,coords = vector3(0,0,0),isActive = false,blip = 0,timeUntilNext = {minutes = 1,seconds = 0}},
        data = {plane = 0, lootBoxes = {}, armourPlates = {},vehiclelocations = {}, timer = 15,leaderboard = {}},
        player = {canExitPlane = false, isInWinnerScreen = false, hasJumped = false},
        players = {}
    }
end
local currentroyale = Reset()

function DoAnim()
    local I = GetGameTimer()
    tXCEL.loadAnimDict("anim@gangops@facility@servers@bodysearch@")
    local Ped = PlayerPedId()
    local PedCoords = GetEntityCoords(Ped, true)
    local Rotation = GetEntityRotation(Ped, 2)
    local D = true
    TaskPlayAnimAdvanced(Ped,"anim@gangops@facility@servers@bodysearch@","player_search",PedCoords.x,PedCoords.y,PedCoords.z,Rotation.x,Rotation.y,Rotation.z,8.0,-8.0,-1,524288,512,0,false,false)
    RemoveAnimDict("anim@gangops@facility@servers@bodysearch@")
    while D do
        if not IsEntityPlayingAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search", 3) then
            D = false
            ClearPedTasks(Ped)
            ForcePedAiAndAnimationUpdate(Ped, false, false)
            SetEntityCoordsNoOffset(Ped, PedCoords.x, PedCoords.y, PedCoords.z + 0.1, true, false, false)
            return
        elseif GetGameTimer() - I >= 3000 then
            break
        end
        Citizen.Wait(0)
    end
    ClearPedTasks(Ped)
    ForcePedAiAndAnimationUpdate(Ped, false, false)
    SetEntityCoordsNoOffset(Ped, PedCoords.x, PedCoords.y, PedCoords.z + 0.1, true, false, false)
    D = false
end

function XCEL.startGas(M, F)
    currentroyale.gas.coords = F
    currentroyale.gas.radius = M
    currentroyale.gas.blip = AddBlipForRadius(F.x, F.y, F.z, M / 2.0)
    SetBlipColour(currentroyale.gas.blip, 1)
    SetBlipAlpha(currentroyale.gas.blip, 155)
    currentroyale.gas.isActive = not currentroyale.gas.isActive
end

function XCEL.changeGasRadius(M)
    SendNUIMessage({transactionType = "br-gas"})
    currentroyale.gas.timeUntilNext = {minutes = 1, seconds = 0}
    tXCEL.announceMpSmallMsg("GAS MOVING", "The gas is closing in!",6,5000)
    Wait(4000)
    Citizen.CreateThread(function()
        while currentroyale.gas.isActive and currentroyale.gas.radius > tonumber(M) and CurrentEvent.isActive do
            currentroyale.gas.radius = currentroyale.gas.radius - currentroyale.gas.radius * 0.008 * GetFrameTime()
            RemoveBlip(currentroyale.gas.blip)
            currentroyale.gas.blip = AddBlipForRadius(currentroyale.gas.coords.x, currentroyale.gas.coords.y, currentroyale.gas.coords.z, currentroyale.gas.radius / 2.0)
            SetBlipColour(currentroyale.gas.blip, 1)
            SetBlipAlpha(currentroyale.gas.blip, 155)
            Wait(0)
        end
    end)
end

function tXCEL.ClearWeapons()
    RemoveAllPedWeapons(PlayerPedId())
end

function XCEL.GiveWeaponToPed(weaponHash, ammoCount, isHidden, equipNow)
    if not HasPedGotWeapon(Ped, weaponHash, false) then
        GiveWeaponToPed(PlayerPedId(), weaponHash, ammoCount, isHidden, equipNow)
    elseif HasPedGotWeapon(Ped, weaponHash, false) then
        SetPedAmmo(Ped, weaponHash, ammoCount)
        tXCEL.notify("~g~You already have this weapon refilling ammo!")
    end
end

RegisterNetEvent("XCEL:startBattlegrounds",function(I)
    local Ped = PlayerPedId()
    locationID = I
    XCEL.startGas(cfg.locations[locationID].gas.initalRadius, cfg.locations[locationID].gas.centre)
    DoScreenFadeOut(1500)
    Wait(1500)
    CurrentEvent.eventName = "Battle Royale"
    TriggerEvent("chat:clear")
    tXCEL.stopEventSequence(true)
    tXCEL.ClearWeapons()
    XCEL.GiveWeaponToPed("GADGET_PARACHUTE", 2, false, false)
    tXCEL.giveWeapons({["GADGET_PARACHUTE"] = {2}},false,decorpasskey)
    SetPlayerHasReserveParachute(PlayerId())
    SetEntityCoords(Ped, cfg.locations[locationID].planeStart)
    tXCEL.loadModel("titan")
    ExecuteCommand("hideui")
    for o, p in pairs(GetActivePlayers()) do
        if p ~= PlayerId() then
            NetworkConcealPlayer(p, true, 0)
            SetEntityVisible(GetPlayerPed(p), false, false)
        end
    end
    local J = XCEL.spawnVehicle("titan", cfg.locations[locationID].planeStart, cfg.locations[locationID].planeHeading, false, false, true)
    SetModelAsNoLongerNeeded("titan")
    SetEntityCollision(J, false, true)
    SetVehicleEngineOn(J, true, true, false)
    SetPlaneTurbulenceMultiplier(J, 0.0)
    tXCEL.loadModel("s_m_m_pilot_02")
    local K = CreatePedInsideVehicle(J, 1, "s_m_m_pilot_02", -1, false, true)
    SetModelAsNoLongerNeeded("s_m_m_pilot_02")
    Wait(500)
    SetPedIntoVehicle(Ped, J, -2)
    SetPedKeepTask(K, true)
    ActivatePhysics(J)
    SetVehicleEngineHealth(J, 1000.0)
    SetVehicleBodyHealth(J, 1000.0)
    SetVehicleDeformationFixed(J)
    SetVehicleForwardSpeed(J, 60.0)
    SetHeliBladesFullSpeed(J)
    SetVehicleEngineOn(J, true, true, false)
    ControlLandingGear(J, 3)
    OpenBombBayDoors(J)
    SetEntityProofs(J, true, true, true, true, true, true, true, true)
    SetEntityInvincible(J, true)
    TaskVehicleDriveToCoord(K,J,cfg.locations[locationID].planeEnd + vector3(0.0, 0.0, 500.0),60.0,0,"titan",262144,15.0,-1.0,0.0,0.0)
    SetEntityVisible(Ped, false, false)
    currentroyale.data.plane = J
    inplane = not inplane
    Wait(4000)
    DoScreenFadeIn(4000)
    Citizen.CreateThread(function()
        while not currentroyale.player.canExitPlane and CurrentEvent.isActive do
            currentroyale.data.timer = currentroyale.data.timer - 1
            Wait(1000)
        end
    end)
    SetTimeout(15000,function()
        if CurrentEvent.isActive then
            currentroyale.player.canExitPlane = true
            setCursor(1)
            inGUI = not inGUI
            SetTimeout(45000,function()
                local L = tXCEL.getPlayerVehicle()
                if CurrentEvent.isActive and currentroyale.data.plane == L then
                    ApplyDamageToPed(Ped, 1000, false)
                end
            end)
        end
    end)
end)

RegisterNetEvent("XCEL:BattleGrounds:Cleanup",function()
    CurrentEvent.isActive = false
    for A,B in pairs(currentroyale.data.lootBoxes) do
        tXCEL.removeArea(B.areaId)
        tXCEL.removeNamedBlip(B.areaId)
        if DoesEntityExist(B.entity) then
            DeleteEntity(B.entity)
        end
    end
    for A,B in pairs(currentroyale.data.armourPlates) do
        tXCEL.removeArea(B.areaId)
        tXCEL.removeNamedBlip(B.areaId)
        if DoesEntityExist(B.entity) then
            DeleteEntity(B.entity)
        end
    end
    -- for A,B in pairs(currentroyale.data.vehiclelocations) do
    --     if DoesEntityExist(B.entity) then
    --         DeleteEntity(B.entity)
    --     end
    -- end
    RemoveBlip(currentroyale.gas.blip)
    inGUI = false
    inplane = false
    setCursor(0)
    currentroyale = Reset()
end)

RegisterNetEvent("XCEL:Battlegrounds:Podium",function(winners,losers)
   -- print("[XCEL] Battlegrounds Winners:" ..json.encode(winners))
   -- print("[XCEL] Battlegrounds Losers:".. json.encode(losers))
    local quickExit = false
    if not winners then
        SetEntityCoords(PlayerPedId(), vector3(226.35165405273,-1043.4857177734,29.364135742188))
        quickExit = true
    end
    if not quickExit then
        DoScreenFadeOut(1000)
        Wait(2000)
    end
    if not quickExit then
        DoScreenFadeIn(1000)
        if winners and losers then
            XCEL.podiumLeaderboard(winners, losers)--, currentEmotes)
        end
    end
end)

RegisterNetEvent("XCEL:syncLootboxesTable",function(u)
    currentroyale.data.lootBoxes = table.copy(cfg.lootBoxes[u])
    currentroyale.data.armourPlates = table.copy(cfg.armourPlates[u])
    -- currentroyale.data.vehiclelocations = table.copy(cfg.vehiclelocations[u])
    tXCEL.loadModel("prop_box_ammo03a")
    for v, w in pairs(currentroyale.data.lootBoxes) do
        if #(w.coords - currentroyale.gas.coords) < currentroyale.gas.radius / 2 then
            currentroyale.data.lootBoxes[v].areaId = "XCELbr_lootbox_" .. v
            tXCEL.setNamedBlip("XCELbr_lootbox_" .. v, w.coords.x, w.coords.y, w.coords.z, 478, 1, "Lootbox", 0.5)
            local x = function(y)
                if currentroyale.data.lootBoxes[y.box] then
                    if currentroyale.data.lootBoxes[y.box].entity == nil then
                        currentroyale.data.lootBoxes[y.box].entity = CreateObject("prop_box_ammo03a", w.coords, false, false, false, false, false)
                        SetEntityHeading(currentroyale.data.lootBoxes[y.box].entity, 10.0)
                        PlaceObjectOnGroundProperly(currentroyale.data.lootBoxes[y.box].entity)
                        FreezeEntityPosition(currentroyale.data.lootBoxes[y.box].entity, true)
                    end
                else
                    print(string.format("[XCEL] lootbox with ID: %s is nil", y.box))
                end
            end
            local z = function(y)
                if currentroyale.data.lootBoxes[y.box] then
                    if currentroyale.data.lootBoxes[y.box].entity then
                        if DoesEntityExist(currentroyale.data.lootBoxes[y.box].entity) then
                            DeleteEntity(currentroyale.data.lootBoxes[y.box].entity)
                            currentroyale.data.lootBoxes[v].entity = nil
                        end
                    end
                end
            end
            local A = function(y)
                if currentroyale.data.lootBoxes[y.box] then
                    if y.distance <= 1.5 then
                        local F = currentroyale.data.lootBoxes[y.box].coords
                        tXCEL.DrawText3D(vector3(F.x, F.y, F.z - 0.5), "Press [E] to pickup lootbox.", 0.2)
                        if IsControlJustPressed(0, 51) then
                            if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
                                tXCEL.notify("~r~You cannot pickup a lootbox while in a vehicle.")
                                return
                            end
                            DoAnim()
                            Wait(500)
                            TriggerServerEvent("XCEL:LootBox", y.box)
                        end
                    end
                end
            end
            tXCEL.createArea("XCELbr_lootbox_" .. v, w.coords, 200.0, 6, x, z, A, {box = v})
        end
    end
    SetModelAsNoLongerNeeded("prop_box_ammo03a")
    tXCEL.loadModel("prop_armour_pickup")
    for v, w in pairs(currentroyale.data.armourPlates) do
        if #(w.coords - currentroyale.gas.coords) < currentroyale.gas.radius / 2 then
            tXCEL.setNamedBlip("XCELbr_armour_" .. v, w.coords.x, w.coords.y, w.coords.z, 175, 1, "Lootbox", 0.5)
            local B = function(C)
                if currentroyale.data.armourPlates[C.plateId] then
                    if currentroyale.data.armourPlates[C.plateId].entity == nil then
                        currentroyale.data.armourPlates[C.plateId].entity = CreateObject("prop_armour_pickup", w.coords, false, false, false, false, false)
                        SetEntityHeading(currentroyale.data.armourPlates[C.plateId].entity, 10.0)
                        PlaceObjectOnGroundProperly(currentroyale.data.armourPlates[C.plateId].entity)
                        FreezeEntityPosition(currentroyale.data.armourPlates[C.plateId].entity, true)
                    end
                else
                    print(string.format("[XCEL Events] body armour with ID of %s is nil in table (onEnter)", C.plateId))
                end
            end
            local D = function(C)
                if currentroyale.data.armourPlates[C.plateId] then
                    if currentroyale.data.armourPlates[C.plateId].entity then
                        if DoesEntityExist(currentroyale.data.armourPlates[C.plateId].entity) then
                            DeleteEntity(currentroyale.data.armourPlates[C.plateId].entity)
                            currentroyale.data.armourPlates[C.plateId].entity = nil
                        end
                    end
                else
                    print(string.format("[XCEL Events] body armour with ID of %s is nil in table (onLeave)", C.plateId))
                end
            end
            local E = function(C)
                if currentroyale.data.armourPlates[C.plateId] then
                    if C.distance <= 1.5 then
                        local F = currentroyale.data.armourPlates[C.plateId].coords
                        tXCEL.DrawText3D(vector3(F.x, F.y, F.z - 0.5), "Press [E] to pickup armour.", 0.2)
                        if IsControlJustPressed(0, 51) then
                            if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
                                tXCEL.notify("~r~You cannot pickup a armour plate while in a vehicle.")
                                return
                            end
                            if GetPedArmour(PlayerPedId()) < 100 then
                                local soundId=GetSoundId()
                                PlaySoundFrontend(soundId,"Armour_On","DLC_GR_Steal_Miniguns_Sounds",true)
                                ReleaseSoundId(soundId)
                                TriggerServerEvent("XCEL:removeArmourPlate", C.plateId)
                                SetPedComponentVariation(PlayerPedId(), 9, 15, 2, 0)
                            else
                                tXCEL.notify("~r~You already have full armour.")
                            end
                        end
                    end
                end
            end
            tXCEL.createArea("XCELbr_armour_" .. v, w.coords, 200.0, 6, B, D, E, {plateId = v})
            currentroyale.data.armourPlates[v].areaId = "XCELbr_armour_" .. v
        end
    end
    SetModelAsNoLongerNeeded("prop_armour_pickup")
    local vehicle = tXCEL.loadModel("sovereign")
    for _,location in pairs(currentroyale.data.vehiclelocations) do
        if #(location.coords - currentroyale.gas.coords) < currentroyale.gas.radius / 2 then
            local veh = XCEL.spawnVehicle("sovereign", location.coords, 0, false, false, false)
            local blip = AddBlipForEntity(veh)
            SetVehicleOnGroundProperly(veh)
            SetEntityInvincible(veh, false)
            SetVehicleModKit(veh, 0)
            SetVehicleMod(veh, 11, 2, false)
            SetVehicleMod(veh, 13, 2, false)
            SetVehicleMod(veh, 12, 2, false)
            SetVehicleMod(veh, 15, 3, false)
            ToggleVehicleMod(veh, 18, true)
            SetBlipSprite(blip, 226)
            SetBlipColour(blip, 1)
            SetBlipScale(blip, 0.8)
            SetBlipDisplay(blip, 4)
        end
    end
    SetModelAsNoLongerNeeded("sovereign")
end)

RegisterNetEvent("XCEL:removeLootBox",function(G)
    tXCEL.removeArea("XCELbr_lootbox_" .. G)
    tXCEL.removeNamedBlip("XCELbr_lootbox_" .. G)
    if currentroyale.data.lootBoxes[G].entity then
        if DoesEntityExist(currentroyale.data.lootBoxes[G].entity) then
            DeleteEntity(currentroyale.data.lootBoxes[G].entity)
            currentroyale.data.lootBoxes[G].entity = nil
        end
    end
    currentroyale.data.lootBoxes[G] = nil
end)

RegisterNetEvent("XCEL:removeArmourPlateCl",function(H)
    tXCEL.removeArea("XCELbr_armour_" .. H)
    tXCEL.removeNamedBlip("XCELbr_armour_" .. H)
    if currentroyale.data.armourPlates[H] then
        if currentroyale.data.armourPlates[H].entity then
            if DoesEntityExist(currentroyale.data.armourPlates[H].entity) then
                DeleteEntity(currentroyale.data.armourPlates[H].entity)
                currentroyale.data.armourPlates[H].entity = nil
            end
        end
        currentroyale.data.armourPlates[H] = nil
    end
end)


local function SortBR()
    local R = sortedKeys(currentroyale.players,function(S, T)
        return currentroyale.players[S].kills > currentroyale.players[T].kills
    end)
    for h = 1, 3 do
        if currentroyale.players[R[h]] then
            currentroyale.players[R[h]].leaderboardPos = h
            currentroyale.data.leaderboard[h] = currentroyale.players[R[h]]
        end
    end
end

RegisterNetEvent("XCEL:addBRKill",function(usersrc, username)
    if currentroyale.players[usersrc] then
        currentroyale.players[usersrc].kills = currentroyale.players[usersrc].kills + 1
    else
        currentroyale.players[usersrc] = {source = usersrc, name = username, kills = 1}
    end
    SortBR()
end)
RegisterNetEvent("XCEL:removePlayerFromBR",function(usersrc)
    if currentroyale.players[usersrc] then
        local p = table.copy(currentroyale.players[usersrc])
        currentroyale.players[usersrc] = nil
        if p.leaderboardPos then
            currentroyale.data.leaderboard[p.leaderboardPos] = nil
            SortBR()
        end
    end
end)

local a = false
local c = 0.033
local d = 0.033
local e = 0
local f = 0.306
function func_BRMenuControl()
    if a then
        if CurrentEvent.isActive and CurrentEvent.eventName == "Battle Royale" then
            if tXCEL.isNewPlayer() then
                drawNativeNotification("Press ~INPUT_SELECT_CHARACTER_FRANKLIN~ to toggle the BR Leaderboard Menu.")
            end
            DrawRect(0.50, 0.222, 0.223, 0.075,  142, 50, 0, 255)
            DrawAdvancedText(0.595, 0.210, 0.005, 0.0028, 0.7, "XCEL BR LEADERBOARD", 255, 255, 255, 255, tXCEL.getFontId("Akrobat-ExtraBold"), 0)
            if next(currentroyale.players) ~= nil then
                DrawAdvancedText(0.55, 0.275, 0.005, 0.0028, 0.4, "Name", 0, 255, 50, 255, 6, 0)
                DrawAdvancedText(0.60, 0.275, 0.005, 0.0028, 0.4, "", 0, 255, 50, 255, 6, 0)
                DrawAdvancedText(0.65, 0.275, 0.005, 0.0028, 0.4, "Kills", 0, 255, 50, 255, 6, 0)
            else
                DrawAdvancedText(0.595, 0.275, 0.005, 0.0028, 0.4, "0 Players with kills", 255, 0, 50, 255, 6, 0)
            end
            DrawRect(0.50, 0.272, 0.223, 0.026, 0, 0, 0, 222)
            for usersrc, player in pairs(currentroyale.players) do
                DrawAdvancedText(0.55, f + e * c, 0.005, 0.0028, 0.4, tostring(player.name), 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.60, f + e * c, 0.005, 0.0028, 0.4, "|", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.65, f + e * c, 0.005, 0.0028, 0.4, tostring(player.kills or 0), 255, 255, 255, 255, 6, 0)
                DrawRect(0.50, 0.301 + c * e, 0.223, 0.033, 0, 0, 0, 120)
                e = e + 1
            end
            e = 0
        end
    end
end
RegisterCommand('brleaderboard', function(source, args, rawCommand)
    a = not a
    if a then
        func_BRMenuControl()
    end
end, false)
RegisterKeyMapping("brleaderboard", "Open BR Leaderboard Menu", "keyboard", "F6")
tXCEL.createThreadOnTick(func_BRMenuControl)

local N = {[1] = "1st", [2] = "2nd", [3] = "3rd"}
local O = {[1] = 4, [2] = 3, [3] = 2}
local P = {[1] = "~HUD_COLOUR_GOLD~", [2] = "~HUD_COLOUR_SILVER~", [3] = "~HUD_COLOUR_BRONZE~"}
tXCEL.createThreadOnTick(function()
    if CurrentEvent.isActive and CurrentEvent.eventName == "Battle Royale" then
        for h = 1, 3 do
            if currentroyale.data.leaderboard[h] then
                XCEL.DrawGTATimerBar(P[h] .. N[h] .. " " .. currentroyale.data.leaderboard[h].name,P[h] .. currentroyale.data.leaderboard[h].kills,O[h] + 1)
            end
        end
        XCEL.DrawGTATimerBar("~y~GAS:~w~",string.format("~y~%02d:%02d", currentroyale.gas.timeUntilNext.minutes, currentroyale.gas.timeUntilNext.seconds),2)
    end
end)

function XCEL.DrawGTAText(a, b, c, j, z, A)
    SetTextFont(0)
    SetTextScale(j, j)
    SetTextColour(254, 254, 254, 255)
    if z then
        SetTextWrap(b - A, b)
        SetTextRightJustify(true)
    end
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(a)
    EndTextCommandDisplayText(b, c)
end

function XCEL.DrawGTATimerBar(a0, K, a1, a2, a3, a4)
    local a5 = 0.17
    local a6 = -0.01
    local a7 = 0.038
    local a8 = 0.008
    local a9 = 0.005
    local a4 = a4 or 0.32
    local a2 = a2 or 0.5
    local aa = -0.04
    local ab = 0.014
    local ac = GetSafeZoneSize()
    local ad = ab + ac - a5 + a5 / 2
    local ae = aa + ac - a7 + a7 / 2 - (a1 - 1) * (a7 + a9)
    DrawSprite("timerbars", "all_black_bg", ad, ae, a5, 0.038, 0, 0, 0, 0, 128)
    XCEL.DrawGTAText(a0, ac - a5 + 0.06, ae - a8, a4)
    XCEL.DrawGTAText(string.upper(K), ac - a6 + (a3 or 0), ae - 0.0175, a2, true, a5 / 2)
end

tXCEL.createThreadOnTick(function()
    if currentroyale.gas.isActive then
        local M = currentroyale.gas.radius
        if M >= 1800.0 then
            M = M - 17.5
        elseif M >= 1400.0 then
            M = M - 15.0
        elseif M >= 1000 then
            M = M - 12.5
        elseif M >= 600 then
            M = M - 10.0
        elseif M >= 250 then
            M = M - 5.0
        end
        DrawMarker(1,currentroyale.gas.coords.x,currentroyale.gas.coords.y,0.0,0.0,0.0,0.0,1.0,1.0,1.0,M,M,6000.0,255,0,0,155,false,false,2,false,nil,nil,false)
    end
end)

Citizen.CreateThread(function()
    while true do
        sleep = false
        if currentroyale.gas.isActive then
            sleep = true
            if currentroyale.gas.timeUntilNext.seconds > 0 then
                currentroyale.gas.timeUntilNext.seconds = currentroyale.gas.timeUntilNext.seconds - 1
            else
                if currentroyale.gas.timeUntilNext.seconds == 0 and currentroyale.gas.timeUntilNext.minutes == 0 then
                    XCEL.changeGasRadius(currentroyale.gas.radius - 400)
                else
                    currentroyale.gas.timeUntilNext.seconds = 59
                    currentroyale.gas.timeUntilNext.minutes = currentroyale.gas.timeUntilNext.minutes - 1
                end
            end
        end
        Wait(sleep and 1000 or 5000)
    end
end)

Citizen.CreateThread(function()
    while true do
        sleep = false
        if currentroyale.gas.isActive and currentroyale.player.hasJumped and not IsPedInParachuteFreeFall(PlayerPedId()) and GetPedParachuteState(PlayerPedId()) <= 2 and CurrentEvent.isActive then
            sleep = true
            if #(tXCEL.getPlayerCoords().xy - currentroyale.gas.coords.xy) > currentroyale.gas.radius / 2.0 then
                XCEL.DrawNativeText("~r~You are in the gas. Get to the safe zone before you suffocate.")
                ApplyDamageToPed(PlayerPedId(), 1, false)
            end
        end
        Wait(sleep and 500 or 5000)
    end
end)

function XCEL.DrawAdvancedText(b, c, r, s, t, a, u, v, w, x, k, y)
    SetTextFont(k)
    SetTextScale(t, t)
    SetTextJustification(y)
    SetTextColour(u, v, w, x)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(a)
    EndTextCommandDisplayText(b - 0.1 + r, c - 0.02 + s)
end
function XCEL.DrawAdvancedTextNoOutline(b, c, r, s, t, a, u, v, w, x, k, y)
    SetTextFont(k)
    SetTextScale(t, t)
    SetTextJustification(y)
    SetTextColour(u, v, w, x)
    SetTextDropShadow()
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(a)
    EndTextCommandDisplayText(b - 0.1 + r, c - 0.02 + s)
end

local function DrawJumpBox()
    if inplane then
        DrawRect(0.496, 0.945, 1.008, 0.12, 0, 0, 0, 150)
        DrawRect(0.493, 0.059, 1.025, 0.12, 0, 0, 0, 150)
        if CursorInArea(GetArea(0.493, 0.944, 0.14, 0.074)) then
            DrawRect(0.493, 0.944, 0.14, 0.074, 0, 203, 93, 134)
        else
            DrawRect(0.493, 0.944, 0.14, 0.074, 0, 180, 93, 134)
        end
        if currentroyale.data.timer > 0 then
            XCEL.DrawAdvancedText(0.587, 0.934, 0.005, 0.0028, 0.971, tostring(currentroyale.data.timer), 255, 255, 255, 255, 4, 0)
        else
            XCEL.DrawAdvancedText(0.587, 0.934, 0.005, 0.0028, 0.971, "JUMP", 255, 255, 255, 255, 4, 0)
        end
        XCEL.DrawAdvancedText(0.591, 0.042, 0.005, 0.0028, 0.993, "XCEL BATTLEGROUNDS", 255, 255, 255, 255, 6, 0)
    end
end
function tXCEL.DrawNativeNotification(A)
    SetTextComponentFormat('STRING')
    AddTextComponentString(A)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end
local winnerPositions = {
    vector4(683.82855224609,570.56701660156,130.44616699219,155.0),
    vector4(682.49670410156,571.10766601562,130.44616699219,155.0),
    vector4(685.51647949219,570.01318359375,130.44616699219,155.0),
    vector4(687.23077392578,569.41979980469,130.44616699219,155.0),
    vector4(681.44177246094,571.45056152344,130.44616699219,155.0),
    vector4(680.21539306641,573.54724121094,130.44616699219,155.0),
    vector4(681.73187255859,573.17803955078,130.44616699219,155.0),
    vector4(683.34063720703,572.57141113281,130.44616699219,155.0),
    vector4(685.09448242188,571.8857421875,130.44616699219,155.0),
    vector4(687.23077392578,571.39782714844,130.44616699219,155.0),
    vector4(689.23516845703,570.89672851562,130.44616699219,155.0),
    vector4(690.96264648438,571.43737792969,130.44616699219,155.0),
    vector4(689.63079833984,572.94067382812,130.44616699219,155.0),
    vector4(687.74505615234,573.69232177734,130.44616699219,155.0),
    vector4(686.10986328125,574.33843994141,130.44616699219,155.0),
    vector4(682.44396972656,575.78900146484,130.44616699219,155.0),
    vector4(680.14947509766,572.00439453125,130.44616699219,155.0),
    vector4(678.93627929688,572.57141113281,130.44616699219,155.0),
    vector4(679.23956298828,573.876953125,130.44616699219,155.0),
    vector4(686.22857666016,571.75384521484,130.44616699219,155.0),
    vector4(688.29888916016,571.06811523438,130.44616699219,155.0),
    vector4(688.57580566406,568.95825195312,130.44616699219,155.0),
    vector4(690.54064941406,570.19781494141,130.44616699219,155.0),
    vector4(689.61755371094,571.80657958984,130.44616699219,155.0),
    vector4(688.41760253906,572.34722900391,130.44616699219,155.0),
    vector4(687.38903808594,572.71649169922,130.44616699219,155.0),
    vector4(686.20220947266,573.05932617188,130.44616699219,155.0),
    vector4(684.96264648438,573.37585449219,130.44616699219,155.0),
    vector4(683.96044921875,573.86376953125,130.44616699219,155.0),
    vector4(682.86596679688,574.23297119141,130.44616699219,155.0),
    vector4(681.876953125,574.66815185547,130.44616699219,155.0),
    vector4(680.82196044922,574.98461914062,130.44616699219,155.0),
    vector4(689.48571777344,569.67034912109,130.44616699219,155.0),
    vector4(688.43078613281,570.13189697266,130.44616699219,155.0),
    vector4(687.01977539062,570.65936279297,130.44616699219,155.0),
    vector4(685.75384521484,571.00219726562,130.44616699219,155.0),
    vector4(684.03955078125,571.62200927734,130.44616699219,155.0),
    vector4(682.73406982422,571.9384765625,130.44616699219,155.0),
    vector4(681.65277099609,572.47912597656,130.44616699219,155.0),
    vector4(680.54504394531,572.72967529297,130.44616699219,155.0),
    vector4(679.47692871094,573.00659179688,130.44616699219,155.0),
    vector4(679.63519287109,575.47253417969,130.44616699219,155.0),
    vector4(689.88134765625,568.74725341797,130.44616699219,155.0),
    vector4(690.87036132812,572.50549316406,130.44616699219,155.0),
    vector4(688.70770263672,573.27032470703,130.44616699219,155.0),
    vector4(684.97583007812,574.60217285156,130.44616699219,155.0),
    vector4(683.73626708984,575.05053710938,130.44616699219,155.0),
    vector4(681.27032470703,576.06591796875,130.44616699219,155.0),
    vector4(680.25494384766,576.36926269531,130.44616699219,155.0),
    vector4(691.54284667969,573.53405761719,130.44616699219,155.0),
    vector4(690.40881347656,573.9560546875,130.44616699219,155.0),
    vector4(689.52526855469,574.29888916016,130.44616699219,155.0),
    vector4(688.58898925781,574.62860107422,130.44616699219,155.0),
    vector4(687.46813964844,575.07690429688,130.44616699219,155.0),
    vector4(686.42639160156,575.53845214844,130.44616699219,155.0),
    vector4(685.31866455078,575.80218505859,130.44616699219,155.0),
    vector4(684.30328369141,576.21099853516,130.44616699219,155.0),
    vector4(683.31427001953,576.67254638672,130.44616699219,155.0),
    vector4(682.28570556641,577.12091064453,130.44616699219,155.0),
    vector4(681.34942626953,577.45056152344,130.44616699219,155.0),
    vector4(680.28131103516,577.79339599609,130.44616699219,155.0),
    vector4(686.38684082031,569.78900146484,130.44616699219,155.0),
    vector4(684.72528076172,570.42199707031,130.44616699219,155.0),
    vector4(686.99340820312,574.0615234375,130.44616699219,155.0)
}

local loserPositions = {
    vector4(696.13189697266,579.70550537109,130.44616699219,155.0),
    vector4(694.94506835938,580.02197265625,130.44616699219,155.0),
    vector4(693.85052490234,580.41760253906,130.44616699219,155.0),
    vector4(693.42858886719,579.25714111328,130.44616699219,155.0),
    vector4(694.62860107422,578.78240966797,130.44616699219,155.0),
    vector4(695.98681640625,578.22857666016,130.44616699219,155.0),
    vector4(696.27691650391,577.21319580078,130.44616699219,155.0),
    vector4(694.90551757812,577.74066162109,130.44616699219,155.0),
    vector4(696.47473144531,577.12091064453,130.44616699219,155.0),
    vector4(692.51867675781,578.22857666016,130.44616699219,155.0),
    vector4(691.38464355469,578.59777832031,130.44616699219,155.0),
    vector4(692.38684082031,579.86376953125,130.44616699219,155.0),
    vector4(690.98901367188,581.01098632812,130.44616699219,155.0),
    vector4(690.44836425781,579.32305908203,130.44616699219,155.0),
    vector4(697.92529296875,581.60437011719,130.44616699219,155.0),
    vector4(699.16485595703,581.02416992188,130.44616699219,155.0),
    vector4(692.42639160156,581.03735351562,130.44616699219,155.0),
    vector4(690.17144775391,581.73626708984,130.44616699219,155.0),
    vector4(697.17364501953,579.21759033203,130.44616699219,155.0),
    vector4(697.39782714844,577.78021240234,130.44616699219,155.0),
    vector4(697.75384521484,576.64617919922,130.44616699219,155.0),
    vector4(699.24395751953,576.0263671875,130.44616699219,155.0),
    vector4(697.84613037109,578.88793945312,130.44616699219,1155.0),
    vector4(698.92749023438,578.58459472656,130.44616699219,155.0),
    vector4(697.79339599609,577.71429443359,130.44616699219,155.0),
    vector4(699.16485595703,577.16046142578,130.44616699219,155.0),
    vector4(693.66595458984,577.89892578125,130.44616699219,155.0),
    vector4(691.00219726562,580.23297119141,130.44616699219,155.0),
    vector4(689.85498046875,580.76043701172,130.44616699219,155.0),
    vector4(689.47253417969,579.66595458984,130.44616699219,155.0),
    vector4(700.0087890625,579.38903808594,130.44616699219,155.0),
    vector4(698.78240966797,579.78460693359,130.44616699219,155.0),
    vector4(697.912109375,580.1142578125,130.44616699219,155.0),
    vector4(696.97583007812,580.50988769531,130.44616699219,155.0),
    vector4(695.90771484375,580.81317138672,130.44616699219,155.0),
    vector4(694.72088623047,581.19561767578,130.44616699219,155.0),
    vector4(693.59997558594,581.61755371094,130.44616699219,155.0),
    vector4(692.22857666016,582.22418212891,130.44616699219,155.0),
    vector4(690.92309570312,582.68572998047,130.44616699219,155.0),
    vector4(696.83074951172,582.0,130.44616699219,155.0),
    vector4(695.76263427734,582.38244628906,130.44616699219,155.0),
    vector4(694.70770263672,582.54064941406,130.44616699219,155.0),
    vector4(693.30987548828,583.01538085938,130.44616699219,155.0),
    vector4(692.18902587891,583.58239746094,130.44616699219,155.0),
    vector4(690.96264648438,583.9912109375,130.44616699219,155.0),
    vector4(691.41101074219,581.78900146484,130.44616699219,155.0),
    vector4(699.876953125,581.67034912109,130.44616699219,155.0),
    vector4(698.91430664062,582.11865234375,130.44616699219,155.0),
    vector4(697.62200927734,582.65936279297,130.44616699219,155.0),
    vector4(696.52746582031,583.06811523438,130.44616699219,155.0),
    vector4(695.51208496094,583.34503173828,130.44616699219,155.0),
    vector4(694.28570556641,583.68792724609,130.44616699219,155.0),
    vector4(693.11206054688,584.0966796875,130.44616699219,155.0),
    vector4(691.9384765625,584.59777832031,130.44616699219,155.0),
    vector4(699.83734130859,582.71209716797,130.44616699219,155.0),
    vector4(698.58459472656,583.22637939453,130.44616699219,155.0),
    vector4(697.26593017578,583.71429443359,130.44616699219,155.0),
    vector4(696.22418212891,584.03076171875,130.49670410156,155.0),
    vector4(695.07690429688,584.41320800781,130.46301269531,155.0),
    vector4(693.85052490234,584.66375732422,130.44616699219,155.0),
    vector4(692.78240966797,585.11206054688,130.44616699219,155.0),
    vector4(691.51647949219,585.61315917969,130.44616699219,155.0),
    vector4(699.99560546875,578.16265869141,130.44616699219,155.0),
    vector4(700.15386962891,576.75164794922,130.44616699219,155.0)
}

local function firework(coords)
    tXCEL.loadPtfx("proj_indep_firework")
    tXCEL.loadPtfx("proj_indep_firework_v2")
    UseParticleFxAsset("proj_indep_firework")
    UseParticleFxAsset("proj_indep_firework_v2")
    CreateThread(function()
        for i=1, 5 do
            if i % 2 == 0 then
                UseParticleFxAsset("proj_indep_firework_v2")
                local part1 = StartParticleFxNonLoopedAtCoord("scr_firework_indep_repeat_burst_rwb", coords, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, false, false, false)
            else
                UseParticleFxAsset("proj_indep_firework")
                local part1 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_air_burst", coords, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, false, false, false)
            end
            Wait(1000)
        end
    end)

    tXCEL.loadPtfx("scr_indep_fireworks")
    UseParticleFxAsset("scr_indep_fireworks")
    CreateThread(function()
        for i=1, 5 do
            UseParticleFxAsset("scr_indep_fireworks")
            local part1 = StartParticleFxNonLoopedAtCoord("scr_indep_firework_starburst", coords, 0.0, 0.0, 0.0, 1.0, 0., 0.0, false, false, false)
            Wait(1000)
        end
    end)
end

-- anim@arena@celeb
-- intcelebration

local drawingPodium = false

function XCEL.isPodiumDrawing()
    return drawingPodium
end

local cancelPodium = false

function XCEL.callCancelPodium()
    cancelPodium = true
end

function XCEL.podiumLeaderboard(winners, losers, currentEmotes)
    if not next(winners) and not next(losers) then
        print("XCEL.podiumLeaderboard was called with no winners or losers, this will break things!")
    end
  --  XCEL.enablePlayerTags(true, false)
    drawingPodium = true
    tXCEL.setTime(0,0,0)
   -- XCEL.clearBounds()
    RequestIpl("stadium")
    while not IsIplActive("stadium") do
        print("Loading stadium IPL")
        Wait(0)
    end
    --SetTimecycleModifier("MP_job_win")
    ExecuteCommand("hideui")
    TriggerEvent("XCEL:PlaySound", "celebration_music")
    local textHandles = {}
    local playerPed = PlayerPedId()
    FreezeEntityPosition(playerPed,true)
    SetEntityVisible(playerPed, true, false)
    ClearPedBloodDamage(playerPed)
    SetEntityCoords(playerPed, 686.37365722656,576.83074951172,130.44616699219, false, false, false, false)
    for index, playerInfo in pairs(winners) do
        if playerInfo.source == GetPlayerServerId(PlayerId()) then
            local position = winnerPositions[index]
            if not position then
                position = vector4(686.37365722656,576.83074951172,130.44616699219,158.74015808105)
            end
            SetEntityCoords(playerPed, position.x,position.y,position.z-1, false, false, false, false)
            SetEntityHeading(playerPed, position.w)
            CreateThread(function()
                local dict = "anim@arena@celeb@flat@solo@no_props@"
                local anim = "flip_a_player_a"
                if currentEmotes and currentEmotes["winning"] then
                    dict = currentEmotes["winning"].dict
                    anim = currentEmotes["winning"].anim
                end
                tXCEL.loadAnimDict(dict)
                while drawingPodium do
                    SetFocusPosAndVel(682.94506835938,572.95385742188,131.08642578125, 0, 0, 0)
                    FreezeEntityPosition(PlayerPedId(),true)
                    if not IsEntityPlayingAnim(PlayerPedId(),dict,anim,3) then
                        TaskPlayAnim(PlayerPedId(),dict,anim,8.0,8.0,-1,1,1.0, false, false, false)
                    end
                    Wait(0)
                end
            end)
        end
        --table.insert(textHandles, XCEL.add3DTextForCoord(playerInfo.name, winnerPositions[index].x,winnerPositions[index].y,winnerPositions[index].z+2, 25))
    end
    for index, playerInfo in pairs(losers) do
        if playerInfo.source == GetPlayerServerId(PlayerId()) then
            local position = loserPositions[index]
            if not position then
                position = vector4(700.52307128906,575.68353271484,130.44616699219,158.74015808105)
            end
            SetEntityCoords(playerPed, position.x,position.y,position.z-1,false, false, false, false)
            SetEntityHeading(playerPed, position.w)
            CreateThread(function()
                local dict = "anim_casino_a@amb@casino@games@arcadecabinet@femaleleft"
                local anim = "lose_big"
                if currentEmotes and currentEmotes["losing"] then
                    dict = currentEmotes["losing"].dict
                    anim = currentEmotes["losing"].anim
                end
                tXCEL.loadAnimDict(dict)
                while drawingPodium do
                    SetFocusPosAndVel(682.94506835938,572.95385742188,131.08642578125, 0, 0, 0)
                    FreezeEntityPosition(PlayerPedId(),true)
                    if not IsEntityPlayingAnim(PlayerPedId(),dict,anim,3) then
                        TaskPlayAnim(PlayerPedId(),dict,anim,8.0,8.0,-1,1,1.0, false, false, false)
                    end
                    Wait(0)
                end
            end)
        end
        --table.insert(textHandles, XCEL.add3DTextForCoord(playerInfo.name, loserPositions[index].x,loserPositions[index].y,loserPositions[index].z+2, 25))
    end

    local cameraCoords = vector3(683.83, 570.57, 130.46)
    local cameraOne = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA",681.29, 563.62, 141.05, 0.0, 0.0, 0.0, 65.0, false, 2)
    PointCamAtCoord(cameraOne, cameraCoords.x, cameraCoords.y, cameraCoords.z+10)
    SetCamActive(cameraOne, true)
    RenderScriptCams(true, true, 0, true, false)
    local cameraTwo = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA",681.29, 563.62, 131.05, 0.0, 0.0, 0.0, 65.0, false, 2)
    PointCamAtCoord(cameraTwo, cameraCoords.x, cameraCoords.y, cameraCoords.z)
    SetCamActiveWithInterp(cameraTwo, cameraOne, 4000, 5, 5)

    firework(cameraCoords + vector3(0,0,5))
    firework(vector3(681.34, 572.84, 130.46) + vector3(0,0,5))
    firework(vector3(686.76, 570.71, 130.46) + vector3(0,0,5))

    local startTimer = GetGameTimer()
    while not cancelPodium and (GetGameTimer() - startTimer < 3000) do
        ThefeedHideThisFrame()
        Wait(0)
    end

    if not cancelPodium then
        local cameraThree = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA",696.13189697266,579.70550537109,130.44616699219, 0.0, 0.0, 0.0, 65.0, false, 2)
        PointCamAtCoord(cameraThree, vector3(695.947265625,584.84832763672,130.74951171875))
        SetCamActiveWithInterp(cameraThree, cameraTwo, 8000, 5, 5)
    end

    local startTimer = GetGameTimer()
    while not cancelPodium and (GetGameTimer() - startTimer < 4000) do
        ThefeedHideThisFrame()
        Wait(0)
    end

    if not cancelPodium then
        DoScreenFadeOut(2000)
    end

    local startTimer = GetGameTimer()
    while not cancelPodium and (GetGameTimer() - startTimer < 3000) do Wait(0) end

    for _, areaId in pairs(textHandles) do
        tXCEL.removeArea("3dtext_"..areaId)
    end
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed,false)
    RenderScriptCams(false, false, 1, true, true)
    DestroyCam(cameraOne, false)
    DestroyCam(cameraTwo, false)
    DestroyAllCams(true)
    DoScreenFadeIn(1000)
    tXCEL.setTime(12,0,0)
    ClearTimecycleModifier()
    drawingPodium = false
    ExecuteCommand("showui")
    cancelPodium = false
    ClearFocus()
    SendNUIMessage({
        type="STOP_AUDIO",
    })
end

function XCEL.RegisterDebugCommand(commandName, func)
    CreateThread(function()
        while tXCEL.getUserId() == nil do
            Wait(0)
        end
        if tXCEL.isDev() then
            RegisterCommand(commandName, function(source, args, rawCommand)
                func(source, args, rawCommand)
            end, true)
        end
    end)
end

RegisterCommand("testpodium", function()
    XCEL.podiumLeaderboard({},{
        {name="finny",source=GetPlayerServerId(PlayerId())}
    },nil)
end, false)

-- XCEL.RegisterDebugCommand("testpodium", function()
--     XCEL.podiumLeaderboard({},{
--         {name="finny",source=GetPlayerServerId(PlayerId())}
--     },nil)
-- end)

function func_handleClicks()
    if inplane then
        DisableAllControlActions(0)
        EnableControlAction(0, 329, true)
        EnableControlAction(1, 329, true)
        EnableControlAction(2, 239, true)
        EnableControlAction(2, 240, true)
        if CursorInArea(GetArea(0.493, 0.944, 0.14, 0.074)) then
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                if currentroyale.player.canExitPlane then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    ClearPedTasks(PlayerPedId())
                    
                    local coords = GetEntityCoords(PlayerPedId())
                    TaskLeaveVehicle(PlayerPedId(), currentroyale.data.plane, 256)
                    SetEntityCoords(PlayerPedId(), coords.x + 10, coords.y, coords.z - 1.0)
                    
                    SetEntityVisible(PlayerPedId(), true, true)
                    currentroyale.player.hasJumped = true
                    SetTimeout(5000,function()
                        DeleteEntity(currentroyale.data.plane)
                        if CurrentEvent.isActive then 
                            for o, p in pairs(GetActivePlayers()) do
                                if p ~= PlayerId() then
                                    NetworkConcealPlayer(p, false, 0)
                                    SetEntityVisible(GetPlayerPed(p), true, true)
                                end
                            end
                        end
                        local q = PlayerPedId()
                        local r = false
                        while HasPedGotWeapon(q, "GADGET_PARACHUTE", false) do
                            local s = GetEntityHeightAboveGround(q)
                            if s > 10.0 and s < 250.0 and IsPedInParachuteFreeFall(q) then
                                tXCEL.DrawNativeNotification("Press ~INPUT_PARACHUTE_DEPLOY~ to deploy your parachute.")
                                if s < 100.0 and not r then
                                    SetControlNormal(0, 144, 1.0)
                                    r = true
                                end
                            end
                            Citizen.Wait(0)
                        end
                    end)
                    setCursor(0)
                    inplane = false
                    inGUI = false
                    ExecuteCommand("showui")
                end
            end
        end
    end
    if currentroyale.player.isInWinnerScreen then
        if CursorInArea(GetArea(0.092, 0.925, 0.154, 0.096)) then
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                setCursor(0)
                currentroyale.player.isInWinnerScreen = false
                inGUI = false
                inplane = false
                currentroyale = Reset()
                ExecuteCommand("hideui")
            end
        end
    end
end

local function func_drawWinnerGUI()
    if currentroyale.player.isInWinnerScreen then
        DrawRect(0.486, 0.064, 1.081, 0.202, 0, 0, 0, 150)
        DrawAdvancedText(0.262, 0.067, 0.005, 0.0028, 0.96599999999999, "WINNER WINNER CHICKEN DINNER!", 255, 255, 255, 255, 6, 0)
        DrawRect(0.478, 0.933, 1.054, 0.194, 0, 0, 0, 150)
        DrawAdvancedText(0.582, 0.905, 0.005, 0.0028, 0.96599999999999, "#1 "..tXCEL.GetPlayerName(GetPlayerServerId(PlayerId())), 255, 255, 255, 255, 6, 0)
        if CursorInArea(GetArea(0.092, 0.925, 0.154, 0.096)) then
            DrawRect(0.092, 0.925, 0.154, 0.096, 100, 0, 0, 174)
        else
            DrawRect(0.092, 0.925, 0.154, 0.096, 78, 0, 0, 174)
        end
        DrawAdvancedText(0.185, 0.91, 0.005, 0.0028, 0.971, "LEAVE", 255, 255, 255, 255, 6, 0)
    end
end
tXCEL.createThreadOnTick(func_drawWinnerGUI)
tXCEL.createThreadOnTick(DrawJumpBox)
tXCEL.createThreadOnTick(func_handleClicks)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        local playerPed = PlayerPedId()
        local playerId = PlayerId()

        if IsPedFalling(playerPed) and CurrentEvent.isActive then
            SetEntityInvincible(playerPed, true)
            SetPlayerInvincible(playerId, true)
            SetPedCanRagdoll(playerPed, false)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            SetEntityProofs(playerPed, true, true, true, true, true, true, true, true)
            SetEntityOnlyDamagedByPlayer(playerPed, false)
            SetEntityCanBeDamaged(playerPed, false)
        else
            SetEntityInvincible(playerPed, false)
            SetPlayerInvincible(playerId, false)
            SetPedCanRagdoll(playerPed, true)
            ClearPedLastWeaponDamage(playerPed)
            SetEntityProofs(playerPed, false, false, false, false, false, false, false, false)
            SetEntityOnlyDamagedByPlayer(playerPed, false)
            SetEntityCanBeDamaged(playerPed, true)
        end
    end
end)
