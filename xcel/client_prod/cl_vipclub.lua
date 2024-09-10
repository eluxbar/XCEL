RMenu.Add(
    "vipclubmenu",
    "mainmenu",
    RageUI.CreateMenu("", "~w~XCEL Club", tXCEL.getRageUIMenuWidth(), tXCEL.getRageUIMenuHeight(), "banners","vipclub", "xcel_club", "xcel_club")
)
RMenu.Add(
    "vipclubmenu",
    "managesubscription",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "mainmenu"),
        "",
        "~w~XCEL Club",
        tXCEL.getRageUIMenuWidth(),
        tXCEL.getRageUIMenuHeight(),
        "banners",
        "vipclub",
        "xcel_club",
        "xcel_club"
    )
)
RMenu.Add(
    "vipclubmenu",
    "manageusersubscription",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "mainmenu"),
        "",
        "~w~XCEL Club Manage",
        tXCEL.getRageUIMenuWidth(),
        tXCEL.getRageUIMenuHeight(),
        "banners",
        "vipclub",
        "xcel_club",
        "xcel_club"
    )
)
RMenu.Add(
    "vipclubmenu",
    "manageperks",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "mainmenu"),
        "",
        "~w~XCEL Club Perks",
        tXCEL.getRageUIMenuWidth(),
        tXCEL.getRageUIMenuHeight(),
        "banners",
        "vipclub",
        "xcel_club",
        "xcel_club"
    )
)
RMenu.Add(
    "vipclubmenu",
    "deathsounds",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "manageperks"),
        "",
        "~w~Manage Death Sounds",
        tXCEL.getRageUIMenuWidth(),
        tXCEL.getRageUIMenuHeight(),
        "banners",
        "vipclub",
        "xcel_club",
        "xcel_club"
    )
)
RMenu.Add(
    "vipclubmenu",
    "vehicleExtras",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "manageperks"),
        "",
        "~w~Vehicle Extras",
        tXCEL.getRageUIMenuWidth(),
        tXCEL.getRageUIMenuHeight(),
        "banners",
        "vipclub",
        "xcel_club",
        "xcel_club"
    )
)
local a = {hoursOfPlus = 0, hoursOfPlatinum = 0}
local b = {}
function tXCEL.isPlusClub()
    if a.hoursOfPlus > 0 then
        return true
    else
        return false
    end
end
function tXCEL.isPlatClub()
    if a.hoursOfPlatinum > 0 then
        return true
    else
        return false
    end
end
RegisterCommand(
    "xcelclub",
    function()
        TriggerServerEvent("XCEL:getPlayerSubscription")
        RageUI.ActuallyCloseAll()
        RageUI.Visible(RMenu:Get("vipclubmenu", "mainmenu"), not RageUI.Visible(RMenu:Get("vipclubmenu", "mainmenu")))
    end
)
local c = {
    ["XCEL"] = {checked = true, soundId = "playDead"},
    ["Fortnite"] = {checked = false, soundId = "fortnite_death"},
    ["Roblox"] = {checked = false, soundId = "roblox_death"},
    ["Minecraft"] = {checked = false, soundId = "minecraft_death"},
    ["Pac-Man"] = {checked = false, soundId = "pacman_death"},
    ["Mario"] = {checked = false, soundId = "mario_death"},
    ["CS:GO"] = {checked = false, soundId = "csgo_death"}
}
local tracerColours = json.decode(GetResourceKvpString("xcel_tracer_colours")) or {r = 255, g = 0, b = 0}
local d = false
local e = false
local f = false
local g = false
local h = {"Red", "Blue", "Green", "Pink", "Yellow", "Orange", "Purple"}
local i = tonumber(GetResourceKvpString("xcel_damageindicatorcolour")) or 1
local gD = {"Red", "Blue", "Green", "Pink", "Yellow", "Orange", "Purple"}
local hD = tonumber(GetResourceKvpString("xcel_bullettracercolour")) or 1
Citizen.CreateThread(
    function()
        local j = GetResourceKvpString("xcel_codhitmarkersounds") or "false"
        if j == "false" then
            d = false
            TriggerEvent("XCEL:codHMSoundsOff")
        else
            d = true
            TriggerEvent("XCEL:codHMSoundsOn")
        end
        local k = GetResourceKvpString("xcel_killlistsetting") or "false"
        if k == "false" then
            e = false
        else
            e = true
        end
        local l = GetResourceKvpString("xcel_oldkillfeed") or "false"
        if l == "false" then
            f = false
        else
            f = true
        end
        local m = GetResourceKvpString("xcel_damageindicator") or "false"
        if m == "false" then
            g = false
        else
            g = true
        end
        local L = GetResourceKvpString("xcel_bullet_tracers") or "false"
        if L == "false" then
            bulletTracers = false
        else
            bulletTracers = true
        end
        Wait(5000)
    end
)
AddEventHandler(
    "XCEL:onClientSpawn",
    function(f, g)
        if g then
            TriggerServerEvent("XCEL:getPlayerSubscription")
            Wait(5000)
            local n = tXCEL.getDeathSound()
            local o = "playDead"
            for p, j in pairs(c) do
                if j.soundId == n then
                    o = p
                end
            end
            for p, k in pairs(c) do
                if o ~= p then
                    k.checked = false
                else
                    k.checked = true
                end
            end
        end
    end
)
function tXCEL.setDeathSound(n)
    if tXCEL.isPlusClub() or tXCEL.isPlatClub() then
        SetResourceKvp("xcel_deathsound", n)
    else
        tXCEL.notify("~r~Cannot change deathsound, not a valid XCEL Plus or Platinum subscriber.")
    end
end
function tXCEL.getDeathSound()
    if tXCEL.isPlusClub() or tXCEL.isPlatClub() then
        local p = GetResourceKvpString("xcel_deathsound")
        if type(p) == "string" and p ~= "" then
            return p
        else
            return "playDead"
        end
    else
        return "playDead"
    end
end
function tXCEL.getDmgIndcator()
    return g, i
end
local function k(h)
    SendNUIMessage({transactionType = h})
end
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("vipclubmenu", "mainmenu")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if tXCEL.isPlusClub() or tXCEL.isPlatClub() then
                        RageUI.ButtonWithStyle(
                            "Manage Subscription",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(m, q, r)
                            end,
                            RMenu:Get("vipclubmenu", "managesubscription")
                        )
                        RageUI.ButtonWithStyle(
                            "Manage Perks",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(m, q, r)
                            end,
                            RMenu:Get("vipclubmenu", "manageperks")
                        )
                    else
                        RageUI.ButtonWithStyle(
                            "Purchase Subscription",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(m, q, r)
                                if r then
                                    tXCEL.OpenUrl("https://store.xcelstudios.com/category/subscriptions")
                                end
                            end
                        )
                    end
                    if tXCEL.isDev() or tXCEL.getStaffLevel() >= 10 then
                        RageUI.ButtonWithStyle(
                            "Manage User's Subscription",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(m, q, r)
                            end,
                            RMenu:Get("vipclubmenu", "manageusersubscription")
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("vipclubmenu", "managesubscription")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    colourCode = getColourCode(a.hoursOfPlus)
                    RageUI.Separator(
                        "Days remaining of Plus Subscription: " ..
                            colourCode .. math.floor(a.hoursOfPlus / 24 * 100) / 100 .. " days."
                    )
                    colourCode = getColourCode(a.hoursOfPlatinum)
                    RageUI.Separator(
                        "Days remaining of Platinum Subscription: " ..
                            colourCode .. math.floor(a.hoursOfPlatinum / 24 * 100) / 100 .. " days."
                    )
                    RageUI.Separator()
                    RageUI.ButtonWithStyle(
                        "Sell Plus Subscription days.",
                        "~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                            if r then
                                if isInGreenzone then
                                    TriggerServerEvent("XCEL:beginSellSubscriptionToPlayer", "Plus")
                                else
                                    notify("~r~You must be in a greenzone to sell.")
                                end
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "Sell Platinum Subscription days.",
                        "~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                            if r then
                                if isInGreenzone then
                                    TriggerServerEvent("XCEL:beginSellSubscriptionToPlayer", "Platinum")
                                else
                                    notify("~r~You must be in a greenzone to sell.")
                                end
                            end
                        end
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("vipclubmenu", "manageusersubscription")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if tXCEL.isDev() then
                        if next(b) then
                            RageUI.Separator("Perm ID: " .. b.userid)
                            colourCode = getColourCode(b.hoursOfPlus)
                            RageUI.Separator(
                                "Days of Plus Remaining: " .. colourCode .. math.floor(b.hoursOfPlus / 24 * 100) / 100
                            )
                            colourCode = getColourCode(b.hoursOfPlatinum)
                            RageUI.Separator(
                                "Days of Platinum Remaining: " ..
                                    colourCode .. math.floor(b.hoursOfPlatinum / 24 * 100) / 100
                            )
                            RageUI.ButtonWithStyle(
                                "Set Plus Days",
                                "",
                                {RightLabel = "→→→"},
                                true,
                                function(m, q, r)
                                    if r then
                                        TriggerServerEvent("XCEL:setPlayerSubscription", b.userid, "Plus")
                                    end
                                end
                            )
                            RageUI.ButtonWithStyle(
                                "Set Platinum Days",
                                "",
                                {RightLabel = "→→→"},
                                true,
                                function(m, q, r)
                                    if r then
                                        TriggerServerEvent("XCEL:setPlayerSubscription", b.userid, "Platinum")
                                    end
                                end
                            )
                        else
                            RageUI.Separator("Please select a Perm ID")
                        end
                        RageUI.ButtonWithStyle(
                            "Select Perm ID",
                            nil,
                            {RightLabel = "→→→"},
                            true,
                            function(s, t, u)
                                if u then
                                    permID = tXCEL.KeyboardInput("Enter Perm ID", "", 10)
                                    if permID == nil then
                                        tXCEL.notify("Invalid Perm ID")
                                        return
                                    end
                                    TriggerServerEvent("XCEL:getPlayerSubscription", permID)
                                end
                            end,
                            RMenu:Get("vipclubmenu", "manageusersubscription")
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("vipclubmenu", "manageperks")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.ButtonWithStyle(
                        "Custom Death Sounds",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                        end,
                        RMenu:Get("vipclubmenu", "deathsounds")
                    )
                    RageUI.ButtonWithStyle(
                        "Vehicle Extras",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                        end,
                        RMenu:Get("vipclubmenu", "vehicleextras")
                    )
                    RageUI.ButtonWithStyle(
                        "Claim Weekly Kit",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                            if r then
                                if not globalInPrison and not tXCEL.isHandcuffed() then
                                    TriggerServerEvent("XCEL:claimWeeklyKit")
                                else
                                    notify("~r~You can not redeem a kit whilst in custody.")
                                end
                            end
                        end
                    )
                    local function r()
                        TriggerEvent("XCEL:codHMSoundsOn")
                        d = true
                        tXCEL.setCODHitMarkerSetting(d)
                        tXCEL.notify("~y~COD Hitmarkers now set to " .. tostring(d))
                    end
                    local function v()
                        TriggerEvent("XCEL:codHMSoundsOff")
                        d = false
                        tXCEL.setCODHitMarkerSetting(d)
                        tXCEL.notify("~y~COD Hitmarkers now set to " .. tostring(d))
                    end
                    RageUI.Checkbox(
                        "Enable COD Hitmarkers",
                        "~g~This adds 'hit marker' sound and image when shooting another player.",
                        d,
                        {RightBadge = RageUI.CheckboxStyle.Car},
                        function(l, q, m, w)
                        end,
                        r,
                        v
                    )
                    RageUI.Checkbox(
                        "Enable Kill List",
                        "~g~This adds a kill list below your crosshair when you kill a player.",
                        e,
                        {Style = RageUI.CheckboxStyle.Car},
                        function()
                        end,
                        function()
                            e = true
                            tXCEL.setKillListSetting(e)
                            tXCEL.notify("~y~Kill List now set to " .. tostring(e))
                        end,
                        function()
                            e = false
                            tXCEL.setKillListSetting(e)
                            tXCEL.notify("~y~Kill List now set to " .. tostring(e))
                        end
                    )
                    RageUI.Checkbox(
                        "Enable Old Kilfeed",
                        "~g~This toggles the old killfeed that notifies above minimap.",
                        f,
                        {Style = RageUI.CheckboxStyle.Car},
                        function()
                        end,
                        function()
                            f = true
                            tXCEL.setOldKillfeed(f)
                            tXCEL.notify("~y~Old killfeed now set to " .. tostring(f))
                        end,
                        function()
                            f = false
                            tXCEL.setOldKillfeed(f)
                            tXCEL.notify("~y~Old killfeed now set to " .. tostring(f))
                        end
                    )
                    local function a4()
                        bulletTracers = true
                        SetResourceKvp("xcel_bullet_tracers", tostring(bulletTracers))
                    end
                    local function a5()
                        bulletTracers = false
                        SetResourceKvp("xcel_bullet_tracers", tostring(bulletTracers))
                    end
                    RageUI.Checkbox(
                        "Enable Damage Indicator",
                        "~g~This toggles the display of damage indicator.",
                        g,
                        {Style = RageUI.CheckboxStyle.Car},
                        function()
                        end,
                        function()
                            g = true
                            tXCEL.setDamageIndicator(g)
                            tXCEL.notify("~y~Damage Indicator now set to " .. tostring(g))
                        end,
                        function()
                            g = false
                            tXCEL.setDamageIndicator(g)
                            tXCEL.notify("~y~Damage Indicator now set to " .. tostring(g))
                        end
                    )
                    if g then
                        RageUI.List(
                            "Damage Colour",
                            h,
                            i,
                            "~g~Change the displayed colour of damage",
                            {},
                            true,
                            function(x, y, z, A)
                                i = A
                                tXCEL.setDamageIndicatorColour(i)
                            end,
                            function()
                            end,
                            nil
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("vipclubmenu", "deathsounds")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    for B, p in pairs(c) do
                        RageUI.Checkbox(
                            B,
                            "",
                            p.checked,
                            {},
                            function()
                            end,
                            function()
                                for n, j in pairs(c) do
                                    j.checked = false
                                end
                                p.checked = true
                                k(p.soundId)
                                tXCEL.setDeathSound(p.soundId)
                            end,
                            function()
                            end
                        )
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("vipclubmenu", "vehicleextras")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    local C = tXCEL.getPlayerVehicle()
                    --SetVehicleAutoRepairDisabled(C, true)
                    for D = 1, 99, 1 do
                        if DoesxcelExist(C, D) then
                            RageUI.Checkbox(
                                "Xcel" .. D,
                                "",
                                IsVehicleExtraTurnedOn(C, D),
                                {},
                                function()
                                end,
                                function()
                                    SetVehicleExtra(C, D, 0)
                                end,
                                function()
                                    SetVehicleExtra(C, D, 1)
                                end
                            )
                        end
                    end
                end
            )
        end
    end
)
RegisterNetEvent(
    "XCEL:setVIPClubData",
    function(E, b)
        a.hoursOfPlus = E
        a.hoursOfPlatinum = b
    end
)
RegisterNetEvent(
    "XCEL:getUsersSubscription",
    function(F, G, H)
        b.userid = F
        b.hoursOfPlus = G
        b.hoursOfPlatinum = H
        RMenu:Get("vipclubmenu", "manageusersubscription")
    end
)
RegisterNetEvent(
    "XCEL:userSubscriptionUpdated",
    function()
        TriggerServerEvent("XCEL:getPlayerSubscription", permID)
    end
)
Citizen.CreateThread(
    function()
        while true do
            if tXCEL.isPlatClub() then
                if not HasPedGotWeapon(PlayerPedId(), "GADGET_PARACHUTE", false) then
                    XCEL.allowWeapon("GADGET_PARACHUTE")
                    GiveWeaponToPed(PlayerPedId(), "GADGET_PARACHUTE")
                    SetPlayerHasReserveParachute(PlayerId())
                end
            end
            if tXCEL.isPlusClub() or tXCEL.isPlatClub() then
                SetVehicleDirtLevel(tXCEL.getPlayerVehicle(), 0.0)
            end
            Wait(500)
        end
    end
)
function getColourCode(a)
    if a == nil then
        return "~r~" 
    end
    if a >= 10 then
        colourCode = "~g~"
    elseif a < 10 and a > 3 then
        colourCode = "~y~"
    else
        colourCode = "~r~"
    end
    return colourCode
end
local z = {}
local function A()
    for E, I in pairs(z) do
        DrawAdvancedTextNoOutline(
            0.6,
            0.5 + 0.025 * E,
            0.005,
            0.0028,
            0.45,
            "Killed " .. I.name,
            255,
            255,
            255,
            255,
            tXCEL.getFontId("Akrobat-Regular"),
            1
        )
    end
end
tXCEL.createThreadOnTick(A)

local a_ = math.rad
local b0 = math.cos
local b1 = math.sin
local b2 = math.abs
function tXCEL.rotationToDirection(b3)
    local B = a_(b3.x)
    local D = a_(b3.z)
    return vector3(-b1(D) * b2(b0(B)), b0(D) * b2(b0(B)), b1(B))
end
zz_z = Wait

function tXCEL.RayCastPed(pos,distance,ped)
    local cameraRotation = GetGameplayCamRot()
	local direction = tXCEL.rotationToDirection(cameraRotation)
	local destination = 
	{ 
		x = pos.x + direction.x * distance, 
		y = pos.y + direction.y * distance, 
		z = pos.z + direction.z * distance 
	}

	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(pos.x, pos.y, pos.z, destination.x, destination.y, destination.z, -1, ped, 1))
    return b, c
end
RegisterNetEvent(
    "XCEL:onPlayerKilledPed",
    function(J)
        if e and (tXCEL.isPlatClub() or tXCEL.isPlusClub()) and IsPedAPlayer(J) then
            local K = NetworkGetPlayerIndexFromPed(J)
            if K >= 0 then
                local L = GetPlayerServerId(K)
                if L >= 0 then
                    local M = tXCEL.GetPlayerName(K)
                    table.insert(z, {name = M, source = L})
                    SetTimeout(
                        2000,
                        function()
                            for E, I in pairs(z) do
                                if L == I.source then
                                    table.remove(z, E)
                                end
                            end
                        end
                    )
                end
            end
        end
    end
)
