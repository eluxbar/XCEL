local lang = XCEL.lang
local MoneydropEntities = {}

function tXCEL.MoneyDrop()
    local source = source
    Wait(100) -- wait delay for death.
    local user_id = XCEL.getUserId(source)
    local money = XCEL.getMoney(user_id)
    if money > 0 then
        local model = `prop_poly_bag_money`
        local name1 = XCEL.GetPlayerName(user_id)
        local moneydrop = CreateObjectNoOffset(model, GetEntityCoords(GetPlayerPed(source)) + 0.2, true, true, false)
        local moneydropnetid = NetworkGetNetworkIdFromEntity(moneydrop)
        SetEntityRoutingBucket(moneydrop, GetPlayerRoutingBucket(source))
        MoneydropEntities[moneydropnetid] = {moneydrop, moneydrop, false, source}
        MoneydropEntities[moneydropnetid].Money = {}
        local ndata = XCEL.getUserDataTable(user_id)
        local stored_inventory = nil;
        if XCEL.tryPayment(user_id,money) then
            MoneydropEntities[moneydropnetid].Money = money
        end
    end
end

RegisterNetEvent('XCEL:Moneydrop')
AddEventHandler('XCEL:Moneydrop', function(netid)
    local source = source
    if MoneydropEntities[netid] and not MoneydropEntities[netid][3] and #(GetEntityCoords(MoneydropEntities[netid][1]) - GetEntityCoords(GetPlayerPed(source))) < 10.0 then
        MoneydropEntities[netid][3] = true;
        local user_id = XCEL.getUserId(source)
        if user_id ~= nil then
            TriggerClientEvent("XCEL:MoneyNotInBag",source)
            if MoneydropEntities[netid].Money ~= 0 then
                XCEL.giveMoney(user_id,MoneydropEntities[netid].Money)
                local moneyamount = tonumber(MoneydropEntities[netid].Money)
                XCELclient.notify(source,{"~g~You have picked up £"..getMoneyStringFormatted(moneyamount)})
                MoneydropEntities[netid].Money = 0
            end
        else
            XCELclient.notify(source,{"~r~The money has been picked up by someone else."})

        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Wait(100)
        for i,v in pairs(MoneydropEntities) do 
            if v.Money == 0 then
                if DoesEntityExist(v[1]) then 
                    DeleteEntity(v[1])
                    MoneydropEntities[i] = nil;
                end
            end
        end
    end
end)