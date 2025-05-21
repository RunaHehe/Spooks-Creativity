local fullscreen = nil
local OGx = nil
local OGy = nil
local OGwidth = nil
local OGheight = nil

waveWindowY = false
waveWindowX = false
waveWindowSpeed = 5
borderlessShake = false

function onCreate()
    OGx = getPropertyFromClass("openfl.Lib", "application.window.x")
    OGy = getPropertyFromClass("openfl.Lib", "application.window.y")
    OGwidth = getPropertyFromClass("openfl.Lib", "application.window.width")
    OGheight = getPropertyFromClass("openfl.Lib", "application.window.height")
    waveBaseX = OGx
end

function onUpdatePost(elapsed)
    fullscreen = getPropertyFromClass("openfl.Lib", "application.window.fullscreen")
    if waveWindowY then
        local curBeat = (getSongPosition() / 1000) * (bpm / 60)
        local yOffset = math.sin(curBeat * waveWindowSpeed/4)*60
        setWindow("y", OGy + yOffset)
    end

    if waveWindowX then
        local curBeat = (getSongPosition() / 1000) * (bpm / 60)
        local xOffset = math.cos(curBeat * waveWindowSpeed/4)*60
        setWindow("x", OGx + xOffset)
    end
    if borderlessShake and false then
        setPropertyFromClass('openfl.Lib', 'application.window.borderless', getRandomBool(5))
    end
    local currentX = getPropertyFromClass('openfl.Lib', 'application.window.x')
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

function onBeatHit()
    if curBeat == 80 then
        moveWindow("x", "windowX", OGx * 0.25, crochet/1000*14*4, "quadInOut")
        moveWindow("width", "windowWidth", OGwidth * 1, crochet/1000*14*4, "quadInOut")
    end
    if curBeat == 140 then
        moveWindow("x", "windowX", OGx, crochet/1000*4, "expoIn")
        moveWindow("width", "windowWidth", OGwidth, crochet/1000*4, "expoIn")
    end
    if curBeat == 144 then
        waveWindowY = true
    end
    if curBeat == 208 then
        waveWindowSpeed = 10
        waveWindowX = true
        borderlessShake = true
    end
    if curBeat >= 208 and curBeat < 270 then
        if curBeat % 8 == 0 then
            moveWindow("x", "windowX", OGx * -0, crochet/1000*2, "quintOut")
        elseif curBeat % 8 == 4 then
            moveWindow("x", "windowX", OGx * 1.2, crochet/1000*2, "quintOut")
        end
    end
    if curBeat == 270 then
        moveWindow("x", "windowX", OGx, crochet/1000*1, "quadInOut")
        moveWindow("y", "windowY", OGy * - 0.5, crochet/1000*2, "expoIn")
        waveWindowX = false
        waveWindowY = false
        borderlessShake = false
        setPropertyFromClass('openfl.Lib','application.window.borderless',false)
    end
    if curBeat == 272 then
        setWindow("y", OGy * 20)
        moveWindow("y", "windowY", OGy, crochet/1000*1, "quadOut")
        waveWindowY = true
        borderlessShake = true
    end
    if curBeat == 336 then
        borderlessShake = false
        setPropertyFromClass('openfl.Lib','application.window.borderless',false)
        waveWindowY = false
        setWindow("y", OGy)
        setWindow("x", OGx)
    end
    if curBeat == 592 then
        waveWindowSpeed = 5
        waveWindowY = true
    end
    if curBeat == 654 then
        borderlessShake = false
        waveWindowSpeed = 10
        waveWindowY = false
    end
    if curBeat == 656 then
        borderlessShake = true
    end
    if curBeat == 688 then
        waveWindowY = true
    end
    if curBeat == 720 then 
        borderlessShake = false
        waveWindowY = false
    end
end

function continuous_sin(x) return math.sin((x % 1) * 2*math.pi) end