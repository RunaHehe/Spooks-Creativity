folder = ""

SpriteUtil = nil

downGlowBeat = false
upGlowBeat = false
squaresParticleSpawn = false

local videoSprites = {}
function onCreate()
    luaDebugMode = true
    package.path = getProperty("modulePath") .. ";" .. package.path
   SpriteUtil = require("SpriteUtil")

   addHaxeLibrary('Conductor', '')
   
end
function onCreatePost()
    runHaxeCode([[
        camNotes = new FlxCamera();
        camNotes.bgColor = 0xF;
        camVideo = new FlxCamera();
        camVideo.bgColor = 0xF;

        FlxG.cameras.remove(game.camHUD, false);
        FlxG.cameras.remove(game.camOther, false);
        FlxG.cameras.add(camVideo, false);
        FlxG.cameras.add(camNotes, false);
        FlxG.cameras.add(game.camHUD, false);
        FlxG.cameras.add(game.camOther, false);

        game.variables.set("camNotes", camNotes);
        game.variables.set("camVideo", camVideo);

        game.strumLineNotes.camera = camNotes;
        game.notes.camera = camNotes;
        game.grpNoteSplashes.camera = camNotes;
    ]])

    SpriteUtil.makeSprite({tag="upGlow",image=folder.."mod/upGlow", cam="camOther"})
    screenCenter("upGlow")
    setProperty("upGlow.alpha", 0)
    setBlendMode("upGlow", "add")

    SpriteUtil.makeSprite({tag="downGlow",image=folder.."mod/downGlow", cam="camOther"})
    screenCenter("downGlow")
    setProperty("downGlow.alpha", 0)
    setBlendMode("downGlow", "add")

    SpriteUtil.makeSprite({tag="vignette",image=folder.."mod/Vignette", cam="camOther", xSize = 0.5})
    screenCenter("vignette")
    setProperty("vignette.alpha", 0)
    setBlendMode("vignette", "multiply")

    loadGraphic("opponent", "chars/Moderator")
    setGraphicSize("opponent", 649 * 0.625, 146 * 0.625)

    setGlobalFromScript("stages/discordStage", "opponentTyping", "(Prefessor Mod is Typing...)")

   -- cacheVideo()
    readyVideo()

    SpriteUtil.makeSprite({tag="blackScreen", cam="camOther", graphicColor = "000000", graphicWidth = 1300, graphicHeight = 800})
    screenCenter("blackScreen")
    setProperty("blackScreen.alpha", 0)

    setHealthBarColors("77A6FF", "ffc400")

    setProperty('videoCutscene.bitmap.mute', false)
end

function onStepEvent(curStep)
    if curStep == 384 or curStep == 448 then
        setProperty("defaultCamZoom", 3)
        setProperty("camDiscord.zoom", 3)
        setProperty("camBDiscord.zoom", 3)
    end
    if curStep-1 == 384 or curStep-1 == 448 then
        setProperty("defaultCamZoom", 0.9)
    end

    if curStep == 760 then
        doTweenAlpha("blackHidden", "blackScreen", 1, crochet/1000*2, "quadIn")
        doTweenAlpha("camHUDhide", "camHUD", 0, crochet/1000*2, "quadIn")
    end
    if curStep == 768 then
        spawnCutscene()
        doTweenAlpha("blackHidden", "blackScreen", 0, crochet/1000*1, "linear")
    end
    if curStep == 1264 then
        doTweenAlpha("blackHidden", "blackScreen", 1, crochet/1000*4, "quadIn")
        doTweenAlpha("camHUDshow", "camHUD", 1, crochet/1000*4, "quadIn")
    end
    if curStep == 1280 then
        doTweenAlpha("blackHidden", "blackScreen", 0, crochet/1000*4, "linear")
    end

    if curStep == 1536 then
        setProperty("dad.healthIcon", "moderator-happy")
        setProperty("boyfriend.healthIcon", "annoyer-happy")
        runHaxeCode([[
            game.iconP2.changeIcon("icon-moderator-happy");
            game.iconP1.changeIcon("icon-annoyer-happy");
        ]])

        setHealthBarColors("77A6FF", "ffc400")
    end
    if curStep == 1540 then
        setHealthBarColors("77A6FF", "ffc400")
    end


    --glow
    if curStep == 128 or curStep == 1280 then
        upGlowBeat = true
    end
    if curStep == 256 or curStep == 640 or curStep == 1280 then
        downGlowBeat = true
    end
    if curStep == 512 then
        downGlowBeat = false
        squaresParticleSpawn = true
    end
    if curStep == 760 then
        downGlowBeat = false
        squaresParticleSpawn = false
        upGlowBeat = false
    end
    if curStep == 1536 then
        squaresParticleSpawn = true
    end
    if curStep == 1792 then
        downGlowBeat = false
        squaresParticleSpawn = false
        upGlowBeat = false
    end
    if curBeat ~= 96 and curBeat ~= 112 and curBeat ~= 352 and curBeat ~= 358 then
        if downGlowBeat and curStep % 4 == 0 then
            setProperty("downGlow.alpha", 0.6)
            doTweenAlpha("downGlow", "downGlow", 0, crochet/1000)
            triggerEvent("Add Camera Zoom", "", "0.05")
        end
        if upGlowBeat and curStep % 4 == 0 then
            setProperty("upGlow.alpha", 0.8)
            doTweenAlpha("upGlow", "upGlow", 0, crochet/1000)
            
        end
    end

    if curStep == 1280 then
        cameraFlash("camOther", "0xFFFFFFFF", 1, true)
        setProperty("vignette.alpha", 1)
    end

    if curStep == 1536 then
        cameraFlash("camOther", "0xFFFFFFFF", 1)
        setProperty("vignette.alpha", 0)
    end
end



function onStepHit()
    if (curStep >= 64 and curStep < 128) then
        if (((curStep%16==0 or curStep%16==3 or curStep%16==6 or curStep%16==9) or (curStep%16>=12 and curStep%2==0)) and curStep%64 < 56) or 
        (curStep%64 == 56 or curStep%64 == 59 or curStep%64 == 62) then
            setProperty("upGlow.alpha", 0.8)
            doTweenAlpha("upGlow", "upGlow", 0, 0.3)
        end
    end

    if curStep % 2 == 0 and squaresParticleSpawn then
        spawnSquare()
    end
end

local squareID = 0
local squares = {}
function spawnSquare()
    local tag = "squareParticle"..squareID
    SpriteUtil.makeSprite({tag=tag,graphicColor = "42A6FF", graphicWidth = 1300, graphicHeight = 50, cam="camOther", y = 740})
    screenCenter(tag, "X")
    setProperty(tag..".alpha", 0.4)
    setBlendMode(tag, "add")
    doTweenY(tag, tag, 300, 2, "quadIn")
    doTweenAlpha("alphingSquare"..squareID, tag, 0, 2, "quadIn")
    squares[tag] = 1 

    squareID = squareID + 1
end 


function onTweenCompleted(tag)
   if string.find(tag, "squareParticle") then
        removeLuaSprite(tag, true)
        squares[tag] = null
   end
end


function videoEnded(tag)
    if tag == "cutsceneMod" then
        inCutscene = false
    end
end

function readyVideo()
    runHaxeCode([[
        var video = new FlxVideoSprite(0, 0);
        video.antialiasing = true;
        video.bitmap.onFormatSetup.add(function()
            {
                video.setGraphicSize(FlxG.width, FlxG.height);
                video.updateHitbox();
                video.screenCenter();
                video.camera = camVideo;
            });
        video.bitmap.onEndReached.add(function(){
            game.callOnLuas("videoEnded", ["cutsceneMod"]);
            video.destroy();
        });
        video.autoPause = false;
        video.load(Paths.video("Moderator Mid Cutscene"));
        video.bitmap.mute = true;
        game.add(video);
        new FlxTimer().start(0.001, function(tmr:FlxTimer)
        {
            video.play();
            new FlxTimer().start(0.001, function(tmr:FlxTimer)
            {
                video.pause();
                video.bitmap.time = 0;
            });
        });
        video.visible = false;
        setVar('video', video);
    ]])
end


inCutscene = false
function spawnCutscene()
    runHaxeCode("getVar('video').play();")
    runHaxeCode("getVar('video').visible = true;")
    runHaxeCode("getVar('video').bitmap.mute = true;")
    
    inCutscene = true
    setObjectOrder("video", getObjectOrder("healthBar") - 5)

    for i, v in pairs(squares) do
        cancelTween(i)
        removeLuaSprite(i)
    end
end

function onUpdatePost()
    if not inGameOver then
        setProperty("camNotes.zoom", getProperty("camHUD.zoom"))
        if inCutscene then
            --runHaxeCode('video.time = Conductor.songPosition - 74322.5806;')
            -- runHaxeCode([[
            --     if (cutsceneMod != null) {
            --         cutsceneMod.time = Conductor.songPosition - 74322.5806;
            --         game.getLuaObject("cutsceneMod").loadGraphic(cutsceneMod.bitmapData);
            --     }
            -- ]])
        end
    end
    
end

function syncVideo()
    local time = getSongPosition() - 74322.5806
    runHaxeCode([[
        getVar('video').pause();
        getVar('video').bitmap.time = ]]..tostring(time)..[[;
        getVar('video').play();
    ]])
end

function onSectionHit()
    if inCutscene then
        syncVideo()
    end
end

local inPause = false
function onFocus()
    if inCutscene and not inPause then
        runHaxeCode("getVar('video').resume();")
    end
end
function onFocusLost()
    if inCutscene and not inPause then
        runHaxeCode("getVar('video').pause();")
    end
end
function onPause()
    inPause = true
    if inCutscene then
        runHaxeCode("getVar('video').pause();")
    end
end
function onResume()
    inPause = false
    if inCutscene then
        runHaxeCode("getVar('video').resume();")
    end
end

function onDestroy()
    runHaxeCode([[
        if (getVar('video') != null)
            getVar('video').destroy();
    ]])
end

-- function onDestroy()
--     runHaxeCode([[
--         FlxG.signals.gameResized.remove(outsideGameClick);
--     ]])
--     if inCutscene then
--         runHaxeCode([[
--             cutsceneMod.stop();
--             cutsceneMod.finishCallback = function(){};
--             cutsceneMod = null;
--         ]])
--     end
-- end