local beatHardSnares = false
local zoomMultiply = 1
local opponentHitDistract = false

local membersSprites = {}
local lerpMem = true
local switcha = false

local intense = false

function onCreatePost()
    mechanic = not EasyMode and Mechanic

    luaDebugMode = true
    makeLuaSprite('shake', '', 0, 0)
    if shadersEnabled then
        initLuaShader("RGB_PIN_SPLIT")
        initLuaShader("GlitchShader")

        makeLuaSprite("lens", nil, 0, 0); setSpriteShader("lens", "RGB_PIN_SPLIT")
        makeLuaSprite("glitch", nil, 0.001, 0); setSpriteShader("glitch", "GlitchShader")

        setShaderFloat('lens', 'amount', 0.0)
        setShaderFloat('lens', 'distortionFactor', 0.05)

        setShaderFloat('glitch', 'GlitchAmount', 0.001)

        runHaxeCode([[
            var lensShader = new ShaderFilter(game.getLuaObject("lens").shader);
            var glitchShader = new ShaderFilter(game.getLuaObject("glitch").shader);
            camBDiscord.setFilters([lensShader, glitchShader]);
            camDiscord.setFilters([lensShader, glitchShader]);
            game.camHUD.setFilters([lensShader, glitchShader]);
         ]])
    end

    makeLuaSprite('redOverlay', '', 0, 0)
    makeGraphic('redOverlay', 1300,  800, 'FF0000')
    setBlendMode("redOverlay", 'multiply')
    addLuaSprite('redOverlay')
    setObjectCamera('redOverlay', 'other')
    setProperty('redOverlay.alpha', 0)

    makeLuaSprite('dark', 'vignette', 0, 0)
    setBlendMode("dark", 'multiply')
    addLuaSprite('dark')
    setObjectCamera('dark', 'other')
    setProperty('dark.alpha', 1)
    screenCenter('dark')

    makeAnimatedLuaSprite("glitchy", 'glitch', 0, 0)
    addAnimationByPrefix("glitchy", "glitch", "g", 24, true)
    playAnim('glitchy', 'glitch')
    setBlendMode("glitchy", 'add')
    addLuaSprite('glitchy')
    setObjectCamera("glitchy", 'other')
    screenCenter("glitchy", 'xy')
    setProperty('glitchy.alpha', 0)

    setProperty('defaultCamZoom', 2)
    setProperty('camBDiscord.alpha', 0)

    membersSprites = getProperty("membersSprites")

    setHealthBarColors("FFFFFF", "ffc400")

    setProperty('iconSpeed', 2)
end

function onUpdate(elapsed)
    if not inGameOver then
        if (curStep >= 256 and curStep < 512) or (curStep >= 1152 and curStep < 1536) then
            if mechanic then
                setProperty('camBDiscord.angle', continuous_sin(curDecBeat/2) * 8)
            end
            if HardMode then
                setProperty('camHUD.angle', continuous_sin(curDecBeat/2) * -6)
            end
            local timeshake = ((ReduceShakeOption or not mechanic) and 0.2 or 1)
            cameraShake('camHUD', 0.01 * timeshake, 0.1 * timeshake)
            cameraShake('camHUD', 0.01 * timeshake, 0.1 * timeshake)
            runHaxeCode("getVar('camBDiscord').shake("..tostring(0.015 * timeshake)..", "..tostring(0.1 * timeshake)..", null, true);")
            runHaxeCode("getVar('camDiscord').shake("..tostring(0.015 * timeshake)..", "..tostring(0.1 * timeshake)..", null, true);")
            setProperty('glitchy.alpha', getRandomFloat(0.25, 0.5))

            if getRandomBool(5) then
                setProperty("glitchy.flipY", getProperty("glitchy.flipY") == false)
            end
            if getRandomBool(5) then
                setProperty("glitchy.flipX", getProperty("glitchy.flipX") == false)
            end
            if curStep >= 1280 then
                setProperty('redOverlay', 0.3 + (math.sin(curDecBeat/10)*0.2))
            end
        end
        local shake = getProperty('shake.x')
        for i = 4, 7 do
            setPropertyFromGroup('strumLineNotes', i, 'x', _G['defaultPlayerStrumX'..tostring(i-4)] + getRandomFloat(-shake, shake))
            setPropertyFromGroup('strumLineNotes', i, 'y', _G['defaultPlayerStrumY'..tostring(i-4)] + getRandomFloat(-shake, shake))
        end
        if lerpMem then 
            for i,v in pairs(membersSprites) do
                if not v[3] then
                    local offsetX = 7
                    setProperty(v[1]..".xAdd", lerp(getProperty(v[1]..".xAdd"), offsetX, elapsed*7))
                end
            end
            
        end

        if curStep >= 512 and curStep < 768 then
            setProperty('opponent.x', 320 + getRandomFloat(-2, 2))
        elseif curStep >= 768 and curStep < 1024 then
            setProperty('opponent.x', 320 + getRandomFloat(-4, 4))
        elseif curStep >= 1024 and curStep < 1536 then
            setProperty('opponent.x', 320 + getRandomFloat(-6, 6))
        end
        if shadersEnabled then
            if mechanic then
                setShaderFloat('glitch', 'iTime', os.clock())
            end

            setShaderFloat('lens', 'amount', getProperty('lens.x'))
            if mechanic then
                setShaderFloat('glitch', 'GlitchAmount', getProperty('glitch.x'))
            end
        end
    end

end

function onStepEvent(curStep)
    if curStep == 4 then
        doTweenAlpha('camBDiscord', 'camBDiscord', 1, 8)
    end
    if curStep == 128 then
        doTweenAlpha('dark', 'dark', 0, 0.5)
    end
    if curStep == 128 or curStep == 1024 then
        beatHardSnares = true
    end
    if curStep == 250 or curStep == 1146 or curStep == 1150 then
        triggerEvent("Add Camera Zoom", -0.015 * zoomMultiply, -0.03 * zoomMultiply)
        lensBop()
    end
    if curStep == 252 or curStep == 1148 then
        doTweenAlpha('redOverlay', 'redOverlay', (HardMode and 0.6 or 0.3), crochet/1000, 'expoIn')
    end
    if curStep == 256 or curStep == 1152 then
        setProperty('iconSpeed', 1)
        cameraFlash("hud", flashingLights and "0xB0FF0000" or "0x90FF0000", EasyMode and 0.75 or 1.5, true)
        zoomMultiply = 1.5
        intense = true
    end
    if curStep == 378 or curStep == 382 then
        triggerEvent("Add Camera Zoom", -0.015 * zoomMultiply, -0.03 * zoomMultiply)
        lensBop()
    end
    if curStep == 384 or curStep == 1280 then
        callScript("stages/discordStage", "lightingMode", {true})
        cameraFlash("other", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", EasyMode and 0.5 or 1, true)
    end
    if curStep == 506 or curStep == 510 then
        triggerEvent("Add Camera Zoom", -0.015 * zoomMultiply, -0.03 * zoomMultiply)
        lensBop()
    end
    if curStep == 512 or curStep == 1536 then
        setProperty('iconSpeed', 4)
        callScript("stages/discordStage", "lightingMode", {false})
        setProperty('redOverlay.alpha', 0)
        if curStep == 1536 then
            cameraFlash("hud", "000000", 1, true)
            runHaxeCode('camDiscord.flash(0xFF000000, 8, null, true);')
            setProperty('dark.alpha', 1)
        else
            cameraFlash("hud", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", 0.75, true)
        end
        runHaxeCode("game.camOther.flash(0xFFFFFFFF, 0.75, null, true);")
        beatHardSnares = false
        setProperty('camHUD.angle', 0)
        setProperty('camBDiscord.angle', 0)
        setProperty('camDiscord.angle', 0)
        setProperty('glitchy.alpha', 0)
        zoomMultiply = 1
        setProperty('opponent.x', 320)
        intense = false
    end
    if curStep == 640 then
        setProperty('iconSpeed', 1)
    end
    if curStep == 762 or curStep == 766 then
        triggerEvent("Add Camera Zoom", -0.015 * zoomMultiply, -0.03 * zoomMultiply)
        lensBop()
    end
    if curStep == 1024 then
        setProperty('iconSpeed', 2)
        setProperty('camHUD.x', 0)
        setProperty('camHUD.y', 0)
        setProperty('camHUD.angle', 0)
        cancelTween('camHUDx')
        cancelTween('camHUDy')
        cancelTween('camHUDangle')
    end
    if curStep == 768 then
        opponentHitDistract = true
    end
    if curStep == 1024 then
        opponentHitDistract = false
        setProperty('glitchy.alpha', 0.05)
        cancelTween("glitchy")
    end
    if curStep == 1808 then
        setProperty('camBDiscord.visible', false)
        setProperty('camDiscord.visible', false)
    end
end

function onStepHit()
   
    if (curStep % 16 == 4 or curStep % 16 == 10 or curStep % 16 == 14) and curStep >= 576 and curStep < 640 then
        switcha = switcha == false
        for i,v in pairs(membersSprites) do
            if not v[3] then
                local offsetX = 7
                setProperty(v[1]..".xAdd", offsetX + (7*(i%2==0 and 5 or -5)*(switcha and 1 or -1)))
            end
        end
    end
    if (curStep % 4 == 0) and curStep >= 640 and curStep < 1024 then
        switcha = switcha == false
        for i,v in pairs(membersSprites) do
            if not v[3] then
                local offsetX = 7
                setProperty(v[1]..".xAdd", offsetX + (7*(i%2==0 and 4 or -4)*(switcha and 1 or -1)))
            end
        end
    end
    if Mechanic and curStep >= 640 and curStep < 1024 then
        if curStep % 8 == 0 then
            doTweenX('camHUDx', 'camHUD', EasyMode and 15 or 25, crochet/1000, 'linear')
            if HardMode then
                doTweenAngle('camHUDangle', 'camHUD', 4, crochet/1000/2, 'quadOut')
            end
        end
        if curStep % 8 == 4 then
            doTweenX('camHUDx', 'camHUD', EasyMode and -15 or -25, crochet/1000, 'linear')
            if HardMode then
                doTweenAngle('camHUDangle', 'camHUD', -4, crochet/1000/2, 'quadOut')
            end
        end
        if curStep % 4 == 0 then
            doTweenY('camHUDy', 'camHUD', EasyMode and -15 or -25, crochet/1000/2, 'quadOut')
        end
        if curStep % 4 == 2 then
            doTweenY('camHUDy', 'camHUD', 0, crochet/1000/2, 'quadIn')
        end
    end

    if curStep >= 768 and curStep < 1024 and curStep % 4 == 0 then
        triggerEvent("Add Camera Zoom", 0.015, 0.03 )
    end

    if beatHardSnares then
        if curStep % 8 == 0 then
            triggerEvent("Add Camera Zoom", 0.015 * zoomMultiply, 0.03 * zoomMultiply)
            if curStep >= 1408 then
                gltichBop()
            end
        elseif curStep % 8 == 4 and curStep ~= 252 and curStep ~= 380 and curStep  ~= 508 and curStep ~= 1148 and curStep ~= 1276 then
            triggerEvent("Add Camera Zoom", -0.015 * zoomMultiply, -0.03 * zoomMultiply)
            lensBop()
        end
    end
    if opponentHitDistract and mechanic then
        if curStep % 8 == 0 then
            for i = 0, 3 do -- _G['defaultOpponentStrumX'..i]
                noteTweenX('noteComeIN'..i, i, _G['defaultOpponentStrumX'..i] + 350, crochet/1000, 'expoIn')
            end
        elseif curStep % 8 == 4 then
            for i = 0, 3 do -- _G['defaultOpponentStrumX'..i]
                noteTweenX('noteComeIN'..i, i, _G['defaultOpponentStrumX'..i], crochet/1000, 'quadOut')
            end
            setProperty('shake.x', 75)
            doTweenX('shake', 'shake', 0, crochet/1000*1.5, 'quadOut')

            setProperty("glitchy.alpha", 0.3 * (HardMode and 1.25 or 1))
            doTweenAlpha('glitchy', 'glitchy', 0, crochet/1000, 'expoIn')
            addHealth(-0.075 * (HardMode and 1.25 or 1))

            setProperty('songSpeed', getPropertyFromClass("PlayState", "SONG.speed") * 0.6 * (HardMode and 0.9 or 1))
            triggerEvent('Change Scroll Speed', 1, crochet/1000)

            lensBop()
            gltichBop()
        end
    end
end
function lensBop(multiply)
    if shadersEnabled then
        setProperty('lens.x', (intense and 0.1 or 0.03) * (multiply or 1))
        doTweenX('lens', 'lens', 0, crochet/1000, 'quadOut')
    end
end

function gltichBop(multiply)
    if shadersEnabled then
        setProperty('glitch.x', (HardMode and 1.6 or 0.8) * (multiply or 1))
        doTweenX('glitch', 'glitch', 0.001, crochet/1000*1.5, 'quadOut')
        setProperty('lerpShakeBar', 10)
    end
end

function continuous_sin(x)
    return math.sin((x % 1) * 2 * math.pi)
end
function lerp(a, b, t) return a + (b - a) * t end