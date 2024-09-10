local a = {}
RegisterNetEvent("XCEL:receiveCurrentPlayerInfo")
AddEventHandler(
    "XCEL:receiveCurrentPlayerInfo",
    function(b)
        a = b
    end
)
function tXCEL.getCurrentPlayerInfo(c)
    for d, e in pairs(a) do
        if d == c then
            return e
        end
    end
end
function tXCEL.clientGetPlayerIsStaff(f)
    local g = tXCEL.getCurrentPlayerInfo("currentStaff")
    if g then
        for h, i in pairs(g) do
            if i == f then
                return true
            end
        end
        return false
    end
end
