showMode = false
centerCam = false centerX = 550 centerY = 300
thisCameraSystem = true
local isHardmode = false

function onCreatePost()
    isHardmode = false

    luaDebugMode = true 
    makeLuaSprite("middleGlow", "ammarvoid/GreenGradientMiddle",-1200 ,-200)
    scaleObject("middleGlow", 3, 1.5)
    addLuaSprite("middleGlow")
    setProperty("middleGlow.alpha", 0.05)
    setScrollFactor("middleGlow", 0.6, 0.6)

    makeLuaSprite("bottomGlow", "ammarvoid/GreenGradientBottom",-450 ,200)
    scaleObject("bottomGlow", 2, 1.1)
    addLuaSprite("bottomGlow", true)
    setProperty("bottomGlow.alpha", 0)
    setScrollFactor("bottomGlow", 0.0, 0.0)
    setBlendMode("bottomGlow", "add")

    makeLuaSprite("middleGlowOverlay", "ammarvoid/GreenGradientMiddle",-1200 ,-1200)
    scaleObject("middleGlowOverlay", 3, 1.25)
    addLuaSprite("middleGlowOverlay", true)
    setProperty("middleGlowOverlay.alpha", 0.05)
    setScrollFactor("middleGlowOverlay", 0.6, 0.6)
    setBlendMode("middleGlowOverlay", "add")

    makeLuaSprite("bfOverlay", "", -400 , -300)
    makeGraphic("bfOverlay", 1400, 900, "00FF00")
    addLuaSprite("bfOverlay", true)
    setScrollFactor("bfOverlay", 0, 0)
    scaleObject("bfOverlay", 1.54, 1.5, true)
    setBlendMode("bfOverlay", "multiply")
    setProperty("bfOverlay.alpha", 0)

    runHaxeCode([[
        setVar('particleAmount', 0);
        setVar('particleSpeed', 0);
        setVar('showMode', false);
    ]])

    setProperty('particleAmount', 0)
    setProperty('particleSpeed', 0)
end

local targetCamX, targetCamY = 0, 0

function onStepHit()
    if songName:lower() == "no-debug" then
        if (curBeat < 64 and not isHardmode) or (curBeat < 96 and isHardmode) then
            if curStep % 16 == 0 then
                setProperty("bottomGlow.alpha", 1)
                doTweenAlpha("bottonGlowGone", "bottomGlow", 0, 0.25 )
            elseif curStep % 16 == 2 then
                setProperty("bottomGlow.alpha", 0.9)
                doTweenAlpha("bottonGlowGone", "bottomGlow", 0, 0.25)
            elseif curStep % 16 == 4 then
                setProperty("bottomGlow.alpha", 0.8)
                doTweenAlpha("bottonGlowGone", "bottomGlow", 0, 0.25)
            elseif curStep % 16 == 6 then
                setProperty("bottomGlow.alpha", 0.7)
                doTweenAlpha("bottonGlowGone", "bottomGlow", 0, 1)
            end
        elseif (curBeat >= 68 and not isHardmode) or (curBeat >= 100 and not isHardmode) then
            if curStep % 16 == 0 then
                setProperty("bottomGlow.alpha", 0.9)
                doTweenAlpha("bottonGlowGone", "bottomGlow", 0, crochet/1000*4)

                setProperty("middleGlowOverlay.alpha", 0.5)
                doTweenAlpha("middleGlowOverlay", "middleGlowOverlay", 0.25, crochet/1000*2)
            end
        end
        if ((curStep == 68*4 or curStep == 360*4) and not isHardmode) or ((curStep == 100*4 or curStep == 360*4) and isHardmode) then
            showMode = true
            setProperty("middleGlow.alpha", 0.5)
            setProperty("middleGlowOverlay.alpha", 0.25)

            setProperty("bfOverlay.alpha", 0.3)
        end

        if  (curStep == 292*4 and not isHardmode) or (curStep == 324*4 and not isHardmode) then
            showMode = false
            setProperty("middleGlow.alpha", 0.05)
            setProperty("middleGlowOverlay.alpha", 0.05)

            setProperty("bfOverlay.alpha", 0)
        end

        if (((curBeat >= 68 and curBeat < 292) or (curBeat >= 360 and curBeat < 488)) and not isHardmode) or
        (((curBeat >= 100 and curBeat < 324) or (curBeat >= 392 and curBeat < 520)) and isHardmode) then
            createBackParticle(2, 1)
        end
        if ((((curBeat >= 196 and curBeat <= 260) or (curBeat >= 422 and curBeat <= 488)) and not isHardmode) or
        (((curBeat >= 228 and curBeat <= 292) or (curBeat >= 456 and curBeat <= 520)) and isHardmode)) and curStep % 4 == 0 then
            createBackParticle(25, 0.2)
        end
        if (curBeat >= 292 and curBeat < 356 and curStep % 8 == 0 and not isHardmode) or (curBeat >= 324 and curBeat < 388 and curStep % 8 == 0 and isHardmode) then
            createBackParticle(75, 0.4)
        end
    else
        if getProperty('particleAmount') ~= 0 or getProperty('particleSpeed') ~= 0 then
            createBackParticle(getProperty('particleAmount'), getProperty('particleSpeed'))
        end
    end
end

local thingLerp = 1
function onUpdate(elapsed)
    if not inGameOver and not getProperty('isCameraOnForcedPos') and thisCameraSystem then
        if centerCam then
            setProperty("camFollow.x", centerX + math.sin(getSongPosition()/500)*5)
            setProperty("camFollow.y", centerY + math.cos(getSongPosition()/700)*5)
        else
            setProperty("camFollow.x", targetCamX + math.sin(getSongPosition()/500)*30)
            setProperty("camFollow.y", targetCamY + math.cos(getSongPosition()/700)*30)
        end
    end
end


local particleID = 0
function createBackParticle(amount, multSpeed)
    for i = 0, amount do
        particleID = particleID + 1
        local tag = "particleBGBack"..particleID
        makeLuaSprite(tag, "", getRandomFloat(-900, 2270), getRandomFloat(850, 900))
        makeGraphic(tag, 20, 20, "00FF00")
        addLuaSprite(tag, true)
        setBlendMode(tag, "add")

        setProperty(tag..".alpha", 0.85)
        setProperty(tag..".angle", getRandomFloat(0, 89))
        doTweenY(tag, tag, getProperty(tag..".y") - getRandomFloat(150, 400), 2 * (multSpeed or 1), "quadOut")
        doTweenAlpha("partAlphaB"..particleID, tag, 0, 2 * (multSpeed or 1))
    end
end


function onTweenCompleted(tag)
    if string.find(tag, "particleBGBack") then
        removeLuaSprite(tag, true)
    end
end

function onMoveCamera(character)
    if thisCameraSystem then
        if showMode or getProperty('showMode') and not getProperty('isCameraOnForcedPos')  then
            if character == "dad" then
                --setProperty("camFollow.x", getProperty("camFollow.x") + 300)
                setProperty("camFollow.x", 230.5)
            else
                --setProperty("camFollow.x", getProperty("camFollow.x") - 360)
                setProperty("camFollow.x", 917.5)
            end
        else
            if character == "dad" then
                --setProperty("camFollow.x", getProperty("camFollow.x") + 300)
                --setProperty("camFollow.x", 230.5)
                setProperty("camFollow.x", -92)
            else
                setProperty("camFollow.x", 1275.5)
            end
        end

        targetCamX, targetCamY = getProperty("camFollow.x"), getProperty("camFollow.y")
    end
end