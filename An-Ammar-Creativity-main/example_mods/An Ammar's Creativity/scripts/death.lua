
daSongName = ""
SpriteUtil = nil
Timer = nil

thisBPM = 100
targetBGAlpha = 1

mobileMode = false
canClick = false
function onCreate()
    addHaxeLibrary("GameOverSubstate")
    addHaxeLibrary("WeekData")
    addHaxeLibrary("MusicBeatState")
    daSongName = string.lower(songName:gsub("%s+", ""))

    package.path = getProperty("modulePath") .. ";" .. package.path
    SpriteUtil = require("SpriteUtil")
    Timer = require("Timer")

    mobileMode = buildTarget == "android"

    Timer.startTimer(0.5, function(l, ll)
        canClick = true
    end)

    customGameOver(true)
end

function onGameOverStart()

    runHaxeCode([[  
        camDead = new FlxCamera();
        camDead.bgColor = 0x00;
        FlxG.cameras.add(camDead,false);
        game.variables.set("camDead", camDead);

        FlxTween.tween(game.camHUD, {alpha:0}, 1);
        game.persistentDraw = true;
    ]])

    SpriteUtil.makeSprite({tag="gameOverBG",graphicWidth = 1400, graphicHeight = 900, graphicColor = "000000"})
    screenCenter("gameOverBG")
    setProperty("gameOverBG.alpha", 0.5)
    setBlendMode("gameOverBG", "multiply")
    runHaxeCode("game.getLuaObject('gameOverBG').camera = camDead")

    customGameOver(false)

    SpriteUtil.makeSprite({tag="gameOverFlash",graphicWidth = 1400, graphicHeight = 900, graphicColor = "FFFFFF"})
    screenCenter("gameOverFlash")
    setProperty("gameOverFlash.alpha", 1)
    runHaxeCode("game.getLuaObject('gameOverFlash').camera = camDead")
    doTweenAlpha("gameOverFlash", "gameOverFlash", 0, 2)
    doTweenAlpha("gameOverBG", "gameOverBG", targetBGAlpha, 1)
end

local customGameOverVar = {}
function customGameOver(loading)
    if daSongName == "no-debug" or daSongName == 'myself' or daSongName == 'furryfemboy' then
        if loading then
            setPropertyFromClass("GameOverSubstate", "deathSoundName", "gameover/vineboom")
            precacheSound("gameover/vineboom")
            precacheImage("ammarvoid/eyes")
            precacheImage("ammarvoid/mouth")
        else
            SpriteUtil.makeSprite({tag="ammarEyes", antialiasing = false})
            runHaxeCode("game.getLuaObject('ammarEyes').camera = camDead")

            loadGraphic('ammarEyes', 'ammarvoid/eyes' .. (daSongName == 'furryfemboy' and '-furry' or ''), 75)

            addAnimation('ammarEyes', "idle", {0,1}, 3, true)
            addAnimation('ammarEyes', "blink", {2}, 0, true)
            playAnim("ammarEyes", "idle")
            setProperty("ammarEyes.antialiasing", false)

            setProperty("ammarEyes.alpha", 0)
            doTweenAlpha("ammarEyes", "ammarEyes", 1, 2)
            scaleObject("ammarEyes", 3, 3)
            screenCenter("ammarEyes")

            SpriteUtil.makeSprite({tag="ammarMouth",image = "ammarvoid/mouth" .. (daSongName == 'myself' and '-sad' or '')})
            setProperty("ammarMouth.alpha", 0)
            runHaxeCode("game.getLuaObject('ammarMouth').camera = camDead")
            doTweenAlpha("ammarMouth", "ammarMouth", 1, 2)
            scaleObject("ammarMouth", 3, 3)
            setProperty("ammarMouth.antialiasing", false)

            customGameOverVar.eyeX = getProperty("ammarEyes.x")
            customGameOverVar.eyeY = getProperty("ammarEyes.y") - 50

            SpriteUtil.makeText({
                tag = "deadText" , text = "",
                align = "center", borderColor = "0x00000000", size = 60, borderSize = 0, borderQuality = 0, color = "FFFFFFF",
                x = 0 , y = 0, width = -1, font = "1_Minecraft-Regular.otf"
            })
            Timer.startTimer(0.4, function(l, ll)
                typeText("deadText", "Try Again?", 1)
            end)
            runHaxeCode("game.getLuaObject('deadText').camera = camDead")
            screenCenter("deadText")
            setProperty('deadText.antialiasing', false)
            setProperty('deadText.y', 500)
        end
    end
    if daSongName == "google" then
        if loading then
           --empty
        else
            SpriteUtil.makeText({
                tag = "deadText" , text = "",
                align = "center", borderColor = "0x00000000", size = 60, borderSize = 0, borderQuality = 0, color = "FFFFFFF",
                x = 0 , y= 0, width = -1, font = "Google/Product Sans Regular.ttf"
            })
            Timer.startTimer(0.4, function(l, ll)
                typeText("deadText", "Don't Give Up!\nTry Again?", 1)
            end)
            runHaxeCode("game.getLuaObject('deadText').camera = camDead")
            screenCenter("deadText")
            targetBGAlpha = 0.75
        end
    end
    if daSongName == 'furryappeared' then
        if loading then
            precacheImage("kaijuparadise/NoobDeath")
        else
            makeAnimatedLuaSprite("deathChar", 'kaijuparadise/NoobDeath', getProperty('boyfriend.x'), getProperty('boyfriend.y'))
            addLuaSprite('deathChar')
            addAnimationByPrefix("deathChar", "death", "Noob Death", 24, false)
            playAnim('deathChar', 'death', true)
            runHaxeCode("game.getLuaObject('deathChar').camera = camDead")
            screenCenter('deathChar')
            setProperty('boyfriend.alpha', 0)
            setProperty('gameOverBG.alpha', 1)
            setProperty('deathChar.y', getProperty('deathChar.y') + 75)
            debugPrint('dead')

            SpriteUtil.makeText({
                tag = "deadText" , text = "Retry?",
                align = "center", borderColor = "0x00000000", size = 60, borderSize = 0, borderQuality = 0, color = "FFFFFFF",
                x = 0 , y= 0, width = 700
            })
            runHaxeCode("game.getLuaObject('deadText').camera = camDead")
            screenCenter("deadText")
            setProperty('deadText.y', getProperty('deathChar.y') - 340)

            runTimer("furryDeadText", 0.6)
        end
    end
    if getPropertyFromClass("PlayState", "curStage") == "discordStage" or getPropertyFromClass("PlayState", "curStage") == "demonbg" then
        if loading then
            setPropertyFromClass("GameOverSubstate", "deathSoundName", "gameover/discordVoiceLeft")
         else
            SpriteUtil.makeSprite({tag="deathBG", graphicColor = "36393F", graphicWidth = 1300, graphicHeight = 800})
            runHaxeCode("game.getLuaObject('deathBG').camera = camDead;")
            screenCenter("deathBG")

            SpriteUtil.makeSprite({tag="deathMee", image = "mee6"})
            runHaxeCode("game.getLuaObject('deathMee').camera = camDead;")
            screenCenter("deathMee")
            scaleObject("deathMee", 1.45, 1.45)
            setProperty("deathMee.alpha", 0)

            SpriteUtil.makeText({
                tag = "deadText" , text = "",
                align = "center", borderColor = "0x00000000", size = 60, borderSize = 0, borderQuality = 0, color = "FFFFFFF",
                x = 0 , y= 0, width = -1, font = "Discord/ggsans-Medium.ttf"
            })
            Timer.startTimer(0.5, function(l, ll)
                typeText("deadText", "Annoying User just left the server", 1.5)
                doTweenAlpha("deathMee", "deathMee", 1, 1.5)
            end)
            runHaxeCode("game.getLuaObject('deadText').camera = camDead")

            SpriteUtil.makeSprite({tag="deathVig", image = "vignette"})
            runHaxeCode("game.getLuaObject('deathVig').camera = camDead;")
            screenCenter("deathVig")
         end
    end

    if getPropertyFromClass("PlayState", "curStage") == "youtubeStage" or getPropertyFromClass("PlayState", "curStage") == "twitterStage" or daSongName == 'big-problem' then
        if loading then
            setPropertyFromClass("GameOverSubstate", "deathSoundName", "gameover/shutdown")
         else
            SpriteUtil.makeSprite({tag="deathBG", graphicColor = "000000", graphicWidth = 1300, graphicHeight = 800})
            runHaxeCode("game.getLuaObject('deathBG').camera = camDead;")
            screenCenter("deathBG")

            SpriteUtil.makeSprite({tag="deathPCBG", graphicColor = "FFFFFF", graphicWidth = 1280 * 0.9, graphicHeight = 720 * 0.85})
            runHaxeCode("game.getLuaObject('deathPCBG').camera = camDead;")
            screenCenter("deathPCBG")
            setProperty("deathPCBG.color", getColorFromHex("0063BB"))

            SpriteUtil.makeText({
                tag = "deadText" , text = "Shutting Down\nTry Again?",
                align = "center", borderColor = "0x00000000", size = 20, borderSize = 0, borderQuality = 0, color = "FFFFFFF",
                x = 0 , y= 0, width = -1, font = "SegoeUIVF.ttf"
            })
            runHaxeCode("game.getLuaObject('deadText').camera = camDead")
            screenCenter("deadText")

            SpriteUtil.makeSprite({tag="deathPC", image = "computer"})
            runHaxeCode("game.getLuaObject('deathPC').camera = camDead;")
            screenCenter("deathPC")

            SpriteUtil.makeSprite({tag="deathVig", image = "vignette"})
            runHaxeCode("game.getLuaObject('deathVig').camera = camDead;")
            screenCenter("deathVig")

            setProperty("camDead.zoom" ,1.3)

            Timer.startTimer(2, function(l, ll)
                runHaxeCode("FlxTween.tween(camDead, {zoom : 1}, 2, {ease : FlxEase.quadOut})")
            end)
         end
    end
end

function customUpdateGameOver()
    if daSongName == "no-debug" or daSongName == 'myself' or daSongName == 'furryfemboy' then
        setProperty("ammarEyes.x", customGameOverVar.eyeX + (math.sin(os.clock()) * 10))
        setProperty("ammarEyes.y", customGameOverVar.eyeY + (math.cos(os.clock()) * 10))

        setProperty("ammarMouth.x", customGameOverVar.eyeX + (math.sin(os.clock() + 0.2) * 9) - 2)
        setProperty("ammarMouth.y", customGameOverVar.eyeY + (math.cos(os.clock() + 0.2) * 9))
    end
    if getPropertyFromClass("PlayState", "curStage") == "discordStage" or getPropertyFromClass("PlayState", "curStage") == "demonbg" then
       screenCenter("deadText")
        setProperty("deadText.x", getProperty("deadText.x") + 55)
        setProperty("deathMee.x", (getProperty("deadText.x")/getProperty("deadText.scale.x")) - 160)
        setProperty("deathMee.y", (getProperty("deadText.y")) - 40)
    end
    if getPropertyFromClass("PlayState", "curStage") == "youtubeStage" or getPropertyFromClass("PlayState", "curStage") == "twitterStage" or daSongName == 'big-problem' then
        screenCenter("deadText")
        setProperty("deadText.offset.y", math.sin(os.clock())*10)
    end
    if daSongName == "google" then
        screenCenter("deadText")
    end
end


function onGameOverConfirm(isNotGoingToMenu)
    if isNotGoingToMenu then
        runHaxeCode([[
        camDead.flash(0x20FFFFFF, 2, null, true);
        camDead.fade(0xFF000000, 2.7);
        ]])
        if daSongName == "google" then
            cancelTimer("deadTypeText")
            setTextString("deadText", "Hurray!")
        end
        if daSongName == "no-debug" or daSongName == 'myself' or daSongName == 'furryfemboy' then
            playAnim("ammarEyes", "blink", true)
        end
        if  getPropertyFromClass("PlayState", "curStage") == "discordStage" or getPropertyFromClass("PlayState", "curStage") == "demonbg" then
            cancelTimer("deadTypeText")
            setTextString("deadText", "Annoying User joined the server")
        end
        if  getPropertyFromClass("PlayState", "curStage") == "youtubeStage" or getPropertyFromClass("PlayState", "curStage") == "twitterStage" or daSongName == 'big-problem'  then
            setTextString("deadText", "Restarting...")
        end
    else
        runHaxeCode([[  
            game.persistentDraw = false;
        ]])
    end 
end

function onUpdate(elasped)
    if inGameOver then
        if mobileMode and canClick then
            if mouseClicked("") then
                runHaxeCode([[
                    camDead.flash(0x20FFFFFF, 0.5, null, true);
                    GameOverSubstate.instance.endBullshit();
                ]])
            elseif getPropertyFromClass("flixel.FlxG", "android.justReleased.BACK") then --getPropertyFromClass("flixel.FlxG", "android.justReleased.BACK") or
                runHaxeCode([[
                    FlxG.sound.music.stop();
                    PlayState.deathCounter = 0;
                    PlayState.seenCutscene = false;
                    PlayState.chartingMode = false;

                    WeekData.loadTheFirstEnabledMod();
                    MusicBeatState.switchState(new MainMenuStateAmmar());

                    FlxG.sound.playMusic(Paths.music('freakyMenu'));
                    game.callOnLuas('onGameOverConfirm', [false]);
                ]])
            end
        end
        calculateBeat()
        customUpdateGameOver()
    end
end

local oldStep = 0
local step = 0
function calculateBeat()
    local songTime = getPropertyFromClass("flixel.FlxG", "sound.music.time")/1000
    local crochet = (60 / thisBPM)
    step = math.ceil(songTime / (crochet/4)) - 1

    if step ~= oldStep then
        oldStep = step
        customStepHit()
    end
end

function customStepHit()
    if step%4 == 0 and (daSongName == "google" or daSongName == "no-debug" or daSongName == 'myself' or daSongName == 'furryfemboy') then
        scaleObject("deadText", 1.1, 1.1)
        doTweenX("deadTextScaleX", "deadText.scale", 1, 0.5, "quadOut")
        doTweenY("deadTextScaley", "deadText.scale", 1, 0.5, "quadOut")
    end

    if step%16 == 0 and (daSongName == "no-debug" or daSongName == 'myself' or daSongName == 'furryfemboy') then
        playAnim("ammarEyes", "blink", true)
        runTimer("unblink", 0.1)
    end

    if step%8 == 0 and (getPropertyFromClass("PlayState", "curStage") == "discordStage" or getPropertyFromClass("PlayState", "curStage") == "demonbg") then
        setProperty("deathVig.alpha", 0.8)
        doTweenAlpha("deathVIG", "deathVig", 1, 0.6)

        scaleObject("deadText", (step%16==0 and 1.05 or 0.95), (step%16==8 and 1.05 or 0.95), false)
        doTweenX("deadTextScaleX", "deadText.scale", 1, 1, "quadOut")
        doTweenY("deadTextScaley", "deadText.scale", 1, 1, "quadOut")
    end

    if step%8 == 0 and (getPropertyFromClass("PlayState", "curStage") == "youtubeStage" or getPropertyFromClass("PlayState", "curStage") == "twitterStage" or daSongName == 'big-problem') then
        setProperty("deathVig.alpha", 0.8)
        doTweenAlpha("deathVIG", "deathVig", 1, 0.6)

        scaleObject("deadText", (step%16==0 and 1.05 or 0.95), (step%16==8 and 1.05 or 0.95), false)
        doTweenX("deadTextScaleX", "deadText.scale", 1, 1, "quadOut")
        doTweenY("deadTextScaley", "deadText.scale", 1, 1, "quadOut")
    end

    if step%4 == 0 and (daSongName == 'furryappeared') then
        scaleObject("deadText", 1.05, 1.05)
        doTweenX("deadTextScaleX", "deadText.scale", 1, 0.5, "quadOut")
        doTweenY("deadTextScaley", "deadText.scale", 1, 0.5, "quadOut")
        screenCenter('deadText', 'x')
    end
end

function onUpdatePost(elapsed)
    if inGameOver then
        if daSongName == "no-debug" or daSongName == 'myself' or daSongName == 'furryfemboy' then
            screenCenter("deadText", "X")
        end
    end
end

local textToType = ""
local textTag = ""
function typeText(tagText, typeToText, duration)
    cancelTimer("deadTypeText")
    setTextString(tagText, "")
    textToType = typeToText
    textTag = tagText

    runTimer("deadTypeText", duration / #textToType, #textToType)
end

function onTimerCompleted(tag, loops, loopsLeft) 
    if Timer ~= nil then Timer.timerEnd(tag, loops, loopsLeft) end 
    if tag == "deadTypeText" then
        setProperty(textTag..".text", string.sub(textToType, 1, loops - loopsLeft))
    end
        
    if tag == "unblink" then
        playAnim("ammarEyes", "idle", true)
    end

    if tag == 'furryDeadText' then
        doTweenY('deadTextCome', 'deadText', getProperty('deathChar.y') - 120, 1.25, 'quadOut')
    end
end

function lerp(a, b, t) return a + (b - a) * t end