local inArena = {}
local dailyArena = {}
local spawnCoords = {
    vector3(-980.00256347656,-789.48596191406,18.221858978271),
    vector3(-949.04217529297,-734.2568359375,19.921379089355),
    vector3(-932.78930664062,-781.48937988281,15.921143531799),
    vector3(-941.1708984375,-791.75329589844,15.951022148132),
    vector3(-948.84149169922,-801.56921386719,15.921129226685),
    vector3(-897.02221679688,-779.42608642578,15.910862922668),
    vector3(-900.32934570312,-809.1005859375,16.184114456177),
    vector3(-958.83538818359,-779.66473388672,17.836130142212),
}

RegisterCommand("fragarena", function(source, args, rawCommand)
    local source = source
    local user_id = XCEL.getUserId(source)
    if not dailyArena[source] then
        dailyArena[source] = true
        inArena[source] = {timeInside = 1800,savedCoords = GetEntityCoords(GetPlayerPed(source))}
        SetPlayerRoutingBucket(source, 200)
        RemoveAllPedWeapons(source, false)
        XCELclient.teleport(source, {table.unpack(spawnCoords[math.random(#spawnCoords)])})
        XCELclient.giveWeapons(source, {{["WEAPON_MOSIN"] = {ammo = 250}}})
        XCELclient.setArmour(source, {100})
        TriggerClientEvent("Kerr:Arena:GotCounter", source, 1800)
        XCELclient.notify(source, {'~b~You have entered the XCEL Frag Arena.'})
    else
        XCELclient.notify(source, {'~r~You have used all your daily fragging time.'})
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k, v in pairs(inArena) do
            if inArena[k] then
                if v.timeInside > 0 then
                    v.timeInside = v.timeInside - 1
                end
                if v.timeInside <= 0 then
                    inArena[k] = nil
                    RemoveAllPedWeapons(k, false)
                    SetPlayerRoutingBucket(k, 0)
                    XCELclient.notify(k, {'~r~Time up, you may not join back today.'})
                    XCELclient.teleport(k, {vector3(1902.343, 3725.246, 32.73862)})
                end
            end
        end
    end
end)

function XCEL.ManageArenaDeath(killedsource,killersource)
    local killer_id = XCEL.getUserId(killersource)
    local killed_id = XCEL.getUserId(killedsource)
    local killername = XCEL.GetPlayerName(killer_id)
    local killedname = XCEL.GetPlayerName(killed_id)
    local reward = math.random(35000,100000)
    if killersource ~= nil then
        XCEL.giveBankMoney(killer_id, reward)
        XCELclient.RevivePlayer(killedsource, {})
        XCELclient.setHealth(killersource, {200})
        XCELclient.setArmour(killersource, {100, true})
        XCELclient.teleport(killedsource, {table.unpack(spawnCoords[math.random(#spawnCoords)])})
        XCELclient.notify(killedsource, {'Eliminated by ~r~'..killername})
        XCELclient.notify(killersource, {'Received ~r~£'..reward..'~w~ for eliminating ~r~'..killedplayername})
        XCELclient.giveWeapons(killedsource, {{["WEAPON_MOSIN"] = {ammo = 250}}})
    end
end

RegisterCommand("leavearena", function(source, args, RawCommand)
    local source = source
    local user_id = XCEL.getUserId(source)
    if inArena[source] then
        XCELclient.teleport(source, {table.unpack(inArena[source].savedCoords)})
        inArena[source] = nil
        RemoveAllPedWeapons(source, false)
        SetPlayerRoutingBucket(source, 0)
        TriggerClientEvent("Kerr:Arena:GotCounter", source, 0)
        XCELclient.notify(source, {'~r~Since you left the XCEL Frag Arena, you may not join back today.'})
    end
end)

function XCEL.inArena(source)
    if inArena[source] then
        return true
    end
    return false
end

