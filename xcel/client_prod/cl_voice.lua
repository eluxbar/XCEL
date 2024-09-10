RegisterNetEvent(
    "XCEL:mutePlayers",
    function(a)
        for b, c in pairs(a) do
            exports["xcel"]:mutePlayer(c, true)
        end
    end
)
RegisterNetEvent(
    "XCEL:mutePlayer",
    function(c)
        exports["xcel"]:mutePlayer(c, true)
    end
)
RegisterNetEvent(
    "XCEL:unmutePlayer",
    function(c)
        exports["xcel"]:mutePlayer(c, false)
    end
)
RegisterNetEvent(
    "XCEL:ToggleMutePlayer",
    function(c)
        exports["xcel"]:mutePlayer(c, true)
        Citizen.Wait(60000)
        exports["xcel"]:mutePlayer(c, false)
    end
)
function unmute(c)
    MumbleSetActive(false)
end
