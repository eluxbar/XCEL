AddEventHandler(
    "onClientMapStart",
    function()
        exports.xcel:setAutoSpawn(false)
        exports.xcel:spawnPlayer()
        SetClockTime(24, 0, 0)
    end
)
