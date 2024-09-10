local cfg = module("cfg/player_state")
local a = module("cfg/weapons")
local purgecfg = module("cfg/cfg_purge")
local lang = XCEL.lang

baseplayers = {}
proplist = {
    "prop_fire_hydrant_1",
    "prop_fire_hydrant_2",
    "prop_bin_01a",
    "prop_postbox_01a",
    "prop_phonebox_04",
    "prop_sign_road_03m",
    "prop_sign_road_05e",
    "prop_sign_road_03g",
    "prop_sign_road_04a",
    "prop_consign_01a",
    "prop_barrier_work01d",
    "prop_sign_road_05a",
    "prop_bin_05a",
    "prop_sign_road_05za",
    "prop_sign_road_02a",
    "prop_bin_05a",
    "prop_sign_road_01a",
    "prop_sign_road_03e",
    "prop_forsalejr1",
    "prop_letterbox_01",
    "prop_sign_road_03",
    "prop_parknmeter_02",
    "prop_rub_binbag_03d",
    "prop_elecbox_08",
    "prop_rub_binbag_04",
    "prop_rub_binbag_05",
    "prop_cratepile_03a",
    "prop_crate_01a",
    "prop_sign_road_07a",
    "prop_rub_trolley_01a",
    "prop_highway_paddle",
    "prop_barrier_work06a",
    "prop_cactus_01d",
    "prop_generator_03a",
    "prop_bin_06a",
    "prop_food_bs_juice03",
    "prop_bollard_02a",
    "prop_rub_cardpile_03",
    "prop_bin_07c",
    "prop_rub_cage01e",
    "prop_rub_cage01c",
    "prop_rub_binbag_03b",
    "prop_bin_08a",
    "prop_barrel_02a",
    "prop_rub_binbag_06",
    "prop_pot_plant_04b",
    "prop_rub_cage01a",
    "prop_rub_cage01c",
    "prop_bin_03a",
    "prop_afsign_amun",
    "prop_bin_07a",
    "prop_pallet_pile_01",
    "prop_shopsign_01",
    "prop_traffic_01a",
    "prop_rub_binbag_03",
    "prop_rub_boxpile_04",
}
AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    XCEL.getFactionGroups(source)
    local data = XCEL.getUserDataTable(user_id)
    local tmpdata = XCEL.getUserTmpTable(user_id)
    local playername = XCEL.GetPlayerName(user_id)
    TriggerEvent("XCEL:AddChatModes", source)

    if first_spawn then
        if data.customization == nil then
            data.customization = cfg.default_customization
        end

        if data.invcap == nil then
            data.invcap = 30
        end

        XCEL.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                if user_id == 1 or user_id == 3 then
                    data.invcap = 1000
                elseif plathours > 0 and data.invcap < 50 then
                    data.invcap = 50
                elseif plushours > 0 and data.invcap < 40 then
                    data.invcap = 40
                else
                    data.invcap = 30
                end
            end
        end)

        if data.position == nil and cfg.spawn_enabled then
            local x = cfg.spawn_position[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local y = cfg.spawn_position[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local z = cfg.spawn_position[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            data.position = { x = x, y = y, z = z }
        end

        if data.customization ~= nil then
            if XCEL.isPurge() then
                TriggerClientEvent("XCEL:purgeSpawnClient", source)
            else
                XCELclient.spawnAnim(source, {})
            end

            if data.weapons ~= nil then
                XCELclient.giveWeapons(source, {data.weapons, true})
            end

            XCELclient.setUserID(source, {user_id})
            XCELclient.setdecor(source, {decor, proplist})

            if XCEL.hasGroup(user_id, 'Founder') or XCEL.hasGroup(user_id, 'Lead Developer') or XCEL.hasGroup(user_id,"Developer") then
                TriggerClientEvent("XCEL:SetDev", source)
            end

            if XCEL.hasPermission(user_id, 'cardev.menu') then
                TriggerClientEvent('XCEL:setCarDev', source)
            end

            if XCEL.hasPermission(user_id, 'police.armoury') then
                XCELclient.setPolice(source, {true})
                TriggerClientEvent('XCEL:globalOnPoliceDuty', source, true)
            end

            if XCEL.hasPermission(user_id, 'nhs.menu') then
                XCELclient.setNHS(source, {true})
                TriggerClientEvent('XCEL:globalOnNHSDuty', source, true)
            end

            if XCEL.hasPermission(user_id, 'hmp.menu') then
                XCELclient.setHMP(source, {true})
                TriggerClientEvent('XCEL:globalOnPrisonDuty', source, true)
            end

            if XCEL.hasGroup(user_id, 'Taco Seller') then
                TriggerClientEvent('XCEL:toggleTacoJob', source, true)
            end

            if XCEL.hasGroup(user_id, 'Police Horse Trained') then
                XCELclient.setglobalHorseTrained(source, {})
            end

            local adminlevel = 0
            if XCEL.hasGroup(user_id,"Founder") then
                adminlevel = 12
            elseif XCEL.hasGroup(user_id,"Lead Developer") or XCEL.hasGroup(user_id,"Developer") then
                adminlevel = 11
            elseif XCEL.hasGroup(user_id,"Community Manager") then
                adminlevel = 10
            elseif XCEL.hasGroup(user_id,"Staff Manager") then    
                adminlevel = 9
            elseif XCEL.hasGroup(user_id,"Head Administrator") then
                adminlevel = 8
            elseif XCEL.hasGroup(user_id,"Senior Administrator") then
                adminlevel = 6
            elseif XCEL.hasGroup(user_id,"Administrator") then
                adminlevel = 5
            elseif XCEL.hasGroup(user_id,"Senior Moderator") then
                adminlevel = 4
            elseif XCEL.hasGroup(user_id,"Moderator") then
                adminlevel = 3
            elseif XCEL.hasGroup(user_id,"Support Team") then
                adminlevel = 2
            elseif XCEL.hasGroup(user_id,"Trial Staff") then
                adminlevel = 1
            end

            TriggerClientEvent("XCEL:SetStaffLevel", source, adminlevel)
            TriggerEvent('XCEL:FiveGuard:givePermissionToPlayer', user_id)
            TriggerClientEvent('XCEL:ForceRefreshData', -1)
            TriggerClientEvent('XCEL:sendGarageSettings', source)

            players = XCEL.getUsers({})
            for k,v in pairs(players) do
                baseplayers[v] = XCEL.getUserId(v)
            end
            XCELclient.setBasePlayers(source, {baseplayers})
        else
            if data.weapons ~= nil then -- load saved weapons
                XCELclient.giveWeapons(source, {data.weapons, true})
            end

            if data.health ~= nil then
                XCELclient.setHealth(source, {data.health})
            end
        end

    else -- not first spawn (player died), don't load weapons, empty wallet, empty inventory
        XCEL.clearInventory(user_id)
        XCELclient.setHandcuffed(source, {false})
    end
end)


function tXCEL.updateWeapons(weapons)
    local user_id = XCEL.getUserId(source)
    if user_id ~= nil then
        local data = XCEL.getUserDataTable(user_id)
        if data ~= nil then
            data.weapons = weapons
        end
    else 
        print('Error occured, user does not exist could not save weapons.')
    end
end



Citizen.CreateThread(function()
    while true do
        Wait(60000)
        for k, v in pairs(XCEL.getUsers()) do
            local data = XCEL.getUserDataTable(k)
            if data ~= nil then
                if data.PlayerTime ~= nil then
                    data.PlayerTime = tonumber(data.PlayerTime) + 1
                else
                    data.PlayerTime = 1
                end
            end
            if XCEL.hasPermission(k, 'police.armoury') then
           --     print('Police on duty')
                local lastClockedRank = string.gsub(getGroupInGroups(k, 'Police'), ' Clocked', '')
                local user_id = k
                local username = XCEL.GetPlayerName(user_id)
                local weekly_hours = 1 / 60
                local total_hours = 1 / 60
                local last_clocked_rank = lastClockedRank
                local last_clocked_date = os.date("%d/%m/%Y")
                local total_players_fined = 0
                local total_players_jailed = 0
                local sql = "INSERT INTO xcel_police_hours (user_id, username, weekly_hours, total_hours, last_clocked_rank, last_clocked_date, total_players_fined, total_players_jailed) VALUES (?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE weekly_hours = weekly_hours + 1/60, total_hours = total_hours + 1/60, username = ?, last_clocked_rank = ?, last_clocked_date = ?, total_players_fined = ?, total_players_jailed = ?"
                exports['xcel']:execute(sql, user_id, username, weekly_hours, total_hours, last_clocked_rank, last_clocked_date, total_players_fined, total_players_jailed, username, last_clocked_rank, last_clocked_date, total_players_fined, total_players_jailed)
            end
        end
    end
end)



function XCEL.updateInvCap(user_id, invcap)
    if user_id ~= nil then
        local data = XCEL.getUserDataTable(user_id)
        if data ~= nil then
            if data.invcap ~= nil then
                data.invcap = invcap
                if user_id == 1 or user_id == 3 then
                    data.invcap = 1000
                end
            else
                data.invcap = 30
            end
        end
    end
end


function XCEL.setBucket(source, bucket)
    local source = source
    local user_id = XCEL.getUserId(source)
    SetPlayerRoutingBucket(source, bucket)
    TriggerClientEvent('XCEL:setBucket', source, bucket)
end

local isStoring = {}
AddEventHandler('XCEL:StoreWeaponsRequest', function(source)
    local player = source 
    local user_id = XCEL.getUserId(player)
	XCELclient.getWeapons(player,{},function(weapons)
        if not isStoring[player] then
            isStoring[player] = true
            XCELclient.giveWeapons(player,{{},true}, function(removedwep)
                for k,v in pairs(weapons) do
                    if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' and k~= 'WEAPON_SMOKEGRENADE' and k~= 'WEAPON_FLASHBANG' then
                        if v.ammo > 0 and k ~= 'WEAPON_STUNGUN' then
                            for i,c in pairs(a.weapons) do
                                if i == k then
                                    XCEL.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                                end   
                            end
                        end
                    end
                end
                XCELclient.notify(player,{"~g~Weapons Stored"})
                SetTimeout(3000,function()
                      isStoring[player] = nil 
                end)
            end)
        else
            XCELclient.notify(player,{"~o~Your weapons are already being stored hmm..."})
        end
    end)
end)
function XCEL.isPurge()
    return purgecfg.active
end

RegisterServerEvent('requestUserId')
AddEventHandler('requestUserId', function()
    local _source = source
    local userId = XCEL.getUserId(_source) -- Retrieve user ID
    TriggerClientEvent('receiveUserId', _source, userId)
end)

RegisterNetEvent('XCEL:forceStoreWeapons')
AddEventHandler('XCEL:forceStoreWeapons', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local data = XCEL.getUserDataTable(user_id)
    Wait(3000)
    if data ~= nil then
        data.inventory = {}
    end
    XCEL.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            local invcap = 30
            if user_id == 1 or user_id == 3 then
                invcap = 1000
            elseif plathours > 0 then
                invcap = invcap + 20
            elseif plushours > 0 then
                invcap = invcap + 10
            end
            if invcap == 30 then
            return
            end
            if data.invcap - 15 == invcap then
            XCEL.giveInventoryItem(user_id, "offwhitebag", 1, false)
            elseif data.invcap - 20 == invcap then
            XCEL.giveInventoryItem(user_id, "guccibag", 1, false)
            elseif data.invcap - 30 == invcap  then
            XCEL.giveInventoryItem(user_id, "nikebag", 1, false)
            elseif data.invcap - 35 == invcap  then
            XCEL.giveInventoryItem(user_id, "huntingbackpack", 1, false)
            elseif data.invcap - 40 == invcap  then
            XCEL.giveInventoryItem(user_id, "greenhikingbackpack", 1, false)
            elseif data.invcap - 70 == invcap  then
            XCEL.giveInventoryItem(user_id, "rebelbackpack", 1, false)
            end
            XCEL.updateInvCap(user_id, invcap)
        end
    end)
end)



RegisterServerEvent("XCEL:AddChatModes", function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    local main = {
        name = "Global",
        displayName = "Global",
        isChannel = "Global",
        isGlobal = true,
    }
    local ooc = {
        name = "OOC",
        displayName = "OOC",
        isChannel = "OOC",
        isGlobal = false,
    }
    TriggerClientEvent('chat:addMode', source, main)
    TriggerClientEvent('chat:addMode', source, ooc)
end)