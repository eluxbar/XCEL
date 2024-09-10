RegisterNetEvent("XCEL:syncEntityDamage")
AddEventHandler("XCEL:syncEntityDamage", function(u, v, t, s, m, n) -- s head
    local source = source
    local playerId = XCEL.getUserId(source)
    local killerId = XCEL.getUserId(t)
    if killerId then
        TriggerClientEvent('XCEL:onEntityHealthChange', t, GetPlayerPed(source), u, v, s)
        XCELclient.isPlayerInRedZone(source, {}, function(victimInRedzone)
            XCELclient.isPlayerInRedZone(t, {}, function(shooterInRedzone)
                if victimInRedzone and not shooterInRedzone then
                    TriggerClientEvent('XCEL:chatFilterScaleform', t, 1, 'Do not shoot at players from outside a redzone!')
                elseif shooterInRedzone and not victimInRedzone then
                    TriggerClientEvent('XCEL:chatFilterScaleform', t, 1, 'Do not shoot at players from inside a redzone!')
                end
            end)
        end)
    end
end)