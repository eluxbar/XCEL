RMenu.Add(
    "xcelannouncements",
    "main",
    RageUI.CreateMenu(
        "",
        "Announcement Menu",
        tXCEL.getRageUIMenuWidth(),
        tXCEL.getRageUIMenuHeight(),
        "banners",
        "announcement",
        "xcel_announceui",
        "xcel_announceui"
    )
)
local a = {}
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("xcelannouncements", "main")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    for b, c in pairs(a) do
                        RageUI.Button(
                            c.name,
                            string.format("%s Price: £%s", c.desc, getMoneyStringFormatted(c.price)),
                            {RightLabel = "→→→"},
                            true,
                            function(d, e, f)
                                if f then
                                    TriggerServerEvent("XCEL:serviceAnnounce", c.name)
                                end
                            end
                        )
                    end
                end
            )
        end
    end
)
RegisterNetEvent(
    "XCEL:serviceAnnounceCl",
    function(g, h)
        tXCEL.announce(g, h)
    end
)
RegisterNetEvent(
    "XCEL:buildAnnounceMenu",
    function(i)
        a = i
        RageUI.Visible(RMenu:Get("xcelannouncements", "main"), not RageUI.Visible(RMenu:Get("xcelannouncements", "main")))
    end
)
RegisterCommand(
    "announcemenu",
    function()
        TriggerServerEvent("XCEL:getAnnounceMenu")
    end
)
RegisterNetEvent("XCEL:Announce")
AddEventHandler(
    "XCEL:Announce",
    function(d)
        if d ~= nil then
            CreateThread(
                function()
                    local e = GetGameTimer()
                    local scaleform = RequestScaleformMovie("MIDSIZED_MESSAGE")
                    while not HasScaleformMovieLoaded(scaleform) do
                        Wait(0)
                    end
                    BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_MIDSIZED_MESSAGE")
                    ScaleformMovieMethodAddParamTextureNameString("~y~XCEL Announcement")
                    ScaleformMovieMethodAddParamTextureNameString(d)
                    ScaleformMovieMethodAddParamInt(5)
                    ScaleformMovieMethodAddParamBool(true)
                    ScaleformMovieMethodAddParamBool(false)
                    EndScaleformMovieMethod()
                    while e + 6 * 1000 > GetGameTimer() do
                        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
                        Wait(0)
                    end
                end
            )
        end
    end
)
