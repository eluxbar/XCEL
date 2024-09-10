local cfg = module("cfg/cfg_stores")


RegisterNetEvent("XCEL:BuyStoreItem")
AddEventHandler("XCEL:BuyStoreItem", function(item, amount)
    local user_id = XCEL.getUserId(source)
    local ped = GetPlayerPed(source)
    for k,v in pairs(cfg.shopItems) do
        if item == v.itemID then
            if XCEL.getInventoryWeight(user_id) <= 25 then
                if XCEL.tryBankPayment(user_id,v.price*amount) then
                    XCEL.giveInventoryItem(user_id, item, amount, false)
                    XCELclient.notifyPicture(source, {"monzo", "monzo", "~g~Paid ".. '£' ..getMoneyStringFormatted(v.price*amount)..'.'})

                    TriggerClientEvent("XCEL:PlaySound", source, "playMoney")
                else
                    XCELclient.notify(source, {"~r~Not enough money."})
                    TriggerClientEvent("XCEL:PlaySound", source, 2)
                end
            else
                XCELclient.notify(source,{'~r~Not enough inventory space.'})
                TriggerClientEvent("XCEL:PlaySound", source, 2)
            end
        end
    end
end)