RegisterCommand('cinematicmenu', function(source)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasGroup(user_id, 'Cinematic') then
        TriggerClientEvent('XCEL:openCinematicMenu', source)
    end
end)