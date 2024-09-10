local a = false
local b = true
RegisterCommand(
    "togglekillfeed",
    function()
        if not a then
            b = not b
            if b then
                tXCEL.notify("~g~Killfeed is now enabled")
                SendNUIMessage({type = "killFeedEnable"})
            else
                tXCEL.notify("~r~Killfeed is now disabled")
                SendNUIMessage({type = "killFeedDisable"})
            end
        end
    end
)
RegisterNetEvent(
    "XCEL:showHUD",
    function(c)
        a = not c
        if b then
            if c then
                SendNUIMessage({type = "killFeedEnable"})
            else
                SendNUIMessage({type = "killFeedDisable"})
            end
        end
    end
)

function tXCEL.takeClientVideoAndUploadKills(a)
    exports["els"]:requestVideoUpload(
        a,
        "files[]",
        {headers = {}, isVideo = true, isManual = true, encoding = "mp4"},
        function(n)
            XCELserver.killProcessed()
        end
    )
end
