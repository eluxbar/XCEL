local lastMoneyAmount = 0

local function AddApp()
    exports["lb-phone"]:AddCustomApp({
        identifier = "offshore",
        name = "Offshore",
        description = "Offshore Banking",
        developer = "Kerr",
        defaultApp = true,
        size = 59812,
        images = {},
        ui = GetCurrentResourceName() .. "/ui/dist/index.html",
        icon = "https://cfx-nui-" .. GetCurrentResourceName() .. "/ui/icon.png"
    })
end

local function updatePrivateMoney(amount)
    exports["lb-phone"]:SendCustomAppMessage("offshore", {
        type = "setPrivateMoney",
        amount = math.floor(amount)
    })
end

CreateThread(function ()
    while GetResourceState("lb-phone") ~= "started" do
        Wait(500)
    end

    AddApp()

    AddEventHandler("onResourceStart", function(resource)
        if resource == "lb-phone" then
            AddApp()
        end
    end)
    
    RegisterNetEvent("XCEL:setDisplayOffshore", function(value)
        if GetResourceState("lb-phone") == "started" then
            lastMoneyAmount = value
            updatePrivateMoney(value)
        end
    end)

    RegisterNUICallback("depositOffshoreMoney", function(data, cb)
        if data.moneyAmount then
            local moneyAmount = tonumber(data.moneyAmount)
            if moneyAmount then
                TriggerServerEvent("XCEL:depositOffshoreMoney", moneyAmount)
            end
        end
        cb("ok")
    end)

    RegisterNUICallback("depositAllOffshoreMoney", function(data, cb)
        TriggerServerEvent("XCEL:depositAllOffshoreMoney")
        cb("ok")
    end)

    RegisterNUICallback("withdrawOffshoreMoney", function(data, cb)
        if data.moneyAmount then
            local moneyAmount = tonumber(data.moneyAmount)
            if moneyAmount then
                TriggerServerEvent("XCEL:withdrawOffshoreMoney", moneyAmount)
            end
        end
        cb("ok")
    end)

    RegisterNUICallback("withdrawAllOffshoreMoney", function(data, cb)
        TriggerServerEvent("XCEL:withdrawAllOffshoreMoney")
        cb("ok")
    end)

    RegisterNUICallback("getOffshoreMoney", function(data, cb)
        updatePrivateMoney(lastMoneyAmount)
        cb("ok")
    end)
end)