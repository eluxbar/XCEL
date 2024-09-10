local verifyCodes = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        for k, v in pairs(verifyCodes) do
            if verifyCodes[k] ~= nil then
                verifyCodes[k] = nil
            end
        end
    end
end)

RegisterServerEvent('XCEL:changeLinkedDiscord', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.prompt(source, "Enter Discord Id:", "", function(source, discordid)
        if discordid ~= nil then
            TriggerClientEvent('XCEL:gotDiscord', source)
            generateUUID({"linkcode", 5, "alphanumeric"}, function(code)
                verifyCodes[user_id] = { code = code, discordid = discordid, timestamp = os.time() }
                exports['xcel']:dmUser(source, { discordid, code, user_id }, function() end)
            end)
        end
    end)
end)

RegisterServerEvent('XCEL:enterDiscordCode', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local currentTimestamp = os.time()
    local verification = verifyCodes[user_id]

    if verification and currentTimestamp - verification.timestamp <= 300 then
        XCEL.prompt(source, "Enter Code:", "", function(source, code)
            if code and code ~= "" then
                if verification.code == code then
                    exports['xcel']:execute("UPDATE `xcel_verification` SET discord_id = @discord_id WHERE user_id = @user_id", { user_id = user_id, discord_id = verification.discordid }, function() end)
                    XCELclient.notify(source, { '~g~Your discord has been successfully updated.' })
                else
                    XCELclient.notify(source, { '~r~Invalid code.' })
                end
            else
                XCELclient.notify(source, { '~r~You need to enter a code!' })
            end
        end)
    else
        XCELclient.notify(source, { '~r~Your code has expired.' })
    end
end)
