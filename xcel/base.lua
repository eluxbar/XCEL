MySQL = module("modules/MySQL")

Proxy = module("lib/Proxy")
Tunnel = module("lib/Tunnel")
Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
local version = module("version")
local WhiteListed = false
local verify_card = {
    ["type"] = "AdaptiveCard",
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.3",
    ["backgroundImage"] = {
        ["url"] = "https://cdn.discordapp.com/attachments/1195851571150467097/1210381117983694908/yup.png?ex=660609c2&is=65f394c2&hm=54b2baacf47d017d0046bc0c37612bda6bde0231b174b29b94fe9f50d5a14124&",
    },
    ["body"] = {
        {
            ["type"] = "TextBlock",
            ["text"] = "",
            ["horizontalAlignment"] = "Center",
            ["size"] = "Large",
            ["wrap"] = true,
            ["weight"] = "Bolder"
        },
        {
            ["type"] = "Container",
            ["horizontalAlignment"] = "Center",
            ["size"] = "Large",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["text"] = "In order to connect to XCEL you must be in our discord and verify your account",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["text"] = "Join the XCEL discord (discord.gg/xcel5m)",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["text"] = "In the #verify channel, type the following command",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["color"] = "Attention",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["text"] = "!verify NULL",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["color"] = "Attention",
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ["text"] = "Your account has not beem verified yet. (Attempt 0)",
                    ["wrap"] = false,
                }
            }
        },
        {
            ['type'] = 'ActionSet',
            ["horizontalAlignment"] = "Center",
            ["size"] = "Large",
            ['actions'] = {
                {
                    ['type'] = 'Action.Submit',
                    ['title'] = 'Enter XCEL',
                    ["horizontalAlignment"] = "Center",
                    ["size"] = "Large",
                    ['id'] = 'connectButton', -- Add an ID to the button action
                    ['data'] = {
                        ['action'] = 'connectClicked',
                    },
                },             
            },
        },
    }
}

local connecting_card = {
    ["type"] = "AdaptiveCard",
    ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
    ["version"] = "1.3",
    ["body"] = {
        {
            ["type"] = "TextBlock",
            ["text"] = "Connecting To XCEL #1",
            ["horizontalAlignment"] = "Left",
            ["size"] = "Large",
            ["wrap"] = true,
            ["weight"] = "Bolder"
        },
        {
            ["type"] = "Container",
            ["horizontalAlignment"] = "Left",
            ["size"] = "Large",
            ["items"] = {
                {
                    ["type"] = "TextBlock",
                    ["text"] = "You must be in our Discord and Verify your account.",
                    ["horizontalAlignment"] = "Left",
                    ["size"] = "Large",
                    ["wrap"] = false,
                },
                {
                    ["type"] = "TextBlock",
                    ["color"] = "White",
                    ["text"] = "Your ID is: ", 
                    ["wrap"] = true,
                    ["size"] = "Medium",
                    ["horizontalAlignment"] = "Left",
                },
            }
        },
        {
            ["type"] = "TextBlock",
            ["text"] = string.rep("🟩", 0) .. string.rep("⬜", 100), -- Initial progress bar
            ["wrap"] = true
        },
        {
            ['type'] = 'ActionSet',
            ["horizontalAlignment"] = "Left",
            ["size"] = "Large",
            ['actions'] = {
                {
                    ['type'] = 'Action.OpenUrl',
                    ['title'] = 'XCEL Discord',
                    ["horizontalAlignment"] = "Left",
                    ["size"] = "Large",
                    ["url"] = "https://discord.gg/xcel5m",
                },          
            },
        },
    }
}


Debug.active = config.debug
XCEL = {}
Proxy.addInterface("XCEL",XCEL)

tXCEL = {}
Tunnel.bindInterface("XCEL",tXCEL) -- listening for client tunnel

-- load language 
local dict = module("cfg/lang/"..config.lang) or {}
XCEL.lang = Lang.new(dict)

-- init
XCELclient = Tunnel.getInterface("XCEL","XCEL") -- server -> client tunnel

XCEL.users = {} -- will store logged users (id) by first identifier
XCEL.rusers = {} -- store the opposite of users
XCEL.user_tables = {} -- user data tables (logger storage, saved to database)
XCEL.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
XCEL.user_sources = {} -- user sources 
Citizen.CreateThread(function()
    Wait(1000) -- Wait for GHMatti to Initialize
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_users(
    id INTEGER AUTO_INCREMENT,
    last_login VARCHAR(100),
    username VARCHAR(100),
    license VARCHAR(100),
    banned BOOLEAN,
    bantime VARCHAR(100) NOT NULL DEFAULT "",
    banreason VARCHAR(1000) NOT NULL DEFAULT "",
    banadmin VARCHAR(100) NOT NULL DEFAULT "",
    baninfo VARCHAR(2000) NOT NULL DEFAULT "",
    last_kit_usage INT NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS cardevs (
    userid varchar(255),
    reportscompleted int,
    currentreport int,
    PRIMARY KEY(userid)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS cardev (
    reportid int NOT NULL AUTO_INCREMENT,
    spawncode varchar(255),
    issue varchar(255), 
    reporter varchar(255), 
    claimed varchar(255),
    completed boolean,
    notes varchar(255),
    PRIMARY KEY (reportid)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_user_data(
    user_id INTEGER,
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_user_moneys(
    user_id INTEGER,
    wallet bigint,
    bank bigint,
    offshore bigint,
    CONSTRAINT pk_user_moneys PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_srv_data(
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_user_vehicles(
    user_id INTEGER,
    vehicle VARCHAR(100),
    vehicle_plate varchar(255) NOT NULL,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    locked BOOLEAN NOT NULL DEFAULT 0,
    fuel_level FLOAT NOT NULL DEFAULT 100,
    impounded BOOLEAN NOT NULL DEFAULT 0,
    impound_info varchar(2048) NOT NULL DEFAULT '',
    impound_time VARCHAR(100) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_user_identities(
    user_id INTEGER,
    registration VARCHAR(100),
    phone VARCHAR(100),
    firstname VARCHAR(100),
    name VARCHAR(100),
    age INTEGER,
    CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
    INDEX(registration),
    INDEX(phone)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_warnings (
    warning_id INT AUTO_INCREMENT,
    user_id INT,
    warning_type VARCHAR(25),
    duration INT,
    admin VARCHAR(100),
    warning_date DATE,
    reason VARCHAR(2000),
    point INT,
    PRIMARY KEY (warning_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_gangs (
    gangname VARCHAR(255) NULL DEFAULT NULL,
    gangmembers VARCHAR(3000) NULL DEFAULT NULL,
    funds BIGINT NULL DEFAULT NULL,
    logs VARCHAR(3000) NULL DEFAULT NULL,
    gangfit TEXT DEFAULT NULL,
    chat_tag VARCHAR(3000) NULL DEFAULT NULL,
    lockedfunds BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (gangname)
    )
    ]])              
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_user_notes (
    user_id INT,
    info VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_user_homes(
    user_id INTEGER,
    home VARCHAR(100),
    number INTEGER,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_homes PRIMARY KEY(home),
    UNIQUE(home,number)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_bans_offenses(
    UserID INTEGER AUTO_INCREMENT,
    Rules TEXT NULL DEFAULT NULL,
    points INT(10) NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(UserID)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_dvsa(
    user_id INT(11),
    licence VARCHAR(100) NULL DEFAULT NULL,
    testsaves VARCHAR(1000) NULL DEFAULT NULL,
    points VARCHAR(500) NULL DEFAULT NULL,
    id VARCHAR(500) NULL DEFAULT NULL,
    datelicence VARCHAR(500) NULL DEFAULT NULL,
    penalties VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_subscriptions (
    user_id INT(11),
    plathours FLOAT(10) NULL DEFAULT NULL,
    plushours FLOAT(10) NULL DEFAULT NULL,
    last_used VARCHAR(100) NOT NULL DEFAULT "",
    redeemed INT DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY (user_id)
    );
    ]]);      
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_casino_chips(
    user_id INT(11),
    chips bigint NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_verification(
    user_id INT(11),
    code VARCHAR(100) NULL DEFAULT NULL,
    discord_id VARCHAR(100) NULL DEFAULT NULL,
    verified TINYINT NULL DEFAULT NULL,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_users_contacts (
    id int(11) NOT NULL AUTO_INCREMENT,
    identifier varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
    number varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
    display varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1',
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_messages (
    id int(11) NOT NULL AUTO_INCREMENT,
    transmitter varchar(10) NOT NULL,
    receiver varchar(10) NOT NULL,
    message varchar(255) NOT NULL DEFAULT '0',
    time timestamp NOT NULL DEFAULT current_timestamp(),
    isRead int(11) NOT NULL DEFAULT 0,
    owner int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_calls (
    id int(11) NOT NULL AUTO_INCREMENT,
    owner varchar(10) NOT NULL COMMENT 'Num such owner',
    num varchar(10) NOT NULL COMMENT 'Reference number of the contact',
    incoming int(11) NOT NULL COMMENT 'Defined if we are at the origin of the calls',
    time timestamp NOT NULL DEFAULT current_timestamp(),
    accepts int(11) NOT NULL COMMENT 'Calls accept or not',
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_app_chat (
    id int(11) NOT NULL AUTO_INCREMENT,
    channel varchar(20) NOT NULL,
    message varchar(255) NOT NULL,
    time timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_community_pot (
    xcel VARCHAR(65) NOT NULL,
    value BIGINT(11) NOT NULL,
    PRIMARY KEY (xcel)
    );
    ]])
    MySQL.SingleQuery([[
    INSERT IGNORE INTO xcel_community_pot (value) VALUES (1)
    ]])  
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_quests (
    user_id INT(11),
    quests_completed INT(11) NOT NULL DEFAULT 0,
    reward_claimed BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_weapon_whitelists (
    user_id INT(11),
    weapon_info varchar(2048) DEFAULT '{}',
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_weapon_codes (
    user_id INT(11),
    spawncode varchar(2048) NOT NULL DEFAULT '',
    weapon_code int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (weapon_code)
    );
    ]])
    MySQL.SingleQuery([[
CREATE TABLE IF NOT EXISTS xcel_prison (
    user_id INT(11) NOT NULL,
    prison_time INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
);
 

    
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_staff_tickets (
    user_id INT(11),
    ticket_count INT(11) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_daily_rewards (
    user_id INT(11),
    last_reward INT(11) NOT NULL DEFAULT 0,
    streak INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS `xcel_user_tokens` (
    `token` varchar(200) NOT NULL,
    `user_id` int(11) DEFAULT NULL,
    `banned` tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`token`)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS `xcel_user_device` (
    `devices` longtext NOT NULL,
    `user_id` int(11) DEFAULT NULL,
    `banned` tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`user_id`)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_police_hours (
    user_id INT(11),
    weekly_hours FLOAT(10) NOT NULL DEFAULT 0,
    total_hours FLOAT(10) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    last_clocked_date VARCHAR(100) NOT NULL,
    last_clocked_rank VARCHAR(100) NOT NULL,
    total_players_fined INT(11) NOT NULL DEFAULT 0,
    total_players_jailed INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS xcel_stores (
    code VARCHAR(255) NOT NULL,
    item VARCHAR(255) NOT NULL,
    date VARCHAR(255) NOT NULL,
    user_id INT(11),
    PRIMARY KEY (code)
    );
    ]])
    MySQL.SingleQuery("ALTER TABLE xcel_users ADD IF NOT EXISTS bantime varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE xcel_users ADD IF NOT EXISTS banreason varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE xcel_users ADD IF NOT EXISTS banadmin varchar(100) NOT NULL DEFAULT ''; ")
    MySQL.SingleQuery("ALTER TABLE xcel_user_vehicles ADD IF NOT EXISTS rented BOOLEAN NOT NULL DEFAULT 0;")
    MySQL.SingleQuery("ALTER TABLE xcel_user_vehicles ADD IF NOT EXISTS rentedid varchar(200) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE xcel_user_vehicles ADD IF NOT EXISTS rentedtime varchar(2048) NOT NULL DEFAULT '';")
    MySQL.createCommand("XCELls/create_modifications_column", "alter table xcel_user_vehicles add if not exists modifications text not null")
	MySQL.createCommand("XCELls/update_vehicle_modifications", "update xcel_user_vehicles set modifications = @modifications where user_id = @user_id and vehicle = @vehicle")
	MySQL.createCommand("XCELls/get_vehicle_modifications", "select modifications, vehicle_plate from xcel_user_vehicles where user_id = @user_id and vehicle = @vehicle")
	MySQL.execute("XCELls/create_modifications_column")
    print("[XCEL] ^2Base tables initialised.^0")
end)

MySQL.createCommand('XCEL/CreateUser', 'INSERT INTO xcel_users(license,banned) VALUES(@license,false)')
MySQL.createCommand('XCEL/GetUserByLicense', 'SELECT id FROM xcel_users WHERE license = @license')
MySQL.createCommand("XCEL/AddIdentifier", "INSERT INTO xcel_user_ids (identifier, user_id, banned) VALUES(@identifier, @user_id, false)")
MySQL.createCommand("XCEL/GetUserByIdentifier", "SELECT user_id FROM xcel_user_ids WHERE identifier = @identifier")
MySQL.createCommand("XCEL/GetIdentifiers", "SELECT identifier FROM xcel_user_ids WHERE user_id = @user_id")
MySQL.createCommand("XCEL/BanIdentifier", "UPDATE xcel_user_ids SET banned = @banned WHERE identifier = @identifier")

MySQL.createCommand("XCEL/identifier_all","SELECT * FROM xcel_user_ids WHERE identifier = @identifier")
MySQL.createCommand("XCEL/select_identifier_byid_all","SELECT * FROM xcel_user_ids WHERE user_id = @id")

MySQL.createCommand("XCEL/set_userdata","REPLACE INTO xcel_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
MySQL.createCommand("XCEL/get_userdata","SELECT dvalue FROM xcel_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("XCEL/set_srvdata","REPLACE INTO xcel_srv_data(dkey,dvalue) VALUES(@key,@value)")
MySQL.createCommand("XCEL/get_srvdata","SELECT dvalue FROM xcel_srv_data WHERE dkey = @key")

MySQL.createCommand("XCEL/get_banned","SELECT banned FROM xcel_users WHERE id = @user_id")
MySQL.createCommand("XCEL/set_banned","UPDATE xcel_users SET banned = @banned, bantime = @bantime,  banreason = @banreason,  banadmin = @banadmin, baninfo = @baninfo WHERE id = @user_id")
MySQL.createCommand("XCEL/set_identifierbanned","UPDATE xcel_user_ids SET banned = @banned WHERE identifier = @iden")
MySQL.createCommand("XCEL/getbanreasontime", "SELECT * FROM xcel_users WHERE id = @user_id")

MySQL.createCommand("XCEL/set_last_login","UPDATE xcel_users SET last_login = @last_login WHERE id = @user_id")
MySQL.createCommand("XCEL/get_last_login","SELECT last_login FROM xcel_users WHERE id = @user_id")

--Token Banning 
MySQL.createCommand("XCEL/add_token","INSERT INTO xcel_user_tokens(token,user_id) VALUES(@token,@user_id)")
MySQL.createCommand("XCEL/check_token","SELECT user_id, banned FROM xcel_user_tokens WHERE token = @token")
MySQL.createCommand("XCEL/check_token_userid","SELECT token FROM xcel_user_tokens WHERE user_id = @id")
MySQL.createCommand("XCEL/ban_token","UPDATE xcel_user_tokens SET banned = @banned WHERE token = @token")
MySQL.createCommand("XCEL/delete_token","DELETE FROM xcel_user_tokens WHERE token = @token")
--Device Banning
MySQL.createCommand("device/add_info", "INSERT IGNORE INTO xcel_user_device SET user_id = @user_id")
MySQL.createCommand("XCEL/get_device", "SELECT devices FROM xcel_user_device WHERE user_id = @user_id")
MySQL.createCommand("XCEL/set_device", "UPDATE xcel_user_device SET devices = @devices WHERE user_id = @user_id")
MySQL.createCommand("XCEL/get_device_banned", "SELECT banned FROM xcel_user_device WHERE devices = @devices")
MySQL.createCommand("XCEL/check_device_userid","SELECT devices FROM xcel_user_device WHERE user_id = @id")
MySQL.createCommand("XCEL/ban_device","UPDATE xcel_user_device SET banned = @banned WHERE devices = @devices")
MySQL.createCommand("XCEL/check_device","SELECT user_id, banned FROM xcel_user_device WHERE devices = @devices")
MySQL.createCommand("ac/delete_ban","DELETE FROM xcel_anticheat WHERE @user_id = user_id")

function XCEL.getUsers()
    local users = {}
    for k,v in pairs(XCEL.user_sources) do
        users[k] = v
    end
    return users
end


-- [[ User Information ]] --


function XCEL.checkidentifiers(userid,identifier,cb)
    for A,B in pairs(identifier) do
        MySQL.query("XCEL/GetUserByIdentifier", {identifier = B}, function(rows, affected)
            if rows[1] then
                if rows[1].id ~= userid then
                    XCEL.isBanned(rows[1].id, function(banned)
                        if banned then
                            cb(true, rows[1].id,"Ban Evading",B)
                        else
                            cb(true, rows[1].id,"Multi Accounting",B)
                        end
                    end)
                end
            else
                if string.find(B, "ip:") == nil then
                    MySQL.query("XCEL/AddIdentifier", {identifier = B, user_id = userid})
                end
            end
        end)
    end
end

function XCEL.getUserByLicense(license, cb)
    MySQL.query('XCEL/GetUserByLicense', {license = license}, function(rows, affected)
        if rows[1] then
            cb(rows[1].id)
        else
            MySQL.query('XCEL/CreateUser', {license = license}, function(rows, affected)
                if rows.affectedRows > 0 then
                    XCEL.getUserByLicense(license, cb)
                end
            end)
            for k, v in pairs(XCEL.getUsers()) do
                XCELclient.notify(v, {'~g~You have received £25,000 as someone new has joined the server.'})
                XCEL.giveBankMoney(k, 25000)
            end
        end
    end)
end


function XCEL.SetIdentifierban(user_id,banned)
    MySQL.query("XCEL/GetIdentifiers", {user_id = user_id}, function(rows)
        if banned then
            for i=1, #rows do
                MySQL.query("XCEL/BanIdentifier", {identifier = rows[i].identifier, banned = true})
                Wait(50)
            end
        else
            for i=1, #rows do
                MySQL.query("XCEL/BanIdentifier", {identifier = rows[i].identifier, banned = false})
            end
        end
    end)
end

-- return identification string for the source (used for non XCEL identifications, for rejected players)
function XCEL.getSourceIdKey(source)
    local Identifiers = GetPlayerIdentifiers(source)
    local idk = "idk_"
    for k,v in pairs(Identifiers) do
        idk = idk..v
    end
    return idk
end

--- sql

function XCEL.ReLoadChar(source)
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    if ids.license then
        XCEL.getUserByLicense(ids.license, function(user_id)
            XCEL.GetDiscordName(user_id)
            Wait(250)
            if user_id then
                local name = XCEL.GetPlayerName(user_id) 
                XCEL.StoreTokens(source, user_id) 
                if XCEL.rusers[user_id] == nil then
                    XCEL.users[Identifiers[1]] = user_id
                    XCEL.rusers[user_id] = Identifiers[1]
                    XCEL.user_tables[user_id] = {}
                    XCEL.user_tmp_tables[user_id] = {}
                    XCEL.user_sources[user_id] = source
                    XCEL.getUData(user_id, "XCEL:datatable", function(sdata)
                        local data = json.decode(sdata)
                        if type(data) == "table" then XCEL.user_tables[user_id] = data end
                        local tmpdata = XCEL.getUserTmpTable(user_id)
                        XCEL.getLastLogin(user_id, function(last_login)
                            tmpdata.last_login = last_login or ""
                            tmpdata.spawns = 0
                            local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                            MySQL.execute("XCEL/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                            print("[XCEL] "..name.." ^2Joined^0 | Perm ID: "..user_id)
                            TriggerEvent("XCEL:playerJoin", user_id, source, name, tmpdata.last_login)
                            TriggerClientEvent("XCEL:CheckIdRegister", source)
                        end)
                    end)
                else -- already connected
                    print("[XCEL] "..name.." ^2Re-Joined^0 | Perm ID: "..user_id)
                    TriggerEvent("XCEL:playerRejoin", user_id, source, name)
                    TriggerClientEvent("XCEL:CheckIdRegister", source)
                    local tmpdata = XCEL.getUserTmpTable(user_id)
                    tmpdata.spawns = 0
                end
            end
        end)
    end
end

exports("xcel", function(method_name, params, cb)
    if cb then 
        cb(XCEL[method_name](table.unpack(params)))
    else 
        return XCEL[method_name](table.unpack(params))
    end
end)

RegisterNetEvent("XCEL:CheckID")
AddEventHandler("XCEL:CheckID", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if not user_id then
        XCEL.ReLoadChar(source)
    end
end)

function XCEL.isBanned(user_id, cbr)
    local task = Task(cbr, {false})
    MySQL.query("XCEL/get_banned", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].banned})
        else
            task()
        end
    end)
end
function XCEL.getLastLogin(user_id, cbr)
    local task = Task(cbr,{""})
    MySQL.query("XCEL/get_last_login", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].last_login})
        else
            task()
        end
    end)
end

function XCEL.fetchBanReasonTime(user_id,cbr)
    MySQL.query("XCEL/getbanreasontime", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then 
            cbr(rows[1].bantime, rows[1].banreason, rows[1].banadmin)
        end
    end)
end

function XCEL.setUData(user_id,key,value)
    MySQL.execute("XCEL/set_userdata", {user_id = user_id, key = key, value = value})
end

function XCEL.getUData(user_id,key,cbr)
    local task = Task(cbr,{""})
    MySQL.query("XCEL/get_userdata", {user_id = user_id, key = key}, function(rows, affected)
        if rows and #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function XCEL.setSData(key,value)
    MySQL.execute("XCEL/set_srvdata", {key = key, value = value})
end

function XCEL.getSData(key, cbr)
    local task = Task(cbr,{""})
    MySQL.query("XCEL/get_srvdata", {key = key}, function(rows, affected)
        if rows and #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

-- return user data table for XCEL internal persistant connected user storage
function XCEL.getUserDataTable(user_id)
    return XCEL.user_tables[user_id]
end

function XCEL.getUserTmpTable(user_id)
    return XCEL.user_tmp_tables[user_id]
end

function XCEL.isConnected(user_id)
    return XCEL.rusers[user_id] ~= nil
end

function XCEL.isFirstSpawn(user_id)
    local tmp = XCEL.getUserTmpTable(user_id)
    return tmp and tmp.spawns == 1
end

function XCEL.getUserId(source)
    if source then
        local Identifiers = GetPlayerIdentifiers(source)
        if Identifiers and #Identifiers > 0 then
            return XCEL.users[Identifiers[1]]
        end
    end
    return nil
end

exports("getUserId", XCEL.getUserId)

-- return source or nil
function XCEL.getUserSource(user_id)
    return XCEL.user_sources[user_id]
end

function XCEL.IdentifierBanCheck(source,user_id,cb)
    for i,v in pairs(GetPlayerIdentifiers(source)) do 
        MySQL.query('XCEL/identifier_all', {identifier = v}, function(rows)
            for i = 1,#rows do 
                if rows[i].banned then 
                    if user_id ~= rows[i].user_id then 
                        cb(true, rows[i].user_id, v)
                    end 
                end
            end
        end)
    end
end

function XCEL.BanIdentifiers(user_id, value)
    MySQL.query('XCEL/select_identifier_byid_all', {id = user_id}, function(rows)
        for i = 1, #rows do 
            MySQL.execute("XCEL/set_identifierbanned", {banned = value, iden = rows[i].identifier })
        end
    end)
end

function calculateTimeRemaining(expireTime)
    if tonumber(expireTime) then
        local datetime = ''
        local expiry = os.date("%d/%m/%Y at %H:%M", tonumber(expireTime))
        local hoursLeft = ((tonumber(expireTime)-os.time()))/3600
        local minutesLeft = nil
        if hoursLeft < 1 then
            minutesLeft = hoursLeft * 60
            minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
            datetime = minutesLeft .. " mins" 
            return datetime
        else
            hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
            datetime = hoursLeft .. " hours" 
            return datetime
        end
        return datetime
    else
        return "Permanent Ban"
    end
end

function XCEL.setBanned(user_id,banned,time,reason,admin,baninfo)
    if banned then 
        MySQL.execute("XCEL/set_banned", {user_id = user_id, banned = banned, bantime = time, banreason = reason, banadmin = admin, baninfo = baninfo})
        XCEL.BanIdentifiers(user_id, true)
        XCEL.BanTokens(user_id, true)
        exports['xcel']:dmUserBanned({XCEL.getUserIdDiscord(user_id),reason,calculateTimeRemaining(time),admin,baninfo})
    else 
        MySQL.execute("XCEL/set_banned", {user_id = user_id, banned = banned, bantime = "", banreason =  "", banadmin =  "", baninfo = ""})
        XCEL.BanIdentifiers(user_id, false)
        XCEL.BanTokens(user_id, false)
        MySQL.execute("ac/delete_ban", {user_id = user_id})
        exports['xcel']:dmUserUnbanned({XCEL.getUserIdDiscord(user_id)})
    end 
end

function XCEL.ban(adminsource,permid,time,reason,baninfo)
    local adminPermID = XCEL.getUserId(adminsource)
    local PlayerSource = XCEL.getUserSource(tonumber(permid))
    local getBannedPlayerSrc = XCEL.getUserSource(tonumber(permid))
    local adminname = XCEL.GetPlayerName(adminPermID)
    if getBannedPlayerSrc then 
        if tonumber(time) then
            XCEL.setBucket(PlayerSource, permid)
            XCEL.setBanned(permid,true,time,reason,adminname,baninfo)
            XCEL.kick(getBannedPlayerSrc,"[XCEL] Ban expires in: "..calculateTimeRemaining(time).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/xcel5m") 
        else
            XCEL.setBucket(PlayerSource, permid)
            XCEL.setBanned(permid,true,"perm",reason,adminname,baninfo)
            XCEL.kick(getBannedPlayerSrc,"[XCEL] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/xcel5m") 
        end
        XCELclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    else 
        if tonumber(time) then 
            XCEL.setBanned(permid,true,time,reason,adminname,baninfo)
        else 
            XCEL.setBanned(permid,true,"perm",reason,adminname,baninfo)
        end
        XCELclient.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    end
end

function XCEL.banConsole(permid,time,reason)
    local adminPermID = "XCEL"
    local getBannedPlayerSrc = XCEL.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            XCEL.setBanned(permid,true,banTime,reason, adminPermID)
            XCEL.kick(getBannedPlayerSrc,"[XCEL] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by XCEL \nAppeal @ discord.gg/xcel5m") 
        else 
            XCEL.setBanned(permid,true,"perm",reason, adminPermID)
            XCEL.kick(getBannedPlayerSrc,"[XCEL] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by XCEL \nAppeal @ discord.gg/xcel5m") 
        end
        print("Successfully banned Perm ID: " .. permid)
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            XCEL.setBanned(permid,true,banTime,reason, adminPermID)
        else 
            XCEL.setBanned(permid,true,"perm",reason, adminPermID)
        end
        print("Successfully banned Perm ID: " .. permid)
    end
end
function XCEL.banAnticheat(permid,time,reason)
    local adminPermID = "XCEL"
    local getBannedPlayerSrc = XCEL.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            XCEL.setBanned(permid,true,banTime,reason, adminPermID)
            Citizen.Wait(20000)
            XCEL.kick(getBannedPlayerSrc,"[XCEL] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by XCEL \nAppeal @ discord.gg/xcel5m") 
        else 
            XCEL.setBanned(permid,true,"perm",reason, adminPermID)
            Citizen.Wait(20000)
            XCEL.kick(getBannedPlayerSrc,"[XCEL] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by XCEL \nAppeal @ discord.gg/xcel5m") 
        end
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            XCEL.setBanned(permid,true,banTime,reason, adminPermID)
        else 
            XCEL.setBanned(permid,true,"perm",reason, adminPermID)
        end
    end
end

function XCEL.banDiscord(permid,time,reason,adminPermID,baninfo)
    local getBannedPlayerSrc = XCEL.getUserSource(tonumber(permid))
    if tonumber(time) then 
        local banTime = os.time()
        banTime = banTime  + (60 * 60 * tonumber(time))
        XCEL.setBanned(permid,true,banTime,reason, adminPermID, baninfo)
        if getBannedPlayerSrc then 
            XCEL.kick(getBannedPlayerSrc,"[XCEL] Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/xcel5m") 
        end
    else 
        XCEL.setBanned(permid,true,"perm",reason,  adminPermID)
        if getBannedPlayerSrc then
            XCEL.kick(getBannedPlayerSrc,"[XCEL] Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/xcel5m") 
        end
    end
end

function XCEL.StoreTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            MySQL.query("XCEL/check_token", {token = token}, function(rows)
                if token and rows and #rows <= 0 then 
                    MySQL.execute("XCEL/add_token", {token = token, user_id = user_id})
                end        
            end)
        end
    end
end


function XCEL.CheckTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local banned = false;
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            local rows = MySQL.asyncQuery("XCEL/check_token", {token = token, user_id = user_id})
                if #rows > 0 then 
                if rows[1].banned then 
                    return rows[1].banned, rows[1].user_id
                end
            end
        end
    else 
        return false; 
    end
end

function XCEL.BanTokens(user_id, banned) 
    if GetNumPlayerTokens then 
        MySQL.query("XCEL/check_token_userid", {id = user_id}, function(id)
            sleep = banned and 50 or 0
            for i = 1, #id do
                if banned then
                    MySQL.execute("XCEL/ban_token", {token = id[i].token, banned = banned})

                else
                    MySQL.execute("XCEL/delete_token", {token = id[i].token})
                end
                Wait(sleep)
            end
        end)
    end
end

function XCEL.kick(source,reason)
    DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
    TriggerEvent("XCEL:save")
    Debug.pbegin("XCEL save datatables")
    for k,v in pairs(XCEL.user_tables) do
        XCEL.setUData(k,"XCEL:datatable",json.encode(v))
    end
    Debug.pend()
    SetTimeout(config.save_interval*1000, task_save_datatables)
end
task_save_datatables()
function XCEL.GetPlayerIdentifiers(source)
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    return ids
end
local forbiddenNames = {
	"%^1",
	"%^2",
	"%^3",
	"%^4",
	"%^5",
	"%^6",
	"%^7",
	"%^8",
	"%^9",
	"%^%*",
	"%^_",
	"%^=",
	"%^%~",
	"admin",
    "nigger",
    "faggot",
    "*"
}

-- [[ Error Codes ]] --
-- XCEL: #0000 - Default Error
-- XCEL: #0001 - Deferrals not provided
-- XCEL: #0002 - Error while fetching data
-- XCEL: #0003 - Rollback Error
-- XCEL: #0004 - Provided wrong data

-- [[ Adaptive Cards ]] --

local currentTasks = {}
local referenceCode = "XCEL: #0000"

function XCEL.updateCard(message, deferrals, id)
    local startTime = os.time()
    Wait(100)
    local progressText = ""
    XCEL.isBanned(id, function(banned)
        if not banned then
            if message == "" then
                referenceCode = "XCEL: #0001"
                deferrals.done("Failure to connect, Contact a developer about your issue.\n Reference code: " .. referenceCode, deferrals, user_id)
               return
            end
            if message then
                if connecting_card["body"][2] and connecting_card["body"][2]["items"] then
                    if connecting_card["body"][2]["items"][1] then
                        connecting_card["body"][2]["items"][1]["text"] = message
                    end
                    if connecting_card["body"][2]["items"][2] and id then
                        connecting_card["body"][2]["items"][2]["text"] = "Your ID is: "..id
                    end
                end
            end
            if not currentTasks[id] then
                currentTasks[id] = 0
            end
            currentTasks[id] = currentTasks[id] + 1
            if currentTasks[id] <= 13 then
                progressText = "Running Checks..."
            elseif currentTasks[id] >= 14 then
                progressText = "Downloading Resources..."
            else
                progressText = "Loading..."
            end
            
            progressBar = string.rep("🟩", currentTasks[id]) .. " " .. progressText
            
            if connecting_card["body"][3] then
                connecting_card["body"][3]["text"] = progressBar
            else
                table.insert(connecting_card["body"], {
                    ["type"] = "TextBlock",
                    ["text"] = progressBar,
                    ["wrap"] = true
                })
            end
            deferrals.presentCard(connecting_card)
            while true do
                Wait(120000)
                if os.difftime(os.time(), startTime) > 10 then
                    referenceCode = "XCEL: #0002"
                    deferrals.done("Failure to connect, Contact a developer about your issue.\n Reference code: " .. referenceCode, deferrals, user_id)
                    return
                end
            end
        end
    end)
end

AddEventHandler("playerConnecting", function(name, setMessage, deferrals)
    deferrals.defer()
    local source = source
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    if GetNumPlayerTokens(source) <= 0 then
        deferrals.done("\n[XCEL] Fetching tokens...\nPlease re-connect")
        return
    end
    if ids.license then
        XCEL.getUserByLicense(ids.license, function(user_id)
            XCEL.updateCard("[XCEL] Checking For  Identifiers...", deferrals, user_id)
            XCEL.checkidentifiers(user_id, ids, function(banned, userid, reason, identifier)
                if banned and reason == "Ban Evading" then
                    deferrals.done("\n[XCEL] Permanently Banned\nUser ID: "..user_id.."\nReason: "..reason.."\nAppeal: https://discord.gg/xcel5m")
                    XCEL.setBanned(user_id,true,"perm","Ban Evading","XCEL","ID Banned: "..userid)
                    XCEL.sendWebhook('ban-evaders', 'XCEL Ban Evade Logs', "> Player Name: **"..GetPlayerName(source).."**\n> Player Current Perm ID: **"..user_id.."**\n> Player Banned PermID: **"..userid.."**\n> Banned Identifier: **"..identifier.."**")
                    return
                end
            end)
            if user_id ~= nil then
                XCEL.updateCard("[XCEL] Checking If  Verified...", deferrals, user_id)
                ::try_verify::
                local verified = exports["xcel"]:executeSync("SELECT * FROM xcel_verification WHERE user_id = @user_id", { user_id = user_id })
                if #verified > 0 then
                    if verified[1].verified == 0 then
                        if code == nil then
                            code = string.upper(generateUUID("verifycode", 6, "alphanumeric"))
                            exports["xcel"]:executeSync("UPDATE xcel_verification SET code = @code WHERE user_id = @user_id", { user_id = user_id, code = code })
                        else
                            code = string.upper(generateUUID("verifycode", 6, "alphanumeric"))
                            exports["xcel"]:executeSync("UPDATE xcel_verification SET code = @code WHERE user_id = @user_id", { user_id = user_id, code = code })
                        end
                        show_auth_card(code, deferrals, function(data)
                            check_verified(deferrals, code, user_id)
                        end)
                        Wait(100000)
                    end
                    if #verified == 1 then
                        XCEL.StoreTokens(source, user_id)
                        XCEL.GetDiscordName(user_id)
                        XCEL.isBanned(user_id, function(banned)
                            if not banned then
                                XCEL.updateCard("[XCEL] Checking For Discord...", deferrals, user_id)
                                if not XCEL.checkForRole(user_id, '1195851569472741441') and not XCEL.checkForRole(user_id, '1218536107214372956') then
                                    deferrals.done("[XCEL]: Your Perm ID Is [".. user_id .."] you are required to be in the discord to join (discord.gg/xcel5m)")
                                    return
                                end
                                XCEL.updateCard("[XCEL] Getting User Name...", deferrals, user_id)
                                Wait(3000)                         
                                if XCEL.CheckTokens(source, user_id) then 
                                    deferrals.done("[XCEL]: You are banned from this server, please do not try to evade your ban. If you believe this was an error quote your ID which is: " .. user_id)
                                    XCEL.banConsole(user_id, "perm", "1.11 Ban Evading")
                                    return
                                end
                                XCEL.updateCard("[XCEL] Checking User Data...", deferrals, user_id)
                                Citizen.Wait(1000)
                                XCEL.users[Identifiers[1]] = user_id
                                XCEL.rusers[user_id] = Identifiers[1]
                                XCEL.user_tables[user_id] = {}
                                XCEL.user_tmp_tables[user_id] = {}
                                XCEL.user_sources[user_id] = source
                                XCEL.updateCard("[XCEL] Getting User Data...", deferrals, user_id)
                                XCEL.getUData(user_id, "XCEL:datatable", function(sdata)
                                    local data = json.decode(sdata)
                                    if type(data) == "table" then 
                                        XCEL.user_tables[user_id] = data 
                                    end
                                    local tmpdata = XCEL.getUserTmpTable(user_id)
                                    XCEL.getLastLogin(user_id, function(last_login)
                                        tmpdata.last_login = last_login or ""
                                        tmpdata.spawns = 0
                                        local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                        MySQL.execute("XCEL/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                        XCEL.updateCard("[XCEL] Got User Data...", deferrals, user_id)
                                        print("[XCEL] "..XCEL.GetPlayerName(user_id).." ^2Joined^0 | PermID: "..user_id)
                                        TriggerEvent("XCEL:playerJoin", user_id, source, XCEL.GetPlayerName(user_id), tmpdata.last_login)
                                        Wait(500)
                                        deferrals.done()
                                    end)
                                end)
                            else
                                XCEL.fetchBanReasonTime(user_id, function(bantime, banreason, banadmin)
                                    if tonumber(bantime) then 
                                        local timern = os.time()
                                        if timern > tonumber(bantime) then 
                                            XCEL.setBanned(user_id, false)
                                            if XCEL.rusers[user_id] == nil then
                                                XCEL.users[Identifiers[1]] = user_id
                                                XCEL.rusers[user_id] = Identifiers[1]
                                                XCEL.user_tables[user_id] = {}
                                                XCEL.user_tmp_tables[user_id] = {}
                                                XCEL.user_sources[user_id] = source
                                                XCEL.getUData(user_id, "XCEL:datatable", function(sdata)
                                                    local data = json.decode(sdata)
                                                    if type(data) == "table" then 
                                                        XCEL.user_tables[user_id] = data 
                                                    end
                                                    local tmpdata = XCEL.getUserTmpTable(user_id)
                                                    XCEL.getLastLogin(user_id, function(last_login)
                                                        tmpdata.last_login = last_login or ""
                                                        tmpdata.spawns = 0
                                                        local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                        MySQL.execute("XCEL/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                                                        print("[XCEL] "..XCEL.GetPlayerName(user_id).." ^3Joined after their ban expired.^0 (Perm ID = "..user_id..")")
                                                        TriggerEvent("XCEL:playerJoin", user_id, source, XCEL.GetPlayerName(user_id), tmpdata.last_login)
                                                        deferrals.done()
                                                    end)
                                                end)
                                            else
                                                print("[XCEL] "..XCEL.GetPlayerName(user_id).." ^3Re-joined after their ban expired.^0 | Perm ID = "..user_id)
                                                TriggerEvent("XCEL:playerRejoin", user_id, source, XCEL.GetPlayerName(user_id))
                                                deferrals.done()
                                                local tmpdata = XCEL.getUserTmpTable(user_id)
                                                tmpdata.spawns = 0
                                            end
                                        end
                                        print("[XCEL] "..GetPlayerName(source).." ^1Rejected: "..banreason.."^0 | Perm ID = "..user_id)
                                        deferrals.done("\n[XCEL] Ban expires in "..calculateTimeRemaining(bantime).."\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ discord.gg/xcel5m")
                                    else 
                                        print("[XCEL] "..GetPlayerName(source).." ^1Rejected: "..banreason.."^0 | Perm ID = "..user_id)
                                        deferrals.done("\n[XCEL] Permanent Ban\nYour ID: "..user_id.."\nReason: "..banreason.."\nAppeal @ discord.gg/xcel5m")
                                    end
                                end)
                            end
                        end)
                    end
                else
                    exports["xcel"]:executeSync("INSERT IGNORE INTO xcel_verification(user_id,verified) VALUES(@user_id,false)", {user_id = user_id})
                    goto try_verify
                end
            end
        end)
    end
end)
local trys = {}
function show_auth_card(code, deferrals, callback)
    if trys[code] == nil then
        trys[code] = 0
    end
    verify_card["body"][2]["items"][4]["text"] = "!verify "..code
    verify_card["body"][2]["items"][4]["color"] = "Good"
    verify_card["body"][2]["items"][5]["text"] = "Your account has not been verified yet. (Attempt "..trys[code]..")"
    deferrals.presentCard(verify_card, callback)
end

function check_verified(deferrals, code, user_id, data)
    local data_verified = exports["xcel"]:executeSync("SELECT verified FROM xcel_verification WHERE user_id = @user_id", { user_id = user_id })
    if trys[code] == nil then
        trys[code] = 0
    end
    if trys[code] ~= 5 then
        verify_card["body"][2]["items"][4]["text"] = "Checking Verification..."
        verify_card["body"][2]["items"][4]["color"] = "Good"
        verify_card["body"][2]["items"][1]["text"] = ""
        verify_card["body"][2]["items"][2]["text"] = ""
        verify_card["body"][2]["items"][3]["text"] = ""
        verify_card["body"][2]["items"][5]["text"] = ""
        deferrals.presentCard(verify_card, callback)
        Wait(2000)
        verify_card["body"][2]["items"][1]["text"] = "In order to connect to XCEL you must be in our discord and verify your account"
        verify_card["body"][2]["items"][2]["text"] = "Join the XCEL discord (discord.gg/xcel5m)"
        verify_card["body"][2]["items"][3]["text"] = "In the #verify channel, type the following command"
        verify_card["body"][2]["items"][4]["text"] = "!verify "..code
    else
        verify_card["body"][2]["items"][1]["text"] = ""
        verify_card["body"][2]["items"][2]["text"] = ""
        verify_card["body"][2]["items"][3]["text"] = ""
        verify_card["body"][2]["items"][4]["text"] = ""
        verify_card["body"][2]["items"][5]["text"] = "You Have Reached The Maximum Amount Of Attempts"
        deferrals.presentCard(verify_card, callback)
        Wait(2000)
        deferrals.done("[XCEL]: Failed to verify your account, please try again.")
        return
    end
    if data_verified[1] and data_verified[1].verified == 1 then

        verify_card["body"][2]["items"][4]["text"] = "Verification Successful!"
        verify_card["body"][2]["items"][4]["color"] = "Good"
        verify_card["body"][2]["items"][1]["text"] = ""
        verify_card["body"][2]["items"][2]["text"] = ""
        verify_card["body"][2]["items"][3]["text"] = ""
        verify_card["body"][2]["items"][5]["text"] = ""
        verify_card["body"][3] = false
        deferrals.presentCard(verify_card, callback)
        Wait(3000)
        XCEL.updateCard("[XCEL] Checking For Discord...", deferrals, user_id)
        if not XCEL.checkForRole(user_id, '1195851569472741441') and not XCEL.checkForRole(user_id, '1218536107214372956') then
            deferrals.done("[XCEL]: Your Perm ID Is [".. user_id .."] you are required to be in the discord to join (discord.gg/xcel5m)")
            return
        end
        Wait(1000)
        XCEL.updateCard("[XCEL] Getting User Name...", deferrals, user_id)
        Wait(1000)
        XCEL.updateCard("[XCEL] Checking User Data...", deferrals, user_id)
        Wait(1000)
        deferrals.done()
        print("[XCEL] "..XCEL.GetPlayerName(user_id).." ^2Newly Verified^0 | PermID: "..user_id)
    end
    trys[code] = trys[code] + 1
    show_auth_card(code, deferrals, callback)
end






AddEventHandler("playerDropped", function(reason)
    local source = source
    local user_id = XCEL.getUserId(source)
    local name = XCEL.GetPlayerName(user_id)
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    if user_id ~= nil then
        TriggerEvent("XCEL:playerLeave", user_id, source)
        XCEL.setUData(user_id, "XCEL:datatable", json.encode(XCEL.getUserDataTable(user_id)))
        print("[XCEL] " .. name .. " ^1Disconnected^0 | Perm ID: "..user_id)
        XCEL.users[XCEL.rusers[user_id]] = nil
        XCEL.rusers[user_id] = nil
        XCEL.user_tables[user_id] = nil
        XCEL.user_tmp_tables[user_id] = nil
        XCEL.user_sources[user_id] = nil
        XCEL.sendWebhook('leave', XCEL.GetPlayerName(user_id) .. " Disconnected", "\n> Player Name:** " .. XCEL.GetPlayerName(user_id) .. "**\n> PermID: **" .. user_id .. "**\n> Temp ID: **" .. source .. "**\n> Reason:" .. (reason and string.format("\n```%s```", reason) or "Exiting"))
    else
        print('[XCEL] SEVERE ERROR: Failed to save data for: ' .. name .. ' Rollback expected!')
    end
    XCELclient.removeBasePlayer(-1, {source})
    XCELclient.removePlayer(-1, {source})
end)

MySQL.createCommand("XCEL/setusername", "UPDATE xcel_users SET username = @username WHERE id = @user_id")

RegisterServerEvent("XCELCli:playerSpawned")
AddEventHandler("XCELCli:playerSpawned", function()
    local source = source
    local Identifiers = GetPlayerIdentifiers(source)
    local Tokens = GetNumPlayerTokens(source)
    local ids = {}
    for _, identifier in pairs(Identifiers) do
        local key, value = string.match(identifier, "([^:]+):(.+)")
        if key and value and key ~= "ip" then
            ids[key] = ids[key] or key .. ":" .. value
        end
    end
    local user_id = XCEL.getUserId(source)
    local name = XCEL.GetPlayerName(user_id)
    local player = source
    XCELclient.addBasePlayer(-1, {player, user_id})
    if user_id ~= nil then
        XCEL.user_sources[user_id] = source
        local tmp = XCEL.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns + 1
        local first_spawn = (tmp.spawns == 1)
        local playertokens = {}
        for i = 1, Tokens do
            local token = GetPlayerToken(source, i)
            if token then
                if not playertokens[source] then
                    playertokens[source] = {}
                end
                table.insert(playertokens[source], token)
            end
        end
        local tokens = ""
        if GetNumPlayerTokens then
            local numtokens = GetNumPlayerTokens(source)
            for i = 1, numtokens do
                local token = GetPlayerToken(source, i)
                if token then
                    tokens = tokens .. "\n" .. token
                end
            end
        end
        local f = {}
        for _, identifier in pairs(Identifiers) do
            if not string.match(identifier, "^ip:") then
                table.insert(f, identifier)
            end
        end
        XCEL.sendWebhook('join', XCEL.GetPlayerName(user_id) .. " Connected", "\nUser Info:\n" .. "```\n" .. "Player Name: " .. XCEL.GetPlayerName(user_id) .. "\n" .. "User ID: " .. user_id .. "\n" .. "Temp ID: " .. source .. "\n" .. "Ping: " .. GetPlayerPing(source) .. "\n" .. "```" .. "\nIdentifiers:" .. "```\n" .. "" .. table.concat(f, "\n") .. "\n" .. "\n" .. tokens .. "```")
        if first_spawn then
            for k, v in pairs(XCEL.user_sources) do
                XCELclient.addPlayer(source, {v})
            end
            XCELclient.addPlayer(-1, {source})
            MySQL.execute("XCEL/setusername", {user_id = user_id, username = name})
        end
        TriggerEvent("XCEL:playerSpawn", user_id, player, first_spawn)
        TriggerClientEvent("XCEL:onClientSpawn", player, user_id, first_spawn)
    end
end)
RegisterServerEvent("XCEL:playerRespawned")
AddEventHandler("XCEL:playerRespawned", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    TriggerClientEvent('XCEL:ForceRefreshData', -1)
    TriggerClientEvent('XCEL:onClientSpawn', source)
    Wait(60000)
    XCEL.getSubscriptions(user_id, function(cb, plushours, plathours)
        if plathours and plathours == 0 then
            XCELclient.notify(source, {'~y~You can Purchase Platinum or Plus from xcel.tebex.io'})
        elseif plathours and plathours > 0 then
            XCEL.giveInventoryItem(user_id, "civilian_radio", 1)
        end
    end)
end)



local Online = true
exports("getServerStatus", function(params, cb)
    if not Online then
        cb("❌ Offline")
    else
        cb("✅ Online")
    end
end)

exports("getConnected", function(params, cb)
    if XCEL.getUserSource(params[1]) then
        cb('connected')
    else
        cb('not connected')
    end
end)

exports("kickPlayerIdSwap", function(params, cb)
    local success, result = pcall(function()
        if XCEL.getUserSource(params[1]) then
            DropPlayer(XCEL.getUserSource(params[1]), "[XCEL]\n You're ID is being swapped\n Please wait till you have recieved a message from the staff bot")
            cb('kicked')
        else
            cb('kicked')
        end
    end)
end)

function XCEL.NameCheck(name, cb)
    for v in pairs(forbiddenNames) do
        if(string.gsub(string.gsub(string.gsub(string.gsub(name:lower(), "-", ""), ",", ""), "%.", ""), " ", ""):find(forbiddenNames[v])) then
            cb(true)
            return
        end
    end
end


local devs = {
    [1] = true,
    [3] = true,
}


function XCEL.isDeveloper(user_id)
    if IsDuplicityVersion() then
        return devs[tonumber(user_id)]
    else
        return devs[tXCEL.getUserId()]
    end
end

