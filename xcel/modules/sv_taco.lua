local tacoDrivers = {}

RegisterNetEvent('XCEL:addTacoSeller')
AddEventHandler('XCEL:addTacoSeller', function(coords, price)
    local source = source
    local user_id = XCEL.getUserId(source)
    tacoDrivers[user_id] = {position = coords, amount = price}
    TriggerClientEvent('XCEL:sendClientTacoData', -1, tacoDrivers)
end)

RegisterNetEvent('XCEL:RemoveMeFromTacoPositions')
AddEventHandler('XCEL:RemoveMeFromTacoPositions', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    tacoDrivers[user_id] = nil
    TriggerClientEvent('XCEL:removeTacoSeller', -1, user_id)
end)

RegisterNetEvent('XCEL:payTacoSeller')
AddEventHandler('XCEL:payTacoSeller', function(id)
    local source = source
    local user_id = XCEL.getUserId(source)
    if tacoDrivers[id] then
        if XCEL.getInventoryWeight(user_id)+1 <= XCEL.getInventoryMaxWeight(user_id) then
            if XCEL.tryFullPayment(user_id,15000) then
                XCEL.giveInventoryItem(user_id, 'Taco', 1)
                XCEL.giveBankMoney(id, 15000)
                TriggerClientEvent("XCEL:PlaySound", source, "money")
            else
                XCELclient.notify(source, {'~r~You do not have enough money.'})
            end
        else
            XCELclient.notify(source, {'~r~Not enough inventory space.'})
        end
    end
end)