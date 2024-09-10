loadouts = {
    ['Basic'] = {
        permission = "police.armoury",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
        },
    },
    ['SCO-19'] = {
        permission = "police.loadshop2",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
            "WEAPON_G36K",
        },
    },
    ['CTSFO'] = {
        permission = "police.maxarmour",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_PDGLOCK",
            "WEAPON_SPAR17",
            "WEAPON_AX50",
            "WEAPON_FLASHBANG",
        },
    }
}


RegisterNetEvent('XCEL:getPoliceLoadouts')
AddEventHandler('XCEL:getPoliceLoadouts', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local loadoutsTable = {}
    if XCEL.hasPermission(user_id, 'police.armoury') then
        for k,v in pairs(loadouts) do
            v.hasPermission = XCEL.hasPermission(user_id, v.permission) 
            loadoutsTable[k] = v
        end
        TriggerClientEvent('XCEL:gotLoadouts', source, loadoutsTable)
    end
end)

RegisterNetEvent('XCEL:selectLoadout')
AddEventHandler('XCEL:selectLoadout', function(loadout)
    local source = source
    local user_id = XCEL.getUserId(source)
    for k,v in pairs(loadouts) do
        if k == loadout then
            if XCEL.hasPermission(user_id, 'police.armoury') and XCEL.hasPermission(user_id, v.permission) then
                for a,b in pairs(v.weapons) do
                    XCELclient.giveWeapons(source, {{[b] = {ammo = 250}}, false})
                    XCELclient.setArmour(source, {100, true})
                end
                XCELclient.notify(source, {"~g~Received "..loadout.." loadout."})
            else
                XCELclient.notify(source, {"~r~You do not have permission to select this loadout"})
            end
        end
    end
end)