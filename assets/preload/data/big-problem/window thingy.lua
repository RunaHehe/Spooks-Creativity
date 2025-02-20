local fullscreen = nil
local OGx = nil
local OGy = nil
local OGwidth = nil
local OGheight = nil

function onCreate()
    OGx = getPropertyFromClass("openfl.Lib", "application.window.x")
    OGy = getPropertyFromClass("openfl.Lib", "application.window.y")
    OGwidth = getPropertyFromClass("openfl.Lib", "application.window.width")
    OGheight = getPropertyFromClass("openfl.Lib", "application.window.height")
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
    setWindowColor(0x0000ff00)
end

function onUpdatePost(elapsed)
    fullscreen = getPropertyFromClass("openfl.Lib", "application.window.fullscreen")
end

function moveW(v1,v2,v3,v4,v5)
    callScript("scripts/Window Modchart Tool", "mowW", {v1, v2, v3, v4, v5})
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
    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
end


function onStepHit()
    if curStep == 3776 then
        callScript("scripts/Window Modchart Tool", "moveW", {"width", "appear Width", 0 * 1.09, 0.1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"height", "appear Height", 0 * 1.09, 0.1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 0.1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 0.1, "expoOut"})
        setPropertyFromClass("openfl.Lib", "application.window.borderless", true)
    end

    if curStep == 3822 then
        callScript("scripts/Window Modchart Tool", "moveW", {"width", "appear Width", OGwidth * 1, 20, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"height", "appear Height", OGheight * 1, 20, "expoOut"})
    end
    if curStep == 4287 then
        callScript("scripts/Window Modchart Tool", "setW", {"width", "appear Width", 0 * 1, 0.1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "setW", {"height", "appear Height", 0 * 1, 0.1, "expoOut"})
    end
end