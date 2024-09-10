local cfg = module("cfg/survival")
local lang = XCEL.lang


-- handlers

-- init values
AddEventHandler("XCEL:playerJoin", function(user_id, source, name, last_login)
    local data = XCEL.getUserDataTable(user_id)
end)


---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = XCEL.getUserId(player)
    if user_id ~= nil then
        XCELclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = XCEL.getUserId(nplayer)
            if nuser_id ~= nil then
                XCELclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if XCEL.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            XCELclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                XCELclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        XCELclient.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                XCELclient.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}

RegisterNetEvent('XCEL:SearchForPlayer')
AddEventHandler('XCEL:SearchForPlayer', function()
    TriggerClientEvent('XCEL:ReceiveSearch', -1, source)
end)


