
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
    if HardMode then
        hardEvent(curStep)
    else
        easyEvent(curStep)
    end
end

function easyEvent(curStep)
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
        local x, y = getProperty('dad.x') + (getProperty('dad.width')/2) + 100, getProperty('dad.y') + 350
        setProperty('camFollowPos.x', x)
        setProperty('camFollowPos.y', y)
        setProperty('camFollow.x', x)
        setProperty('camFollow.y', y)
        setProperty('isCameraOnForcedPos', true)

        setProperty('defaultCamZoom', 2)
        setProperty('camGame.zoom', 2)
    end
    if curStep == 400 then
        local x, y = getProperty('boyfriend.x') + (getProperty('boyfriend.width')/2) + 100, getProperty('boyfriend.y') + 350
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
        --setProperty('particleAmount', 1)
        --setProperty('particleSpeed', 2)
        setProperty('showMode', true)
        setProperty("defaultCamZoom", 0.6)
    end
    if curStep == 640 then
        setProperty('cameraSpeed', 2)
    end
    if curStep == 672 then
        setProperty('cameraSpeed', 1)
    end
    if curStep == 1056 then
        setProperty('checker.color', getColorFromHex("000000"))
        setProperty('ground.color', getColorFromHex("000000"))
    end
    if curStep == 1568 then
        doTweenColor('groundC', 'ground', 'DC000F', 0.2, 'linear')
        doTweenColor('checkerC', 'checker', 'DC000F', 0.2, 'linear')
        -- local chars = {'dad', 'boyfriend', 'dadTrail', 'boyfriendTrail'}
        -- for i, v in pairs(chars) do
        --     setProperty(v..'.colorTransform.redOffset', 0)
        --     setProperty(v..'.colorTransform.greenOffset', 0)
        --     setProperty(v..'.colorTransform.blueOffset', 0)
        -- end
        -- setProperty('dad.color', 0xFFFFFFFF)
        -- setProperty('boyfriend.color', 0xFFFFFFFF)
    end
end

function hardEvent(curStep)
    if curStep == 160 then
        cameraFlash("camGame", '000000', 4)
        cameraFlash("camHUD", '000000', 1)
        setProperty('checker.color', getColorFromHex("000000"))
        setProperty('ground.color', getColorFromHex("000000"))
    end

    if curStep == 416 then
        cameraFlash("camGame", 'DC000F', 1)
        setProperty('checker.color', getColorFromHex("DC000F"))
        setProperty('checker.alpha', 0.2)
        setProperty('ground.color', getColorFromHex("DC000F"))
        setProperty('showMode', true)
        setProperty("defaultCamZoom", 0.6)
    end
    if curStep == 640 then
        doTweenX('checkerx', 'checker.velocity', 100 * 16, crochet/1000 * 7, 'quadIn')
        doTweenY('checkery', 'checker.velocity', -30 * 16, crochet/1000 * 7, 'quadIn')
    end
    if curStep == 672 then
        doTweenX('checkerx', 'checker.velocity', 100, crochet/1000, 'linear')
        doTweenY('checkery', 'checker.velocity', -30, crochet/1000, 'linear')
        cameraFlash("camGame", '000000', 10)
    end
    if curStep == 1200 then
        setWhite('ground', true)
    end
    if curStep == 1204 then
        setWhite('ground', false)
    end
    if curStep == 1208 then
        setWhite('checker', true)
    end
    if curStep == 1210 then
        setWhite('checker', false)
    end
    if curStep == 1212 then
        setWhite('ground', true)
        setWhite('checker', false)
    end
    if curStep == 1213 then
        setWhite('ground', false)
        setWhite('checker', true)
    end
    if curStep == 1214 then
        setWhite('ground', true)
        setWhite('checker', false)
    end
    if curStep == 1215 then
        setWhite('ground', false)
        setWhite('checker', true)
    end
    if curStep == 1216 then
        setWhite('ground', false)
        setWhite('checker', false)
        cameraFlash("camGame", '000000', 10)
        setProperty('checker.color', getColorFromHex("000000"))
        setProperty('ground.color', getColorFromHex("000000"))
        setProperty('showMode', false)
        setProperty("defaultCamZoom", 0.9)
    end
    if curStep == 1472 then
        cameraFlash("camGame", 'DC000F', 1)
        setProperty('checker.color', getColorFromHex("DC000F"))
        setProperty('checker.alpha', 0.2)
        setProperty('ground.color', getColorFromHex("DC000F"))
        setProperty('showMode', true)
        setProperty("defaultCamZoom", 0.6)
    end
    if curStep == 1852 then
        doTweenX('checkerx', 'checker.velocity', 100 * 10, crochet/1000 * 1, 'quadIn')
        doTweenY('checkery', 'checker.velocity', -30 * 10, crochet/1000 * 1, 'quadIn')
    end
    if curStep == 2080 then
        doTweenX('checkerx', 'checker.velocity', 100, crochet/1000 * 2, 'linear')
        doTweenY('checkery', 'checker.velocity', -30, crochet/1000 * 2, 'linear')
    end
end

function onStepHit()
    if HardMode then
        if (curStep >= 288 and curStep < 400) and (curStep % 16 == 8) then
            setProperty('ground.color', getColorFromHex("FFFFFF"))
            doTweenColor('groundC', 'ground', '000000', crochet/1000*3, 'quadOut')

            setProperty('checker.color', getColorFromHex("AAAAAA"))
            doTweenColor('checkerC', 'checker', '000000', crochet/1000*3, 'quadOut')
            checkBeat(3)
        end
        if (curStep >= 416 and curStep < 640) and curStep % 8 == 4 then
            setProperty('ground.color', getColorFromHex("DB535E"))
            doTweenColor('groundC', 'ground', 'DC000F', crochet/1000*1.5, 'quadOut')
        end
        if (curStep >= 928 and curStep < 1184) and curStep % 4 == 0 then
            setProperty('ground.color', getColorFromHex("DB535E"))
            doTweenColor('groundC', 'ground', 'DC000F', crochet/1000*1, 'quadOut')

            checkBeat(1)
        end
        if (curStep >= 1472 and curStep < 1728) and curStep % 8 == 4 then
            checkBeat(2)
        end
        if (curStep >= 1856 and curStep < 2080) and (curStep % 8 == 4) then
            setProperty('ground.color', getColorFromHex("DB535E"))
            doTweenColor('groundC', 'ground', 'DC000F', crochet/1000*1.5, 'quadOut')
        end
        if (curStep >= 2112 and curStep < 2352) and curStep % 4 == 0 then
            setProperty('ground.color', getColorFromHex("DB535E"))
            doTweenColor('groundC', 'ground', 'DC000F', crochet/1000*1, 'quadOut')

            checkBeat(1)
        end
    else
        if ((curStep >= 128 and curStep < 256)) and (curStep % 16 == 0 or curStep % 64 == 56) then
            triggerEvent('Add Camera Zoom', 0.015 * 6, 0.03 * 2)
            checkBeat(3)
        end
        if checkStep({388, 392, 400, 404}) then
            triggerEvent('Add Camera Zoom', 0.015 * 6, 0.03 * 2)
            checkBeat(1)
        end
        if curStep >= 416 and curStep < 640 then
            if curStep % 8 == 4 then
                setProperty('ground.color', getColorFromHex("DB535E"))
                doTweenColor('groundC', 'ground', 'DC000F', crochet/1000*1.5, 'quadOut')
            end
        end
        if checkStep({644, 652, 660, 668}) then
            triggerEvent('Add Camera Zoom', 0.015 * 6, 0.03 * 2)
            checkBeat(1)
        end
        if ((curStep >= 672 and curStep < 928) or (curStep >= 1568 and curStep < 1824)) then
            if (curStep % 8 == 0) then
                triggerEvent('Add Camera Zoom', 0.015 * 1, 0.03 * 1)
                checkBeat(1.5)
            end
            if curStep % 8 == 4 then
                setProperty('ground.color', getColorFromHex("DB535E"))
                doTweenColor('groundC', 'ground', 'DC000F', crochet/1000*1.5, 'quadOut')
            end
        end
        if (curStep >= 928 and curStep < 1056) and (curStep-16 % 16 == 0 or curStep-16 % 64 == 56) then
            triggerEvent('Add Camera Zoom', 0.015 * 6, 0.03 * 2)
            checkBeat(3)
        end
        if ((curStep >= 1056 and curStep < 1552) and (curStep % 8 == 0)) or (curStep >= 1552 and curStep % 4 == 0 and curStep < 1568) then
            if (curStep < 1552 and curStep % 16 == 8) or curStep >= 1552 then
                setProperty('ground.color', getColorFromHex("FFFFFF"))
                doTweenColor('groundC', 'ground', '000000', crochet/1000*(curStep >= 1552 and 1 or 2), 'quadOut')
                -- local chars = {'dad', 'boyfriend', 'dadTrail', 'boyfriendTrail'}
                -- for i, v in pairs(chars) do
                --     setProperty(v..'.colorTransform.redOffset', 255)
                --     setProperty(v..'.colorTransform.greenOffset', 255)
                --     setProperty(v..'.colorTransform.blueOffset', 255)
                -- end
            end
            if (curStep < 1552 and curStep % 16 == 0) or curStep >= 1552 then
                setProperty('checker.color', getColorFromHex("EEEEEE"))
                doTweenColor('checkerC', 'checker', '000000', crochet/1000*(curStep >= 1552 and 1 or 2), 'quadOut')
                checkBeat(2)
                -- local chars = {'dad', 'boyfriend', 'dadTrail', 'boyfriendTrail'}
                -- for i, v in pairs(chars) do
                --     setProperty(v..'.colorTransform.redOffset', 0)
                --     setProperty(v..'.colorTransform.greenOffset', 0)
                --     setProperty(v..'.colorTransform.blueOffset', 0)
                -- end
                -- setProperty('dad.color', 0xFF000000)
                -- setProperty('boyfriend.color', 0xFF000000)
            end
        end
    end
end

function particle(amount, speed)
    --callOnLuas('createBackParticle', {amount, speed})
end

function checkBeat(dur)
    callOnLuas('beatChecker', {dur})
end

function setWhite(obj, white)
    setProperty(obj..'.colorTransform.redOffset', (white and 255 or 0))
    setProperty(obj..'.colorTransform.greenOffset', (white and 255 or 0))
    setProperty(obj..'.colorTransform.blueOffset', (white and 255 or 0))
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if not HardMode and (curBeat >= 264 and curBeat < 328) then
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