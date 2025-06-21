local fullscreen = nil
local OGx = nil
local OGy = nil
local OGwidth = nil
local OGheight = nil

local floatHeight = 40
local durationY = 3
local durationX = 6


function onCreate()
    OGx = getPropertyFromClass("openfl.Lib", "application.window.x")
    OGy = getPropertyFromClass("openfl.Lib", "application.window.y")
    OGwidth = getPropertyFromClass("openfl.Lib", "application.window.width")
    OGheight = getPropertyFromClass("openfl.Lib", "application.window.height")
    floatWindowUp()
    --floatWindowX()
end

function onUpdatePost(elapsed)
    fullscreen = getPropertyFromClass("openfl.Lib", "application.window.fullscreen")
end

function moveWindow(v1,v2,v3,v4,v5)
    callScript("scripts/Window Modchart Tool", "moveW", {v1, v2, v3, v4, v5})
end
function setWindow(v1,v2)
    callScript("scripts/Window Modchart Tool", "setW", {v1, v2})
end
function resetWindow(v1)
    callScript("scripts/Window Modchart Tool", "resetW", {v1})
end

function onDestroy()
    setPropertyFromClass("openfl.Lib", "application.window.x", OGx)
    setPropertyFromClass("openfl.Lib", "application.window.y", OGy)
    setPropertyFromClass("openfl.Lib", "application.window.width", OGwidth)
    setPropertyFromClass("openfl.Lib", "application.window.height", OGheight)
end

function floatWindowUp()
    moveWindow("y", "floaty", OGy - floatHeight, durationY, "sineInOut")
    runTimer("floatDown", durationY)
end

function floatWindowX()
    moveWindow("x", "xFloat", OGx - floatHeight, durationX, "sineInOut")
    runTimer("xFloatD", durationX)
end

function onTimerCompleted(tag)
    if tag == "floatDown" then
        moveWindow("y", "floatDown", OGy + floatHeight, durationY, "sineInOut")
        runTimer("floaty", durationY)
    elseif tag == "floaty" then
        floatWindowUp()
    end

    if tag == "xFloatD" then
        moveWindow("x", "xFloatD", OGx + floatHeight, durationX, "sineInOut")
        runTimer("xFloat", durationX)
    elseif tag == "xFloat" then
        floatWindowX()
    end
end