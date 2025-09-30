local flasherCreated = false

function onCreatePost()
    makeLuaSprite('blackOverlay', '', 9, 0)
    makeGraphic('blackOverlay', 2000, 15000, '000000')
    setObjectCamera('blackOverlay', 'other')
    setProperty('blackOverlay.alpha', 0)
    screenCenter('blackOverlay')
    addLuaSprite('blackOverlay', false)
end

function onStepEvent(curStep)
    if curStep == 128 then
        setProperty('blackOverlay.alpha', 1)
        doTweenAlpha('fuck you', 'blackOverlay', 0, 5, 'linear')
    end
end

function onBeatHit()
    if curBeat == 64 then
        flashCamera(0.7, 1)
    end
    if curBeat == 128 then
        flashCamera(0.6, 1)
    end
    if curBeat == 192 then
        flashCamera(0.5, 1)
    end
    if curBeat == 320 then
        setProperty('blackOverlay.alpha', 1)
    end
    if curBeat == 328 then
        setProperty('blackOverlay.alpha', 0)
        flashCamera(0.8, 1.5)
    end
    if curBeat == 536 then
        flashCamera(1, 1.5)
        setProperty('camZoomMult', 0)
        setProperty('camZooming', false)
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