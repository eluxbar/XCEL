RegisterNetEvent("XCEL:saveFaceData")
AddEventHandler("XCEL:saveFaceData", function(faceSaveData)
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.setUData(user_id,"XCEL:Face:Data",json.encode(faceSaveData))
end)

RegisterNetEvent("XCEL:saveClothingHairData") -- this updates hair from clothing stores
AddEventHandler("XCEL:saveClothingHairData", function(hairtype, haircolour)
    local source = source
    local user_id = XCEL.getUserId(source)
    local facesavedata = {}
    XCEL.getUData(user_id, "XCEL:Face:Data", function(data)
        if data ~= nil and data ~= 0 and hairtype ~= nil and haircolour ~= nil then
            facesavedata = json.decode(data)
            if facesavedata == nil then
                facesavedata = {}
            end
            facesavedata["hair"] = hairtype
            facesavedata["haircolor"] = haircolour
            XCEL.setUData(user_id,"XCEL:Face:Data",json.encode(facesavedata))
        end
    end)
end)

RegisterNetEvent("XCEL:getPlayerHairstyle")
AddEventHandler("XCEL:getPlayerHairstyle", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.getUData(user_id,"XCEL:Face:Data", function(data)
        if data ~= nil and data ~= 0 then
            TriggerClientEvent("XCEL:setHairstyle", source, json.decode(data))
        end
    end)
end)

AddEventHandler("XCEL:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = XCEL.getUserId(source)
        XCEL.getUData(user_id,"XCEL:Face:Data", function(data)
            if data ~= nil and data ~= 0 then
                TriggerClientEvent("XCEL:setHairstyle", source, json.decode(data))
            end
        end)
    end)
end)