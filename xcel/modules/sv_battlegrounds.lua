local cfg = module("cfg/cfg_battleroyale")
local lootTable = {"WEAPON_AK200","WEAPON_SPAR16","WEAPON_M4A1","WEAPON_UMP45","WEAPON_UZI","WEAPON_MOSIN"}

--[[ Functions ]]--
local function Reset(locationid)
    currentRoyale = {lootBoxes = {},armourPlates = {}}
    for i = 1,#cfg.locations[locationid].armourLocations do
        currentRoyale.armourPlates[i] = false
    end
    for i = 1,#cfg.locations[locationid].lootLocations do
        currentRoyale.lootBoxes[i] = false
    end
end

local function GetLocationID(locationname)
    if locationname == "Legion" then
        return 1
    elseif locationname == "Sandy Shores" then
        return 2
    elseif locationname == "Paleto" then
        return 3
    end
    return "Unknown"
end

--[[ Events ]]
AddEventHandler("XCEL:Event:BattleRoyale", function(locationname)
    local locationID = GetLocationID(locationname)
    Reset(locationID)
    for _, tbl in pairs(CurrentEvent.players) do
        XCEL.setBucket(tbl.source, "battle_royale")
        TriggerClientEvent("XCEL:startBattlegrounds", tbl.source, locationID)
        TriggerClientEvent("XCEL:syncLootboxesTable", tbl.source, locationname)
        TriggerClientEvent("XCEL:EventStarting", tbl.source)
        XCELclient.setArmour(tbl.source, {50})
    end
end)

RegisterServerEvent("XCEL:removeArmourPlate", function(plateId)
    local source = source
    local user_id = XCEL.getUserId(source)
    if not currentRoyale.armourPlates[plateId] then
        if CurrentEvent.players[user_id] then
            currentRoyale.armourPlates[plateId] = true
            XCELclient.setArmour(source, {100})
            TriggerClientEvent("XCEL:removeArmourPlateCl", -1, plateId)
        else
            XCEL.ACBan(15, user_id, "XCEL:removeArmourPlate")
        end
    else
        XCELclient.notify(source, {"~r~This armour plate has already been used"})
    end
end)

RegisterServerEvent("XCEL:LootBox", function(boxId)
    local source = source
    local user_id = XCEL.getUserId(source)
    if not currentRoyale.lootBoxes[boxId] then
        if CurrentEvent.players[user_id] then
            currentRoyale.lootBoxes[boxId] = true
            local randomWeapon = lootTable[math.random(1,#lootTable)]
            XCELclient.giveWeapons(source, {{[randomWeapon] = {ammo = 250}}, false, globalpasskey})
            XCELclient.notify(source,{string.format("~g~You have received a %s",getWeaponName(randomWeapon))})
            TriggerClientEvent("XCEL:removeLootBox", -1, boxId)
        end
    else
        XCEL.notify(source, "~r~This loot box has already been used")
    end
end)