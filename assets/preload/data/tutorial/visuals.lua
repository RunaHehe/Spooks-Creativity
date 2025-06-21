local flasherCreated = false

local tweens = {} --array to store tweens

local easings = {
    --ok listen easings werent automatically supported :sob:
    linear = function(t) return t end,

    sineInOut = function(t)
        return -0.5 * (math.cos(math.pi * t) - 1)
    end,

    expoIn = function(t)
        return t == 0 and 0 or math.pow(2, 10 * (t - 1))
    end,
    expoOut = function(t)
        return t == 1 and 1 or 1 - math.pow(2, -10 * t)
    end
}

function onCreate()
    --debugging
    --setProperty('cpuControlled', true)
    --end of debugging
    setProperty('skipCountdown', true)
    setProperty('camGame.zoom', 5)
    luaDebugMode = true

    makeLuaSprite('blackOverlay', '', 9, 0)
    makeGraphic('blackOverlay', 1280, 720, '000000')
    setObjectCamera('blackOverlay', 'other')
    setProperty('blackOverlay.alpha', 1)
    screenCenter('blackOverlay')
    addLuaSprite('blackOverlay', false)

    makeLuaSprite('Ready', 'ready', 0, 0)
    setObjectCamera('Ready', 'hud')
    setProperty('Ready.alpha', 0)
    screenCenter('Ready')
    addLuaSprite('Ready', false)

    makeLuaSprite('Set', 'set', 0, 0)
    setObjectCamera('Set', 'hud')
    setProperty('Set.alpha', 0)
    screenCenter('Set')
    addLuaSprite('Set', false)

    makeLuaSprite('Go', 'go', 0, 0)
    setObjectCamera('Go', 'hud')
    setProperty('Go.alpha', 0)
    screenCenter('Go')
    addLuaSprite('Go', false)
end

function onSongStart()
    doTweenAlpha('byeOverlay', 'blackOverlay', 0, 8, 'linear')
    doTweenVar('Cam', 'camGame.zoom', 1, 9, 'sineInOut')
end

function onStepEvent(curStep)
    if curStep == 52 then
        setProperty('Ready.alpha', 1)
    end
    if curStep == 53 then
        doTweenAlpha('byeReady', 'Ready', 0, 0.3, 'linear')
    end
    if curStep == 56 then
        setProperty('Set.alpha', 1)
    end
    if curStep == 57 then
        doTweenAlpha('byeSet', 'Set', 0, 0.3, 'linear')
    end
    if curStep == 60 then
        setProperty('Go.alpha', 1)
        playAnim('boyfriend', 'hey')
        playAnim('dad', 'cheer')
    end
    if curStep == 61 then
        doTweenAlpha('byeGo', 'Go', 0, 0.3, 'linear')
    end
    if curStep == 114 then
        doTweenVar('Cam', 'camGame.zoom', 1, 0.2, 'expoOut')
    end
    if curStep == 238 then
        doTweenVar('Cam', 'camGame.zoom', 1.5, 0.3, 'expoOut')
    end
end

function RunaFlash(alpha, duration) --fuck camera flash lmao
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

function onBeatHit()
    if curBeat == 16 then
        RunaFlash(1, 2)
    end
    if curBeat == 26 then
        doTweenVar('Cam', 'camGame.zoom', 1.5, 0.2, 'expoOut')
    end
    if curBeat == 27 then
        doTweenVar('Cam', 'camGame.zoom', 0.8, 0.2, 'expoOut')
    end
    if curBeat == 30 then
        doTweenVar('Cam', 'camGame.zoom', 0.8, 0.2, 'expoOut')
    end
    if curBeat == 31 then
        doTweenVar('Cam', 'camGame.zoom', 1.5, 0.2, 'expoOut')
    end
    if curBeat == 47 then
        doTweenVar('Cam', 'camGame.zoom', 0.8, 0.3, 'expoOut')
    end
    if curBeat == 59 then
        doTweenVar('Cam', 'camGame.zoom', 1.2, 0.3, 'expoOut')
    end
    if curBeat == 60 then
        doTweenVar('Cam', 'camGame.zoom', 1, 0.3, 'expoOut')
    end
    if curBeat == 75 then
        doTweenVar('Cam', 'camGame.zoom', 1.3, 0.2, 'expoOut')
    end
    if curBeat == 76 then
        doTweenVar('Cam', 'camGame.zoom', 1, 0.2, 'expoOut')
    end
    if curBeat == 80 then
        doTweenVar('Cam', 'camGame.zoom', 1.5, 8, 'sineInOut')
    end
    if curBeat == 108 then
        doTweenVar('Cam', 'camGame.zoom', 1.2, 0.3, 'expoOut')
    end
    if curBeat == 109 then
        doTweenVar('Cam', 'camGame.zoom', 1.4, 0.3, 'expoOut')
    end
    if curBeat == 110 then
        doTweenVar('Cam', 'camGame.zoom', 1, 0.5, 'expoOut')
    end
    if curBeat == 112 then
        doTweenVar('Cam', 'camGame.zoom', 3, 8, 'sineInOut')
    end
    if curBeat == 138 then
        doTweenVar('Cam', 'camGame.zoom', 1.2, 0.2, 'expoOut')
    end
    if curBeat == 140 then
        doTweenVar('Cam', 'camGame.zoom', 1, 0.2, 'expoOut')
    end
    if curBeat == 144 then
        doTweenVar('Cam', 'camGame.zoom', 1.5, 5, 'sineInOut')
    end
    if curBeat == 148 then
        doTweenVar('Cam', 'camGame.zoom', 1, 5, 'sineInOut')
    end
    if curBeat == 160 then
        doTweenAlpha('hi', 'blackOverlay', 1, 5, 'linear')
        doTweenVar('Cam', 'camGame.zoom', 3, 5, 'sineInOut')
    end
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