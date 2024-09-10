local outfitCodes = {}

RegisterNetEvent("XCEL:saveWardrobeOutfit")
AddEventHandler("XCEL:saveWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.getUData(user_id, "XCEL:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        XCELclient.getCustomization(source,{},function(custom)
            sets[outfitName] = custom
            XCEL.setUData(user_id,"XCEL:home:wardrobe",json.encode(sets))
            XCELclient.notify(source,{"~g~Saved outfit "..outfitName.." to wardrobe!"})
            TriggerClientEvent("XCEL:refreshOutfitMenu", source, sets)
        end)
    end)
end)

RegisterNetEvent("XCEL:deleteWardrobeOutfit")
AddEventHandler("XCEL:deleteWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.getUData(user_id, "XCEL:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        sets[outfitName] = nil
        XCEL.setUData(user_id,"XCEL:home:wardrobe",json.encode(sets))
        XCELclient.notify(source,{"~r~Remove outfit "..outfitName.." from wardrobe!"})
        TriggerClientEvent("XCEL:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("XCEL:equipWardrobeOutfit")
AddEventHandler("XCEL:equipWardrobeOutfit", function(outfitName)
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.getUData(user_id, "XCEL:home:wardrobe", function(data)
        local sets = json.decode(data)
        XCELclient.setCustomization(source, {sets[outfitName]})
        XCELclient.getHairAndTats(source, {})
    end)
end)

RegisterNetEvent("XCEL:initWardrobe")
AddEventHandler("XCEL:initWardrobe", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.getUData(user_id, "XCEL:home:wardrobe", function(data)
        local sets = json.decode(data)
        if sets == nil then
            sets = {}
        end
        TriggerClientEvent("XCEL:refreshOutfitMenu", source, sets)
    end)
end)

RegisterNetEvent("XCEL:getCurrentOutfitCode")
AddEventHandler("XCEL:getCurrentOutfitCode", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    XCELclient.getCustomization(source,{},function(custom)
        XCELclient.generateUUID(source, {"outfitcode", 5, "alphanumeric"}, function(uuid)
            local uuid = string.upper(uuid)
            outfitCodes[uuid] = custom
            XCELclient.CopyToClipBoard(source, {uuid})
            XCELclient.notify(source, {"~g~Outfit code copied to clipboard."})
            XCELclient.notify(source, {"~g~The code ~y~"..uuid.."~w~ will persist until restart."})
        end)
    end)
end)

RegisterNetEvent("XCEL:applyOutfitCode")
AddEventHandler("XCEL:applyOutfitCode", function(outfitCode)
    local source = source
    local user_id = XCEL.getUserId(source)
    if outfitCodes[outfitCode] ~= nil then
        XCELclient.setCustomization(source, {outfitCodes[outfitCode]})
        XCELclient.notify(source, {"~g~Outfit code applied."})
        XCELclient.getHairAndTats(source, {})
    else
        XCELclient.notify(source, {"~r~Outfit code not found."})
    end
end)

RegisterCommand('wardrobe', function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasGroup(user_id, 'Founder') or XCEL.hasGroup(user_id, 'Developer') or XCEL.hasGroup(user_id, 'Lead Developer') or XCEL.hasGroup(user_id, 'Staff Manager') or XCEL.hasGroup(user_id, 'Community Manager') then
        TriggerClientEvent("XCEL:openOutfitMenu", source)
    end
end)

RegisterCommand('copyfit', function(source, args)
    local source = source
    local user_id = XCEL.getUserId(source)
    local permid = tonumber(args[1])
    if XCEL.hasGroup(user_id, 'Founder') or XCEL.hasGroup(user_id, 'Developer') or XCEL.hasGroup(user_id, 'Lead Developer') or XCEL.hasGroup(user_id, 'Staff Manager') or XCEL.hasGroup(user_id, 'Community Manager') then
        XCELclient.getCustomization(XCEL.getUserSource(permid),{},function(custom)
            XCELclient.setCustomization(source, {custom})
        end)
    end
end)