local folder = ""

shaker = 0
shakeAdd = 0;
shakerTime = 5

mechanic = true
isAngry = false

glowBeat = false

defaultNote = {}

glitchBeat = false

shaderE = false

tweenGlitch = false

function onCreate()
    mechanicOption = DifficultyOption == "normal" or DifficultyOption == "hard"

    setProperty('spawnTime', 3500)
end
function onCreatePost()
    shaderE = getPropertyFromClass("ClientPrefs", "shaders")
    if shaderE then 
        initLuaShader("Glitching")
        initLuaShader("lensDis")
        initLuaShader("GlitchShader")
        makeLuaSprite("glitchEffect", "", 0, 0)
        makeLuaSprite("lensEffect", "", 0, 0)
        makeLuaSprite("glitch2Effect", "", 0.0001, 0)
        setSpriteShader("glitchEffect", "Glitching")
        setSpriteShader("lensEffect", "lensDis")
        setSpriteShader("glitch2Effect", "GlitchShader")

        setShaderFloat("lensEffect", "intensity", 0)
        setShaderFloat("glitchEffect", "intensity", 0)
        setShaderFloat("glitch2Effect", "GlitchAmount", 0.0001)

        runHaxeCode([[
            camBYoutube.setFilters([new ShaderFilter(game.getLuaObject("lensEffect").shader), new ShaderFilter(game.getLuaObject("lowShader").shader), new ShaderFilter(game.getLuaObject("glitch2Effect").shader)]);
            game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("glitch2Effect").shader), new ShaderFilter(game.getLuaObject("lowShader").shader)]);
        ]])
    end


    setGlobalFromScript("stages/youtubeStage", "defaultZoom", 2.5)

    makeLuaSprite("glowBeat", folder.."redGlows", 0 , 0)
    addLuaSprite("glowBeat", true)
    scaleObject("glowBeat", 1.1, 1)
    screenCenter("glowBeat")
    setProperty("glowBeat.alpha", 0)
    setObjectCamera("glowBeat", "hud")
    setBlendMode("glowBeat", "add")
    

    makeLuaSprite("hackerComment", folder.."Hacker Comment", 0 , 0)
    addLuaSprite("hackerComment", true)
    scaleObject("hackerComment", 0.6, 0.6)
    screenCenter("hackerComment")
    setProperty("hackerComment.alpha", 0)
    setObjectCamera("hackerComment", "hud")

    makeLuaSprite("redGlow", folder.."redGlowing", 0 , 0)
    addLuaSprite("redGlow", true)
    scaleObject("redGlow", 2.5, 2.5)
    screenCenter("redGlow")
    setProperty("redGlow.x", getProperty("redGlow.x") - 300)
    setProperty("redGlow.alpha", 0)
    setBlendMode("redGlow", "add")
    setObjectCamera('redGlow', 'other')

    makeLuaSprite("youtubeBroke", folder.."videoNo", 0 , 0)
    addLuaSprite("youtubeBroke", true)
    screenCenter("youtubeBroke")
    setProperty("youtubeBroke.alpha", 0)
    setObjectCamera("youtubeBroke", "other")

    setProperty("dad.healthIcon", "hater")
    setProperty("boyfriend.healthIcon", "ammar"..(CuteMode and 'cute' or ''))
    runHaxeCode([[
        game.iconP2.changeIcon("icon-hater");
        game.iconP1.changeIcon("icon-ammar]]..(CuteMode and 'cute' or '')..[[");
    ]])
    setHealthBarColors("eba71e", "60f542")

    iconSpeed(0)

    setGlobalFromScript("stages/youtubeStage", "focusCam", false)
end

function SCREAM()
    shaker = 8
    shakerTime = 3
    setProperty("hackerComment.alpha", 1)
    setProperty("redGlow.alpha", 0.6)
    doTweenAngle("redGlowSpin", "redGlow", 120, 2)
    runTimer("hideScream", crochet/1000*3)

end

function onUpdatePost(elapsed)
    if not inGameOver then
        shaker = lerp(shaker, 0 ,elapsed * shakerTime)
        
        if shaderE then
            setShaderFloat("glitchEffect", "iTime", os.clock()%100)
            setShaderFloat("glitch2Effect", "iTime", os.clock())
            if getShaderFloat("lensEffect", "intensity") ~= 0 then
                setShaderFloat("lensEffect", "intensity", lerp(getShaderFloat("lensEffect", "intensity"), 0, elapsed*6))
            end
            if tweenGlitch then
                setShaderFloat("glitch2Effect", "GlitchAmount", getProperty("glitch2Effect.x"))
            end
        end

       local resultShake = (shaker + shakeAdd)/45*(ReduceShakeOption and 0.25 or 1)
       
       canGameX = 0.5 * getPropertyFromClass("flixel.FlxG", "width") * (1 - getProperty("camBYoutube.zoom")) * getPropertyFromClass("flixel.FlxG", "scaleMode.scale.x")
       canGameY = 0.5 * getPropertyFromClass("flixel.FlxG", "height") * (1 - getProperty("camBYoutube.zoom")) * getPropertyFromClass("flixel.FlxG", "scaleMode.scale.y")
       canHUDX = 0.5 * getPropertyFromClass("flixel.FlxG", "width") * (1 - getProperty("camHUD.zoom")) * getPropertyFromClass("flixel.FlxG", "scaleMode.scale.x")
       canHUDY = 0.5 * getPropertyFromClass("flixel.FlxG", "height") * (1 - getProperty("camHUD.zoom")) * getPropertyFromClass("flixel.FlxG", "scaleMode.scale.y")
       if resultShake > 0 then 
          --cameraShake("game", resultShake, 0.01)
          --cameraShake("hud", resultShake/2, 0.01)
          local randomX =  getRandomFloat(-resultShake, resultShake) * 700
          local randomY =  getRandomFloat(-resultShake, resultShake) * 700
          setProperty("camBYoutube.canvas.x", canGameX + randomX)
          setProperty("camBYoutube.canvas.y", canGameY + randomY)
 
        setProperty("camHUD.canvas.x", canHUDX + (-randomX*0.5))
        setProperty("camHUD.canvas.y", canHUDY + (-randomY/2*0.5))
       end
    end
 
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    if isAngry then 
        if not isSustainNote then 
            shaker = shaker + 0.3
        else 
            shaker = shaker + 0.1
        end
    end

    if noteType == "Hurt Note" then 
        shaker = shaker + 1

    end
end


function onStepEvent(curStep)
    if curStep == 2128 then --scream
        SCREAM()
    end

    if curStep == 64 then 
        --doTweenX("camPosX", "camPos", 240, 1, "expoOut")
        --doTweenX("zooming", "zoomYT", 2.5, 1, "quadOut")

        setGlobalFromScript("stages/youtubeStage", "focusCam", true)
        callScript("stages/youtubeStage", "setCameraLerp", {0.005})

        setGlobalFromScript("stages/youtubeStage", "beatCooldown", 4)
        iconSpeed(2)
    end
    
    if curStep == 100 then 
        --doTweenX("camPosX", "camPos", 240, 1, "expoOut")
        cancelTween("zooming")
        --doTweenX("zooming", "zoomYT", 2, 2, "quadInOut")
    end

    if curStep == 320 then 
        glowBeat = true
        iconSpeed(4)
        glitchBeat = true
    end
    if curStep == 576 then 
        iconSpeed(2)
        glitchBeat = false
    end
    if curStep == 608 or curStep == 1888 then 
        iconSpeed(4)
    end
    if curStep == 1632 then 
        iconSpeed(1)
    end 
    if curStep == 576 or curStep == 864 or curStep == 1632 or curStep == 2640 then 
        glowBeat = false
    end
    if curStep == 608 or curStep == 1376 or curStep == 2144 then 
        glowBeat = true
    end
    if curStep == 320 or curStep == 608 or curStep == 2144 then 
        setGlobalFromScript("stages/youtubeStage", "beatCooldown", 1)
        setGlobalFromScript("stages/youtubeStage", "zoomIntense", 0.15)
    end
    if curStep == 576 or curStep == 1632 or curStep == 2128 then 
        setGlobalFromScript("stages/youtubeStage", "zoomIntense", 0)
    end
    if curStep == 608 or curStep == 1376 then --! thumbnails IN

        doTweenX("thumbna", "thumbnailsPos", 600, 1, "quadOut")
    end
    if curStep == 864 or curStep == 1632 or curStep == 2656 then 

        doTweenX("thumbna", "thumbnailsPos", 800, 1, "quadIn")
    end

    if curStep+1 == 992 or curStep+1 == 1376 or curStep+1 == 2400 then
        glitchBeat = true
    end
    if curStep+1 == 1120 or curStep+1 == 1632 or curStep+1 == 2656 then
        glitchBeat = false
    end
    if curStep == 1312 then 
        setGlobalFromScript("stages/youtubeStage", "thumbnailPhase", 2)
    end

    if curStep == 1888 then 
        setGlobalFromScript("stages/youtubeStage", "beatCooldown", 2)
        setGlobalFromScript("stages/youtubeStage", "zoomIntense", 0.1)
    end

    if curStep == 2016 then 
        setGlobalFromScript("stages/youtubeStage", "beatCooldown", 1)
    end
    if curStep == 2128 then 
        isAngry = true
        callScript("stages/youtubeStage", "changeTheme", {true})
        setGlobalFromScript("stages/youtubeStage", "healthDrain", 0.04)
        shakeAdd = 0.2

        setProperty("dad.healthIcon", "hacker")
        runHaxeCode([[
        game.iconP2.changeIcon("icon-hacker");
        ]])
        setHealthBarColors("fc2e23", "60f542")

        setBlendMode("redGlow", "normal")
        setBlendMode("glowBeat", "normal")
    end

    if curStep == 2400 then 
        setGlobalFromScript("stages/youtubeStage", "thumbnailPhase", 1)

        doTweenX("thumbna", "thumbnailsPos", 600, 1, "quadOut")

        runHaxeCode([[
            camBYoutube.setFilters([new ShaderFilter(game.getLuaObject("glitchEffect").shader), new ShaderFilter(game.getLuaObject("lensEffect").shader), 
            new ShaderFilter(game.getLuaObject("lowShader").shader), new ShaderFilter(game.getLuaObject("glitch2Effect").shader)]);
        ]])
    end

    if curStep == 2656 then 
        setGlobalFromScript("stages/youtubeStage", "beatCooldown", 4)
        setGlobalFromScript("stages/youtubeStage", "zoomIntense", 0.1)
    end
    if curStep == 2912 then 
        setProperty("youtubeBroke.alpha", 1)
        cameraFlash("other", "FFFFFF" ,3)
    end

    if curStep == 960 then -- flip!!!!
        --doTweenAngle("camBYoutubeUPSIDEDOWN", "camBYoutube", 180, 1, "quadOut")
    end
    if curStep == 1120 then -- flip!!!!
        --doTweenAngle("camBYoutubeUPSIDEDOWN", "camBYoutube", 0, 1, "quadOut")
    end

    if shaderE then
        pixelEvent()
        if Mechanic then
            glitchEvent()
        end
    end
end

function onBeatHit()
    if glowBeat then 
        setProperty("glowBeat.alpha", isAngry and 1 or 0.8)
        doTweenAlpha("glowBeat", "glowBeat", 0, 0.35)
    end
    if glitchBeat then
        setShaderFloat("lensEffect", "intensity", -0.5)
    end
end

function pixelEvent()
    if curStep == 316 or curStep == 318 or curStep == 496 or curStep == 500 or curStep == 502 or curStep == 1520 or curStep == 1526 then 
        pixel(100)
        setProperty("camBYoutube.zoom", getProperty("camBYoutube.zoom") + 0.1)
        setProperty("camHUD.zoom", getProperty("camHUD.zoom") + 0.1)
    end
    if curStep == 317 or curStep == 319 or curStep == 498 or curStep == 501 or curStep == 503 or curStep == 1524 or curStep == 1530 then 
        pixel()
        setProperty("camBYoutube.zoom", getProperty("camBYoutube.zoom") + 0.1)
        setProperty("camHUD.zoom", getProperty("camHUD.zoom") + 0.1)
    end

    if curStep == 592 or curStep == 600 or curStep == 712 or curStep == 720 or curStep == 728 or curStep == 732 or curStep == 734
    or curStep == 1248 or curStep == 1264 or curStep == 1266 then 
        pixel(50)
        setProperty("camBYoutube.zoom", getProperty("camBYoutube.zoom") + 0.1)
        setProperty("camHUD.zoom", getProperty("camHUD.zoom") + 0.1)
    end
    if curStep == 596 or curStep == 604 or curStep == 704 or curStep == 716 or curStep == 724 or curStep == 730 or curStep == 733 or curStep == 735
    or curStep == 1249 or curStep == 1265 or curStep == 1267 then 
        pixel()
        setProperty("camBYoutube.zoom", getProperty("camBYoutube.zoom") + 0.1)
        setProperty("camHUD.zoom", getProperty("camHUD.zoom") + 0.1)
    end

    if curStep == 380 or curStep == 1308  then -- scream
        pixel(50)
        tweenP(0, nil, 2, "quadIn")
    end
    if curStep == 832 then 
        pixel(25)
        tweenP(0, nil, 3, "quadIn")

        setProperty("camBYoutube.zoom", getProperty("camBYoutube.zoom") + 0.3)
        setProperty("camHUD.zoom", getProperty("camHUD.zoom") + 0.3)
    end

    if curStep == 608 or curStep == 864  then -- low quality
        pixel(220, 50)
    end
    if curStep == 992  then -- back high quality
        tweenP(0, 0, crochet/1000*8*6, "sineIn")
    end

    if curStep == 1504 or curStep == 1510 then  -- scream fade
        pixel(25)
        tweenP(0, nil, 3, "quadIn")

        setProperty("camBYoutube.zoom", getProperty("camBYoutube.zoom") + 0.1)
        setProperty("camHUD.zoom", getProperty("camHUD.zoom") + 0.1)
    end

end

function glitchEvent()
    if curStep == 736 then
        setGlitchy(crochet/1000*4*4, 0.5)
    end
    if curStep == 806 then
        setGlitchy(crochet/1000, 0.0001)
    end
    if curStep == 992 then
        setGlitchy(crochet/1000*4*7, 0.5)
    end
    if curStep == 1120 then
        setGlitchy(crochet/1000, 0.0001)
    end
    if curStep == 1856 then
        setGlitchy(crochet/1000*8, 2, "expoIn")
    end
    if curStep == 1888 then
        setGlitchy(crochet/1000, 0.0001, "quadOut")
    end
    if curStep == 2128 then
        setShaderFloat("glitch2Effect", "GlitchAmount", 0.5)
        setProperty("glitch2Effect.x", 0.5)
        setGlitchy(crochet/1000*4, 0.0001, "quadOut")
    end
    if curStep == 2642 then
        setGlitchy(crochet/1000*4, 2, "quadIn")
    end
    if curStep == 2656 then
        setShaderFloat("glitch2Effect", "GlitchAmount", 0.0001)
        setProperty("glitch2Effect.x", 0.0001)
        setGlitchy(crochet/1000*4*16, ((HardMode or InsaneMode) and 1.5 or 0.75))
    end
    if curStep == 2912 then
        setGlitchy(crochet/1000*4, 0.0001, "quadOut")
    end
end

function setGlitchy(duration, intensity, ease)
    if shaderE then
        doTweenX("glitch2Effect", "glitch2Effect", intensity, duration, ease or "linear")
        tweenGlitch = true
    end
end
function tweenP(pixels, colors, duration, ease)
    if shaderE then
        callScript("stages/youtubeStage", "tweenPixel", {pixels, colors, duration, ease})
    end
end
function pixel(pixels, colors)
    if shaderE then
        callScript("stages/youtubeStage", "setPixel", {pixels, colors})
    end
end
function iconSpeed(speed)
    setGlobalFromScript("scripts/engine/engine", "iconSpeed", speed or 4)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "hideScream" then 
        doTweenAlpha("hideComment", "hackerComment", 0, crochet/1000)
        doTweenAlpha("hideGlow", "redGlow", 0, crochet/1000)
    end
end

function goodNoteHit(id, dir, type, sus)
    if curStep >= 2128 and mechanicOption then 
        addHealth(sus and 0.005 or 0.04)
    end
end

function lerp(a, b, t) return a + (b - a) * t end
function continuous_sin(x)
    return math.sin((x % 1) * 2*math.pi)
end

function onTweenCompleted(tag)
    if tag == "glitch2Effect" then
        tweenGlitch = false
    end
end

function onSongStart()
    callScript("stages/youtubeStage", "showYT", {3})
    doTweenY("camPosY", "camPos", 1000, 4, "sineInOut")
end