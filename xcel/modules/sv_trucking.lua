-- local cfg = module("cfg/cfg_trucking")
-- local ownedtrucks = {}
-- local rentedtrucks = {}
-- local onTruckJob = false


-- AddEventHandler("XCELCli:playerSpawned", function()
--     local source = source
--     TriggerEvent("XCEL:updateOwnedTruckssv", source)
-- end)


-- local d = {
--     owned = {},
--     rented = {}
-- }

-- RegisterNetEvent("XCEL:updateOwnedTruckssv")
-- AddEventHandler("XCEL:updateOwnedTruckssv", function(ownedTrucks, rentedTrucks)
--     local source = source
    
--     d["owned"][source] = ownedTrucks
--     d["rented"][source] = rentedTrucks
--     TriggerClientEvent("XCEL:updateOwnedTrucks", source, d["owned"][source], d["rented"][source])
-- end)







-- RegisterServerEvent("XCEL:rentTruck")
-- AddEventHandler("XCEL:rentTruck", function(vehicleName, price)
--     local source = source
--     local user_id = XCEL.getUserId(source)
    
--     ownedtrucks[user_id] = ownedtrucks[user_id] or {}
--     rentedtrucks[user_id] = rentedtrucks[user_id] or {}
    
--     TriggerClientEvent("XCEL:updateOwnedTrucks", source, ownedtrucks[user_id], rentedtrucks[user_id])
-- end)

-- RegisterServerEvent("XCEL:spawnTruck")
-- AddEventHandler("XCEL:spawnTruck", function(vehicleName)
--     local source = source
--     TriggerClientEvent("XCEL:spawnTruckCl", source, vehicleName)
-- end)

-- RegisterServerEvent("XCEL:truckJobBuyAllTrucks")
-- AddEventHandler("XCEL:truckerJobBuyAllTrucks", function()
--     local source = source
    
--     -- Add your logic to handle buying all trucks here
    
--     TriggerClientEvent("XCEL:updateOwnedTrucks", source, ownedtrucks[source], rentedtrucks[source])
-- end)

-- RegisterServerEvent("XCEL:toggleTruckJob")
-- AddEventHandler("XCEL:toggleTruckJob", function(onDuty)
--     local source = source
--     onTruckJob = onDuty
    
--     -- Add your logic to handle the trucker job status here
    
--     TriggerClientEvent("XCEL:setTruckerOnDuty", source, onDuty)
-- end)
