local f = module("cfg/weapons")
f = f.weapons
illegalWeapons = f.nativeWeaponModelsToNames

function getWeaponName(weapon)
    for k,v in pairs(f) do
        if weapon == 'Mosin Nagant' then
            return 'Heavy'
        elseif weapon == 'Nerf Mosin' then
            return 'Heavy'
        elseif weapon == 'Black Ice Mosin' then
            return 'Heavy'
        elseif weapon == 'Cherry Mosin' then
            return 'Heavy'
        elseif weapon == 'Fists' then
            return 'Fist'
        elseif weapon == 'Fire' then
            return 'Fire'
        elseif weapon == 'Explosion' then
            return 'Explode'
        elseif weapon == 'Suicide' then
            return 'Suicide'
        end
        if v.name == weapon then
            return v.class
        end
    end
    return "Unknown"
end

local function getweaponnames(weapon)
    for k,v in pairs(f) do
        if v.name == weapon then
            return v.name
        end
    end
    return "Unknown"
end

local function triggerbotCheck(weaponhash, killer, source)
    local c = getWeaponName(weaponhash)
    if c ~= 'Fist' and c ~= 'Fire' and c ~= 'Explode' and c ~= 'Melee' and not XCELclient.isEmergencyService(killer,{XCEL.getUserId(killer)}) and killer ~= source then
        return true
    end
end

RegisterNetEvent('XCEL:onPlayerKilled')
AddEventHandler('XCEL:onPlayerKilled', function(killtype, killer, weaponhash, suicide, distance, headshotKill)
    local source = source
    local killergroup = 'none'
    local killedgroup = 'none'
    local killer_id = XCEL.getUserId(killer)
    local killer_name = XCEL.GetPlayerName(killer_id)
    if distance ~= nil then
        distance = math.floor(distance)
    end 
    if not XCEL.InEvent(XCEL.getUserId(source)) then
        if not XCEL.inWager(source) then
            if not XCEL.inArena(source) then
                if killtype == 'killed' then
                    if XCEL.hasPermission(XCEL.getUserId(source), 'police.armoury') then
                        killedgroup = 'police'
                    elseif XCEL.hasPermission(XCEL.getUserId(source), 'nhs.menu') then
                        killedgroup = 'nhs'
                    end

                    if XCEL.hasPermission(XCEL.getUserId(killer), 'police.armoury') then
                        killergroup = 'police'
                    elseif XCEL.hasPermission(XCEL.getUserId(killer), 'nhs.menu') then
                        killergroup = 'nhs'
                    end

                    if killer ~= nil then
                        for k,v in pairs(GetPlayers()) do
                            if GetPlayerRoutingBucket(v) == GetPlayerRoutingBucket(source) then
                                TriggerClientEvent('XCEL:newKillFeed', v, XCEL.GetPlayerName(killer_id), XCEL.GetPlayerName(XCEL.getUserId(source)), getWeaponName(weaponhash), suicide, distance, killedgroup, killergroup, headshotKill)
                            end
                        end
                        TriggerClientEvent('XCEL:deathSound', -1, GetEntityCoords(GetPlayerPed(source)))
                        if XCEL.isPurge() then
                            TriggerEvent("XCEL:AddKill", killer_id)
                        end
                        if triggerbotCheck(weaponhash, killer, source) then
                            XCELclient.getPlayerCombatTimer(killer,{},function(currentTimer,inCombat)
                                if currentTimer < 58 or not isInCombat then
                                    TriggerClientEvent("XCEL:takeClientScreenshotAndUpload", killer, XCEL.getWebhook("trigger-bot"))
                                    Citizen.Wait(1500)
                                    XCEL.sendWebhook("trigger-bot", "XCEL Trigger Bot Logs", "> Player Name: **"..XCEL.GetPlayerName(killer_id).."**\n> Player User ID: **"..XCEL.getUserId(killer).."**")
                                end
                            end)
                        end
                        if not XCEL.isPurge() then
                            if not gettingVideo then
                                gettingVideo = true
                                TriggerClientEvent("XCEL:takeClientVideoAndUpload", killer, XCEL.getWebhook('killvideo'))
                                gettingVideo = false
                                Wait(19000)
                            end
                        end
                        if XCEL.GetPlayerName(killer_id) and XCEL.GetPlayerName(XCEL.getUserId(source)) and XCEL.getUserId(killer) and XCEL.getUserId(source) and getweaponnames(weaponhash) and distance then
                            XCEL.sendWebhook('kills', "XCEL Kill Logs", "> Killer Name: **"..XCEL.GetPlayerName(killer_id).."**\n> Killer ID: **"..XCEL.getUserId(killer).."**\n> Weapon: **"..getweaponnames(weaponhash).."**\n> Victim Name: **"..XCEL.GetPlayerName(XCEL.getUserId(source)).."**\n> Victim ID: **"..XCEL.getUserId(source).."**\n> Distance: **"..distance.."m**")
                        end
                    else
                        for k,v in pairs(GetPlayers()) do
                            if GetPlayerRoutingBucket(v) == GetPlayerRoutingBucket(source) then
                                TriggerClientEvent('XCEL:newKillFeed', v, XCEL.GetPlayerName(XCEL.getUserId(source)), XCEL.GetPlayerName(XCEL.getUserId(source)), 'suicide', suicide, distance, killedgroup, killergroup)
                            end
                        end
                        TriggerClientEvent('XCEL:deathSound', -1, GetEntityCoords(GetPlayerPed(source)))
                    end
                end
            else
                XCEL.ManageArenaDeath(source,killer)
            end
        else
            XCEL.handleWagerDeath(source, killer)
            if killer ~= nil then
                for k,v in pairs(GetPlayers()) do
                    if GetPlayerRoutingBucket(v) == GetPlayerRoutingBucket(source) then
                        TriggerClientEvent('XCEL:newKillFeed', v, XCEL.GetPlayerName(killer_id), XCEL.GetPlayerName(XCEL.getUserId(source)), getWeaponName(weaponhash), suicide, distance, killedgroup, killergroup, headshotKill)
                    end
                end
            end
        end
    else
        XCEL.diedInEvent(source,killer)
        if killer ~= nil then
            for k,v in pairs(GetPlayers()) do
                if GetPlayerRoutingBucket(v) == GetPlayerRoutingBucket(source) then
                    TriggerClientEvent('XCEL:newKillFeed', v, XCEL.GetPlayerName(killer_id), XCEL.GetPlayerName(XCEL.getUserId(source)), getWeaponName(weaponhash), suicide, distance, killedgroup, killergroup, headshotKill)
                end
            end
        end
    end
end)

AddEventHandler('weaponDamageEvent', function(sender, ev)
    local user_id = XCEL.getUserId(sender)

    -- Check if user_id is not nil
    if user_id then
        local name = XCEL.GetPlayerName(user_id)
        if ev.weaponDamage ~= 0 then
            -- if ev.weaponType == 911657153 and not XCEL.hasPermission(user_id, 'police.armoury') or ev.weaponType == 3452007600 then
            --     XCEL.ACBan(5,user_id,'Using a weapon that is not allowed')
            -- end
            if ev.weaponType == 133987706 then
                print("Weapon Type 133987706 has been flagged by " ..name.. " | " ..user_id)
            end
            XCEL.sendWebhook('damage', "XCEL Damage Logs", "> Player Name: **"..name.."**\n> Player Temp ID: **"..sender.."**\n> Player Perm ID: **"..user_id.."**\n> Damage: **"..ev.weaponDamage.."**\n> Weapon : **"..getweaponnames(ev.weaponType).."**")
        end
    else
        -- Handle the case where user_id is nil
        print("Error: user_id is nil for sender " .. tostring(sender))
    end
end)
