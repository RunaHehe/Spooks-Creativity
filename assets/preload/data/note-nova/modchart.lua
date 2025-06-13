function onCreatePost()
    setupMods()
    setMod("dadY", -150)
    setMod("bfY", -150)
    setupEvents()
    setProperty('cpuControlled', true)
end

function setupMods()
    startMod("dadY", "YDModifier", "opponent", -1)
    startMod("bfY", "YDModifier", "player", -1)
    startMod("xModifier", "XModifier", "", -1)
    startMod("rotateStrums", "ConfusionModifier", "", -1)
    startMod("tMod", "TordnadoModifier", "", -1)
    startMod("stealthMod", "StealthModifier", "", -1)
end

function setupEvents()
    ease(0, 8, "quadOut", "0, dadY")
    ease(8, 8, "quadOut", "0, bfY")
    for beat = 0, (4 * 36) - 1 do
        local time = 16 + beat

        if (beat % 2 == 0) then
            set(time, '40, xModifier')
            set(time, '20, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
        if (beat % 2 == 1) then
            set(time, '-40, xModifier')
            set(time, '-20, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
    end

    set(96, '1, tMod')
    set(160, '0, tMod')
    set(176, '0.5, tMod')
    set(192, '1, tMod')
    set(224, '1.5, tMod')
    set(256, '0, tMod')
    set(272, '0.5, tMod')
    set(288, '0, tMod')
    ease(288, 1, "quadOut", "2, stealthMod")

    --literally just fucking repeat it lmao
    for beat = 0, (4 * 12) - 1 do
        local time = 176 + beat

        if (beat % 2 == 0) then
            set(time, '40, xModifier')
            set(time, '20, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
        if (beat % 2 == 1) then
            set(time, '-40, xModifier')
            set(time, '-20, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
    end
    for beat = 0, (4 * 8) - 1 do
        local time = 224 + beat

        if (beat % 2 == 0) then
            set(time, '50, xModifier')
            set(time, '30, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
        if (beat % 2 == 1) then
            set(time, '-50, xModifier')
            set(time, '-30, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
    end
    for beat = 0, (4 * 4) - 1 do
        local time = 272 + beat

        if (beat % 2 == 0) then
            set(time, '40, xModifier')
            set(time, '20, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
        if (beat % 2 == 1) then
            set(time, '-40, xModifier')
            set(time, '-20, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
    end

end

-- runa is window

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
    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
    setPropertyFromClass("lime.app.Application", "current.window.opacity", 1)
end

function onStepEvent(curStep)
    if (curStep >= 384 and curStep < 640) or (curStep >= 768 and curStep < 896) or (curStep >= 1088 and curStep < 1152) then
        if curStep % 8 == 0 then
            setWindow("x", OGx + 30)
            moveW("x", "move", OGx, 0.5, "quadOut")
        end
        if curStep % 8 == 4 then
            setWindow("x", OGx + -30)
            moveW("x", "move", OGx, 0.5, "quadOut")
        end
    end
    if curStep == 380 then
        setPropertyFromClass("lime.app.Application", "current.window.opacity", 0)
    end
    if curStep == 384 then
        setPropertyFromClass("lime.app.Application", "current.window.opacity", 1)
    end

    if curStep >= 704 and curStep < 768 then
        if curStep % 8 == 0 then
            setWindow("x", OGx + 15)
            moveW("x", "move", OGx, 0.5, "quadOut")
        end
        if curStep % 8 == 4 then
            setWindow("x", OGx + -15)
            moveW("x", "move", OGx, 0.5, "quadOut")
        end
    end

    if curStep >= 896 and curStep < 1024 then
        if curStep % 8 == 0 then
            setWindow("x", OGx + 50)
            moveW("x", "move", OGx, 0.5, "quadOut")
        end
        if curStep % 8 == 4 then
            setWindow("x", OGx + -50)
            moveW("x", "move", OGx, 0.5, "quadOut")
        end
    end

    if curStep == 1152 then
        tweenWindowOpacity(0, 0.2)
    end
end


local startOpacity = 1
local targetOpacity = 0
local duration = 1
local tweenTime = 0
local tweening = false

function tweenWindowOpacity(toValue, time)
    startOpacity = getPropertyFromClass("lime.app.Application", "current.window.opacity")
    targetOpacity = toValue
    duration = time
    tweenTime = 0
    tweening = true
end

function onUpdate(elapsed)
    if tweening then
        tweenTime = tweenTime + elapsed
        local progress = math.min(tweenTime/duration, 1)
        local eased = progress

        local current = startOpacity + (targetOpacity - startOpacity) * eased
        setPropertyFromClass("lime.app.Application", "current.window.opacity", current)

        if progress >= 1 then
            tweening = false
        end
    end
end