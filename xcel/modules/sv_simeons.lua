local cfg=module("xcel-vehicles", "cfg/cfg_simeons")
local inventory=module("xcel-vehicles", "cfg/cfg_inventory")


RegisterNetEvent("XCEL:refreshSimeonsPermissions")
AddEventHandler("XCEL:refreshSimeonsPermissions",function()
    local source=source
    local simeonsCategories={}
    local user_id = XCEL.getUserId(source)
    for k,v in pairs(cfg.simeonsCategories) do
        for a,b in pairs(v) do
            if a == "_config" then
                if b.permissionTable[1] ~= nil then
                    if XCEL.hasPermission(XCEL.getUserId(source),b.permissionTable[1])then
                        for c,d in pairs(v) do
                            if inventory.vehicle_chest_weights[c] then
                                table.insert(v[c],inventory.vehicle_chest_weights[c])
                            else
                                table.insert(v[c],30)
                            end
                        end
                        simeonsCategories[k] = v
                    end
                else
                    for c,d in pairs(v) do
                        if inventory.vehicle_chest_weights[c] then
                            table.insert(v[c],inventory.vehicle_chest_weights[c])
                        else
                            table.insert(v[c],30)
                        end
                    end
                    simeonsCategories[k] = v
                end
            end
        end
    end
    TriggerClientEvent("XCEL:gotCarDealerInstances",source,cfg.simeonsInstances)
    TriggerClientEvent("XCEL:gotCarDealerCategories",source,simeonsCategories)
end)

RegisterNetEvent('XCEL:purchaseCarDealerVehicle')
AddEventHandler('XCEL:purchaseCarDealerVehicle', function(vehicleclass, vehicle)
    local source = source
    local user_id = XCEL.getUserId(source)
    local playerName = XCEL.GetPlayerName(user_id)   
    for k,v in pairs(cfg.simeonsCategories[vehicleclass]) do
        if k == vehicle then
            local vehicle_name = v[1]
            local vehicle_price = v[2]
            MySQL.query("XCEL/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
                if #pvehicle > 0 then
                    XCELclient.notify(source,{"~r~Vehicle already owned."})
                else
                    if XCEL.tryFullPayment(user_id, vehicle_price) then
                        XCELclient.generateUUID(source, {"plate", 5, "alphanumeric"}, function(uuid)
                            local uuid = string.upper(uuid)
                            MySQL.execute("XCEL/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = 'P'..uuid})
                            XCELclient.notify(source,{"~g~Paid £"..vehicle_price.." for "..vehicle_name.."."})
                            TriggerClientEvent("XCEL:PlaySound", source, "playMoney")
                            TriggerClientEvent("XCEL:carDealerPurchased", source)
                        end)
                    else
                        XCELclient.notify(source,{"~r~Not enough money."})
                        TriggerClientEvent("XCEL:PlaySound", source, 2)
                    end
                end
            end)
        end
    end
end)
