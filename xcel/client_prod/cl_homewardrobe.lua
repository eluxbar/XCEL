local a = nil
local b = {}
local c = ""
local function d()
    if next(b) then
        return true
    end
    return false
end
RMenu.Add(
    "xcelwardrobe",
    "mainmenu",
    RageUI.CreateMenu("", "", tXCEL.getRageUIMenuWidth(), tXCEL.getRageUIMenuHeight(), "xcel_wardrobeui", "xcel_wardrobeui")
)
RMenu:Get("xcelwardrobe", "mainmenu"):SetSubtitle("HOME")
RMenu.Add(
    "xcelwardrobe",
    "listoutfits",
    RageUI.CreateSubMenu(
        RMenu:Get("xcelwardrobe", "mainmenu"),
        "",
        "Wardrobe",
        tXCEL.getRageUIMenuWidth(),
        tXCEL.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "xcelwardrobe",
    "equip",
    RageUI.CreateSubMenu(
        RMenu:Get("xcelwardrobe", "listoutfits"),
        "",
        "Wardrobe",
        tXCEL.getRageUIMenuWidth(),
        tXCEL.getRageUIMenuHeight()
    )
)
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("xcelwardrobe", "mainmenu")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    RageUI.Button(
                        "List Outfits",
                        "",
                        {RightLabel = "→→→"},
                        d(),
                        function(e, f, g)
                        end,
                        RMenu:Get("xcelwardrobe", "listoutfits")
                    )
                    RageUI.Button(
                        "Save Outfit",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(e, f, g)
                            if g then
                                c = tXCEL.KeyboardInput("Outfit Name:", "", 20)
                                if c then
                                    if not tXCEL.isPlayerInAnimalForm() then
                                        TriggerServerEvent("XCEL:saveWardrobeOutfit", c)
                                    else
                                        tXCEL.notify("Cannot save animal in wardrobe.")
                                    end
                                else
                                    tXCEL.notify("~r~Invalid outfit name")
                                end
                            end
                        end
                    )
                    RageUI.Button(
                        "Get Outfit Code",
                        "Gets a code for your current outfit which can be shared with other players.",
                        {RightLabel = "→→→"},
                        true,
                        function(e, f, g)
                            if g then
                                if tXCEL.isPlusClub() or tXCEL.isPlatClub() then
                                    TriggerServerEvent("XCEL:getCurrentOutfitCode")
                                else
                                    tXCEL.notify(
                                        "~y~You need to be a subscriber of XCEL Plus or XCEL Platinum to use this feature."
                                    )
                                    tXCEL.notify("~y~Available @ store.xcelstudios.com")
                                end
                            end
                        end,
                        nil
                    )
                end,
                function()
                end
            )
        end
        if RageUI.Visible(RMenu:Get("xcelwardrobe", "listoutfits")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    if b ~= {} then
                        for h, i in pairs(b) do
                            RageUI.Button(
                                h,
                                "",
                                {RightLabel = "→→→"},
                                true,
                                function(e, f, g)
                                    if g then
                                        c = h
                                    end
                                end,
                                RMenu:Get("xcelwardrobe", "equip")
                            )
                        end
                    else
                        RageUI.Button(
                            "No outfits saved",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(e, f, g)
                            end,
                            RMenu:Get("xcelwardrobe", "mainmenu")
                        )
                    end
                end,
                function()
                end
            )
        end
        if RageUI.Visible(RMenu:Get("xcelwardrobe", "equip")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = true},
                function()
                    RageUI.Button(
                        "Equip Outfit",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(e, f, g)
                            if g then
                                TriggerServerEvent("XCEL:equipWardrobeOutfit", c)
                            end
                        end,
                        RMenu:Get("xcelwardrobe", "listoutfits")
                    )
                    RageUI.Button(
                        "Delete Outfit",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(e, f, g)
                            if g then
                                TriggerServerEvent("XCEL:deleteWardrobeOutfit", c)
                            end
                        end,
                        RMenu:Get("xcelwardrobe", "listoutfits")
                    )
                end,
                function()
                end
            )
        end
    end
)
local function j()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("xcelwardrobe", "mainmenu"), true)
end
local function k()
    RageUI.ActuallyCloseAll()
    RageUI.Visible(RMenu:Get("xcelwardrobe", "mainmenu"), false)
end
RegisterNetEvent(
    "XCEL:openOutfitMenu",
    function(l)
        if l then
            b = l
        else
            TriggerServerEvent("XCEL:initWardrobe")
        end
        j()
    end
)
RegisterNetEvent(
    "XCEL:refreshOutfitMenu",
    function(l)
        b = l
    end
)
RegisterNetEvent(
    "XCEL:closeOutfitMenu",
    function()
        k()
    end
)
