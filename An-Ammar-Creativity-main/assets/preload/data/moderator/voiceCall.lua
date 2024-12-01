folder = "call/"

SpriteUtil = nil

local annSpeak = false
local modSpeak = false

function onCreate()
    luaDebugMode = true
    package.path = getProperty("modulePath") .. ";" .. package.path
   SpriteUtil = require("SpriteUtil")
end
function onCreatePost()
    SpriteUtil.makeSprite({tag="blackBG", graphicColor = "000000", graphicWidth = 1800, graphicHeight = 388})
    setProperty("blackBG.alpha", 0)
    screenCenter("blackBG")
    runHaxeCode("game.getLuaObject('blackBG').camera = camDiscord;")

    SpriteUtil.makeSprite({tag="voiceColor",image=folder.."BackColor", xSize = 0.935})
    screenCenter("voiceColor")
    setProperty("voiceColor.alpha", 0)
    runHaxeCode("game.getLuaObject('voiceColor').camera = camDiscord;")

    SpriteUtil.makeSprite({tag="voiceOverlay",image=folder.."Overlay", xSize = 0.935})
    screenCenter("voiceOverlay")
    setProperty("voiceOverlay.alpha", 0)
    runHaxeCode("game.getLuaObject('voiceOverlay').camera = camDiscord;")

    --green outline
    SpriteUtil.makeSprite({tag="modTalky",image=folder.."Talk Box", xSize = 0.875, x = 140, y = 219})
    setProperty("modTalky.alpha", 0)
    runHaxeCode("game.getLuaObject('modTalky').camera = camDiscord;")

    SpriteUtil.makeSprite({tag="annTalky",image=folder.."Talk Box", xSize = 0.875, x = 630, y = 219})
    setProperty("annTalky.alpha", 0)
    runHaxeCode("game.getLuaObject('annTalky').camera = camDiscord;")

    SpriteUtil.makeSprite({tag="modCall",image=folder.."Moderator Calling", xSize = 0.935})
    screenCenter("modCall")
    setProperty("modCall.alpha", 0)
    runHaxeCode("game.getLuaObject('modCall').camera = game.camHUD;")


    SpriteUtil.makeSprite({tag="buttons",image=folder.."callButtons", xSize = 1})
    screenCenter("buttons")
    setProperty('buttons.y', 520)
    setProperty("buttons.alpha", 0)
    runHaxeCode("game.getLuaObject('buttons').camera = camDiscord;")

    runHaxeCode("game.dadGroup.camera = camDiscord;")
    runHaxeCode("game.boyfriendGroup.camera = camDiscord;")
    
    setProperty("dad.x", 270); setProperty("dad.y", 268)
    setProperty("boyfriend.x", 750); setProperty("boyfriend.y", 242)
    
    setObjectOrder("voiceOverlay", getObjectOrder("dadGroup") + 4)
    setObjectOrder("modTalky", getObjectOrder("voiceOverlay") + 2)
    setObjectOrder("annTalky", getObjectOrder("voiceOverlay") + 2)
    setObjectOrder("buttons", getObjectOrder("annTalky") + 2)

    setProperty('dad.alpha', 0)
    setProperty('boyfriend.alpha', 0)

    --voiceMode()
    makeLuaSprite("whiter", '', 0, 0)
end

voiceModer = false
function voiceMode()
    voiceModer = true
    --setProperty("modBox.alpha", 1)
    --setProperty("annBox.alpha", 1)

    setProperty("blackBG.alpha", 1)

    setProperty("channels.alpha", 0)
    setProperty("members.alpha", 0)
    setProperty("topBar.alpha", 0)

    setProperty("player.alpha", 0)
    setProperty("playerText.visible", false)
    setProperty("opponent.alpha", 0)
    setProperty("opponentText.visible", false)

    setProperty("buttons.alpha", 1)

    setProperty('dad.alpha', 1)
    setProperty('boyfriend.alpha', 1)

    setProperty('voiceOverlay.alpha', 1)
    setProperty('voiceColor.alpha', 1)
    --setProperty('modTalky.visible', true)
    --setProperty('annTalky.visible', true)
end


function onEvent(eventName, value1, value2)
    if eventName == "Change Character" then
        setProperty("dad.x", 270); setProperty("dad.y", 268)
        setProperty("boyfriend.x", 750); setProperty("boyfriend.y", 242)
    end
end
function onStepEvent(curStep)
    if curStep == 1264 then
        setProperty("modCall.alpha", 1)
    end
    if curStep == 1280 then
        setProperty("modCall.alpha", 0)
        voiceMode()
    end
    if curStep == 1408 then
        setProperty('camDiscord.angle', 360)
        doTweenAngle('camDiscord', 'camDiscord', 0, crochet/1000, 'quadIn')
    end
    if curStep-4 == 1408 then
        cameraFlash('camHUD', '0xA0FFFFFF', 1)
    end
    if curStep == 1472 then
        setProperty('camDiscord.angle', -360)
        doTweenAngle('camDiscord', 'camDiscord', 0, crochet/1000, 'quadIn')
    end
    if curStep-4 == 1472 then
        cameraFlash('camHUD', '0xA0FFFFFF', 1)
    end
    if curStep == 1536 then
        doTweenAngle('camDiscord', 'camDiscord', 0, crochet/1000, 'quadIn')
    end
end
function onBeatHit()
    if curBeat >= 416 and curBeat < 448 then
        setProperty('buttons.angle', curBeat%2==0 and 10 or -10)
        doTweenAngle('buttons', 'buttons', 0, crochet/1000, 'quadOut')
    end
    if getProperty("dad.animation.curAnim.name") == "idle" then 
        playAnim("dad", "idle", true)
     end
end

function onUpdate(elapsed)
    if annSpeak then
        setProperty('annTalky.colorTransform.redOffset', getProperty('whiter.x'))
        setProperty('annTalky.colorTransform.greenOffset', getProperty('whiter.x'))
        setProperty('annTalky.colorTransform.blueOffset', getProperty('whiter.x'))
    end
    if modSpeak then
        setProperty('modTalky.colorTransform.redOffset', getProperty('whiter.y'))
        setProperty('modTalky.colorTransform.greenOffset', getProperty('whiter.y'))
        setProperty('modTalky.colorTransform.blueOffset', getProperty('whiter.y'))
    end
    setProperty("buttons.y", 520 + math.sin(getSongPosition()/1000) * 12)
end


function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if voiceModer then
        setProperty("annTalky.alpha", 1)
        runTimer("annTalkyEnd", 0.5)
        if not isSustainNote then
            setProperty('whiter.x', 200)
            doTweenX('whiter', 'whiter', 0, 0.3, 'quadout')
            annSpeak = true
        end
    end
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if voiceModer then
        setProperty("modTalky.alpha", 1)
        runTimer("modTalkyEnd", 0.5)
        if not isSustainNote then
            setProperty('whiter.y', 200)
            doTweenY('whiter', 'whiter', 0, 0.3, 'quadout')
            modSpeak = true
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "annTalkyEnd" then
        setProperty("annTalky.alpha", 0)
        annSpeak = false
    end
    if tag == "modTalkyEnd" then
        setProperty("modTalky.alpha", 0)
        modSpeak = false
    end
end