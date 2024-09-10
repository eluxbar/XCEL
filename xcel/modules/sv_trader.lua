grindBoost = 2.0

local defaultPrices = {
    ["Weed"] = math.floor(1500*grindBoost),
    ["Cocaine"] = math.floor(2500*grindBoost),
    ["Meth"] = math.floor(3000*grindBoost),
    ["Heroin"] = math.floor(10000*grindBoost),
    ["LSDNorth"] = math.floor(15000*grindBoost),
    ["LSDSouth"] = math.floor(15000*grindBoost),
    ["Copper"] = math.floor(1000*grindBoost),
    ["Limestone"] = math.floor(2000*grindBoost),
    ["Gold"] = math.floor(4000*grindBoost),
    ["Diamond"] = math.floor(6000*grindBoost),
}

function XCEL.getCommissionPrice(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            if v.commission == nil then
                v.commission = 0
            end
            if v.commission == 0 then
                return defaultPrices[drugtype]
            else
                return defaultPrices[drugtype]-defaultPrices[drugtype]*v.commission/100
            end
        end
    end
end

function XCEL.getCommission(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            return v.commission
        end
    end
end

function XCEL.updateTraderInfo()
    TriggerClientEvent('XCEL:updateTraderCommissions', -1, 
    XCEL.getCommission('Weed'),
    XCEL.getCommission('Cocaine'),
    XCEL.getCommission('Meth'),
    XCEL.getCommission('Heroin'),
    XCEL.getCommission('LargeArms'),
    XCEL.getCommission('LSDNorth'),
    XCEL.getCommission('LSDSouth'))
    TriggerClientEvent('XCEL:updateTraderPrices', -1, 
    XCEL.getCommissionPrice('Weed'), 
    XCEL.getCommissionPrice('Cocaine'),
    XCEL.getCommissionPrice('Meth'),
    XCEL.getCommissionPrice('Heroin'),
    XCEL.getCommissionPrice('LSDNorth'),
    XCEL.getCommissionPrice('LSDSouth'),
    defaultPrices['Copper'],
    defaultPrices['Limestone'],
    defaultPrices['Gold'],
    defaultPrices['Diamond'])
end

RegisterNetEvent('XCEL:requestDrugPriceUpdate')
AddEventHandler('XCEL:requestDrugPriceUpdate', function()
    local source = source
	local user_id = XCEL.getUserId(source)
    XCEL.updateTraderInfo()
end)

local function checkTraderBucket(source)
    if GetPlayerRoutingBucket(source) ~= 0 then
        XCELclient.notify(source, {'~r~You cannot sell drugs in this dimension.'})
        return false
    end
    return true
end

RegisterNetEvent('XCEL:sellCopper')
AddEventHandler('XCEL:sellCopper', function()
    local source = source
	local user_id = XCEL.getUserId(source)
    if checkTraderBucket(source) then
        if XCEL.getInventoryItemAmount(user_id, 'Copper') > 0 then
            XCEL.tryGetInventoryItem(user_id, 'Copper', 1, false)
            XCELclient.notify(source, {'~g~Sold Copper for £'..getMoneyStringFormatted(defaultPrices['Copper'])})
            XCEL.giveBankMoney(user_id, defaultPrices['Copper'])
        else
            XCELclient.notify(source, {'~r~You do not have Copper.'})
        end
    end
end)

RegisterNetEvent('XCEL:sellLimestone')
AddEventHandler('XCEL:sellLimestone', function()
    local source = source
	local user_id = XCEL.getUserId(source)
    if checkTraderBucket(source) then
        if XCEL.getInventoryItemAmount(user_id, 'Limestone') > 0 then
            XCEL.tryGetInventoryItem(user_id, 'Limestone', 1, false)
            XCELclient.notify(source, {'~g~Sold Limestone for £'..getMoneyStringFormatted(defaultPrices['Limestone'])})
            XCEL.giveBankMoney(user_id, defaultPrices['Limestone'])
        else
            XCELclient.notify(source, {'~r~You do not have Limestone.'})
        end
    end
end)

RegisterNetEvent('XCEL:sellGold')
AddEventHandler('XCEL:sellGold', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if checkTraderBucket(source) then
        if XCEL.getInventoryItemAmount(user_id, 'Gold') > 0 then
            XCEL.tryGetInventoryItem(user_id, 'Gold', 1, false)
            XCELclient.notify(source, {'~g~Sold Gold for £'..getMoneyStringFormatted(defaultPrices['Gold'])})
            XCEL.giveBankMoney(user_id, defaultPrices['Gold'])
        else
            XCELclient.notify(source, {'~r~You do not have Gold.'})
        end
    end
end)

RegisterNetEvent('XCEL:sellDiamond')
AddEventHandler('XCEL:sellDiamond', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if checkTraderBucket(source) then
        if XCEL.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
            XCEL.tryGetInventoryItem(user_id, 'Processed Diamond', 1, false)
            XCELclient.notify(source, {'~g~Sold Processed Diamond for £'..getMoneyStringFormatted(defaultPrices['Diamond'])})
            XCEL.giveBankMoney(user_id, defaultPrices['Diamond'])
        else
            XCELclient.notify(source, {'~r~You do not have Diamond.'})
        end
    end
end)

RegisterNetEvent('XCEL:sellWeed')
AddEventHandler('XCEL:sellWeed', function(sellall)
    local source = source
    local user_id = XCEL.getUserId(source)
    if checkTraderBucket(source) then
        if XCEL.getInventoryItemAmount(user_id,"Weed") > 0 then
            if sellall then
                local amount = XCEL.getInventoryItemAmount(user_id,"Weed")
                XCEL.tryGetInventoryItem(user_id, 'Weed', amount, false)
                XCELclient.notify(source, {'~g~Sold Weed for £'..getMoneyStringFormatted(XCEL.getCommissionPrice('Weed')*amount)})
                XCEL.giveMoney(user_id, XCEL.getCommissionPrice('Weed')*amount)
                XCEL.turfSaleToGangFunds(XCEL.getCommissionPrice('Weed')*amount, 'Weed')
            else
                XCEL.tryGetInventoryItem(user_id, 'Weed', 1, false)
                XCELclient.notify(source, {'~g~Sold Weed for £'..getMoneyStringFormatted(XCEL.getCommissionPrice('Weed'))})
                XCEL.giveMoney(user_id, XCEL.getCommissionPrice('Weed'))
                XCEL.turfSaleToGangFunds(XCEL.getCommissionPrice('Weed'), 'Weed')
            end
        else
            XCELclient.notify(source, {'~r~You do not have Weed.'})
        end
    end
end)

RegisterNetEvent('XCEL:sellCocaine')
AddEventHandler('XCEL:sellCocaine', function(sellall)
    local source = source
    local user_id = XCEL.getUserId(source)
    if checkTraderBucket(source) then
        if XCEL.getInventoryItemAmount(user_id,"Cocaine") > 0 then
            if sellall then
                local amount = XCEL.getInventoryItemAmount(user_id,"Cocaine")
                XCEL.tryGetInventoryItem(user_id, 'Cocaine', amount, false)
                XCELclient.notify(source, {'~g~Sold Cocaine for £'..getMoneyStringFormatted(XCEL.getCommissionPrice('Cocaine')*amount)})
                XCEL.giveMoney(user_id, XCEL.getCommissionPrice('Cocaine')*amount)
                XCEL.turfSaleToGangFunds(XCEL.getCommissionPrice('Cocaine')*amount, 'Cocaine')
            else
                XCEL.tryGetInventoryItem(user_id, 'Cocaine', 1, false)
                XCELclient.notify(source, {'~g~Sold Cocaine for £'..getMoneyStringFormatted(XCEL.getCommissionPrice('Cocaine'))})
                XCEL.giveMoney(user_id, XCEL.getCommissionPrice('Cocaine'))
                XCEL.turfSaleToGangFunds(XCEL.getCommissionPrice('Cocaine'), 'Cocaine')
            end
        else
            XCELclient.notify(source, {'You do not have Cocaine.'})
        end
    end
end)

RegisterNetEvent('XCEL:sellMeth')
AddEventHandler('XCEL:sellMeth', function(sellall)
    local source = source
    local user_id = XCEL.getUserId(source)
    if checkTraderBucket(source) then
        if XCEL.getInventoryItemAmount(user_id,"Meth") > 0 then
            if sellall then
                local amount = XCEL.getInventoryItemAmount(user_id,"Meth")
                XCEL.tryGetInventoryItem(user_id, 'Meth', amount, false)
                XCELclient.notify(source, {'~g~Sold Meth for £'..getMoneyStringFormatted(XCEL.getCommissionPrice('Meth')*amount)})
                XCEL.giveMoney(user_id, XCEL.getCommissionPrice('Meth')*amount)
                XCEL.turfSaleToGangFunds(XCEL.getCommissionPrice('Meth')*amount, 'Meth')
            else
                XCEL.tryGetInventoryItem(user_id, 'Meth', 1, false)
                XCELclient.notify(source, {'~g~Sold Meth for £'..getMoneyStringFormatted(XCEL.getCommissionPrice('Meth'))})
                XCEL.giveMoney(user_id, XCEL.getCommissionPrice('Meth'))
                XCEL.turfSaleToGangFunds(XCEL.getCommissionPrice('Meth'), 'Meth')
            end
        else
            XCELclient.notify(source, {'~r~You do not have Meth.'})
        end
    end
end)

RegisterNetEvent('XCEL:sellHeroin')
AddEventHandler('XCEL:sellHeroin', function(sellall)
    local source = source
    local user_id = XCEL.getUserId(source)
    if checkTraderBucket(source) then
        if XCEL.getInventoryItemAmount(user_id,"Heroin") > 0 then
            if sellall then
                local amount = XCEL.getInventoryItemAmount(user_id,"Heroin")
                XCEL.tryGetInventoryItem(user_id, 'Heroin', amount, false)
                XCELclient.notify(source, {'~g~Sold Heroin for £'..getMoneyStringFormatted(XCEL.getCommissionPrice('Heroin')*amount)})
                XCEL.giveMoney(user_id, XCEL.getCommissionPrice('Heroin')*amount)
                XCEL.turfSaleToGangFunds(XCEL.getCommissionPrice('Heroin')*amount, 'Heroin')
            else
                XCEL.tryGetInventoryItem(user_id, 'Heroin', 1, false)
                XCELclient.notify(source, {'~g~Sold Heroin for £'..getMoneyStringFormatted(XCEL.getCommissionPrice('Heroin'))})
                XCEL.giveMoney(user_id, XCEL.getCommissionPrice('Heroin'))
                XCEL.turfSaleToGangFunds(XCEL.getCommissionPrice('Heroin'), 'Heroin')
            end
        else
            XCELclient.notify(source, {'~r~You do not have Heroin.'})
        end
    end
end)

RegisterNetEvent('XCEL:sellLSDNorth')
AddEventHandler('XCEL:sellLSDNorth', function(sellall)
    local source = source
    local user_id = XCEL.getUserId(source)
    if checkTraderBucket(source) then
        if XCEL.getInventoryItemAmount(user_id,"LSD") > 0 then
            if sellall then
                local amount = XCEL.getInventoryItemAmount(user_id,"LSD")
                XCEL.tryGetInventoryItem(user_id, 'LSD', amount, false)
                XCELclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(XCEL.getCommissionPrice('LSDNorth')*amount)})
                XCEL.giveMoney(user_id, XCEL.getCommissionPrice('LSDNorth')*amount)
                XCEL.turfSaleToGangFunds(XCEL.getCommissionPrice('LSDNorth')*amount, 'LSDNorth')
            else
                XCEL.tryGetInventoryItem(user_id, 'LSD', 1, false)
                XCELclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(XCEL.getCommissionPrice('LSDNorth'))})
                XCEL.giveMoney(user_id, XCEL.getCommissionPrice('LSDNorth'))
                XCEL.turfSaleToGangFunds(XCEL.getCommissionPrice('LSDNorth'), 'LSDNorth')
            end
        else
            XCELclient.notify(source, {'~r~You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('XCEL:sellLSDSouth')
AddEventHandler('XCEL:sellLSDSouth', function(sellall)
    local source = source
    local user_id = XCEL.getUserId(source)
    if checkTraderBucket(source) then
        if XCEL.getInventoryItemAmount(user_id,"LSD") > 0 then
            if sellall then
                local amount = XCEL.getInventoryItemAmount(user_id,"LSD")
                XCEL.tryGetInventoryItem(user_id, 'LSD', amount, false)
                XCELclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(XCEL.getCommissionPrice('LSDSouth')*amount)})
                XCEL.giveMoney(user_id, XCEL.getCommissionPrice('LSDSouth')*amount)
                XCEL.turfSaleToGangFunds(XCEL.getCommissionPrice('LSDSouth')*amount, 'LSDSouth')
            else
                XCEL.tryGetInventoryItem(user_id, 'LSD', 1, false)
                XCELclient.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(XCEL.getCommissionPrice('LSDSouth'))})
                XCEL.giveMoney(user_id, XCEL.getCommissionPrice('LSDSouth'))
                XCEL.turfSaleToGangFunds(XCEL.getCommissionPrice('LSDSouth'), 'LSDSouth')
            end
        else
            XCELclient.notify(source, {'~r~You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('XCEL:sellAll')
AddEventHandler('XCEL:sellAll', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if checkTraderBucket(source) then
        for k,v in pairs(defaultPrices) do
            if k == 'Copper' or k == 'Limestone' or k == 'Gold' then
                if XCEL.getInventoryItemAmount(user_id, k) > 0 then
                    local amount = XCEL.getInventoryItemAmount(user_id, k)
                    XCEL.tryGetInventoryItem(user_id, k, amount, false)
                    XCELclient.notify(source, {'~g~Sold '..k..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    XCEL.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            elseif k == 'Diamond' then
                if XCEL.getInventoryItemAmount(user_id, 'Processed Diamond') > 0 then
                    local amount = XCEL.getInventoryItemAmount(user_id, 'Processed Diamond')
                    XCEL.tryGetInventoryItem(user_id, 'Processed Diamond', amount, false)
                    XCELclient.notify(source, {'~g~Sold '..'Processed Diamond'..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    XCEL.giveBankMoney(user_id, defaultPrices[k]*amount)
                end
            end
        end
    end
end)

RegisterCommand("testitem", function(source, args, rawCommand)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id == 1 then
        if args[1] then
            if args[2] then
                XCEL.giveInventoryItem(user_id, args[2], tonumber(args[1]))
            else
                XCELclient.notify(source, {'~r~Invalid Arguments /testitem [amount] [itemname]'})
            end
        else
            XCELclient.notify(source, {'~r~Invalid Arguments /testitem [amount] [itemname]'})
        end
    end
end)