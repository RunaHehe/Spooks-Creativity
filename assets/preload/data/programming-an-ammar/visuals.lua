local flasherCreated = false
local OGZoom = nil

local tweens = {} --array to store tweens

local easings = {
    --ok listen easings werent automatically supported :sob:
    linear = function(t) return t end,
    sineInOut = function(t) return -0.5 * (math.cos(math.pi * t) - 1) end,
    expoIn = function(t) return t == 0 and 0 or math.pow(2, 10 * (t - 1)) end,
    expoOut = function(t) return t == 1 and 1 or 1 - math.pow(2, -10 * t) end,
    quadOut = function(t) return -t * (t - 2) end
}

function onCreatePost()
    makeLuaSprite('blackOverlay', '', 9, 0)
    makeGraphic('blackOverlay', 2000, 15000, '000000')
    setObjectCamera('blackOverlay', 'other')
    setProperty('blackOverlay.alpha', 1)
    screenCenter('blackOverlay')
    addLuaSprite('blackOverlay', false)
    
    OGZoom = getProperty('defaultCamZoom')

    setPropertyFromClass("lime.app.Application", "current.window.opacity", 1)
end

function onSongStart()
    doTweenAlpha('meow', 'blackOverlay', 0, 19, 'linear')
end

function onStepEvent(curStep)
    if curStep == 246 then
        doTweenVar('zooms', 'defaultCamZoom', OGZoom + 0.3, 0.1, 'quadOut')
    end
end

function onBeatHit()
    if curBeat > 328 and curBeat <= 528 then
        if curBeat % 1 == 0 then
            triggerEvent('Add Camera Zoom', 0.08, 0.08)
        end
    end

    if curBeat == 32 then
        setProperty('camZoomMult', 0.1)
    end

    if curBeat == 64 then
        flashCamera(0.5, 1)
        setProperty('defaultCamZoom', OGZoom)
    end

    if curBeat == 128 then
        flashCamera(0.5, 1)
    end

    if curBeat == 192 then
        setProperty('camZoomMult', 0.2)
        flashCamera(0.5, 1)
    end

    if curBeat == 256 then
        setProperty('camZoomMult', 0.4)
        flashCamera(0.5, 1)
    end

    if curBeat == 320 then
        setObjectCamera('blackOverlay', 'hud')
        setProperty('blackOverlay.alpha', 1)
    end

    if curBeat == 328 then
        setProperty('blackOverlay.alpha', 0)
        flashCamera(0.7, 2)
        setProperty('camZoomMult', 0)
    end

    if curBeat == 536 then
        flashCamera(0.8, 4)
    end

    if curBeat == 568 then
        setObjectCamera('blackOverlay', 'other')
        setProperty('blackOverlay.alpha', 1)
        flashCamera(1, 4)
        tweenWindowOpacity(0, 4)
    end
end

function flashCamera(alpha, duration)
    if not flasherCreated then
        makeLuaSprite('flasher', '', 0, 0)
        makeGraphic('flasher', screenWidth, screenHeight, 'FFFFFF')
        setObjectCamera('flasher', 'other')
        screenCenter('flasher')
        addLuaSprite('flasher', true)
        flasherCreated = true
    end

    setProperty('flasher.alpha', alpha)
    setProperty('flasher.visible', true)
    doTweenAlpha('flashOut', 'flasher', 0, duration, 'linear')
end

function doTweenVar(tag, object, endValue, duration, easing)
    if tweens[tag] then
        tweens[tag] = nil
    end

    local startValue = getProperty(object)
    tweens[tag] = {
        object = object,
        startValue = startValue,
        endValue = endValue,
        duration = duration,
        elapsedTime = 0,
        easing = easing or 'linear'
    }
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
    for tag, tweenData in pairs(tweens) do
        tweenData.elapsedTime = tweenData.elapsedTime + elapsed
        local t = math.min(tweenData.elapsedTime / tweenData.duration, 1)

        local easeFunc = easings[tweenData.easing] or easings.linear
        local easedT = easeFunc(t)

        local currentValue = tweenData.startValue + (tweenData.endValue - tweenData.startValue) * easedT
        setProperty(tweenData.object, currentValue)

        if tweenData.elapsedTime >= tweenData.duration then
            setProperty(tweenData.object, tweenData.endValue)
            tweens[tag] = nil
        end
    end

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

function onDestroy()
    setPropertyFromClass("lime.app.Application", "current.window.opacity", 1)
end