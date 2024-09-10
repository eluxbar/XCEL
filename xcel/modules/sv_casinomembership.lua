function notifyClient(source, message)
    TriggerClientEvent('XCEL:notify', source, message)
end

function getUserId(source)
    return XCEL.getUserId(source)
end

function hasGroup(user_id, group)
    return XCEL.hasGroup(user_id, group)
end

function addUserGroup(user_id, group)
    XCEL.addUserGroup(user_id, group)
end

function removeUserGroup(user_id, group)
    XCEL.removeUserGroup(user_id, group)
end

function tryFullPayment(user_id, amount)
    return XCEL.tryFullPayment(user_id, amount)
end

function sendWebhook(event, title, message)
    XCEL.sendWebhook(event, title, message)
end

RegisterNetEvent('XCEL:purchaseHighRollersMembership')
AddEventHandler('XCEL:purchaseHighRollersMembership', function()
    local source = source
    local user_id = getUserId(source)
    if not hasGroup(user_id, 'Highroller') then
        if tryFullPayment(user_id, 10000000) then
            addUserGroup(user_id, 'Highroller')
            notifyClient(source, {'~g~You have purchased the ~b~High Rollers ~g~membership.'})
            sendWebhook('purchase-highrollers', "XCEL Purchased Highrollers Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**")
        else
            notifyClient(source, {'~r~You do not have enough money to purchase this membership.'})
        end
    else
        notifyClient(source, {"~r~You already have High Roller's License."})
    end
end)

RegisterNetEvent('XCEL:removeHighRollersMembership')
AddEventHandler('XCEL:removeHighRollersMembership', function()
    local source = source
    local user_id = getUserId(source)
    if hasGroup(user_id, 'Highroller') then
        removeUserGroup(user_id, 'Highroller')
        notifyClient(source, {'~r~You have removed the ~b~High Rollers ~r~membership.'})
    else
        notifyClient(source, {"~r~You do not have High Roller's License."})
    end
end)

RegisterNetEvent('XCEL:casinoBan')
AddEventHandler('XCEL:casinoBan', function(banDuration)
    local source = source
    local user_id = getUserId(source)
    if banDuration > 0 then
        XCEL.setCasinoBanTime(user_id, banDuration)
        notifyClient(source, {'~r~You are banned from the casino for '..banDuration..' hours.'})
        sendWebhook('casino-ban', "XCEL Casino Ban Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Ban Duration: **"..banDuration.." hours**")
    else
        notifyClient(source, {"~r~Invalid ban duration."})
    end
end)

RegisterNetEvent('XCEL:claimRakeback')
AddEventHandler('XCEL:claimRakeback', function()
    local source = source
    local user_id = getUserId(source)
    local rakeback = XCEL.getCasinoRakeback(user_id)
    if rakeback > 0 then
        XCEL.giveMoney(user_id, rakeback)
        XCEL.resetCasinoRakeback(user_id)
        notifyClient(source, {'~g~You have claimed £'..rakeback..' in rakeback.'})
        sendWebhook('claim-rakeback', "XCEL Claim Rakeback Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **£"..rakeback.."**")
    else
        notifyClient(source, {"~r~You have no rakeback to claim."})
    end
end)

RegisterNetEvent('XCEL:getCasinoStats')
AddEventHandler('XCEL:getCasinoStats', function()
    local source = source
    local user_id = getUserId(source)
    local stats = XCEL.getCasinoStats(user_id)
    local rakeback = XCEL.getCasinoRakeback(user_id)
    local banTime = XCEL.getCasinoBanTime(user_id)
    TriggerClientEvent('XCEL:setCasinoStats', source, stats, rakeback, banTime)
end)

function XCEL.getCasinoStats(user_id)
    return {}
end

function XCEL.getCasinoRakeback(user_id)
    return 0
end

function XCEL.resetCasinoRakeback(user_id)
end

function XCEL.getCasinoBanTime(user_id)
    return 0
end

function XCEL.setCasinoBanTime(user_id, banDuration)
end
