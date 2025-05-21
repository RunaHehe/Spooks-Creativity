scaleX = null
scaleY = null

camShake = 0
shaky = 0

wiggleFreq = 0
wiggleFreqLerp = 0
wiggleAmp = 0
wiggleAmpLerp = 0

boomSpeed = 2
bam = 1

susOffset = 0


--[[disableMovingScreen = false
local windowX = 0;
local windowY = 0;
local windowW = 0;
local windowH = 0;

waveWindowY = false
waveWindowX = false
waveWindowSpeed = 1
borderlessShake = false]]

function onCreatePost()
    luaDebugMode = true
    scaleX = getPropertyFromClass("flixel.FlxG", "scaleMode.scale.x")
    scaleY = getPropertyFromClass("flixel.FlxG", "scaleMode.scale.y")

    makeLuaSprite("windowObject", "", 0 , 0)

    makeLuaSprite("red", "", 0 , 0)
    makeGraphic("red", 2000,2000, "FF0000")
    addLuaSprite("red", true)
    setObjectCamera("red", "other")
    screenCenter("red")
    setProperty("red.alpha", 0)
    setBlendMode("red", "multiply")
    --setObjectOrder("red", getObjectOrder("message") + 1)

    makeLuaSprite("blackbarD", "", -400 , 729)
    makeGraphic("blackbarD", 2000,500, "000000")
    addLuaSprite("blackbarD", true)
    setObjectCamera("blackbarD", "hud")
    setProperty("blackbarD.alpha", 1)
    setObjectOrder("blackbarD", getObjectOrder("strumLineNotes") - 1)

    makeLuaSprite("blackbarU", "", -400 , -500)
    makeGraphic("blackbarU", 2000,500, "000000")
    addLuaSprite("blackbarU", true)
    setObjectCamera("blackbarU", "hud")
    setProperty("blackbarU.alpha", 1)
    setObjectOrder("blackbarU", getObjectOrder("strumLineNotes") - 1)


    for note = 0, getProperty("unspawnNotes.length") do 
        if getPropertyFromGroup("unspawnNotes", note, "isSustainNote") then
           susOffset = getPropertyFromGroup("unspawnNotes", note, "offsetX")
           break;
        end
     end

     --[[getWindowPos()
     windowW = 1280--getPropertyFromClass('openfl.Lib','application.window.width')
     windowH = 720--getPropertyFromClass('openfl.Lib','application.window.height')]]

     setProperty("dad.healthIcon", "bunny")
     setProperty("boyfriend.healthIcon", "annoyer")
     runHaxeCode([[
         game.iconP2.changeIcon("icon-bunny");
         game.iconP1.changeIcon("icon-annoyer");
       ]])
    setHealthBarColors("fffdfc", "ffc400")
end

function createShaders()
    addHaxeLibrary("ShaderFilter", "openfl.filters")
    initLuaShader("ChromaticAbberation")
    makeLuaSprite("caaShader", "", 0, 0)
    setSpriteShader("caaShader", "ChromaticAbberation")
 
    setShaderFloat("caaShader", "amount", 2)
    runHaxeCode([[
        game.camHUD.setFilters([ new ShaderFilter(game.getLuaObject("caaShader").shader), new ShaderFilter(game.getLuaObject("colorShader").shader)]);
    ]])
end

function barTween(duration, distance)
    doTweenY("blackbarD", "blackbarD", 720 - distance, duration, "quadInOut")
    doTweenY("blackbarU", "blackbarU", -500 + distance, duration, "quadInOut")
end

function onStepHit()
    if curStep == 320 or curStep == 2112 then 
        setGlobalFromScript("stages/discordStageAAC", "sideSinning", true)
        shaky = 0.03
        doTweenAlpha('reding','red', 0.8, crochet/1000*4*8)
        doTweenAlpha('staticing','static', 0.2, crochet/1000*4*8)
        barTween(8, 100)
    end
    if curStep == 576 or curStep == 2368 then 
        setGlobalFromScript("stages/discordStageAAC", "sideSinning", false)
        callScript("stages/discordStageAAC", "lightingMode", {true})
        cameraFlash("other", "FFFFFF", 2, false)
        shaky = 0
        setProperty('red.alpha',0)
        setProperty('static.alpha',0)
        barTween(1, 0)
    end
    if curStep == 1344 then 
        setProperty("camHUD.angle", 0)
        setProperty("camBDiscord.angle", 0)
        setProperty("camDiscord.angle", 0)
    end
    if curStep == 832 or curStep == 1344 then 
        callScript("stages/discordStageAAC", "lightingMode", {false})
        cameraFlash("other", "FFFFFF", 2, false)
        setProperty("cover.color", getColorFromHex("36393F"))
    end
    if curStep == 1088 or curStep == 2368 then 
        callScript("stages/discordStageAAC", "lightingMode", {true})
        cameraFlash("other", "FFFFFF", 2, false)
        setProperty("cover.color", getColorFromHex("FFFFFF"))
    end
    if curStep == 1600 or curStep == 2624 then 
        cameraFlash("other", "FFFFFF", 2, false)
        setProperty("camDiscord.visible", false)
        setProperty("camBDiscord.visible", false)
        setProperty("camGame.visible", true)
        setProperty('cover.alpha', 0);
        barTween(1, 100)

        setProperty("dad.healthIcon", "demon-sky")
        setProperty("boyfriend.healthIcon", "bf-chained")
        runHaxeCode([[
            game.iconP2.changeIcon("icon-demon-sky");
            game.iconP1.changeIcon("icon-bf-chained");
          ]])

          setHealthBarColors("990000", "2fa8de")
    end
    if curStep == 1856 then 
        cameraFlash("other", "FFFFFF", 1, false)
        setProperty("camDiscord.visible", true)
        setProperty("camBDiscord.visible", true)
        setProperty('cover.alpha', 1);

        setProperty("camGame.visible", false)
        barTween(1, 0)

        setProperty("dad.healthIcon", "bunny")
        setProperty("boyfriend.healthIcon", "annoyer")
        runHaxeCode([[
            game.iconP2.changeIcon("icon-bunny");
            game.iconP1.changeIcon("icon-annoyer");
          ]])

          setHealthBarColors("fffdfc", "ffc400")
    end
    if curStep == 2624 then 
        shaky = 0.03
        callScript("stages/discordStageAAC", "lightingMode", {false})
        setProperty("cover.color", getColorFromHex("36393F"))
    end
    if curStep == 2752 then 
        shaky = 0.07
        barTween(1, 50)
        setProperty("camDiscord.visible", true)
        setProperty("camBDiscord.visible", true)
        cameraFlash("other", "FFFFFF", 1, false)

        callScript("stages/discordStageAAC", "lightingMode", {true})
        setProperty("cover.color", getColorFromHex("FFFFFF"))

        setProperty("dad.healthIcon", "bunny")
        setProperty("boyfriend.healthIcon", "annoyer")
        runHaxeCode([[
            game.iconP2.changeIcon("icon-bunny");
            game.iconP1.changeIcon("icon-annoyer");
          ]])

          setHealthBarColors("fffdfc", "ffc400")
    end
    if curStep == 2880 then 
        shaky = 0.02
        barTween(1, 0)
        setProperty("camHUD.angle", 0)
        setProperty("camDiscord.angle", 0)
        setProperty("camBDiscord.angle", 0)
        doTweenAlpha("camDiscordAl", "camDiscord", 1, 0.5)
        doTweenAlpha("camBDiscordAl", "camBDiscord", 1, 0.5)

        cameraFlash("other", "FFFFFF", 2, false)
        callScript("stages/discordStageAAC", "lightingMode", {false})
        setProperty("cover.color", getColorFromHex("36393F"))

        setProperty("blackbarD.angle", 0)
        setProperty("blackbarU.angle", 0)
    end
    if curStep == 3136 then 
        setProperty("canPause", false)
        barTween(3, 400)
    end
end

function opponentNoteHit()
    camShake = camShake + 0.03
end


--local windowOffset = {x = 0, y = 0}
function onUpdate(elapsed)
    if not inGameOver then
            notesEvent(elapsed)

            if curStep >= 832 and curStep < 1344 then 
                setProperty("camHUD.angle", continuous_sin(curDecStep/16)*5)
                setProperty("camBDiscord.angle", continuous_sin(curDecStep/8)*-5)
                setProperty("camDiscord.angle", continuous_sin(curDecStep/8)*10)
            end
                --[[local winX, winY = getPropertyFromClass('openfl.Lib','application.window.x'), getPropertyFromClass('openfl.Lib','application.window.y')
                setPropertyFromClass('openfl.Lib','application.window.x',lerp(winX, windowX + windowOffset.x + getProperty("windowObject.x"), elapsed*12))
                setPropertyFromClass('openfl.Lib','application.window.y',lerp(winY, windowY + windowOffset.y + getProperty("windowObject.y"), elapsed*12))
                setPropertyFromClass('openfl.Lib','application.window.width', windowW * getProperty("windowObject.scale.x"))
                setPropertyFromClass('openfl.Lib','application.window.height', windowH * getProperty("windowObject.scale.y"))
            
                if waveWindowY then
                    windowOffset.y = continuous_sin(curDecBeat*waveWindowSpeed/4)*60
                elseif windowOffset.y ~= 0 then
                    windowOffset.y = 0
                end
                if waveWindowX then
                    windowOffset.x = continuous_cos(curDecBeat*waveWindowSpeed/4)*60
                elseif windowOffset.x ~= 0 then
                    windowOffset.x = 0
                end
                if borderlessShake and false then 
                    setPropertyFromClass('openfl.Lib','application.window.borderless',getRandomBool(5))
                end]]

        if curStep >= 2752 and curStep < 2880 then
            setProperty("camDiscord.alpha", 0.7 + continuous_sin(curDecStep/16)*0.3)
            setProperty("camBDiscord.alpha", 0.7 + continuous_sin(curDecStep/16)*0.3)
        end

        if curStep >= 2624 and curStep < 2880 then --2720
            setProperty("blackbarD.angle", math.sin(getSongPosition()/200)*5)
            setProperty("blackbarU.angle", math.sin(getSongPosition()/190)*5)
        end
    end
   
end

--[[function customMovingWindow()
    if curBeat == 80 then
        getWindowPos()
        doTweenX("windowH", "windowObject.scale", 1.5, crochet/1000*14*4 ,"quadInOut")
        doTweenX("windowX", "windowObject", -1280*0.25, crochet/1000*14*4 ,"quadInOut")
    end
    if curBeat == 140 then
        doTweenX("windowH", "windowObject.scale", 1, crochet/1000*4 ,"expoIn")
        doTweenX("windowX", "windowObject", 0, crochet/1000*4 ,"expoIn")
    end
    if curBeat >= 208 and curBeat < 270 then
        if curBeat%8==0 then
            doTweenX("windowX", "windowObject", -150, crochet/1000*2 ,"quintOut")
        elseif curBeat%8==4 then
            doTweenX("windowX", "windowObject", 150, crochet/1000*2 ,"quintOut")
        end
    end
    if curBeat == 270 then
        doTweenX("windowX", "windowObject", 0, crochet/1000*2 ,"quadInOut")
        doTweenY("windowY", "windowObject", -600, crochet/1000*2 ,"expoIn")
    end
    if curBeat == 272 then
        setProperty('windowObject.y', 600)
        doTweenY("windowY", "windowObject", 0, crochet/1000*2 ,"quadOut")
    end
end]]

function onBeatHit()
    --[[if curBeat == 144 then 
        getWindowPos()
        waveWindowY = true
    end
    if curBeat == 208 then 
        waveWindowSpeed = 2
        borderlessShake = true
        waveWindowX = true
    end
    if curBeat == 270 then 
        borderlessShake = false
        waveWindowX = false
        setPropertyFromClass('openfl.Lib','application.window.borderless',false)
        waveWindowY = false
    end
    if curBeat == 272 then 
        borderlessShake = true
        waveWindowY = true
    end
    if curBeat == 336 then 
        borderlessShake = false
        setPropertyFromClass('openfl.Lib','application.window.borderless',false)
        waveWindowY = false
    end
    if curBeat == 592 then 
        getWindowPos()
        waveWindowSpeed = 1
        waveWindowY = true
    end
    if curBeat == 654 then 
        borderlessShake = false
        waveWindowSpeed = 2
        waveWindowY = false
    end
    if curBeat == 656 then 
        borderlessShake = true
    end
    if curBeat == 688 then 
        getWindowPos()
        waveWindowY = true
    end
    if curBeat == 720 then 
        borderlessShake = false
        setPropertyFromClass('openfl.Lib','application.window.borderless',false)
        waveWindowY = false
    end]]
    if curBeat % boomSpeed == 0 and not songEnded and curStep > 64 then
		triggerEvent("Add Camera Zoom",0.015*bam,0.03*bam)
		if getProperty('camGame.zoom') >= 1.35 then
			
			setProperty('camGame.zoom',getProperty('camGame.zoom')+0.025*bam);
			setProperty('camHUD.zoom',getProperty('camHUD.zoom')+0.03*bam);
            setProperty('camDiscord.zoom',getProperty('camDiscord.zoom')+0.02*bam);
            setProperty('camBDiscord.zoom',getProperty('camBDiscord.zoom')+0.04*bam);
		end
	end
    --customMovingWindow()
end

--[[function getWindowPos()
    windowX = getPropertyFromClass('openfl.Lib', 'application.window.x')
    windowY = getPropertyFromClass('openfl.Lib', 'application.window.y')
end]]
function onUpdatePost(elapsed)
    if not inGameOver then
        shakyi(elapsed)
    end
end

function shakyi(elapsed)
    local resultShake = (camShake + shaky) * (reduceShakeOption and 0.25 or 1)
    camShake = lerp(camShake, 0, elapsed * 5)
    
    local GameX = 0.5 * screenWidth * (1 - getProperty("camGame.zoom")) * scaleX
    local GameY = 0.5 * screenHeight * (1 - getProperty("camGame.zoom")) * scaleY
    local HUDX = 0.5 * screenWidth * (1 - getProperty("camHUD.zoom")) * scaleX
    local HUDY = 0.5 * screenHeight * (1 - getProperty("camHUD.zoom")) * scaleY
    local BDiscordX = 0.5 * screenWidth * (1 - getProperty("camBDiscord.zoom")) * scaleX
    local BDiscordY = 0.5 * screenHeight * (1 - getProperty("camBDiscord.zoom")) * scaleY
    local DiscordX = 0.5 * screenWidth * (1 - getProperty("camDiscord.zoom")) * scaleX
    local DiscordY = 0.5 * screenHeight * (1 - getProperty("camDiscord.zoom")) * scaleY
    if resultShake > 0 then 
       local randomX =  getRandomFloat(-resultShake, resultShake) * 200
       local randomY =  getRandomFloat(-resultShake, resultShake) * 200
        setProperty("camGame.canvas.x", GameX + randomX)
        setProperty("camGame.canvas.y", GameY + randomY)
        setProperty("camHUD.canvas.x", HUDX + -randomX*-0.25)
        setProperty("camHUD.canvas.y", HUDY + -randomY*-0.25)
        setProperty("camBDiscord.canvas.x", BDiscordX + -randomX*0.7)
        setProperty("camBDiscord.canvas.y", BDiscordY + -randomY*0.7)
        setProperty("camDiscord.canvas.x", DiscordX + -randomX)
        setProperty("camDiscord.canvas.y", DiscordY + -randomY)
        setProperty("camHUD.canvas.origin.x", 1280/2)
        setProperty("camHUD.canvas.origin.y", 720/2)
    end
    
end

function notesEvent(elapsed)
    wiggleAmpLerp = lerp(wiggleAmpLerp, wiggleAmp, elapsed * 10)
    wiggleFreqLerp = lerp(wiggleFreqLerp, wiggleFreq, elapsed * 10)
    if not inGameOver then
       for i=0,getProperty('notes.length')-1 do
          local strum = getPropertyFromGroup('notes',i,'strumTime')
          local woom = (strum-getSongPosition())/(math.floor(wiggleFreqLerp) <= 0.1 and 0.001 or math.floor(wiggleFreqLerp))
          local sus = getPropertyFromGroup('notes',i,'isSustainNote')
          local strength = math.floor(wiggleAmpLerp)
          if getPropertyFromGroup("notes", i, "mustPress") then strength = -strength end

          if false then 
             setPropertyFromGroup('notes',i,'angle',strength *math.sin(woom))
          else 
             setPropertyFromGroup('notes',i,'offsetX', (strength *math.sin(woom/2)) + ((sus) and susOffset or 0))
          end
       
       end
    end

end

function onEvent(n,v1,v2)

    if n == "Cam Boom Speed" then
       boomSpeed = tonumber(v1)
       bam = tonumber(v2)
    end
    if n == 'WiggleNotes' then
         wiggleFreq = tonumber(v1)
         wiggleAmp = tonumber(v2)
     end
    
 end

--[[function onPause()
        setPropertyFromClass('openfl.Lib','application.window.borderless',false)
        setPropertyFromClass('openfl.Lib','application.window.x',windowX)
        setPropertyFromClass('openfl.Lib','application.window.y',windowY)

        setPropertyFromClass('openfl.Lib','application.window.width',windowW)
        setPropertyFromClass('openfl.Lib','application.window.height',windowH)
end
function onDestroy()
        setPropertyFromClass('openfl.Lib','application.window.borderless',false)
        setPropertyFromClass('openfl.Lib','application.window.x',windowX)
        setPropertyFromClass('openfl.Lib','application.window.y',windowY)

        setPropertyFromClass('openfl.Lib','application.window.width',windowW)
        setPropertyFromClass('openfl.Lib','application.window.height',windowH)
end

function onResume()
    getWindowPos()
end]]

function continuous_sin(x) return math.sin((x % 1) * 2*math.pi) end
function continuous_cos(x) return math.cos((x % 1) * 2*math.pi) end
function lerp(a, b, t) return a + (b - a) * t end