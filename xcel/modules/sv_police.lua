
-- this module define some police tools and functions
local lang = XCEL.lang
local a = module("cfg/weapons")
local isStoring = {}
local cooldowns = {}

RegisterServerEvent("XCEL:forceStoreSingleWeapon")
AddEventHandler("XCEL:forceStoreSingleWeapon", function(model)
    local source = source
    local user_id = XCEL.getUserId(source)
    local currentTime = os.time()
    if cooldowns[source] and currentTime - cooldowns[source] < 3 then
        XCELclient.notify(source, {"~r~Store weapon cooldown. Please wait"})
    else
        cooldowns[source] = currentTime
        if model ~= nil then
            XCELclient.getWeapons(source, {}, function(weapons)
                for k, v in pairs(weapons) do
                    if k == model then
                        local new_weight = XCEL.getInventoryWeight(user_id) + XCEL.getItemWeight(model)
                        if new_weight <= XCEL.getInventoryMaxWeight(user_id) then
                            RemoveWeaponFromPed(GetPlayerPed(source), k)
                            XCELclient.removeWeapon(source, {k})
                            XCEL.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                            if v.ammo > 0 then
                                for i, c in pairs(a.weapons) do
                                    if i == model and c.class ~= 'Melee' then
                                        XCEL.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

RegisterServerEvent("XCEL:storeAllWeapons", function(death)
  local player = source
  if not XCEL.inArena(player) then
    local user_id = XCEL.getUserId(player)
    local data = XCEL.getUserDataTable(user_id)
    XCELclient.getWeapons(player, {}, function(weapons)
      if not isStoring[player] then
        local new_weight = XCEL.getInventoryWeight(user_id)
        for k, v in pairs(weapons) do
          new_weight = new_weight + v.ammo * 0.01
          new_weight = new_weight + XCEL.getItemWeight("wbody|"..k)
        end
        if new_weight > XCEL.getInventoryMaxWeight(user_id) and GetEntityHealth(GetPlayerPed(player)) > 102 then XCELclient.notify(player, {'~r~You do not have enough space to store all weapons.'}) return end
        isStoring[player] = true
        XCELclient.getAllowedWeapons(player, {}, function(allowed)
          XCELclient.giveWeapons(player, { {}, true, globalpasskey }, function(removedwep)
            for k, v in pairs(weapons) do
              if allowed[k] then
                if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' then
                  XCEL.giveInventoryItem(user_id, "wbody|"..k, 1, not death)
                  if v.ammo > 0 and k ~= 'WEAPON_STUNGUN' then
                    for i, c in pairs(a.weapons) do
                      if i == k and c.class ~= 'Melee' then
                        if v.ammo > 250 then
                          v.ammo = 250
                        end
                        XCEL.giveInventoryItem(user_id, c.ammo, v.ammo, not death)
                      end   
                    end
                  end
                end
              end
            end
            XCELclient.notify(player, {"~g~Weapons Stored"})
            TriggerEvent('XCEL:RefreshInventory', player)
            XCELclient.ClearWeapons(player,{})
            data.weapons = {}
            SetTimeout(3000, function()
              isStoring[player] = nil 
            end)
          end)
        end)
      end
    end)
  end
end)

RegisterCommand('shield', function(source, args)
  local source = source
  local user_id = XCEL.getUserId(source)
  if XCEL.hasPermission(user_id, 'police.armoury') then
    TriggerClientEvent('XCEL:toggleShieldMenu', source)
  end
end)

RegisterCommand('cuff', function(source, args)
  local source = source
  local user_id = XCEL.getUserId(source)
  XCELclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      XCELclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and XCEL.hasPermission(user_id, 'admin.tickets')) or XCEL.hasPermission(user_id, 'police.armoury') then
          XCELclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = XCEL.getUserId(nplayer)
              if (not XCEL.hasPermission(nplayer_id, 'police.armoury') or XCEL.hasPermission(nplayer_id, 'police.undercover')) then
                XCELclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('XCEL:uncuffAnim', source, nplayer, false)
                    TriggerClientEvent('XCEL:unHandcuff', source, false)
                  else
                    TriggerClientEvent('XCEL:arrestCriminal', nplayer, source)
                    TriggerClientEvent('XCEL:arrestFromPolice', source)
                  end
                  TriggerClientEvent('XCEL:toggleHandcuffs', nplayer, false)
                  TriggerClientEvent('XCEL:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              XCELclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

RegisterCommand('frontcuff', function(source, args)
  local source = source
  local user_id = XCEL.getUserId(source)
  XCELclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      XCELclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and XCEL.hasPermission(user_id, 'admin.tickets')) or XCEL.hasPermission(user_id, 'police.armoury') then
          XCELclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = XCEL.getUserId(nplayer)
              if (not XCEL.hasPermission(nplayer_id, 'police.armoury') or XCEL.hasPermission(nplayer_id, 'police.undercover')) then
                XCELclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('XCEL:uncuffAnim', source, nplayer, true)
                    TriggerClientEvent('XCEL:unHandcuff', source, true)
                  else
                    TriggerClientEvent('XCEL:arrestCriminal', nplayer, source)
                    TriggerClientEvent('XCEL:arrestFromPolice', source)
                  end
                  TriggerClientEvent('XCEL:toggleHandcuffs', nplayer, true)
                  TriggerClientEvent('XCEL:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              XCELclient.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

function XCEL.handcuffKeys(source)
  local source = source
  local user_id = XCEL.getUserId(source)
  if XCEL.getInventoryItemAmount(user_id, 'handcuffkeys') >= 1 then
    XCELclient.getNearestPlayer(source,{5},function(nplayer)
      if nplayer ~= nil then
        local nplayer_id = XCEL.getUserId(nplayer)
        XCELclient.isHandcuffed(nplayer,{},function(handcuffed)
          if handcuffed then
            XCEL.tryGetInventoryItem(user_id, 'handcuffkeys', 1)
            TriggerClientEvent('XCEL:uncuffAnim', source, nplayer, false)
            TriggerClientEvent('XCEL:unHandcuff', source, false)
            TriggerClientEvent('XCEL:toggleHandcuffs', nplayer, false)
            TriggerClientEvent('XCEL:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
          end
        end)
      else
        XCELclient.notify(source,{lang.common.no_player_near()})
      end
    end)
  end
end

function XCEL.handcuff(source)
  local source = source
  local user_id = XCEL.getUserId(source)
  if XCEL.getInventoryItemAmount(user_id, 'handcuff') >= 1 then
    XCELclient.getNearestPlayer(source,{5},function(nplayer)
      if nplayer ~= nil then
        local nplayer_id = XCEL.getUserId(nplayer)
        XCELclient.isHandcuffed(nplayer,{},function(handcuffed)
          if not handcuffed then
            XCEL.tryGetInventoryItem(user_id, 'handcuff', 1)
            TriggerClientEvent('XCEL:toggleHandcuffs', nplayer, true)
            TriggerClientEvent('XCEL:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
          end
        end)
      else
        XCELclient.notify(source,{lang.common.no_player_near()})
      end
    end)
  end
end

local section60s = {}
RegisterCommand('s60', function(source, args)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.announce') then
        if args[1] ~= nil and args[2] ~= nil then
            local radius = tonumber(args[1])
            local duration = tonumber(args[2])*60
            local section60UUID = #section60s+1
            section60s[section60UUID] = {radius = radius, duration = duration, uuid = section60UUID}
            TriggerClientEvent("XCEL:addS60", -1, GetEntityCoords(GetPlayerPed(source)), radius, section60UUID)
        else
            XCELclient.notify(source,{'~r~Invalid Arguments.'})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(section60s) do
            if section60s[k].duration > 0 then
                section60s[k].duration = section60s[k].duration-1 
            else
                TriggerClientEvent('XCEL:removeS60', -1, section60s[k].uuid)
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand('handbook', function(source, args)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') then
      TriggerClientEvent('XCEL:toggleHandbook', source)
    end
end)

local draggingPlayers = {}

RegisterServerEvent('XCEL:dragPlayer')
AddEventHandler('XCEL:dragPlayer', function(playersrc)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id ~= nil and (XCEL.hasPermission(user_id, "police.armoury") or XCEL.hasPermission(user_id, "hmp.menu")) then
      if playersrc ~= nil then
        local nuser_id = XCEL.getUserId(playersrc)
          if nuser_id ~= nil then
            XCELclient.isHandcuffed(playersrc,{},function(handcuffed)
                if handcuffed then
                    if draggingPlayers[user_id] then
                      TriggerClientEvent("XCEL:undrag", playersrc, source)
                      draggingPlayers[user_id] = nil
                    else
                      TriggerClientEvent("XCEL:drag", playersrc, source)
                      draggingPlayers[user_id] = playersrc
                    end
                else
                    XCELclient.notify(source,{"~r~Player is not handcuffed."})
                end
            end)
          else
              XCELclient.notify(source,{"~r~There is no player nearby"})
          end
      else
          XCELclient.notify(source,{"~r~There is no player nearby"})
      end
    end
end)

RegisterServerEvent('XCEL:putInVehicle')
AddEventHandler('XCEL:putInVehicle', function(playersrc)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id ~= nil and XCEL.hasPermission(user_id, "police.armoury") then
      if playersrc ~= nil then
        XCELclient.isHandcuffed(playersrc,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            XCELclient.putInNearestVehicleAsPassenger(playersrc, {10})
          else
            XCELclient.notify(source,{lang.police.not_handcuffed()})
          end
        end)
      end
    end
end)

RegisterServerEvent('XCEL:ejectFromVehicle')
AddEventHandler('XCEL:ejectFromVehicle', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id ~= nil and XCEL.hasPermission(user_id, "police.armoury") then
      XCELclient.getNearestPlayer(source,{10},function(nplayer)
        local nuser_id = XCEL.getUserId(nplayer)
        if nuser_id ~= nil then
          XCELclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
              XCELclient.ejectVehicle(nplayer, {})
            else
              XCELclient.notify(source,{lang.police.not_handcuffed()})
            end
          end)
        else
          XCELclient.notify(source,{lang.common.no_player_near()})
        end
      end)
    end
end)


RegisterServerEvent("XCEL:Knockout")
AddEventHandler('XCEL:Knockout', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    XCELclient.getNearestPlayer(source, {2}, function(nplayer)
        local nuser_id = XCEL.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('XCEL:knockOut', nplayer)
            SetTimeout(30000, function()
                TriggerClientEvent('XCEL:knockOutDisable', nplayer)
            end)
        end
    end)
end)

RegisterServerEvent("XCEL:KnockoutNoAnim")
AddEventHandler('XCEL:KnockoutNoAnim', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasGroup(user_id, 'Founder') or XCEL.hasGroup(user_id, 'Developer') or XCEL.hasGroup(user_id, 'Lead Developer') or XCEL.hasGroup(user_id, 'Developer') then
      XCELclient.getNearestPlayer(source, {2}, function(nplayer)
          local nuser_id = XCEL.getUserId(nplayer)
          if nuser_id ~= nil then
              TriggerClientEvent('XCEL:knockOut', nplayer)
              SetTimeout(30000, function()
                  TriggerClientEvent('XCEL:knockOutDisable', nplayer)
              end)
          end
      end)
    end
end)

RegisterServerEvent("XCEL:requestPlaceBagOnHead")
AddEventHandler('XCEL:requestPlaceBagOnHead', function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.getInventoryItemAmount(user_id, 'Headbag') >= 1 then
      XCELclient.getNearestPlayer(source, {10}, function(nplayer)
          local nuser_id = XCEL.getUserId(nplayer)
          if nuser_id ~= nil then
              XCEL.tryGetInventoryItem(user_id, 'Headbag', 1, true)
              TriggerClientEvent('XCEL:placeHeadBag', nplayer)
          end
      end)
    end
end)

RegisterServerEvent('XCEL:gunshotTest')
AddEventHandler('XCEL:gunshotTest', function(playersrc)
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id ~= nil and XCEL.hasPermission(user_id, "police.armoury") then
      if playersrc ~= nil then
        XCELclient.hasRecentlyShotGun(playersrc,{}, function(shotagun)
          if shotagun then
            XCELclient.notify(source, {"~r~Player has recently shot a gun."})
          else
            XCELclient.notify(source, {"~r~Player has no gunshot residue on fingers."})
          end
        end)
      end
    end
end)

RegisterServerEvent('XCEL:tryTackle')
AddEventHandler('XCEL:tryTackle', function(id)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') or XCEL.hasPermission(user_id, 'hmp.menu') or XCEL.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent('XCEL:playTackle', source)
        TriggerClientEvent('XCEL:getTackled', id, source)
    end
end)

RegisterCommand('drone', function(source, args)
  local source = source
  local user_id = XCEL.getUserId(source)
  if XCEL.hasGroup(user_id, 'Drone Trained') or XCEL.hasGroup(user_id, 'Lead Developer') or XCEL.hasGroup(user_id, 'Developer') then
      TriggerClientEvent('toggleDrone', source)
  end
end)

RegisterCommand('trafficmenu', function(source, args)
  local source = source
  local user_id = XCEL.getUserId(source)
  if XCEL.hasPermission(user_id, 'police.armoury') or XCEL.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('XCEL:toggleTrafficMenu', source)
  end
end)

RegisterServerEvent('XCEL:startThrowSmokeGrenade')
AddEventHandler('XCEL:startThrowSmokeGrenade', function(name)
    local source = source
    TriggerClientEvent('XCEL:displaySmokeGrenade', -1, name, GetEntityCoords(GetPlayerPed(source)))
end)

RegisterCommand('breathalyse', function(source, args)
  local source = source
  local user_id = XCEL.getUserId(source)
  if XCEL.hasPermission(user_id, 'police.armoury') then
      TriggerClientEvent('XCEL:breathalyserCommand', source)
  end
end)

RegisterServerEvent('XCEL:breathalyserRequest')
AddEventHandler('XCEL:breathalyserRequest', function(temp)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') then
      TriggerClientEvent('XCEL:beingBreathalysed', temp)
      TriggerClientEvent('XCEL:breathTestResult', source, math.random(0, 100), XCEL.GetPlayerName(XCEL.getUserId(temp)))
    end
end)

seizeBullets = {
  ['9mm Bullets'] = true,
  ['7.62mm Bullets'] = true,
  ['.357 Bullets'] = true,
  ['12 Gauge Bullets'] = true,
  ['.308 Sniper Rounds'] = true,
  ['5.56mm NATO'] = true,
}

RegisterServerEvent('XCEL:seizeWeapons')
AddEventHandler('XCEL:seizeWeapons', function(playerSrc)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') then
      XCELclient.isHandcuffed(playerSrc,{},function(handcuffed)
        if handcuffed then
          RemoveAllPedWeapons(GetPlayerPed(playerSrc), true)
          local player_id = XCEL.getUserId(playerSrc)
          local cdata = XCEL.getUserDataTable(player_id)
          for a,b in pairs(cdata.inventory) do
              if string.find(a, 'wbody|') then
                  c = a:gsub('wbody|', '')
                  cdata.inventory[c] = b
                  cdata.inventory[a] = nil
              end
          end
          for k,v in pairs(a.weapons) do
              if cdata.inventory[k] ~= nil then
                  if not v.policeWeapon then
                    cdata.inventory[k] = nil
                  end
              end
          end
          for c,d in pairs(cdata.inventory) do
              if seizeBullets[c] then
                cdata.inventory[c] = nil
              end
          end
          TriggerEvent('XCEL:RefreshInventory', playerSrc)
          XCELclient.notify(source, {'Seized weapons.'})
          XCELclient.notify(playerSrc, {'Your weapons have been seized.'})
        end
      end)
    end
end)

seizeDrugs = {
  ['Weed leaf'] = true,
  ['Weed'] = true,
  ['Coca leaf'] = true,
  ['Cocaine'] = true,
  ['Opium Poppy'] = true,
  ['Heroin'] = true,
  ['Ephedra'] = true,
  ['Meth'] = true,
  ['Frogs legs'] = true,
  ['Lysergic Acid Amide'] = true,
  ['LSD'] = true,
}
RegisterServerEvent('XCEL:seizeIllegals')
AddEventHandler('XCEL:seizeIllegals', function(playerSrc)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') then
      local player_id = XCEL.getUserId(playerSrc)
      local cdata = XCEL.getUserDataTable(player_id)
      for a,b in pairs(cdata.inventory) do
          for c,d in pairs(seizeDrugs) do
              if a == c then
                cdata.inventory[a] = nil
              end
          end
      end
      TriggerEvent('XCEL:RefreshInventory', playerSrc)
      XCELclient.notify(source, {'~r~Seized illegals.'})
      XCELclient.notify(playerSrc, {'~r~Your illegals have been seized.'})
    end
end)

RegisterServerEvent("XCEL:newPanic")
AddEventHandler("XCEL:newPanic", function(a,b)
	local source = source
	local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id, 'police.armoury') or XCEL.hasPermission(user_id, 'hmp.menu') or XCEL.hasPermission(user_id, 'nhs.menu') or XCEL.hasPermission(user_id, 'lfb.onduty.permission') then
        TriggerClientEvent("XCEL:returnPanic", -1, nil, a, b)
        XCEL.sendWebhook(getPlayerFaction(user_id)..'-panic', 'XCEL Panic Logs', "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Location: **"..a.Location.."**")
    end
end)

RegisterNetEvent("XCEL:flashbangThrown")
AddEventHandler("XCEL:flashbangThrown", function(coords)   
    TriggerClientEvent("XCEL:flashbangExplode", -1, coords)
end)

RegisterNetEvent("XCEL:updateSpotlight")
AddEventHandler("XCEL:updateSpotlight", function(a)  
  local source = source 
  TriggerClientEvent("XCEL:updateSpotlight", -1, source, a)
end)

RegisterCommand('wc', function(source, args)
  local source = source
  local user_id = XCEL.getUserId(source)
  if XCEL.hasPermission(user_id, 'police.armoury') then
    XCELclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        XCELclient.getPoliceCallsign(source, {}, function(callsign)
          XCELclient.getPoliceRank(source, {}, function(rank)
            XCELclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            XCELclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank.."\n~b~Name: ~w~"..XCEL.GetPlayerName(user_id),"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('XCEL:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)

RegisterCommand('wca', function(source, args)
  local source = source
  local user_id = XCEL.getUserId(source)
  if XCEL.hasPermission(user_id, 'police.armoury') then
    XCELclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        XCELclient.getPoliceCallsign(source, {}, function(callsign)
          XCELclient.getPoliceRank(source, {}, function(rank)
            XCELclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            XCELclient.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank,"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('XCEL:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)
