cfg = module("cfg/client")
purgecfg = module("cfg/cfg_purge")
tXCEL = {}
local a = {}
Tunnel.bindInterface("XCEL", tXCEL)
XCELserver = Tunnel.getInterface("XCEL", "XCEL")
Proxy.addInterface("XCEL", tXCEL)
allowedWeapons = {}
weapons = module("cfg/weapons")
function tXCEL.isDevMode()
    if tXCEL.isDev() then
        return true
    else
        return false
    end
end
function tXCEL.teleport(b, c, d)
    local e = PlayerPedId()
    NetworkFadeOutEntity(e, true, false)
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    SetEntityCoords(tXCEL.getPlayerPed(), b + 0.0001, c + 0.0001, d + 0.0001, 1, 0, 0, 1)
    NetworkFadeInEntity(e, 0)
    DoScreenFadeIn(500)
end
function tXCEL.teleport2(f, g)
    local e = PlayerPedId()
    NetworkFadeOutEntity(e, true, false)
    if tXCEL.getPlayerVehicle() == 0 or not g then
        SetEntityCoords(tXCEL.getPlayerPed(), f.x, f.y, f.z, 1, 0, 0, 1)
    else
        SetEntityCoords(tXCEL.getPlayerVehicle(), f.x, f.y, f.z, 1, 0, 0, 1)
    end
    Wait(500)
    NetworkFadeInEntity(e, 0)
end
function tXCEL.getPosition()
    return GetEntityCoords(tXCEL.getPlayerPed())
end
function tXCEL.getDistanceBetweenCoords(h, j, k, l, m, n)
    local o = GetDistanceBetweenCoords(h, j, k, l, m, n, true)
    return o
end
function tXCEL.isInside()
    local h, j, k = table.unpack(tXCEL.getPosition())
    return not (GetInteriorAtCoords(h, j, k) == 0)
end
local p = module("cfg/cfg_attachments")
function tXCEL.getAllWeaponAttachments(q, r)
    local s = PlayerPedId()
    local t = {}
    if r then
        for u, v in pairs(p.attachments) do
            if HasPedGotWeaponComponent(s, q, GetHashKey(v)) and not table.has(givenAttachmentsToRemove[q] or {}, v) then
                table.insert(t, v)
            end
        end
    else
        for u, v in pairs(p.attachments) do
            if HasPedGotWeaponComponent(s, q, GetHashKey(v)) then
                table.insert(t, v)
            end
        end
    end
    return t
end
function tXCEL.getSpeed()
    local w, x, y = table.unpack(GetEntityVelocity(PlayerPedId()))
    return math.sqrt(w * w + x * x + y * y)
end
function tXCEL.getCamDirection()
    local z = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local A = GetGameplayCamRelativePitch()
    local h = -math.sin(z * math.pi / 180.0)
    local j = math.cos(z * math.pi / 180.0)
    local k = math.sin(A * math.pi / 180.0)
    local B = math.sqrt(h * h + j * j + k * k)
    if B ~= 0 then
        h = h / B
        j = j / B
        k = k / B
    end
    return h, j, k
end
function tXCEL.addPlayer(C)
    a[C] = true
end
function tXCEL.removePlayer(C)
    a[C] = nil
end
function tXCEL.getNearestPlayers(D)
    local E = {}
    local F = GetPlayerPed(i)
    local G = PlayerId()
    local H, I, J = table.unpack(tXCEL.getPosition())
    for e, K in pairs(a) do
        local C = GetPlayerFromServerId(e)
        if K and C ~= G and NetworkIsPlayerConnected(C) then
            local L = GetPlayerPed(C)
            local h, j, k = table.unpack(GetEntityCoords(L, true))
            local o = GetDistanceBetweenCoords(h, j, k, H, I, J, true)
            if o <= D then
                E[GetPlayerServerId(C)] = o
            end
        end
    end
    return E
end
function tXCEL.getNearestPlayer(D)
    local M = nil
    local a = tXCEL.getNearestPlayers(D)
    local N = D + 10.0
    for e, K in pairs(a) do
        if K < N then
            N = K
            M = e
        end
    end
    return M
end
function tXCEL.getNearestPlayersFromPosition(O, D)
    local E = {}
    local F = GetPlayerPed(i)
    local G = PlayerId()
    local H, I, J = table.unpack(O)
    for e, K in pairs(a) do
        local C = GetPlayerFromServerId(e)
        if K and C ~= G and NetworkIsPlayerConnected(C) then
            local L = GetPlayerPed(C)
            local h, j, k = table.unpack(GetEntityCoords(L, true))
            local o = GetDistanceBetweenCoords(h, j, k, H, I, J, true)
            if o <= D then
                E[GetPlayerServerId(C)] = o
            end
        end
    end
    return E
end
function tXCEL.notify(P)
    if not globalHideUi then
        SetNotificationTextEntry("STRING")
        AddTextComponentString(P)
        DrawNotification(true, false)
    end
end
local function Q(R, S, T)
    return R < S and S or R > T and T or R
end
local function U(b)
    local c = math.floor(#b % 99 == 0 and #b / 99 or #b / 99 + 1)
    local i = {}
    for d = 0, c - 1 do
        i[d + 1] = string.sub(b, d * 99 + 1, Q(#string.sub(b, d * 99), 0, 99) + d * 99)
    end
    return i
end
local function e(f, g)
    local V = U(f)
    SetNotificationTextEntry("CELL_EMAIL_BCON")
    for W, M in ipairs(V) do
        AddTextComponentSubstringPlayerName(M)
    end
    if g then
        local X = GetSoundId()
        PlaySoundFrontend(X, "police_notification", "DLC_AS_VNT_Sounds", true)
        ReleaseSoundId(X)
    end
end
function tXCEL.notifyPicture(Y, Z, f, _, a0, a1, a2)
    if Y ~= nil and Z ~= nil then
        RequestStreamedTextureDict(Y, true)
        while not HasStreamedTextureDictLoaded(Y) do
         --   print("stuck loading", Y)
            Wait(0)
        end
    end
    e(f, a1 == "police")
    if a2 == nil then
        a2 = 0
    end
    local a3 = false
    EndTextCommandThefeedPostMessagetext(Y, Z, a3, a2, _, a0)
    local a4 = true
    local a5 = false
    EndTextCommandThefeedPostTicker(a5, a4)
    DrawNotification(false, true)
    if a1 == nil then
        PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 1)
    end
end
function tXCEL.notifyPicture2(a6, type, a7, a8, a9)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(a9)
    SetNotificationMessage(a6, a6, true, type, a7, a8, a9)
    DrawNotification(false, true)
end
function tXCEL.notifyPicture6(ay,az,l,ac,aA,aB,aC)
    if ay~=nil and az~=nil then 
        RequestStreamedTextureDict(ay,true)
        while not HasStreamedTextureDictLoaded(ay)do 
            print("stuck loading",ay)
            Wait(0)
        end 
    end
    k(l,aB=="monzo")
    if aC==nil then 
        aC=0 
    end
    local aD=false
    EndTextCommandThefeedPostMessagetext(ay,az,aD,aC,ac,aA)
    local aE=true
    local aF=false
    EndTextCommandThefeedPostTicker(aF,aE)
    DrawNotification(false,true)
    if aB==nil then 
      TriggerEvent("xcel:PlaySound", "apple")
    end 
  end
function tXCEL.playScreenEffect(aa, ab)
    if ab < 0 then
        StartScreenEffect(aa, 0, true)
    else
        StartScreenEffect(aa, 0, true)
        Citizen.CreateThread(
            function()
                Citizen.Wait(math.floor((ab + 1) * 1000))
                StopScreenEffect(aa)
            end
        )
    end
end
function tXCEL.stopScreenEffect(aa)
    StopScreenEffect(aa)
end
local r = {}
local s = {}
function tXCEL.createArea(f, ac, u, v, ad, ae, af, ag)
    local ah = {position = ac, radius = u, height = v, enterArea = ad, leaveArea = ae, onTickArea = af, metaData = ag}
    if ah.height == nil then
        ah.height = 6
    end
    r[f] = ah
    s[f] = ah
end
function tXCEL.doesAreaExist(f)
    if r[f] then
        return true
    end
    return false
end
function DrawText3D(ai, Q, R, S, T, U, b)
    local c, i, d = GetScreenCoordFromWorldCoord(ai, Q, R)
    if c then
        SetTextScale(0.4, 0.4)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        BeginTextCommandDisplayText("STRING")
        SetTextCentre(1)
        AddTextComponentSubstringPlayerName(S)
        EndTextCommandDisplayText(i, d)
    end
end
function tXCEL.add3DTextForCoord(S, ai, Q, R, e)
    local function f(g)
        DrawText3D(g.coords.x, g.coords.y, g.coords.z, g.text)
    end
    local V = tXCEL.generateUUID("3dtext", 8, "alphanumeric")
    tXCEL.createArea(
        "3dtext_" .. V,
        vector3(ai, Q, R),
        e,
        6.0,
        function()
        end,
        function()
        end,
        f,
        {coords = vector3(ai, Q, R), text = S}
    )
end
local aj = {}
local ak = {
    ["alphabet"] = "abcdefghijklmnopqrstuvwxyz",
    ["numerical"] = "0123456789",
    ["alphanumeric"] = "abcdefghijklmnopqrstuvwxyz0123456789"
}
local function al(am, type)
    local an, ao, ap = 0, "", 0
    local aq = {ak[type]}
    repeat
        an = an + 1
        ap = math.random(aq[an]:len())
        if math.random(2) == 1 then
            ao = ao .. aq[an]:sub(ap, ap)
        else
            ao = aq[an]:sub(ap, ap) .. ao
        end
        an = an % #aq
    until ao:len() >= am
    return ao
end
function tXCEL.generateUUID(ar, am, type)
    if aj[ar] == nil then
        aj[ar] = {}
    end
    if type == nil then
        type = "alphanumeric"
    end
    local as = al(am, type)
    if aj[ar][as] then
        while aj[ar][as] ~= nil do
            as = al(am, type)
            Wait(0)
        end
    end
    aj[ar][as] = true
    return as
end
function tXCEL.setdecor(at, au)
    decor = at
    objettable = au
end
function XCEL.spawnVehicle(ac, K, av, au, ad, ae, af, ag)
    local aw = tXCEL.loadModel(ac)
    local ax = CreateVehicle(aw, K, av, au, ad, af, ag)
    SetModelAsNoLongerNeeded(aw)
    SetEntityAsMissionEntity(ax)
    DecorSetInt(ax, decor, 955)
    SetModelAsNoLongerNeeded(aw)
    if ae then
        TaskWarpPedIntoVehicle(PlayerPedId(), ax, -1)
    end
    setVehicleFuel(ax, 100)
    return ax
end
local ay = {}
Citizen.CreateThread(
    function()
        while true do
            local az = {}
            az.playerPed = tXCEL.getPlayerPed()
            az.playerCoords = tXCEL.getPlayerCoords()
            az.playerId = tXCEL.getPlayerId()
            az.vehicle = tXCEL.getPlayerVehicle()
            az.weapon = GetSelectedPedWeapon(az.playerPed)
            for aA = 1, #ay do
                local aB = ay[aA]
                aB(az)
            end
            Wait(0)
        end
    end
)
function tXCEL.createThreadOnTick(aB)
    ay[#ay + 1] = aB
end
local ai = 0
local Q = 0
local R = 0
local S = vector3(0, 0, 0)
local T = false
local U = PlayerPedId
function savePlayerInfo()
    ai = U()
    Q = GetVehiclePedIsIn(ai, false)
    R = PlayerId()
    S = GetEntityCoords(ai)
    local b = GetPedInVehicleSeat(Q, -1)
    T = b == ai
end
_G["PlayerPedId"] = function()
    return ai
end
function tXCEL.getPlayerPed()
    return ai
end
function tXCEL.getPlayerVehicle()
    return Q, T
end
function tXCEL.getPlayerId()
    return R
end
function tXCEL.getPlayerCoords()
    return S
end
createThreadOnTick(savePlayerInfo)
function tXCEL.getClosestVehicle(aC)
    local aD = tXCEL.getPlayerCoords()
    local aE = 100
    local aF = 100
    for u, bu in pairs(GetGamePool("CVehicle")) do
        local aG = GetEntityCoords(bu)
        local aH = #(aD - aG)
        if aH < aF then
            aF = aH
            aE = bu
        end
    end
    if aF <= aC then
        return aE
    else
        return nil
    end
end
local aI = {}
local aJ = Tools.newIDGenerator()
function tXCEL.playAnim(aK, aL, aM)
    if aL.task ~= nil then
        tXCEL.stopAnim(true)
        local F = PlayerPedId()
        if aL.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then
            local h, j, k = table.unpack(tXCEL.getPosition())
            TaskStartScenarioAtPosition(F, aL.task, h, j, k - 1, GetEntityHeading(F), 0, 0, false)
        else
            TaskStartScenarioInPlace(F, aL.task, 0, not aL.play_exit)
        end
    else
        tXCEL.stopAnim(aK)
        local aN = 0
        if aK then
            aN = aN + 48
        end
        if aM then
            aN = aN + 1
        end
        Citizen.CreateThread(
            function()
                local aO = aJ:gen()
                aI[aO] = true
                for e, K in pairs(aL) do
                    local aP = K[1]
                    local aa = K[2]
                    local aQ = K[3] or 1
                    for i = 1, aQ do
                        if aI[aO] then
                            local aR = e == 1 and i == 1
                            local aS = e == #aL and i == aQ
                            RequestAnimDict(aP)
                            local i = 0
                            while not HasAnimDictLoaded(aP) and i < 1000 do
                                Citizen.Wait(10)
                                RequestAnimDict(aP)
                                i = i + 1
                            end
                            if HasAnimDictLoaded(aP) and aI[aO] then
                                local aT = 8.0001
                                local aU = -8.0001
                                if not aR then
                                    aT = 2.0001
                                end
                                if not aS then
                                    aU = 2.0001
                                end
                                TaskPlayAnim(PlayerPedId(), aP, aa, aT, aU, -1, aN, 0, 0, 0, 0)
                            end
                            Citizen.Wait(0)
                            while GetEntityAnimCurrentTime(PlayerPedId(), aP, aa) <= 0.95 and
                                IsEntityPlayingAnim(PlayerPedId(), aP, aa, 3) and
                                aI[aO] do
                                Citizen.Wait(0)
                            end
                        end
                    end
                end
                aJ:free(aO)
                aI[aO] = nil
            end
        )
    end
end
function tXCEL.stopAnim(aK)
    aI = {}
    if aK then
        ClearPedSecondaryTask(PlayerPedId())
    else
        ClearPedTasks(PlayerPedId())
    end
end
local aV = false
function tXCEL.setRagdoll(aW)
    aV = aW
end
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(10)
            if aV then
                SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
            end
        end
    end
)
function tXCEL.playSpatializedSound(aP, aa, h, j, k, aX)
    PlaySoundFromCoord(-1, aa, h + 0.0001, j + 0.0001, k + 0.0001, aP, 0, aX + 0.0001, 0)
end
function tXCEL.playSound(aP, aa)
    PlaySound(-1, aa, aP, 0, 0, 1)
end
function tXCEL.playFrontendSound(aP, aa)
    PlaySoundFrontend(-1, aP, aa, 0)
end
function tXCEL.loadAnimDict(aP)
    while not HasAnimDictLoaded(aP) do
        RequestAnimDict(aP)
        Wait(0)
    end
end
function tXCEL.drawNativeNotification(aY)
    SetTextComponentFormat("STRING")
    AddTextComponentString(aY)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
function tXCEL.announceMpBigMsg(aZ, a_, b0)
    local b1 = Scaleform("MP_BIG_MESSAGE_FREEMODE")
    b1.RunFunction("SHOW_SHARD_WASTED_MP_MESSAGE", {aZ, a_, 0, false, false})
    local b2 = false
    SetTimeout(
        b0,
        function()
            b2 = true
        end
    )
    while not b2 do
        b1.Render2D()
        Wait(0)
    end
end
local g = true
function tXCEL.canAnim()
    return g
end
function tXCEL.setCanAnim(V)
    g = V
end
function tXCEL.getModelGender()
    local b3 = PlayerPedId()
    if GetEntityModel(b3) == GetHashKey("mp_f_freemode_01") then
        return "female"
    else
        return "male"
    end
end
function tXCEL.getPedServerId(b4)
    local b5 = GetActivePlayers()
    for u, v in pairs(b5) do
        if b4 == GetPlayerPed(v) then
            local b6 = GetPlayerServerId(v)
            return b6
        end
    end
    return nil
end
function tXCEL.loadModel(b7)
    local b8
    if type(b7) ~= "string" then
        b8 = b7
    else
        b8 = GetHashKey(b7)
    end
    if IsModelInCdimage(b8) then
        if not HasModelLoaded(b8) then
            RequestModel(b8)
            while not HasModelLoaded(b8) do
                Wait(0)
            end
        end
        return b8
    else
        return nil
    end
end
function tXCEL.getObjectId(b9, ba)
    if ba == nil then
        ba = ""
    end
    local bb = 0
    local bc = NetworkDoesNetworkIdExist(b9)
    if not bc then
        print(string.format("no object by ID %s\n%s", b9, ba))
    else
        local bd = NetworkGetEntityFromNetworkId(b9)
        bb = bd
    end
    return bb
end
function tXCEL.KeyboardInput(be, bf, bg)
    AddTextEntry("FMMC_KEY_TIP1", be)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", bf, "", "", "", bg)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local bh = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
        blockinput = false
        return bh
    else
        Citizen.Wait(1)
        blockinput = false
        return nil
    end
end
function tXCEL.syncNetworkId(bi)
    SetNetworkIdExistsOnAllMachines(bi, true)
    SetNetworkIdCanMigrate(bi, false)
    NetworkSetNetworkIdDynamic(bi, true)
end
RegisterNetEvent("__mg_callback:client")
AddEventHandler(
    "__mg_callback:client",
    function(bj, ...)
        local bk = promise.new()
        TriggerEvent(
            string.format("c__mg_callback:%s", bj),
            function(...)
                bk:resolve({...})
            end,
            ...
        )
        local bb = Citizen.Await(bk)
        TriggerServerEvent(string.format("__mg_callback:server:%s:%s", bj, ...), table.unpack(bb))
    end
)
tXCEL.TriggerServerCallback = function(bj, ...)
    assert(type(bj) == "string", "Invalid Lua type at argument #1, expected string, got " .. type(bj))
    local bk = promise.new()
    local bl = GetGameTimer()
    RegisterNetEvent(string.format("__mg_callback:client:%s:%s", bj, bl))
    local bm =
        AddEventHandler(
        string.format("__mg_callback:client:%s:%s", bj, bl),
        function(...)
            bk:resolve({...})
        end
    )
    TriggerServerEvent("__mg_callback:server", bj, bl, ...)
    local bb = Citizen.Await(bk)
    RemoveEventHandler(bm)
    return table.unpack(bb)
end
tXCEL.RegisterClientCallback = function(bj, bn)
    assert(type(bj) == "string", "Invalid Lua type at argument #1, expected string, got " .. type(bj))
    assert(type(bn) == "function", "Invalid Lua type at argument #2, expected function, got " .. type(bn))
    AddEventHandler(
        string.format("c__mg_callback:%s", bj),
        function(bo, ...)
            bo(bn(...))
        end
    )
end
Citizen.CreateThread(
    function()
        while true do
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetPedDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
            local bp = GetPlayerPed(-1)
            local bq = GetEntityCoords(bp)
            RemoveVehiclesFromGeneratorsInArea(
                bq["x"] - 500.0,
                bq["y"] - 500.0,
                bq["z"] - 500.0,
                bq["x"] + 500.0,
                bq["y"] + 500.0,
                bq["z"] + 500.0
            )
            SetGarbageTrucks(0)
            SetRandomBoats(0)
            Citizen.Wait(1)
        end
    end
)
function tXCEL.drawTxt(b1, b2, br, bs, bt, bv, bw, r, s, t)
    SetTextFont(b2)
    SetTextProportional(0)
    SetTextScale(bv, bv)
    SetTextColour(bw, r, s, t)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(br)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(b1)
    EndTextCommandDisplayText(bs, bt)
end
function drawNativeText(ah)
    if not globalHideUi then
        BeginTextCommandPrint("STRING")
        AddTextComponentSubstringPlayerName(ah)
        EndTextCommandPrint(100, 1)
    end
end
function clearNativeText()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName("")
    EndTextCommandPrint(1, true)
end
function tXCEL.announceClient(S)
    if S ~= nil then
        CreateThread(
            function()
                local T = GetGameTimer()
                local bx = RequestScaleformMovie("MIDSIZED_MESSAGE")
                while not HasScaleformMovieLoaded(bx) do
                    Wait(0)
                end
                PushScaleformMovieFunction(bx, "SHOW_SHARD_MIDSIZED_MESSAGE")
                PushScaleformMovieFunctionParameterString("~g~XCEL Announcement")
                PushScaleformMovieFunctionParameterString(S)
                PushScaleformMovieMethodParameterInt(5)
                PushScaleformMovieMethodParameterBool(true)
                PushScaleformMovieMethodParameterBool(false)
                EndScaleformMovieMethod()
                while T + 6 * 1000 > GetGameTimer() do
                    DrawScaleformMovieFullscreen(bx, 255, 255, 255, 255)
                    Wait(0)
                end
            end
        )
    end
end
AddEventHandler(
    "mumbleDisconnected",
    function(U)
        tXCEL.notify("~r~[XCEL] Lost connection to voice server, you may need to toggle voice chat.")
    end
)
RegisterNetEvent("XCEL:PlaySound")
AddEventHandler(
    "XCEL:PlaySound",
    function(by)
        SendNUIMessage({transactionType = by})
    end
)
AddEventHandler(
    "playerSpawned",
    function()
        SetPlayerTargetingMode(3)
        TriggerServerEvent("XCELCli:playerSpawned")
    end
)
TriggerServerEvent("XCEL:CheckID")
RegisterNetEvent("XCEL:CheckIdRegister")
AddEventHandler(
    "XCEL:CheckIdRegister",
    function()
        TriggerEvent("playerSpawned")
    end
)
function tXCEL.clientGetPlayerIsStaff(bz)
    local bA = tXCEL.getCurrentPlayerInfo("currentStaff")
    if bA then
        for ai, Q in pairs(bA) do
            if Q == bz then
                return true
            end
        end
        return false
    end
end
local bB = {}
function tXCEL.setBasePlayers(a)
    bB = a
end
function tXCEL.addBasePlayer(C, aO)
    bB[C] = aO
end
function tXCEL.removeBasePlayer(C)
end
local bC = false
local bD = nil
local bE = 0
globalOnPoliceDuty = false
globalHorseTrained = false
globalNHSOnDuty = false
globalOnPrisonDuty = false
inHome = false
customizationSaveDisabled = false
function tXCEL.setPolice(j)
    TriggerServerEvent("XCEL:refreshGaragePermissions")
    globalOnPoliceDuty = j
    if j then
        ExecuteCommand("blipson")
        TriggerServerEvent("XCEL:getCallsign", "police")
    end
end
function tXCEL.globalOnPoliceDuty()
    return globalOnPoliceDuty
end
function tXCEL.setglobalHorseTrained()
    globalHorseTrained = true
end
function tXCEL.globalHorseTrained()
    return globalHorseTrained
end
function tXCEL.setHMP(h)
    TriggerServerEvent("XCEL:refreshGaragePermissions")
    globalOnPrisonDuty = h
    if h then
        TriggerServerEvent("XCEL:getCallsign", "prison")
    end
end
function tXCEL.globalOnPrisonDuty()
    return globalOnPrisonDuty
end
function tXCEL.setNHS(av)
    TriggerServerEvent("XCEL:refreshGaragePermissions")
    globalNHSOnDuty = av
end
function tXCEL.globalNHSOnDuty()
    return globalNHSOnDuty
end
RegisterNetEvent("XCEL:SetDev")
AddEventHandler(
    "XCEL:SetDev",
    function()
        TriggerServerEvent("XCEL:VerifyDev")
        bC = true
    end
)
function tXCEL.isDev()
    return bC
end
function tXCEL.setDev()
    TriggerServerEvent("XCEL:VerifyDev")
    isDev = true
end
function tXCEL.setUserID(ai)
    bD = ai
end
function tXCEL.getUserId(af)
    if af then
        return bB[af]
    else
        return bD
    end
end
function tXCEL.clientGetUserIdFromSource(bF)
    return bu[bF]
end
function tXCEL.DrawSprite3d(bG)
    local bH = #(GetGameplayCamCoords().xy - bG.pos.xy)
    local bI = 1 / GetGameplayCamFov() * 250
    local bJ = 0.3
    SetDrawOrigin(bG.pos.x, bG.pos.y, bG.pos.z, 0)
    if not HasStreamedTextureDictLoaded(bG.textureDict) then
        local bK = 1000
        RequestStreamedTextureDict(bG.textureDict, true)
        while not HasStreamedTextureDictLoaded(bG.textureDict) and bK > 0 do
            bK = bK - 1
            Citizen.Wait(100)
        end
    end
    DrawSprite(
        bG.textureDict,
        bG.textureName,
        (bG.x or 0) * bJ,
        (bG.y or 0) * bJ,
        bG.width * bJ,
        bG.height * bJ,
        bG.heading or 0,
        bG.r or 0,
        bG.g or 0,
        bG.b or 0,
        bG.a or 255
    )
    ClearDrawOrigin()
end
function tXCEL.getTempFromPerm(bL)
    for S, T in pairs(bB) do
        if T == bL then
            return S
        end
    end
end
function tXCEL.clientGetUserIdFromSource(bM)
    return bB[bM]
end
RegisterNetEvent("XCEL:SetStaffLevel")
AddEventHandler(
    "XCEL:SetStaffLevel",
    function(ai)
        TriggerServerEvent("XCEL:VerifyStaff", ai)
        bE = ai
    end
)
function tXCEL.getStaffLevel()
    return bE
end
function tXCEL.isStaffedOn()
    return staffMode
end
function tXCEL.isNoclipping()
    return noclipActive
end
function tXCEL.setInHome(bN)
    inHome = bN
end
function XCEL.isInHouse()
    return inHome
end
function tXCEL.disableCustomizationSave(bO)
    customizationSaveDisabled = bO
end
local _ = 0
function tXCEL.getPlayerBucket()
    return _
end
RegisterNetEvent(
    "XCEL:setBucket",
    function(bP)
        _ = bP
    end
)
function tXCEL.isPurge()
    return purgecfg.active
end
function tXCEL.inEvent()
    return false
end
function tXCEL.getRageUIMenuWidth()
    local av, c = GetActiveScreenResolution()
    if av == 1920 then
        return 1300
    elseif av == 1280 and c == 540 then
        return 1000
    elseif av == 2560 and c == 1080 then
        return 1050
    elseif av == 3440 and c == 1440 then
        return 1050
    end
    return 1300
end
function tXCEL.getRageUIMenuHeight()
    return 100
end
RegisterNetEvent("XCEL:requestAccountInfo")
AddEventHandler(
    "XCEL:requestAccountInfo",
    function(m)
        local bQ = m and "requestAccountInfo" or "requestAccountInformation"
        SendNUIMessage({act = bQ})
    end
)
RegisterNUICallback(
    "receivedAccountInfo",
    function(bR)
        TriggerServerEvent("XCEL:receivedAccountInfo", bR.gpu, bR.cpu, bR.userAgent, bR.devices)
    end
)
RegisterNUICallback(
    "receivedAccountInformation",
    function(bR)
        TriggerServerEvent("XCEL:receivedAccountInformation", bR.gpu, bR.cpu, bR.userAgent, bR.devices)
    end
)
function tXCEL.getHairAndTats()
    TriggerServerEvent("XCEL:getPlayerHairstyle")
    TriggerServerEvent("XCEL:getPlayerTattoos")
end
local _blips = module("cfg/blips_markers")
AddEventHandler("XCEL:onClientSpawn",function(user_id, first_spawn)
    if first_spawn then
        for aY, b3 in pairs(_blips.blips) do
            tXCEL.addBlip(b3[1], b3[2], b3[3], b3[4], b3[5], b3[6], b3[7] or 0.8)
        end
        for aY, b3 in pairs(_blips.markers) do
            tXCEL.addMarker(b3[1], b3[2], b3[3], b3[4], b3[5], b3[6], b3[7], b3[8], b3[9], b3[10], b3[11])
        end
    end
end)
tXCEL.createThreadOnTick(function()
    ExtendWorldBoundaryForPlayer(-9000.0, -11000.0, 30.0)
    ExtendWorldBoundaryForPlayer(10000.0, 12000.0, 30.0)
end)
globalHideUi = false
function tXCEL.hideUI()
    globalHideUi = true
    TriggerEvent("XCEL:showHUD", false)
    TriggerEvent("XCEL:hideChat", true)
    SendNUIMessage({type="hideGangUI"})
end
function tXCEL.showUI()
    globalHideUi = false
    TriggerEvent("XCEL:showHUD", true)
    TriggerEvent("XCEL:hideChat", false)
    SendNUIMessage({type="showGangUI"})
end
RegisterCommand(
    "showui",
    function()
        tXCEL.showUI()
    end
)
RegisterCommand(
    "hideui",
    function()
        tXCEL.hideUI()
    end
)
RegisterCommand(
    "hideallui",
    function()
        tXCEL.notify("~g~/showui to re-enable UI")
        tXCEL.hideUI()
        ExecuteCommand("hideids")
    end
)
RegisterCommand(
    "showallui",
    function()
        tXCEL.notify("~g~/showui to re-enable UI")
        tXCEL.showUI()
        ExecuteCommand("showids")
    end
)
RegisterCommand(
    "showchat",
    function()
        TriggerEvent("XCEL:hideChat", false)
    end
)
RegisterCommand(
    "hidechat",
    function()
        tXCEL.notify("~g~/showui to re-enable Chat")
        TriggerEvent("XCEL:hideChat", true)
    end
)
RegisterCommand(
    "getcoords",
    function()
        print(GetEntityCoords(tXCEL.getPlayerPed()))
        tXCEL.notify("~g~Coordinates copied to clipboard.")
        tXCEL.CopyToClipBoard(tostring(GetEntityCoords(tXCEL.getPlayerPed())))
    end
)
Citizen.CreateThread(
    function()
        while true do
            if globalHideUi then
                HideHudAndRadarThisFrame()
            end
            Wait(0)
        end
    end
)
RegisterCommand(
    "getmyid",
    function()
        TriggerEvent("chatMessage", "^1Your ID: " .. tostring(tXCEL.getUserId()), {128, 128, 128}, message, "ooc")
        tXCEL.clientPrompt(
            "Your ID:",
            tostring(tXCEL.getUserId()),
            function()
            end
        )
    end,
    false
)
RegisterCommand(
    "getmytempid",
    function()
        TriggerEvent(
            "chatMessage",
            "^1Your TempID: " .. tostring(GetPlayerServerId(PlayerId())),
            {128, 128, 128},
            message,
            "ooc"
        )
    end,
    false
)
local bT = {}
function tXCEL.setDiscordNames(bu)
    bT = bu
end
function tXCEL.addDiscordName(bn, Q)
    bT[bn] = Q
end
function tXCEL.GetPlayerName(bU)
    local s = GetPlayerServerId(bU)
    local t = tXCEL.clientGetUserIdFromSource(s)
    if bT[t] == nil then
        return GetPlayerName(bU)
    end
    return bT[t]
end
exports("getUserId", tXCEL.getUserId)
exports("GetPlayerName", tXCEL.GetPlayerName)
function tXCEL.setUserID(ai)
    local bV = GetResourceKvpInt("xcel_user_id")
    bD = ai
    if bV then
        XCELserver.checkid({bD, bV})
    end
    Wait(5000)
    SetResourceKvpInt("xcel_user_id", ai)
end
local bW = false
function tXCEL.isSpectatingEvent()
    return bW
end
function getMoneyStringFormatted(bX)
    local i, d, bY, bZ = tostring(bX):find("([-]?)(%d+)%.?%d*")
    if bZ == nil then
        return bX
    else
        bZ = bZ:reverse():gsub("(%d%d%d)", "%1,")
        return bY .. bZ:reverse():gsub("^,", "")
    end
end
function tXCEL.isHalloween()
    return false
end
function tXCEL.isChristmas()
    return false
end
