RegisterServerEvent('XCEL:saveTattoos')
AddEventHandler('XCEL:saveTattoos', function(tattooData, price)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.tryFullPayment(user_id, price) then
        XCEL.setUData(user_id, "XCEL:Tattoo:Data", json.encode(tattooData))
    end
end)

RegisterServerEvent('XCEL:getPlayerTattoos')
AddEventHandler('XCEL:getPlayerTattoos', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.getUData(user_id, "XCEL:Tattoo:Data", function(data)
        if data ~= nil then
            TriggerClientEvent('XCEL:setTattoos', source, json.decode(data))
        end
    end)
end)
