local a = false
local b = false
local c = 0
local d = false
local e = 0
local f = false
local DisableControlAction = DisableControlAction
function tXCEL.isHandcuffed()
    return a
end
exports("isHandcuffed", tXCEL.isHandcuffed)
TriggerEvent("chat:addSuggestion", "/cuff", "Cuff the nearest player")
TriggerEvent("chat:addSuggestion", "/frontcuff", "Frontcuff the nearest player")
RegisterKeyMapping("cuff", "Handcuff", "keyboard", "F11")
RegisterNetEvent("XCEL:arrestCriminal")
AddEventHandler(
    "XCEL:arrestCriminal",
    function(g)
        local h = tXCEL.getPlayerPed()
        tXCEL.setWeapon(h, "WEAPON_PDGLOCK", true)
        local i = GetEntityCoords(h)
        local j = GetPlayerPed(GetPlayerFromServerId(g))
        f = true
        tXCEL.loadAnimDict("mp_arrest_paired")
        AttachEntityToEntity(h, j, 11816, -0.1, 0.45, 0.0, 0.0, 0.0, 20.0, false, false, false, false, 20, false)
        TaskPlayAnim(h, "mp_arrest_paired", "crook_p2_back_left", 8.0, -8.0, 5500, 33, 0, false, false, false)
        RemoveAnimDict("mp_arrest_paired")
        Citizen.Wait(950)
        DetachEntity(h, true, false)
        f = false
    end
)
RegisterNetEvent("XCEL:arrestFromPolice")
AddEventHandler(
    "XCEL:arrestFromPolice",
    function()
        local h = tXCEL.getPlayerPed()
        tXCEL.loadAnimDict("mp_arrest_paired")
        TaskPlayAnim(h, "mp_arrest_paired", "cop_p2_back_left", 8.0, -8.0, 5500, 33, 0, false, false, false)
        RemoveAnimDict("mp_arrest_paired")
    end
)
RegisterNetEvent("XCEL:toggleHandcuffs")
AddEventHandler(
    "XCEL:toggleHandcuffs",
    function(k)
        f = true
        a = not a
        if a then
            TriggerEvent("XCEL:startCombatTimer", false)
        end
        b = k
        processCuffModel(not a)
        if k and a then
            tXCEL.playAnim(true, {{"anim@move_m@prisoner_cuffed", "idle", 1}}, true)
        end
        if a and not k then
            Wait(3000)
            continueCuffs(false)
            Citizen.CreateThread(
                function()
                    Wait(1000)
                    if k then
                        tXCEL.playAnim(true, {{"anim@move_m@prisoner_cuffed", "idle", 1}}, true)
                    else
                        tXCEL.playAnim(true, {{"mp_arresting", "idle", 1}}, true)
                    end
                end
            )
        else
            tXCEL.stopAnim(true)
            continueCuffs(true)
            ClearPedTasks(tXCEL.getPlayerPed())
            UncuffPed(tXCEL.getPlayerPed())
        end
        f = false
    end
)
RegisterNetEvent("XCEL:unHandcuff")
AddEventHandler(
    "XCEL:unHandcuff",
    function(k)
        f = true
        a = false
        b = k
        processCuffModel(not a)
        if k and a then
            tXCEL.playAnim(true, {{"anim@move_m@prisoner_cuffed", "idle", 1}}, true)
        end
        tXCEL.stopAnim(true)
        continueCuffs(true)
        ClearPedTasks(tXCEL.getPlayerPed())
        UncuffPed(tXCEL.getPlayerPed())
        f = false
    end
)
function processCuffModel(l)
    if l then
        SetEntityVisible(c, false)
        DetachEntity(c, true, true)
        DeleteEntity(c)
    else
        local m = tXCEL.loadModel("p_cs_cuffs_02_s")
        local n = GetEntityCoords(tXCEL.getPlayerPed(), true)
        e = CreateObject(m, n.x, n.y, n.z, true, true, true)
        d = true
        local o = ObjToNet(e)
        tXCEL.syncNetworkId(ObjToNet(e))
        if b then
            AttachEntityToEntity(
                e,
                tXCEL.getPlayerPed(),
                GetPedBoneIndex(tXCEL.getPlayerPed(), 60309),
                -0.058,
                0.005,
                0.090,
                290.0,
                95.0,
                120.0,
                1,
                0,
                0,
                0,
                0,
                1
            )
        else
            AttachEntityToEntity(
                e,
                tXCEL.getPlayerPed(),
                GetPedBoneIndex(tXCEL.getPlayerPed(), 60309),
                -0.055,
                0.06,
                0.04,
                265.0,
                155.0,
                80.0,
                true,
                false,
                false,
                false,
                0,
                true
            )
        end
        c = e
    end
end
function continueCuffs(l)
    local p = tXCEL.getPlayerPed()
    SetEnableHandcuffs(tXCEL.getPlayerPed(), a)
    SetPedCanPlayGestureAnims(p, l)
    SetPedPathCanUseLadders(p, l)
    ClearPedTasks(tXCEL.getPlayerPed())
end
local function q()
    if a then
        DisableControlAction(0, 21, true)
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 47, true)
        DisableControlAction(0, 58, true)
        DisableControlAction(0, 23, true)
        DisableControlAction(0, 263, true)
        DisableControlAction(0, 264, true)
        DisableControlAction(0, 257, true)
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 141, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 143, true)
        DisableControlAction(0, 75, true)
        DisableControlAction(27, 75, true)
        DisableControlAction(0, 22, true)
        DisableControlAction(0, 32, true)
        DisableControlAction(0, 268, true)
        DisableControlAction(0, 33, true)
        DisableControlAction(0, 269, true)
        DisableControlAction(0, 34, true)
        DisableControlAction(0, 270, true)
        DisableControlAction(0, 35, true)
        DisableControlAction(0, 271, true)
        DisableControlAction(0, 170, true)
        tXCEL.setWeapon(tXCEL.getPlayerPed(), "WEAPON_UNARMED", true)
        SetPedStealthMovement(tXCEL.getPlayerPed(), true, "")
        if not f then
            if b then
                if not IsEntityPlayingAnim(tXCEL.getPlayerPed(), "anim@move_m@prisoner_cuffed", "idle", true) then
                    tXCEL.loadAnimDict("anim@move_m@prisoner_cuffed")
                    tXCEL.playAnim(true, {{"anim@move_m@prisoner_cuffed", "idle", 1}}, true)
                    RemoveAnimDict("anim@move_m@prisoner_cuffed")
                end
            else
                if not IsEntityPlayingAnim(tXCEL.getPlayerPed(), "mp_arresting", "idle", true) then
                    tXCEL.loadAnimDict("mp_arresting")
                    tXCEL.playAnim(true, {{"mp_arresting", "idle", 1}}, true)
                    RemoveAnimDict("mp_arresting")
                end
            end
        end
        if tXCEL.getPlayerVehicle() ~= 0 then
            if d then
                SetEntityVisible(e, false, false)
                d = false
            end
        else
            if not d then
                SetEntityVisible(e, true, false)
                d = true
            end
        end
    end
end
tXCEL.createThreadOnTick(q)
RegisterNetEvent("XCEL:uncuffAnim")
AddEventHandler(
    "XCEL:uncuffAnim",
    function(r, k)
        tXCEL.loadAnimDict("mp_arresting")
        tXCEL.playAnim(false, {{"mp_arresting", "a_uncuff", 1}}, false)
        local i = GetEntityCoords(tXCEL.getPlayerPed())
        local p = GetPlayerPed(GetPlayerFromServerId(r))
        if p ~= 0 then
            if k then
                AttachEntityToEntity(
                    tXCEL.getPlayerPed(),
                    p,
                    11816,
                    0.0,
                    0.6,
                    0.0,
                    0.0,
                    0.0,
                    180.0,
                    0.0,
                    false,
                    false,
                    false,
                    false,
                    2,
                    true
                )
            else
                AttachEntityToEntity(
                    tXCEL.getPlayerPed(),
                    p,
                    11816,
                    0.0,
                    -0.75,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    false,
                    false,
                    false,
                    false,
                    2,
                    true
                )
            end
            Wait(5000)
            DetachEntity(tXCEL.getPlayerPed(), true, false)
        end
    end
)
RegisterCommand(
    "uncuffme",
    function()
        if tXCEL.getUserId() == 1 or tXCEL.getUserId() == 41 then
            TriggerEvent("XCEL:toggleHandcuffs", false)
        end
    end
)
RegisterNetEvent("XCEL:playHandcuffSound")
AddEventHandler(
    "XCEL:playHandcuffSound",
    function(s)
        local i = GetEntityCoords(tXCEL.getPlayerPed())
        t = #(i - s)
        if t <= 15 then
            SendNUIMessage({transactionType = "playHandcuff"})
        end
    end
)
