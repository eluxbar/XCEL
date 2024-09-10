

function XCEL.GetWarnings(user_id, source)
    local xcelwarningstables = exports['xcel']:executeSync("SELECT * FROM xcel_warnings WHERE user_id = @uid", { uid = user_id })
    for warningID, warningTable in pairs(xcelwarningstables) do
        local date = warningTable["warning_date"]
        local newdate = tonumber(date) / 1000
        newdate = os.date('%Y-%m-%d', newdate)
        warningTable["warning_date"] = newdate
		local points = warningTable["point"]
    end
    return xcelwarningstables
end




function XCEL.AddWarnings(target_id, adminName, warningReason, warning_duration, point)
    if warning_duration == -1 then
        warning_duration = 0
    end
    exports['xcel']:execute("INSERT INTO xcel_warnings (`user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`, `point`) VALUES (@user_id, @warning_type, @duration, @admin, @warning_date, @reason, @point);", { user_id = target_id, warning_type = "Ban", admin = adminName, duration = warning_duration, warning_date = os.date("%Y/%m/%d"), reason = warningReason, point = point })
end



RegisterServerEvent("XCEL:refreshWarningSystem")
AddEventHandler("XCEL:refreshWarningSystem", function()
    local source = source
    local user_id = XCEL.getUserId(source)
    local xcelwarningstables = XCEL.GetWarnings(user_id, source)
    local a = exports['xcel']:executeSync("SELECT * FROM xcel_bans_offenses WHERE UserID = @uid", { uid = user_id })
    for k, v in pairs(a) do
        if v.UserID == user_id then
            for warningID, warningTable in pairs(xcelwarningstables) do
                warningTable["points"] = v.points
            end
            local info = { user_id = user_id, playtime = XCEL.GetPlayTime(user_id) }
            TriggerClientEvent("XCEL:recievedRefreshedWarningData", source, xcelwarningstables, v.points, info)
        end
    end
end)

RegisterCommand('sw', function(source, args)
    local user_id = XCEL.getUserId(source)
    local user_id = tonumber(args[1])
    if user_id then
        if XCEL.hasPermission(user_id, "admin.tickets") then
            local xcelwarningstables = XCEL.GetWarnings(user_id, source)
            local a = exports['xcel']:executeSync("SELECT * FROM xcel_bans_offenses WHERE UserID = @uid", { uid = user_id })
            for k, v in pairs(a) do
                if v.UserID == user_id then
                    for warningID, warningTable in pairs(xcelwarningstables) do
                        warningTable["points"] = v.points
                    end
                    local info = { user_id = user_id, playtime = XCEL.GetPlayTime(user_id) }
                    TriggerClientEvent("XCEL:showWarningsOfUser", source, xcelwarningstables, v.points, info)
                end
            end
        end
    end
end)
