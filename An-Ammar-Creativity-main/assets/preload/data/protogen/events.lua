local camEvent = {}

local enableCamZooming = true
local camZooming = true

local lightBeat = false
local centerCam = false
--New Cam System
local zoom = 1
local zoomBeat = 0
local hudBeat = 0

local isZoomTweening = false

local camPos = {{450,350}, {990,350}} -- left, right
-- debug 
local noDark = false
--shaders
    local tweeningRGBSplit = false
    local tweeningRadialBlur = false
--
videoBGPlay = false
function onCreate()
    setProperty('useModchart', true)

    setProperty('iconSpeed', 2)
    shadersEnabled = getProperty('shaderBack')
end


function onCreatePost()
    luaDebugMode = true

    if shadersEnabled then
        initLuaShader("RGB_PIN_SPLIT")
        initLuaShader("radchr")
        initLuaShader("LowQuality")
    
        makeLuaSprite('rgbSplitTween', '', 0, -1000)
        setSpriteShader("rgbSplitTween", "radchr")
        setShaderFloat("rgbSplitTween", "iMin", 0.01)
        setShaderFloat("rgbSplitTween", "iOffset", 0)

        makeLuaSprite('radialBlurTween', '', 0, -1000)
        setSpriteShader("radialBlurTween", "radialBlur")
        setShaderFloat("radialBlurTween", "cx", 0.5)
        setShaderFloat("radialBlurTween", "cy", 0.5)
        setShaderFloat("radialBlurTween", "blurWidth", 0)

        makeLuaSprite('lowQuality', '', 0, -1000)
        setSpriteShader("lowQuality", "LowQuality")
        setShaderFloat("lowQuality", "PIXEL_FACTOR", 100)
        setShaderFloat("lowQuality", "COLOR_FACTOR", 255*255*255)

        runHaxeCode([[
            var rgb = new ShaderFilter(game.getLuaObject("rgbSplitTween").shader);
            var blur = new ShaderFilter(game.getLuaObject("radialBlurTween").shader);
            var low = new ShaderFilter(game.getLuaObject("lowQuality").shader);
            game.camGame.setFilters([rgb, blur]);
            game.camHUD.setFilters([rgb, blur]);
        ]])
    end

    makeLuaSprite('camAngle', '', 0, -1000)
    makeLuaSprite('zoomTween', '', 1, -1000) setProperty('zoomTween.visible', false) setProperty('zoomTween.active', false) -- var tween
    if not noDark then
        setProperty("chardark.alpha", 0.75)
        setProperty("vignette.alpha", 1)

        for i = 1,4 do
            setProperty('light'..i..'.alpha', 0)
        end
    end
    zoom = getProperty('defaultCamZoom') setProperty('zoomTween.x', zoom)
    zoomingEvent()

    --NEW FEATURE
    if not EasyMode and Mechanic then
        runHaxeCode([[
            game.strumLineNotes.camera = game.camGame;
            game.notes.camera = game.camGame;
            game.grpNoteSplashes.camera = game.camGame;
            game.grpNoteHoldSplashes.camera = game.camGame;
            game.comboSpr.camera = game.camGame;
            game.comboSpr.scrollFactor.set(0.8, 0.8);

            for (strum in game.strumLineNotes) {
                strum.scrollFactor.set(0.8, 0.8);
            }

            for (note in game.unspawnNotes) {
                note.scrollFactor.set(0.8, 0.8);
            }

            game.healthBar.camera = game.camGame;
            game.healthBarBG.camera = game.camGame;
            game.healthBarOverlay.camera = game.camGame;
            game.iconP1.camera = game.camGame;
            game.iconP2.camera = game.camGame;
        ]])
        setPropertyFromClass("NoteSplash", 'scrollX', 0.8)
        setPropertyFromClass("NoteSplash", 'scrollY', 0.8)
        setPropertyFromClass("NoteHoldSplash", 'scrollX', 0.8)
        setPropertyFromClass("NoteHoldSplash", 'scrollY', 0.8)
        setProperty('comboSprY', 400)

        
        setObjectOrder("grpNoteSplashes", getObjectOrder("notes") + 1)
        setObjectOrder("grpNoteHoldSplashes", getObjectOrder("notes") + 3)
        setObjectOrder("healthBar", getObjectOrder("light1")-1)
        setObjectOrder("healthBarBG", getObjectOrder("light1")-1)
        setObjectOrder("healthBarOverlay", getObjectOrder("light1")-1)
        setObjectOrder("iconP1", getObjectOrder("light1")-1)
        setObjectOrder("iconP2", getObjectOrder("light1")-1)
        for i = 0, 7 do
            setPropertyFromGroup('strumLineNotes', i, 'y', 0)
        end
    
    end

    makeLuaSprite('onecolor', '', 0,0)
	makeGraphic("onecolor", 1280, 720, 'FFFFFF')
	scaleObject('onecolor', 1.8, 1.8)
	screenCenter('onecolor')
	setScrollFactor('onecolor', 0, 0)
	setProperty("onecolor.alpha", 0)
	addLuaSprite('onecolor', false)
    setProperty('onecolor.color', 0)
    setObjectOrder("onecolor", getObjectOrder("dadGroup") - 4)

    if not EasyMode and Mechanic then
        if HardMode then --better view
            setObjectOrder("strumLineNotes", getObjectOrder("healthBar"))
            setObjectOrder("notes", getObjectOrder("healthBar"))
            setProperty('healthBar.visible', false)
            setProperty('healthBarBG.visible', false)
            setProperty('healthBarOverlay.visible', false)
            setProperty('iconP1.visible', false)
            setProperty('iconP2.visible', false)
        else
            setObjectOrder("strumLineNotes", getObjectOrder("dadGroup")-1)
            setObjectOrder("notes", getObjectOrder("dadGroup")-1)
        end
    end

    createSpace()

    makeLuaSprite('red', '', 0,0)
	makeGraphic("red", 1280, 720, 'FF0000')
	scaleObject('red', 1.8, 1.8)
	screenCenter('red')
	setScrollFactor('red', 0, 0)
	setProperty("red.alpha", 0)
    setBlendMode("red", 'multiply')
	addLuaSprite('red', true)

    makeLuaSprite('white', '', -500,-300)
	makeGraphic("white", 1280, 720, 'FFFFFF')
	scaleObject('white', 1.8, 1.8)
	screenCenter('white')
	setScrollFactor('white', 0, 0)
	setObjectCamera('white', 'add')
	setProperty("white.alpha", 0)
	addLuaSprite('white', true)

    readyVideo()

    setProperty('boyfriend.flipX', false)
    setProperty('dad.flipX', true)

    setProperty('dad.x', 1150 - 200)
    setProperty('dad.y', -210)
    setProperty('boyfriend.x', 0)

    setProperty('camFollow.x', camPos[2][1])
    setProperty('camFollow.y', camPos[2][2])

    setProperty('healthBar.flipX', true)
    setProperty('iconP1.flipX', true)
    setProperty('iconP2.flipX', true)
end
function zoomingEvent()
    local sec = crochet/1000*4
    local bea = crochet/1000
    --scheduleZoom(0, 1.2, 0, '')
    scheduleSort()
end

local spaceData = {
    {'float', 'FLIGHT_SPEED', 2},

    {'float', 'DRAW_DISTANCE', 20},
    {'float', 'FADEOUT_DISTANCE', 10},
    {'float', 'FIELD_OF_VIEW', 2.7},

    {'float', 'STAR_SIZE', 0.4},
    {'float', 'STAR_CORE_SIZE', 0.14},

    {'float', 'CLUSTER_SCALE', 0.3},
    {'float', 'STAR_THRESHOLD', 0.5},

    {'float', 'BLACK_HOLE_CORE_RADIUS', 0.2},
    {'float', 'BLACK_HOLE_THRESHOLD', 0.3},
    {'float', 'BLACK_HOLE_DISTORTION', 0.03}
}
function createSpace()
    initLuaShader("space")--

    makeLuaSprite('space', '', 0,0)
	makeGraphic("space", 1280, 720, 'FF0000')
	scaleObject('space', 1.8, 1.8)
	screenCenter('space')
	setScrollFactor('space', 0, 0)
	addLuaSprite('space', false)
    setSpriteShader("space", "space")
    if not HardMode then
        setObjectOrder("space", getObjectOrder("strumLineNotes"))
    end
    setProperty('space.alpha', 0)

    for i,data in pairs(spaceData) do
        if data[1] == 'float' then
            setShaderFloat('space', data[2], data[3])
        end
    end
end

function onSongStart()
    onStepHit()
end

local lastStep = 0
function onStepHit()
    for i = lastStep+1, curStep do
        stepEvent(i)
    end
    if videoBGPlay then
        createParticle(2)
    end
    if lightBeat and curStep % 4 == 0 then
        for i = 1,4 do
            setProperty('light'..i..'.alpha', 0.5) 
            doTweenAlpha('light'..i,'light'..i, 0.3, crochet/1000)
        end
        zoomBeat = zoomBeat + 0.015
        hudBeat = hudBeat + 0.03
    end
    if ((curStep < 128) or (curStep >= 512 and curStep < 544) or (curStep >= 576 and curStep < 608)) and (curStep % 32 == 0 or curStep % 32 == 6 or curStep % 32 == 12 or curStep % 32 == 18 or curStep % 32 == 24 or curStep % 32 == 28) then
        zoomBeat = zoomBeat + 0.2
        hudBeat = hudBeat + 0.05

        setProperty("red.alpha", 0.2)
        doTweenAlpha('red', 'red', 0, 0.4)
    end
    if ((curStep >= 128 and curStep < 184) or (curStep >= 256 and curStep < 512) or (curStep >= 640 and curStep < 696) or (curStep >= 1280 and curStep < 1344) or (curStep >= 1408 and curStep < 1664) or (curStep >= 1920 and curStep < 2432)) and (curStep % 4 == 0) then
        zoomBeat = zoomBeat + 0.08
        hudBeat = hudBeat + 0.04

        if curStep <= 1920 then
            setProperty('camAngle.x', curStep%8==0 and 10 or -10)
            doTweenX('camAngle', 'camAngle', 0, crochet/1000, 'quadOut')
        end

        if curStep >= 1152 then
            setProperty("red.alpha", 0.75)
            doTweenAlpha('red', 'red', 0.6, 0.4)

            setRGBSplit((getProperty('space.alpha') <= 0.2 and curStep < 1920) and 0.2 or  0.05)
            tweenRGBSplit(0, 0.4, 'quadOut')
        else
            setProperty("red.alpha", 0.5)
            doTweenAlpha('red', 'red', 0.2, 0.4)
        end

        if curStep >= 256 and curStep < 512  then
            setRadialBlur(-0.05)
            tweenRadialBlur(0, 0.4, 'quadOut')
        end
    end
    if ((curStep >= 192 and curStep < 208) or (curStep >= 704 and curStep <= 720) or (curStep >= 1344 and curStep < 1376)) and (curStep % 2 == 0) then
        zoomBeat = zoomBeat + 0.08
        hudBeat = hudBeat + 0.04

        if curStep >= 1152 then
            setProperty("red.alpha", 0.8)
            doTweenAlpha('red', 'red', 0.6, 0.3)
        else
            setProperty("red.alpha", 0.7)
            doTweenAlpha('red', 'red', 0.3, 0.3)
        end
    end
    if (curStep >= 208 and curStep < 216 + 8) or (curStep >= 720 and curStep <= 736) or (curStep >= 1376 and curStep < 1392) then
        zoomBeat = zoomBeat + 0.08
        hudBeat = hudBeat + 0.04

        if curStep >= 1152 then
            setProperty("red.alpha", 0.8)
            doTweenAlpha('red', 'red', 0.6, 0.2)
        else
            setProperty("red.alpha", 0.7)
            doTweenAlpha('red', 'red', 0.3, 0.2)
        end
    end

    if (curStep >= 768 and curStep < 880) and (curStep % 4 == 0 or curStep % 64 == 30 or curStep % 64 == 60 or curStep % 64 == 61 or curStep % 64 == 62 or curStep % 64 == 63) then
        zoomBeat = zoomBeat + 0.08
        hudBeat = hudBeat + 0.04

        setProperty("red.alpha", 1)
        doTweenAlpha('red', 'red', 0.2, 0.5)

        setRGBSplit(0.5)
        tweenRGBSplit(0, 0.5, 'expoOut')

        setRadialBlur(-0.05)
        tweenRadialBlur(0, 0.4, 'quadOut')
    end

    if (curStep >= 1216 and curStep < 1280) and curStep%4==0 then --clap
        zoomBeat = zoomBeat + 0.04
        hudBeat = hudBeat + 0.02
    end
    lastStep = curStep
end
function onSectionHit()
    if enableCamZooming then
        zoomBeat = zoomBeat + 0.015
        hudBeat = hudBeat + 0.03
    end
end
function stepEvent(curStep)
    if curStep == 184 or curStep == 188 or curStep == 696 or curStep == 700 then --hey
        zoomBeat = zoomBeat + 0.4
        hudBeat = hudBeat + 0.06
        playAnim('dad', 'hey', true)
        setProperty('camFollow.x', 1300)
        setProperty('camFollow.y', 300)
        setProperty('camFollowPos.x', getProperty('camFollow.x'))
        setProperty('camFollowPos.y', getProperty('camFollow.y'))
        setProperty('camAngle.x', curStep%8==0 and 20 or -20)

        setProperty("red.alpha", 1)
        doTweenAlpha('red', 'red', 0.2, 0.5)

        setRadialBlur(-0.4)
        tweenRadialBlur(0, 0.4, 'quadOut')
    end
    if curStep == 192 or curStep == 704 then --hey finish
        setProperty('camAngle.x', 0)
    end

    if curStep == 128 then
        doTweenAlpha('vignette', 'vignette', 0.5, 2)
        doTweenAlpha('chardark', 'chardark', 0.6, 2)

        setProperty('iconSpeed', 1)
    end
    if curStep == 224 then
        setProperty('iconSpeed', 4)
    end
    if curStep == 256 then
        setProperty('iconSpeed', 1)
    end
    if curStep == 512 then
        setProperty('iconSpeed', 2)
    end
    if shadersEnabled and curStep == 544 then
        runHaxeCode([[
            var rgb = new ShaderFilter(game.getLuaObject("rgbSplitTween").shader);
            var blur = new ShaderFilter(game.getLuaObject("radialBlurTween").shader);
            var low = new ShaderFilter(game.getLuaObject("lowQuality").shader);
            game.camGame.setFilters([rgb, blur, low]);
            game.camHUD.setFilters([rgb, blur, low]);
         ]])
    end
    if shadersEnabled and curStep == 576 then
        runHaxeCode([[
            var rgb = new ShaderFilter(game.getLuaObject("rgbSplitTween").shader);
            var blur = new ShaderFilter(game.getLuaObject("radialBlurTween").shader);
            var low = new ShaderFilter(game.getLuaObject("lowQuality").shader);
            game.camGame.setFilters([rgb, blur]);
            game.camHUD.setFilters([rgb, blur]);
         ]])
    end
    if curStep == 640 then
        setProperty('iconSpeed', 1)
    end
    if curStep == 736 then
        setProperty('iconSpeed', 4)
    end
    if curStep == 768 then
        setProperty('iconSpeed', 1) 
    end
    if curStep == 880 then
        doTweenAlpha('white', 'white', 1, crochet/1000*4, 'expoIn')
        setProperty('iconSpeed', 4)
    end
    if curStep == 896 then
        doTweenAlpha('white', 'white', 0, crochet/1000*8, 'linear')
        setProperty("onecolor.alpha", 1)
        setProperty("dad.colorTransform.redOffset", 255)
        setProperty("dad.colorTransform.greenOffset", 255)
        setProperty("dad.colorTransform.blueOffset", 255)

        setProperty("boyfriend.colorTransform.redOffset", 255)
        setProperty("boyfriend.colorTransform.greenOffset", 255)
        setProperty("boyfriend.colorTransform.blueOffset", 255)

        setProperty('hazzy.alpha', 0)
        setProperty('roy.alpha', 0)
        setProperty('feizao.alpha', 0)

        setProperty("red.alpha", 0)
    end
    if curStep == 1024 then
        setProperty('iconSpeed', 2)
        doTweenAlpha('onecolor', 'onecolor', 0, crochet/1000*2, 'linear')
        setProperty("dad.colorTransform.redOffset", 0)
        setProperty("dad.colorTransform.greenOffset", 0)
        setProperty("dad.colorTransform.blueOffset", 0)

        setProperty("boyfriend.colorTransform.redOffset", 0)
        setProperty("boyfriend.colorTransform.greenOffset", 0)
        setProperty("boyfriend.colorTransform.blueOffset", 0)

        doTweenAlpha('hazzy', 'hazzy', 1, crochet/1000*2, 'linear')
        doTweenAlpha('roy', 'roy', 1, crochet/1000*2, 'linear')
        doTweenAlpha('feizao', 'feizao', 1, crochet/1000*2, 'linear')
    end
    if curStep == 1144 then
        playAnim('dad', 'error', true)
        setProperty('dad.specialAnim', true)
    end
    if curStep == 1152 then -- space
        if shadersEnabled and not lowQuality then
            setProperty('space.alpha', 1)
            setProperty('hazzy.alpha', 0)
            setProperty('roy.alpha', 0)
            setProperty('feizao.alpha', 0)

        end
        setProperty('iconSpeed', 1)
        setProperty('dad.specialAnim', false)
        cancelTween('onecolor')
        cancelTween('white')
        setProperty('onecolor.alpha',0)
        setProperty('white.alpha',0)

        setProperty("red.alpha", 0.6)
        flash(1, 2)
    end

    if curStep == 1664 then
        if shadersEnabled and not lowQuality then
            setProperty('space.alpha', 0)
            setProperty('hazzy.alpha', 1)
            setProperty('roy.alpha', 1)
            setProperty('feizao.alpha', 1)

        end
        setProperty('iconSpeed', 4)
        setProperty('onecolor.alpha',1)

        cancelTween('red')
        setProperty("red.alpha", 0)

        setProperty("dad.colorTransform.redOffset", 255)
        setProperty("dad.colorTransform.greenOffset", 255)
        setProperty("dad.colorTransform.blueOffset", 255)

        setProperty("boyfriend.colorTransform.redOffset", 255)
        setProperty("boyfriend.colorTransform.greenOffset", 255)
        setProperty("boyfriend.colorTransform.blueOffset", 255)

        setProperty('hazzy.alpha', 0)
        setProperty('roy.alpha', 0)
        setProperty('feizao.alpha', 0)
        flash(1, 4)
    end

    if curStep == 1912 then
        doTweenAlpha('white', 'white', 1, crochet/1000*2, 'expoIn')
    end
    if curStep == 1920 then -- VIDEO BG1
        setProperty('iconSpeed', 1)
        doTweenAlpha('white', 'white', 0, crochet/1000*2, 'linear')
        setProperty("dad.colorTransform.redOffset", 0)
        setProperty("dad.colorTransform.greenOffset", 0)
        setProperty("dad.colorTransform.blueOffset", 0)

        setProperty("boyfriend.colorTransform.redOffset", 0)
        setProperty("boyfriend.colorTransform.greenOffset", 0)
        setProperty("boyfriend.colorTransform.blueOffset", 0)

        setProperty('hazzy.alpha', 0)
        setProperty('roy.alpha', 0)
        setProperty('feizao.alpha', 0)

        setProperty('onecolor.alpha', 0)
        if not lowQuality then
            videoBGPlay = true
            setProperty('video.alpha', 1)
            runHaxeCode('video.play();')
        end
    end
    if curStep == 2432 then
        setProperty('iconSpeed', 2)
        setProperty("dad.colorTransform.redOffset", 0)
        setProperty("dad.colorTransform.greenOffset", 0)
        setProperty("dad.colorTransform.blueOffset", 0)

        flash(1, 5)
        cancelTween('red')
        setProperty('red.alpha', 0)

        doTweenAlpha('vignette', 'vignette', 0.3, 6)
        doTweenAlpha('chardark', 'chardark', 0, 6)

        for i = 1,4 do
            doTweenAlpha('light'..i,'light'..i, 0.3, 6)
        end
        if not lowQuality then
            setProperty('video.alpha', 0)
            runHaxeCode('video.pause();')
        end
        
        setProperty('hazzy.alpha', 1)
        setProperty('roy.alpha', 1)
        setProperty('feizao.alpha', 1)
        videoBGPlay = false
    end
    if curStep == 2560 then
        flash(1, 4)
    end

end

function onUpdate(elapsed)
    if not inGameOver then
        for i, v in pairs(camEvent) do
            if v.beat <= curDecBeat and not v.used then
                v.tween()
                v.used = true
            end
        end
        if isZoomTweening then
            zoom = getProperty('zoomTween.x')
        end
        if centerCam then
            setProperty('camFollow.x', 690)
            setProperty('camFollow.y', 350)
        end

        if shadersEnabled and tweeningRGBSplit then
            setShaderFloat("rgbSplitTween", "iOffset", getProperty('rgbSplitTween.x'))
        end
        if shadersEnabled and tweeningRadialBlur then
            setShaderFloat("radialBlurTween", "blurWidth", getProperty('radialBlurTween.x'))
        end
        
        setShaderFloat("space", "iTime", getSongPosition()/1000)
    end
end
function onUpdatePost(elapsed)
    if not inGameOver then
        if camZooming then
            zoomBeat = lerp(zoomBeat, 0, elapsed * 3)
            hudBeat = lerp(hudBeat, 0, elapsed * 3)
            setProperty('camGame.zoom', zoom + zoomBeat)
            setProperty('camHUD.zoom', 1 + hudBeat)
        end
        setProperty('camGame.angle', math.sin(getSongPosition()/1000) + getProperty('camAngle.x'))
        if videoBGPlay and not lowQuality then
            setProperty('video.bitmap.time', getSongPosition() - 144000)
        end
    end
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if not enableCamZooming then
        setProperty('camZooming', false)
    else
        camZooming = true
    end
end

function onTweenCompleted(tag)
    if tag == 'zoomTween' then
        isZoomTweening = false
    end
end

function onMoveCamera(name)
    local idint = name == 'dad' and 2 or 1
    setProperty('camFollow.x', camPos[idint][1])
    setProperty('camFollow.y', camPos[idint][2])
end

function setRGBSplit(intensity)
    if not shadersEnabled then return end
    tweeningRGBSplit = false
    cancelTween('rgbSplitTween')
    setProperty('rgbSplitTween.x', intensity/10)
    setShaderFloat("rgbSplitTween", "iOffset", intensity/10)
end
function tweenRGBSplit(intensity, duration, ease)
    if not shadersEnabled then return end
    tweeningRGBSplit = true
    cancelTween('rgbSplitTween')
    doTweenX('rgbSplitTween', 'rgbSplitTween', intensity/10, duration, ease)
end


function setRadialBlur(intensity)
    if not shadersEnabled then return end
    tweeningRadialBlur = false
    cancelTween('radialBlurTween')
    setProperty('radialBlurTween.x', intensity)
    setShaderFloat("radialBlurTween", "blurWidth", intensity)
end
function tweenRadialBlur(intensity, duration, ease)
    if not shadersEnabled then return end
    tweeningRadialBlur= true
    cancelTween('radialBlurTween')
    doTweenX('radialBlurTween', 'radialBlurTween', intensity, duration, ease)
end

function onTweenCompleted(tag)
    if tag == 'rgbSplitTween' then
        tweeningRGBSplit = false
    end
    if tag == 'radialBlurTween' then
        tweeningRadialBlur = false
    end
end

function onEvent(eventName, value1, value2)
    if eventName == 'Change Character' then
        if value1 == 'dad' then
            setProperty('dad.flipX', true)

            setProperty('dad.y', -210)
            setProperty('dad.x', 1150 - 200)
        end
    end
end

function readyVideo()
    if lowQuality then return; end
    runHaxeCode([[
        video = new FlxVideoSprite(0, 0);
        video.bitmap.onFormatSetup.add(function()
            {
                video.setGraphicSize(FlxG.width*2, FlxG.height*2);
                video.updateHitbox();
                video.screenCenter();
                video.y -= 50;
                video.x += 50;
                video.camera = game.camGame;
            });
        video.bitmap.onEndReached.add(function(){
            game.callOnLuas("videoEnded", ["cutsceneMod"]);
            video.destroy();
        });
        video.autoPause = false;
        video.load(Paths.video("ProtogenBG"));
        video.pause();

        game.add(video);

        setVar('video', video);
    ]])
    setObjectOrder("video", getObjectOrder("onecolor")-1)
    setProperty('video.bitmap.mute', true)
    setProperty('video.alpha', 0)
end

local particleID = 0
function createParticle(amount, multSpeed)
    for i = 0, amount do
        particleID = particleID + 1
        local tag = "particle"..particleID
        makeLuaSprite(tag, 'kaijuparadise/'.."particle", getRandomFloat(-400, 1570), getRandomFloat(-400, 800))
        setProperty(tag..'.color', getColorFromHex('FF0000'))
        setScrollFactor(tag, 0.75, 0.75)
        setProperty(tag..'.active', false)
        addLuaSprite(tag, true)
        local scale = getRandomFloat(1, 2)
        scaleObject(tag, scale, scale)
        setBlendMode(tag, "add")

        setProperty(tag..".alpha", 0.85)
        doTweenX(tag..'.x', tag, getProperty(tag..".x") + getRandomFloat(-300, 300), 2 * (multSpeed or 1), "quadOut")
        doTweenY(tag, tag, getProperty(tag..".y") + getRandomFloat(-300, 300), 2 * (multSpeed or 1), "quadOut")
        doTweenAlpha("partAlphaB"..particleID, tag, 0, 2 * (multSpeed or 1))
    end
end


function onTimerCompleted(tag, loops, loopsLeft)
    if string.find( tag,  "particle") then 
        removeLuaSprite(tag)
     end
end

function onDestroy()
    if not lowQuality then
        runHaxeCode('video.destroy();')
    end
end
local inPause = false
function onFocus()
    if videoBGPlay and not inPause then
        runHaxeCode('video.resume();')
    end
end
function onFocusLost()
    if videoBGPlay and not inPause then
        runHaxeCode('video.pause();')
    end
end
function onPause()
    inPause = true
    if videoBGPlay then
        runHaxeCode('video.pause();')
    end
end
function onResume()
    inPause = false
    if videoBGPlay then
        runHaxeCode('video.resume();')
    end
end


function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if not isSustainNote and getHealth() > 0.2 then
        addHealth(-0.015)
    end
end












--LIBARAY
function flash(alpha, duration)
    setProperty('white.alpha', alpha)
    doTweenAlpha("white", "white", 0, duration, "")
end
function scheduleZoom(beat, newZoom, duration, ease)
    table.insert(camEvent, {beat = beat, used = false, tween = function()
        tzoom(newZoom, duration, ease)
    end})
end
function scheduleSort()
    table.sort(camEvent, function (k1, k2) return k1.beat < k2.beat end )
end

function tzoom(newZoom, duration, ease)
    local duration = duration or 1
    if newZoom <= 0 then newZoom = getProperty('defaultCamZoom') end
    if duration <= 0 then
        zoom = newZoom
        setProperty('zoomTween.x', newZoom)
        isZoomTweening = false
        cancelTween('zoomTween')

        return
    end
    doTweenX('zoomTween', 'zoomTween', newZoom, duration, ease)
    isZoomTweening = true
end

function setcamZooming(value)
    enableCamZooming = value
    setProperty('camZooming', value)
    camZooming = value
end

function lerp(a, b, t)return a + (b - a) * t end