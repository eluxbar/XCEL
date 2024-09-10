local lookup = {
    ["XCELELS:changeStage"] = "XCELELS:1",
    ["XCELELS:toggleSiren"] = "XCELELS:2",
    ["XCELELS:toggleBullhorn"] = "XCELELS:3",
    ["XCELELS:patternChange"] = "XCELELS:4",
    ["XCELELS:vehicleRemoved"] = "XCELELS:5",
    ["XCELELS:indicatorChange"] = "XCELELS:6"
}

local origRegisterNetEvent = RegisterNetEvent
RegisterNetEvent = function(name, callback)
    origRegisterNetEvent(lookup[name], callback)
end

if IsDuplicityVersion() then
    local origTriggerClientEvent = TriggerClientEvent
    TriggerClientEvent = function(name, target, ...)
        origTriggerClientEvent(lookup[name], target, ...)
    end

    TriggerClientScopeEvent = function(name, target, ...)
        exports["xcel"]:TriggerClientScopeEvent(lookup[name], target, ...)
    end
else
    local origTriggerServerEvent = TriggerServerEvent
    TriggerServerEvent = function(name, ...)
        origTriggerServerEvent(lookup[name], ...)
    end
end