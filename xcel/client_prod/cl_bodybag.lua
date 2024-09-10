RegisterCommand(
    "bodybag",
    function()
        local a = tXCEL.getNearestPlayer(3)
        if a then
            TriggerServerEvent("XCEL:requestBodyBag", a)
        else
            tXCEL.notify("No one dead nearby")
        end
    end
)
RegisterNetEvent(
    "XCEL:removeIfOwned",
    function(b)
        local c = tXCEL.getObjectId(b, "bodybag_removeIfOwned")
        if c then
            if DoesEntityExist(c) then
                if NetworkHasControlOfEntity(c) then
                    DeleteEntity(c)
                end
            end
        end
    end
)
RegisterNetEvent(
    "XCEL:placeBodyBag",
    function()
        local d = tXCEL.getPlayerPed()
        local e = GetEntityCoords(d)
        local f = GetEntityHeading(d)
        SetEntityVisible(d, false, 0)
        local g = tXCEL.loadModel("xm_prop_body_bag")
        local h = CreateObject(g, e.x, e.y, e.z, true, true, true)
        DecorSetInt(h, decor, 955)
        PlaceObjectOnGroundProperly(h)
        SetModelAsNoLongerNeeded(g)
        local b = ObjToNet(h)
        TriggerServerEvent("XCEL:removeBodybag", b)
        while GetEntityHealth(tXCEL.getPlayerPed()) <= 102 do
            Wait(0)
        end
        DeleteEntity(h)
        SetEntityVisible(d, true, 0)
    end
)
