local a = {active = false, spawnedDecks = false, coords = vector3(0, 0, 0), handles = {}}
local b = {volume = 100}
local c = {}
local d = 0
local e = vector3(0.0, 0.0, 0.0)
local f = 0
local g = false
local h = false
local i = {}
local j = {{"Big Cone", "prop_roadcone01a"}}
RMenu.Add(
    "XCELDJ",
    "main",
    RageUI.CreateMenu("", "DJ Mixer", tXCEL.getRageUIMenuWidth(), tXCEL.getRageUIMenuHeight(), "xcel_musicui", "xcel_musicui")
)
RMenu.Add(
    "XCELDJ",
    "admin",
    RageUI.CreateSubMenu(
        RMenu:Get("XCELDJ", "main"),
        "",
        "DJ Admin Menu",
        tXCEL.getRageUIMenuWidth(),
        tXCEL.getRageUIMenuHeight(),
        "xcel_musicui",
        "xcel_musicui"
    )
)
TriggerEvent("chat:addSuggestion", "/play", "Play a song on the DJ Mixer", {{name = "URL", help = "Video ID"}})
TriggerEvent("chat:addSuggestion", "/djmenu", "Toggle the DJ Mixer")
TriggerEvent("chat:addSuggestion", "/djadmin", "Administrate the use of the DJ Mixer")
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("XCELDJ", "main")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if inOrganHeist then
                        return
                    elseif not a.active then
                        if h then
                            RageUI.Button(
                                "Start Session",
                                "Start a new DJ Session",
                                {RightLabel = "→→→"},
                                true,
                                function(k, l, m)
                                    if m then
                                        if
                                            tXCEL.getPlayerCombatTimer() == 0 and not tXCEL.isPlayerInRedZone() and
                                                tXCEL.getPlayerVehicle() == 0
                                         then
                                            setupDj()
                                        else
                                            tXCEL.notify("You can not set up a DJ deck right now.")
                                        end
                                    end
                                end
                            )
                        end
                    else
                        RageUI.SliderProgress(
                            "Song Volume",
                            b.volume,
                            100,
                            "Select or update the song volume",
                            {
                                ProgressBackgroundColor = {R = 0, G = 0, B = 0, A = 255},
                                ProgressColor = {R = 0, G = 117, B = 194, A = 255}
                            },
                            true,
                            function(n, o, p, q)
                                if o then
                                    if q ~= b.volume then
                                        b.volume = q
                                        if b.volume % 10 == 0 or b.volume == 1 then
                                            updateVolume()
                                        end
                                        drawNativeText("DJ~w~: Volume Updated")
                                    end
                                end
                                b.volume = q
                            end
                        )
                        RageUI.Button(
                            "Skip Ahead",
                            "Skip 20 seconds ahead",
                            {},
                            true,
                            function(n, p, o)
                                if o then
                                    skipDj(true)
                                    drawNativeText("DJ~w~: Song Skipped")
                                end
                            end
                        )
                        RageUI.Button(
                            "Skip Back",
                            "Skip 20 seconds back",
                            {},
                            true,
                            function(n, p, o)
                                if o then
                                    skipDj(false)
                                    drawNativeText("DJ~w~: Song Skipped")
                                end
                            end
                        )
                        RageUI.Button(
                            "Stop Song",
                            "Stop the current song",
                            {},
                            true,
                            function(n, p, o)
                                if o then
                                    stopDjSong()
                                    drawNativeText("DJ~w~: Song Stopped")
                                end
                            end
                        )
                        RageUI.Button(
                            "End Session",
                            "Stop the current DJ Session",
                            {},
                            true,
                            function(n, p, o)
                                if o then
                                    stopDj()
                                    drawNativeText("DJ~w~: Session Ended")
                                end
                            end
                        )
                        RageUI.Button(
                            "Help",
                            "Assistance message",
                            {},
                            true,
                            function(n, p, o)
                                if o then
                                    TriggerEvent(
                                        "XCEL:showNotification",
                                        {
                                            text = "Use /play, The Video ID is the ID at the end of the YouTube URL after =",
                                            height = "200px",
                                            width = "auto",
                                            colour = "#FFF",
                                            background = "#32CD32",
                                            pos = "bottom-right",
                                            icon = "success"
                                        },
                                        5000
                                    )
                                end
                            end
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("XCELDJ", "admin")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if table.count(i) > 0 then
                        for r, s in pairs(i) do
                            if i[r] ~= nil then
                                local t = round2(#(tXCEL.getPlayerCoords() - s[2]), 2)
                                RageUI.ButtonWithStyle(
                                    "ID: " .. s[3] .. " - Started: " .. s[5] .. "",
                                    "Name: " .. s[4] .. " Distance Away: " .. t .. " metres",
                                    {RightLabel = "→→→"},
                                    true,
                                    function(n, p, o)
                                        if o then
                                            TriggerServerEvent("XCEL:adminStopSong", s[1])
                                        end
                                    end
                                )
                            end
                        end
                    end
                end
            )
        end
    end
)
function round2(u, v)
    return math.floor(u * math.pow(10, v) + 0.5) / math.pow(10, v)
end
RegisterNetEvent("XCEL:playDjSong")
AddEventHandler(
    "XCEL:playDjSong",
    function(w, coords, x, y)
        local z = tXCEL.getPlayerCoords()
        local A = #(coords - z)
        if A < 30.0 then
            SendNUIMessage({type = "djPlay", song = w, volume = 90})
            drawNativeText("DJ " .. y .. "~w~: New Song playing")
            for r, s in pairs(c) do
                if s[1] == coords then
                    c[r] = nil
                end
            end
            c[x] = {coords, w, true}
        else
            c[x] = {coords, w, false}
        end
    end
)

RegisterNetEvent("XCEL:requestCurrentProgress")
AddEventHandler(
    "XCEL:requestCurrentProgress",
    function(w, coords)
        SendNUIMessage({type = "requestProgress"})
        if not g then
            if specificSongPlaying(coords) then
                d = w
                e = coords
                SendNUIMessage({type = "requestProgress"})
            end
        end
    end
)
RegisterNetEvent("XCEL:toggleDjMenu")
AddEventHandler(
    "XCEL:toggleDjMenu",
    function()
        RageUI.Visible(RMenu:Get("XCELDJ", "main"), true)
        h = true
    end
)
RegisterNetEvent("XCEL:toggleDjAdminMenu")
AddEventHandler(
    "XCEL:toggleDjAdminMenu",
    function(B)
        RageUI.Visible(RMenu:Get("XCELDJ", "admin"), true)
        i = B
    end
)
RegisterNetEvent("XCEL:finaliseSong")
AddEventHandler(
    "XCEL:finaliseSong",
    function(C)
        if a.active then
            TriggerServerEvent("XCEL:playDjSongServer", C, a.coords)
        end
    end
)
RegisterNetEvent("XCEL:updateDjVolume")
AddEventHandler(
    "XCEL:updateDjVolume",
    function(coords, D)
        if specificSongPlaying(coords) then
            SendNUIMessage({type = "djVolume", volume = D})
        end
    end
)
RegisterNetEvent("XCEL:stopSong")
AddEventHandler(
    "XCEL:stopSong",
    function(coords)
        local E = false
        for r, s in pairs(c) do
            if s[1] == coords then
                E = true
                c[r] = nil
            end
        end
        if E then
            SendNUIMessage({type = "djStop"})
        end
    end
)
RegisterNetEvent("XCEL:skipDj")
AddEventHandler(
    "XCEL:skipDj",
    function(coords, F)
        if specificSongPlaying(coords) then
            if F then
                SendNUIMessage({type = "djSkipAhead"})
            else
                SendNUIMessage({type = "djSkipBack"})
            end
        end
    end
)
function skipDj(F)
    if songPlaying() then
        TriggerServerEvent("XCEL:skipServer", a.coords, F)
    end
end
function setupDj()
    a.active = true
    a.coords = tXCEL.getPlayerCoords()
    a.spawnedDecks = true
    createDjObject(0.0, 1.5, 0.0, "ba_prop_battle_dj_stand", 0.0)
    createDjObject(-1.5, 1.5, 0.0, "ba_prop_battle_club_speaker_large", 180.0)
    createDjObject(1.5, 1.5, 0.0, "ba_prop_battle_club_speaker_large", 180.0)
    createDjObject(0.0, -1.2, 0.0, "prop_studio_light_01", 180.0)
end
function createDjObject(G, H, I, J, K)
    local J = tXCEL.loadModel(J)
    coords = GetOffsetFromEntityInWorldCoords(tXCEL.getPlayerPed(), G, H, I)
    local L = CreateObject(J, coords.x, coords.y, coords.z, true, true, true)
    table.insert(a.handles, L)
    PlaceObjectOnGroundProperly(L)
    FreezeEntityPosition(L, true)
    local M = GetEntityHeading(tXCEL.getPlayerPed())
    SetEntityHeading(L, M + K)
end
function stopDj()
    if songPlaying() then
        TriggerServerEvent("XCEL:stopSongServer", a.coords)
    end
    a.active = false
    a.spawnedDecks = false
    for r in pairs(a.handles) do
        DeleteObject(a.handles[r])
    end
    a.handles = {}
end
function stopDjSong()
    if songPlaying() then
        TriggerServerEvent("XCEL:stopSongServer", a.coords)
    end
end
function updateVolume()
    if songPlaying() then
        TriggerServerEvent("XCEL:updateVolumeServer", a.coords, b.volume)
    end
end
function specificSongPlaying(coords)
    local E = false
    for r, s in pairs(c) do
        if s[1] == coords and s[3] then
            E = true
        end
    end
    return E
end
function songPlaying()
    local E = false
    for r, s in pairs(c) do
        if s[1] == a.coords then
            E = true
        end
    end
    return E
end
function func_checkDjSongs(N)
    for r, s in pairs(c) do
        if #(N.playerCoords - s[1]) > 45.0 then
            c[r][3] = false
            SendNUIMessage({type = "djStop"})
        else
            if not c[r][3] then
                g = true
                TriggerServerEvent("XCEL:requestCurrentProgressServer", r, s[1])
                c[r][3] = true
            end
        end
    end
end
tXCEL.createThreadOnTick(func_checkDjSongs)
RegisterNUICallback(
    "returnProgress",
    function(O, P)
        if O.progress ~= nil then
            if O.progress ~= 0 then
                TriggerServerEvent("XCEL:returnProgressServer", d, e, O.progress)
            end
        end
        P("return")
    end
)
RegisterNetEvent("XCEL:returnProgress")
AddEventHandler(
    "XCEL:returnProgress",
    function(w, coords, Q, R)
        if g then
            if specificSongPlaying(coords) then
                c[w] = nil
                c[w] = {coords, w, true}
                SendNUIMessage({type = "djPlay", song = R, volume = 90})
                Wait(1000)
                SendNUIMessage({type = "skipTo", time = Q})
                g = false
            end
        end
    end
)
