local cfg=module("cfg/cfg_groupselector")

function XCEL.getJobSelectors(source)
    local source=source
    local jobSelectors={}
    local user_id = XCEL.getUserId(source)
    for k,v in pairs(cfg.selectors) do
        for i,j in pairs(cfg.selectorTypes) do
            if v.type == i then
                if j._config.permissions[1]~=nil then
                    if XCEL.hasPermission(XCEL.getUserId(source),j._config.permissions[1])then
                        v['_config'] = j._config
                        v['jobs'] = {}
                        for a,b in pairs(j.jobs) do
                            if XCEL.hasGroup(user_id, b[1]) then
                                table.insert(v['jobs'], b)
                            end
                        end
                        jobSelectors[k] = v
                    end
                else
                    v['_config'] = j._config
                    v['jobs'] = j.jobs
                    jobSelectors[k] = v
                end
            end
        end
    end
    TriggerClientEvent("XCEL:gotJobSelectors",source,jobSelectors)
end

RegisterNetEvent("XCEL:getJobSelectors")
AddEventHandler("XCEL:getJobSelectors",function()
    local source = source
    XCEL.getJobSelectors(source)
end)

function XCEL.removeAllJobs(user_id)
    local source = XCEL.getUserSource(user_id)
    for i,j in pairs(cfg.selectorTypes) do
        for k,v in pairs(j.jobs)do
            if i == 'default' and XCEL.hasGroup(user_id, v[1]) then
                XCEL.removeUserGroup(user_id, v[1])
            elseif i ~= 'default' and XCEL.hasGroup(user_id, v[1]..' Clocked') then
                XCEL.removeUserGroup(user_id, v[1]..' Clocked')
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                XCELclient.setArmour(source, {0})
                TriggerEvent('XCEL:clockedOffRemoveRadio', source)
            end
        end
    end
    -- remove all faction ranks
    XCELclient.setPolice(source, {false})
    TriggerClientEvent('XCEL:globalOnPoliceDuty', source, false)
    XCELclient.setNHS(source, {false})
    TriggerClientEvent('XCEL:globalOnNHSDuty', source, false)
    XCELclient.setHMP(source, {false})
    TriggerClientEvent('XCEL:globalOnPrisonDuty', source, false)
    XCELclient.setLFB(source, {false})
    XCEL.updateCurrentPlayerInfo()
    TriggerClientEvent('XCEL:disableFactionBlips', source)
    TriggerClientEvent('XCEL:radiosClearAll', source)
    TriggerClientEvent('XCEL:toggleTacoJob', source, false)
end

RegisterNetEvent("XCEL:jobSelector")
AddEventHandler("XCEL:jobSelector",function(a,b)
    local source = source
    local user_id = XCEL.getUserId(source)
    if #(GetEntityCoords(GetPlayerPed(source)) - cfg.selectors[a].position) > 20 then
        --TriggerEvent("XCEL:acBan", user_id, 11, XCEL.GetPlayerName(user_id), source, 'Triggering job selections from too far away')
        return
    end
    if b == "Unemployed" then
        XCEL.removeAllJobs(user_id)
        XCELclient.notify(source, {"~g~You are now unemployed."})
    else
        if cfg.selectors[a].type == 'police' then
            if XCEL.hasGroup(user_id, b) then
                XCEL.removeAllJobs(user_id)
                XCEL.addUserGroup(user_id,b..' Clocked')
                XCELclient.setPolice(source, {true})
                TriggerClientEvent('XCEL:globalOnPoliceDuty', source, true)
                XCELclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                XCEL.sendWebhook('pd-clock', 'XCEL Police Clock On Logs',"> Officer Name: **"..XCEL.GetPlayerName(user_id).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                XCELclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'nhs' then
            if XCEL.hasGroup(user_id, b) then
                XCEL.removeAllJobs(user_id)
                XCEL.addUserGroup(user_id,b..' Clocked')
                XCELclient.setNHS(source, {true})
                TriggerClientEvent('XCEL:globalOnNHSDuty', source, true)
                XCELclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                XCEL.sendWebhook('nhs-clock', 'XCEL NHS Clock On Logs',"> Medic Name: **"..XCEL.GetPlayerName(user_id).."**\n> Medic TempID: **"..source.."**\n> Medic PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                XCELclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'lfb' then
            if XCEL.hasGroup(user_id, b) then
                XCEL.removeAllJobs(user_id)
                XCEL.addUserGroup(user_id,b..' Clocked')
                XCELclient.setLFB(source, {true})
                XCELclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                XCEL.sendWebhook('lfb-clock', 'XCEL LFB Clock On Logs',"> Firefighter Name: **"..XCEL.GetPlayerName(user_id).."**\n> Firefighter TempID: **"..source.."**\n> Firefighter PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                XCELclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'hmp' then
            if XCEL.hasGroup(user_id, b) then
                XCEL.removeAllJobs(user_id)
                XCEL.addUserGroup(user_id,b..' Clocked')
                XCELclient.setHMP(source, {true})
                TriggerClientEvent('XCEL:globalOnPrisonDuty', source, true)
                XCELclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                XCEL.sendWebhook('hmp-clock', 'XCEL HMP Clock On Logs',"> Prison Officer Name: **"..XCEL.GetPlayerName(user_id).."**\n> Prison Officer TempID: **"..source.."**\n> Prison Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                XCELclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        else
            XCEL.removeAllJobs(user_id)
            XCEL.addUserGroup(user_id,b)
            XCELclient.notify(source, {"~g~Employed as "..b.."."})
            TriggerClientEvent('XCEL:jobInstructions',source,b)
            if b == 'Taco Seller' then
                TriggerClientEvent('XCEL:toggleTacoJob', source, true)
            end
        end
        TriggerEvent('XCEL:clockedOnCreateRadio', source)
        TriggerClientEvent('XCEL:radiosClearAll', source)
        TriggerClientEvent('XCEL:refreshGunStorePermissions', source)
        XCEL.updateCurrentPlayerInfo()
    end
end)