-- Table to track DJ sessions
local c = {}

-- Command: Toggle DJ Menu
RegisterCommand("djmenu", function(source, args, rawCommand)
    local user_id = XCEL.getUserId(source)
    if XCEL.hasGroup(user_id, "DJ") then
        TriggerClientEvent('XCEL:toggleDjMenu', source)
    end
end)

-- Command: Toggle DJ Admin Menu
RegisterCommand("djadmin", function(source, args, rawCommand)
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, "admin.noclip") then
        TriggerClientEvent('XCEL:toggleDjAdminMenu', source, c)
    end
end)

-- Command: Play a song
RegisterCommand("play", function(source, args, rawCommand)
    local user_id = XCEL.getUserId(source)
    if XCEL.hasGroup(user_id, "DJ") and XCEL.GetPlayTime(user_id) >= 50 and #args > 0 then
        TriggerClientEvent('XCEL:finaliseSong', source, args[1])
    elseif XCEL.GetPlayTime(user_id) <= 49 then
        XCELclient.notify(user_id,{"~r~You do not meet the hour requirements to use the DJ Licence"})
    end
end)

-- Server Event: Admin Stop Song
RegisterServerEvent("XCEL:adminStopSong")
AddEventHandler("XCEL:adminStopSong", function(param)
    if c[param] then
        TriggerClientEvent('XCEL:stopSong', -1, c[param][2])
        c[param] = nil
        TriggerClientEvent('XCEL:toggleDjAdminMenu', source, c)
    end
end)

-- Server Event: Play DJ Song
RegisterServerEvent("XCEL:playDjSongServer")
AddEventHandler("XCEL:playDjSongServer", function(param, coords)
    local user_id = XCEL.getUserId(source)
    local name = XCEL.GetPlayerName(user_id)
    c[tostring(source)] = {param, coords, user_id, name, "true"}
    TriggerClientEvent('XCEL:playDjSong', -1, param, coords, user_id, name)
end)

-- Server Event: Skip Song
RegisterServerEvent("XCEL:skipServer")
AddEventHandler("XCEL:skipServer", function(coords, param)
    TriggerClientEvent('XCEL:skipDj', -1, coords, param)
end)

-- Server Event: Stop Song
RegisterServerEvent("XCEL:stopSongServer")
AddEventHandler("XCEL:stopSongServer", function(coords)
    c[tostring(source)] = nil
    TriggerClientEvent('XCEL:stopSong', -1, coords)
end)

-- Server Event: Update Volume
RegisterServerEvent("XCEL:updateVolumeServer")
AddEventHandler("XCEL:updateVolumeServer", function(coords, volume)
    TriggerClientEvent('XCEL:updateDjVolume', -1, coords, volume)
end)

-- Server Event: Request Current Progress
RegisterServerEvent("XCEL:requestCurrentProgressServer")
AddEventHandler("XCEL:requestCurrentProgressServer", function(a, b)
    TriggerClientEvent('XCEL:requestCurrentProgress', -1, a, b)
end)

-- Server Event: Return Progress
RegisterServerEvent("XCEL:returnProgressServer")
AddEventHandler("XCEL:returnProgressServer", function(x, y, z)
    for k, v in pairs(c) do
        if tonumber(k) == XCEL.getUserSource(x) then
            TriggerClientEvent('XCEL:returnProgress', -1, x, y, z, v[1])
        end
    end
end)
