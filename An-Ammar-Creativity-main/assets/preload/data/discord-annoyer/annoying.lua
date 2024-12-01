local scaleX, scaleY = nil, nil
function onCreate()
    scaleX = getPropertyFromClass("flixel.FlxG", "scaleMode.scale.x")
    scaleY = getPropertyFromClass("flixel.FlxG", "scaleMode.scale.y")
end

local colorSingMode = false

local membersSprites = {}

pbr = 1
function onCreatePost()
    pbr = getProperty("playbackRate")

    setProperty('iconSpeed', 4)
    setGlobalFromScript("stages/discordStage", "disableCamLerp", true)
    setProperty("camBDiscord.zoom", 1.6)
    setProperty("camDiscord.zoom", 2)

    precacheImage("light/left"); precacheImage("light/down"); precacheImage("light/up"); precacheImage("light/right")

    makeLuaSprite("anCom", "chars/AnCom", 320 , 480)
    addLuaSprite("anCom")
    setGraphicSize("anCom", 649 * 0.625, 146 * 0.625)
    screenCenter('anCom')
    setProperty('anCom.alpha', 0);
    runHaxeCode("game.getLuaObject('anCom').camera = camBDiscord;")
    setObjectOrder("anCom", 60)
    

    makeLuaSprite("shakeSpr", "", 0 , 0)

    makeLuaSprite("blackFade", "", 0 , 0)
    makeGraphic("blackFade", 2000,2000, "000000")
    setScrollFactor("blackFade", 0 ,0)
    addLuaSprite("blackFade", true)
    screenCenter("blackFade")
    setObjectCamera("blackFade", "hud")
    setProperty('blackFade.alpha', 1);

    makeLuaSprite("colorSing", "light/left", 0 , 0)
    addLuaSprite("colorSing")
    screenCenter("colorSing")
    setObjectCamera("colorSing", "other")
    setProperty('colorSing.alpha', 0);
    setBlendMode("colorSing", "add")

    callScript("stages/discordStage", "setObjectCameraCustom", {"blackFade", "camDiscord"})

    setProperty("dad.healthIcon", "ammar"..(CuteMode and 'cute' or ''))
    setProperty("boyfriend.healthIcon", "annoyer")
    runHaxeCode([[
        game.iconP2.changeIcon("icon-ammar]]..(CuteMode and 'cute' or '')..[[");
        game.iconP1.changeIcon("icon-annoyer");
      ]])
      
     setHealthBarColors("60f542", "ffc400")

     membersSprites = getProperty("membersSprites")

end

function onSongStart()
    doTweenAlpha("fadeBlack", "blackFade", 0, 1/pbr, "quadIn")
    setGlobalFromScript("stages/discordStage", "disableCamLerp", false)
end

function onStepEvent(step) 
    if step == 128 then 
        setProperty('iconSpeed', 2)
        setGlobalFromScript("stages/discordStage", "disableCamLerp", false)
    end
    if step == 502 then 
        setGlobalFromScript("stages/discordStage", "disableDadTextRemove", true)
        setGlobalFromScript("stages/discordStage", "disableDadTextTyping", true)
    end
    if step == 504 then 
        setTextString("opponentText", "Can")
    end
    if step == 506 then 
        setTextString("opponentText", "Can you")
    end
    if step == 508 then 
        setTextString("opponentText", "Can you stop???")
    end
    if step == 510 then 
        setGlobalFromScript("stages/discordStage", "disableDadTextRemove", false)
        setGlobalFromScript("stages/discordStage", "disableDadTextTyping", false)
    end
    if step == 624 then
        setProperty('iconSpeed', 16)
    end
    if step == 660 then 
        setTextString("opponentText", "")
        setGlobalFromScript("stages/discordStage", "disableDadTextRemove", true)
        setGlobalFromScript("stages/discordStage", "disableDadTextTyping", true)
    end
    if step == 672 then 
        setGlobalFromScript("stages/discordStage", "disableDadTextRemove", false)
        setGlobalFromScript("stages/discordStage", "disableDadTextTyping", false)
        setProperty('iconSpeed', 2)
    end
    if step == 832 then
        setProperty('iconSpeed', 8)
    end
    if step == 864 then
        setProperty('iconSpeed', 2)
    end
    if step == 928 then
        setProperty('iconSpeed', 4)
    end
    if step == 1184 then
        setProperty('iconSpeed', 2)
    end
    if step == 1220 then  --ANCom
        setProperty('iconSpeed', 16)
        setProperty("shakeSpr.x", 12)
        doTweenX("shake", "shakeSpr", 0, 1/pbr)

        setProperty('anCom.alpha', 1);
        setProperty('opponent.alpha', 0);
        setProperty('opponentText.alpha', 0);
        setProperty('player.alpha', 0);
        setProperty('playerText.alpha', 0);

        setProperty("defaultCamZoom", 1.6)
    end
    if step == 1232 then  --ANCom
        doTweenAlpha("anComOut", "anCom", 0, crochet/1000*4/pbr)

        doTweenAlpha("opponentOut", "opponent", 1, crochet/1000*4/pbr)
        doTweenAlpha("opponentTOut", "opponentText", 1, crochet/1000*4/pbr)
        doTweenAlpha("playerOut", "player", 1, crochet/1000*4/pbr)
        doTweenAlpha("playerTOut", "playerText", 1, crochet/1000*4/pbr)

        
    end
    if step == 1248 then 
        setProperty('iconSpeed', 1)
        callScript("stages/discordStage", "lightingMode", {true})
        cameraFlash("camOther", "FFFFFF", 1/pbr, false)

        setProperty("defaultCamZoom", 0.9)

        setBlendMode("colorSing", "normal")
    end

    if step == 1376 then 
        setProperty('iconSpeed', 8)
        doTweenAlpha("fadeBlack", "blackFade", 1, 0.5/pbr, "linear")
    end
    if step == 1384 then 
        setGlobalFromScript("stages/discordStage", "disableDadTextRemove", true)
        setGlobalFromScript("stages/discordStage", "disableDadTextTyping", true)
        setTextString("opponentText", "")
    end
    if step == 1392 then 
        doTweenAlpha("fadeBlack", "blackFade", 0, 0.5/pbr, "linear")
    end
    if step == 1393 then 
        setTextString("opponentText", "????????")
    end
    if step == 1407 then 
        setGlobalFromScript("stages/discordStage", "disableDadTextRemove", false)
        setGlobalFromScript("stages/discordStage", "disableDadTextTyping", false)
        setTextString("opponentText", "")
        setProperty('iconSpeed', 1)
    end
    if step == 1456 then 
        doTweenX("shake", "shakeSpr", 10, 5/pbr)
    end
    if step == 1520 then 
        colorSingMode = true
        cancelTween('shake')
        setProperty("shakeSpr.x", 0)
        setProperty('iconSpeed', 2)
    end
    if step == 1520 or step == 1648 then 
        callScript("stages/discordStage", "lightingMode", {false})
        cameraFlash("camOther", "FFFFFF", 1/pbr, false)

        setBlendMode("colorSing", "add")
    end
    if step == 1584 or step == 1712 then 
        callScript("stages/discordStage", "lightingMode", {true})
        cameraFlash("camOther", "FFFFFF", 1/pbr, false)

        setBlendMode("colorSing", "normal")
    end

    if step == 1760 then 
        setProperty("camHUD.angle", 0)
        setProperty("camBDiscord.angle", 0)
        setProperty("camDiscord.angle", 0)
        callScript("stages/discordStage", "lightingMode", {false})

        setBlendMode("colorSing", "add")
    end
    if step == 1766 then 
        callScript("stages/discordStage", "lightingMode", {true})

        setBlendMode("colorSing", "normal")
    end
    if step == 1776 then 
        callScript("stages/discordStage", "lightingMode", {false})
        cameraFlash("camOther", "FFFFFF", 2/pbr, false)
        colorSingMode = false

        setBlendMode("colorSing", "add")
    end
    if step == 1792 then 
        doTweenAlpha("fadeBlack", "blackFade", 1, 3/pbr, "quadIn")
    end
end


function onStepHit()
    if ((curStep >= 128 and curStep < 240) or (curStep >= 256 and curStep < 504)) and HardMode then
        if curStep % 8 == 4 then
            setProperty("camHUD.angle", curStep%16==4 and -10 or 10)
            doTweenAngle("backCamhudAngle", "camHUD", 0, crochet/1000*4/pbr, "expoOut") 
        end
    end
    if ((curStep >= 512 and curStep < 624) or (curStep >= 672 and curStep < 832) or (curStep >= 864 and curStep < 928)) and HardMode then
        if curStep % 4 == 0 then
            setProperty("camHUD.angle", curStep%8==0 and -5 or 5)
            doTweenAngle("backCamhudAngle", "camHUD", 0, crochet/1000/pbr, "quadOut")
        end
    end
    if curStep >= 660 and curStep < 672 then 
        setTextString("opponentText", getTextString("opponentText")..(getRandomBool(50) and "!" or "?"))
    end
   
    if (curStep >= 512 and curStep < 624) or (curStep >= 672 and curStep < 832) or (curStep >= 864 and curStep < 928) then 
        if curStep % 4 == 0 then
            for i,v in pairs(membersSprites) do
                if not v[3] then
                    local offsetX = 7
                    setProperty(v[1]..".xAdd", offsetX + (7*(i%2==0 and 1 or -1)*(curStep%8==0 and 1 or -1)))
                end
            end
        end
    end
    if colorSingMode and curStep % 4 == 0 then 
        triggerEvent("Add Camera Zoom", 0.015, 0.03)
    end
end

local dirName = {"left", "down", "up", "right"}
function goodNoteHit(id, dir)
    if colorSingMode then
        loadGraphic("colorSing", "light/"..dirName[dir+1])
        setProperty("colorSing.alpha", 0.8)
        doTweenAlpha("colorSingfade","colorSing", 0, 1/pbr)
    end
end

function onUpdate(elapsed) 
    if curStep >= 1520 and curStep < 1760 then
        setProperty("camHUD.angle", continuous_sin(curDecStep/32)*(EasyMode and 3 or 6))
        setProperty("camBDiscord.angle", continuous_sin(curDecStep/32)*6)
        setProperty("camDiscord.angle", continuous_sin(curDecStep/32)*3)
    end
end

function onUpdatePost(elapsed)
    if not inGameOver then
        shakyi(elapsed)
        if (curStep >= 512 and curStep < 624) or (curStep >= 672 and curStep < 832) or (curStep >= 864 and curStep < 928) then 
            for i,v in pairs(membersSprites) do
                if not v[3] then
                    local offsetX = 7
                    setProperty(v[1]..".xAdd", lerp(getProperty(v[1]..".xAdd"), offsetX, elapsed*7*pbr))
                end
            end
            
        end
     end
end



function shakyi(elapsed)
    local resultShake = getProperty("shakeSpr.x")
    
    local HUDX = 0.5 * getPropertyFromClass("flixel.FlxG", "width") * (1 - getProperty("camHUD.zoom")) * scaleX
    local HUDY = 0.5 * getPropertyFromClass("flixel.FlxG", "height") * (1 - getProperty("camHUD.zoom")) * scaleY

    local randomX =  getRandomFloat(-resultShake, resultShake) * 1
    local randomY =  getRandomFloat(-resultShake, resultShake) * 1
    
    local rotate = math.sin(getSongPosition()/500) * 10
    setProperty("camHUD.canvas.x", HUDX + -randomX*-0.6)
    setProperty("camHUD.canvas.y", HUDY + -randomY*-0.6)
    setProperty("camBDiscord.x", -randomX*0.7)
    setProperty("camBDiscord.y", -randomY*0.7)
    setProperty("camDiscord.x", -randomX)
    setProperty("camDiscord.y", -randomY)
    
end


function opponentNoteHit(id, dir, type, sus)
    if HardMode and not sus then 
        if getHealth() > 0.2 then 
            addHealth(-0.008)
        end
    end
end

function continuous_sin(x) return math.sin((x % 1) * 2*math.pi) end
function lerp(a, b, t) return a + (b - a) * t end