RegisterServerEvent("XCEL:getCommunityPotAmount")
AddEventHandler("XCEL:getCommunityPotAmount", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    exports['xcel']:execute("SELECT value FROM xcel_community_pot", function(potbalance)
        TriggerClientEvent('XCEL:gotCommunityPotAmount', source, parseInt(potbalance[1].value))
    end)
end)

function refreshPot()
    exports['xcel']:execute("SELECT value FROM xcel_community_pot", function(potbalance)
        if potbalance[1] == nil then
            exports['xcel']:execute("INSERT INTO xcel_community_pot (value) VALUES (@value)", {value = 0})
        else
            local newpotbalance = parseInt(potbalance[1].value)
            exports['xcel']:execute("UPDATE xcel_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
        end
    end)
end

Citizen.CreateThread(function()
    refreshPot()
end)

RegisterServerEvent("XCEL:tryDepositCommunityPot")
AddEventHandler("XCEL:tryDepositCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id >= 0 then
        print("yes")
        exports['xcel']:execute("SELECT value FROM xcel_community_pot", function(potbalance)
            if XCEL.tryFullPayment(user_id,amount) then
                local newpotbalance = parseInt(potbalance[1].value) + amount
                exports['xcel']:execute("UPDATE xcel_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('XCEL:gotCommunityPotAmount', source, newpotbalance)
            end
        end)
    end
end)

RegisterServerEvent("XCEL:tryWithdrawCommunityPot")
AddEventHandler("XCEL:tryWithdrawCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id >= 0 then
        exports['xcel']:execute("SELECT value FROM xcel_community_pot", function(potbalance)
            if parseInt(potbalance[1].value) >= amount then
                local newpotbalance = parseInt(potbalance[1].value) - amount
                exports['xcel']:execute("UPDATE xcel_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('XCEL:gotCommunityPotAmount', source, newpotbalance)
                XCEL.giveBankMoney(user_id, amount)
            end
        end)
    end
end)

RegisterServerEvent("XCEL:distributeCommunityPot")
AddEventHandler("XCEL:distributeCommunityPot", function(amountToDistribute)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id >= 0 then
        exports['xcel']:execute("SELECT value FROM xcel_community_pot", function(potbalance)
            local totalAmount = tonumber(potbalance[1].value)
            amountToDistribute = tonumber(amountToDistribute)
            if totalAmount and amountToDistribute and totalAmount >= amountToDistribute then
                local players = GetPlayers()
                local amountPerPlayer = amountToDistribute / #players
                for i, player in ipairs(players) do
                    XCEL.giveBankMoney(XCEL.getUserId(player), amountPerPlayer)
                end
                local remainingAmount = totalAmount - amountToDistribute
                XCELclient.notify(-1, {"~g~Received £"..getMoneyStringFormatted(amountPerPlayer).." distributed from the community pot."})
                XCELclient.notify(source, {"~g~Distributed £"..getMoneyStringFormatted(amountPerPlayer).." to all online players."})
                exports['xcel']:execute("UPDATE xcel_community_pot SET value = @value", {['@value'] = remainingAmount})
                TriggerClientEvent('XCEL:gotCommunityPotAmount', source, remainingAmount)
            else
                XCELclient.notify(source, {"~r~Not enough money in the community pot."})
            end
        end)
    end
end)

RegisterNetEvent('XCEL:carToAll')
AddEventHandler('XCEL:carToAll', function()
    local source = source
    local admin_id = XCEL.getUserId(source)
    local admin_name = XCEL.GetPlayerName(admin_id)
    local car = ""
    if XCEL.hasPermission(admin_id, 'admin.addcar') then
        XCEL.prompt(source, "Spawncode:", "", function(source, car)
            if car ~= "" then
                car = car
                XCEL.prompt(source, "Locked (0 or 1):", "", function(source, locked)
                    if locked == '0' or locked == '1' then
                        for _, v in pairs(GetPlayers()) do
                            exports['xcel']:execute("SELECT * FROM `xcel_user_vehicles` WHERE vehicle = @spawncode", {spawncode = car}, function(result)
                                if result == nil or #result <= 0 then
                                    MySQL.execute("XCEL/add_vehicle", {user_id = XCEL.getUserId(v), vehicle = car, registration = "P"..math.random(1111,9999), locked = locked})
                                    XCELclient.notify(v, {'~g~' .. car .. ' has been added to your garage from the server.'})
                                end
                            end)
                        end
                        XCELclient.notify(source, {'~g~Added car ' .. car .. ' to all online players.'})
                        XCEL.sendWebhook('add-car', 'XCEL Add Car To All Players Logs', "> Admin Name: **"..admin_name.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Spawncode: **"..car.."**\n> Players online: **"..#GetPlayers().."**")
                    else
                        XCELclient.notify(source, {'~r~Locked must be either 1 or 0'})
                    end
                end)
            else
                XCELclient.notify(source, {'~r~You must provide a spawncode.'})
            end
        end)
    else
        XCEL.ACBan(15,admin_id,'XCEL:carToAll')
    end
end)

function XCEL.addToCommunityPot(amount)
    exports['xcel']:execute("SELECT value FROM xcel_community_pot", function(potbalance)
        local newpotbalance = parseInt(potbalance[1].value) + amount
        exports['xcel']:execute("UPDATE xcel_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
    end)
end