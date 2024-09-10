local a = false
SetNuiFocus(false, false)
function func_playerlistControl()
    if IsUsingKeyboard(2) then
        if IsControlJustPressed(0, 212) then
            a = not a
            TriggerServerEvent("XCEL:getPlayerListData")
            Wait(100)
            sendFullPlayerListData()
            SetNuiFocus(true, true)
            SendNUIMessage({showPlayerList = true})
        end
    end
end
tXCEL.createThreadOnTick(func_playerlistControl)
RegisterNUICallback(
    "closeXCELPlayerList",
    function(b, c)
        SetNuiFocus(false, false)
    end
)
AddEventHandler(
    "XCEL:onClientSpawn",
    function(d, e)
        if e then
            TriggerServerEvent("XCEL:getPlayerListData")
        end
    end
)
RegisterNetEvent(
    "XCEL:gotFullPlayerListData",
    function(f, g, h, i, j, k)
        sortedPlayersStaff = f
        sortedPlayersPolice = g
        sortedPlayersNHS = h
        sortedPlayersLFB = i
        sortedPlayersHMP = j
        sortedPlayersCivillians = k
    end
)
local l, m, n
RegisterNetEvent(
    "XCEL:playerListMetaUpdate",
    function(o)
        l, m, n = table.unpack(o)
        SendNUIMessage({wipeFooterPlayerList = true})
        SendNUIMessage({appendToFooterPlayerList = '<span class="foot">Server #1 | </span>'})
        SendNUIMessage(
            {
                appendToFooterPlayerList = '<span class="foot" style="color: rgb(0, 255, 20);">Server uptime ' ..
                    tostring(l) .. "</span>"
            }
        )
        SendNUIMessage(
            {
                appendToFooterPlayerList = '<span class="foot">  |  Number of players ' ..
                    tostring(m) .. "/" .. tostring(n) .. "</span>"
            }
        )
    end
)
function getLength(p)
    local q = 0
    for r in pairs(p) do
        q = q + 1
    end
    return q
end

function sendFullPlayerListData()
    local s = getLength(sortedPlayersStaff)
    local t = getLength(sortedPlayersPolice)
    local u = getLength(sortedPlayersNHS)
    local v = getLength(sortedPlayersLFB)
    local w = getLength(sortedPlayersHMP)
    local x = getLength(sortedPlayersCivillians)
    SendNUIMessage({wipePlayerList = true})
    SendNUIMessage({clearServerMetaData = true})
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/xcel.png" align="top" width="20px",height="20px"><span class="staff">' ..
                tostring(s) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/nhs.png" align="top" width="20",height="20"><span class="nhs">' ..
                tostring(u) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/lfb.png" align="top" width="20",height="20"><span class="lfb">' ..
                tostring(v) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/met.png" align="top"  width="24",height="24"><span class="police">' ..
                tostring(t) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/hmp.png" align="top"  width="24",height="24"><span class="hmp">' ..
                tostring(w) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/danny.png" align="top" width="20",height="20"><span class="aa">' ..
                tostring(x) .. "</span>"
        }
    )
    SendNUIMessage({wipeFooterPlayerList = true})
    SendNUIMessage({appendToFooterPlayerList = '<span class="foot">Server #1 | </span>'})
    SendNUIMessage(
        {
            appendToFooterPlayerList = '<span class="foot" style="color: rgb(0, 255, 20);">Server uptime ' ..
                tostring(l) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            appendToFooterPlayerList = '<span class="foot">  |  Number of players ' ..
                tostring(m) .. "/" .. tostring(n) .. "</span>"
        }
    )
    if s >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_staff">Staff</span>'})
    end
    for y, z in pairs(sortedPlayersStaff) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersStaff[y].name) ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersStaff[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersStaff[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if t >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_police">MET Police</span>'})
    end
    for y, z in pairs(sortedPlayersPolice) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersPolice[y].name) ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersPolice[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersPolice[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if u >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_nhs">NHS</span>'})
    end
    for y, z in pairs(sortedPlayersNHS) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersNHS[y].name) ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersNHS[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersNHS[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if v >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_lfb">LFB</span>'})
    end
    for y, z in pairs(sortedPlayersLFB) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersLFB[y].name) ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersLFB[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersLFB[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if w >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_hmp">HMP</span>'})
    end
    for y, z in pairs(sortedPlayersHMP) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersHMP[y].name) ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersHMP[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersHMP[y].hours) .. "hrs</span><br/>"
            }
        )
    end
    if x >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_civs">Civilians</span>'})
    end
    for y, z in pairs(sortedPlayersCivillians) do
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(sortedPlayersCivillians[y].name) ..
                        '</span><span class="job">' ..
                            tostring(sortedPlayersCivillians[y].rank) ..
                                '</span><span class="playtime">' ..
                                    tostring(sortedPlayersCivillians[y].hours) .. "hrs</span><br/>"
            }
        )
    end
end
function tXCEL.getEmploymentStatus(permid)
    local departments = {sortedPlayersPolice, sortedPlayersNHS, sortedPlayersHMP, sortedPlayersStaff, sortedPlayersCivillians}
    for _, department in ipairs(departments) do
        if department[permid] then
            return department[permid].rank
        end
    end
    return "Unemployed"
end
function tXCEL.getHours()
    local playerId = tXCEL.getUserId()
    local departments = {sortedPlayersPolice, sortedPlayersNHS, sortedPlayersHMP, sortedPlayersCivillians}
    for _, department in ipairs(departments) do
        if department[playerId] then
            return department[playerId].hours
        end
    end
end
function tXCEL.getPlayers()
    return string.format("%s/%s", m, n)
end

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        if l and m and n then
            local userId, playerName, hours = tXCEL.getUserId(), tXCEL.GetPlayerName(PlayerId()), tXCEL.getHours()
            SetDiscordAppId(1264629541650038886)
            SetDiscordRichPresenceAsset('xcel')
            SetDiscordRichPresenceAssetText('discord.gg/xcel5m')
            SetDiscordRichPresenceAssetSmallText(playerName)
            SetDiscordRichPresenceAction(1, "Join XCEL", "https://discord.gg/xcel5m")
            SetRichPresence("[ID:" .. tostring(userId) .. "] | " .. tostring(m) .. "/" .. tostring(n) .. "\n" .. playerName .. " | " .. tostring(hours) .. " hours | " .. tXCEL.getEmploymentStatus(userId))
        else
            print("^1[XCEL] ^7Rich presence not set, missing data")
        end
        Wait(15000)
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        tXCEL.notify("~r~[XCEL] \nThe server has stopped")
    else
        tXCEL.notify("~r~[" .. resourceName .. "] \nThe resource has stopped")
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        tXCEL.notify("~g~[XCEL] \nThe server has started")
    else
        tXCEL.notify("~g~[" .. resourceName .. "] \nThe resource has started")
    end
end)