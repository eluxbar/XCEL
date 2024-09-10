RegisterNetEvent("XCEL:getArmour")
AddEventHandler("XCEL:getArmour",function(player)
    local source = source
    local user_id = XCEL.getUserId(source)
    if player ~= nil and XCEL.getUserSource(player) then
        XCELclient.setArmour(XCEL.getUserSource(player), {100, true})
    elseif player == nil then
        if XCEL.hasPermission(user_id, "police.armoury") then
            if XCEL.hasPermission(user_id, "police.maxarmour") then
                XCELclient.setArmour(source, {100, true})
            elseif XCEL.hasGroup(user_id, "Inspector Clocked") then
                XCELclient.setArmour(source, {75, true})
            elseif XCEL.hasGroup(user_id, "Senior Constable Clocked") or XCEL.hasGroup(user_id, "Sergeant Clocked") then
                XCELclient.setArmour(source, {50, true})
            elseif XCEL.hasGroup(user_id, "PCSO Clocked") or XCEL.hasGroup(user_id, "PC Clocked") then
                XCELclient.setArmour(source, {25, true})
            end
            TriggerClientEvent("XCEL:PlaySound", source, "playMoney")
            XCELclient.notify(source, {"~g~You have received your armour."})
        else
            XCEL.ACBan(15,user_id,'XCEL:getArmour')
        end
    end
end)

local equipingplates = {}

function XCEL.ArmourPlate(src)
    local user_id = XCEL.getUserId(src)
    if GetPedArmour(GetPlayerPed(src)) < 100 then
        if not equipingplates[user_id] then
            if XCEL.tryGetInventoryItem(user_id,"armourplate",1) or XCEL.tryGetInventoryItem(user_id,"pd_armourplate",1) then
                equipingplates[user_id] = true
                TriggerClientEvent("XCEL:playArmourApplyAnim",src)
                Wait(5000)
                XCELclient.setArmour(src, {100})
                equipingplates[user_id] = false
                XCELclient.notify(src, {"~g~You have equipped an armour plate."})
            else
                XCELclient.notify(src, {"~r~You do not have any armour plates."})
            end
        else
            XCELclient.notify(src, {"~r~You are already equipping armour plates."})
        end
    else
        XCELclient.notify(src, {"~r~You already have 100% armour."})
    end
end