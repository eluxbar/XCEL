drawInventoryUI = false
local a = false
local b = false
local c = false
local d = 0.00
local e = 0.00
local f = nil
local g = nil
local h = nil
local i = false
local j = nil
local k = 0
local l = 0
local m = false
local currentInventoryMaxWeight = 30
local n = {
    ["9mm Bullets"] = true,
    ["12 Gauge Bullets"] = true,
    [".308 Sniper Rounds"] = true,
    ["7.62mm Bullets"] = true,
    ["5.56mm NATO"] = true,
    [".357 Bullets"] = true,
    ["Police Issued 5.56mm"] = true,
    ["Police Issued .308 Sniper Rounds"] = true,
    ["Police Issued 9mm"] = true,
    ["Police Issued 12 Gauge"] = true
}
local cfgweapon = module("cfg/weapons")
local o = json.decode(GetResourceKvpString("xcel_gang_inv_colour")) or {r = 18, g = 82, b = 228}
local p = nil
local q = nil
local r = nil
local s = false
inventoryType = nil
local t = false
local function u()
    if IsUsingKeyboard(2) and not tXCEL.isInComa() and not tXCEL.isHandcuffed() then
        TriggerServerEvent("XCEL:FetchPersonalInventory")
        if not i then
            drawInventoryUI = not drawInventoryUI
            if drawInventoryUI then
                setCursor(1)
            else
                setCursor(0)
                inGUIXCEL = false
                if p then
                    tXCEL.vc_closeDoor(q, 5)
                    p = nil
                    q = nil
                    r = nil
                    TriggerEvent("XCEL:clCloseTrunk")
                end
                inventoryType = nil
                XCELSecondItemList = {}
            end
        else
            tXCEL.notify("~r~Cannot open inventory right before a restart!")
        end
    end
end
RegisterCommand("inventory", u, false)
RegisterKeyMapping("inventory", "Open Inventory", "KEYBOARD", "L")
Citizen.CreateThread(
    function()
        while true do
            if drawInventoryUI and IsDisabledControlJustReleased(0, 200) then
                u()
            end
            Wait(0)
        end
    end
)
local v = {}
local w = 0
local XCELSecondItemList = {}
local x = 0
local y = 14
function tXCEL.getSpaceInFirstChest()
    return currentInventoryMaxWeight - d
end
function tXCEL.getSpaceInSecondChest()
    local z = 0
    if next(XCELSecondItemList) == nil then
        return e
    else
        for u, w in pairs(XCELSecondItemList) do
            z = z + w.amount * w.Weight
        end
        return e - z
    end
end
RegisterNetEvent(
    "XCEL:FetchPersonalInventory",
    function(A, B, C)
        v = A
        d = B
        currentInventoryMaxWeight = C
    end
)
RegisterNetEvent(
    "XCEL:SendSecondaryInventoryData",
    function(x, y, D, E)
        if E ~= nil then
            r = E
            inventoryType = "CarBoot"
        end
        XCELSecondItemList = x
        e = D
        c = true
        drawInventoryUI = true
        setCursor(1)
        if D then
            g = D
            h = GetEntityCoords(tXCEL.getPlayerPed())
            if D == "notmytrunk" then
                j = GetEntityCoords(tXCEL.getPlayerPed())
            end
            if string.match(D, "player_") then
                l = string.gsub(D, "player_", "")
            else
                l = 0
            end
        end
    end
)
RegisterNetEvent("XCEL:CloseToRestart", function(x)
    CloseToRestart = true 
    TriggerServerEvent("XCEL:CloseToRestarting")
    Citizen.CreateThread(function()
        while true do
            XCELSecondItemList = {}
            c = false
            drawInventoryUI = false
            setCursor(0)
            Wait(50)
        end
    end)
end)
RegisterNetEvent(
    "XCEL:closeSecondInventory",
    function()
        XCELSecondItemList = {}
        c = false
        drawInventoryUI = false
        g = nil
        setCursor(0)
    end
)
AddEventHandler(
    "XCEL:clCloseTrunk",
    function()
        c = false
        drawInventoryUI = false
        g = nil
        setCursor(0)
        f = nil
        inGUIXCEL = false
        XCELSecondItemList = {}
    end
)
AddEventHandler(
    "XCEL:clOpenTrunk",
    function()
        local F, G, H = tXCEL.getNearestOwnedVehicle(3.5)
        r = G
        q = H
        if F and IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
            p = GetEntityCoords(PlayerPedId())
            tXCEL.vc_openDoor(G, 5)
            inventoryType = "CarBoot"
            TriggerServerEvent("XCEL:FetchTrunkInventory", G)
        else
            tXCEL.notify("~r~You don't have the keys to this vehicle!")
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if f ~= nil and c then
                local I = GetEntityCoords(tXCEL.getPlayerPed())
                local J = GetEntityCoords(f)
                local K = #(I - J)
                if K > 10.0 then
                    TriggerEvent("XCEL:clCloseTrunk")
                    TriggerServerEvent("XCEL:closeChest")
                end
            end
            if g == "house" and c then
                local I = GetEntityCoords(tXCEL.getPlayerPed())
                local J = h
                local K = #(I - J)
                if K > 5.0 then
                    TriggerEvent("XCEL:clCloseTrunk")
                    TriggerServerEvent("XCEL:closeChest")
                end
            end
            if g == "notmytrunk" and c then
                local I = GetEntityCoords(tXCEL.getPlayerPed())
                local J = j
                local K = #(I - J)
                if K > 5.0 then
                    TriggerEvent("XCEL:clCloseTrunk")
                    TriggerServerEvent("XCEL:closeChest")
                end
            end
            if l ~= 0 and c then
                local I = GetEntityCoords(tXCEL.getPlayerPed())
                local J = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(l))))
                local K = #(I - J)
                if K > 5.0 then
                    TriggerEvent("XCEL:clCloseTrunk")
                    TriggerServerEvent("XCEL:closeChest")
                end
            end
            if f == nil and g == "trunk" then
                c = false
                drawInventoryUI = false
            end
            Wait(500)
        end
    end
)
local function L(M, N)
    local O = sortAlphabetically(M)
    local P = #O
    local Q = N * y
    local R = {}
    for S = Q + 1, math.min(Q + y, P) do
        table.insert(R, O[S])
    end
    return R
end
function tXCEL.getAllWeapons()
    local playerPed = tXCEL.getPlayerPed()
    for weaponName, _ in pairs(cfgweapon.weapons) do
        if weaponName ~= "WEAPON_UNARMED" and weaponName ~= "GADGET_PARACHUTE" then
            local weaponHash = GetHashKey(weaponName)
            if HasPedGotWeapon(playerPed, weaponHash, false) then
                return true
            end
        end
    end
    return false
end
Citizen.CreateThread(function()
        while true do
            if drawInventoryUI then
                DrawRect(0.5, 0.53, 0.572, 0.508, 0, 0, 0, 150)
                DrawAdvancedText(
                    0.593,
                    0.235,
                    0.005,
                    0.0028,
                    0.66,
                    "XCEL INVENTORY",
                    255,
                    255,
                    255,
                    255,
                    tXCEL.getFontId("Akrobat-ExtraBold"),
                    0
                )
                DrawRect(0.5, 0.24, 0.572, 0.058, 0, 0, 0, 225)
                if tXCEL.getAllWeapons() and not c then
                    DrawAdvancedText(0.944, 0.243, 0.005, 0.0008, 0.38, "EQUIPPED WEAPONS", 255, 255, 255, 255, tXCEL.getFontId("Akrobat-ExtraBold"), 0)
                    DrawRect(0.848, 0.24, 0.115, 0.058, 0, 0, 0, 225) -- weapons
                    DrawRect(0.848, 0.53, 0.115, 0.508, 0, 0, 0, 150) -- weapons 
                    DrawAdvancedText(0.944, 0.722, 0.005, 0.0028, 0.4, "Store All", 255, 255, 255, 255, 6, 0)
                    DrawRect(0.848, 0.273, 0.115, 0.0069999999999999, o.r, o.g, o.b, 150) -- weapons
                end
                DrawRect(0.342, 0.536, 0.215, 0.436, 0, 0, 0, 150)
                DrawRect(0.652, 0.537, 0.215, 0.436, 0, 0, 0, 150)
                if s then
                    DrawAdvancedText(0.664, 0.305, 0.005, 0.0028, 0.325, "Loot All", 255, 255, 255, 255, 6, 0)
                end
                if c and r then
                    DrawAdvancedText(0.440, 0.305, 0.005, 0.0028, 0.325, "Transfer All", 255, 255, 255, 255, 6, 0)
                end
                if next(v) then
                    DrawAdvancedText(0.355, 0.305, 0.005, 0.0028, 0.325, "Equip All", 255, 255, 255, 255, 6, 0)
                end
                if m then
                    DrawAdvancedText(0.575, 0.364, 0.005, 0.0028, 0.325, "Use", 255, 255, 255, 255, 6, 0)
                    DrawAdvancedText(0.615, 0.364, 0.005, 0.0028, 0.325, "Use All", 255, 255, 255, 255, 6, 0)
                    DrawAdvancedText(0.575, 0.634, 0.005, 0.0028, 0.35, "Give X", 255, 255, 255, 255, 6, 0)
                    DrawAdvancedText(0.615, 0.634, 0.005, 0.0028, 0.35, "Give All", 255, 255, 255, 255, 6, 0)
                else
                    DrawAdvancedText(
                        0.595,
                        0.634,
                        0.005,
                        0.0028,
                        0.35,
                        "Give to Nearest Player",
                        255,
                        255,
                        255,
                        255,
                        6,
                        0
                    )
                    DrawAdvancedText(0.594, 0.364, 0.005, 0.0028, 0.4, "Use", 255, 255, 255, 255, 6, 0)
                end
                DrawAdvancedText(0.594, 0.454, 0.005, 0.0028, 0.4, "Move", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.575, 0.545, 0.005, 0.0028, 0.325, "Move X", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.615, 0.545, 0.005, 0.0028, 0.325, "Move All", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.594, 0.722, 0.005, 0.0028, 0.4, "Trash", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.488, 0.335, 0.005, 0.0028, 0.366, "Amount", 255, 255, 255, 255, 4, 0)
                DrawAdvancedText(0.404, 0.335, 0.005, 0.0028, 0.366, "Item Name", 255, 255, 255, 255, 4, 0)
                DrawAdvancedText(0.521, 0.335, 0.005, 0.0028, 0.366, "Weight", 255, 255, 255, 255, 4, 0)
                DrawAdvancedText(0.833, 0.776, 0.005, 0.0028, 0.288, "[Press L to close]", 255, 255, 255, 255, 4, 0)
                DrawRect(0.5, 0.273, 0.572, 0.0069999999999999, o.r, o.g, o.b, 150)
                DisableControlAction(0, 200, true)
                if table.count(v) > y then
                    DrawAdvancedText(0.528, 0.742, 0.005, 0.0008, 0.4, "Next", 255, 255, 255, 255, 6, 0)
                    if
                        CursorInArea(0.412, 0.432, 0.72, 0.76) and
                            (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                     then
                        local T = math.floor(table.count(v) / y)
                        w = math.min(w + 1, T)
                    end
                    DrawAdvancedText(0.349, 0.742, 0.005, 0.0008, 0.4, "Previous", 255, 255, 255, 255, 6, 0)
                    if
                        CursorInArea(0.239, 0.269, 0.72, 0.76) and
                            (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                     then
                        w = math.max(w - 1, 0)
                    end
                end
                inGUIXCEL = true
                if not c then
                    DrawAdvancedText(
                        0.751,
                        0.525,
                        0.005,
                        0.0028,
                        0.49,
                        "2nd Inventory not available",
                        255,
                        255,
                        255,
                        118,
                        6,
                        0
                    )
                elseif g ~= nil then
                    DrawAdvancedText(0.798, 0.335, 0.005, 0.0028, 0.366, "Amount", 255, 255, 255, 255, 4, 0)
                    DrawAdvancedText(0.714, 0.335, 0.005, 0.0028, 0.366, "Item Name", 255, 255, 255, 255, 4, 0)
                    DrawAdvancedText(0.831, 0.335, 0.005, 0.0028, 0.366, "Weight", 255, 255, 255, 255, 4, 0)
                    local U = 0.026
                    local V = 0.026
                    local W = 0
                    local X = 0
                    for Y, Z in pairs(sortAlphabetically(XCELSecondItemList)) do
                        X = X + Z["value"].amount * Z["value"].Weight
                    end
                    local _ = L(XCELSecondItemList, x)
                    if #_ == 0 then
                        x = 0
                    end
                    for Y, Z in pairs(_) do
                        local a0 = Z.title
                        local a1 = Z["value"]
                        local a2, a3, z = a1.ItemName, a1.amount, a1.Weight
                        DrawAdvancedText(0.714, 0.360 + W * V, 0.005, 0.0028, 0.366, a2, 255, 255, 255, 255, 4, 0)
                        DrawAdvancedText(
                            0.831,
                            0.360 + W * V,
                            0.005,
                            0.0028,
                            0.366,
                            tostring(z * a3) .. "kg",
                            255,
                            255,
                            255,
                            255,
                            4,
                            0
                        )
                        DrawAdvancedText(0.798, 0.360 + W * V, 0.005, 0.0028, 0.366, a3, 255, 255, 255, 255, 4, 0)
                        if CursorInArea(0.5443, 0.7584, 0.3435 + W * V, 0.3690 + W * V) then
                            DrawRect(0.652, 0.331 + U * (W + 1), 0.215, 0.026, o.r, o.g, o.b, 150)
                            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                                if not lockInventorySoUserNoSpam then
                                    b = a0
                                    a = false
                                    k = a3
                                    selectedItemWeight = z
                                    lockInventorySoUserNoSpam = true
                                    Citizen.CreateThread(
                                        function()
                                            Wait(250)
                                            lockInventorySoUserNoSpam = false
                                        end
                                    )
                                end
                            end
                        elseif a0 == b then
                            DrawRect(0.652, 0.331 + U * (W + 1), 0.215, 0.026, o.r, o.g, o.b, 150)
                        end
                        W = W + 1
                    end
                    if X / e > 0.5 then
                        if X / e > 0.9 then
                            DrawAdvancedText(
                                0.826,
                                0.307,
                                0.005,
                                0.0028,
                                0.366,
                                "Weight: " .. X .. "/" .. e .. "kg",
                                255,
                                50,
                                0,
                                255,
                                4,
                                0
                            )
                        else
                            DrawAdvancedText(
                                0.826,
                                0.307,
                                0.005,
                                0.0028,
                                0.366,
                                "Weight: " .. X .. "/" .. e .. "kg",
                                255,
                                165,
                                0,
                                255,
                                4,
                                0
                            )
                        end
                    else
                        DrawAdvancedText(
                            0.826,
                            0.307,
                            0.005,
                            0.0028,
                            0.366,
                            "Weight: " .. X .. "/" .. e .. "kg",
                            255,
                            255,
                            153,
                            255,
                            4,
                            0
                        )
                    end
                    if table.count(XCELSecondItemList) > y then
                        DrawAdvancedText(0.84, 0.742, 0.005, 0.0008, 0.4, "Next", 255, 255, 255, 255, 6, 0)
                        if
                            CursorInArea(0.735, 0.755, 0.72, 0.76) and
                                (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                         then
                            local T = math.floor(table.count(XCELSecondItemList) / y)
                            x = math.min(x + 1, T)
                        end
                        DrawAdvancedText(0.661, 0.742, 0.005, 0.0008, 0.4, "Previous", 255, 255, 255, 255, 6, 0)
                        if
                            CursorInArea(0.55, 0.58, 0.72, 0.76) and
                                (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                         then
                            x = math.max(x - 1, 0)
                        end
                    end
                end
                if m then
                    if CursorInArea(0.46, 0.496, 0.33, 0.383) then
                        DrawRect(0.48, 0.359, 0.0375, 0.056, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                if a then
                                    TriggerServerEvent("XCEL:UseItem", a, "Plr")
                                elseif b and g ~= nil and c then
                                    XCELserver.useInventoryItem({b})
                                else
                                    tXCEL.notify("~r~No item selected!")
                                end
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.48, 0.359, 0.0375, 0.056, 0, 0, 0, 150)
                    end
                    if CursorInArea(0.501, 0.536, 0.329, 0.381) then
                        DrawRect(0.52, 0.359, 0.0375, 0.056, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                if a then
                                    TriggerServerEvent("XCEL:UseAllItem", a, "Plr")
                                elseif b and g ~= nil and c then
                                    XCELserver.useInventoryItem({b})
                                else
                                    tXCEL.notify("~r~No item selected!")
                                end
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.52, 0.359, 0.0375, 0.056, 0, 0, 0, 150)
                    end
                else
                    if CursorInArea(0.4598, 0.5333, 0.3283, 0.3848) then
                        DrawRect(0.5, 0.36, 0.075, 0.056, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                if a then
                                    TriggerServerEvent("XCEL:UseItem", a, "Plr")
                                elseif b and g ~= nil and c then
                                else
                                    tXCEL.notify("~r~No item selected!")
                                end
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.5, 0.36, 0.075, 0.056, 0, 0, 0, 150)
                    end
                end
                if not m then
                    if CursorInArea(0.4598, 0.5333, 0.5931, 0.6477) then
                        DrawRect(0.5, 0.63, 0.075, 0.056, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                if a then
                                    TriggerServerEvent("XCEL:GiveItem", a, "Plr")
                                elseif b then
                                    XCELserver.giveToNearestPlayer({b})
                                else
                                    tXCEL.notify("~r~No item selected!")
                                end
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.5, 0.63, 0.075, 0.056, 0, 0, 0, 150)
                    end
                end
                if CursorInArea(0.4598, 0.5333, 0.418, 0.4709) then
                    DrawRect(0.5, 0.45, 0.075, 0.056, o.r, o.g, o.b, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if not lockInventorySoUserNoSpam then
                            if c then
                                if a and g ~= nil and c then
                                    if tXCEL.isPurge() then
                                        notify("~r~No items will be saved during a purge.")
                                    end
                                    if tXCEL.getPlayerCombatTimer() > 0 then
                                        notify("~r~You can not store items whilst in combat.")
                                    else
                                        if inventoryType == "CarBoot" then
                                            TriggerServerEvent("XCEL:MoveItem", "Plr", a, r, false)
                                        elseif inventoryType == "Housing" then
                                            TriggerServerEvent("XCEL:MoveItem", "Plr", a, "home", false)
                                        elseif inventoryType == "Crate" then
                                            TriggerServerEvent("XCEL:MoveItem", "Plr", a, "crate", false)
                                        elseif s then
                                            TriggerServerEvent("XCEL:MoveItem", "Plr", a, "LootBag", true)
                                        end
                                    end
                                elseif b and g ~= nil and c then
                                    if inventoryType == "CarBoot" then
                                        TriggerServerEvent("XCEL:MoveItem", inventoryType, b, r, false)
                                    elseif inventoryType == "Housing" then
                                        TriggerServerEvent("XCEL:MoveItem", inventoryType, b, "home", false)
                                    elseif inventoryType == "Crate" then
                                        TriggerServerEvent("XCEL:MoveItem", inventoryType, b, "crate", false)
                                    else
                                        TriggerServerEvent("XCEL:MoveItem", "LootBag", b, LootBagIDNew, true)
                                    end
                                else
                                    tXCEL.notify("~r~No item selected!")
                                end
                            else
                                tXCEL.notify("~r~No second inventory available!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.5, 0.45, 0.075, 0.056, 0, 0, 0, 150)
                end
                if CursorInArea(0.4598, 0.498, 0.5042, 0.5666) then
                    DrawRect(0.48, 0.54, 0.0375, 0.056, o.r, o.g, o.b, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        local a4 = tonumber(GetInvAmountText()) or 1
                        if not lockInventorySoUserNoSpam then
                            if c then
                                if a and g ~= nil and c then
                                    if tXCEL.isPurge() then
                                        notify("~r~You can not store items during a purge.")
                                        return
                                    end
                                    if tXCEL.getPlayerCombatTimer() > 0 then
                                        notify("~r~You can not store items whilst in combat.")
                                    else
                                        if inventoryType == "CarBoot" then
                                            TriggerServerEvent("XCEL:MoveItemX", "Plr", a, r, false, a4)
                                        elseif inventoryType == "Housing" then
                                            TriggerServerEvent("XCEL:MoveItemX", "Plr", a, "home", false, a4)
                                        elseif inventoryType == "Crate" then
                                            TriggerServerEvent("XCEL:MoveItemX", "Plr", a, "crate", false, a4)
                                        elseif s then
                                            TriggerServerEvent("XCEL:MoveItemX", "Plr", a, "LootBag", true, a4)
                                        end
                                    end
                                elseif b and g ~= nil and c then
                                    if inventoryType == "CarBoot" then
                                        TriggerServerEvent("XCEL:MoveItemX", inventoryType, b, r, false, a4)
                                    elseif inventoryType == "Housing" then
                                        TriggerServerEvent("XCEL:MoveItemX", inventoryType, b, "home", false, a4)
                                    elseif inventoryType == "Crate" then
                                        TriggerServerEvent("XCEL:MoveItemX", inventoryType, b, "crate", false, a4)
                                    else
                                        TriggerServerEvent("XCEL:MoveItemX", "LootBag", b, LootBagIDNew, true, a4)
                                    end
                                else
                                    tXCEL.notify("~r~No item selected!")
                                end
                            else
                                tXCEL.notify("~r~No second inventory available!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.48, 0.54, 0.0375, 0.056, 0, 0, 0, 150)
                end
                if CursorInArea(0.5004, 0.5333, 0.5042, 0.5666) then
                    DrawRect(0.52, 0.54, 0.0375, 0.056, o.r, o.g, o.b, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if not lockInventorySoUserNoSpam then
                            if c then
                                if a and g ~= nil and c then
                                    local L = tXCEL.getSpaceInSecondChest()
                                    local a4 = k
                                    if k * selectedItemWeight > L then
                                        a4 = math.floor(L / selectedItemWeight)
                                    end
                                    if a4 > 0 then
                                        if tXCEL.isPurge() then
                                            notify("~r~You can not store items during a purge.")
                                            return
                                        end
                                        if tXCEL.getPlayerCombatTimer() > 0 then
                                            notify("~r~You can not store items whilst in combat.")
                                        else
                                            if inventoryType == "CarBoot" then
                                                TriggerServerEvent(
                                                    "XCEL:MoveItemAll",
                                                    "Plr",
                                                    a,
                                                    r,
                                                    NetworkGetNetworkIdFromEntity(tXCEL.getNearestVehicle(3))
                                                )
                                            elseif inventoryType == "Housing" then
                                                TriggerServerEvent("XCEL:MoveItemAll", "Plr", a, "home")
                                            elseif inventoryType == "Crate" then
                                                TriggerServerEvent("XCEL:MoveItemAll", "Plr", a, "crate")
                                            elseif s then
                                                TriggerServerEvent("XCEL:MoveItemAll", "Plr", a, "LootBag")
                                            end
                                        end
                                    else
                                        tXCEL.notify("~r~Not enough space in secondary chest!")
                                    end
                                elseif b and g ~= nil and c then
                                    local M = tXCEL.getSpaceInFirstChest()
                                    local a4 = k
                                    if k * selectedItemWeight > M then
                                        a4 = math.floor(M / selectedItemWeight)
                                    end
                                    if a4 > 0 then
                                        if inventoryType == "CarBoot" then
                                            TriggerServerEvent(
                                                "XCEL:MoveItemAll",
                                                inventoryType,
                                                b,
                                                r,
                                                NetworkGetNetworkIdFromEntity(tXCEL.getNearestVehicle(3))
                                            )
                                        elseif inventoryType == "Housing" then
                                            TriggerServerEvent("XCEL:MoveItemAll", inventoryType, b, "home")
                                        elseif inventoryType == "Crate" then
                                            TriggerServerEvent("XCEL:MoveItemAll", inventoryType, b, "crate")
                                        else
                                            TriggerServerEvent("XCEL:MoveItemAll", "LootBag", b, LootBagIDNew)
                                        end
                                    else
                                        tXCEL.notify("~r~Not enough space in secondary chest!")
                                    end
                                else
                                    tXCEL.notify("~r~No item selected!")
                                end
                            else
                                tXCEL.notify("~r~No second inventory available!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.52, 0.54, 0.0375, 0.056, 0, 0, 0, 150)
                end
                if m then
                    if CursorInArea(0.4598, 0.498, 0.5931, 0.6477) then
                        DrawRect(0.48, 0.63, 0.0375, 0.056, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                if a then
                                    TriggerServerEvent("XCEL:GiveItem", a, "Plr")
                                elseif b then
                                    XCELserver.giveToNearestPlayer({b})
                                else
                                    tXCEL.notify("~r~No item selected!")
                                end
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.48, 0.63, 0.0375, 0.056, 0, 0, 0, 150)
                    end
                end
                if m then
                    if CursorInArea(0.5004, 0.5333, 0.5931, 0.6477) then
                        DrawRect(0.52, 0.63, 0.0375, 0.056, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                if a then
                                    TriggerServerEvent("XCEL:GiveItemAll", a, "Plr")
                                elseif b then
                                    XCELserver.giveToNearestPlayer({b})
                                else
                                    tXCEL.notify("~r~No item selected!")
                                end
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.52, 0.63, 0.0375, 0.056, 0, 0, 0, 150)
                    end
                end
                if s then
                    if CursorInArea(0.5428, 0.5952, 0.2879, 0.3111) then
                        DrawRect(0.5695, 0.3, 0.05, 0.025, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                TriggerServerEvent("XCEL:LootItemAll", LootBagIDNew)
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.5695, 0.3, 0.05, 0.025, 0, 0, 0, 150)
                    end
                end
                if next(v) then
                    if CursorInArea(0.233854, 0.282813, 0.287037, 0.308333) then
                        DrawRect(0.2600, 0.3, 0.05, 0.025, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                TriggerServerEvent("XCEL:EquipAll")
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.2600, 0.3, 0.05, 0.025, 0, 0, 0, 150)
                    end
                end
                if c and r then
                    if CursorInArea(0.32000, 0.37000, 0.287037, 0.308333) then
                        DrawRect(0.3453, 0.3, 0.05, 0.025, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                TriggerServerEvent("XCEL:TransferAll",r)
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end)
                        end
                    else
                        DrawRect(0.3453, 0.3, 0.05, 0.025, 0, 0, 0, 150)
                    end
                end
                if CursorInArea(0.4598, 0.5333, 0.6831, 0.7377) then
                    DrawRect(0.5, 0.72, 0.075, 0.056, o.r, o.g, o.b, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if not lockInventorySoUserNoSpam then
                            if a then
                                TriggerServerEvent("XCEL:TrashItem", a, "Plr")
                            elseif b then
                                tXCEL.notify("~r~Please move the item to your inventory to trash")
                            else
                                tXCEL.notify("~r~No item selected!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.5, 0.72, 0.075, 0.056, 0, 0, 0, 150)
                end
                if not c and tXCEL.getAllWeapons() then
                    if CursorInArea(0.8119, 0.8828, 0.6831, 0.7377) then -- store all
                        DrawRect(0.85, 0.72, 0.075, 0.056, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                ExecuteCommand("storeallweapons")     
                            else
                                tXCEL.notify("~r~No item selected!")
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end)
                        end
                    else
                        DrawRect(0.85, 0.72, 0.075, 0.056, 0, 0, 0, 150)
                    end
                end
                if not c then
                    local UWeapon = 0.026 
                    local VWeapon = 0.026
                    local WidthWeapon = 0
                    local weapons = {}
                    for weaponspawncode, weapondata in pairs(tXCEL.getWeapons()) do
                        if weaponspawncode ~= "GADGET_PARACHUTE" then
                            for spawncode, data in pairs(cfgweapon.weapons) do
                                if spawncode == weaponspawncode then
                                    table.insert(weapons, {name = data.name, ammo = data.ammo, spawncode = weaponspawncode, weapondata = weapondata})
                                    break
                                end
                            end
                        end
                    end
                    local weapons = sortWeaponsAlphabetically(weapons)
                    for i, weapon in ipairs(weapons) do
                        local WeaponName = weapon.name
                        local WeaponAmmo = weapon.ammo
                        if weapon.weapondata.ammo > 0 and WeaponAmmo ~= "modelammo" then
                            DrawAdvancedText(0.944, 0.299 + WidthWeapon * VWeapon, 0.005, 0.0028, 0.366, WeaponName .. " | " ..WeaponAmmo, 255, 255, 255, 255, 4, 0)
                        else
                            DrawAdvancedText(0.944, 0.299 + WidthWeapon * VWeapon, 0.005, 0.0028, 0.366, WeaponName, 255, 255, 255, 255, 4, 0)
                        end
                        if CursorInArea(0.7900, 0.9041, 0.2795 + WidthWeapon * VWeapon, 0.3046 + WidthWeapon * VWeapon) then
                            DrawRect(0.848, 0.269 + UWeapon * (WidthWeapon + 1), 0.115, 0.026, o.r, o.g, o.b, 150)
                            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                                TriggerServerEvent("XCEL:forceStoreSingleWeapon", weapon.spawncode)
                            end
                        end
                        WidthWeapon = WidthWeapon + 1
                    end
                end
                local U = 0.026
                local V = 0.026
                local W = 0
                local X = 0
                local a5 = sortAlphabetically(v)
                for Y, Z in pairs(a5) do
                    local a0 = Z.title
                    local a1 = Z["value"]
                    local a2, a3, z = a1.ItemName, a1.amount, a1.Weight
                    X = X + a3 * z
                    DrawAdvancedText(0.404, 0.360 + W * V, 0.005, 0.0028, 0.366, a2, 255, 255, 255, 255, 4, 0)
                    DrawAdvancedText(
                        0.521,
                        0.360 + W * V,
                        0.005,
                        0.0028,
                        0.366,
                        tostring(z * a3) .. "kg",
                        255,
                        255,
                        255,
                        255,
                        4,
                        0
                    )
                    DrawAdvancedText(0.488, 0.360 + W * V, 0.005, 0.0028, 0.366, a3, 255, 255, 255, 255, 4, 0)
                    if CursorInArea(0.2343, 0.4484, 0.3435 + W * V, 0.3690 + W * V) then
                        DrawRect(0.342, 0.331 + U * (W + 1), 0.215, 0.026, o.r, o.g, o.b, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            a = a0
                            if n[a] then
                                m = true
                            else
                                m = false
                            end
                            k = a3
                            selectedItemWeight = z
                            b = false
                        end
                    elseif a0 == a then
                        DrawRect(0.342, 0.331 + U * (W + 1), 0.215, 0.026, o.r, o.g, o.b, 150)
                    end
                    W = W + 1
                end
                if X / currentInventoryMaxWeight > 0.5 then
                    if X / currentInventoryMaxWeight > 0.9 then
                        DrawAdvancedText(
                            0.516,
                            0.307,
                            0.005,
                            0.0028,
                            0.366,
                            "Weight: " .. X .. "/" .. currentInventoryMaxWeight .. "kg",
                            255,
                            50,
                            0,
                            255,
                            4,
                            0
                        )
                    else
                        DrawAdvancedText(
                            0.516,
                            0.307,
                            0.005,
                            0.0028,
                            0.366,
                            "Weight: " .. X .. "/" .. currentInventoryMaxWeight .. "kg",
                            255,
                            165,
                            0,
                            255,
                            4,
                            0
                        )
                    end
                else
                    DrawAdvancedText(
                        0.516,
                        0.307,
                        0.005,
                        0.0028,
                        0.366,
                        "Weight: " .. X .. "/" .. currentInventoryMaxWeight .. "kg",
                        255,
                        255,
                        255,
                        255,
                        4,
                        0
                    )
                end
            end
            Wait(0)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if GetEntityHealth(tXCEL.getPlayerPed()) <= 102 then
                XCELSecondItemList = {}
                c = false
                drawInventoryUI = false
                inGUIXCEL = false
                setCursor(0)
            end
            Wait(50)
        end
    end
)
function GetInvAmountText()
    AddTextEntry("FMMC_MPM_NA", "Enter amount: (Blank to cancel)")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter amount: (Blank to cancel)", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local N = GetOnscreenKeyboardResult()
        return N
    end
    return nil
end
Citizen.CreateThread(
    function()
        while true do
            Wait(250)
            if p then
                if #(p - GetEntityCoords(PlayerPedId())) > 8.0 then
                    drawInventoryUI = false
                    tXCEL.vc_closeDoor(q, 5)
                    p = nil
                    q = nil
                    r = nil
                    inventoryType = nil
                end
            end
            if drawInventoryUI then
                if
                    tXCEL.isInComa() or
                        inventoryType == "Crate" and
                            GetClosestObjectOfType(
                                GetEntityCoords(PlayerPedId()),
                                5.0,
                                GetHashKey("xs_prop_arena_crate_01a"),
                                false,
                                false,
                                false
                            ) == 0
                 then
                    TriggerEvent("XCEL:InventoryOpen", false)
                    if p then
                        tXCEL.vc_closeDoor(q, 5)
                        p = nil
                        q = nil
                        r = nil
                    end
                end
            end
        end
    end
)
function LoadAnimDict(a6)
    while not HasAnimDictLoaded(a6) do
        RequestAnimDict(a6)
        Citizen.Wait(5)
    end
end
RegisterNetEvent("XCEL:InventoryOpen")
AddEventHandler(
    "XCEL:InventoryOpen",
    function(a7, a8, a9)
        s = a8
        LootBagIDNew = a9
        if a7 and not i then
            drawInventoryUI = true
            setCursor(1)
            inGUIXCEL = true
        else
            drawInventoryUI = false
            setCursor(0)
            XCELSecondItemList = {}
            inGUIXCEL = false
            inventoryType = nil
            local aa = PlayerPedId()
            local X = GetEntityCoords(aa)
            ClearPedTasks(aa)
            ForcePedAiAndAnimationUpdate(aa, false, false)
            if tXCEL.getPlayerVehicle() == 0 then
                SetEntityCoordsNoOffset(aa, X.x, X.y, X.z + 0.1, true, false, false)
            end
        end
    end
)
function tXCEL.setInventoryColour()
    tXCEL.clientPrompt(
        "Enter rgb value eg 255,100,150:",
        "",
        function(aa)
            if aa ~= "" then
                local I = stringsplit(aa, ",")
                if I[1] ~= nil and I[2] ~= nil and I[3] ~= nil then
                    o.r = tonumber(I[1])
                    o.g = tonumber(I[2])
                    o.b = tonumber(I[3])
                    tXCEL.notify("~g~Inventory colour updated.")
                else
                    tXCEL.notify("~r~Invalid value")
                end
            else
                tXCEL.notify("~r~Invalid value")
            end
            SetResourceKvp("xcel_gang_inv_colour", json.encode(o))
        end
    )
end
