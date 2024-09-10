local a = 0
local b = 0
local c = 0
local d = 3
proximityIdToString = {[1] = "Whisper", [2] = "Talking", [3] = "Shouting"}
local e, f = GetActiveScreenResolution()
local g = {}
RegisterNetEvent("XCEL:showHUD")
AddEventHandler(
    "XCEL:showHUD",
    function(i)
        showhudUI(i)
    end
)
AddEventHandler(
    "pma-voice:setTalkingMode",
    function(j)
        d = j
        local k = tXCEL.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, k.rightX * k.resX)
    end
)
function updateMoneyUI(l, m, n, o, k, p)
    SendNUIMessage(
        {
            updateMoney = true,
            cash = l,
            bank = m,
            redmoney = n,
            proximity = proximityIdToString[o],
            topLeftAnchor = k,
            yAnchor = p,
            hours = tXCEL.getHours()
        }
    )
end
function showhudUI(i)
    SendNUIMessage({showMoney = i})
end
RegisterNetEvent("XCEL:setDisplayMoney")
RegisterNetEvent(
    "XCEL:setDisplayMoney",
    function(r)
        local s = tostring(math.floor(r))
        a = getMoneyStringFormatted(s)
        local k = tXCEL.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, k.rightX * k.resX)
    end
)
RegisterNetEvent("XCEL:setDisplayBankMoney")
AddEventHandler(
    "XCEL:setDisplayBankMoney",
    function(r)
        local s = tostring(math.floor(r))
        b = getMoneyStringFormatted(s)
        local k = tXCEL.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, k.rightX * k.resX)
    end
)
RegisterNetEvent("XCEL:setDisplayRedMoney")
AddEventHandler(
    "XCEL:setDisplayRedMoney",
    function(r)
        local s = tostring(math.floor(r))
        c = getMoneyStringFormatted(s)
        local k = tXCEL.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, k.rightX * k.resX)
    end
)
RegisterNetEvent("XCEL:initMoney")
AddEventHandler(
    "XCEL:initMoney",
    function(l, m)
        local t = tostring(math.floor(l))
        a = getMoneyStringFormatted(t)
        local s = tostring(math.floor(m))
        b = getMoneyStringFormatted(s)
        local k = tXCEL.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, k.rightX * k.resX)
    end
)
Citizen.CreateThread(
    function()
        Wait(4000)
        while tXCEL.getUserId() == nil do
            Wait(100)
        end
        TriggerServerEvent("XCEL:requestPlayerBankBalance")
        TriggerServerEvent("XCEL:SetDiscordName")
        local u = false
        while true do
            local v, w = GetActiveScreenResolution()
            if v ~= e or w ~= f then
                e, f = GetActiveScreenResolution()
                cachedMinimapAnchor = GetMinimapAnchor()
                updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, cachedMinimapAnchor.rightX * cachedMinimapAnchor.resX)
            end
            if NetworkIsPlayerTalking(PlayerId()) then
                if not u then
                    u = true
                    SendNUIMessage({moneyTalking = true})
                end
            else
                if u then
                    u = false
                    SendNUIMessage({moneyTalking = false})
                end
            end
            Wait(0)
        end
    end
)
RegisterNUICallback(
    "moneyUILoaded",
    function(data, cb)
        local k = tXCEL.getCachedMinimapAnchor()
        updateMoneyUI("£" .. tostring(a), "£" .. tostring(b), "£" .. tostring(c), d, k.rightX * k.resX)
    end
)
local avatars = {}

RegisterNetEvent('XCEL:addProfilePictures', function(id,avatar)
    avatars[id] = avatar
end)

RegisterNetEvent("XCEL:gotProfilePicture", function(pfp)
    SendNUIMessage({setPFP = pfp or "https://imgur.com/a/yhYboLR"})
end)

RegisterNetEvent('XCEL:setProfilePictures', function(tbl)
    avatars = tbl
end)

function XCEL.getAvatar(src)
    if avatars[src] then
        return avatars[src]
    else
        return "https://imgur.com/a/yhYboLR"
    end
end
