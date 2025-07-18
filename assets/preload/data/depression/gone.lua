folder = "discord/"
profiles = "profiles/"

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

local lastTextAngle = 0

local lastCamAngle = 0

local lastHUDAngle = 0

local OpponentTextAngle = false

local oppSinging = false
local singTimer = 0
local singCooldown = 0.1

originalBFStrumX = {}
originalOPStrumX = {}

-- what are these USELESS variables doing in my code..

function onCreate()
    luaDebugMode = false
    setProperty('defaultCamZoom', 2.5)
    
end

function onSongStart()
    doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 19, 'sineInOut')
    setProperty('iconSpeed', 0)
    setProperty('lightbottom.y', 50)
end

function onCreatePost()
    for i = 4, 7 do
        originalBFStrumX[i] = getPropertyFromGroup('strumLineNotes', i, 'x')
    end
    for i = 0, 3 do
        originalOPStrumX[i] = getPropertyFromGroup('strumLineNotes', i, 'x')
    end

    makeLuaSprite("lightbottom", "downGlow", 0, 0)
    setObjectCamera("lightbottom", "hud")
    screenCenter("lightbottom")
    setProperty('lightbottom.alpha', 0)
    setProperty('lightbottom.color', getColorFromHex("CCCCCC"))
    addLuaSprite("lightbottom")

    mechanic = not EasyMode and Mechanic
    shadersOption = getPropertyFromClass("ClientPrefs", "shaders")
    if shadersOption then
        initLuaShader("OldTV")
        initLuaShader("rain")

        makeLuaSprite("oldTvEffect", "", 0, 0)
        makeLuaSprite("oldTVNoStatic")
        makeLuaSprite("rainhehe", "", 0, 0)


        setSpriteShader("rainhehe", "rain")
        setSpriteShader("oldTvEffect", "OldTV")
        setSpriteShader("oldTVNoStatic", "OldTV")



        makeLuaSprite("noiseAlphaHolder", nil, 1, 0)
        setProperty("noiseAlphaHolder.alpha", 0)
        addLuaSprite("noiseAlphaHolder", false)
    end

    makeLuaSprite('blackOverlay', '', 9, 0)
    makeGraphic('blackOverlay', screenWidth, screenHeight, '000000')
    setObjectCamera('blackOverlay', 'other')
    setProperty('blackOverlay.alpha', 0)
    screenCenter('blackOverlay')
    addLuaSprite('blackOverlay', false)

    makeLuaSprite('vignette', 'vignette', 0, 0)
    setObjectCamera('vignette', 'other')
    setProperty('vignette.alpha', 0)
    screenCenter('vignette')
    scaleObject('vignette', 1, 1)
    addLuaSprite('vignette', true)

    setGlobalFromScript("stages/discordStage", "opponentTyping", "(Delta is typing...)")

    setProperty("dad.healthIcon", "depress")
    runHaxeCode([[
        game.iconP2.changeIcon("icon-depress");
    ]])
end

function onBeatHit()
    if curBeat > 64 and curBeat <= 128 then
        if curBeat % 4 == 0 then
            setProperty('lightbottom.alpha', 1)
            doTweenAlpha('goAway', 'lightbottom', 0, 2, 'linear')
        end
    end
    if (curBeat > 128 and curBeat <= 192) or (curBeat > 256 and curBeat <= 320) or (curBeat > 384 and curBeat <= 512) then
        if curBeat % 4 == 0 then
            setProperty('lightbottom.alpha', 1)
            doTweenAlpha('goAway', 'lightbottom', 0, 0.5, 'linear')
        end
        if curBeat % 4 == 2 then
            setProperty('lightbottom.alpha', 1)
            doTweenAlpha('goAway', 'lightbottom', 0, 0.5, 'linear')
        end
    end
    if curBeat > 512 and curBeat <= 640 then
        if curBeat % 1 == 0 then
            setProperty('lightbottom.alpha', 1)
            doTweenAlpha('goAway', 'lightbottom', 0, 0.5, 'linear')
        end
    end
    if curBeat == 584 then
        doTweenAngle('icon', 'iconP1', 360, 1, 'quartOut')
    end
end

function onStepEvent(curStep)
    --runa time!!
    if curStep == 896 or curStep == 902 or curStep == 909 or curStep == 928 or curStep == 935 or curStep == 940 or curStep == 960 or curStep == 966 or curStep == 972 or curStep == 992 or curStep == 999 or curStep == 1004 then
        setProperty('lightbottom.alpha', 1)
            doTweenAlpha('goAway', 'lightbottom', 0, 0.3, 'linear')
    end
    if curStep == 256 then
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x90FFFFFF", 2)
        if shadersOption then
            runHaxeCode([[
                var oldTvFilter = new ShaderFilter(game.getLuaObject("oldTVNoStatic").shader);
                var rainFilter = new ShaderFilter(game.getLuaObject("rainhehe").shader);
                camDiscord.setFilters([rainFilter, oldTvFilter]);
                camBDiscord.setFilters([rainFilter, oldTvFilter]);
                game.camHUD.setFilters([rainFilter, oldTvFilter]);
            ]])
        end
        setProperty('camDiscord.angle', 10)
        OpponentTextAngle = true
    end
    if curStep == 512 then 
        cameraFlash("camOther", "FFFFFF", 2)
        setProperty('iconSpeed', 1)
    end
    if curStep == 503 then
        if shadersOption then
            doTweenX("noiseTween", "noiseAlphaHolder", 15, 11, "linear")
        end
    end
    if curStep == 512 then
        if shadersOption then
            doTweenX("noiseTween", "noiseAlphaHolder", 1, 1, "linear")
        end
    end
    if curStep == 752 then
        if shadersOption then
            doTweenX("noiseTween", "noiseAlphaHolder", 15, 7, "linear")
        end
    end
    if curStep == 768 then
        setProperty('blackOverlay.alpha', 1)
        doTweenAlpha('blackTween', 'blackOverlay', 0, 7)
        callScript("stages/discordStage", "lightingMode", {true})
        setTextColor("opponentName", "000000")
        if shadersOption then
            doTweenX("noiseTween", "noiseAlphaHolder", 1, 2, "linear")
        end
        setProperty('iconSpeed', 0)

        setProperty('opponent.visible', false)
        setProperty('opponentText.visible', false)
        setProperty('opponentName.visible', false)
        setProperty('opponent.alpha', 0)
        setProperty('opponentText.alpha', 0)
        setProperty('opponentName.alpha', 0)
    end
    if curStep == 832 then
        setProperty('opponent.visible', true)
        setProperty('opponentText.visible', true)
        setProperty('opponentName.visible', true)
        doTweenAlpha('hiDelta', 'opponent', 1, 5, 'linear')
        doTweenAlpha('hiDeltaT', 'opponentText', 1, 5, 'linear')
        doTweenAlpha('hiDeltaN', 'opponentName', 1, 5, 'linear')
    end
    if curStep == 896 then
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x90FFFFFF", 0.4)
        callScript("stages/discordStage", "lightingMode", {false})
        setTextColor("opponentName", "FFFFFF")
        if shadersOption then
           setShaderFloat("rainhehe", "iIntensity", 0.13)
        end
    end
    if curStep == 902 or curStep == 909 or curStep == 928 or curStep == 935 or curStep == 940 or curStep == 960 or curStep == 966 or curStep == 972 or curStep == 992 or curStep == 999 or curStep == 1004 then
        cameraFlash("camOther", flashingLights and "0x40FFFFFF", 0.3)
    end
    if curStep == 1024 then
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x80FFFFFF", 1.2)
        setProperty('iconSpeed', 1)
    end
    if curStep == 1256 then
        if shadersOption then
            doTweenX("noiseTween", "noiseAlphaHolder", 20, 13, "linear")
        end
    end
    if curStep == 1280 then
        loadGraphic("player", profiles.."runa")
        setGraphicSize("player", 649 * 0.625, 146 * 0)
        cameraFlash("camOther", "FFFFFF", 1)
        setTextString("playerText", "...")
        setTextString("playerName", "Spook")
        setTextColor("playerName", "9C02D6")

        setProperty('player.alpha', 0)
        setProperty('playerText.alpha', 0)
        setProperty('playerName.alpha', 0)

        setProperty('player.visible', false)
        setProperty('playerText.visible', false)
        setProperty('playerName.visible', false)

        scaleObject("player", 0.5, 0.5)
        setProperty("player.offset.x", 10)
        setProperty("playerName.offset.y", 80)
        setProperty("player.offset.y", 25)

        if shadersOption then
            setShaderFloat("rainhehe", "iIntensity", 0.2)
            doTweenX("noiseTween", "noiseAlphaHolder", 1, 1, "linear")
        end
        setProperty('iconSpeed', 0)
    end
    if curStep == 1300 then
        setProperty('player.alpha', 1)
        setProperty('playerText.alpha', 1)
        setProperty('playerName.alpha', 1)

        setProperty('player.visible', true)
        setProperty('playerText.visible', true)
        setProperty('playerName.visible', true)

        setProperty('player.y', -500)
        doTweenY('hiRuna', 'player', 270, 2, 'expoOut')
    end
    if curStep == 1536 then
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x40FFFFFF", 1)
        setProperty('iconSpeed', 1)
    end
    if curStep == 2560 or curStep == 2566 or curStep == 2572 then
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x30FFFFFF", 0.3)
    end
    if curStep == 2576 then
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x90FFFFFF", 1.2)
    end

    if curStep == 2592 then
        if shadersOption then
            doTweenX("noiseTween", "noiseAlphaHolder", 200, 20, "linear")
        end
    end


    -- all of this is camera zooms lmao
    if curStep == 320 then
        doTweenVar('zoomTween', 'defaultCamZoom', 1.7, 6, 'expoIn')
    end
    if curStep == 384 then
        doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.5, 'expoOut')
    end
    if curStep == 496 then
        doTweenVar('zoomTween', 'defaultCamZoom', 1.4, 0.5, 'expoOut')
    end
    if curStep == 512 then
        doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 1, 'expoOut')
    end
    if curStep == 768 then
        setProperty('defaultCamZoom', 1.6)
        doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 7.5, 'sineInOut')
    end
    if curStep == 888 then
        doTweenVar('zoomTween', 'defaultCamZoom', 1.9, 0.5, 'expoIn')
    end
    if curStep == 896 then
        doTweenVar('zoomTween', 'defaultCamZoom', 1, 1, 'expoOut')
    end
    if curStep == 1008 then
        doTweenVar('zoomTween', 'defaultCamZoom', 1, 0.3, 'expoOut')
    end
    if curStep == 1016 then
        doTweenVar('zoomTween', 'defaultCamZoom', 1.8, 0.5, 'expoIn')
    end
    if curStep == 1024 then
        doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 1, 'expoOut')
    end
    if curStep == 1280 then
        doTweenVar('zoomTween', 'defaultCamZoom', 1.3, 11, 'sineInOut')
    end
    if curStep == 1408 then
        doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 11, 'sineInOut')
    end
    if curStep == 1600 then
        doTweenVar('zoomTween', 'defaultCamZoom', 1, 0.5, 'expoOut')
    end
    if curStep == 1664 then
        doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.5, 'expoOut')
    end
    if curStep == 1792 then
        doTweenVar('zoomTween', 'defaultCamZoom', 1.3, 6, 'sineInOut')
    end
    if curStep == 1856 then
        doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.5, 'expoOut')
    end
    if curStep == 1888 then
        doTweenVar('zoomTween', 'defaultCamZoom', 0.95, 0.5, 'expoOut')
    end
    if curStep == 1920 then
        doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.5, 'expoOut')
    end
    if curStep == 2040 then
        doTweenVar('zoomTween', 'defaultCamZoom', 1.4, 0.2, 'expoIn')
    end
    if curStep == 2048 then
        doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 14, 'sineInOut')
    end
    if curStep == 2304 then
        doTweenVar('zoomTween', 'defaultCamZoom', 1.3, 10, 'sineInOut')
    end
    if curStep == 2560 then
        doTweenVar('zoomTween', 'defaultCamZoom', 0.9, 0.01, 'expoOut')
    end
    
    -- i am so sorry to anyone who is reading this code, i know theres a way easier way to do this :sob:

    if curStep == 896 and not Modchart then
        for i = 4, 7 do
            local targetX = 412 + (i - 4) * 112
            noteTweenX("middlescroll"..i, i, targetX, 5, "sineOut")
        end
        for i = 0, 3 do
            local targetX = -200 + (i - 4) * 112
            noteTweenX("middlescroll"..i, i, targetX, 6, "sineOut")
        end
    end
    if curStep == 1024 and not Modchart then
        for i = 0, 3 do
            noteTweenX("ogPos"..i, i, originalOPStrumX[i], 0.01, "linear")
        end
        for i = 4, 7 do
            noteTweenX("ogPos"..i, i, originalBFStrumX[i], 0.01, "linear")
        end
    end

end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    if mechanic then
        local health = getProperty('health')

        if health <= 0.1 then return end

        local maxDrain = 0.02
        local minDrain = 0.005

        local scaledDrain = maxDrain * health
        if scaledDrain < minDrain then
            scaledDrain = minDrain
        end

        if health - scaledDrain < 0.1 then
            scaledDrain = health - 0.1
        end

        setProperty('health', health - scaledDrain)
    end

    if not isSustainNote then
        if OpponentTextAngle then
            local newTextAngle = lastTextAngle

            while newTextAngle == lastTextAngle do
                -- Generate float between -2 and 2
                newTextAngle = (math.random() * 4) - 2
                newTextAngle = math.floor(newTextAngle * 100) / 100 -- optional: round to 2 decimal places
            end

            setProperty('opponentText.angle', newTextAngle)
            lastTextAngle = newTextAngle
        end

        local newCamAngle = lastCamAngle

        while newCamAngle == lastCamAngle do
            newCamAngle = getRandomInt(-1, 1)
        end

        doTweenAngle('discordHehe', 'camDiscord', newCamAngle, 0.3, 'sineout')
        lastCamAngle = newCamAngle


        if not Modchart then
            local newHUDAngle = lastHUDAngle

            while newHUDAngle == lastHUDAngle do
                newHUDAngle = getRandomInt(-2, 2)
            end

            doTweenAngle('hudMove', 'camHUD', newHUDAngle, 0.33, 'sineout')
            lastHUDAngle = newHUDAngle
        end
    end

    oppSinging = true
    singTimer = singCooldown
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if not isSustainNote then
        local newCamAngle = lastCamAngle

        while newCamAngle == lastCamAngle do
            newCamAngle = getRandomInt(-1, 1)
        end

        doTweenAngle('discordHehe', 'camDiscord', newCamAngle, 0.3, 'sineout')
        lastCamAngle = newCamAngle

        if not Modchart then
            local newHUDAngle = lastHUDAngle

            while newHUDAngle == lastHUDAngle do
                newHUDAngle = getRandomInt(-2, 2)
            end

            doTweenAngle('hudMove', 'camHUD', newHUDAngle, 0.33, 'sineout')
            lastHUDAngle = newHUDAngle
        end
    end

    local gain = 0.001
    if oppSinging then
        gain = 0.010
    end

    setProperty('health', getProperty('health') + gain)
end

function onUpdate(elapsed)
    if shadersOption then
        local songPos = getSongPosition()
        setShaderFloat("oldTVNoStatic", "iTime", songPos / 1000)
        setShaderFloat("rainhehe", "iTime", songPos / 1000)
        setShaderFloat("rainhehe", "iTimescale", 0.1)
        
        local currentNoise = getProperty("noiseAlphaHolder.x")
        setShaderFloat("oldTVNoStatic", "noiseAlpha", currentNoise)
    end
    --now this where the magic come in
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

    local health = getProperty('health')

    local fadeAlpha = math.max(0, 1 - health)
    fadeAlpha = fadeAlpha * 1.2
    setProperty('vignette.alpha', fadeAlpha)

    if singTimer > 0 then
        singTimer = singTimer - elapsed
        if singTimer <= 0 then
            oppSinging = false
        end
    end

    if curBeat > 192 and curBeat < 208 then
        setProperty('opponent.alpha', 0)
        setProperty('opponentText.alpha', 0)
        setProperty('opponentName.alpha', 0)
    end
end

-- the stupid ass function
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

--[[
    Hello! I'm Runa :3
    I made a custom function called "doTweenVar" 
    If you want to use this function, well here you go!
    To use this, an example could be: doTweenVar('camZooming', 'defaultCamZoom', 1, 15)
    Keep in mind, you aren't limited to just camera zooming!
    You can do alot more with this :333

local tweens = {}

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

]]