local function a(b)
    return b == 1 or b == true
end
local c = {[31086] = true}
local d = {
    [40269] = true,
    [28252] = true,
    [24818] = true,
    [45509] = true,
    [61163] = true,
    [10706] = true,
    [65245] = true,
    [63931] = true,
    [57597] = true,
    [58271] = true,
    [51826] = true,
    [36864] = true,
    [24816] = true,
    [24817] = true,
    [24819] = true,
    [14201] = true,
    [52301] = true,
    [18905] = true,
    [57005] = true,
    [39317] = true,
    [64729] = true
}
local e = false
AddEventHandler(
    "XCEL:hsSoundsOn",
    function()
        e = true
    end
)
AddEventHandler(
    "XCEL:hsSoundsOff",
    function()
        e = false
    end
)
local f = false
AddEventHandler(
    "XCEL:codHMSoundsOn",
    function()
        f = true
    end
)
AddEventHandler(
    "XCEL:codHMSoundsOff",
    function()
        f = false
    end
)
DecorRegister("lasthp", 3)
CreateThread(
    function()
        while true do
            Wait(0)
            if not DecorExistOn(PlayerPedId(), "lasthp") then
                DecorSetInt(PlayerPedId(), "lasthp", GetEntityHealth(PlayerPedId()))
            end
        end
    end
)
AddEventHandler(
    "gameEventTriggered",
    function(g, h)
        GameEventTriggered(g, h)
    end
)
function GameEventTriggered(i, j)
    if i == "CEventNetworkEntityDamage" then
        local k = tonumber(j[1])
        local l = tonumber(j[2])
        local m = tonumber(j[6]) == 1 and true or false
        local n = tonumber(j[5])
        local o = tonumber(j[10]) ~= 0 and true or false
        local p = tonumber(j[11])
        local q, r = GetPedLastDamageBone(k)
        local s = nil
        if q then
            s = tonumber(r)
        end
        if m and l == PlayerPedId() and IsEntityAPed(k) and k ~= PlayerPedId() then
            TriggerEvent("XCEL:onPlayerKilledPed", k)
        end
        if k == PlayerPedId() then
            local t = tXCEL.getPedServerId(l)
            if n == 0 then
                n = GetSelectedPedWeapon(l)
            end
            CreateThread(
                function()
                    while not DecorExistOn(PlayerPedId(), "lasthp") do
                        Wait(0)
                    end
                    if DecorExistOn(PlayerPedId(), "lasthp") then
                        local u = m and 0 or GetEntityHealth(k)
                        local v = DecorGetInt(k, "lasthp")
                        if u < v then
                            if c[r] then
                                if t then
                                    TriggerServerEvent("XCEL:syncEntityDamage", u, v, t, true, m, n)
                                end
                            elseif d[r] then
                                if t then
                                    TriggerServerEvent("XCEL:syncEntityDamage", u, v, t, false, m, n)
                                end
                            end
                        end
                        if m then
                            DecorRemove(k, "lasthp")
                        else
                            DecorSetInt(k, "lasthp", u)
                        end
                    end
                end
            )
        end
        if
            tXCEL.getDmgIndcator() and (tXCEL.isPlusClub() or tXCEL.isPlatClub()) and IsEntityAPed(k) and
                k ~= PlayerPedId() and
                l == PlayerPedId()
         then
            local w = math.floor(string.unpack("f", string.pack("i4", tonumber(j[3]))))
            if w == 2 then
                return
            end
            local x, y = tXCEL.getDmgIndcator()
            local z = {
                {200, 0, 0, 255},
                {0, 0, 200, 255},
                {0, 200, 0, 255},
                {242, 172, 185, 255},
                {255, 255, 0, 255},
                {255, 165, 0, 255},
                {128, 0, 128, 255}
            }
            if x then
                local A = 3000
                local B = GetEntityCoords(k)
                Citizen.CreateThread(
                    function()
                        while true do
                            if A >= 0 then
                                tXCEL.DrawText3D(vector3(B.x, B.y, B.z + 0.5), w, 0.5, 4, nil, z[y], true, true)
                                A = A - 10
                            end
                            Wait(0)
                        end
                    end
                )
            end
        end
    end
end

RegisterNetEvent("XCEL:newKillFeed",function(d, e, f, g, h, i, j, headshotKill)
    if GetIsLoadingScreenActive() then
        return
    end
    local k = "other"
    local l = tXCEL.GetPlayerName(tXCEL.getPlayerId())
    if e == l or d == l then
        k = "self"
    end
    local m = GetResourceKvpString("xcel_oldkillfeed") or "false"
    local oldKillfeed = m ~= "false"

    if oldKillfeed and (tXCEL.isPlatClub() or tXCEL.isPlusClub()) then
        if g then
            tXCEL.notify("~o~" .. e .. " ~w~died.")
        elseif headshotKill then
            tXCEL.notify('~o~'..d..' ~w~headshotted ~o~'..e..'~w~.')
        else
            tXCEL.notify("~o~" .. d .. " ~w~killed ~o~" .. e .. "~w~.")
        end
    else
        if c[r] then
            headshotKill = true
        end
        SendNUIMessage({
            type = "addKill",
            victim = e,
            killer = d,
            weapon = f,
            suicide = g,
            victimGroup = i,
            killerGroup = j,
            range = h,
            uuid = tXCEL.generateUUID("kill", 10, "alphabet"),
            category = k,
            isHeadshot = headshotKill
        })
    end
end)

AddEventHandler(
    "entityDamaged",
    function(C, D, n, E)
        local F = PlayerPedId()
        if D == F and C ~= F and IsEntityAPed(C) and GetEntityHealth(C) > 105 and not IsEntityDead(C) then
            Citizen.Wait(0)
            TriggerEvent("XCEL:onPlayerDamagePed", C)
        end
    end
)
CreateThread(
    function()
        RequestScriptAudioBank("DLC_HITMARKERS\\HITMARKERS_ONE")
        while not RequestScriptAudioBank("DLC_HITMARKERS\\HITMARKERS_ONE") do
            Wait(0)
        end
        if not HasStreamedTextureDictLoaded("hitmarker") then
            RequestStreamedTextureDict("hitmarker")
            while not HasStreamedTextureDictLoaded("hitmarker") do
                Wait(0)
            end
        end
    end
)
local A = 0
RegisterNetEvent(
    "XCEL:onEntityHealthChange",
    function(G, u, v, H)
        if f and (tXCEL.isPlusClub() or tXCEL.isPlatClub()) then
            PlaySoundFrontend(-1, "hitmarker", "hitmarkers", false)
            A = 500
        elseif e then
            if H then
                SendNUIMessage({transactionType = "headshot"})
            else
                SendNUIMessage({transactionType = "bodyshot"})
            end
        end
    end
)
CreateThread(
    function()
        while true do
            if A >= 0 then
                DrawSprite("hitmarker", "hitmarker", 0.5, 0.5, 0.0125, 0.02, 0.0, 255, 255, 255, 255)
                HideHudComponentThisFrame(14)
            end
            Wait(0)
        end
    end
)
CreateThread(
    function()
        while true do
            if A >= 0 then
                A = A - 100
            end
            Wait(100)
        end
    end
)
