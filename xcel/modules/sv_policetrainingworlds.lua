local trainingWorlds = {}
local trainingWorldsCount = 0
RegisterCommand('trainingworlds', function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('XCEL:trainingWorldSendAll', source, trainingWorlds)
        TriggerClientEvent('XCEL:trainingWorldOpen', source, XCEL.hasPermission(user_id, 'police.announce'))
    end
end)

RegisterNetEvent("XCEL:trainingWorldCreate")
AddEventHandler("XCEL:trainingWorldCreate", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    trainingWorldsCount = trainingWorldsCount + 1
    XCEL.prompt(source,"World Name:","",function(player,worldname) 
        if string.gsub(worldname, "%s+", "") ~= '' then
            if next(trainingWorlds) then
                for k,v in pairs(trainingWorlds) do
                    if v.name == worldname then
                        XCELclient.notify(source, {"~r~This world name already exists."})
                        return
                    elseif v.ownerUserId == user_id then
                        XCELclient.notify(source, {"~r~You already have a world, please delete it first."})
                        return
                    end
                end
            end
            XCEL.prompt(source,"World Password:","",function(player,password) 
                trainingWorlds[trainingWorldsCount] = {name = worldname, ownerName = XCEL.GetPlayerName(user_id), ownerUserId = user_id, bucket = trainingWorldsCount, members = {}, password = password}
                table.insert(trainingWorlds[trainingWorldsCount].members, user_id)
                XCEL.setBucket(source, trainingWorldsCount)
                TriggerClientEvent('XCEL:trainingWorldSend', -1, trainingWorldsCount, trainingWorlds[trainingWorldsCount])
                XCELclient.notify(source, {'~g~Training World Created!'})
            end)
        else
            XCELclient.notify(source, {"~r~Invalid World Name."})
        end
    end)
end)

RegisterNetEvent("XCEL:trainingWorldRemove")
AddEventHandler("XCEL:trainingWorldRemove", function(world)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.announce') then
        if trainingWorlds[world] ~= nil then
            TriggerClientEvent('XCEL:trainingWorldRemove', -1, world)
            for k,v in pairs(trainingWorlds[world].members) do
                local memberSource = XCEL.getUserSource(v)
                if memberSource ~= nil then
                    XCEL.setBucket(memberSource, 0)
                    XCELclient.notify(memberSource, {"~w~The training world you were in was deleted, you have been returned to the main dimension."})
                end
            end
            trainingWorlds[world] = nil
        end
    end
end)

RegisterNetEvent("XCEL:trainingWorldJoin")
AddEventHandler("XCEL:trainingWorldJoin", function(world)
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.prompt(source,"Enter Password:","",function(player,password) 
        if password ~= trainingWorlds[world].password then
            XCELclient.notify(source, {"~r~Invalid Password."})
            return
        else
            XCEL.setBucket(source, world)
            table.insert(trainingWorlds[world].members, user_id)
            XCELclient.notify(source, {"~w~You have joined training world "..trainingWorlds[world].name..' owned by '..trainingWorlds[world].ownerName..'.'})
        end
    end)
end)

RegisterNetEvent("XCEL:trainingWorldLeave")
AddEventHandler("XCEL:trainingWorldLeave", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    XCEL.setBucket(source, 0)
    XCELclient.notify(source, {"~w~You have left the training world."})
end)

