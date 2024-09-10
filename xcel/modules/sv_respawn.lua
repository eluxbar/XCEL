local cfg=module("cfg/cfg_respawn")

RegisterNetEvent("XCEL:SendSpawnMenu")
AddEventHandler("XCEL:SendSpawnMenu",function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local spawnTable={}
    for k,v in pairs(cfg.spawnLocations)do
        if v.permission[1] ~= nil then
            if XCEL.hasPermission(XCEL.getUserId(source),v.permission[1])then
                table.insert(spawnTable, k)
            end
        else
            table.insert(spawnTable, k)
        end
    end
    exports['xcel']:execute("SELECT * FROM `xcel_user_homes` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for a,b in pairs(result) do
                table.insert(spawnTable, b.home)
            end
            if XCEL.isPurge() then
                TriggerClientEvent("XCEL:purgeSpawnClient",source)
            else
                TriggerClientEvent("XCEL:OpenSpawnMenu",source,spawnTable)
                XCEL.clearInventory(user_id) 
                XCELclient.setPlayerCombatTimer(source, {0})
            end
        end
    end)
end)