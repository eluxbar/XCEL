function rank(_, arg)
    if _ ~= 0 then return end
	local user_id = tonumber(arg[1])
    local rank = arg[2]
    print(user_id.." has bought "..rank.."! ^7")
    if XCEL.getUserSource(user_id) ~= nil then
        XCEL.addUserGroup(user_id,rank)  
        TriggerClientEvent('XCEL:smallAnnouncement', user_id, 'XCEL Studios', "You have received "..rank.." rank we appreciate your support! ❤️\n", 18, 10000)
    else
        exports['xcel']:execute("SELECT * FROM xcel_user_data WHERE user_id = @user_id", {user_id = user_id}, function(result) 
            if #result > 0 then
                local dvalue = json.decode(result[1].dvalue)
                local groups = dvalue.groups
                groups[rank] = true
                exports['xcel']:execute("UPDATE xcel_user_data SET dvalue = @dvalue WHERE user_id = @user_id", {dvalue = json.encode(dvalue), user_id = user_id}, function() end)
            end
        end)
    end  
    XCEL.sendWebhook('donation',"XCEL Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **"..rank.."**")
end

function moneybag(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local amount = tonumber(arg[2])
    if XCEL.getUserSource(user_id) ~= nil then
        XCEL.giveBankMoney(user_id, amount)
        TriggerClientEvent('XCEL:smallAnnouncement', user_id, 'XCEL Studios', "You have received a £"..amount.." money bag we appreciate your support! ❤️\n", 18, 10000)
    else
        exports['xcel']:execute("UPDATE xcel_user_moneys SET bank = bank + @amount WHERE user_id = @user_id", {amount = amount, user_id = user_id}, function() end)
    end
    XCEL.sendWebhook('donation',"XCEL Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **£"..getMoneyStringFormatted(amount).." money bag**")
end

function plus(_, arg)
    if _ ~= 0 then return end
	local user_id = tonumber(arg[1])
    local newhours = tonumber(arg[2])
    XCEL.getSubscriptions(user_id, function(cb, plushours, plathours)
        TriggerClientEvent('XCEL:smallAnnouncement', user_id, 'XCEL Studios', "You have received XCEL Plus we appreciate your support! ❤️\n", 18, 10000)
        if cb then
            MySQL.execute("subscription/set_plushours", {user_id = user_id, plushours = plushours + newhours})
            XCEL.sendWebhook('donation',"XCEL Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: ** of Plus**")
        end
    end)
end

function platinum(_, arg)
    if _ ~= 0 then return end
	local user_id = tonumber(arg[1])
    local newhours = tonumber(arg[2])
    XCEL.getSubscriptions(user_id, function(cb, plushours, plathours)
        TriggerClientEvent('XCEL:smallAnnouncement', user_id, 'XCEL Studios', "You have received XCEL Platinum we appreciate your support! ❤️\n", 18, 10000)
        if cb then
            MySQL.execute("subscription/set_plathours", {user_id = user_id, plathours = plathours})
            XCEL.sendWebhook('donation',"XCEL Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: ** of Platinum**")
        end
    end)
end

function addweaponwhitelist(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local code = tonumber(arg[2])
    local ownedWhitelists = {}
    MySQL.query("XCEL/get_weapon_codes", {}, function(weaponCodes)
        if #weaponCodes > 0 then
            for e,f in pairs(weaponCodes) do
                if f['user_id'] == user_id and f['weapon_code'] == code then
                    MySQL.query("XCEL/get_weapons", {user_id = user_id}, function(weaponWhitelists)
                        if next(weaponWhitelists) then
                            ownedWhitelists = json.decode(weaponWhitelists[1]['weapon_info'])
                        end
                        for a,b in pairs(whitelistedGuns) do
                            for c,d in pairs(b) do
                                if c == f['spawncode'] then
                                    if not ownedWhitelists[a] then
                                        ownedWhitelists[a] = {}
                                    end
                                    ownedWhitelists[a][c] = d
                                end
                            end
                        end
                        MySQL.execute("XCEL/set_weapons", {user_id = user_id, weapon_info = json.encode(ownedWhitelists)})
                        MySQL.execute("XCEL/remove_weapon_code", {weapon_code = code})
                        XCEL.sendWebhook('donation',"XCEL Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **Weapon Access**\n> Access code: **"..code.."**")
                    end)
                end
            end
        end
    end)
end

function setphonenumber(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local phone_number = tonumber(arg[2])
    MySQL.query("XCEL/get_userbyphone", {phone_number}, function(phoneNumberTaken)
        TriggerClientEvent('XCEL:smallAnnouncement', user_id, 'XCEL Studios', "You have changed your phone number to "..phone_number.." we appreciate your support! ❤️\n", 6, 10000)
        if #phoneNumberTaken > 0 then
        else
            MySQL.execute("XCEL/update_user_phone", {phone = phone_number, user_id = user_id})
            XCEL.sendWebhook('donation',"XCEL Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **Phone Number: "..phone_number.."**")
        end
    end)
end

function vipcar(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local spawncode = arg[2]
    TriggerClientEvent('XCEL:smallAnnouncement', user_id, 'XCEL Studios', "You have received a "..spawncode.." in your garage we appreciate your support! ❤️\n", 18, 10000)
    MySQL.execute("XCEL/add_vehicle", {user_id = user_id, vehicle = spawncode, registration = 'P'..math.random(10000,99999)})
    XCEL.sendWebhook('donation',"XCEL Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **VIP Car: "..spawncode.."**")
end

function vipcar2(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local spawncode2 = arg[2]
    TriggerClientEvent('XCEL:smallAnnouncement', user_id, 'XCEL Studios', "You have received a "..spawncode.." in your garage we appreciate your support! ❤️\n", 18, 10000)
    MySQL.execute("XCEL/add_vehicle", {user_id = user_id, vehicle = spawncode2, registration = 'P'..math.random(10000,99999)})
    XCEL.sendWebhook('donation',"XCEL Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **VIP Car: "..spawncode2.."**")
end

function vipcar3(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local spawncode3 = arg[2]
    TriggerClientEvent('XCEL:smallAnnouncement', user_id, 'XCEL Studios', "You have received a "..spawncode.." in your garage we appreciate your support! ❤️\n", 18, 10000)
    MySQL.execute("XCEL/add_vehicle", {user_id = user_id, vehicle = spawncode3, registration = 'P'..math.random(10000,99999)})
    XCEL.sendWebhook('donation',"XCEL Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **VIP Car: "..spawncode3.."**")
end

function vipcar4(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local spawncode4 = arg[2]
    TriggerClientEvent('XCEL:smallAnnouncement', user_id, 'XCEL Studios', "You have received a "..spawncode.." in your garage we appreciate your support! ❤️\n", 18, 10000)
    MySQL.execute("XCEL/add_vehicle", {user_id = user_id, vehicle = spawncode4, registration = 'P'..math.random(10000,99999)})
    XCEL.sendWebhook('donation',"XCEL Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **VIP Car: "..spawncode4.."**")
end

RegisterCommand("rank", rank, true)
RegisterCommand("moneybag", moneybag, true)
RegisterCommand("plus", plus, true)
RegisterCommand("platinum", platinum, true)
RegisterCommand("addweaponwhitelist", addweaponwhitelist, true)
RegisterCommand("setphonenumber", setphonenumber, true)
RegisterCommand("vipcar", vipcar, true)
RegisterCommand("vipcar2", vipcar2, true)
RegisterCommand("vipcar3", vipcar3, true)
RegisterCommand("vipcar4", vipcar4, true)