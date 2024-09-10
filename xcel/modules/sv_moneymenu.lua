RegisterServerEvent("XCEL:getUserinformation")
AddEventHandler("XCEL:getUserinformation",function(id)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'admin.moneymenu') then
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('XCEL:receivedUserInformation', source, XCEL.getUserSource(id), XCEL.GetPlayerName(id), math.floor(XCEL.getBankMoney(id)), math.floor(XCEL.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("XCEL:ManagePlayerBank")
AddEventHandler("XCEL:ManagePlayerBank",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = XCEL.getUserId(source)
    local userstemp = XCEL.getUserSource(id)
    if XCEL.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            XCEL.giveBankMoney(id, amount)
            XCELclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Bank Balance.'})
            XCEL.sendWebhook('manage-balance',"XCEL Money Menu Logs", "> Admin Name: **"..XCEL.GetPlayerName(user_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..XCEL.GetPlayerName(id).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Bank**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            XCEL.tryBankPayment(id, amount)
            XCELclient.notify(source, {'Removed £'..getMoneyStringFormatted(amount)..' from players Bank Balance.'})
            XCEL.sendWebhook('manage-balance',"XCEL Money Menu Logs", "> Admin Name: **"..XCEL.GetPlayerName(user_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..XCEL.GetPlayerName(id).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Bank**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('XCEL:receivedUserInformation', source, XCEL.getUserSource(id), XCEL.GetPlayerName(id), math.floor(XCEL.getBankMoney(id)), math.floor(XCEL.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("XCEL:ManagePlayerCash")
AddEventHandler("XCEL:ManagePlayerCash",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = XCEL.getUserId(source)
    local userstemp = XCEL.getUserSource(id)
    if user_id == 61 then
        XCELclient.notify(source, {"No Slothid"})
        return
    end
    if XCEL.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            XCEL.giveMoney(id, amount)
            XCELclient.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Cash Balance.'})
            XCEL.sendWebhook('manage-balance',"XCEL Money Menu Logs", "> Admin Name: **"..XCEL.GetPlayerName(user_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..XCEL.GetPlayerName(id).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Cash**\n> Type: **"..cashtype.."**")
        elseif cashtype == 'Decrease' then
            XCEL.tryPayment(id, amount)
            XCELclient.notify(source, {'~r~Removed £'..getMoneyStringFormatted(amount)..' from players Cash Balance.'})
            XCEL.sendWebhook('manage-balance',"XCEL Money Menu Logs", "> Admin Name: **"..XCEL.GetPlayerName(user_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..XCEL.GetPlayerName(id).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **£"..amount.." Cash**\n> Type: **"..cashtype.."**")
        end
        MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                TriggerClientEvent('XCEL:receivedUserInformation', source, XCEL.getUserSource(id), XCEL.GetPlayerName(id), math.floor(XCEL.getBankMoney(id)), math.floor(XCEL.getMoney(id)), chips)
            end
        end)
    end
end)

RegisterServerEvent("XCEL:ManagePlayerChips")
AddEventHandler("XCEL:ManagePlayerChips",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = XCEL.getUserId(source)
    local userstemp = XCEL.getUserSource(id)
    if user_id == 61 then
        XCELclient.notify(source, {"No Watt Skill"})
        return
    end
    if XCEL.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            MySQL.execute("casinochips/add_chips", {user_id = id, amount = amount})
            XCELclient.notify(source, {'~g~Added '..getMoneyStringFormatted(amount)..' to players Casino Chips.'})
            XCEL.sendWebhook('manage-balance',"XCEL Money Menu Logs", "> Admin Name: **"..XCEL.GetPlayerName(user_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..XCEL.GetPlayerName(id).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **"..amount.." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('XCEL:receivedUserInformation', source, XCEL.getUserSource(id), XCEL.GetPlayerName(id), math.floor(XCEL.getBankMoney(id)), math.floor(XCEL.getMoney(id)), chips)
                end
            end)
        elseif cashtype == 'Decrease' then
            MySQL.execute("casinochips/remove_chips", {user_id = id, amount = amount})
            XCELclient.notify(source, {'~r~Removed '..getMoneyStringFormatted(amount)..' from players Casino Chips.'})
            XCEL.sendWebhook('manage-balance',"XCEL Money Menu Logs", "> Admin Name: **"..XCEL.GetPlayerName(user_id).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..XCEL.GetPlayerName(id).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..userstemp.."**\n> Amount: **"..amount.." Chips**\n> Type: **"..cashtype.."**")
            MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
                if #rows > 0 then
                    local chips = rows[1].chips
                    TriggerClientEvent('XCEL:receivedUserInformation', source, XCEL.getUserSource(id), XCEL.GetPlayerName(id), math.floor(XCEL.getBankMoney(id)), math.floor(XCEL.getMoney(id)), chips)
                end
            end)
        end
    end
end)