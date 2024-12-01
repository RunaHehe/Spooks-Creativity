
opScores = 0
opScoresLerp = 0

function onCreate()
    setProperty('HUDtoRight', true)
end
function onCreatePost()
    luaDebugMode = true
    if HardMode then
        setProperty('newHealthSystem', true)
    end
    setProperty("camGame.maxScrollY", 1100)

    setProperty("middleGlow.alpha", 0.1)
    setProperty("middleGlowOverlay.alpha", 0.05)

    setProperty('boyfriendGroup.x', getProperty('boyfriendGroup.x') + 150)
    setProperty('dadGroup.y', getProperty('dadGroup.y') - 50)

    makeLuaText('oppScore', 'SCORES: 0', 0, 20, 700 - 20)
    setTextFont("oppScore", "HUD/gaposiss.ttf")
    setTextSize("oppScore", 20)
    setTextBorder("oppScore", 3, "0xFF121212")
    addLuaText("oppScore")
    setProperty('oppScore.borderQuality', 0)

    makeLuaText('instruction', 'You will gain less HP when your scores is below opponent\'s scores', 700, 0, 740)
    setTextFont("instruction", "HUD/gaposiss.ttf")
    setTextSize("instruction", 20)
    setTextBorder("instruction", 3, "0xFF121212")
    addLuaText("instruction")
    screenCenter('instruction', 'x')
    setProperty('instruction.borderQuality', 0)

    setProperty('iconSpeed', 2)
    setProperty('iconP2.alpha', 0)


end

function onSongStart()
    doTweenY('instruction', 'instruction', 600, crochet/500, 'quadOut')
end

function onStepEvent(curStep)
    if curStep == 64 then
        doTweenY('instruction', 'instruction', 740, crochet/500, 'cubeIn')
    end
    if curStep == 128 then
        doTweenAlpha('iconP2', 'iconP2', 1, 1)
    end
    if curStep == 256 then
        doTweenAlpha('middleGlow', 'middleGlow', 0.25, 1, 1)
        doTweenAlpha('middleGlowOverlay', 'middleGlowOverlay', 0.1, 1, 1)
    end

    if curStep == 388 then
        setProperty('camZoomingMult', 0)
        setProperty('camZooming', false)
    end
    if curStep == 396 or curStep == 408 then
        setProperty('camZooming', true)
    end
    if curStep == 400 then
        setProperty('camZooming', false)
    end
    if curStep == 388 then
        local x, y = getProperty('dad.x') + (getProperty('dad.width')/2) + 100, getProperty('dad.y') + 50
        setProperty('camFollowPos.x', x)
        setProperty('camFollowPos.y', y)
        setProperty('camFollow.x', x)
        setProperty('camFollow.y', y)
        setProperty('isCameraOnForcedPos', true)

        setProperty('defaultCamZoom', 2)
        setProperty('camGame.zoom', 2)
    end
    if curStep == 400 then
        local x, y = getProperty('boyfriend.x') + (getProperty('boyfriend.width')/2) + 350, getProperty('boyfriend.y') + 500
        setProperty('camFollowPos.x', x)
        setProperty('camFollowPos.y', y)
        setProperty('camFollow.x', x)
        setProperty('camFollow.y', y)
        setProperty('isCameraOnForcedPos', true)

        setProperty('defaultCamZoom', 1.8)
        setProperty('camGame.zoom', 1.8)
    end
    if curStep == 408 then
        setProperty('camZoomingMult', 1)
        setProperty('isCameraOnForcedPos', false)
        setProperty('defaultCamZoom', 0.6)
    end

    if curStep == 256 then
        setProperty('particleAmount', 1)
        setProperty('particleSpeed', 2)
        setProperty('showMode', true)
        setProperty("defaultCamZoom", 0.6)
    end
    if curStep == 640 then
        setProperty('cameraSpeed', 2)
    end
    if curStep == 672 then
        setProperty('cameraSpeed', 1)
    end
end

function onStepHit()
    if ((curStep >= 128 and curStep < 256)) and (curStep % 16 == 0 or curStep % 64 == 56) then
        setProperty('bottomGlow.alpha', 1)
        doTweenAlpha('bottomGlow', 'bottomGlow' ,0, 1, 1)

        setProperty('middleGlow.alpha', 0.75)
        doTweenAlpha('middleGlow', 'middleGlow', 0.1, 1, 1)

        setProperty('middleGlowOverlay.alpha', 0.2)
        doTweenAlpha('middleGlowOverlay', 'middleGlowOverlay', 0.05, 1, 1)
        triggerEvent('Add Camera Zoom', 0.015 * 6, 0.03 * 2)
    end

    if checkStep({388, 392, 400, 404}) then
        setProperty('bottomGlow.alpha', 1)
        doTweenAlpha('bottomGlow', 'bottomGlow' ,0, 0.5)

        setProperty('middleGlow.alpha', 1)
        doTweenAlpha('middleGlow', 'middleGlow', 0.25, 0.5)

        setProperty('middleGlowOverlay.alpha', 0.5)
        doTweenAlpha('middleGlowOverlay', 'middleGlowOverlay', 0.1, 0.5)
        particle(60, 0.4)
        triggerEvent('Add Camera Zoom', 0.015 * 2.5, 0.03 * 2.5)
    end

    if curStep >= 416 and curStep%8==0 and curStep < 640 then
        setProperty('bottomGlow.alpha', 1)
        doTweenAlpha('bottomGlow', 'bottomGlow' ,0, 0.5)
        if curStep >= 544 then
            setProperty('middleGlow.alpha', 0.5)
            doTweenAlpha('middleGlow', 'middleGlow', 0.25, 0.5)
    
            setProperty('middleGlowOverlay.alpha', 0.25)
            doTweenAlpha('middleGlowOverlay', 'middleGlowOverlay', 0.1, 0.5)
        end
    end

    if curStep >= 640 and curStep%8==4 and curStep < 672 then
        setProperty('bottomGlow.alpha', 1)
        doTweenAlpha('bottomGlow', 'bottomGlow' ,0, 0.5)

        setProperty('middleGlow.alpha', 1)
        doTweenAlpha('middleGlow', 'middleGlow', 0.25, 0.5)

        setProperty('middleGlowOverlay.alpha', 0.5)
        doTweenAlpha('middleGlowOverlay', 'middleGlowOverlay', 0.1, 0.5)

        particle(60, 0.4)
        triggerEvent('Add Camera Zoom', 0.015 * 2.5, 0.03 * 2.5)
    end

    if curStep >= 672 and curStep%8==0 and curStep < 928 then
        setProperty('bottomGlow.alpha', 1)
        doTweenAlpha('bottomGlow', 'bottomGlow' ,0, 0.5)

        setProperty('middleGlow.alpha', 0.5)
        doTweenAlpha('middleGlow', 'middleGlow', 0.25, 0.5)

        setProperty('middleGlowOverlay.alpha', 0.25)
        doTweenAlpha('middleGlowOverlay', 'middleGlowOverlay', 0.1, 0.5)

        setProperty('camGame.angle', curStep%16==0 and 5 or -5)
        doTweenAngle('camGame', 'camGame', 0, 0.5, 'quadout')

        particle(20, 0.4)
        triggerEvent('Add Camera Zoom', 0.015 * 2.5, 0.03 * 2.5)
    end

    if ((curStep >= 928 and curStep < 1056)) and (curStep % 16 == 0 or (curStep+8) % 64 == 56) then
        setProperty('bottomGlow.alpha', 1)
        doTweenAlpha('bottomGlow', 'bottomGlow' ,0, 1, 1)

        setProperty('middleGlow.alpha', 0.75)
        doTweenAlpha('middleGlow', 'middleGlow', 0.1, 1, 1)

        setProperty('middleGlowOverlay.alpha', 0.2)
        doTweenAlpha('middleGlowOverlay', 'middleGlowOverlay', 0.05, 1, 1)
        triggerEvent('Add Camera Zoom', 0.015 * 6, 0.03 * 2)
    end

    if curStep >= 1568 and curStep%8==0 and curStep < 1824 then
        setProperty('bottomGlow.alpha', 1)
        doTweenAlpha('bottomGlow', 'bottomGlow' ,0, 0.5)

        setProperty('middleGlow.alpha', 0.5)
        doTweenAlpha('middleGlow', 'middleGlow', 0.25, 0.5)

        setProperty('middleGlowOverlay.alpha', 0.25)
        doTweenAlpha('middleGlowOverlay', 'middleGlowOverlay', 0.1, 0.5)

        setProperty('camGame.angle', curStep%16==0 and 5 or -5)
        doTweenAngle('camGame', 'camGame', 0, 0.5, 'quadout')

        particle(20, 0.4)
        triggerEvent('Add Camera Zoom', 0.015 * 2.5, 0.03 * 2.5)
    end
end

function particle(amount, speed)
    callOnLuas('createBackParticle', {amount, speed})
end


function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if (curBeat >= 264 and curBeat < 328) then
        addHealth(isSustainNote and -0.003 or -0.0062)
    end
    if HardMode then
        addHealth(-0.0042)
    end
    if getHealth() < 0.05 then
        setHealth(0.05)
    end
    if not isSustainNote then
        opScores = opScores + (EasyMode and 220 or 275)
        if HardMode then
            opScores = opScores + 20
        end
    end
end

function checkStep(array)
    for i,v in pairs(array) do
        if curStep == v then
            return true
        end
    end
    return false
end
function onUpdatePost(elapsed)
    
    if not inGameOver then
        setProperty('scoreTxt.x', 1280 - 20 - getProperty('scoreTxt.width'))
        setProperty('rateTxt.x', 1280 - 20 - getProperty('rateTxt.width'))
        setProperty('missTxt.x', 1280 - 20 - getProperty('missTxt.width'))
        setProperty('comboTxt.x', 1280 - 20 - getProperty('comboTxt.width'))

        opScoresLerp = lerp(opScoresLerp, opScores, elapsed*12) 
        setTextString("oppScore", "SCORES: " .. tostring(math.ceil(opScoresLerp)))
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if opScores > getProperty('songScore') and not isSustainNote then
        addHealth(-0.02)
    end
end

function lerp(a, b, t)
	return a + (b - a) * t
end