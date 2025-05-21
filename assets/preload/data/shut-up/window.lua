local fullscreen = nil
local OGx = nil
local OGy = nil
local OGwidth = nil
local OGheight = nil
local shakeEnabled = false
local wasShaking = false

function onCreate()
    OGx = getPropertyFromClass("openfl.Lib", "application.window.x")
    OGy = getPropertyFromClass("openfl.Lib", "application.window.y")
    OGwidth = getPropertyFromClass("openfl.Lib", "application.window.width")
    OGheight = getPropertyFromClass("openfl.Lib", "application.window.height")
    shakeEnabled = false
end

function onUpdatePost(elapsed)
    fullscreen = getPropertyFromClass("openfl.Lib", "application.window.fullscreen")
end

function onUpdate()
    if curBeat >= 192 and curBeat < 256 then
        if curBeat % 2 == 0 then
            moveWindow("y", "yReset", OGy, 1, "quadOut")
            moveWindow("x", "xReset", OGx, 1, "quadOut")
        end
        if curBeat % 2 == 1 then
            setWindow("y", OGy + math.random(-50, 50))
            setWindow("x", OGx + math.random(-25, 25))
        end
    end
    if curBeat >= 352 and curBeat < 384 then
        if curBeat % 2 == 0 then
            moveWindow("y", "yReset", OGy, 1, "quadOut")
            moveWindow("x", "xReset", OGx, 1, "quadOut")
        end
        if curBeat % 2 == 1 then
            setWindow("y", OGy + math.random(-100, 100))
            setWindow("x", OGx + math.random(-150, 150))
        end
    end
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

--[[function onStepEvent(curBeat)
    if curBeat >= 192 and curBeat < 256 then
        if curBeat % 2 == 0 then
            shakeEnabled = false
        end
        if curBeat % 2 == 1 then
            shakeEnabled = true
        end
    end
end]]