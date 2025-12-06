local flasherCreated = false

local invertThisNow = false

local camNoteBeat = false

local tweens = {}

local easings = {
    -- ok listen easings werent automatically supported :sob:
    linear = function(t) return t end,

    sineInOut = function(t) return -0.5 * (math.cos(math.pi * t) - 1) end,

    expoIn = function(t) return t == 0 and 0 or math.pow(2, 10 * (t - 1)) end,

    expoOut = function(t) return t == 1 and 1 or 1 - math.pow(2, -10 * t) end,

    quadIn = function(t) return t * t end,

    quadOut = function(t) return t * (2 - t) end
}


local membersSprites = {}

pbr = 1
function onCreate()
    if HardMode then
        setProperty('defaultCamZoom', 2.5)
    end
end

function onCreatePost()
    if HardMode then
        makeLuaSprite('blackOverlay', '', 9, 0)
        makeGraphic('blackOverlay', 2000, 15000, '000000')
        setObjectCamera('blackOverlay', 'other')
        setProperty('blackOverlay.alpha', 1)
        screenCenter('blackOverlay')
        addLuaSprite('blackOverlay', false)

        makeLuaSprite('hudOverlay', '', 9, 0)
        makeGraphic('hudOverlay', 2000, 15000, '000000')
        setObjectCamera('hudOverlay', 'hud')
        setProperty('hudOverlay.alpha', 0)
        screenCenter('hudOverlay')
        addLuaSprite('hudOverlay', false)

        makeLuaSprite('vignette', 'vignette', 0, 0)
        setObjectCamera('vignette', 'other')
        setProperty('vignette.alpha', 0.7)
        screenCenter('vignette')
        scaleObject('vignette', 1, 1)
        addLuaSprite('vignette', true)

        setProperty("dad.healthIcon", "ammar"..(CuteMode and 'cute' or ''))
        setProperty("boyfriend.healthIcon", "annoyer")
        runHaxeCode([[
            game.iconP2.changeIcon("icon-ammar]]..(CuteMode and 'cute' or '')..[[");
            game.iconP1.changeIcon("icon-annoyer");
        ]])
        
        setHealthBarColors("60f542", "ffc400")
        membersSprites = getProperty("membersSprites")
        pbr = getProperty("playbackRate")
    end
end

function onBeatHit()
    if HardMode then
        if curBeat == 16 then
            doTweenAlpha('helloGame', 'blackOverlay', 0.4, 10, 'linear')
        end
        if curBeat == 32 then
            cancelTween('helloGame')
            setProperty('blackOverlay.alpha', 1)
            setProperty('defaultCamZoom', 0.9)
        end
        if curBeat == 40 then
            setProperty('blackOverlay.alpha', 0)
            flashCamera(1, 3)
        end
        if curBeat == 40 or curBeat == 48 or curBeat == 56 or curBeat == 64 or curBeat == 72 or curBeat == 80 or curBeat == 88 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.2, 0.5, 'quadIn')
        end
        if curBeat == 44 or curBeat == 52 or curBeat == 60 or curBeat == 68 or curBeat == 76 or curBeat == 84 or curBeat == 92 then
            doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.5, 'quadOut')
        end
        if curBeat == 96 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.5, 1.7, 'expoOut')
        end
        if curBeat == 102 then
            setProperty('hudOverlay.alpha', 1)
            setProperty('defaultCamZoom', 0.9)
        end
        if curBeat == 104 then
            setProperty('hudOverlay.alpha', 0)
            flashCamera(1, 3)
        end
        if curBeat == 136 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.7, 10, 'linear')
        end
        if curBeat == 168 then
            setProperty('defaultCamZoom', 0.9)
            flashCamera(1, 2)
            callScript("stages/discordStage", "lightingMode", {true})
        end
        if curBeat == 176 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.3, 0.2, 'quadOut')
        end
        if curBeat == 184 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.6, 0.2, 'quadOut')
        end
        if curBeat == 192 then
            doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.2, 'quadOut')
        end
        if curBeat == 208 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.3, 0.2, 'quadOut')
        end
        if curBeat == 216 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.6, 0.2, 'quadOut')
        end
        if curBeat == 224 then
            doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.2, 'quadOut')
        end
        if curBeat == 232 then
            setProperty('hudOverlay.alpha', 1)
        end
        if curBeat == 233 then
            setProperty('hudOverlay.alpha', 0)
            flashCamera(0.6, 3)
        end
        if curBeat == 256 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.5, 1.5, 'quadOut')
        end
        if curBeat == 264 then
            setProperty('hudOverlay.alpha', 1)
            setProperty('defaultCamZoom', 0.9)
        end
        if curBeat == 265 then
            setProperty('hudOverlay.alpha', 0)
            flashCamera(0.6, 3)
        end
        if curBeat == 288 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.5, 1.5, 'quadOut')
        end
        if curBeat == 296 then
            setProperty('defaultCamZoom', 0.9)
            flashCamera(0.7, 3)
            callScript("stages/discordStage", "lightingMode", {false})
        end
        if curBeat == 360 then
            camNoteBeat = false
            setProperty('hudOverlay.alpha', 1)
        end
        if curBeat == 364 then
            setProperty('hudOverlay.alpha', 0)
            flashCamera(1, 1)
        end
        if curBeat == 428 then
            setProperty('hudOverlay.alpha', 1)
        end
        if curBeat == 429 then
            setProperty('hudOverlay.alpha', 0)
            flashCamera(0.7, 2)
        end
        if curBeat == 460 then
            setProperty('hudOverlay.alpha', 1)
        end
        if curBeat == 461 then
            setProperty('hudOverlay.alpha', 0)
            flashCamera(0.7, 2)
        end
        if curBeat == 492 then
            doTweenVar('zoomTween', 'defaultCamZoom', 1.8, 0.5, 'expoOut')
        end
        if curBeat == 496 then
            triggerEvent('Add Camera Zoom', 0.15, 0.15)
            setProperty('blackOverlay.alpha', 1)
        end
        
        if curBeat >= 40 and curBeat < 96 then
            if curBeat % 2 == 0 then
                setProperty('camHUD.zoom', 1.05)
                doTweenZoom("hudBack", "camHUD", 1, 1, "expoOut")
            end
        end
        if curBeat >= 104 and curBeat < 168 then
            if curBeat % 1 == 0 then
                triggerEvent('Add Camera Zoom', 0.05, 0.05)
            end
        end
        if curBeat >= 168 and curBeat < 232 then
            if curBeat % 1 == 0 then
                triggerEvent('Add Camera Zoom', 0.08, 0.08)
            end
        end
        if curBeat >= 233 and curBeat < 264 then
            if curBeat % 1 == 0 then
                triggerEvent('Add Camera Zoom', 0.08, 0.08)
            end
        end
        if curBeat >= 265 and curBeat < 296 then
            if curBeat % 1 == 0 then
                triggerEvent('Add Camera Zoom', 0.08, 0.08)
            end
        end
        if curBeat >= 296 and curBeat < 360 then
            camNoteBeat = true
        end
        if curBeat >= 364 and curBeat < 428 then
            triggerEvent('Add Camera Zoom', 0.11, 0.11)
        end
        if curBeat >= 429 and curBeat < 460 then
            triggerEvent('Add Camera Zoom', 0.11, 0.11)
        end
        if curBeat >= 461 and curBeat < 496 then
            triggerEvent('Add Camera Zoom', 0.11, 0.11)
        end
    end
end

function onStepEvent(curStep)
    if HardMode then
        if curStep >= 416 and curStep < 672 then 
            if curStep % 4 == 0 then
                for i,v in pairs(membersSprites) do
                    if not v[3] then
                        local offsetX = 7
                        setProperty(v[1]..".xAdd", offsetX + (7*(i%2==0 and 1 or -1)*(curStep%8==0 and 1 or -1)))
                    end
                end
            end
        end

        if (curStep >= 672 and curStep < 928) or (curStep >= 932 and curStep < 1056) or (curStep >= 1060 and curStep < 1184) then 
            if curStep % 4 == 0 then
                for i,v in pairs(membersSprites) do
                    if not v[3] then
                        local offsetX = 7
                        setProperty(v[1]..".xAdd", offsetX + (7*(i%2==0 and 2 or -2)*(curStep%8==0 and 1 or -1)))
                    end
                end
            end
        end

        if (curStep >= 1456 and curStep < 1712) or (curStep >= 1716 and curStep < 1840) or (curStep >= 1844 and curStep < 1984) then 
            if curStep % 4 == 0 then
                for i,v in pairs(membersSprites) do
                    if not v[3] then
                        local offsetX = 7
                        setProperty(v[1]..".xAdd", offsetX + (7*(i%2==0 and 4 or -4)*(curStep%8==0 and 1 or -1)))
                    end
                end
            end
        end
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    if HardMode then
        if not isSustainNote then
            if camNoteBeat == true then
                triggerEvent('Add Camera Zoom', 0.08, 0.08)
            end
        end
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if HardMode then
        if not isSustainNote then
            if camNoteBeat == true then
                triggerEvent('Add Camera Zoom', 0.08, 0.08)
            end
        end
    end
end

function onUpdatePost(elapsed)
    if HardMode then
        if not inGameOver then
            if curStep >= 416 and curStep < 1984 then
                for i,v in pairs(membersSprites) do
                    if not v[3] then
                        local offsetX = 7
                        setProperty(v[1]..".xAdd", lerp(getProperty(v[1]..".xAdd"), offsetX, elapsed*7*pbr))
                    end
                end
            end
        end
    end
end

function flashCamera(alpha, duration)
    if HardMode then
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
end

function onUpdate(elapsed)
    if HardMode then
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
end

function doTweenVar(tag, object, endValue, duration, easing)
    if HardMode then
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
end
function lerp(a, b, t) return a + (b - a) * t end