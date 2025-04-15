local folder = 'discord/'
local tweens = {}

local membersSprite = {}
pbr = 1

local annoyerMad = false

function onCreate()
    if HardMode then
        luaDebugMode = true
        shadersOption = getPropertyFromClass("ClientPrefs", "shaders")
        makeLuaSprite('dark', 'vignette', 9, 0)
        setObjectCamera('dark', 'other')
        addLuaSprite("dark")
        screenCenter('dark')
        setBlendMode("dark", 'overlay')
        setProperty('dark.alpha', 0)

        makeLuaSprite('blackOverlay', '', 9, 0)
        makeGraphic('blackOverlay', 1280, 720, '000000')
        setObjectCamera('blackOverlay', 'other')
        setProperty('blackOverlay.alpha', 1)
        screenCenter('blackOverlay')
        addLuaSprite('blackOverlay', false)

        setProperty("skipCountdown", true)
    end
end

function onCreatePost()
    if HardMode then
        if shadersOption then
            initLuaShader("RGGLITCH")

            makeLuaSprite("glitch", "", 0, 0)

            setSpriteShader("glitch", "RGGLITCH")

            runHaxeCode([[
                var glitchShader = new ShaderFilter(game.getLuaObject("glitch").shader);
                camDiscord.setFilters([glitchShader]);
                camBDiscord.setFilters([glitchShader]);
                game.camHUD.setFilters([glitchShader]);
            ]])

            makeLuaSprite("glitchIntensity", nil, 0, 0)
            setProperty("glitchIntensity.alpha", 0)
            addLuaSprite("glitchIntensity", false)
        end

        pbr = getProperty("playbackRate")
        membersSprites = getProperty("membersSprites")
    end
end

function onSongStart()
    if HardMode then
        doTweenVar('camZooming', 'defaultCamZoom', 1, 0.01)
        doTweenAlpha('black', 'blackOverlay', 0, 0.6, 'linear')
    end
end

function onStepEvent(curStep)
    if HardMode then
        if curStep == 4 then
            doTweenVar('camZooming', 'defaultCamZoom', 1.1, 0.01)
        end
        if curStep == 8 then
            doTweenVar('camZooming', 'defaultCamZoom', 1.3, 0.01)
        end
        if curStep == 10 then
            doTweenVar('camZooming', 'defaultCamZoom', 1.5, 0.01)
        end
        if curStep == 12 then
            doTweenVar('camZooming', 'defaultCamZoom', 1, 0.01)
        end
        if curStep == 14 then
            doTweenVar('camZooming', 'defaultCamZoom', 0.6, 0.03)
        end
        if curStep == 16 then
            doTweenVar('camZooming', 'defaultCamZoom', 0.9, 0.06)
            cameraFlash("camOther", flashingLights and "0x90FFFFFF", 0.5)
        end
        if curStep == 144 then
            doTweenVar('camZooming', 'defaultCamZoom', 1.3, 15)
        end
        if curStep == 240 then
            doTweenVar('camZooming', 'defaultCamZoom', 0.9, 0.5)
        end
        if curStep == 256 then
            triggerEvent('Add Camera Zoom', '0.02', '0.02')
        end
        if curStep == 272 then
            triggerEvent('Add Camera Zoom', '0.03', '0.03')
            doTweenVar('camZooming', 'defaultCamZoom', 1.1, 0.6)
        end
        if curStep == 280 then
            doTweenVar('camZooming', 'defaultCamZoom', 1.3, 0.6)
        end
        if curStep == 288 then
            doTweenVar('camZooming', 'defaultCamZoom', 1.5, 0.6)
        end
        if curStep == 296 then
            doTweenVar('camZooming', 'defaultCamZoom', 1.2, 0.6)
        end
        if curStep == 300 then
            doTweenVar('camZooming', 'defaultCamZoom', 0.5, 0.6)
        end
        if curStep == 304 then
            doTweenVar('camZooming', 'defaultCamZoom', 0.9, 0.09)
            triggerEvent('Add Camera Zoom', '0.06', '0.06')
            cameraFlash("camOther", flashingLights and "0x90FFFFFF", 0.3)
            setProperty("glitchIntensity.x", 10)
            doTweenX("glitchTween", "glitchIntensity", 0, 0.5, 'linear')
        end
        if curStep == 307 or curStep == 310 or curStep == 320 or curStep == 323 or curStep == 326 or curStep == 336 or curStep == 339 or curStep == 342 or curStep == 352 or curStep == 355 or curStep == 358 or curStep == 688 or curStep == 691 or curStep == 694 or curStep == 704 or curStep == 707 or curStep == 710 or curStep == 712 or curStep == 715 or curStep == 718 or curStep == 720 or curStep == 723 or curStep == 726 or curStep == 736 or curStep == 739 or curStep == 742 or curStep == 744 or curStep == 747 or curStep == 750 then
            triggerEvent('Add Camera Zoom', '0.6', '0.6')
            cameraFlash("camOther", flashingLights and "0x90FFFFFF", 0.3)
            setProperty("glitchIntensity.x", 10)
            doTweenX("glitchTween", "glitchIntensity", 0, 0.5, 'linear')
        end
        if curStep == 371 or curStep == 374 or curStep == 384 or curStep == 387 then
            triggerEvent('Add Camera Zoom', '0.6', '0.6')
            cameraFlash("camOther", flashingLights and "0x90FFFFFF", 0.3)
            setProperty("glitchIntensity.x", 10)
            doTweenX("glitchTween", "glitchIntensity", 0, 0.5, 'linear')
        end
        if curStep == 390 or curStep == 400 or curStep == 403 or curStep == 406 or curStep == 416 or curStep == 419 or curStep == 422 then
            triggerEvent('Add Camera Zoom', '0.6', '0.6')
            cameraFlash("camOther", flashingLights and "0x90FFFFFF", 0.3)
            setProperty("glitchIntensity.x", 10)
            doTweenX("glitchTween", "glitchIntensity", 0, 0.5, 'linear')
        end
        if curStep == 368 then
            triggerEvent('Add Camera Zoom', '0.6', '0.6')
            doTweenAlpha('vignette', 'dark', 1, 9, 'linear')
            doTweenAlpha('black', 'blackOverlay', 0.4, 8, 'linear')
            cameraFlash("camOther", flashingLights and "0x90FFFFFF", 0.3)
        end
        if curStep == 432 then
            doTweenVar('camZooming', 'defaultCamZoom', 2.5, 19)
            cameraFlash("camOther", "FFFFFF", 1.3)
            setProperty('dark.alpha', 0)
            setProperty('blackOverlay.alpha', 0)
            setGlobalFromScript("stages/discordStage", "sideSinning", true)
            cancelTween('channelYMove')
            cancelTween('memberYMove')
        end
        if curStep == 560 then
            doTweenVar('camZooming', 'defaultCamZoom', 0.9, 19)
            doTweenAlpha('vignette', 'dark', 1, 9, 'linear')
            doTweenAlpha('black', 'blackOverlay', 0.4, 8, 'linear')
            doTweenX("hahaGlitch", "glitchIntensity", 20, 20, 'linear')
        end
        if curStep == 688 then
            setProperty('dark.alpha', 0)
            setProperty('blackOverlay.alpha', 0)
            setGlobalFromScript("stages/discordStage", "sideSinning", false)
            cancelTween('channelYMove')
            cancelTween('memberYMove')
        end
        if curStep == 752 then
            doTweenVar('camZooming', 'defaultCamZoom', 2.5, 19)
            cameraFlash("camOther", "FFFFFF", 1.3)
            setProperty('dark.alpha', 0)
            setProperty('blackOverlay.alpha', 0)
            setGlobalFromScript("stages/discordStage", "sideSinning", true)
            cancelTween('channelYMove')
            cancelTween('memberYMove')
        end
        if curStep == 880 then
            doTweenVar('camZooming', 'defaultCamZoom', 0.9, 19)
            doTweenAlpha('vignette', 'dark', 1, 9, 'linear')
            doTweenAlpha('black', 'blackOverlay', 0.4, 8, 'linear')
            doTweenX("hahaGlitch", "glitchIntensity", 20, 20, 'linear')
        end
        if curStep == 994 then
            doTweenX("hahaGlitch", "glitchIntensity", 25, 15, 'linear')
        end
        if curStep == 1008 then
            doTweenX("hahaGlitch", "glitchIntensity", 0, 20, 'linear')
        end
        if curStep == 1072 then
            annoyerMad = true
        end
        if (curStep >= 432 and curStep < 688) or (curStep == 752) then 
            if curStep % 4 == 0 then
                for i,v in pairs(membersSprites) do
                    if not v[3] then
                        local offsetX = 9
                        setProperty(v[1]..".xAdd", offsetX + (9*(i%2==0 and 1.4 or -1.4)*(curStep%8==0 and 1.4 or -1.4)))
                    end
                end
            end
        end
    end
end

function onUpdate(elapsed)
    if HardMode then
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

        if shadersOption then
            setShaderFloat("glitch", "iTime", os.clock()%100)
            local currentGlitch = getProperty("glitchIntensity.x")
            setShaderFloat("glitch", "intensity", currentGlitch)
        end
    end
end

function onUpdatePost(elapsed)
    if HardMode then
        if not inGameOver then
            for i,v in pairs(membersSprites) do
                if not v[3] then
                    local offsetX = 7
                    setProperty(v[1]..".xAdd", lerp(getProperty(v[1]..".xAdd"), offsetX, elapsed*7*pbr))
                end
            end
        end
    end
end
function opponentNoteHit(id, direction, noteType, isSustainNote)
    if HardMode then
        if annoyerMad then
            cameraShake('camGame', 0.03, 0.2)
            cameraShake('camHUD', 0.03, 0.2)
        end
    end
end
    

function doTweenVar(tag, object, endValue, duration)
    -- this is like the third time im gonna use this :sob:
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

function lerp(a, b, t) return a + (b - a) * t end
function continuous_sin(x) return math.sin((x % 1) * 2 * math.pi) end