local a = {}
local b = {}
RMenu.Add(
    "XCEL",
    "admindailyboot",
    RageUI.CreateMenu("", "Daily Boot", tXCEL.getRageUIMenuWidth(), tXCEL.getRageUIMenuHeight(), "banners", "admin", "xcel_adminui", "xcel_adminui")
)
RMenu.Add("XCEL", "subadmindailyboot", RageUI.CreateSubMenu(RMenu:Get("XCEL", "admindailyboot"), "", "Daily Boot"))
RMenu.Add("XCEL", "weaponadmindailyboot", RageUI.CreateSubMenu(RMenu:Get("XCEL", "subadmindailyboot"), "", "Daily Boot"))
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("XCEL", "admindailyboot")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    if next(a) ~= nil then
                        RageUI.Separator("Claimed: " .. tostring("~g~" .. a.claimed))
                        RageUI.Separator(
                            "Redeem Time: " ..
                                string.format("%02d:%02d", tonumber(a.time.hour), tonumber(a.time.minute))
                        )
                        RageUI.Separator("Reward: £" .. getMoneyStringFormatted("~g~" .. a.money))
                        RageUI.Separator("Reward Items: ")
                        for c, d in pairs(a.items) do
                            RageUI.Separator(c .. " x" .. d)
                        end
                        RageUI.Button(
                            "Change Information",
                            "",
                            {},
                            true,
                            function(e, f, g)
                            end,
                            RMenu:Get("XCEL", "subadmindailyboot")
                        )
                    else
                        RageUI.Separator("Loading...")
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("XCEL", "subadmindailyboot")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    RageUI.ButtonWithStyle(
                        "Redeem Time",
                        "Change the time the daily boot is redeemable",
                        {},
                        true,
                        function(e, f, g)
                            if g then
                                TriggerServerEvent("XCEL:RequestChange", "openingtime")
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "Reward Money",
                        "Change the reward of the daily boot",
                        {},
                        true,
                        function(e, f, g)
                            if g then
                                TriggerServerEvent("XCEL:RequestChange", "moneyreward")
                            end
                        end
                    )
                    RageUI.ButtonWithStyle(
                        "Reward Items",
                        "Change the reward items of the daily boot",
                        {},
                        true,
                        function(e, f, g)
                        end,
                        RMenu:Get("XCEL", "weaponadmindailyboot")
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("XCEL", "weaponadmindailyboot")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    for c, d in pairs(weaponlist.weapons) do
                        print(d.wepname)
                        print(d.weight)
                        print(d.checked)
                    end
                    RageUI.ButtonWithStyle(
                        "Cancel",
                        "",
                        {},
                        true,
                        function(e, f, g)
                            if g then
                                for c, d in pairs(weaponlist) do
                                    b[c] = false
                                end
                            end
                        end,
                        RMenu:Get("XCEL", "subadmindailyboot")
                    )
                    RageUI.ButtonWithStyle(
                        "Confirm",
                        "",
                        {},
                        true,
                        function(e, f, g)
                            if g then
                                TriggerServerEvent("XCEL:RequestChange", "rewarditems", b)
                                b = {}
                            end
                        end
                    )
                end
            )
        end
    end
)
RegisterNetEvent(
    "XCEL:ReturnAdminBootTable",
    function(h, i)
        weaponlist = i
        a = h
        RageUI.Visible(RMenu:Get("XCEL", "admindailyboot"), not RageUI.Visible(RMenu:Get("XCEL", "admindailyboot")))
    end
)
RegisterNetEvent(
    "XCEL:RefreshBootData",
    function(h)
        a = h
    end
)
