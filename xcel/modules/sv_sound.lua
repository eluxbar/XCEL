local soundCode = math.random(143, 1000000)

RegisterServerEvent('XCEL:soundCodeServer', function()
    TriggerClientEvent('XCEL:soundCode', source, soundCode)
end)
RegisterServerEvent("XCEL:playNuiSound", function(sound, distance, soundEventCode)
    local source = source
    local user_id = XCEL.getUserId(source)
    if soundCode == soundEventCode then
        local coords = GetEntityCoords(GetPlayerPed(source))
        TriggerClientEvent("XCEL:playClientNuiSound", -1, coords, sound, distance)
    else
        TriggerClientEvent("XCEL:playClientNuiSound", source, coords, sound, distance)
        Wait(2500)
        XCEL.ACBan(15,user_id,'XCEL:playNuiSound')
    end
end)