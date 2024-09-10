RMenu.Add('xcelhighrollers','casino',RageUI.CreateMenu("","",tXCEL.getRageUIMenuWidth(),tXCEL.getRageUIMenuHeight(),"shopui_title_casino","shopui_title_casino"))
RMenu:Get('xcelhighrollers','casino'):SetSubtitle("~b~MEMBERSHIP")
RMenu.Add('xcelhighrollers','confirmadd',RageUI.CreateSubMenu(RMenu:Get('xcelhighrollers','casino'),"","~b~Are you sure?",tXCEL.getRageUIMenuWidth(),tXCEL.getRageUIMenuHeight()))
RMenu.Add('xcelhighrollers','confirmremove',RageUI.CreateSubMenu(RMenu:Get('xcelhighrollers','casino'),"","~b~Are you sure?",tXCEL.getRageUIMenuWidth(),tXCEL.getRageUIMenuHeight()))
RMenu.Add('xcelhighrollers','casinoban',RageUI.CreateSubMenu(RMenu:Get('xcelhighrollers','casino'),"","~b~Manage Casino Ban",tXCEL.getRageUIMenuWidth(),tXCEL.getRageUIMenuHeight()))
RMenu.Add('xcelhighrollers','casinostats',RageUI.CreateSubMenu(RMenu:Get('xcelhighrollers','casino'),"","~b~Casino Stats",tXCEL.getRageUIMenuWidth(),tXCEL.getRageUIMenuHeight()))

local a={
    {
        pedPosition=vector3(1088.0207519531,221.13066101074,-49.200397491455),
        pedHeading=175.0,
        entryPosition=vector3(1088.3181152344,218.88592529297,-50.200374603271)
    },
    {
        pedPosition=vector3(4.245992, 6689.755371, -107.104309),
        pedHeading=345.0,
        entryPosition=vector3(4.565618, 6691.982910, -108.084309)
    }
}
local casinoStats = {}
local casinoRakeback = 0
local casinoBanTime = 0

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("xcelhighrollers", "casino")) then
        RageUI.DrawContent({header = true, glare = false, instructionalButton = false}, function()
            if tXCEL.casinoBanned() then
                RageUI.Separator("~HC_58~You are currently banned from the casino. Whilst banned you cannot make any purchases or bets. The time remaining on your ban is ~HC_4~" .. XCEL.getTimeLeft(casinoBanTime))
            else
                RageUI.ButtonWithStyle("Purchase High Rollers Membership (£10,000,000)", "~g~Allows you to sit at High-Rollers only seats.", {RightLabel = "→→→"}, true, function(b, c, d)
                end, RMenu:Get('xcelhighrollers', 'confirmadd'))
                RageUI.ButtonWithStyle("Remove High Rollers Membership (£0)", "~r~This is an irrevocable action, you will not receive any money in return.", {RightLabel = "→→→"}, true, function(b, c, d)
                end, RMenu:Get('xcelhighrollers', 'confirmremove'))
                RageUI.ButtonWithStyle("Casino Ban", "~b~Allows you to ban yourself from the casino for a set period of time. Whilst banned you cannot access this menu.", {RightLabel = "→→→"}, true, function(b, c, d)
                end, RMenu:Get('xcelhighrollers', 'casinoban'))
                RageUI.ButtonWithStyle("View Casino Stats", "~b~Your blackjack history throughout XCEL.", {RightLabel = "→→→"}, true, function(b, c, d)
                end, RMenu:Get('xcelhighrollers', 'casinostats'))
            end
        end)
    end

    RageUI.IsVisible(RMenu:Get("xcelhighrollers", "confirmadd"), true, true, true, function()
        RageUI.ButtonWithStyle("No", "", {RightLabel = "→→→"}, true, function(b, c, d)
            if d then 
                tXCEL.notify("~y~Cancelled!")
            end 
        end, RMenu:Get('xcelhighrollers', 'casino'))
        RageUI.ButtonWithStyle("Yes", "", {RightLabel = "→→→"}, true, function(b, c, d)
            if d then 
                TriggerServerEvent("XCEL:purchaseHighRollersMembership")
            end 
        end, RMenu:Get('xcelhighrollers', 'casino'))
    end)

    RageUI.IsVisible(RMenu:Get("xcelhighrollers", "confirmremove"), true, true, true, function()
        RageUI.ButtonWithStyle("No", "", {RightLabel = "→→→"}, true, function(b, c, d)
            if d then 
                tXCEL.notify("~y~Cancelled!")
            end 
        end, RMenu:Get('xcelhighrollers', 'casino'))
        RageUI.ButtonWithStyle("Yes", "", {RightLabel = "→→→"}, true, function(b, c, d)
            if d then 
                TriggerServerEvent("XCEL:removeHighRollersMembership")
            end 
        end, RMenu:Get('xcelhighrollers', 'casino'))
    end)

    RageUI.IsVisible(RMenu:Get("xcelhighrollers", "casinoban"), true, true, true, function()
        RageUI.ButtonWithStyle("Ban Duration", "", casinoBanTime > 0 and {RightLabel = casinoBanTime .. " hours"} or {RightLabel = "Set Duration"}, true, function(b, c, d)
            if d then 
                tXCEL.clientPrompt("Ban Duration: ", "", function(O)
                    if tonumber(O) then
                        if tonumber(O) > 0 then
                            casinoBanTime = tonumber(O)
                        else
                            tXCEL.notify("~r~Invalid duration.")
                        end
                    else
                        tXCEL.notify("~r~Invalid duration.")
                    end
                end)
            end 
        end)
        RageUI.ButtonWithStyle("Confirm Ban", "~r~This is an irrevocable action.", {RightLabel = "→→→"}, true, function(b, c, d)
            if d then 
                TriggerServerEvent("XCEL:casinoBan", casinoBanTime)
            end 
        end, RMenu:Get('xcelhighrollers', 'casino'))
    end)

    RageUI.IsVisible(RMenu:Get("xcelhighrollers", "casinostats"), true, true, true, function()
        if next(casinoStats) then
            for k, v in pairs(casinoStats) do
                RageUI.Separator(v)
            end
        else
            RageUI.Separator('~r~You have no casino blackjack stats to display.')
        end
        RageUI.ButtonWithStyle("Back", "", {RightLabel = "→→→"}, true, function(b, c, d)
        end, RMenu:Get('xcelhighrollers', 'casino'))
    end)
end)

RegisterNetEvent('XCEL:setCasinoStats')
AddEventHandler('XCEL:setCasinoStats', function(stats, rakeback, bantime)
    casinoStats = stats
    casinoRakeback = rakeback
    casinoBanTime = bantime
end)
function showCasinoMembership(e)
    RageUI.Visible(RMenu:Get('xcelhighrollers','casino'),e)
end
Citizen.CreateThread(function()
    local f="mini@strip_club@idles@bouncer@base"
    RequestAnimDict(f)
    while not HasAnimDictLoaded(f)do 
        RequestAnimDict(f)
        Wait(0)
    end
    for g,h in pairs(a)do 
        local i=tXCEL.loadModel('u_f_m_casinocash_01')
        local j=CreatePed(26,i,h.pedPosition.x,h.pedPosition.y,h.pedPosition.z,175.0,false,true)
        SetModelAsNoLongerNeeded(i)
        SetEntityCanBeDamaged(j,0)
        SetPedAsEnemy(j,0)
        SetBlockingOfNonTemporaryEvents(j,1)
        SetPedResetFlag(j,249,1)
        SetPedConfigFlag(j,185,true)
        SetPedConfigFlag(j,108,true)
        SetPedCanEvasiveDive(j,0)
        SetPedCanRagdollFromPlayerImpact(j,0)
        SetPedConfigFlag(j,208,true)
        SetEntityCoordsNoOffset(j,h.pedPosition.x,h.pedPosition.y,h.pedPosition.z,175.0,0,0,1)
        SetEntityHeading(j,h.pedHeading)
        FreezeEntityPosition(j,true)
        TaskPlayAnim(j,f,"base",8.0,0.0,-1,1,0,0,0,0)
        RemoveAnimDict(f)
    end 
end)
AddEventHandler("XCEL:onClientSpawn",function(D, E)
    if E then
        TriggerServerEvent("XCEL:getCasinoStats")
		local m=function(n)
            TriggerServerEvent("XCEL:getCasinoStats")
            showCasinoMembership(true)
        end
        local o=function(n)
            RageUI.CloseAll()
            showCasinoMembership(false)
        end
        local p=function(n)
        end
        for q,h in pairs(a)do 
            tXCEL.addBlip(h.entryPosition.x,h.entryPosition.y,h.entryPosition.z,682,0,"Casino Memberships",0.7,true)
            tXCEL.addMarker(h.entryPosition.x,h.entryPosition.y,h.entryPosition.z,1.0,1.0,1.0,138,43,226,70,50,27)
            tXCEL.createArea("casinomembership_"..q,h.entryPosition,1.5,6,m,o,p,{})
        end 
	end
end)

function tXCEL.casinoBanned()
    return casinoBanTime > 0
end