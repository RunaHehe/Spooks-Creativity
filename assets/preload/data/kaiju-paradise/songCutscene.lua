local videoSprites = {}

function onCreate()
    package.path = getProperty("modulePath") .. ";" .. package.path
    SpriteUtil = require("SpriteUtil")

    addHaxeLibrary('Conductor', '')
end

function onCreatePost()
    runHaxeCode([[
        camVideo = new FlxCamera();
        camVideo.bgColor = 0xF;

        FlxG.cameras.add(camVideo, false);

        game.variables.set("camVideo", camVideo)
    ]])

    readyVideo()
    setProperty('videoCutscene.bitmap.mute', false)
end

function onStepEvent(curStep)
    if curStep == 512 then
        spawnCutscene()
    end
end

function videoEnded(tag)
    if tag == "cutsceneKaiju" then
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
            game.callOnLuas("videoEnded", ["cutsceneKaiju"]);
            video.destroy();
        });
        video.autoPause = false;
        video.load(Paths.video("Kaiju Mid Cutscene"));
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

function syncVideo()
    local time = getSongPosition() - 54322.5806
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