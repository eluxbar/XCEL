Citizen.CreateThread(
    function()
        AddTextEntry("FE_THDR_GTAO", "XCEL British RP - discord.gg/xcel5m")
        AddTextEntry("PM_PANE_CFX", "XCEL")
    end
)
RegisterCommand(
    "discord",
    function()
        TriggerEvent("chatMessage", "^1[XCEL]^1  ", {128, 128, 128}, "^0Discord: discord.gg/xcel5m", "ooc")
        tXCEL.notify("~g~discord Copied to Clipboard.")
        tXCEL.CopyToClipboard("https://discord.gg/xcel5m")
    end
)
RegisterCommand(
    "getid",
    function(a, b)
        if b and b[1] then
            if tXCEL.clientGetUserIdFromSource(tonumber(b[1])) ~= nil then
                if tXCEL.clientGetUserIdFromSource(tonumber(b[1])) ~= tXCEL.getUserId() then
                    TriggerEvent(
                        "chatMessage",
                        "^1[XCEL]^1  ",
                        {128, 128, 128},
                        "This Users Perm ID is: " .. tXCEL.clientGetUserIdFromSource(tonumber(b[1])),
                        "alert"
                    )
                else
                    TriggerEvent(
                        "chatMessage",
                        "^1[XCEL]^1  ",
                        {128, 128, 128},
                        "This Users Perm ID is: " .. tXCEL.getUserId(),
                        "alert"
                    )
                end
            else
                TriggerEvent("chatMessage", "^1[XCEL]^1  ", {128, 128, 128}, "Invalid Temp ID", "alert")
            end
        else
            TriggerEvent(
                "chatMessage",
                "^1[XCEL]^1  ",
                {128, 128, 128},
                "Please specify a user eg: /getid [tempid]",
                "alert"
            )
        end
    end
)

