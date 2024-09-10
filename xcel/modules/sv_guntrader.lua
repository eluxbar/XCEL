RegisterNetEvent('XCEL:gunTraderSell')
AddEventHandler('XCEL:gunTraderSell', function()
    local source = source
	local user_id = XCEL.getUserId(source)
    if checkTraderBucket(source) then
        if XCEL.getInventoryItemAmount(user_id, 'weapon') > 0 then
            XCEL.tryGetInventoryItem(user_id, 'weapon', 1, false)
            XCELclient.notify(source, {'~g~Sold weapon for £'..getMoneyStringFormatted(a.refundPercentage)})
            XCEL.giveBankMoney(user_id, defaultPrices['weapon'])
        else
            XCELclient.notify(source, {'~r~You do not have a weapon.'})
        end
    end
end)