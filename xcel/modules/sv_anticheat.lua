local processingac = {}
local actypes = {
    [1] = "Spawning Weapons",
    [2] = "ESX Shared Object",
    [3] = "Thermal Vision",
    [4] = "Blacklisted Event",
    [5] = "Weapon Modifier",
    [6] = "Noclip",
    [7] = "Spectating",
    [8] = "Eulen Freecam",
    [9] = "Mod Menu",
    [10] = "Infinite Combat Roll",
    [11] = "Semi Godmode",
    [12] = "Godmode",
    [13] = "Invisibility", -- Dont know why this is a thing?
    [14] = "Nui Dev Tool",
    [15] = "Triggering Events",
    [16] = "Explosion Event",
    [17] = "Remove Weapons",
    [18] = "Give Weapons",
    [19] = "Clear Ped Tasks",
    [20] = "Anti Eulen",
    [21] = "Repairing Vehicle's",
    [24] = "Health/Armour Modification",
    [25] = "Resource Started",
    [26] = "Resource Stopped",
}
local BlacklistedEvents = {
    "esx:getSharedObject",
    "bank:transfer",
    "esx_ambulancejob:revive",
    "esx-qalle-jail:openJailMenu",
    "esx_jailer:wysylandoo",
    "esx_policejob:getarrested",
    "esx_society:openBossMenu",
    "esx:spawnVehicle",
    "esx_status:set",
    "HCheat:TempDisableDetection",
    "UnJP",
    "8321hiue89js",
    "adminmenu:allowall",
    "AdminMenu:giveBank",
    "AdminMenu:giveCash",
    "AdminMenu:giveDirtyMoney",
    "Tem2LPs5Para5dCyjuHm87y2catFkMpV",
    "esx_dmvschool:pay"
}


local blockedItems = {
	[841438406] = true,
    [-473353655] = true,
    [-1327155414] = true,
    [-109599267] = true,
    [566160949] = true,
    [1121747524] = true,
    [-133291774] = true,
    [-552807189] = true,
    [1803116220] = true,
    [522807189] = true,
    [1803116220] = true,
    [552807189] = true,
    [3821613641] = true,
    [3295673357] = true,
    [2967811882] = true,
    [4185368029] = true,
    [516505552] = true,
    [-1980613044] = true,
    [-2130482718] = true,
    [1765283457] = true,
    [-699955605] = true,
    [1865929795] = true,
    [1325339411] = true,
    [-2071359746] = true,
    [-1576911260] = true,
    [-512634970] = true,
    [-999293939] = true,
    [1885233650] = true,
    [1289401397] = true,
    [2088441666] = true,
    [-111377536] = true,
    [22143489] = true,
    [-1111377536] = true,
    [137575484] = true,
    [206865238] = true,
    [-46303329] = true,
    [1708919037] = true,
    [959265690] = true,
    [-1043459709] = true,
    [1885712733] = true,
    [-1008818392] = true,
    [133481871] = true,
    [1185249461] = true,
    [-1011638209] = true,
    [-1279773008] = true,
    [-1268580434] = true,
    [1920863736] = true,
    --[1336576410] = true,
    [-417505688] = true,
    [-220552467] = true,
    [68070371] = true,
    [-1660909656] = true,
    [71929310] = true,
    [-1863364300] = true,
    [-57685738] = true,
    [1264920838] = true,
    [-1044093321] = true,
    [-1699520669] = true,
    [-835930287] = true,
    [1813637474] = true,
    [880829941] = true,
    [2109968527] = true,
    [-1404353274] = true,
    [-1920001264] = true,
    [959275690] = true,
    [2046537925] = true,
    [131073] = true,
}


AddEventHandler('entityCreating', function(entity)
    if blockedItems[GetEntityModel(entity)] then
        CancelEvent()
    else
        print("Entity Creating: "..GetEntityModel(entity))
    end
end)

AddEventHandler("XCEL:playerSpawn",function(user_id,source,first_spawn)
    if first_spawn then
        processingac[user_id] = {active = false, link = ""}
    end
end)

RegisterServerEvent("XCEL:ACBan",function(actype,extrainfo)
    local source = source
    local user_id = XCEL.getUserId(source)
    local extrainfo = extrainfo or "None Provided"
    if not user_id then -- If player hasn't spawned yet
        return
    end
    if user_id ~= 1 then
        if processingac[user_id] and not processingac[user_id].active then
            if actypes[tonumber(actype)] then
                XCEL.ACBan(actype,user_id,extrainfo)
            else
                XCEL.ACBan(15,user_id,extrainfo)
            end
        end
    else
        XCELclient.notify(source, {"[AC]\nType #"..actype.."\nExtra: "..extrainfo})
    end
end)

RegisterServerEvent("XCEL:sendVehicleStats",function(Afterbodyhealth,previousbodyhealth,Afterenginehealth,previousenginehealth,Afterpetroltankhealth,previouspetroltankhealth,Afterentityhealth,previousentityhealth,passangers,vehiclehash)
    local source = source
    XCEL.ACBan(21,XCEL.getUserId(source),"> Vehicle Hash: "..vehiclehash.."\n> Body Health: "..previousbodyhealth.." -> "..Afterbodyhealth.."\n> Engine Health: "..previousenginehealth.." -> "..Afterenginehealth.."\n> Petrol Tank Health: "..previouspetroltankhealth.." -> "..Afterpetroltankhealth.."\n> Entity Health: "..previousentityhealth.." -> "..Afterentityhealth)
end)
 
function XCEL.VideoProcessed(user_id,link)
    processingac[user_id].link = link
end

function XCEL.ACBan(actype,user_id,extrainfo)
    local playersource = XCEL.getUserSource(user_id)
    if user_id ~= 1 then
        if not processingac[user_id].active and actypes[tonumber(actype)] then
            local name = XCEL.GetPlayerName(user_id) or "Unknown"
            processingac[user_id] = {active = true, link = ""}
            print("Currently Processing AC Ban for "..name.." with type "..actype.." and extra info "..extrainfo)
            if playersource then
                TriggerClientEvent("XCEL:takeClientVideoAndUpload",playersource,XCEL.getWebhook('media-cache'),"Anticheat")
                SetTimeout(120000,function()
                    if processingac[user_id].link == "" then
                        processingac[user_id].link = "**Couldn't fetch video**"
                    end
                end)
                while processingac[user_id].link == "" do
                    Wait(100)
                end
            end
            print("User " .. name .. " is now banned")
            XCEL.banConsole(user_id,"perm","Cheating Type #"..actype)
            TriggerClientEvent("chatMessage",-1,"^1"..name.." ^3 has been banned for cheating! ",{180,0,0},"Type #"..actype,"alert")
            exports['xcel']:execute("INSERT INTO `xcel_anticheat` (`user_id`, `username`, `reason`, `extra`) VALUES (@user_id, @username, @reason, @extra);", {user_id = user_id, username = name, reason = "Type #"..actype, extra = extrainfo}, function() end)
            XCEL.sendWebhook('anticheat', 'Anticheat Ban', "> Players Name: **"..name.."**\n> Players Perm ID: **"..user_id.."**\n> Reason: **Type #"..actype.."**\n> Type Meaning: **"..actypes[tonumber(actype)].."**\n> Extra Info: **"..extrainfo.."**\n> Video: "..(processingac[user_id].link or "**Couldn't fetch video**"))
            processingac[user_id].active = {active = false, link = ""}
        end
    else
        XCELclient.notify(playersource, {"[AC]\nType #"..actype.."\nExtra: "..extrainfo})
    end
end

AddEventHandler("explosionEvent", function(source, ev)
    local source = source
    local user_id = XCEL.getUserId(source)
    local explosionTypes = {
        [0] = "Grenade",
        [25] = "Flashbang",
        [61] = "Anti lag",
    }
    if ev.explosionType ~= 61 then
        local explosionName = explosionTypes[ev.explosionType] or type(ev.explosionType)
        print("Explosion Event "..ev.explosionType.. " | "..explosionName.. " | Owner: "..XCEL.GetPlayerName(user_id))
    end
    for _,explosiontype in pairs({1,2,5,32,33,35,36,37,38,45,82}) do
        if ev.explosionType == explosiontype then
            ev.damageScale = 0.0
            local user_id = XCEL.getUserId(source)
           -- CancelEvent()
            XCEL.ACBan(16,user_id,"Explosion Type: "..explosiontype)
        end
    end
end)

AddEventHandler("removeWeaponEvent",function(source)
    CancelEvent()
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.ACBan(17,user_id,"Attempted to remove weapon")
end)

AddEventHandler("removeAllWeaponsEvent",function(source)
    CancelEvent()
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.ACBan(17,user_id,"Attempted to remove all weapons")
end)

AddEventHandler("giveWeaponEvent",function(source)
    CancelEvent()
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.ACBan(18,user_id,"Attempted to give weapon")
end)

AddEventHandler("clearPedTasksEvent",function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.ACBan(19,user_id,"Attempted to clear ped tasks")
end)

for i, eventName in ipairs(BlacklistedEvents) do
    RegisterNetEvent(eventName, function()
        local source = source
        local user_id = XCEL.getUserId(source)
        XCEL.ACBan(4,user_id,"Blacklisted Event: "..eventName)
    end)
end

<<<<<<< HEAD
AddEventHandler('weaponDamageEvent', function(source, attacker, victim, weaponHash, isMeleeDamage, damageGiven)
    if damageGiven ~= nil and damageGiven > 199 then
        local user_id = XCEL.getUserId(source)
        XCEL.ACBan(22, user_id, "Magic Bullet Detected: Damage Given - " .. damageGiven)
    end
end)

AddEventHandler('playerShotEvent', function(attacker, hitPed, hitHeadshot)
    local source = source
    local user_id = XCEL.getUserId(source)
    
    if hitHeadshot then
        playerAccuracy[user_id] = (playerAccuracy[user_id] or 0) + 1
    end
    
    if playerAccuracy[user_id] >= 5 then 
        XCEL.ACBan(23, user_id, "Aimbot Detected: Consecutive Headshots - " .. playerAccuracy[user_id])
        playerAccuracy[user_id] = 0
    end
end)

AddEventHandler('playerFiredWeaponEvent', function(attacker, weaponHash, shotTime)
    local source = source
    local user_id = XCEL.getUserId(source)
    local currentTime = GetGameTimer()

    if lastShotTime[user_id] and (currentTime - lastShotTime[user_id] < 100) then 
        XCEL.ACBan(25, user_id, "Weapon Manipulation Detected: Rapid Fire")
    end

    lastShotTime[user_id] = currentTime
end)
=======
-- // Thread Checks \\ --
>>>>>>> parent of 3bc1f50 (tweak(AC))

Citizen.CreateThread(function()
    Wait(15000)
    while true do
        for perm,src in pairs(XCEL.getUsers()) do
            local Ped = GetPlayerPed(src)
            if GetPedArmour(Ped) > 100 then
                XCEL.ACBan(21,perm,"Armour Modification "..GetPedArmour(Ped))
            end
            if GetEntityHealth(Ped) > 200 then
                XCEL.ACBan(24,perm,"Health Modification "..GetEntityHealth(Ped))
            end
        end
        Wait(10000)
    end
end)

RegisterServerEvent("XCEL:CheckKVP")
AddEventHandler("XCEL:CheckKVP", function(kvpid, original_user_id)
    if kvpid then
        if original_user_id ~= kvpid then
            XCEL.sendWebhook("multi-account","XCEL Multi Account Logs","> Player Current Perm ID: **" .. original_user_id .. "**\n> Player Other Perm ID: **" .. kvpid .. "**")
        end
        XCEL.isBanned(kvpid, function(R)
            if R then
                XCEL.banConsole(d, "perm", "1.11 Ban Evading")
                XCEL.sendWebhook("CheckDevicesrs","XCEL Ban Evade Logs","> Player Name: **"..e.."**\n> Player Current Perm ID: **" .. original_user_id .. "**\n> Player Banned Perm ID: **" .. kvpid .. "**")
            end
        end)
    end
end)

decor = generateUUID("decor", 15, "alphanumeric")
globalpasskey = generateUUID("globalpasskey", 15, "alphanumeric")
Citizen.CreateThread(function()
    Wait(2500)
    exports['xcel']:execute([[
    CREATE TABLE IF NOT EXISTS `xcel_anticheat` (
    `ban_id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `username` VARCHAR(100) NOT NULL,
    `reason` VARCHAR(100) NOT NULL,
    `extra` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`ban_id`)
    );]])
   -- print("[XCEL] ^2Anticheat tables initialised.^0")
end)