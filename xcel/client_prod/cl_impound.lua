local a = module("cfg/cfg_impound")
local b = {owner_id = 0, owner_name = "", vehicle = "", vehicle_name = ""}
local c = {}
Citizen.CreateThread(
    function()
        for d, e in pairs(a.peds) do
            tXCEL.createDynamicPed(e.modelHash, e.position, e.heading, true, e.animDict, e.animName, 30, false, false)
            tXCEL.addBlip(e.position.x, e.position.y, e.position.z, 357, 81, "Vehicle Impound", 0.8, false)
        end
        Wait(2000)
        local f = function()
            TriggerServerEvent("XCEL:getImpoundedVehicles")
            RageUI.Visible(RMenu:Get("xcelimpound", "main"), true)
        end
        local g = function()
            RageUI.ActuallyCloseAll()
        end
        local h = function()
        end
        for d, e in pairs(a.peds) do
            tXCEL.createArea("vehicle_impound_" .. d, e.position, 3.0, 6, f, g, h, {})
        end
    end
)
RMenu.Add(
    "xcelimpound",
    "reasons",
    RageUI.CreateMenu(
        "",
        "~b~Impounding Vehicle...",
        tXCEL.getRageUIMenuWidth(),
        tXCEL.getRageUIMenuHeight(),
        "xcel_jobselectorui",
        "metpd"
    )
)
RMenu.Add(
    "xcelimpound",
    "main",
    RageUI.CreateMenu(
        "",
        "~b~Your Impounded Vehicles",
        tXCEL.getRageUIMenuWidth(),
        tXCEL.getRageUIMenuHeight(),
        "xcel_jobselectorui",
        "metpd"
    )
)
RMenu.Add("xcelimpound", "vehicle_information", RageUI.CreateSubMenu(RMenu:Get("xcelimpound", "main")))
RMenu.Add("xcelimpound", "pay_fine_confirmation", RageUI.CreateSubMenu(RMenu:Get("xcelimpound", "vehicle_information")))
local i = 0
RageUI.CreateWhile(
    1.0,
    true,
    function()
        RageUI.BackspaceMenuCallback(
            function()
                resetChecked()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("xcelimpound", "reasons"),
            true,
            true,
            true,
            function()
                RageUI.Separator("Vehicle: ~b~" .. b.vehicle_name .. "~s~ | Owner: ~b~" .. b.owner_name)
                for j = 1, #a.reasonsForImpound do
                    RageUI.Checkbox(
                        a.reasonsForImpound[j].option,
                        "",
                        a.reasonsForImpound[j].checked,
                        {Style = 1},
                        function(k, l, d, m)
                            if l then
                                a.reasonsForImpound[j].checked = m
                            end
                        end
                    )
                end
                RageUI.ButtonWithStyle(
                    "~g~Confirm Selection",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(k, d, l)
                        if l then
                            local n = {}
                            for j, o in ipairs(a.reasonsForImpound) do
                                if o.checked then
                                    table.insert(n, j)
                                    o.checked = false
                                end
                            end
                            TriggerServerEvent(
                                "XCEL:impoundVehicle",
                                b.owner_id,
                                b.owner_name,
                                b.vehicle,
                                b.vehicle_name,
                                n,
                                b.vehicle_net_id
                            )
                            RageUI.ActuallyCloseAll()
                        end
                    end,
                    function()
                    end
                )
                RageUI.ButtonWithStyle(
                    "~r~Cancel",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(k, d, l)
                        if l then
                            RageUI.ActuallyCloseAll()
                        end
                    end,
                    function()
                    end
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("xcelimpound", "main"),
            true,
            true,
            true,
            function()
                RageUI.Separator("View your impounded vehicles here.")
                RageUI.Separator(
                    "You can pay the ~g~£" ..
                        getMoneyStringFormatted(a.impoundPrice) .. "~s~ fine to release your vehicle."
                )
                RageUI.Separator("---")
                if c ~= nil and c ~= {} then
                    for p, q in pairs(c) do
                        RageUI.ButtonWithStyle(
                            q.vehicle_name,
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(k, d, l)
                                if l then
                                    i = q
                                end
                            end,
                            RMenu:Get("xcelimpound", "vehicle_information")
                        )
                    end
                else
                    RageUI.Separator("~r~None of your vehicles are currently impounded.")
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("xcelimpound", "vehicle_information"),
            true,
            true,
            true,
            function()
                if i ~= 0 then
                    RageUI.Separator(i.vehicle_name)
                    RageUI.Separator(
                        "This vehicle was impounded by ~b~" ..
                            i.impounded_by_name .. " (ID: " .. i.impounder .. ") ~s~for:"
                    )
                    local r = i.reasons
                    for j, o in ipairs(r) do
                        RageUI.Separator("» " .. r[j])
                    end
                    RageUI.ButtonWithStyle(
                        "~g~Pay Fine",
                        "Paying the fine will release your vehicle.",
                        {RightLabel = "→→→"},
                        true,
                        function(k, d, l)
                        end,
                        RMenu:Get("xcelimpound", "pay_fine_confirmation")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("xcelimpound", "pay_fine_confirmation"),
            true,
            true,
            true,
            function()
                if i ~= 0 then
                    RageUI.Separator("Would you like to release your vehicle?")
                    RageUI.Separator(
                        "This action will cost you ~g~£" .. getMoneyStringFormatted(a.impoundPrice) .. "~s~."
                    )
                    RageUI.Separator("---")
                    RageUI.ButtonWithStyle(
                        "~g~Pay",
                        "Pay the fine",
                        {RightLabel = "→→→"},
                        true,
                        function(k, d, l)
                            if l then
                                TriggerServerEvent("XCEL:releaseImpoundedVehicle", i.vehicle)
                            end
                        end,
                        RMenu:Get("xcelimpound", "main")
                    )
                    RageUI.ButtonWithStyle(
                        "~r~Cancel",
                        "Go back",
                        {RightLabel = "→→→"},
                        true,
                        function(k, d, l)
                        end,
                        RMenu:Get("xcelimpound", "main")
                    )
                end
            end,
            function()
            end
        )
    end
)
RegisterNetEvent(
    "XCEL:receiveInfoForVehicleToImpound",
    function(s, t, u, v, e)
        b = {owner_id = tonumber(s), owner_name = t, vehicle = u, vehicle_name = v, vehicle_net_id = e}
    end
)
RegisterNetEvent(
    "XCEL:receiveImpoundedVehicles",
    function(w)
        c = w
    end
)
RegisterNetEvent(
    "XCEL:impoundSuccess",
    function(x, u, y, z, A, B, C, D)
        local v = NetworkGetEntityFromNetworkId(x)
        local E = GetEntityCoords(v, false)
        local F = CreateObject("prop_cs_protest_sign_03", E.x, E.y, E.z, true, true, true)
        tXCEL.loadModel("prop_clamp")
        FreezeEntityPosition(v, true)
        local G = CreateObject("prop_clamp", E.x, E.y, E.z, true, true, true)
        SetModelAsNoLongerNeeded("prop_clamp")
        local H = GetEntityBoneIndexByName(v, "wheel_lf")
        SetEntityHeading(G, 0.0)
        AttachEntityToEntity(G, v, H, -0.1, 0.15, -0.3, 180.0, 200.0, 90.0, true, true, false, false, 2, true)
        FreezeEntityPosition(G, true)
        if IsVehicleWindowIntact(v, 0) then
            local I = GetEntityBoneIndexByName(v, "windscreen")
            FreezeEntityPosition(F, true)
            AttachEntityToEntity(F, v, I, 0.1, -2.7, -1.65, -32.0, 5.0, 180.0, true, true, false, true, 0, true)
        end
        tXCEL.notifyPicture(
            "polnotification",
            "notification",
            "You have siezed a ~b~" ..
                u ..
                    "~s~ owned by ~b~" ..
                        y .. "~s~. \n \nA tow truck will pick up the vehicle shortly and take it to the impound.",
            "Metropolitan Police",
            "Impound",
            nil,
            nil
        )
        local J = PlayerPedId()
        local K = GetEntityCoords(J)
        local L, L, M = GetClosestVehicleNodeWithHeading(K.x, K.y, K.z, nil, 8, 8, 8, 8)
        local L, N, L = GetPointOnRoadSide(K.x, K.y, K.z, 0.0)
        local L, O = GetNthClosestVehicleNode(K.x, K.y, K.z, 15)
        local P
        local Q
        if O ~= vector3(0, 0, 0) and N ~= vector3(0, 0, 0) then
            tXCEL.loadModel("flatbed")
            tXCEL.loadModel("a_m_m_prolhost_01")
            P = XCEL.spawnVehicle("flatbed", O.x, O.y, O.z, M, false, true, true)
            local R = NetworkGetNetworkIdFromEntity(P)
            SetVehicleDoorsLocked(P, 2)
            SetNetworkIdCanMigrate(R, false)
            SetModelAsNoLongerNeeded("flatbed")
            local S = AddBlipForEntity(P)
            SetBlipSprite(S, 68)
            SetBlipDisplay(S, 4)
            SetBlipScale(S, 1.0)
            SetBlipColour(S, 5)
            SetBlipAsShortRange(S, true)
            Q = CreatePedInsideVehicle(P, 1, "a_m_m_prolhost_01", -1, true)
            local T = NetworkGetNetworkIdFromEntity(Q)
            TaskVehicleDriveToCoord(Q, P, N.x, N.y, N.z, 15.0, 1.0, "flatbed", 262144, 5.0)
            SetModelAsNoLongerNeeded("a_m_m_prolhost_01")
            local U = GetGameTimer()
            local V = #(GetEntityCoords(v) - GetEntityCoords(P))
            while V > 15.0 and GetGameTimer() - U < 20000 do
                Wait(1000)
                V = #(GetEntityCoords(v) - GetEntityCoords(P))
            end
            TriggerServerEvent(
                "XCEL:deleteImpoundEntities",
                x,
                NetworkGetNetworkIdFromEntity(G),
                NetworkGetNetworkIdFromEntity(F)
            )
            v = XCEL.spawnVehicle(z, C.x, C.y, C.z, D, false, true, false)
            x = NetworkGetEntityFromNetworkId(v)
            SetVehicleDoorsLocked(v, 2)
            SetNetworkIdCanMigrate(x, false)
            SetVehicleColours(v, A, B)
            AttachEntityToEntity(v, P, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
            TriggerServerEvent("XCEL:awaitTowTruckArrival", x, R, T)
            TaskVehicleDriveToCoord(
                Q,
                P,
                a.driveToPosition.x,
                a.driveToPosition.y,
                a.driveToPosition.z,
                15.0,
                1.0,
                "flatbed",
                262144,
                5.0
            )
            SetEntityInvincible(v, true)
            SetEntityInvincible(P, true)
        end
    end
)
RegisterNetEvent(
    "XCEL:attachVehToTowCl",
    function(x, W)
        local v = NetworkGetEntityFromNetworkId(x)
        local P = NetworkGetEntityFromNetworkId(W)
        AttachEntityToEntity(v, P, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
    end
)
local function X(v)
    for Y = -1, GetVehicleMaxNumberOfPassengers(v) - 1 do
        if not IsVehicleSeatFree(v, Y) then
            return true
        end
    end
    return false
end
function tXCEL.impoundVehicleOptions(Z, _, x, a0)
    local a1 = g_vehicleHashToVehicleName[_]
    if X(a0) then
        tXCEL.notifyPicture(
            "polnotification",
            "notification",
            "The vehicle cannot be impounded with a person inside.",
            "Metropolitan Police",
            "Impound",
            nil,
            nil
        )
        return
    end
    local a2 = GetVehicleClass(a0)
    if a2 == 18 then
        tXCEL.notifyPicture(
            "polnotification",
            "notification",
            "Emergency vehicles cannot be impounded.",
            "Metropolitan Police",
            "Impound",
            nil,
            nil
        )
    elseif a.disallowedVehicleClasses[a2] then
        tXCEL.notifyPicture(
            "polnotification",
            "notification",
            "That vehicle is too large to be impounded.",
            "Metropolitan Police",
            "Impound",
            nil,
            nil
        )
    else
        TriggerServerEvent("XCEL:fetchInfoForVehicleToImpound", Z, a1, x)
        RageUI.Visible(RMenu:Get("xcelimpound", "reasons"), true)
    end
end
function tXCEL.isVehicleImpounded(v)
    return c[v] ~= nil
end
function resetChecked()
    for L, o in ipairs(a.reasonsForImpound) do
        o.checked = false
    end
end
exports("impound", tXCEL.impoundVehicleOptions)
exports("isImpounded", tXCEL.isVehicleImpounded)
