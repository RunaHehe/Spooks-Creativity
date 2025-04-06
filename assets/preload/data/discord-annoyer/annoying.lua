folder = "discord/images"
local tweens = {}

function onCreate()
    if not HardMode then
    setProperty('defaultCamZoom', 1.05)
    end
end

pbr = 1

function onCreatePost()
    pbr = getProperty("playbackRate")
    makeLuaSprite("anCom", "chars/AnCom", 320 , 480)
    addLuaSprite("anCom")
    setGraphicSize("anCom", 649 * 0.625, 146 * 0.625)
    screenCenter('anCom')
    setProperty('anCom.alpha', 0);
    runHaxeCode("game.getLuaObject('anCom').camera = camBDiscord;")
    setObjectOrder("anCom", 60)

    makeLuaSprite("glow", "GLOWLIGHT", -130 , -360)
    setScrollFactor("glow", 0 ,0)
    scaleObject("glow", 1.2, 1.2)
    addLuaSprite("glow", true)
    setProperty("glow.alpha", 0)
    setObjectCamera("glow", "hud")
    screenCenter("glow")
end

function onStepEvent(curStep)
    if not HardMode then
        -- im sorry to anyone that tries to read my code :sob:
        if curStep == 6 or curStep == 12 or curStep == 14 or curStep == 18 then
            triggerEvent('Add Camera Zoom', '0.03', '0.03')
        end
        if curStep == 22 or curStep == 24 or curStep == 28 or curStep == 30 or curStep == 32 then
            triggerEvent('Add Camera Zoom', '0.03', '0.03')
        end
        if curStep == 38 or curStep == 44 or curStep == 46 or curStep == 50 or curStep == 54 then
            triggerEvent('Add Camera Zoom', '0.03', '0.03')
        end
        if curStep == 56 or curStep == 60 or curStep == 62 or curStep == 64 or curStep == 70 then
            triggerEvent('Add Camera Zoom', '0.03', '0.03')
        end
        if curStep == 76 or curStep == 78 or curStep == 82 or curStep == 86 or curStep == 88 or curStep == 92 or curStep == 94 or curStep == 96 then
            triggerEvent('Add Camera Zoom', '0.03', '0.03')
        end
        if curStep == 102 or curStep == 108 or curStep == 110 or curStep == 114 or curStep == 118 then
            triggerEvent('Add Camera Zoom', '0.03', '0.03')
        end
        if curStep == 120 or curStep == 124 or curStep == 128 or curStep == 126 then
            triggerEvent('Add Camera Zoom', '0.03', '0.03')
        end
        if curStep == 128 then
            doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.06)
        end
        if curStep == 192 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.1, 1.1)
        end
        if curStep == 224 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.15, 1.1)
        end
        if curStep == 256 then
            doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 1.1)
        end
        if curStep == 360 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.1, 0.06)
        end
        if curStep == 376 then
            doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.09)
        end
        if curStep == 448 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.1, 0.09)
        end
        if curStep == 496 then
            doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.09)
        end
        if curStep == 576 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.15, 1.2)
        end
        if curStep == 624 then
            doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.09)
        end
        if curStep == 704 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.1, 1.2)
        end
        if curStep == 768 then
            doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.09)
        end
        if curStep == 896 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.15, 7)
        end
        if curStep == 1024 or curStep == 1152 or curStep == 1280 or curStep == 1409 then
            doTweenVar('zoomTween', 'defaultCamZoom', 0.85, 1.1)
        end
        if curStep == 1056 or curStep == 1184 or curStep == 1312 or curStep == 1440 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.05, 1)
        end
        if curStep == 1072 or curStep == 1200 or curStep == 1328 or curStep == 1456 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.12, 1)
        end
        if curStep == 1088 or curStep == 1216 or curStep == 1344 or curStep == 1472 then
            doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 1)
        end
        if curStep == 1392 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.3, 1)
        end
        if curStep == 1532 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.6, 0.09)
            doTweenAlpha("anComIn", "anCom", 1, crochet/1000*1/pbr)
            doTweenAlpha("opponentIn", "opponent", 0, crochet/1000*1/pbr)
            doTweenAlpha("opponentTIn", "opponentText", 0, crochet/1000*1/pbr)
            doTweenAlpha("playerIn", "player", 0, crochet/1000*1/pbr)
            doTweenAlpha("playerTIn", "playerText", 0, crochet/1000*1/pbr)
        end
        if curStep == 1560 then
            doTweenAlpha("anComOut", "anCom", 0, crochet/1000*4/pbr)
            doTweenAlpha("opponentOut", "opponent", 1, crochet/1000*4/pbr)
            doTweenAlpha("opponentTOut", "opponentText", 1, crochet/1000*4/pbr)
            doTweenAlpha("playerOut", "player", 1, crochet/1000*4/pbr)
            doTweenAlpha("playerTOut", "playerText", 1, crochet/1000*4/pbr)
        end
        if curStep == 1568 then
            doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.06)
            callScript("stages/discordStage", "lightingMode", {true})
            cameraFlash("camOther", "FFFFFF", 1/pbr, false)
            setProperty("glow.alpha", 0.3)
        end
        if curStep == 1696 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.15, 6)
        end
        if curStep == 1760 then
            doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 5)
        end
        if curStep == 1824 then
            doTweenVar('zoomTween', 'defaultCamZoom', 3, 0.6)
        end
        if curStep == 1840 then
            endSong()
        end
    end
end

function onUpdate(elapsed)
    for tag, tweenData in pairs(tweens) do
        tweenData.elapsedTime = tweenData.elapsedTime + elapsed
        local t = tweenData.elapsedTime / tweenData.duration
        
        local currentValue = tweenData.startValue + (tweenData.endValue - tweenData.startValue) * t
        setProperty(tweenData.object, currentValue)
        
        if tweenData.elapsedTime >= tweenData.duration then
            setProperty(tweenData.object, tweenData.endValue)
            tweens[tag] = nil
        end
    end
    setProperty("glow.angle", getProperty("glow.angle") + (elapsed*4))
end

function doTweenVar(tag, object, endValue, duration)
    if tweens[tag] then
        tweens[tag] = nil
    end
    
    local startValue = getProperty(object)
    tweens[tag] = {
        object = object,
        startValue = startValue,
        endValue = endValue,
        duration = duration,
        elapsedTime = 0
    }
end