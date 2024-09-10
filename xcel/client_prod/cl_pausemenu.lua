isPauseMenuOpen = false
local u = false
local d = "0/128"

local function togglePauseMenu()
    if not IsPauseMenuActive() then
        if isPauseMenuOpen then
            XCEL.HidePauseMenu()
        elseif not tXCEL.isInComa() then
            TriggerServerEvent('XCEL:getPlayerListData')
            XCEL.ShowPauseMenu()
        end
    end
end

RegisterCommand('pauseMenu', togglePauseMenu)
RegisterCommand('pauseMenuController', togglePauseMenu)
RegisterKeyMapping("pauseMenu", "", "keyboard", "ESCAPE")
RegisterKeyMapping("pauseMenuController", "", "controller", "START")

-- RegisterNetEvent('XCEL:receiveDeathmatchPlayers', function(p)
--     d = p
-- end)

function XCEL.ShowPauseMenu()
    if IsPauseMenuActive() or tXCEL.isInComa() then return end
    SetPauseMenuActive(true)
    tXCEL.hideUI()
    SetNuiFocusKeepInput(false)
    TriggerScreenblurFadeIn(5.0)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "pauseMenu",
        toggle = true,
        playtime = tostring(getMoneyStringFormatted(tXCEL.getHours())), -- PLAYTIME
        employment = tXCEL.getEmploymentStatus(tXCEL.getUserId()), -- EMPLOYMENT
        totalPlayers = tXCEL.getPlayers(), -- TOTAL PLAYERS ONLINE
        playerid = getMoneyStringFormatted(tXCEL.getUserId()), -- ID
        deathmatchPlayers = "0/128",--d, -- TOTAL DEATHMATCH PLAYERS ONLINE
        playername = tXCEL.GetPlayerName(PlayerId()), -- NAME
    })
    isPauseMenuOpen = true
end

function XCEL.HidePauseMenu()
    if IsPauseMenuActive() then return end
    tXCEL.showUI()
    TriggerScreenblurFadeOut(5.0)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SetFrontendActive(false)
    SendNUIMessage({
        type = "pauseMenu",
        toggle = false
    })
    isPauseMenuOpen = false
end

tXCEL.createThreadOnTick(function()
    SetPauseMenuActive(false)
end)

Citizen.CreateThread(function()
    while true do
        Wait(1500)
        if u then
            u = false
        end
    end
end)

RegisterNUICallback('Close', function(data)
    XCEL.HidePauseMenu()
end)

RegisterNUICallback('PM:Settings', function(data)
    XCEL.HidePauseMenu()
    ActivateFrontendMenu(`FE_MENU_VERSION_LANDING_MENU`,0,-1) 
end)

RegisterNUICallback('PM:SupportDiscord', function(data)
    if not u then
        u = true
        tXCEL.OpenUrl('https://discord.gg/Y2fKurfUzw')
    else
        ttXCEL.notify('~r~You are being rate limited, Please wait.')
    end
end)

RegisterNUICallback('PM:MinigamesIP', function(data)
    if not u then
        u = true
        TriggerEvent("XCEL:showNotification",
            {
                text = "F8 Connect Copied To Clipboard.",
                height = "200px",
                width = "auto",
                colour = "#FFF",
                background = "#32CD32",
                pos = "bottom-right",
                icon = "good"
            }, 5000
        )
        tXCEL.CopyToClipBoard("s1.xcelstudios.dm")
    else
        tXCEL.notify('~r~You are being rate limited, Please wait.')
    end
end)

RegisterNUICallback('PM:Rules', function(data)
    if not u then
        u = true
        tXCEL.OpenUrl('https://forums.xcelstudios.co.uk/fivem-rules')
        --tXCEL.notify("~o~Coming soon...")
    else
        tXCEL.notify('~r~You are being rate limited, Please wait.')
    end
end)

RegisterNUICallback('PM:CommunityRules', function(data)
    if not u then
        u = true
        tXCEL.OpenUrl('https://forums.xcelstudios.co.uk/community-rules/')
       -- tXCEL.notify("~o~Coming soon...")
    else
        tXCEL.notify('~r~You are being rate limited, Please wait.')
    end
end)

RegisterNUICallback('PM:MainDiscord', function(data)
    if not u then
        u = true
        tXCEL.OpenUrl('https://discord.gg/xcel5m')
    else
        tXCEL.notify('~r~You are being rate limited, Please wait.')
    end
end)

RegisterNUICallback('PM:MinigamesDiscord', function(data)
    if not u then
        u = true
        tXCEL.OpenUrl('https://discord.gg/4FcfcpqGse')
    else
        tXCEL.notify('~r~You are being rate limited, Please wait.')
    end
end)

RegisterNUICallback('PM:Wiki', function(data)
    if not u then
        u = true
        XCEL.HidePauseMenu()
        TriggerEvent("XCEL:openGuideHud")
       -- tXCEL.OpenUrl('https://wiki.xcelstudios.co.uk/')
    else
        tXCEL.notify('~r~You are being rate limited, Please wait.')
    end
end)

RegisterNUICallback('PM:Twitter', function(data)
    if not u then
        u = true
        tXCEL.OpenUrl('https://x.com/XCELFiveM')
    else
        tXCEL.notify('~r~You are being rate limited, Please wait.')
    end
end)

RegisterNUICallback('PM:Website', function(data)
    if not u then
        u = true
        tXCEL.OpenUrl('https://xcelstudios.co.uk')
        --tXCEL.notify("~o~Coming soon...")
    else
        tXCEL.notify('~r~You are being rate limited, Please wait.')
    end
end)

RegisterNUICallback('PM:Store', function(data)
    if not u then
        u = true
        tXCEL.OpenUrl('https://store.xcelstudios.co.uk')
    else
        tXCEL.notify('~r~You are being rate limited, Please wait.')
    end
end)

RegisterNUICallback('PM:Map', function(data)
    XCEL.HidePauseMenu()
    ActivateFrontendMenu(`FE_MENU_VERSION_MP_PAUSE`,0,-1)
end)

RegisterNUICallback('PM:Disconnect', function(data)
	TriggerServerEvent('kick:PauseMenu')
end)

TriggerServerEvent("XCEL:getDeathmatchPlayers")