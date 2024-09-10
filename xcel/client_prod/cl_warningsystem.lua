local a = {}
local b = 0
local c = {}
function func_f10warnings()
    if not recordingMode then
        if IsControlJustPressed(0, 57) then
            TriggerServerEvent("XCEL:refreshWarningSystem")
            Citizen.Wait(100)
            SetNuiFocus(true, true)
            SendNUIMessage({showF10 = true})
        end
    end
end
RegisterNUICallback(
    "closeXCELF10",
    function(b, d)
        TriggerScreenblurFadeOut(100.0)
        SetNuiFocus(false, false)
    end
)
tXCEL.createThreadOnTick(func_f10warnings)
RegisterNetEvent("XCEL:recievedRefreshedWarningData")
AddEventHandler(
    "XCEL:recievedRefreshedWarningData",
    function(e, f, g)
        a = e
        c = g
        SendNUIMessage({type = "sendWarnings", warnings = json.encode(a), points = f, info = json.encode(c)})
    end
)
RegisterNetEvent("XCEL:showWarningsOfUser")
AddEventHandler(
    "XCEL:showWarningsOfUser",
    function(e, f, g)
        a = e
        c = g
        SendNUIMessage({type = "sendWarnings", warnings = json.encode(a), points = f, info = json.encode(c)})
        SendNUIMessage({showF10 = true})
        SetNuiFocus(true, true)
    end
)
