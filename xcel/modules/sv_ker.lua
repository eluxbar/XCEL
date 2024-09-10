local garages = module("xcel-vehicles", "cfg/cfg_garages")
local vehicle_groups = garages.garages

function XCEL.getVehicleModel(x)
    for _, a in pairs(vehicle_groups) do
        for b, c in pairs(a) do
            if x == b then
                return c[1]
            end
        end
    end
end

exports('getVehicleModel',XCEL.getVehicleModel)

local dailyAmount = math.random(2000000, 5000000)

local function generateFixedTimes()
    local times = {}
    for hour = 0, 21, 3 do
        table.insert(times, {notifyHour = hour, notifyMin = 0, dropHour = (hour + 3) % 24, dropMin = 0})
    end
    return times
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t")
        for _, t in ipairs(generateFixedTimes()) do
            if tonumber(time["hour"]) == t.notifyHour and tonumber(time["min"]) == t.notifyMin and tonumber(time["sec"]) == 0 then
                for k, v in pairs(XCEL.getUsers()) do
                    if XCEL.getUserSource(k) then
                        XCELclient.notify(XCEL.getUserSource(k), {"~y~Daily money drop will occur in 3 hours!"})
                    end
                end
            elseif tonumber(time["hour"]) == t.dropHour and tonumber(time["min"]) == t.dropMin and tonumber(time["sec"]) == 0 then
                for k, v in pairs(XCEL.getUsers()) do
                    if XCEL.getUserSource(k) then
                        XCELclient.notify(XCEL.getUserSource(k), {"~g~Received £" .. getMoneyStringFormatted(dailyAmount) .. " from the daily money drop."})
                        XCEL.giveBankMoney(k, dailyAmount)
                    end
                end
                dailyAmount = math.random(2000000, 5000000)
            end
        end
    end
end)