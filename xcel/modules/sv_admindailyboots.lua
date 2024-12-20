bootinformation = {time = {hour = "12",minute = "00"},reward = {money = 5000000,items = {["wbody|WEAPON_MOSIN"] = 1,["7.62mm Bullets"] = 250}}}
table1 = {Claimed = {},Processing = {}}
BootRedeemable = false
local weapons = module("cfg/weapons").weapons
local weapontable = {
    weapons = {
        ["WEAPON_MOSIN"] = {
            wepname = "Mosin Nagant",
            weight = 7.5,
            checked = false,
        },
        ["WEAPON_AK200"] = {
            wepname = "AK200",
            weight = 7.5,
            checked = false,
        },
        ["WEAPON_SVD"] = {
            wepname = "SVD",
            weight = 7.5,
            checked = false,
        },
    },
    ammo = {
        ["7.62mm Bullets"] = {
            wepname = "7.62mm Bullets",
            weight = 0.01,
            checked = false,
        },
        
    },
}


RegisterCommand("admindailyboots",function(source,args,raw)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id,"admin.dailyboot")  then
        tableinformation= {
            claimed = #table1.Claimed,
            time = bootinformation.time,
            money = bootinformation.reward.money,
            items = bootinformation.reward.items
        }
        TriggerClientEvent("XCEL:ReturnAdminBootTable", source, tableinformation,weapontable)
    else
        XCELclient.notify(source,{"You do not have permission to do this!"})
    end
end)


RegisterServerEvent("XCEL:RequestChange",function(index)
    local source = source
    local user_id = XCEL.getUserId(source)
    if XCEL.hasPermission(user_id,"admin.dailyboot")  then
        if index == "openingtime" then
            XCEL.prompt(source,"Enter Hour","",function(source,hour)
                if tonumber(hour) ~= nil and tonumber(hour) >= 0 and tonumber(hour) <= 23 then
                    XCEL.prompt(source,"Enter Minute","",function(source,minute)
                        if tonumber(minute) ~= nil and tonumber(minute) >= 0 and tonumber(minute) <= 59 then
                            bootinformation.time.hour = tonumber(hour)
                            bootinformation.time.minute = tonumber(minute)
                            RefreshBootData()
                            XCELclient.notify(source,{"Opening time changed to "..string.format("%02d:%02d", tonumber(hour), tonumber(minute))})
                        else
                            XCELclient.notify(source,{"~r~Please enter a valid minute!"})
                        end
                    end)
                else
                    XCELclient.notify(source,{"~r~Please enter a valid hour!"})
                end
            end)
        elseif index == "moneyreward" then
            XCEL.prompt(source,"Enter Amount","",function(source,money)
                if tonumber(money) ~= nil and tonumber(money) >= 0 then
                    bootinformation.reward.money = tonumber(money)
                    RefreshBootData()
                    XCELclient.notify(source,{"Money reward changed to "..getMoneyStringFormatted(tonumber(money))})
                else
                    XCELclient.notify(source,{"~r~Please enter a valid amount!"})
                end
            end)
        end
    else
        XCELclient.notify(source,{"~r~You do not have permission to do this!"})
    end
end)


function RefreshBootData()
    tableinformation= {claimed = #table1.Claimed,time = bootinformation.time,money = bootinformation.reward.money,items = bootinformation.reward.items}
    TriggerClientEvent("XCEL:RefreshBootData", -1, tableinformation)
end

Citizen.CreateThread(function()
    while true do
        local time = os.date("*t")
        if time["hour"] == bootinformation.time.hour and time["min"] == bootinformation.time.minute and not BootRedeemable then
            table1.Claimed = {}
            BootRedeemable = true
            XCELclient.notify(-1,{"~g~You can now claim your boot\nUse /dailyboot"})
        end
        if time["hour"] == bootinformation.time.hour and time["min"] == bootinformation.time.minute + 1 and BootRedeemable then
            BootRedeemable = false
            XCELclient.notify(-1,{"~r~You can no longer claim your boot"})
        end
        Citizen.Wait(10000)
    end
end)
