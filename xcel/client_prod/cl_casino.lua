insideDiamondCasino = false
AddEventHandler(
    "XCEL:onClientSpawn",
    function(a, b)
        if b then
            local c = vector3(1121.7922363281, 239.42251586914, -50.440742492676)
            local d = function(e)
                insideDiamondCasino = true
                tXCEL.setCanAnim(false)
                tXCEL.overrideTime(12, 0, 0)
                TriggerEvent("XCEL:enteredDiamondCasino")
                TriggerServerEvent("XCEL:getChips")
            end
            local f = function(e)
                insideDiamondCasino = false
                tXCEL.setCanAnim(true)
                tXCEL.cancelOverrideTimeWeather()
                TriggerEvent("XCEL:exitedDiamondCasino")
            end
            local g = function(e)
            end
            tXCEL.createArea("diamondcasino", c, 100.0, 20, d, f, g, {})
        end
    end
)
