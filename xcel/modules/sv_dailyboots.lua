local VehicleBoots = module("xcel-vehicles", "cfg/cfg_inventory")
local Garage = module("xcel-vehicles", "cfg/cfg_garages") 
RegisterCommand("dailyboot",function(source,args,raw)
    local source = source
    local user_id = XCEL.getUserId(source)
    if BootRedeemable then
        if not table1.Claimed[user_id] then
            local vehicletable = {}
            MySQL.query("XCEL/get_vehicles", {user_id = user_id}, function(vehicles)
                if vehicles then
                    for A, B in pairs(vehicles) do
                        local isSkipCategory = IsSkipCategory(B.vehicle)
                        if not isSkipCategory then
                            vehicletable[B.vehicle] = {kg = VehicleBoots.vehicle_chest_weights[B.vehicle] or VehicleBoots.default_vehicle_chest_weight, checked = false}
                        end
                    end
                    TriggerClientEvent("XCEL:ReturnVehicleTable", source, vehicletable)
                else
                    XCELclient.notify(source, {"~r~Please Contact a Developer with the code 'XCEL-DB-1\nUser ID: " .. user_id})
                end
            end)
        else
            XCELclient.notify(source,{"~r~You have already claimed your daily boot!"})
        end
    else
        XCELclient.notify(source,{"~r~The daily boot is not redeemable at this time!"})
    end
end)

RegisterServerEvent("XCEL:ClaimBoot",function(table)
    local source = source
    local user_id = XCEL.getUserId(source)
    if not table1.Claimed[user_id] or not table1.Processing[user_id] and BootRedeemable then 
        table1.Processing[user_id] = true
        for A,B in pairs(table) do
            if B.checked then
                XCEL.getSData("chest:u1veh_"..A.."|"..user_id,function(cardata)
                    cardata = json.decode(cardata) or {}
                    local maxVehKg = VehicleBoots.vehicle_chest_weights[A] or VehicleBoots.default_vehicle_chest_weight
                    local weightCalculation = XCEL.computeItemsWeight(cardata)+30
                    if weightCalculation == nil then return end
                    if weightCalculation >= maxVehKg then
                        XCELclient.notify(source,{"~r~You cannot claim with this vehicle\nPlease Pick another!"})
                    else
                        for C,D in pairs(bootinformation.reward.items) do
                            print(C)
                            print(D)
                            cardata[C] = cardata[C] or {}
                            cardata[C].amount = (cardata[C].amount or 0) + D
                        end
                        table1.Claimed[user_id] = true
                        XCEL.giveBankMoney(user_id, bootinformation.reward.money)
                        TriggerClientEvent("XCEL:RewardClaimed",source)
                        TriggerClientEvent("XCEL:storeDrawEffects",source)
                        XCEL.setSData("chest:u1veh_"..A.."|"..user_id, json.encode(cardata))
                        XCELclient.notify(source,{"~g~You have claimed your daily boot and received "..getMoneyStringFormatted(bootinformation.reward.money).."!"})
                    end
                    table1.Processing[user_id] = false
                end)
            end
        end
    else
        XCELclient.notify(source,{table1.Claimed[user_id] and "~r~You have already claimed your daily boot!" or table1.Processing[user_id] and "~r~You are already processing a boot!" or not BootRedeemable and "~r~The daily boot is not redeemable at this time!" or "~r~Please contact a developer with the code 'XCEL-ERR-1'"})
    end
end)

function IsSkipCategory(vehicleName)
    local skipCategories = {"police.armoury", "nhs.menu", "hmp.menu", "lfb.onduty.permission"}
    for garageName, garageData in pairs(Garage.garages) do
        local config = garageData._config
        local permissions = config.permissions or {}
        for _, permission in ipairs(permissions) do
            if tableContains(skipCategories, permission) and garageData[vehicleName] then
                return true
            end
        end
    end
    return false
end