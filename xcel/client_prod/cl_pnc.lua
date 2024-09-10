RegisterNUICallback(
    "exit",
    function(a)
        SetDisplay(false)
        stopAnim()
    end
)
RegisterNUICallback(
    "personsearch",
    function(a)
        TriggerServerEvent("XCEL:searchPerson", a.firstname, a.lastname)
    end
)
RegisterNUICallback(
    "platesearch",
    function(a)
        TriggerServerEvent("XCEL:searchPlate", a.plate)
    end
)
RegisterNUICallback(
    "submitfine",
    function(a)
        TriggerServerEvent("XCEL:finePlayer", a.user_id, a.charges, a.amount, a.notes)
    end
)
RegisterNUICallback(
    "addnote",
    function(a)
        TriggerServerEvent("XCEL:addNote", a.user_id, a.note)
    end
)
RegisterNUICallback(
    "removenote",
    function(a)
        TriggerServerEvent("XCEL:removeNote", a.user_id, a.note)
    end
)
RegisterNUICallback(
    "addattentiondrawn",
    function(a)
        TriggerServerEvent("XCEL:addAttentionDrawn", a)
    end
)
RegisterNUICallback(
    "removeattentiondrawn",
    function(a)
        TriggerServerEvent("XCEL:removeAttentionDrawn", a.ad)
    end
)
RegisterNUICallback(
    "savenotes",
    function(a)
        TriggerServerEvent("XCEL:updateVehicleNotes", a.notes, a.user_id, a.vehicle)
    end
)
RegisterNUICallback(
    "savepersonnotes",
    function(a)
        TriggerServerEvent("XCEL:updatePersonNote", a.user_id, a.notes)
    end
)
RegisterNUICallback(
    "generatewarrant",
    function(a)
        TriggerServerEvent("XCEL:getWarrant")
    end
)
RegisterNUICallback(
    "addpoint",
    function(a)
        TriggerServerEvent("XCEL:addPoints", a.points, a.id)
    end
)
RegisterNUICallback(
    "addmarker",
    function(a, b)
        TriggerServerEvent("XCEL:addWarningMarker", tonumber(a.id), a.type, a.reason)
        b()
    end
)
RegisterNUICallback(
    "wipeallmarkers",
    function(a, b)
        TriggerServerEvent("XCEL:wipeAllMarkers", a.code)
        b()
    end
)
RegisterNetEvent(
    "XCEL:sendSearcheduser",
    function(c)
        SendNUIMessage({type = "addPersons", user = c})
    end
)
RegisterNetEvent(
    "XCEL:sendSearchedvehicle",
    function(d)
        SendNUIMessage({type = "displaySearchedVehicle", vehicle = d})
    end
)
RegisterNetEvent(
    "XCEL:addADToClient",
    function(e)
        SendNUIMessage({type = "updateAttentionDrawn", ad = e})
    end
)
RegisterNetEvent(
    "XCEL:verifyFineSent",
    function(f, g)
        SendNUIMessage({type = "verifyFine", sentornah = f, msg = g})
    end
)
RegisterNetEvent(
    "XCEL:novehFound",
    function(g)
        SendNUIMessage({type = "noveh", message = g or "No vehicles found!"})
    end
)
RegisterNetEvent(
    "XCEL:openPNC",
    function(h, i, e)
        SetNuiFocus(true, true)
        SendNUIMessage(
            {
                type = "ui",
                status = true,
                id = tXCEL.getUserId(),
                name = GetPlayerName(PlayerId()),
                gc = h,
                news = i,
                ad = e
            }
        )
        startAnim()
    end
)
RegisterNetEvent(
    "XCEL:updateAttentionDrawn",
    function(j)
        SendNUIMessage({type = "updateAttentionDrawn", ad = j})
    end
)
RegisterNetEvent(
    "XCEL:setNameFields",
    function(k, l)
        SendNUIMessage({type = "setNameFields", lname = k, fname = l})
    end
)
RegisterNetEvent(
    "XCEL:noPersonsFound",
    function()
        SendNUIMessage({type = "NoPersonsFound"})
    end
)
CreateThread(
    function()
        while true do
            if IsControlJustPressed(0, 168) then
                TriggerServerEvent("XCEL:checkForPolicewhitelist")
            end
            Citizen.Wait(0)
        end
    end
)
function startAnim()
    CreateThread(
        function()
            RequestAnimDict("amb@world_human_seat_wall_tablet@female@base")
            while not HasAnimDictLoaded("amb@world_human_seat_wall_tablet@female@base") do
                Citizen.Wait(0)
            end
            attachObject()
            TaskPlayAnim(
                tXCEL.getPlayerPed(),
                "amb@world_human_seat_wall_tablet@female@base",
                "base",
                8.0,
                -8.0,
                -1,
                50,
                0,
                false,
                false,
                false
            )
        end
    )
end
function attachObject()
    tab = CreateObject("prop_cs_tablet", 0, 0, 0, true, true, true)
    AttachEntityToEntity(
        tab,
        tXCEL.getPlayerPed(),
        GetPedBoneIndex(tXCEL.getPlayerPed(), 57005),
        0.17,
        0.10,
        -0.13,
        24.0,
        180.0,
        180.0,
        true,
        true,
        false,
        true,
        1,
        true
    )
end
function stopAnim()
    StopAnimTask(tXCEL.getPlayerPed(), "amb@world_human_seat_wall_tablet@female@base", "base", 8.0)
    DeleteEntity(tab)
end
function SetDisplay(f)
    SetNuiFocus(f, f)
    SendNUIMessage({type = "ui", status = f, name = GetPlayerName(PlayerId())})
end
function PoliceSeizeTrunk(m, n)
    TriggerServerEvent("XCEL:policeClearVehicleTrunk", m, n)
end
RegisterNetEvent(
    "XCEL:notifyAD",
    function(g, o)
        tXCEL.notifyPicture("met_logo", "met_logo1", g, "Met Control", o, "police", 2)
    end
)
