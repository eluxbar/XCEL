local cfg = {}
cfg.GunStores={
    ["policeLargeArms"]={
        ["_config"]={{vector3(1840.6104736328,3691.4741210938,33.350730895996),vector3(461.43179321289,-982.66412353516,29.689668655396),vector3(-440.69451904297,5987.109375,30.716192245483),vector3(-1102.5059814453,-820.62091064453,13.282785415649)},110,5,"MET Police Large Arms",{"police.armoury","police.loadshop2"},false,true}, 
        ["WEAPON_FLASHBANG"]={"Flashbang",0,0,"N/A","w_me_flashbang"},
        ["WEAPON_G36K"]={"G36K",0,0,"N/A","w_ar_g36k"}, 
        ["WEAPON_M4A1"]={"M4 Carbine",0,0,"N/A","w_ar_m4a1"}, 
        ["WEAPON_MP5"]={"MP5",0,0,"N/A","w_sb_mp5"},
        ["WEAPON_AX50"]={"AX-50",0,0,"N/A","w_sr_ax50"}, 
        ["WEAPON_SIGMCX"]={"SigMCX",0,0,"N/A","w_ar_sigmcx"},
        ["WEAPON_STAC"]={"STAC",0,0,"N/A","w_sr_stac"}, 
        ["WEAPON_M82A3"]={"M82A3",0,0,"N/A","w_sr_m82a3"},
        ["WEAPON_SPAR17"]={"SPAR17",0,0,"N/A","w_ar_spar17"},
        ["WEAPON_STING"]={"Sting 9mm",0,0,"N/A","w_sb_sting"},
    },
    ["policeSmallArms"]={
        ["_config"]={{vector3(461.53082275391,-979.35876464844,29.689668655396),vector3(1842.9096679688,3690.7692871094,33.267082214355),vector3(-442.54290771484,5988.7456054688,30.716192245483),vector3(-1104.5264892578,-821.70153808594,13.282785415649)},110,5,"MET Police Small Arms",{"police.armoury"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        ["WEAPON_PDGLOCK"]={"Glock",0,0,"N/A","w_pi_glock"},
        ["WEAPON_NIGHTSTICK"]={"Police Baton",0,0,"N/A","w_me_nightstick"},
        ["WEAPON_REMINGTON870"]={"Remington 870",0,0,"N/A","w_sg_remington870"},
        ["WEAPON_STAFFGUN"]={"Speed Gun",0,0,"N/A","w_pi_staffgun"},
        ["WEAPON_STUNGUN"]={"Tazer",0,0,"N/A","w_pi_stungun"},
        ["pd_armourplate"]={"Police Armour Plate",0,0,"N/A","prop_armour_pickup"},
    },
    ["prisonArmoury"]={
        ["_config"]={{vector3(1779.3741455078,2542.5639648438,45.797782897949)},110,5,"Prison Armoury",{"hmp.menu"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        ["WEAPON_PDGLOCK"]={"Glock",0,0,"N/A","w_pi_glock"},
        ["WEAPON_NIGHTSTICK"]={"Police Baton",0,0,"N/A","w_me_nightstick"},
        ["WEAPON_REMINGTON870"]={"Remington 870",0,0,"N/A","w_sg_remington870"},
        ["WEAPON_STUNGUN"]={"Tazer",0,0,"N/A","w_pi_stungun"},
    },
    ["NHS"]={
        ["_config"]={{vector3(340.41757202148,-582.71209716797,27.973259765625),vector3(-435.27032470703,-318.29010009766,34.08971484375)},110,5,"NHS Armoury",{"nhs.menu"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
    },
    ["LFB"]={
        ["_config"]={{vector3(1210.193359375,-1484.1494140625,34.241326171875),vector3(216.63296508789,-1648.6680908203,29.0179375)},110,5,"LFB Armoury",{"lfb.onduty.permission"},false,true},
        ["WEAPON_FLASHLIGHT"]={"Flashlight",0,0,"N/A","w_me_flashlight"},
        ["WEAPON_FIREAXE"]={"Fireaxe",0,0,"N/A","w_me_fireaxe"},
    },
    ["VIP"]={
        ["_config"]={{vector3(-2151.033203125,5191.3266601562,15.718821525574)},110,5,"VIP Gun Store",{"vip.gunstore"},true},
        ["WEAPON_GOLDAK"]={"Golden AK-47",750000,0,"N/A","w_ar_goldak"},
        ["WEAPON_FIREEXTINGUISHER"]={"Fire Extinguisher",10000,0,"N/A","prop_fire_exting_1b"},
        ["WEAPON_MJOLNIR"]={"Mjlonir",10000,0,"N/A","w_me_mjolnir"},
        ["WEAPON_MOLOTOV"]={"Molotov Cocktail",5000,0,"N/A","w_ex_molotov"},
        -- smoke grenade
        ["WEAPON_SNOWBALL"]={"Snowball",10000,0,"N/A","w_ex_snowball"},
    },
    ["Rebel"]={
        ["_config"]={{vector3(1545.2554931641,6331.5532226562,23.078569412231),vector3(4925.6259765625,-5243.0908203125,1.524599313736)},110,5,"Rebel Gun Store",{"rebellicense.whitelisted"},true},
        ["GADGET_PARACHUTE"]={"Parachute",1000,0,"N/A","p_parachute_s"},
        ["WEAPON_AK200"]={"AK-200",750000,0,"N/A","w_ar_akkal"},
        ["WEAPON_AKM"]={"AKM",700000,0,"N/A","w_ar_akm"},
        ["WEAPON_REVOLVER357"]={"Rebel Revolver",200000,0,"N/A","w_pi_revolver"},
        ["WEAPON_SPAZ"]={"Spaz 12",400000,0,"N/A","w_sg_spaz"},
        ["WEAPON_WINCHESTER12"]={"Winchester 12",350000,0,"N/A","w_sg_winchester12"},
        ["armourplate"]={"Armour Plate",100000,0,"N/A","prop_armour_pickup"},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup"},
        ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02"},
        ["item3"]={"LVL 3 Armour",75000,0,"N/A","prop_bodyarmour_03"},
        ["item4"]={"LVL 4 Armour",100000,0,"N/A","prop_bodyarmour_04"},
        ["item|fillUpArmour"]={"Replenish Armour",100000,0,"N/A","prop_armour_pickup"},
    },
    ["LargeArmsDealer"]={
        ["_config"]={{vector3(-1109.1381835938,4939.2758789062,223.12774658203),vector3(5065.6201171875,-4591.3857421875,1.8652405738831)},110,1,"Large Arms Dealer",{"gang.whitelisted"},false}, 
        ["WEAPON_GOLDAK"]={"AK-47 Assault Rifle",750000,0,"N/A","w_ar_goldak",750000},
        ["WEAPON_MOSIN"]={"Mosin Bolt-Action",1000000,0,"N/A","w_ar_mosin",1000000},
        ["WEAPON_OLYMPIA"]={"Olympia Shotgun",900000,0,"N/A","w_sg_olympia",900000},
        ["WEAPON_UMP45"]={"UMP45 SMG",350000,0,"N/A","w_sb_ump45",350000},
        ["WEAPON_UZI"]={"Uzi SMG",250000,0,"N/A","w_sb_uzi",250000},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup",25000},
        ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02",50000},
    },
    ["nhsSmallArms"]={
        ["_config"]={{vector3(304.52716064453,-600.37548828125,42.284084320068)},110,5,"NHS Combat Medic Small Arms",{"nhs.combatmedic"},false,true},
        ["WEAPON_PDGLOCK"]={"Glock",0,0,"N/A","w_pi_glock"},
        ["WEAPON_STUNGUN"]={"Tazer",0,0,"N/A","w_pi_stungun"},
    },
    ["SmallArmsDealer"]={ 
        ["_config"]={{vector3(2437.5708007813,4966.5610351563,41.34761428833),vector3(-1500.4978027344,-216.72758483887,46.889373779297),vector3(1242.7232666016,-426.84201049805,67.913963317871),vector3(1242.791,-426.7525,67.93467)},110,1,"Small Arms Dealer",{""},true},
        ["WEAPON_BERETTA"]={"Berreta M9 Pistol",60000,0,"N/A","w_pi_beretta"},
        ["WEAPON_M1911"]={"M1911 Pistol",60000,0,"N/A","w_pi_m1911"},
        ["WEAPON_MPX"]={"MPX",300000,0,"N/A","w_ar_mpx"},
        ["WEAPON_PYTHON"]={"Python .357 Revolver",50000,0,"N/A","w_pi_python"},
        ["WEAPON_ROOK"]={"Rook 9mm",60000,0,"N/A","w_pi_rook"},
        ["WEAPON_TEC9"]={"Tec-9",50000,0,"N/A","w_sb_tec9"},
        ["WEAPON_UMP45"]={"UMP-45",350000,0,"N/A","w_sb_ump45"},
        ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup"},
    },
    ["ScorpBlueDealer"]={ 
        ["_config"]={{vector3(-364.65805053711,6104.1313476562,35.439750671387)},110,1,"Scorpion Blue Dealer",{""},true},
        ["WEAPON_SCORPIONBLUE"]={"Scorpion Blue",700000,0,"N/A","w_sb_scorpionblue"},
        ["armourplate"]={"Armour Plate",100000,0,"N/A","prop_armour_pickup"},
        ["WEAPON_MOSIN"]={"Mosin Bolt-Action",1000000,0,"N/A","w_ar_mosin"},
    },
    ["Legion"]={
        ["_config"]={{vector3(-3171.5241699219,1087.5402832031,19.838747024536),vector3(-330.56484985352,6083.6059570312,30.454759597778),vector3(2567.6704101562,294.36923217773,107.70868457031)},154,1,"B&Q Tool Shop",{""},true},
        ["WEAPON_BROOM"]={"Broom",2500,0,"N/A","w_me_broom"},
        ["WEAPON_BASEBALLBAT"]={"Baseball Bat",2500,0,"N/A","w_me_baseballbat"},
        ["WEAPON_CLEAVER"]={"Cleaver",7500,0,"N/A","w_me_cleaver"},
        ["WEAPON_CRICKETBAT"]={"Cricket Bat",2500,0,"N/A","w_me_cricketbat"},
        ["WEAPON_DILDO"]={"Dildo",2500,0,"N/A","w_me_dildo"},
        ["WEAPON_FIREAXE"]={"Fireaxe",2500,0,"N/A","w_me_fireaxe"},
        ["WEAPON_GUITAR"]={"Guitar",2500,0,"N/A","w_me_guitar"},
        ["WEAPON_HAMAXEHAM"]={"Hammer Axe Hammer",2500,0,"N/A","w_me_hamaxeham"},
        ["WEAPON_KITCHENKNIFE"]={"Kitchen Knife",7500,0,"N/A","w_me_kitchenknife"},
        ["WEAPON_SHANK"]={"Shank",7500,0,"N/A","w_me_shank"},
        ["WEAPON_SLEDGEHAMMER"]={"Sledge Hammer",2500,0,"N/A","w_me_sledgehammer"},
        ["WEAPON_TOILETBRUSH"]={"Toilet Brush",2500,0,"N/A","w_me_toiletbrush"},
        ["WEAPON_TRAFFICSIGN"]={"Traffic Sign",2500,0,"N/A","w_me_trafficsign"},
        ["WEAPON_SHOVEL"]={"Shovel",2500,0,"N/A","w_me_shovel"},
    },
}
local organheist = module('cfg/cfg_organheist')

MySQL.createCommand("XCEL/get_weapons", "SELECT weapon_info FROM xcel_weapon_whitelists WHERE user_id = @user_id")
MySQL.createCommand("XCEL/set_weapons", "UPDATE xcel_weapon_whitelists SET weapon_info = @weapon_info WHERE user_id = @user_id")
MySQL.createCommand("XCEL/add_user", "INSERT IGNORE INTO xcel_weapon_whitelists SET user_id = @user_id")
MySQL.createCommand("XCEL/get_all_weapons", "SELECT * FROM xcel_weapon_whitelists")
MySQL.createCommand("XCEL/create_weapon_code", "INSERT IGNORE INTO xcel_weapon_codes SET user_id = @user_id, spawncode = @spawncode, weapon_code = @weapon_code")
MySQL.createCommand("XCEL/remove_weapon_code", "DELETE FROM xcel_weapon_codes WHERE weapon_code = @weapon_code")
MySQL.createCommand("XCEL/get_weapon_codes", "SELECT * FROM xcel_weapon_codes")

AddEventHandler("playerJoining", function()
    local user_id = XCEL.getUserId(source)
    MySQL.execute("XCEL/add_user", {user_id = user_id})
end)

function XCEL.getWhitelistGuns()
    return whitelistedGuns
end

whitelistedGuns = {
    ["policeLargeArms"]={
        ["WEAPON_MK18V2"]={"MK18 V2",0,0,"N/A","w_ar_mk18v2"},
    },
    -- ["policeSmallArms"]={},
    --["prisonArmoury"]={},
    -- ["NHS"]={},
    -- ["LFB"]={},
    -- ["VIP"]={
    --     ["WEAPON_WESTYARES"]={"Westy Ares",1000000,0,"N/A","w_mg_westyares"},
    --     ["WEAPON_ANIMEM16"]={"UWU AR",500000,0,"N/A","w_ar_animem16"},
    --     ["WEAPON_CBHONEYBADGER"]={"CB Honey Badger",1,0,"N/A","w_sb_cbhoneybadger"},
    --     ["WEAPON_YELLOWM4A1S"]={"Yellow Demon M4A1-S",900000,0,"N/A","w_ar_yellowm4a1s"},
    --     ["WEAPON_SCORPBLUE"]={"Scorpion Blue",350000,0,"N/A","w_sb_scorpionblue"},
    --     ["WEAPON_M4A1SPURPLE"]={"M4A1-S Purple",900000,0,"N/A","w_ar_m4a1spurple"},
    --     ["WEAPON_BARRET50NRP"]={"Barret 50 Cal",1000000,0,"N/A", "w_sr_barret50cal"},
    --     ["WEAPON_WAZEYCHAINSLXCEL"]={"Wazey Cum Blaster",2000000,0,"N/A","w_mg_wazeychains"},
    --     ["WEAPON_MP5K"]={"MP5K",0,0,"N/A","w_sb_mp5k"},
    -- },
    -- ["Rebel"]={},
    ["LargeArmsDealer"] = {
        ["WEAPON_WESTYARES"]={"Westy Ares",1000000,0,"N/A","w_mg_westyares"},
        ["WEAPON_TEMPERED"]={"Tempered M249",2000000,0,"N/A","w_mg_m249tempered"},
        ["WEAPON_ANIMEM16"]={"Anime M16",900000,0,"N/A","w_ar_animem16"},
        ["WEAPON_SPACEFLIGHTMP5"]={"Space Flight MP5",450000,0,"N/A","w_sb_spaceflightmp5"},
        ["WEAPON_CBHONEYBADGER"]={"CB Honey Badger",1,0,"N/A","w_sb_cbhoneybadger"},
        ["WEAPON_YELLOWM4A1S"]={"Yellow Demon M4A1-S",900000,0,"N/A","w_ar_yellowm4a1s"},
        ["WEAPON_HINEDERE"]={"Hinedere",900000,0,"N/A","w_ar_hinedere"},
        ["WEAPON_SINGULARITYPHANTOM"]={"Singularity Phantom",900000,0,"N/A","w_ar_singularityphantom"},
        ["WEAPON_SCORPIONBLUE"]={"Scorpion Blue",350000,0,"N/A","w_sb_scorpionblue"},
        ["WEAPON_M4A1SPURPLE"]={"M4A1-S Purple",900000,0,"N/A","w_ar_m4a1spurple"},
        ["WEAPON_GRAU"]={"Grau",900000,0,"N/A","w_ar_grau"},
        ["WEAPON_1928BAR"]={"1928 Browning",900000,0,"N/A","w_ar_1928bar"},
        ["WEAPON_BARRET50NRP"]={"Barret 50 Cal",1000000,0,"N/A", "w_sr_barret50cal"},
        ["WEAPON_WAZEYCHAINSLXCEL"]={"Wazey Cum Blaster",2000000,0,"N/A","w_mg_wazeychains"},
        ["WEAPON_M249PLAYMAKER"]={"M249 Playmaker",2000000,0,"N/A","w_mg_m249playmaker"},
        ["WEAPON_RAUDNIMP5CMG"]={"Sad MP5K",450000,0,"N/A","w_sb_raudnimp5k"},
        ["WEAPON_LILUZI"]={"LIL UZI SMG",450000,0,"N/A","w_sb_liluzi"},
        ["WEAPON_GLC"]={"Glacier Mosin",1000000,0,"N/A","w_ar_glmosin"},
        ["WEAPON_LVMOSIN"]={"Louis Vuitton Mosin",1000000,0,"N/A","w_ar_lvmosin"},
        ["WEAPON_UNI"]={"Uni Mosin",1000000,0,"N/A","w_ar_soimosin"},
        ["WEAPON_MP5K"]={"MP5K",0,0,"N/A","w_sb_mp5k"},
        ["WEAPON_CHERRYMOSIN"]={"CHERRY BLOSSOM MOSIN",1000000,0,"N/A","w_ar_cherrymosin"},
        ["WEAPON_NERFMOSIN"]={"NERF MOSIN",1000000,0,"N/A","w_ar_nerfmosin"},
        ["WEAPON_NOVMOSIN"]={"NO VANITY MOSIN",1000000,0,"N/A","w_ar_novmosin"},
        ["WEAPON_M82BLOSSOM"]={"M82 BLOSSOM",2500000,0,"N/A","w_sr_m82blossom"},
        ["WEAPON_CMPCARBINE"]={"CMP CARBINE",750000,0,"N/A","w_ar_cmpcarbine"},
        ["WEAPON_LR300WHITE"]={"LR 300 WHITE",750000,0,"N/A","w_ar_lr300white"},
        ["WEAPON_M4A1NIGHTMARE"]={"M4A1-S Nightmare",900000,0,"N/A","w_ar_m4a1nightmare"},
    },
    ["SmallArmsDealer"] = {
    },
    ["Legion"] = {
        ["WEAPON_PIGEON"]={"Pigeon",7000,0,"N/A","w_me_pigeon"},
    },
}

local VIPWithPlat = {
    ["item1"]={"LVL 1 Armour",25000,0,"N/A","prop_armour_pickup"},
    ["item2"]={"LVL 2 Armour",50000,0,"N/A","prop_bodyarmour_02"},
    ["item3"]={"LVL 3 Armour",75000,0,"N/A","prop_bodyarmour_03"},
    ["item4"]={"LVL 4 Armour",100000,0,"N/A","prop_bodyarmour_04"},
    ["item|fillUpArmour"]={"Replenish Armour",100000,0,"N/A","prop_armour_pickup"},
}

local RebelWithAdvanced = {
    -- mk1emr
    ["WEAPON_MXM"]={"MXM",950000,0,"N/A","w_ar_mxm"},
    ["WEAPON_SPAR16"]={"Spar 16",900000,0,"N/A","w_ar_spar16"},
    ["WEAPON_MK1EMR"]={"MK1-EMR",900000,0,"N/A","w_ar_mk1emr"},
   -- ["WEAPON_SVDCMG"]={"Draganov SVD",2500000,0,"N/A","w_sr_svd"},
    ["WEAPON_MK14"]={"MK14",1850000,0,"N/A","w_sr_mk14"},
}


function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

RegisterNetEvent("XCEL:getCustomWeaponsOwned")
AddEventHandler("XCEL:getCustomWeaponsOwned",function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local ownedWhitelists = {}
    MySQL.query("XCEL/get_weapons", {user_id = user_id}, function(weaponWhitelists)
        if weaponWhitelists[1]['weapon_info'] then
            data = json.decode(weaponWhitelists[1]['weapon_info'])
            for k,v in pairs(data) do
                for a,b in pairs(v) do
                    for c,d in pairs(whitelistedGuns) do
                        for e,f in pairs(d) do
                            if e == a then
                                ownedWhitelists[a] = b[1]
                            end
                        end
                    end
                end
            end
            TriggerClientEvent('XCEL:gotCustomWeaponsOwned', source, ownedWhitelists)
        end
    end)
end)

RegisterNetEvent("XCEL:requestWhitelistedUsers")
AddEventHandler("XCEL:requestWhitelistedUsers",function(spawncode)
    local source = source
    local user_id = XCEL.getUserId(source)
    local whitelistOwners = {}
    MySQL.query("XCEL/get_all_weapons", {}, function(weaponWhitelists)
        for k,v in pairs(weaponWhitelists) do
            if v['weapon_info'] then
                data = json.decode(v['weapon_info'])
                for a,b in pairs(data) do
                    if b[spawncode] then
                        whitelistOwners[v['user_id']] = (exports['xcel']:executeSync("SELECT username FROM xcel_users WHERE id = @user_id", {user_id = v['user_id']})[1]).username
                    end
                end
            end
        end
        TriggerClientEvent('XCEL:getWhitelistedUsers', source, whitelistOwners)
    end)
end)

RegisterNetEvent("XCEL:generateWeaponAccessCode")
AddEventHandler("XCEL:generateWeaponAccessCode", function(spawncode, id)
    local source = source
    local user_id = XCEL.getUserId(source)
    local code = math.random(100000, 999999)
    print("[XCEL] - Weapon Code: " .. id .. " Spawn Code: " .. spawncode .. " Code: " .. code)
    MySQL.execute("XCEL/create_weapon_code", {user_id = id, spawncode = spawncode, weapon_code = code})
    TriggerClientEvent('XCEL:generatedAccessCode', source, code)
end)

RegisterCommand("genwl", function(source, args)
    if args and args[1] and args[2] then
        local code = generateUUID("weapon_whitelist_code", 6, "numerical")
        MySQL.execute("XCEL/create_weapon_code", {user_id = args[1], spawncode = args[2], weapon_code = code})
        print("[XCEL] - Weapon Code: " .. args[1] .. " Spawn Code: " .. args[2] .. " Code: " .. code)
    else
        print("[XCEL] - Invalid Arguments, /genwl [user_id] [spawncode]")
    end
end)

function XCEL.RefreshGunstoreData(user_id)
    MySQL.query("XCEL/get_weapons", {user_id = user_id}, function(weaponWhitelists)
        local gunstoreData = deepcopy(cfg.GunStores)
        if weaponWhitelists and #weaponWhitelists > 0 then
            if weaponWhitelists[1]['weapon_info'] then
                local data = json.decode(weaponWhitelists[1]['weapon_info'])
                for a,b in pairs(gunstoreData) do
                    for c,d in pairs(data) do
                        if a == c then
                            for e,f in pairs(data[a]) do
                                gunstoreData[a][e] = f
                            end
                        end
                    end
                end
            end
        end
        XCEL.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                if plathours > 0 and XCEL.hasPermission(user_id, "vip.gunstore") then
                    for k,v in pairs(VIPWithPlat) do
                        gunstoreData["VIP"][k] = v
                    end
                end
            end
            if XCEL.hasPermission(user_id, 'advancedrebel.license') then
                for k,v in pairs(RebelWithAdvanced) do
                    gunstoreData["Rebel"][k] = v
                end
            end
            TriggerClientEvent('XCEL:recieveFilteredGunStoreData', XCEL.getUserSource(user_id), gunstoreData)
        end)
    end)
end

RegisterNetEvent("XCEL:requestNewGunshopData")
AddEventHandler("XCEL:requestNewGunshopData",function()
    local source = source
    XCEL.RefreshGunstoreData(XCEL.getUserId(source))
end)

function gunStoreLogs(weaponshop, webhook, title, text)
    if weaponshop == 'policeLargeArms' or weaponshop == 'policeSmallArms' then
        XCEL.sendWebhook('pd-armoury', 'XCEL Police Armoury Logs', text)
    elseif weaponshop == 'NHS' then
        XCEL.sendWebhook('nhs-armoury', 'XCEL NHS Armoury Logs', text)
    elseif weaponshop == 'prisonArmoury' then
        XCEL.sendWebhook('hmp-armoury', 'XCEL HMP Armoury Logs', text)
    elseif weaponshop == 'LFB' then
        XCEL.sendWebhook('lfb-armoury', 'XCEL LFB Armoury Logs', text)
    end
    XCEL.sendWebhook(webhook,title,text)
end

local function gunstorePurchase(user_id, price, weaponshop, vipstore)
    if XCEL.tryFullPayment(user_id, price) then
        return true
    elseif vipstore and XCEL.tryFullPayment(user_id, price) then
        return true
    elseif weaponshop == 'VIP' and XCEL.tryFullPayment(user_id, price) then
        return true
    end
    XCELclient.notify(XCEL.getUserSource(user_id), {'~r~You do not have enough money for this purchase.'})
    return false
end

RegisterNetEvent("XCEL:buyWeapon")
AddEventHandler("XCEL:buyWeapon",function(spawncode, price, name, weaponshop, purchasetype, vipstore)
    local source = source
    local user_id = XCEL.getUserId(source)
    local hasPerm = false
    local gunstoreData = deepcopy(cfg.GunStores)
    MySQL.query("XCEL/get_weapons", {user_id = user_id}, function(weaponWhitelists)
        local gunstoreData = deepcopy(cfg.GunStores)
        if weaponWhitelists[1]['weapon_info'] then
            local data = json.decode(weaponWhitelists[1]['weapon_info'])
            for a,b in pairs(gunstoreData) do
                for c,d in pairs(data) do
                    if a == c then
                        for e,f in pairs(data[a]) do
                            gunstoreData[a][e] = f
                        end
                    end
                end
            end
        end
        for k,v in pairs(gunstoreData[weaponshop]) do
            if k == '_config' then
                local withinRadius = true
                for a,b in pairs(v[1]) do
                    if #(GetEntityCoords(GetPlayerPed(source)) - b) < 10 then
                        withinRadius = true
                    end
                end
                if vipstore then
                    if #(GetEntityCoords(GetPlayerPed(source)) - gunstoreData["VIP"]['_config'][1][1] ) < 10 then
                        withinRadius = true
                    end
                end
                for c,d in pairs(organheist.locations) do
                    for e,f in pairs(d.gunStores) do
                        for g,h in pairs(f) do
                            if #(GetEntityCoords(GetPlayerPed(source)) - h[3]) < 10 then
                                withinRadius = true
                            end
                        end
                    end
                end
                if json.encode(v[5]) ~= '[""]' then
                    local hasPermissions = 0
                    for a,b in pairs(v[5]) do
                        if XCEL.hasPermission(user_id, b) then
                            hasPermissions = hasPermissions + 1
                        end
                    end
                    if hasPermissions == #v[5] then
                        hasPerm = true
                    end
                else
                    hasPerm = true
                end
                XCEL.getSubscriptions(user_id, function(cb, plushours, plathours)
                    if cb then
                        if plathours > 0 and XCEL.hasPermission(user_id, "vip.gunstore") then
                            for k,v in pairs(VIPWithPlat) do
                                gunstoreData["VIP"][k] = v
                            end
                        end
                    end
                    if XCEL.hasPermission(user_id, 'advancedrebel.license') then
                        for k,v in pairs(RebelWithAdvanced) do
                            gunstoreData["Rebel"][k] = v
                        end
                    end
                    for c,d in pairs(gunstoreData[weaponshop]) do
                        if c ~= '_config' then
                            if hasPerm then
                                if c == spawncode then
                                    if name == d[1] then
                                        if purchasetype == 'armour' then
                                            if string.find(spawncode, "fillUp") then
                                                price = (100 - GetPedArmour(GetPlayerPed(source))) * 1000
                                                if gunstorePurchase(user_id, price, weaponshop, vipstore) then
                                                    XCELclient.notifyPicture(source, {"monzo", "monzo", "Purchased " .. name .. " for ~g~£" .. getMoneyStringFormatted(price) .. ".", "Monzo", "Gunstore purchase"})
                                                    TriggerClientEvent("XCEL:PlaySound", source, "playMoney")
                                                    XCELclient.setArmour(source, {100, true})
                                                    gunStoreLogs(weaponshop, 'weapon-shops',"XCEL Weapon Shop Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                                    return
                                                end
                                            elseif GetPedArmour(GetPlayerPed(source)) >= (price/1000) then
                                                XCELclient.notify(source, {'~r~You already have '..GetPedArmour(GetPlayerPed(source))..'% armour.'})
                                                return
                                            end
                                            if gunstorePurchase(user_id, price, weaponshop, vipstore) then
                                                XCELclient.notifyPicture(source, {"monzo", "monzo", "Purchased " .. name .. " for ~g~£" .. getMoneyStringFormatted(price) .. ".", "Monzo", "Gunstore purchase"})
                                                TriggerClientEvent("XCEL:PlaySound", source, "playMoney")
                                                XCELclient.setArmour(source, {price/1000, true})
                                                gunStoreLogs(weaponshop, 'weapon-shops',"XCEL Weapon Shop Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                                if weaponshop == 'LargeArmsDealer' then
                                                    XCEL.turfSaleToGangFunds(price, 'LargeArms')
                                                end
                                            else
                                                XCELclient.notify(source, {'~r~You do not have enough money for this purchase.'})
                                                TriggerClientEvent("XCEL:PlaySound", source, 2)
                                            end
                                        elseif purchasetype == 'weapon' then
                                            if spawncode ~= "armourplate" then
                                                XCELclient.hasWeapon(source, {spawncode}, function(hasWeapon)
                                                    if hasWeapon then
                                                        XCELclient.notify(source, {'~r~You must store your current '..name..' before purchasing another.'})
                                                    else
                                                        if gunstorePurchase(user_id, price, weaponshop, vipstore) then
                                                            if price > 0 then
                                                                XCELclient.notifyPicture(source, {"monzo", "monzo", "Purchased " .. name .. " for ~g~£" .. getMoneyStringFormatted(price) .. ".", "Monzo", "Gunstore purchase"})
                                                                if weaponshop == 'LargeArmsDealer' then
                                                                    XCEL.turfSaleToGangFunds(price, 'LargeArms')
                                                                end
                                                            else
                                                                XCELclient.notify(source, {'~g~'..name..' purchased.'})
                                                            end
                                                            TriggerClientEvent("XCEL:PlaySound", source, "playMoney")
                                                            XCELclient.giveWeapons(source, {{[spawncode] = {ammo = 250}}, false})
                                                            gunStoreLogs(weaponshop, 'weapon-shops',"XCEL Weapon Shop Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                                        else
                                                            XCELclient.notify(source, {'~r~You do not have enough money for this purchase.'})
                                                            TriggerClientEvent("XCEL:PlaySound", source, 2)
                                                        end
                                                    end
                                                end)
                                            else
                                                if XCEL.getInventoryWeight(user_id) + 5 <= XCEL.getInventoryMaxWeight(user_id) then
                                                    if gunstorePurchase(user_id, price, weaponshop, vipstore) then
                                                        XCELclient.notifyPicture(source, {"monzo", "monzo", "Purchased " .. name .. " for ~g~£" .. getMoneyStringFormatted(price) .. ".", "Monzo", "Gunstore purchase"})
                                                        XCEL.giveInventoryItem(user_id, 'armourplate', 1)
                                                        TriggerClientEvent("XCEL:PlaySound", source, "playMoney")
                                                        gunStoreLogs(weaponshop, 'weapon-shops',"XCEL Weapon Shop Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                                    else
                                                        XCELclient.notify(source, {'~r~You do not have enough money for this purchase.'})
                                                        TriggerClientEvent("XCEL:PlaySound", source, 2)
                                                    end
                                                else
                                                    XCELclient.notify(source, {'~r~You do not have enough space in your inventory for this purchase.'})
                                                    TriggerClientEvent("XCEL:PlaySound", source, 2)
                                                end
                                            end
                                        elseif purchasetype == 'ammo' then
                                            price = price/2
                                            if gunstorePurchase(user_id, price, weaponshop, vipstore) then
                                                if price > 0 then
                                                    XCELclient.notifyPicture(source, {"monzo", "monzo", "Purchased 250x Ammo for ~g~£" .. getMoneyStringFormatted(price) .. ".", "Monzo", "Gunstore purchase"})
                                                    if weaponshop == 'LargeArmsDealer' then
                                                        XCEL.turfSaleToGangFunds(price, 'LargeArms')
                                                    end
                                                else
                                                    XCELclient.notifyPicture(source, {"monzo", "monzo", "Purchased 250x Ammo", "Monzo", "Gunstore purchase"})
                                                end
                                                TriggerClientEvent("XCEL:PlaySound", source, "playMoney")
                                                XCELclient.giveWeapons(source, {{[spawncode] = {ammo = 250}}, false})
                                                gunStoreLogs(weaponshop, 'weapon-shops',"XCEL Weapon Shop Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                            else
                                                XCELclient.notify(source, {'~r~You do not have enough money for this purchase.'})
                                                TriggerClientEvent("XCEL:PlaySound", source, 2)
                                            end
                                        end
                                    end
                                end
                            else
                                if weaponshop == 'policeLargeArms' or weaponshop == 'policeSmallArms' or weaponshop == 'nhsSmallArms' then
                                    XCELclient.notify(source, {"~r~You shouldn't be in here, ALARM TRIGGERED!!!"})
                                else
                                    XCELclient.notify(source, {"~r~You do not have permission to access this store."})
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
end)
