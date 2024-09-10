local a = false
local b = nil
local c = false
local d = nil
local e = false
local f = false
function tXCEL.isKnockedOut()
    return a
end
function tXCEL.putInNearestVehicleAsPassenger(g)
    local h = tXCEL.getClosestVehicle(g)
    if IsEntityAVehicle(h) then
        for i = 1, math.max(GetVehicleMaxNumberOfPassengers(h), 3) do
            if IsVehicleSeatFree(h, i) then
                SetPedIntoVehicle(tXCEL.getPlayerPed(), h, i)
                return true
            end
        end
    end
    return false
end
function tXCEL.putInNetVehicleAsPassenger(j)
    local h = tXCEL.getObjectId(j)
    if IsEntityAVehicle(h) then
        for i = 1, GetVehicleMaxNumberOfPassengers(h) do
            if IsVehicleSeatFree(h, i) then
                SetPedIntoVehicle(tXCEL.getPlayerPed(), h, i)
                return true
            end
        end
    end
end
function tXCEL.putInVehiclePositionAsPassenger(k, l, m)
    local h = tXCEL.getVehicleAtPosition(k, l, m)
    if IsEntityAVehicle(h) then
        for i = 1, GetVehicleMaxNumberOfPassengers(h) do
            if IsVehicleSeatFree(h, i) then
                SetPedIntoVehicle(tXCEL.getPlayerPed(), h, i)
                return true
            end
        end
    end
end
local n = {{"switch@franklin@bed", "sleep_loop"}, {"switch@trevor@bed", "bed_sleep_floyd"}}
local function o()
    return n[math.random(1, #n)]
end
RegisterNetEvent(
    "XCEL:knockOut",
    function()
        if not a and not tXCEL.isPurge() then
            tXCEL.setCanAnim(false)
            a = true
            b = o()
        end
    end
)
RegisterNetEvent(
    "XCEL:knockOutDisable",
    function()
        if a then
            local p = PlayerPedId()
            SetEntityCollision(p, true, true)
            FreezeEntityPosition(p, false)
            StopAnimTask(p, b[1], b[2], 1.0)
            tXCEL.setCanAnim(true)
            a = false
            b = nil
        end
    end
)
RegisterNetEvent("XCEL:drag")
AddEventHandler(
    "XCEL:drag",
    function(t)
        d = t
        e = not e
    end
)
RegisterNetEvent("XCEL:undrag")
AddEventHandler(
    "XCEL:undrag",
    function(t)
        e = false
    end
)
TriggerEvent(
    "chat:addSuggestion",
    "/s60",
    "Authorise a new Section 60 order",
    {{name = "Radius", help = "In metres"}, {name = "Duration", help = "In Minutes"}}
)
local q = {}
RegisterNetEvent(
    "XCEL:addS60",
    function(r, s, u)
        local v = AddBlipForCoord(r.x, r.y, r.z)
        local w = AddBlipForRadius(r.x, r.y, r.z, s + .0)
        local x = 61
        SetBlipSprite(v, 526)
        SetBlipColour(v, x)
        SetBlipScale(v, 1.0)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Section 60")
        EndTextCommandSetBlipName(v)
        SetBlipAlpha(w, 80)
        SetBlipColour(w, x)
        q[u] = {w, v}
        local y = GetStreetNameAtCoord(r.x, r.y, r.z)
        local z = GetStreetNameFromHashKey(y)
        TriggerEvent(
            "XCEL:showNotification",
            {
                text = "Metropolitan Police: <br/>A Section 60 has been authorised for the area of " ..
                    z ..
                        ".<br/><br/>This gives officers the power to search any person or vehicle in the area, without any grounds. <br/><br/>This has been authorised in line with legislation.",
                height = "auto",
                width = "auto",
                colour = "#FFF",
                background = "#3287cd",
                pos = "bottom-right",
                icon = "success"
            },
            100000
        )
    end
)
RegisterNetEvent(
    "XCEL:removeS60",
    function(u)
        if q[t] == nil then
            return
        else
            local A = q[u]
            local v = A[2]
            local s = A[1]
            RemoveBlip(v)
            RemoveBlip(s)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if e and d ~= nil then
                DisableControlAction(0, 21, true)
                local B = GetPlayerPed(GetPlayerFromServerId(d))
                local C = tXCEL.getPlayerPed()
                AttachEntityToEntity(C, B, 4103, 11816, 0.48, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2)
                f = true
            else
                if f then
                    DetachEntity(tXCEL.getPlayerPed(), true, false)
                    f = false
                end
            end
            if IsControlPressed(0, 323) or IsControlPressed(0, 27) and not IsUsingKeyboard(2) then
                if
                    not globalSurrenderring and not tXCEL.isInComa() and not tXCEL.isHandcuffed() and
                        (tXCEL.canAnim() or tXCEL.isTazedByRevive())
                 then
                    DisablePlayerFiring(tXCEL.getPlayerPed(), true)
                    DisableControlAction(0, 22, true)
                    DisableControlAction(0, 25, true)
                    DisableControlAction(0, 154, true)
                    if not IsEntityDead(tXCEL.getPlayerPed()) then
                        if not c and not GetIsTaskActive(tXCEL.getPlayerPed(), 298) then
                            c = true
                            tXCEL.loadAnimDict("missminuteman_1ig_2")
                            TaskPlayAnim(
                                tXCEL.getPlayerPed(),
                                "missminuteman_1ig_2",
                                "handsup_enter",
                                7.0,
                                1.0,
                                -1,
                                50,
                                0,
                                false,
                                false,
                                false
                            )
                            RemoveAnimDict("missminuteman_1ig_2")
                        end
                    end
                end
            end
            if
                (IsControlJustReleased(1, 323) or IsControlJustReleased(1, 27)) and not globalSurrenderring and c and
                    not tXCEL.isInComa() and
                    not tXCEL.isHandcuffed() and
                    tXCEL.canAnim()
             then
                c = false
                CreateThread(
                    function()
                        local D = false
                        CreateThread(
                            function()
                                Wait(1000)
                                D = true
                            end
                        )
                        while not D do
                            DisablePlayerFiring(tXCEL.getPlayerPed(), true)
                            Wait(1)
                        end
                    end
                )
                DisableControlAction(0, 21, true)
                DisableControlAction(0, 137, true)
                ClearPedTasks(tXCEL.getPlayerPed())
            end
            if a then
                if tXCEL.isStaffedOn() then
                    TriggerEvent("XCEL:knockOutDisable")
                elseif not tXCEL.isInComa() then
                    local p = PlayerPedId()
                    if not IsEntityPlayingAnim(p, b[1], b[2], 3) then
                        tXCEL.loadAnimDict(b[1])
                        local r = GetEntityCoords(p, true)
                        SetEntityCollision(p, false, false)
                        FreezeEntityPosition(p, true)
                        local E, I = GetGroundZFor_3dCoord(r.x, r.y, r.z)
                        if E then
                            r = vector3(r.x, r.y, I + 0.3)
                        end
                        TaskPlayAnimAdvanced(p, b[1], b[2], r.x, r.y, r.z, 0.0, 0.0, 0.0, 3.0, 1.0, -1, 1, 0.0, 0, 0)
                        RemoveAnimDict(b[1])
                    end
                    tXCEL.notify("~r~You have been knocked out!")
                end
            end
            Wait(0)
        end
    end
)
RMenu.Add(
    "policehandbook",
    "main",
    RageUI.CreateMenu("Police Handbook", "~b~Officer Handbook", tXCEL.getRageUIMenuWidth(), tXCEL.getRageUIMenuHeight())
)
RageUI.CreateWhile(
    1.0,
    true,
    function()
        RageUI.IsVisible(
            RMenu:Get("policehandbook", "main"),
            true,
            true,
            true,
            function()
                RageUI.Button(
                    "Arrest",
                    nil,
                    {},
                    function(F, G, H)
                        if H then
                            TriggerEvent(
                                "XCEL:showNotification",
                                {
                                    text = "The time now is ___. <br/>You are currently under arrest on suspision of ___. <br/>You do not have to say anything. But, it may harm your defence if you do not mention when questioned something which you later rely on in court. <br/>Anything you do say may be given in evidence. <br/>Do you understand?. <br/>The necessities for your arrest are to ___.",
                                    height = "auto",
                                    width = "auto",
                                    colour = "#FFF",
                                    background = "#3287cd",
                                    pos = "bottom-right",
                                    icon = "success"
                                },
                                100000
                            )
                        end
                    end
                )
                RageUI.Button(
                    "Search - GOWISELY",
                    nil,
                    {},
                    function(F, G, H)
                        if H then
                            TriggerEvent(
                                "XCEL:showNotification",
                                {
                                    text = "Before you stop and search someone you must remember GO-WISELY. <br/>You do not have to use this after arrest. <br/>Grounds: for the search. <br/>Object: of the search. <br/>Warrant card: If not in uniform. <br/>Identity: I am PC ___. <br/>Station: attached to ___ Police Station. <br/>Entitlement: Entitled to a copy of this search up to ___ months. <br/>Legal power: Searching under s1 PACE (1984) / s23 MODA (1971). <br/>You: You are currently detained for the purpose of a search.",
                                    height = "auto",
                                    width = "auto",
                                    colour = "#FFF",
                                    background = "#3287cd",
                                    pos = "bottom-right",
                                    icon = "success"
                                },
                                100000
                            )
                        end
                    end
                )
                RageUI.Button(
                    "PACE - Key Legislation",
                    nil,
                    {},
                    function(F, G, H)
                        if H then
                            TriggerEvent(
                                "XCEL:showNotification",
                                {
                                    text = "Police and Criminal Evidence Act 1984  - PACE.<br/> Section 1 - Stop and search (Stolen property, prohibited articles, weapons, articles used to commit an offence.<br/>Section 17 - Entry for the purpose of life and arrest<br/> Section 18 - Entry to search after an arrest <br/>Section 19 - Power of seizure<br/> Section 24 - Power of arrest <br/> Section 32 - Search after an arrest",
                                    height = "auto",
                                    width = "auto",
                                    colour = "#FFF",
                                    background = "#3287cd",
                                    pos = "bottom-right",
                                    icon = "success"
                                },
                                100000
                            )
                        end
                    end
                )
                RageUI.Button(
                    "Identify Codes",
                    nil,
                    {},
                    function(F, G, H)
                        if H then
                            TriggerEvent(
                                "XCEL:showNotification",
                                {
                                    text = "IC1:~s~ White - North European. <br/>IC2: White - South European. <br/>IC3: Black. <br/>IC4: Asian. <br/>IC5: Chinese, Japanese or other South East Asian. <br/>IC6: Arabic or North African. <br/>IC9: Unknown",
                                    height = "auto",
                                    width = "auto",
                                    colour = "#FFF",
                                    background = "#3287cd",
                                    pos = "bottom-right",
                                    icon = "success"
                                },
                                100000
                            )
                        end
                    end
                )
                RageUI.Button(
                    "Traffic Offence Report",
                    nil,
                    {},
                    function(F, G, H)
                        if H then
                            TriggerEvent(
                                "XCEL:showNotification",
                                {
                                    text = "I am reporting you for consideration of the question of prosecuting you for the offence(s) of ___. <br/><br/>You do not have to say anything but it may harm your defence if you do not mention NOW something which you may later rely on in court. Anything you do say may be given in evidence. <br/><br/>You are not under arrest - you are entitled to legal advice and you are not obliged to remain with me.",
                                    height = "auto",
                                    width = "auto",
                                    colour = "#FFF",
                                    background = "#3287cd",
                                    pos = "bottom-right",
                                    icon = "success"
                                },
                                100000
                            )
                        end
                    end
                )
                RageUI.Button(
                    "Initial Phase Pursuit",
                    nil,
                    {},
                    function(F, G, H)
                        if H then
                            TriggerEvent(
                                "XCEL:showNotification",
                                {
                                    text = "VEHICLE DESCRIPTION: MAKE/MODEL/VRM. <br/>LOCATION & DIRECTION: ___. <br/>SPEED: ___. <br/>VEHICLE DENSITY: LOW/MED/HIGH. <br/>PEDESTRIAN DENSITY: LOW/MED/HIGH. <br/>ROAD CONDITIONS: WET/DRY/DIRT. <br/>WEATHER: CLEAR/LIGHT/DARK. <br/>VISIBILITY: CLEAR/MED/LOW. <br/>DRIVER CLASSIFICATION: IPP/ADV/TPAC. <br/>POLICE VEHICLE: MARKED/UNMARKED",
                                    height = "auto",
                                    width = "auto",
                                    colour = "#FFF",
                                    background = "#3287cd",
                                    pos = "bottom-right",
                                    icon = "success"
                                },
                                100000
                            )
                        end
                    end
                )
                RageUI.Button(
                    "Warning Markers",
                    nil,
                    {},
                    function(F, G, H)
                        if H then
                            TriggerEvent(
                                "XCEL:showNotification",
                                {
                                    text = "FI: FIREARMS. <br/>WE: WEAPONS. <br/>XP: EXPLOSIVES. <br/>VI: VIOLENT. <br/>CO: CONTAGIOUS. <br/>ES: ESCAPER. <br/>AG: ALLEGES. <br/>AT: AILMENT. <br/>SU: SUICIDAL. <br/>MH: MENTAL HEALTH. <br/>DR: DRUGS. <br/>IM: MALE IMPERSONATOR. <br/>IF: FEMALE IMPERSONATOR",
                                    height = "auto",
                                    width = "auto",
                                    colour = "#FFF",
                                    background = "#3287cd",
                                    pos = "bottom-right",
                                    icon = "success"
                                },
                                100000
                            )
                        end
                    end
                )
                RageUI.Button(
                    "s136 - Mental Healt Act",
                    nil,
                    {},
                    function(F, G, H)
                        if H then
                            TriggerEvent(
                                "XCEL:showNotification",
                                {
                                    text = "A constable may take a person to (or keep at) a place of a safety. <br/>This can be done without a warrant if: The individual appears to have a mental disorder, and they are in any place other than a house, flat or room where a person is living, or garden or garage that only one household has access to, and they are in need of immediate care or control. <br/><br/>A registered medical practitioner/healthcare professional must be consulted if practicable to do so.",
                                    height = "auto",
                                    width = "auto",
                                    colour = "#FFF",
                                    background = "#3287cd",
                                    pos = "bottom-right",
                                    icon = "success"
                                },
                                100000
                            )
                        end
                    end
                )
                RageUI.Button(
                    "Arrest Necessities",
                    nil,
                    {},
                    function(F, G, H)
                        if H then
                            TriggerEvent(
                                "XCEL:showNotification",
                                {
                                    text = "You require at least two of the following necessities to arrest a suspect: <br/><br/>Investigation: conduct a prompt and effective. <br/>Disappearance: prevent the prosecution being hindered. <br/>Child or Vulnerable person: to protect a. <br/>Obstruction: of the highway unlawfully (preventing). <br/>Physical Injury: prevent to themselves or other person. <br/>Public Decency: prevent an offence being committed against. <br/>Loss or Damage: prevent to property. <br/>Address: enable to be ascertained (not readily available). <br/>Name: enable to be ascertained (not readily available).",
                                    height = "auto",
                                    width = "auto",
                                    colour = "#FFF",
                                    background = "#3287cd",
                                    pos = "bottom-right",
                                    icon = "success"
                                },
                                100000
                            )
                        end
                    end
                )
            end,
            function()
            end
        )
    end
)
TriggerEvent("chat:addSuggestion", "/handbook", "Toggle the Police Handbook")
RegisterNetEvent(
    "XCEL:toggleHandbook",
    function()
        RageUI.Visible(RMenu:Get("policehandbook", "main"), true)
    end
)
RegisterNetEvent(
    "playBreathalyserSound",
    function(r)
        Citizen.SetTimeout(
            10000,
            function()
                local J = tXCEL.getPlayerCoords()
                local K = #(J - r)
                if K <= 15 then
                    SendNUIMessage({transactionType = "breathalyser"})
                end
            end
        )
    end
)
TriggerEvent("chat:addSuggestion", "/breathalyse", "Breathalyse the nearest person")
RegisterNetEvent(
    "XCEL:breathTestResult",
    function(L, M)
        local N = M
        RequestAnimDict("weapons@first_person@aim_rng@generic@projectile@shared@core")
        while not HasAnimDictLoaded("weapons@first_person@aim_rng@generic@projectile@shared@core") do
            Wait(0)
        end
        TaskPlayAnim(
            tXCEL.getPlayerPed(),
            "weapons@first_person@aim_rng@generic@projectile@shared@core",
            "idlerng_med",
            1.0,
            -1,
            10000,
            50,
            0,
            false,
            false,
            false
        )
        RageUI.Text({message = "~w~You are now ~b~breathalysing ~b~" .. I .. "~w~, please wait for the results."})
        Citizen.SetTimeout(
            10000,
            function()
                if L < 36 then
                    RageUI.Text(
                        {
                            message = "~w~The suspect has provided a legal breathalyser sample of ~b~" ..
                                L .. " ~w~µg/100ml."
                        }
                    )
                else
                    RageUI.Text(
                        {
                            message = "~w~The suspect has provided an illegal breathalyser sample of ~b~" ..
                                L .. " ~w~µg/100ml."
                        }
                    )
                end
            end
        )
    end
)
RegisterNetEvent(
    "XCEL:beingBreathalysed",
    function()
        RageUI.Text({message = "~w~You are currently being ~b~breathalysed ~w~by a police officer."})
    end
)
RegisterNetEvent(
    "XCEL:breathalyserCommand",
    function()
        local B = tXCEL.getPlayerPed()
        if not IsPedInAnyVehicle(B, true) then
            local r = GetEntityCoords(B)
            local O = GetActivePlayers()
            for P, Q in pairs(O) do
                if GetPlayerPed(Q) ~= B then
                    local R = GetEntityCoords(GetPlayerPed(Q))
                    local S = #(r - R)
                    if S < 3.0 then
                        local T = GetPlayerServerId(Q)
                        TriggerServerEvent("XCEL:breathalyserRequest", T)
                        break
                    end
                end
            end
        end
    end
)
TriggerEvent("chat:addSuggestion", "/wc", "Flash your police warrant card.")
TriggerEvent("chat:addSuggestion", "/wca", "Flash your police warrant card anonymously.")
RegisterNetEvent(
    "XCEL:flashWarrantCard",
    function()
        local B = PlayerPedId()
        local U = tXCEL.loadModel("prop_fib_badge")
        local V = CreateObject(U, 0, 0, 0, true, true, true)
        while not DoesEntityExist(V) do
            Wait(0)
        end
        SetModelAsNoLongerNeeded(U)
        FreezeEntityPosition(V)
        AttachEntityToEntity(
            V,
            B,
            GetPedBoneIndex(B, 58866),
            0.03,
            -0.05,
            -0.044,
            0.0,
            90.0,
            25.0,
            true,
            true,
            false,
            true,
            1,
            true
        )
        Wait(3000)
        DeleteObject(V)
    end
)
RegisterNetEvent(
    "XCEL:startSearchingSuspect",
    function()
        tXCEL.setCanAnim(false)
        tXCEL.loadAnimDict("custom@police")
        TaskPlayAnim(PlayerPedId(), "custom@police", "police", 8.0, 8.0, -1, 0, 0.0, false, false, false)
        RemoveAnimDict("custom@police")
        local W = GetGameTimer()
        while GetGameTimer() - W < 5000 do
            if IsDisabledControlJustPressed(0, 73) then
                TriggerServerEvent("XCEL:cancelPlayerSearch")
                return
            end
            Citizen.Wait(0)
        end
        tXCEL.setCanAnim(true)
    end
)
local X = false
RegisterNetEvent(
    "XCEL:startBeingSearching",
    function(Y)
        local Z = GetPlayerFromServerId(Y)
        if Z == -1 then
            return
        end
        local _ = GetPlayerPed(Z)
        if _ == 0 then
            return
        end
        X = true
        tXCEL.setCanAnim(false)
        tXCEL.loadAnimDict("custom@suspect")
        local p = tXCEL.getPlayerPed()
        AttachEntityToEntity(p, _, -1, -0.05, 0.5, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, false)
        TaskPlayAnim(p, "custom@suspect", "suspect", 8.0, 8.0, -1, 2, 0.0, false, false, false)
        RemoveAnimDict("custom@suspect")
        local W = GetGameTimer()
        while GetGameTimer() - W < 10000 do
            if not X then
                return
            end
            Citizen.Wait(0)
        end
        X = false
        tXCEL.setCanAnim(true)
        DetachEntity(p)
        ClearPedTasks(p)
    end
)
RegisterNetEvent(
    "XCEL:cancelPlayerSearch",
    function()
        X = false
        tXCEL.setCanAnim(true)
        local p = tXCEL.getPlayerPed()
        DetachEntity(p)
        ClearPedTasks(p)
    end
)
local a0 = ""
local a1 = ""
local a2 = ""
local a3 = false
local a4 = ""
local a5 = ""
local a6 = ""
local a7 = false
RegisterNetEvent(
    "XCEL:receivePoliceCallsign",
    function(a8, a9, aa)
        a0 = a9
        a1 = a8
        a2 = aa
        a3 = true
        if a1 then
            print("Your PD rank is: " .. a0 .. "\nYour callsign is: " .. a1)
        else
            print("Unable to fetch your callsign, You are required to have a callsign in the discord.")
        end
    end
)
RegisterNetEvent(
    "XCEL:receiveHmpCallsign",
    function(a8, a9, aa)
        a4 = a9
        a5 = a8
        a6 = aa
        a7 = true
        print("Your HMP rank is: " .. a6 .. "\nYour callsign is: " .. a5)
    end
)
function tXCEL.getPoliceCallsign()
    return a1
end
function tXCEL.getPoliceRank()
    return a0
end
function tXCEL.getPoliceName()
    return a2
end
function tXCEL.hasPoliceCallsign()
    return a3
end
function tXCEL.getHmpCallsign()
    return a5
end
function tXCEL.getHmpRank()
    return a4
end
function tXCEL.getHmpName()
    return a6
end
function tXCEL.hasHmpCallsign()
    return a7
end
function func_drawCallsign()
    if not globalHideUi then
        if a1 ~= "" and globalOnPoliceDuty then
            DrawAdvancedText(1.064, 0.972, 0.005, 0.0028, 0.4, a1, 255, 255, 255, 255, 0, 0)
        end
        if a5 ~= "" and globalOnPrisonDuty then
            DrawAdvancedText(1.064, 0.972, 0.005, 0.0028, 0.4, a5, 255, 255, 255, 255, 0, 0)
        end
    end
end
tXCEL.createThreadOnTick(func_drawCallsign)
local ab = 0
local function ac()
    local p = tXCEL.getPlayerPed()
    if IsPedShooting(p) then
        local ad = GetSelectedPedWeapon(p)
        local ae, af = GetMaxAmmo(p, ad)
        local ag = GetWeapontypeGroup(ad)
        if af >= 1 and ag ~= GetHashKey("GROUP_MELEE") and ag ~= GetHashKey("GROUP_THROWN") then
            ab = GetGameTimer()
        end
    end
end
tXCEL.createThreadOnTick(ac)
function tXCEL.hasRecentlyShotGun()
    return ab ~= 0 and GetGameTimer() - ab < 600000
end
AddEventHandler(
    "XCEL:onClientSpawn",
    function()
        ab = 0
    end
)
RMenu.Add(
    "trainingWorlds",
    "mainmenu",
    RageUI.CreateMenu("Training Worlds", "Main Menu", tXCEL.getRageUIMenuWidth(), tXCEL.getRageUIMenuHeight())
)
local ah = {}
local ai = false
RegisterNetEvent(
    "XCEL:trainingWorldOpen",
    function(aj)
        ai = aj
        RageUI.Visible(RMenu:Get("trainingWorlds", "mainmenu"), true)
    end
)
RageUI.CreateWhile(
    1.0,
    true,
    function()
        RageUI.IsVisible(
            RMenu:Get("trainingWorlds", "mainmenu"),
            true,
            true,
            true,
            function()
                local ak = false
                for u, al in pairs(ah) do
                    local am = string.format("Created by %s (%s) - Bucket %s", al.ownerName, al.ownerUserId, al.bucket)
                    local an = al.bucket == tXCEL.getPlayerBucket()
                    local ao = an and {RightLabel = "(Joined)"} or {}
                    RageUI.ButtonWithStyle(
                        al.name,
                        am,
                        ao,
                        true,
                        function(F, G, H)
                            if G and ai then
                                drawNativeNotification("Press ~INPUT_FRONTEND_DELETE~ to delete this world")
                                if IsControlJustPressed(0, 214) then
                                    TriggerServerEvent("XCEL:trainingWorldRemove", u)
                                end
                            end
                            if H then
                                TriggerServerEvent("XCEL:trainingWorldJoin", u)
                            end
                        end
                    )
                    if an then
                        ak = an
                    end
                end
                if ak then
                    RageUI.ButtonWithStyle(
                        "~r~Leave Training World",
                        nil,
                        {},
                        true,
                        function(F, G, H)
                            if H then
                                TriggerServerEvent("XCEL:trainingWorldLeave")
                            end
                        end
                    )
                end
                if ai then
                    RageUI.ButtonWithStyle(
                        "~b~Create Training World",
                        nil,
                        {},
                        true,
                        function(F, G, H)
                            if H then
                                TriggerServerEvent("XCEL:trainingWorldCreate")
                            end
                        end
                    )
                end
            end,
            function()
            end
        )
    end
)
RegisterNetEvent(
    "XCEL:trainingWorldSend",
    function(u, ap)
        ah[u] = ap
    end
)
RegisterNetEvent(
    "XCEL:trainingWorldSendAll",
    function(ap)
        ah = ap
    end
)
RegisterNetEvent(
    "XCEL:trainingWorldRemove",
    function(u)
        ah[u] = nil
    end
)
function tXCEL.canBeCuffed()
    return tXCEL.isPlayerSurrenderedNoProgressBar(), tXCEL.isHandcuffed() or tXCEL.isPedBeingTackled() or tXCEL.isTazed()
end
