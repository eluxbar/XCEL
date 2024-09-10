MySQL.createCommand("casinochips/add_id", "INSERT IGNORE INTO xcel_casino_chips SET user_id = @user_id")
MySQL.createCommand("casinochips/get_chips","SELECT * FROM xcel_casino_chips WHERE user_id = @user_id")
MySQL.createCommand("casinochips/add_chips", "UPDATE xcel_casino_chips SET chips = (chips + @amount) WHERE user_id = @user_id")
MySQL.createCommand("casinochips/remove_chips", "UPDATE xcel_casino_chips SET chips = CASE WHEN ((chips - @amount)>0) THEN (chips - @amount) ELSE 0 END WHERE user_id = @user_id")


AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
       MySQL.execute("casinochips/add_id", {user_id = user_id})
    end
end)

RegisterNetEvent("XCEL:enterDiamondCasino")
AddEventHandler("XCEL:enterDiamondCasino", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.setBucket(source, 777)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('XCEL:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

RegisterNetEvent("XCEL:exitDiamondCasino")
AddEventHandler("XCEL:exitDiamondCasino", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.setBucket(source, 0)
end)

RegisterNetEvent("XCEL:getChips")
AddEventHandler("XCEL:getChips", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('XCEL:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

RegisterNetEvent("XCEL:buyChips")
AddEventHandler("XCEL:buyChips", function(amount)
    local source = source
    local user_id = XCEL.getUserId(source)
    if not amount then amount = XCEL.getMoney(user_id) end
    if XCEL.tryPayment(user_id, amount) then
        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
        TriggerClientEvent('XCEL:chipsUpdated', source)
        XCEL.sendWebhook('purchase-chips',"XCEL Chip Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
        return
    else
        XCELclient.notify(source,{"~r~You don't have enough money."})
        return
    end
end)

local sellingChips = {}
RegisterNetEvent("XCEL:sellChips")
AddEventHandler("XCEL:sellChips", function(amount)
    local source = source
    local user_id = XCEL.getUserId(source)
    local chips = nil
    if not sellingChips[source] then
        sellingChips[source] = true
        MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                if not amount then amount = chips end
                if amount > 0 and chips > 0 and chips >= amount then
                    MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = amount})
                    TriggerClientEvent('XCEL:chipsUpdated', source)
                    XCEL.sendWebhook('sell-chips',"XCEL Chip Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
                    XCEL.giveMoney(user_id, amount)
                else
                    XCELclient.notify(source,{"~r~You don't have enough chips."})
                end
                sellingChips[source] = nil
            end
        end)
    end
end)