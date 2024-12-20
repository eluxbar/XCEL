local a = nil
local b = {}
local c = vector3(-585.17864990234, -209.28169250488, 38.219661712646)
local d = module("xcel-vehicles", "cfg/cfg_garages")
d = d.garages
RMenu.Add("plateshop", "main", RageUI.CreateMenu("", "DVLA", 1350, 50, "xcel_licenseplateui", "xcel_licenseplateui"))
RMenu.Add(
    "plateshop",
    "ownedvehicles",
    RageUI.CreateSubMenu(RMenu:Get("plateshop", "main"), "", "Owned Vehicles", 1350, 50)
)
RMenu.Add(
    "plateshop",
    "changeplate",
    RageUI.CreateSubMenu(RMenu:Get("plateshop", "ownedvehicles"), "", "Plate management", 1350, 50)
)
RageUI.CreateWhile(
    1.0,
    true,
    function()
        if RageUI.Visible(RMenu:Get("plateshop", "main")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.ButtonWithStyle(
                        "Owned Vehicles",
                        "View your owned vehicles",
                        {RightLabel = "→→→"},
                        true,
                        function(e, f, g)
                        end,
                        RMenu:Get("plateshop", "ownedvehicles")
                    )
                    RageUI.ButtonWithStyle(
                        "Check Plate Availability",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(e, f, g)
                            if g then
                                local h = GetLicensePlateString()
                                if h ~= "" then
                                    TriggerServerEvent("XCEL:checkPlateAvailability", h)
                                end
                            end
                        end
                    )
                end
            )
        end
        if RageUI.Visible(RMenu:Get("plateshop", "ownedvehicles")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    if next(b) == nil then
                        RageUI.Separator("You do not own any vehicles.")
                    else
                        for i, j in pairs(b) do
                            for k, l in pairs(d) do
                                for m, n in pairs(l) do
                                    if m ~= "_config" then
                                        if m == j[1] then
                                            RageUI.Button(
                                                "" .. n[1],
                                                "~g~Spawncode: ~w~" .. j[1] .. " - ~g~Current Plate ~w~" .. j[2],
                                                "",
                                                true,
                                                function(e, f, g)
                                                    if g then
                                                        selectedCar = j[1]
                                                        selectedCarName = n[1]
                                                    end
                                                end,
                                                RMenu:Get("plateshop", "changeplate")
                                            )
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            )
        end
        if RageUI.Visible(RMenu:Get("plateshop", "changeplate")) then
            RageUI.DrawContent(
                {header = true, glare = false, instructionalButton = false},
                function()
                    RageUI.Button(
                        "Change Number Plate",
                        "~g~Changing plate of " .. selectedCarName,
                        {RightLabel = "~g~£500,000"},
                        true,
                        function(e, f, g)
                            if g then
                                TriggerServerEvent("XCEL:ChangeNumberPlate", selectedCar)
                            end
                        end
                    )
                end
            )
        end
    end
)
AddEventHandler(
    "XCEL:onClientSpawn",
    function(o, i)
        if i then
            local j = function(k)
            end
            local n = function(k)
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("plateshop", "main"), false)
            end
            local d = function(k)
                if IsControlJustPressed(1, 38) then
                    TriggerServerEvent("XCEL:getCars")
                    RageUI.ActuallyCloseAll()
                    RageUI.Visible(RMenu:Get("plateshop", "main"), not RageUI.Visible(RMenu:Get("plateshop", "main")))
                end
                tXCEL.DrawText3D(c, "Press [E] to open License Plate Management", 0.4)
            end
            tXCEL.createArea("licenseplate", c, 1.5, 6, j, n, d, {})
            tXCEL.addMarker(c.x, c.y, c.z - 1, 1.0, 1.0, 1.0, 255, 0, 0, 4, 50, 27)
            tXCEL.addBlip(c.x, c.y, c.z, 606, 2, "Licence Plate Manager")
        end
    end
)
RegisterNetEvent("XCEL:RecieveNumberPlate")
AddEventHandler(
    "XCEL:RecieveNumberPlate",
    function(p)
        a = p
        RageUI.ActuallyCloseAll()
        RageUI.Visible(RMenu:Get("plateshop", "main"), true)
        TriggerServerEvent("XCEL:getCars")
    end
)
RegisterNetEvent("XCEL:carsTable")
AddEventHandler(
    "XCEL:carsTable",
    function(q)
        b = q
    end
)
function GetLicensePlateString()
    AddTextEntry("FMMC_MPM_NA", "Enter text:")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local r = GetOnscreenKeyboardResult()
        return r
    end
    return ""
end
