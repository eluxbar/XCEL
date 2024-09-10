local cfg = module("cfg/discordroles")
local FormattedToken = "Bot " .. cfg.Bot_Token
local Discord_Sources = {} -- Discord ID: (User Source, User ID)

local error_codes_defined = {
	[200] = 'OK - The request was completed successfully..!',
	[400] = "Error - The request was improperly formatted, or the server couldn't understand it..!",
	[401] = 'Error - The Authorization header was missing or invalid..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
	[403] = 'Error - The Authorization token you passed did not have permission to the resource..! Your Discord Token is probably wrong or does not have correct permissions attributed to it.',
	[404] = "Error - The resource at the location specified doesn't exist.",
	[429] = 'Error - Too many requests, you hit the Discord rate limit. https://discord.com/developers/docs/topics/rate-limits',
	[502] = 'Error - Discord API may be down?...'
}

local function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/" .. endpoint, function(errorCode, resultData, resultHeaders)
		data = {data = resultData, code = errorCode, headers = resultHeaders}
    end, method, #jsondata > 0 and jsondata or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while not data do
        Citizen.Wait(0)
    end
	
    return data
end

local function GetIdentifier(source, id_type)
    if type(id_type) ~= "string" then
		return print('Invalid usage')
	end

    for _, identifier in pairs(GetPlayerIdentifiers(source)) do
        if string.find(identifier, id_type) then
            return identifier
        end
    end
    return nil
end

function Get_Client_Discord_ID(source)
	return exports['xcel']:executeSync("SELECT discord_id FROM `xcel_verification` WHERE user_id = @user_id", {user_id = XCEL.getUserId(source)})[1].discord_id
end
function XCEL.getUserIdDiscord(user_id)
	return exports['xcel']:executeSync("SELECT discord_id FROM `xcel_verification` WHERE user_id = @user_id", {user_id = user_id})[1].discord_id
end

local function Client_Has_Role(roles_table, role_id)
	for _, table_role_id in pairs(roles_table) do
		if tostring(table_role_id) == tostring(role_id) or tostring(_) == tostring(role_id) then
			return true
		end
	end
	return false
end

local function Get_Client_Has_Roles(guild_roles, client_roles)
	local has_roles = {}
	local does_not_have_roles = {}

	for role_name, guild_role_id in pairs(guild_roles) do
		local found_role = false
		for _, client_role_id in pairs(client_roles) do
			if tostring(guild_role_id) == tostring(client_role_id) then
				found_role = true
				table.insert(has_roles, guild_role_id)
				break
			end
		end
		
		if not found_role then
			table.insert(does_not_have_roles, guild_role_id)
		end
	end

	return has_roles, does_not_have_roles
end

local recent_role_cache = {}
local function GetDiscordRoles(guild_id, user_discord_id)
	if cfg.CacheDiscordRoles and recent_role_cache[user_discord_id] and recent_role_cache[user_discord_id][guild_id] then
		return recent_role_cache[user_discord_id][guild_id]
	end

	local endpoint = ("guilds/%s/members/%s"):format(guild_id, user_discord_id)
	local member = DiscordRequest("GET", endpoint, {})
	if member.code == 200 then
		local data = json.decode(member.data)
		local roles = data.roles
		local found = true
		if cfg.CacheDiscordRoles then
			recent_role_cache[user_discord_id] = recent_role_cache[user_discord_id] or {}
			recent_role_cache[user_discord_id][guild_id] = roles
			Citizen.SetTimeout(((cfg.CacheDiscordRolesTime or 60) * 1000), function()
				recent_role_cache[user_discord_id][guild_id] = nil 
			end)
		end
		return roles
	else
		return false
	end
	return false
end

local function Modify_Client_Roles(guild_name, discord_id, user_id)
	local discord_roles = GetDiscordRoles(cfg.Guilds[guild_name], discord_id)
	if discord_roles then
		local has_roles, does_not_have_roles = Get_Client_Has_Roles(cfg.Guild_Roles[guild_name], discord_roles)
		for _, role_id in pairs(does_not_have_roles) do
			for k,v in pairs(cfg.Guild_Roles[guild_name]) do
                if v == role_id and XCEL.hasGroup(user_id, k) then
                    XCEL.removeUserGroup(user_id, k)
					if XCEL.hasGroup(user_id, k..' Clocked') then
						XCEL.removeUserGroup(user_id, k..' Clocked')
					end
                end
			end
		end

		for _, role_id in pairs(has_roles) do
            for k,v in pairs(cfg.Guild_Roles[guild_name]) do
                if v == role_id and not XCEL.hasGroup(user_id, k) then
                    XCEL.addUserGroup(user_id, k)
                end
            end
		end
	end
	XCEL.getJobSelectors(XCEL.getUserSource(user_id))
end


local tracked = {}
RegisterNetEvent('XCEL:getFactionWhitelistedGroups')
AddEventHandler('XCEL:getFactionWhitelistedGroups', function()
	local source = source
	XCEL.getFactionGroups(source)
end)

function XCEL.getFactionGroups(source)
    local source = source
	local fivem_license = GetIdentifier(source, 'license')
	if not tracked[fivem_license] then 
		tracked[fivem_license] = true
	end
	local user_id = XCEL.getUserId(source)
	if user_id then
		local discord_id = Get_Client_Discord_ID(source)
		if discord_id then
			Discord_Sources[discord_id] = {user_source = source, user_id = user_id}
			Modify_Client_Roles('Main', discord_id, user_id)
			Modify_Client_Roles('Police', discord_id, user_id)
			Modify_Client_Roles('NHS', discord_id, user_id)
			Modify_Client_Roles('HMP', discord_id, user_id)
		end
	end
end

function Get_Guild_Nickname(guild_id, discord_id)
	local endpoint = ("guilds/%s/members/%s"):format(guild_id, discord_id)
	local member = DiscordRequest("GET", endpoint, {})
	if member.code == 200 then
		local data = json.decode(member.data)
		local nickname = data.nick or data.user.global_name or data.user.username
		return nickname
	else
		return nil
	end
end

function Get_Discord_Avatar(discord_id)
    local endpoint = "users/" .. discord_id
    local user = DiscordRequest("GET", endpoint, {})
    if user.code == 200 then
        local data = json.decode(user.data)
        if data.avatar then
            local avatarURL = "https://cdn.discordapp.com/avatars/" .. discord_id .. "/" .. data.avatar .. ".png"
            return avatarURL
        end
    end
    return nil
end

Caches = {
	Avatars = {},
  RoleList = {}
}
function ResetCaches()
	Caches = {
    Avatars = {},
    RoleList = {},
  };
end

exports('Get_Client_Discord_ID', function(source)
	return Get_Client_Discord_ID(source)
end)

exports('Get_Guild_Nickname', function(guild_id, discord_id)
	return Get_Guild_Nickname(guild_id, discord_id)
end)

exports('Get_Guilds', function()
	return cfg.Guilds
end)

exports('Get_User_Source', function(user_discord_id)
	return Discord_Sources[user_discord_id]
end)

Citizen.CreateThread(function()
	if cfg.Multiguild then 
		for _, guildID in pairs(cfg.Guilds) do
			local guild = DiscordRequest("GET", "guilds/" .. guildID, {})
		end
	else
		local guild = DiscordRequest("GET", "guilds/" .. cfg.Guild_ID, {})
	end
end)

function XCEL.checkForRole(user_id, role_id)
	local discord_id = exports['xcel']:executeSync("SELECT discord_id FROM `xcel_verification` WHERE user_id = @user_id", {user_id = user_id})[1].discord_id
	if not discord_id then
		return false
	end
	local endpoint = ("guilds/%s/members/%s"):format(cfg.Guild_ID, discord_id)
	local member = DiscordRequest("GET", endpoint, {})
	if member.code == 200 then
		local data = json.decode(member.data)
		if data then
			local has_role = Client_Has_Role(data.roles, role_id)
			return has_role
		end
	end
	return false
end

function XCEL.getDiscordAvatar(id)
	local discord_id = exports['xcel']:executeSync("SELECT discord_id FROM `xcel_verification` WHERE user_id = @user_id", {user_id = id})[1].discord_id
    local user = DiscordRequest("GET", "users/" .. discord_id, {})
    if user.code == 200 then
        local data = json.decode(user.data)
        if data.avatar then
            local avatarURL = "https://cdn.discordapp.com/avatars/" .. discord_id .. "/" .. data.avatar .. ".png"
            return avatarURL
        end
    end
    return nil
end


-- // Discord Names \\ --

discordnames = {}
function XCEL.GetDiscordName(user_id)
    local discord_id = exports["xcel"]:executeSync("SELECT discord_id FROM `xcel_verification` WHERE user_id = @user_id", {user_id = user_id})[1].discord_id
    local nickname = Get_Guild_Nickname(1195851569472741437, discord_id)
    if nickname then
        discordnames[user_id] = nickname
        for k, v in pairs(XCEL.getUsers()) do
           XCELclient.addDiscordNames(v, {user_id, nickname})
        end
    end
end

function XCEL.GetPlayerName(user_id)
	return discordnames[user_id] or "Unknown"
end

Citizen.CreateThread(function()
	Wait(3*60)
	while true do
		Wait(3*60)
		for k,v in pairs(XCEL.getUsers()) do
			if not discordnames[k] then
				XCEL.GetDiscordName(k)
			end
		end
	end
end)

function XCEL.UpdateDiscordName(user_id,name)
	discordnames[user_id] = name
	for k,v in pairs(XCEL.getUsers()) do
		XCELclient.setDiscordNames(v, {discordnames})
	end
end

RegisterServerEvent("XCEL:SetDiscordName")
AddEventHandler("XCEL:SetDiscordName", function()
    local source = source
    local user_id = XCEL.getUserId(source)
	if not discordnames[user_id] then
		XCEL.GetDiscordName(user_id)
	end
end)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(60000)
        for i,v in pairs(XCEL.getUsers()) do
            XCELclient.setDiscordNames(v, {discordnames})
        end
    end
end)


exports('GetDiscordName', function(source)
    return XCEL.GetPlayerName(XCEL.getUserId(source))
end)