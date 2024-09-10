local function f(g)
    local h=GetActivePlayers()
    local i=-1
    local j=-1
    local k=PlayerPedId()
    local b=GetEntityCoords(k)
    for l,m in ipairs(h)do 
        local n=GetPlayerPed(m)
        if n~=k then 
            local o=GetEntityCoords(n)
            local p=#(o-b)
            if i==-1 or i>p then 
                j=m
                i=p 
            end 
        end 
    end
    if i~=-1 and i<=g then 
        return j 
    else 
        return nil 
    end 
end

RegisterNetEvent("XCEL:zapFriendlySync")
AddEventHandler(
    "XCEL:zapFriendlySync",
    function(q, r)
        if #(q - GetEntityCoords(PlayerPedId())) < 25.0 then
            local s = {}
            local a = 0
            local diffVector = r - q
            for t = 1, 10, 1 do
                table.insert(s, q + vector3(diffVector.x / 10 * t, diffVector.y / 10 * t, diffVector.z / 10 * t))
            end
            XCEL.loadPtfx("core")
            XCEL.loadPtfx("scr_fbi3")
            SendNUIMessage({transactionType = "wrathofgod"})
            local u = {}
            local x = {}
            local y = {}
            for v, w in pairs(s) do
                SetPtfxAssetNextCall("core")
                local c =
                    StartParticleFxLoopedAtCoord(
                    "ent_dst_elec_crackle",
                    w.x,
                    w.y,
                    w.z,
                    0.0,
                    0.0,
                    0.0,
                    1.2,
                    false,
                    false,
                    false
                )
                table.insert(u, c)
            end
            while a < 20 do
                a = a + 1
                for v, w in pairs(s) do
                    SetPtfxAssetNextCall("core")
                    local c =
                        StartParticleFxLoopedAtCoord(
                        "sp_foundry_sparks",
                        w.x,
                        w.y,
                        w.z,
                        90.0,
                        0.0,
                        0.0,
                        0.0,
                        false,
                        false,
                        false
                    )
                    table.insert(u, c)
                end
                Wait(400)
                for v, w in pairs(u) do
                    RemoveParticleFx(w)
                end
                for v, w in pairs(x) do
                    RemoveParticleFx(w)
                end
            end
            for v, w in pairs(y) do
                RemoveParticleFx(w)
            end
        end
    end
)