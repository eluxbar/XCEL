Citizen.CreateThread(
    function()
        local a = RequestScaleformMovie("minimap")
        SetRadarBigmapEnabled(true, false)
        Wait(0)
        SetRadarBigmapEnabled(false, false)
        BeginScaleformMovieMethod(a, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
)
local b = false
local c = 0
local function d()
    BeginScaleformMovieMethod(c, "SETUP_HEALTH_ARMOUR")
    ScaleformMovieMethodAddParamInt(3)
    EndScaleformMovieMethod()
    if IsDisabledControlJustReleased(0, 20) and IsUsingKeyboard(2) then
        if not b then
            SetBigmapActive(true, false)
            LastGameTimer = GetGameTimer()
            b = true
        elseif b then
            SetBigmapActive(false, false)
            LastGameTimer = 0
            b = false
        end
    end
end
tXCEL.createThreadOnTick(d)
Citizen.CreateThread(
    function()
        c = RequestScaleformMovie("minimap")
    end
)
