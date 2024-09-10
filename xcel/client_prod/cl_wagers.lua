local cfg = module("cfg/cfg_wagers").settings
local weapons = module("cfg/weapons").weapons
local wagerTeam = {}
local wagersOpen = false
local timeout = false
local l, teamA_group_id = AddRelationshipGroup("WAGERS_TEAM_A")
local l, teamB_group_id = AddRelationshipGroup("WAGERS_TEAM_B")

for k,v in pairs(cfg.weapons_in_category) do
    for a,b in pairs(v) do
        cfg.weapons_in_category[k][a] = weapons[a].name
    end
end

RMenu.Add('wagers', 'main', RageUI.CreateMenu("", "Wagers", tXCEL.getRageUIMenuWidth(), tXCEL.getRageUIMenuHeight(), "banners", "wagers"))
RMenu.Add("wagers", "list", RageUI.CreateSubMenu(RMenu:Get("wagers", "main"), "", "Wagers",tXCEL.getRageUIMenuWidth(), tXCEL.getRageUIMenuHeight(),"banners","wagers"))
RMenu.Add("wagers", "create", RageUI.CreateSubMenu(RMenu:Get("wagers", "main"), "", "Wagers",tXCEL.getRageUIMenuWidth(), tXCEL.getRageUIMenuHeight(),"banners","wagers"))
RMenu.Add("wagers", "wagerteams", RageUI.CreateSubMenu(RMenu:Get("wagers", "list"), "", "Wagers",tXCEL.getRageUIMenuWidth(), tXCEL.getRageUIMenuHeight(),"banners","wagers"))

RageUI.CreateWhile(1.0,RMenu:Get("wagers", "main"),function()
    RageUI.IsVisible(RMenu:Get("wagers", "main"),true,true,true,function()
       -- if wagersOpen then
            RageUI.ButtonWithStyle("List Wagers", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent("XCEL:getWagerData")
                end
            end, RMenu:Get("wagers", "list"))
            RageUI.ButtonWithStyle("Create Wager", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            end, RMenu:Get("wagers", "create"))
        -- else
        --     RageUI.Separator("Wagers are currently closed.")
        -- end
    end,
    function()
    end)
    RageUI.IsVisible(RMenu:Get("wagers", "list"),true,true,true,function()
        if table.count(wagerTeam) == 0 then
            RageUI.Separator("~r~No pending bets")
        else
            for owner_id,v in pairs(wagerTeam) do
                RageUI.ButtonWithStyle(wagerTeam[owner_id].name, string.format("Category: %s\nWeapon: %s\nArmour: %s\nBest of: %s\nBet Amount: £%s\n%s", v.WagerWeaponCategory, weapons[v.wagerWeapon].name, v.armourValues, v.bestOf, getMoneyStringFormatted(v.betAmount), "Status: ".. (v.inProgress and "Active" or "inactive")), {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        selectedWagerOwner = owner_id
                    end
                end, RMenu:Get("wagers", "wagerteams"))
            end
        end
    end,
    function()
    end)
    RageUI.IsVisible(RMenu:Get("wagers", "create"),true,true,true,function()
        RageUI.List("Weapon Category",cfg.categories,cfg.categoryIndex,"",{},true,function(M, N, O, a0)
            if a0 ~= cfg.categoryIndex then
                cfg.categoryIndex = a0
                cfg.weaponInCategoryIndex = 1
            end
        end)
        RageUI.List("Weapon",table_values(cfg.weapons_in_category[cfg.categories[cfg.categoryIndex]]),cfg.weaponInCategoryIndex,"",{},true,function(M, N, O, a0)
            if a0 ~= cfg.weaponInCategoryIndex then
                cfg.weaponInCategoryIndex = a0
            end
        end)
        RageUI.List("Armour",cfg.armour_values,cfg.armour_index,"",{},true,function(M, N, O, a0)
            if a0 ~= cfg.armour_index then
                cfg.armour_index = a0
            end
        end)
        RageUI.List("Best of",cfg.best_of,cfg.best_ofIndex,"",{},true,function(M, N, O, a0)
            if a0 ~= cfg.best_ofIndex then
                cfg.best_ofIndex = a0
            end
        end)
        RageUI.List("Location",table_values(cfg.locations),cfg.locationIndex,"",{},true,function(M, N, O, a0)
            if a0 ~= cfg.locationIndex then
                cfg.locationIndex = a0
            end
        end)
        RageUI.ButtonWithStyle("Bet Amount", nil, {RightLabel = "£"..getMoneyStringFormatted(cfg.wagerBetAmount)}, true, function(Hovered, Active, Selected)
            if Selected then
                tXCEL.clientPrompt("Enter Amount:","",function(d)
                    if tonumber(d) then 
                        local amount = tonumber(d)
                        if amount <= cfg.wagerMaxBet and amount >= cfg.wagerMinBet then
                            cfg.wagerBetAmount = amount
                        else
                            tXCEL.notify("~r~You need to bet an amount between £100,000 and £100,000,000.")
                        end
                    else 
                        tXCEL.notify("~r~Invalid amount.")
                    end 
                end)
            end
        end)
        RageUI.ButtonWithStyle("Propose Wager", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if Selected then
                local map = table.find(cfg.locations, table_values(cfg.locations)[cfg.locationIndex])
                if cfg.location_coords[map].load_IPL then
                    RequestIpl(map)
                    while not IsIplActive(map) do print("loading ipl "..map) Wait(0) end
                end
                TriggerServerEvent("XCEL:createWager", 
                cfg.best_of[cfg.best_ofIndex], 
                table.find(cfg.weapons_in_category[cfg.categories[cfg.categoryIndex]], table_values(cfg.weapons_in_category[cfg.categories[cfg.categoryIndex]])[cfg.weaponInCategoryIndex]),
                cfg.categories[cfg.categoryIndex], 
                cfg.wagerBetAmount, 
                cfg.armour_values[cfg.armour_index],
                cfg.location_coords[map])
                selectedWagerOwner = tXCEL.getUserId()
            end
        end, RMenu:Get("wagers", "wagerteams"))
    end,
    function()
    end)
    RageUI.IsVisible(RMenu:Get("wagers", "wagerteams"),true,true,true,function()
        RageUI.Separator("Team A")
        local teamACount = 0
        local playerId = tXCEL.getUserId()
        if wagerTeam[selectedWagerOwner] == nil then
            RageUI.CloseAll()
            RageUI.Visible(RMenu:Get("wagers", "list"), true)
        else 
            for player_id, playerDetails in pairs(wagerTeam[selectedWagerOwner].teamA.players) do
                teamACount = teamACount + 1
                RageUI.ButtonWithStyle(playerDetails.name, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                end)
            end
            for i = teamACount + 1, cfg.maxTeamPlayers do
                RageUI.ButtonWithStyle("Available Slot", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                end)
            end
            if wagerTeam[selectedWagerOwner].teamA.players[tXCEL.getUserId()] then
                RageUI.ButtonWithStyle("~r~Leave Team A", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if not timeout then
                            timeout = true
                            SetTimeout(1000, function()
                                timeout = false
                            end)
                            TriggerServerEvent("XCEL:leaveTeam", selectedWagerOwner, "teamA")
                        else
                            tXCEL.notify("~r~Please wait before leaving another team.")
                        end
                    end
                end)
            else
                if teamACount < cfg.maxTeamPlayers then
                    RageUI.ButtonWithStyle("~g~Join Team A", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if not timeout then
                                timeout = true
                                SetTimeout(1000, function()
                                    timeout = false
                                end)
                                TriggerServerEvent("XCEL:joinWager", selectedWagerOwner, "teamA")
                            else
                                tXCEL.notify("~r~Please wait before joining another team.")
                            end
                        end
                    end)
                else
                    RageUI.Separator("~r~Team A is full.")
                end
            end
            RageUI.Separator("Team B")
            local teamBCount = 0
            for player_id, playerDetails in pairs(wagerTeam[selectedWagerOwner].teamB.players) do
                teamBCount = teamBCount + 1
                RageUI.ButtonWithStyle(playerDetails.name, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                end)
            end
            for i = teamBCount + 1, cfg.maxTeamPlayers do
                RageUI.ButtonWithStyle("Available Slot", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                end)
            end
            if wagerTeam[selectedWagerOwner].teamB.players[tXCEL.getUserId()] then
                RageUI.ButtonWithStyle("~r~Leave Team B", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if not timeout then
                            timeout = true
                            SetTimeout(1000, function()
                                timeout = false
                            end)
                            TriggerServerEvent("XCEL:leaveTeam", selectedWagerOwner, "teamB")
                        else
                            tXCEL.notify("~r~Please wait before leaving another team.")
                        end
                    end
                end)
            else
                if teamBCount < cfg.maxTeamPlayers then
                    RageUI.ButtonWithStyle("~g~Join Team B", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                        if Selected then
                            if not timeout then
                                timeout = true
                                SetTimeout(1000, function()
                                    timeout = false
                                end)
                                TriggerServerEvent("XCEL:joinWager", selectedWagerOwner, "teamB")
                            else
                                tXCEL.notify("~r~Please wait before joining another team.")
                            end
                        end
                    end)
                else
                    RageUI.Separator("~r~Team B is full.")
                end
            end
            if selectedWagerOwner == tXCEL.getUserId() then
                RageUI.Separator("")
                local teamsBalanced = (teamACount == 1 and teamBCount == 1) or (teamACount == 2 and teamBCount == 2)
                RageUI.ButtonWithStyle("~h~" .. (teamsBalanced and "~g~Start Wager" or "~r~Start Wager"), "The game must be at least a 1v1 or a 2v2 to start.", {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if tXCEL.isDev() or teamsBalanced then
                            TriggerServerEvent("XCEL:startWager")
                        else
                            tXCEL.notify("~r~Teams must be balanced to start the wager!")
                        end
                    end
                end)
                RageUI.ButtonWithStyle("~r~Cancel Wager", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("XCEL:cancelWager", selectedWagerOwner)
                    end
                end)
            end
        end
    end,
    function()
    end)
end)

RegisterNetEvent("XCEL:setWagerStats",function(stats)
    wagerStats = stats
end)

AddEventHandler("XCEL:onClientSpawn",function(D, E)
    if E then
        local h = cfg.wagerStartLoc
        local C=function(D)
            TriggerServerEvent("XCEL:getWagerWhitelists")
            cfg.categoryIndex = 1
            cfg.weaponInCategoryIndex = 1
            RageUI.Visible(RMenu:Get('wagers','main'),true)
        end
        local E=function(D)
            RageUI.CloseAll()
        end
        tXCEL.addMarker(h.x, h.y, h.z-0.2, 0.5, 0.5, 0.5, 0, 50, 255, 170, 50, 20, false, false, true)
        tXCEL.addBlip(h.x, h.y, h.z,437,1,"Wager Arena",0.9)
        tXCEL.createArea("wagers",h,1.5,6,C,E,nil,{})
    end
end)

RegisterNetEvent("XCEL:gotWagerWhitelists", function(whitelists, if_wagers_open)
    if table.count(whitelists) ~= 0 and not cfg.weapons_in_category["Owned Whitelists"] then
        table.insert(cfg.categories,"Owned Whitelists")
        cfg.weapons_in_category["Owned Whitelists"] = whitelists
    end
    wagersOpen = if_wagers_open
end)

RegisterNetEvent("XCEL:sendWagerData", function(team, value)
    if value then
        count = 0
        currentRound = 1
        inWager = false
        local map = table.find(cfg.locations, table_values(cfg.locations)[cfg.locationIndex])
        if cfg.location_coords[map].load_IPL then
            RemoveIpl(map)
        end
    end
    wagerTeam = team
end)

RegisterNetEvent("XCEL:toggleInWager",function(v)
    inWager = v
    if not v then
        ClearRelationshipBetweenGroups(5, teamA_group_id, teamB_group_id)
        ClearRelationshipBetweenGroups(5, teamB_group_id, teamA_group_id)
        SetPedRelationshipGroupHash(tXCEL.getPlayerPed(), "PLAYER")
        tXCEL.setFriendlyFire(true)
    end
end)

RegisterNetEvent("XCEL:startWager",function(team)
    ClearPedTasks(tXCEL.getPlayerPed())
    if team == "teamA" then
        SetPedRelationshipGroupHash(tXCEL.getPlayerPed(), teamA_group_id)
    elseif team == "teamB" then
        SetPedRelationshipGroupHash(tXCEL.getPlayerPed(), teamB_group_id)
    end
    SetRelationshipBetweenGroups(5, teamA_group_id, teamB_group_id)
    SetRelationshipBetweenGroups(5, teamB_group_id, teamA_group_id)
    tXCEL.setFriendlyFire(false)
end)

local isCountingDown = false
local countdownValue = 0

function tXCEL.showCountdownTimer(a9)
    isCountingDown = true
    countdownValue = a9
    local aa = 0
    local ab = a9
    local ac = a9 + 1
    local ad = 255
    local ae = 0
    local af

    Citizen.CreateThread(function()
        while isCountingDown do
            if ac ~= -1 then
                ac = ac - 1
                aa = aa + 1
            end
            if ac > 0 then
                PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)
                FreezeEntityPosition(tXCEL.getPlayerPed(), true)
            end
            if ac == 0 then
                PlaySoundFrontend(-1, "GO", "HUD_MINI_GAME_SOUNDSET", 1)
                FreezeEntityPosition(tXCEL.getPlayerPed(), false)
            end
            Citizen.Wait(1000)
        end
    end)

    af = Scaleform("COUNTDOWN")

    Citizen.CreateThread(function()
        while isCountingDown do
            if ac ~= -1 then
                if ac == 0 then
                    af.RunFunction("SET_MESSAGE", {"CNTDWN_GO", 255, 255, 255, true, false})
                elseif ac > 0 then
                    if ac >= a9 / 2 then
                        ae = math.floor(510 * (1 - aa / ab))
                    elseif ac < a9 / 2 then
                        ad = math.floor(510 * aa / ab)
                    end
                    af.RunFunction("SET_MESSAGE", {tostring(ac), 255, 255, 255, true, false})
                end
                af.Render2D()
                DisablePlayerFiring(tXCEL.getPlayerId(), true)
            end
            Wait(0)
        end
    end)

    while ac ~= -1 do
        Citizen.Wait(1.0)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if inWager and wagerTeam[selectedWagerOwner] then
            local currentWager = wagerTeam[selectedWagerOwner]
            if currentWager.teamA.players[tXCEL.getUserId()] then
                count = currentWager.teamA.wins
                currentRound = currentWager.currentRound
            elseif currentWager.teamB.players[tXCEL.getUserId()] then
                count = currentWager.teamB.wins
                currentRound = currentWager.currentRound
            end
            DrawGTATimerBar("~b~Rounds won:", tonumber(count), 3)
            DrawGTATimerBar("~b~Current round:", (currentRound + 1).."/"..currentWager.bestOf, 2)
        end
    end
end)

RegisterCommand("tpwager", function()
    if not InCasinoZone then
        if not XCEL.playerInWager() then
            if isInGreenzone then
                tXCEL.notify("~g~Teleporting...")
                tXCEL.startCircularProgressBar("",3000,nil,function()end)
                tXCEL.teleport(cfg.wagerStartLoc.x, cfg.wagerStartLoc.y, cfg.wagerStartLoc.z,XCEL.getAcKey())
            else
                tXCEL.notify("~r~You must be in a greenzone.")
            end
        else
            tXCEL.notify("~r~You cannot use this while in a wager.")
        end
    else
        tXCEL.notify("~r~Cannot use this right now")
    end
end)

function XCEL.playerInWager()
    return inWager
end