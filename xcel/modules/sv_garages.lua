local lang = XCEL.lang
local cfg = module("xcel-vehicles", "cfg/cfg_garages")
local cfg_inventory = module("xcel-vehicles", "cfg/cfg_inventory")
local vehicle_groups = cfg.garages
local limit = cfg.limit or 1000000000
MySQL.createCommand("XCEL/add_vehicle","INSERT IGNORE INTO xcel_user_vehicles(user_id,vehicle,vehicle_plate,locked) VALUES(@user_id,@vehicle,@registration,@locked)")
MySQL.createCommand("XCEL/remove_vehicle","DELETE FROM xcel_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("XCEL/get_vehicles", "SELECT vehicle, rentedtime, vehicle_plate, fuel_level, impounded FROM xcel_user_vehicles WHERE user_id = @user_id")
MySQL.createCommand("XCEL/get_rented_vehicles_in", "SELECT vehicle, rentedtime, user_id FROM xcel_user_vehicles WHERE user_id = @user_id AND rented = 1")
MySQL.createCommand("XCEL/get_rented_vehicles_out", "SELECT vehicle, rentedtime, user_id FROM xcel_user_vehicles WHERE rentedid = @user_id AND rented = 1")
MySQL.createCommand("XCEL/get_vehicle","SELECT vehicle FROM xcel_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("XCEL/get_vehicle_fuellevel","SELECT fuel_level FROM xcel_user_vehicles WHERE vehicle = @vehicle")
MySQL.createCommand("XCEL/check_rented","SELECT * FROM xcel_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle AND rented = 1")
MySQL.createCommand("XCEL/sell_vehicle_player","UPDATE xcel_user_vehicles SET user_id = @user_id, vehicle_plate = @registration WHERE user_id = @oldUser AND vehicle = @vehicle")
MySQL.createCommand("XCEL/rentedupdate", "UPDATE xcel_user_vehicles SET user_id = @id, rented = @rented, rentedid = @rentedid, rentedtime = @rentedunix WHERE user_id = @user_id AND vehicle = @veh")
MySQL.createCommand("XCEL/fetch_rented_vehs", "SELECT * FROM xcel_user_vehicles WHERE rented = 1")
MySQL.createCommand("XCEL/get_vehicle_count","SELECT * FROM xcel_user_vehicles WHERE vehicle = @vehicle")
MySQL.createCommand("XCEL/get_vehicle_lock_state", "SELECT * FROM xcel_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")

RegisterServerEvent("XCEL:spawnPersonalVehicle")
AddEventHandler('XCEL:spawnPersonalVehicle', function(vehicle)
    local source = source
    local user_id = XCEL.getUserId(source)
    MySQL.query("XCEL/get_vehicles", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.vehicle == vehicle then
                    if v.impounded then
                        XCELclient.notify(source, {'~r~This vehicle is currently impounded.'})
                        return
                    else
                        TriggerClientEvent('XCEL:spawnPersonalVehicle', source, v.vehicle, user_id, false, GetEntityCoords(GetPlayerPed(source)), v.vehicle_plate, v.fuel_level)
                        return
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent('phone:garage:getVehicles')
AddEventHandler('phone:garage:getVehicles', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    MySQL.query("XCEL/get_vehicles", {user_id = user_id}, function(result)
        if result then 
            local vehicles = {}
            for i, vehicle in ipairs(result) do
                vehicles[i] = {model = vehicle.vehicle, plate = vehicle.vehicle_plate}
            end

            TriggerClientEvent('phone:garage:receiveVehicles', source, vehicles)
        end
    end)
end)


valetCooldown = {}
RegisterServerEvent("XCEL:valetSpawnVehicle")
AddEventHandler('XCEL:valetSpawnVehicle', function(spawncode)
    local source = source
    local user_id = XCEL.getUserId(source)
    XCELclient.isPlusClub(source,{},function(plusclub)
        XCELclient.isPlatClub(source,{},function(platclub)
            if plusclub or platclub then
                if valetCooldown[source] and not (os.time() > valetCooldown[source]) then
                    return XCELclient.notify(source,{"~r~Please wait before using this again."})
                else
                    valetCooldown[source] = nil
                end
                MySQL.query("XCEL/get_vehicles", {user_id = user_id}, function(result)
                    if result ~= nil then 
                        for k,v in pairs(result) do
                            if v.vehicle == spawncode then
                                TriggerClientEvent('XCEL:spawnPersonalVehicle', source, v.vehicle, user_id, true, GetEntityCoords(GetPlayerPed(source)), v.vehicle_plate, v.fuel_level)
                                valetCooldown[source] = os.time() + 60
                                return
                            end
                        end
                    end
                end)
            else
                XCELclient.notify(source, {"~y~You need to be a subscriber of XCEL Plus or XCEL Platinum to use this feature."})
                XCELclient.notify(source, {"~y~Available @ store.xcelstudios.com"})
            end
        end)
    end)
end)

RegisterServerEvent("XCEL:getVehicleRarity")
AddEventHandler('XCEL:getVehicleRarity', function(spawncode)
    local source = source
    local user_id = XCEL.getUserId(source)
    MySQL.query("XCEL/get_vehicle_lock_state", {user_id = user_id,vehicle = spawncode}, function(results)
        if results ~= nil then
            MySQL.query("XCEL/get_vehicle_count", {vehicle = spawncode}, function(result)
                if result ~= nil then
                    TriggerClientEvent('XCEL:setVehicleRarity', source, spawncode,#result,tobool(results[1].locked))
                end
            end)
        end
    end)
end)

RegisterServerEvent("XCEL:displayVehicleBlip")
AddEventHandler('XCEL:displayVehicleBlip', function(spawncode)
    local source = source
    local user_id = XCEL.getUserId(source)
    MySQL.query("XCELls/get_vehicle_modifications", {user_id = user_id, vehicle = spawncode}, function(rows, affected) 
        if rows ~= nil then 
            if #rows > 0 then
                XCELclient.getOwnedVehiclePosition(source, {spawncode}, function(x,y,z)
                    if vector3(x,y,z) ~= vector3(0,0,0) then
                        local mods = json.decode(rows[1].modifications) or {}
                        if mods['remoteblips'] == 1 then
                            local position = {}
                            position.x, position.y, position.z = x,y,z
                            if next(position) then
                                TriggerClientEvent('XCEL:displayVehicleBlip', source, position)
                                XCELclient.notify(source, {"~g~Vehicle blip enabled."})
                                return
                            end
                        end
                        XCELclient.notify(source, {"~r~This vehicle does not have a remote vehicle blip installed."})
                    else
                        XCELclient.notify(source, {"~r~Can not locate vehicle with the plate "..rows[1].vehicle_plate.." in this city."})
                    end
                end)
            end
        end
    end)
end)

-- Example server-side callback
RegisterServerEvent("phone:garage:getVehicles")
AddEventHandler("phone:garage:getVehicles", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local vehicles = {} -- This should be replaced with actual database query results

    -- Example database query (pseudo-code)
    MySQL.query("SELECT * FROM xcel_user_vehicles WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result then
            for _, vehicle in pairs(result) do
                table.insert(vehicles, {
                    -- Assuming your vehicle data structure has these fields
                    model = xcel_user_vehicles.vehicle,
                    plate = xcel_user_vehicles.vehicle_plate,
                    -- Other vehicle details...
                })
            end
        end

        -- Sending the vehicle data back to the client
        TriggerClientEvent("phone:garage:returnVehicles", source, vehicles)
    end)
end)


RegisterNetEvent("XCEL:logVehicleSpawn")
AddEventHandler("XCEL:logVehicleSpawn", function(spawncode)
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.sendWebhook('spawn-vehicle', "XCEL Spawn Vehicle Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..XCEL.getUserId(source).."**\n> Vehicle: **"..spawncode.."**")
end)


RegisterServerEvent("XCEL:viewRemoteDashcam")
AddEventHandler('XCEL:viewRemoteDashcam', function(spawncode)
    local source = source
    local user_id = XCEL.getUserId(source)
    MySQL.query("XCELls/get_vehicle_modifications", {user_id = user_id, vehicle = spawncode}, function(rows, affected) 
        if rows ~= nil then 
            if #rows > 0 then
                XCELclient.getOwnedVehiclePosition(source, {spawncode}, function(x,y,z)
                    if vector3(x,y,z) ~= vector3(0,0,0) then
                        local mods = json.decode(rows[1].modifications) or {}
                        if mods['dashcam'] == 1 then
                            if next(table.pack(x,y,z)) then
                                for k,v in pairs(netObjects) do
                                    if math.floor(vector3(x,y,z)) == math.floor(GetEntityCoords(NetworkGetEntityFromNetworkId(k))) then
                                        TriggerClientEvent('XCEL:viewRemoteDashcam', source, table.pack(x,y,z), k)
                                        return
                                    end
                                end
                            end
                        end
                        XCELclient.notify(source, {"~r~This vehicle does not have a remote dashcam installed."})
                    else
                        XCELclient.notify(source, {"~r~Can not locate vehicle with the plate "..rows[1].vehicle_plate.." in this city."})
                    end
                end)
            end
        end
    end)
end)

RegisterServerEvent("XCEL:updateFuel")
AddEventHandler('XCEL:updateFuel', function(vehicle, fuel_level)
    local source = source
    local user_id = XCEL.getUserId(source)
    exports["xcel"]:execute("UPDATE xcel_user_vehicles SET fuel_level = @fuel_level WHERE user_id = @user_id AND vehicle = @vehicle", {fuel_level = fuel_level, user_id = user_id, vehicle = vehicle}, function() end)
end)

RegisterServerEvent("XCEL:getCustomFolders")
AddEventHandler('XCEL:getCustomFolders', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    exports["xcel"]:execute("SELECT * from `xcel_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            TriggerClientEvent("XCEL:sendFolders", source, json.decode(Result[1].folder))
        end
    end)
end)


RegisterServerEvent("XCEL:updateFolders")
AddEventHandler('XCEL:updateFolders', function(FolderUpdated)
    local source = source
    local user_id = XCEL.getUserId(source)
    exports["xcel"]:execute("SELECT * from `xcel_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            exports['xcel']:execute("UPDATE xcel_custom_garages SET folder = @folder WHERE user_id = @user_id", {folder = json.encode(FolderUpdated), user_id = user_id}, function() end)
        else
            exports['xcel']:execute("INSERT INTO xcel_custom_garages (`user_id`, `folder`) VALUES (@user_id, @folder);", {user_id = user_id, folder = json.encode(FolderUpdated)}, function() end)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(60000)
        MySQL.query('XCEL/fetch_rented_vehs', {}, function(pvehicles)
            for i,v in pairs(pvehicles) do 
               if os.time() > tonumber(v.rentedtime) then
                  MySQL.execute('XCEL/rentedupdate', {id = v.rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = v.user_id, veh = v.vehicle})
                  if XCEL.getUserSource(v.rentedid) ~= nil then
                    XCELclient.notify(XCEL.getUserSource(v.rentedid), {"~r~Your rented vehicle has been returned."})
                  end
               end
            end
        end)
    end
end)

RegisterNetEvent('XCEL:FetchCars')
AddEventHandler('XCEL:FetchCars', function(type)
    local source = source
    local user_id = XCEL.getUserId(source)
    local returned_table = {}
    local fuellevels = {}
    if user_id then
        MySQL.query("XCEL/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
            for _, veh in pairs(pvehicles) do
                for i, v in pairs(vehicle_groups) do
                    local perms = false
                    local config = vehicle_groups[i]._config
                    if config.type == vehicle_groups[type]._config.type then 
                        local perm = config.permissions or nil
                        if next(perm) then
                            for i, v in pairs(perm) do
                                if XCEL.hasPermission(user_id, v) then
                                    perms = true
                                end
                            end
                        else
                            perms = true
                        end
                        if perms then 
                            for a, z in pairs(v) do
                                if a ~= "_config" and veh.vehicle == a then
                                    if not returned_table[i] then 
                                        returned_table[i] = {["_config"] = config}
                                    end
                                    if not returned_table[i].vehicles then 
                                        returned_table[i].vehicles = {}
                                    end
                                    returned_table[i].vehicles[a] = {z[1], z[2], veh.vehicle_plate, veh.fuel_level}
                                    fuellevels[a] = veh.fuel_level
                                end
                            end
                        end
                    end
                end
            end
            TriggerClientEvent('XCEL:ReturnFetchedCars', source, returned_table, fuellevels)
        end)
    end
end)

RegisterNetEvent('XCEL:CrushVehicle')
AddEventHandler('XCEL:CrushVehicle', function(vehicle)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id then 
        MySQL.query("XCEL/check_rented", {user_id = user_id, vehicle = vehicle}, function(pvehicles)
            MySQL.query("XCEL/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pveh)
                if #pveh < 0 then 
                    XCELclient.notify(source,{"~r~You cannot destroy a vehicle you do not own"})
                    return
                end
                if #pvehicles > 0 then 
                    XCELclient.notify(source,{"~r~You cannot destroy a rented vehicle!"})
                    return
                end
                MySQL.execute('XCEL/remove_vehicle', {user_id = user_id, vehicle = vehicle})
                XCEL.sendWebhook('crush-vehicle', "XCEL Crush Vehicle Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Vehicle: **"..vehicle.."**")
                TriggerClientEvent('XCEL:CloseGarage', source)
            end)
        end)
    end
end)
RegisterNetEvent('XCEL:SellVehicle')
AddEventHandler('XCEL:SellVehicle', function(veh)
    local name = veh
    local player = source
    local playerID = XCEL.getUserId(source)
    if playerID ~= nil then
        XCELclient.getNearestPlayers(player, {15}, function(nplayers)
            usrList = ""
            for k, v in pairs(nplayers) do
                usrList = usrList .. "[" .. XCEL.getUserId(k) .. "]" .. XCEL.GetPlayerName(XCEL.getUserId(k)) .. " | "
            end
            if usrList ~= "" then
                XCEL.prompt(player, "Players Nearby: " .. usrList .. "", "", function(player, user_id)
                    user_id = user_id
                    if user_id ~= nil and user_id ~= "" then
                        local target = XCEL.getUserSource(tonumber(user_id))
                        if target ~= nil then
                            XCEL.prompt(player, "Price £: ", "", function(player, amount)
                                if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
                                    MySQL.query("XCEL/get_vehicle", { user_id = user_id, vehicle = name }, function(pvehicle, affected)
                                        if #pvehicle > 0 then
                                            XCELclient.notify(player, {"~r~The player already has this vehicle type."})
                                        else
                                            local tmpdata = XCEL.getUserTmpTable(playerID)
                                            MySQL.query("XCEL/check_rented", { user_id = playerID, vehicle = veh }, function(pvehicles)
                                                if #pvehicles > 0 then
                                                    XCELclient.notify(player, {"~r~You cannot sell a rented vehicle!"})
                                                    return
                                                else
                                                    XCEL.prompt(player, "Please replace text with YES or NO to confirm", "Sell Details:\nVehicle: " .. name .. "\nPrice: £" .. getMoneyStringFormatted(amount) .. "\nSelling to player: " .. XCEL.GetPlayerName(XCEL.getUserId(target)) .. "(" .. XCEL.getUserId(target) .. ")", function(player, details)
                                                        if string.upper(details) == 'YES' then
                                                            XCELclient.notify(player, {'~g~Sell offer sent!'})
                                                            XCEL.request(target, XCEL.GetPlayerName(playerID) .. " wants to sell: " .. name .. " Price: £" .. getMoneyStringFormatted(amount), 10, function(target, ok)
                                                                if ok then
                                                                    local pID = XCEL.getUserId(target)
                                                                    amount = tonumber(amount)
                                                                    if XCEL.tryFullPayment(pID, amount) then
                                                                        XCELclient.despawnGarageVehicle(player, {'car', 15})
                                                                        XCEL.getUserIdentity(pID, function(identity)
                                                                            MySQL.execute("XCEL/sell_vehicle_player", { user_id = user_id, registration = "P " .. identity.registration, oldUser = playerID, vehicle = name })
                                                                        end)
                                                                        XCEL.giveBankMoney(playerID, amount)
                                                                        XCELclient.notify(player, {"~g~You have successfully sold the vehicle to " .. XCEL.GetPlayerName(pID) .. " for £" .. getMoneyStringFormatted(amount) .. "!"})
                                                                        XCELclient.notify(target, {"~g~" .. XCEL.GetPlayerName(playerID) .. " has successfully sold you the car for £" .. getMoneyStringFormatted(amount) .. "!"})
                                                                        XCEL.sendWebhook('sell-vehicle', "XCEL Sell Vehicle Logs", "> Seller Name: **" .. XCEL.GetPlayerName(playerID) .. "**\n> Seller TempID: **" .. player .. "**\n> Seller PermID: **" .. playerID .. "**\n> Buyer Name: **" .. XCEL.GetPlayerName(user_id) .. "**\n> Buyer TempID: **" .. target .. "**\n> Buyer PermID: **" .. user_id .. "**\n> Amount: **£" .. getMoneyStringFormatted(amount) .. "**\n> Vehicle: **" .. name .. "**")
                                                                        TriggerClientEvent('XCEL:CloseGarage', player)
                                                                    else
                                                                        XCELclient.notify(player, {"~r~" .. XCEL.GetPlayerName(pID) .. " doesn't have enough money!"})
                                                                        XCELclient.notify(target, {"~r~You don't have enough money!"})
                                                                    end
                                                                else
                                                                    XCELclient.notify(player, {"~r~" .. XCEL.GetPlayerName(pID) .. " has refused to buy the car."})
                                                                    XCELclient.notify(target, {"~r~You have refused to buy " .. XCEL.GetPlayerName(playerID) .. "'s car."})
                                                                end
                                                            end)
                                                        else
                                                            XCELclient.notify(player, {'~r~Sell offer cancelled!'})
                                                        end
                                                    end)
                                                end
                                            end)
                                        end
                                    end)
                                else
                                    XCELclient.notify(player, {"~r~The price of the car has to be a number."})
                                end
                            end)
                        else
                            XCELclient.notify(player, {"~r~That ID seems invalid."})
                        end
                    else
                        XCELclient.notify(player, {"~r~No player ID selected."})
                    end
                end)
            else
                XCELclient.notify(player, {"~r~No players nearby."})
            end
        end)
    end
end)



RegisterNetEvent('XCEL:RentVehicle')
AddEventHandler('XCEL:RentVehicle', function(veh)
    local name = veh
    local player = source 
    local playerID = XCEL.getUserId(source)
    if playerID ~= nil then
		XCELclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. XCEL.getUserId(k) .. "]" .. XCEL.GetPlayerName(XCEL.getUserId(k)) .. " | "
			end
			if usrList ~= "" then
				XCEL.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = XCEL.getUserSource(tonumber(user_id))
						if target ~= nil then
							XCEL.prompt(player,"Price £: ","",function(player,amount)
                                XCEL.prompt(player,"Rent time (in hours): ","",function(player,rent)
                                    if tonumber(rent) and tonumber(rent) >  0 then 
                                        if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
                                            MySQL.query("XCEL/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
                                                if #pvehicle > 0 then
                                                    XCELclient.notify(player,{"~r~The player already has this vehicle."})
                                                else
                                                    local tmpdata = XCEL.getUserTmpTable(playerID)
                                                    MySQL.query("XCEL/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                        if #pvehicles > 0 then 
                                                            return
                                                        else
                                                            XCEL.prompt(player, "Please replace text with YES or NO to confirm", "Rent Details:\nVehicle: "..name.."\nRent Cost: "..getMoneyStringFormatted(amount).."\nDuration: "..rent.." hours\nRenting to player: "..XCEL.GetPlayerName(XCEL.getUserId(target)).."("..XCEL.getUserId(target)..")",function(player,details)
                                                                if string.upper(details) == 'YES' then
                                                                    XCELclient.notify(player, {'~g~Rent offer sent!'})
                                                                    XCEL.request(target,XCEL.GetPlayerName(playerID).." wants to rent: " ..name.. " Price: £"..getMoneyStringFormatted(amount) .. ' | for: ' .. rent .. 'hours', 10, function(target,ok)
                                                                        local pID = XCEL.getUserId(target)
                                                                        if ok then
                                                                            amount = tonumber(amount)
                                                                            if XCEL.tryFullPayment(pID,amount) then
                                                                                XCELclient.despawnGarageVehicle(player,{'car',15}) 
                                                                                XCEL.getUserIdentity(pID, function(identity)
                                                                                    local rentedTime = os.time()
                                                                                    rentedTime = rentedTime  + (60 * 60 * tonumber(rent)) 
                                                                                    MySQL.execute("XCEL/rentedupdate", {user_id = playerID, veh = name, id = pID, rented = 1, rentedid = playerID, rentedunix =  rentedTime }) 
                                                                                end)
                                                                                XCEL.giveBankMoney(playerID, amount)
                                                                                XCELclient.notify(player,{"~g~You have successfully rented the vehicle to "..XCEL.GetPlayerName(pID).." for £"..getMoneyStringFormatted(amount)..' for ' ..rent.. 'hours'})
                                                                                XCELclient.notify(target,{"~g~"..XCEL.GetPlayerName(playerID).." has successfully rented you the car for £"..getMoneyStringFormatted(amount)..' for ' ..rent.. 'hours'})
                                                                                XCEL.sendWebhook('rent-vehicle', "XCEL Rent Vehicle Logs", "> Renter Name: **"..XCEL.GetPlayerName(playerID).."**\n> Renter TempID: **"..player.."**\n> Renter PermID: **"..playerID.."**\n> Rentee Name: **"..XCEL.GetPlayerName(pID).."**\n> Rentee TempID: **"..target.."**\n> Rentee PermID: **"..pID.."**\n> Amount: **£"..getMoneyStringFormatted(amount).."**\n> Duration: **"..rent.." hours**\n> Vehicle: **"..veh.."**")
                                                                                --TriggerClientEvent('XCEL:CloseGarage', player)
                                                                            else
                                                                                XCELclient.notify(player,{"~r~".. XCEL.GetPlayerName(pID).." doesn't have enough money!"})
                                                                                XCELclient.notify(target,{"~r~You don't have enough money!"})
                                                                            end
                                                                        else
                                                                            XCELclient.notify(player,{"~r~"..XCEL.GetPlayerName(pID).." has refused to rent the car."})
                                                                            XCELclient.notify(target,{"~r~You have refused to rent "..XCEL.GetPlayerName(playerID).."'s car."})
                                                                        end
                                                                    end)
                                                                else
                                                                    XCELclient.notify(player, {'~r~Rent offer cancelled!'})
                                                                end
                                                            end)
                                                        end
                                                    end)
                                                end
                                            end) 
                                        else
                                            XCELclient.notify(player,{"~r~The price of the car has to be a number."})
                                        end
                                    else 
                                        XCELclient.notify(player,{"~r~The rent time of the car has to be in hours and a number."})
                                    end
                                end)
							end)
						else
							XCELclient.notify(player,{"~r~That ID seems invalid."})
						end
					else
						XCELclient.notify(player,{"~r~No player ID selected."})
					end
				end)
			else
				XCELclient.notify(player,{"~r~No players nearby."})
			end
		end)
    end
end)



RegisterNetEvent('XCEL:FetchRented')
AddEventHandler('XCEL:FetchRented', function()
    local rentedin = {}
    local rentedout = {}
    local source = source
    local user_id = XCEL.getUserId(source)
    MySQL.query("XCEL/get_rented_vehicles_in", {user_id = user_id}, function(pvehicles, affected)
        for _, veh in pairs(pvehicles) do
            for i, v in pairs(vehicle_groups) do
                local config = vehicle_groups[i]._config
                local perm = config.permissions or nil
                if perm then
                    for i, v in pairs(perm) do
                        if not XCEL.hasPermission(user_id, v) then
                            break
                        end
                    end
                end
                for a, z in pairs(v) do
                    if a ~= "_config" and veh.vehicle == a then
                        if not rentedin.vehicles then 
                            rentedin.vehicles = {}
                        end
                        local hoursLeft = ((tonumber(veh.rentedtime)-os.time()))/3600
                        local minutesLeft = nil
                        if hoursLeft < 1 then
                            minutesLeft = hoursLeft * 60
                            minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
                            datetime = minutesLeft .. " mins" 
                        else
                            hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
                            datetime = hoursLeft .. " hours" 
                        end
                        rentedin.vehicles[a] = {z[1], datetime, veh.user_id, a}
                    end
                end
            end
        end
        MySQL.query("XCEL/get_rented_vehicles_out", {user_id = user_id}, function(pvehicles, affected)
            for _, veh in pairs(pvehicles) do
                for i, v in pairs(vehicle_groups) do
                    local config = vehicle_groups[i]._config
                    local perm = config.permissions or nil
                    if perm then
                        for i, v in pairs(perm) do
                            if not XCEL.hasPermission(user_id, v) then
                                break
                            end
                        end
                    end
                    for a, z in pairs(v) do
                        if a ~= "_config" and veh.vehicle == a then
                            if not rentedout.vehicles then 
                                rentedout.vehicles = {}
                            end
                            local hoursLeft = ((tonumber(veh.rentedtime)-os.time()))/3600
                            local minutesLeft = nil
                            if hoursLeft < 1 then
                                minutesLeft = hoursLeft * 60
                                minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
                                datetime = minutesLeft .. " mins" 
                            else
                                hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
                                datetime = hoursLeft .. " hours" 
                            end
                            rentedout.vehicles[a] = {z[1], datetime, veh.user_id, a}
                        end
                    end
                end
            end
            TriggerClientEvent('XCEL:ReturnedRentedCars', source, rentedin, rentedout)
        end)
    end)
end)

RegisterNetEvent('XCEL:CancelRent')
AddEventHandler('XCEL:CancelRent', function(spawncode, VehicleName, a)
    local source = source
    local user_id = XCEL.getUserId(source)
    if a == 'owner' then
        exports['xcel']:execute("SELECT * FROM xcel_user_vehicles WHERE rentedid = @id", {id = user_id}, function(result)
            if #result > 0 then 
                for i = 1, #result do 
                    if result[i].vehicle == spawncode and result[i].rented then
                        local target = XCEL.getUserSource(result[i].user_id)
                        if target ~= nil then
                            XCEL.request(target,XCEL.GetPlayerName(user_id).." would like to cancel the rent on the vehicle: ", 10, function(target,ok)
                                if ok then
                                    MySQL.execute('XCEL/rentedupdate', {id = user_id, rented = 0, rentedid = "", rentedunix = "", user_id = result[i].user_id, veh = spawncode})
                                    XCELclient.notify(target, {"~r~" ..VehicleName.." has been returned to the vehicle owner."})
                                    XCELclient.notify(source, {"~r~" ..VehicleName.." has been returned to your garage."})
                                else
                                    XCELclient.notify(source, {"~r~User has declined the request to cancel the rental of vehicle: " ..VehicleName})
                                end
                            end)
                        else
                            XCELclient.notify(source, {"~r~The player is not online."})
                        end
                    end
                end
            end
        end)
    elseif a == 'renter' then
        exports['xcel']:execute("SELECT * FROM xcel_user_vehicles WHERE user_id = @id", {id = user_id}, function(result)
            if #result > 0 then 
                for i = 1, #result do 
                    if result[i].vehicle == spawncode and result[i].rented then
                        local rentedid = tonumber(result[i].rentedid)
                        local target = XCEL.getUserSource(rentedid)
                        if target ~= nil then
                            XCEL.request(target,XCEL.GetPlayerName(user_id).." would like to cancel the rent on the vehicle: ", 10, function(target,ok)
                                if ok then
                                    MySQL.execute('XCEL/rentedupdate', {id = rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = user_id, veh = spawncode})
                                    XCELclient.notify(source, {"~r~" ..VehicleName.." has been returned to the vehicle owner."})
                                    XCELclient.notify(target, {"~r~" ..VehicleName.." has been returned to your garage."})
                                else
                                    XCELclient.notify(source, {"~r~User has declined the request to cancel the rental of vehicle: " ..VehicleName})
                                end
                            end)
                        else
                            XCELclient.notify(source, {"~r~The player is not online."})
                        end
                    end
                end
            end
        end)
    end
end)

-- repair nearest vehicle
local function ch_repair(player,choice)
  local user_id = XCEL.getUserId(player)
  if user_id ~= nil then
    -- anim and repair
    if XCEL.tryGetInventoryItem(user_id,"repairkit",1,true) then
      XCELclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
      SetTimeout(15000, function()
        XCELclient.fixeNearestVehicle(player,{7})
        XCELclient.stopAnim(player,{false})
      end)
    end
  end
end

RegisterNetEvent("XCEL:PayVehicleTax")
AddEventHandler("XCEL:PayVehicleTax", function()
    local user_id = XCEL.getUserId(source)
    if user_id ~= nil then
        local bank = XCEL.getBankMoney(user_id)
        local payment = bank / 10000
        if XCEL.tryBankPayment(user_id, payment) then
            XCELclient.notify(source,{"~g~Paid £"..getMoneyStringFormatted(math.floor(payment)).." vehicle tax."})
            XCEL.addToCommunityPot(math.floor(payment))
        else
            XCELclient.notify(source,{"~r~Its fine... Tax payers will pay your vehicle tax instead."})
        end
    end
end)

RegisterNetEvent("XCEL:refreshGaragePermissions")
AddEventHandler("XCEL:refreshGaragePermissions",function(src)
    local source=source
    if src then
        source = src
    end
    local garageTable={}
    local user_id = XCEL.getUserId(source)
    for k,v in pairs(cfg.garages) do
        for a,b in pairs(v) do
            if a == "_config" then
                if json.encode(b.permissions) ~= '[""]' then
                    local hasPermissions = 0
                    for c,d in pairs(b.permissions) do
                        if XCEL.hasPermission(user_id, d) then
                            hasPermissions = hasPermissions + 1
                        end
                    end
                    if hasPermissions == #b.permissions then
                        table.insert(garageTable, k)
                    end
                else
                    table.insert(garageTable, k)
                end
            end
        end
    end
    local ownedVehicles = {}
    if user_id then
        MySQL.query("XCEL/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
            for k,v in pairs(pvehicles) do
                table.insert(ownedVehicles, v.vehicle)
            end
            TriggerClientEvent('XCEL:updateOwnedVehicles', source, ownedVehicles)
        end)
    end
    TriggerClientEvent("XCEL:recieveRefreshedGaragePermissions",source,garageTable)
end)


RegisterNetEvent("XCEL:getGarageFolders")
AddEventHandler("XCEL:getGarageFolders",function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local garageFolders = {}
    local addedFolders = {}
    MySQL.query("XCEL/get_vehicles", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                local spawncode = v.vehicle 
                for a,b in pairs(vehicle_groups) do
                    local hasPerm = true
                    if next(b._config.permissions) then
                        if not XCEL.hasPermission(user_id, b._config.permissions[1]) then
                            hasPerm = false
                        end
                    end
                    if hasPerm then
                        for c,d in pairs(b) do
                            if c == spawncode and not v.impounded then
                                if not addedFolders[a] then
                                    table.insert(garageFolders, {display = a})
                                    addedFolders[a] = true
                                end
                                for e,f in pairs (garageFolders) do
                                    if f.display == a then
                                        if f.vehicles == nil then
                                            f.vehicles = {}
                                        end
                                        table.insert(f.vehicles, {display = d[1], spawncode = spawncode})
                                    end
                                end
                            end
                        end
                    end
                end
            end
            TriggerClientEvent('XCEL:setVehicleFolders', source, garageFolders)
        end
    end)
end)

local cfg_weapons = module("cfg/weapons")

RegisterServerEvent("XCEL:searchVehicle")
AddEventHandler('XCEL:searchVehicle', function(entity, permid)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') then
        if XCEL.getUserSource(permid) ~= nil then
            XCELclient.getNetworkedVehicleInfos(XCEL.getUserSource(permid), {entity}, function(owner, spawncode)
                if spawncode and owner == permid then
                    local vehformat = 'chest:u1veh_'..spawncode..'|'..permid
                    XCEL.getSData(vehformat, function(cdata)
                        if cdata ~= nil then
                            cdata = json.decode(cdata) or {}
                            if next(cdata) then
                                for a,b in pairs(cdata) do
                                    if string.find(a, 'wbody|') then
                                        c = a:gsub('wbody|', '')
                                        cdata[c] = b
                                        cdata[a] = nil
                                    end
                                end
                                for k,v in pairs(cfg_weapons.weapons) do
                                    if cdata[k] ~= nil then
                                        if not v.policeWeapon then
                                            XCELclient.notify(source, {'~r~Seized '..v.name..' x'..cdata[k].amount..'.'})
                                            cdata[k] = nil
                                        end
                                    end
                                end
                                for c,d in pairs(cdata) do
                                    if seizeBullets[c] then
                                        XCELclient.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                        cdata[c] = nil
                                    end
                                    if seizeDrugs[c] then
                                        XCELclient.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                        cdata[c] = nil
                                    end
                                end
                                XCEL.setSData(vehformat, json.encode(cdata))
                                XCEL.sendWebhook('seize-boot', 'XCEL Seize Boot Logs', "> Officer Name: **"..XCEL.GetPlayerName(user_id).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Vehicle: **"..spawncode.."**\n> Owner ID: **"..permid.."**")
                            else
                                XCELclient.notify(source, {'~r~This vehicle is empty.'})
                            end
                        else
                            XCELclient.notify(source, {'~r~This vehicle is empty.'})
                        end
                    end)
                end
            end)
        end
    end
end)


Citizen.CreateThread(function()
    Wait(1500)
    exports['xcel']:execute([[
        CREATE TABLE IF NOT EXISTS `xcel_custom_garages` (
            `user_id` INT(11) NOT NULL AUTO_INCREMENT,
            `folder` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            PRIMARY KEY (`user_id`) USING BTREE
        );
    ]])
end)
