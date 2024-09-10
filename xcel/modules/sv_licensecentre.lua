
local cfg = module("cfg/cfg_licensecentre")

RegisterServerEvent("LicenseCentre:BuyGroup")
AddEventHandler('LicenseCentre:BuyGroup', function(job, name)
    local source = source
    local user_id = XCEL.getUserId(source)
    local coords = cfg.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if not XCEL.hasGroup(user_id, "Rebel") and job == "AdvancedRebel" then
        XCELclient.notify(source, {"~r~You need to have Rebel License."})
        return
    end
    if #(playerCoords - coords) <= 15.0 then
        if XCEL.hasGroup(user_id, job) then 
            XCELclient.notify(source, {"~o~You have already purchased this license!"})
            TriggerClientEvent("xcel:PlaySound", source, 2)
        else
            for k,v in pairs(cfg.licenses) do
                if v.group == job then
                    if XCEL.tryFullPayment(user_id, v.price) then
                        XCEL.addUserGroup(user_id,job)
                        XCELclient.notify(source, {"~g~Purchased " .. name .. " for ".. '£' ..tostring(getMoneyStringFormatted(v.price)) .. " ❤️"})
                        XCEL.sendWebhook('purchases',"XCEL License Centre Logs", "> Player Name: **"..XCEL.GetPlayerName(user_id).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**")
                        TriggerClientEvent("xcel:PlaySound", source, 1)
                        TriggerClientEvent("XCEL:gotOwnedLicenses", source, getLicenses(user_id))
                        TriggerClientEvent("XCEL:refreshGunStorePermissions", source)
                    else 
                        XCELclient.notify(source, {"~r~You do not have enough money to purchase this license!"})
                        TriggerClientEvent("xcel:PlaySound", source, 2)
                    end
                end
            end
        end
    else 
        XCEL.ACBan(15,user_id,'LicenseCentre:BuyGroup')
    end
end)



function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

function getLicenses(user_id)
    local licenses = {}
    if user_id ~= nil then
        for k, v in pairs(cfg.licenses) do
            if XCEL.hasGroup(user_id, v.group) then
                table.insert(licenses, v.name)
            end
        end
        return licenses
    end
end

RegisterNetEvent("XCEL:GetLicenses")
AddEventHandler("XCEL:GetLicenses", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("XCEL:RecievedLicenses", source, getLicenses(user_id))
    end
end)

RegisterNetEvent("XCEL:getOwnedLicenses")
AddEventHandler("XCEL:getOwnedLicenses", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("XCEL:gotOwnedLicenses", source, getLicenses(user_id))
    end
end)