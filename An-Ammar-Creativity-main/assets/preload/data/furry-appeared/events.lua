local camEvent = {}

local enableCamZooming = true
local camZooming = false

local lightBeat = false
local centerCam = false
--New Cam System
local zoom = 1
local zoomBeat = 0
local hudBeat = 0

local isZoomTweening = false
-- debug 
local noDark = false
function onCreate()
    if HardMode then
        setProperty('useModchart', true)
    end
end
function onCreatePost()
    luaDebugMode = true

    makeLuaSprite('zoomTween', '', 1, -1000) setProperty('zoomTween.visible', false) setProperty('zoomTween.active', false) -- var tween
    if not noDark then
        setProperty("chardark.alpha", 0.75)
        setProperty("vignette.alpha", 1)
        setProperty("dad.colorTransform.redOffset", -255)
        setProperty("dad.colorTransform.greenOffset", -255)
        setProperty("dad.colorTransform.blueOffset", -255)

        setProperty("iconP2.colorTransform.redOffset", -255)
        setProperty("iconP2.colorTransform.greenOffset", -255)
        setProperty("iconP2.colorTransform.blueOffset", -255)

        setProperty('black.alpha', 1) 
        for i = 1,4 do
            setProperty('light'..i..'.alpha', 0)
        end
    end
    zoom = getProperty('defaultCamZoom') setProperty('zoomTween.x', zoom)
    zoomingEvent()

    setProperty('hazzy.y', 1300)
    setProperty('feizao.y', 1300)
    setProperty('roy.y', 1300)

    setProperty('fox.visible', false)

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
        setObjectOrder("strumLineNotes", getObjectOrder("dadGroup")-1)
        setObjectOrder("notes", getObjectOrder("dadGroup")-1)
        setObjectOrder("healthBar", getObjectOrder("light1")-1)
        setObjectOrder("healthBarBG", getObjectOrder("light1")-1)
        setObjectOrder("healthBarOverlay", getObjectOrder("light1")-1)
        setObjectOrder("iconP1", getObjectOrder("light1")-1)
        setObjectOrder("iconP2", getObjectOrder("light1")-1)
        for i = 0, 7 do
            setPropertyFromGroup('strumLineNotes', i, 'y', (downscroll and 550 or 0))
        end
    end

    makeLuaSprite('white', '', -500,-300)
	makeGraphic("white", 1280, 720, 'FFFFFF')
	scaleObject('white', 1.1, 1.1)
	screenCenter('white')
	setScrollFactor('white', 0, 0)
	setObjectCamera('white', 'hud')
	setProperty("white.alpha", 0)
	addLuaSprite('white')
    

    if not EasyMode and Mechanic then
        for i = 0, getProperty('unspawnNotes.length')-1 do --start 600
            setPropertyFromGroup("unspawnNotes", i, 'multAlpha', 0)
        end
    end

    if HardMode then
        modchart()
    end
end
function zoomingEvent()
    local sec = crochet/1000*4
    local bea = crochet/1000
    scheduleZoom(0, 1.2, 0, '')
    scheduleZoom(0, 0.9, sec*8, 'quadInOut')
    scheduleZoom(44, 0.95, bea, 'quadOut')
    scheduleZoom(45.5, 1.05, bea, 'quadOut')
    scheduleZoom(47, 0.9, bea, 'quadOut')
    scheduleZoom(60, 0.95, bea, 'quadOut')
    scheduleZoom(61.5, 1.05, bea, 'quadOut')
    scheduleZoom(63, 0.95, bea, 'quadOut')
    scheduleZoom(64, -1, sec+0.75, 'quadOut') -- show opponent
    scheduleZoom(72, 0.6+0.1, sec*2, 'sineInOut')
    scheduleZoom(80, -1, sec, 'quadOut')
    scheduleZoom(88, 0.6+0.1, sec*2, 'sineInOut')
    scheduleZoom(96, -1, sec, 'quadOut')
    scheduleZoom(104, 0.9, sec*2, 'expoIn')
    scheduleZoom(112, 0.6, sec+0.8, 'quadOut')
    scheduleZoom(120, 0.9, sec*2, 'expoIn')
    scheduleZoom(128, 0.7, sec+0.75, 'quadOut')
    scheduleZoom(152, 1, sec*2, 'expoIn')
    scheduleZoom(160, 0.5, sec+0.9, 'quadOut')
    scheduleZoom(192, 0.45, sec*8, 'sineInOut')
    scheduleZoom(224, 0.6, sec*1, 'quadOut')

    scheduleZoom(232, 0.6+0.1, sec*2, 'sineInOut')
    scheduleZoom(240, -1, sec, 'quadOut')
    scheduleZoom(248, 0.6+0.1, sec*2, 'sineInOut')
    scheduleZoom(256, -1, sec, 'quadOut')
    scheduleZoom(264, 0.9, sec*2, 'expoIn')
    scheduleZoom(272, 0.6, sec+0.8, 'quadOut')
    scheduleZoom(280, 0.9, sec*2, 'expoIn')
    scheduleZoom(288, 0.7, sec+0.75, 'quadOut')

    scheduleZoom(424, 0.6+0.1, sec*2, 'sineInOut')
    scheduleZoom(432, -1, sec, 'quadOut')
    scheduleZoom(440, 0.6+0.1, sec*2, 'sineInOut')
    scheduleZoom(448, -1, sec, 'quadOut')
    scheduleZoom(456, 0.9, sec*2, 'expoIn')
    scheduleZoom(464, 0.6, sec+0.8, 'quadOut')
    scheduleZoom(472, 0.9, sec*2, 'expoIn')
    scheduleZoom(480, 0.5, sec/2, 'quadOut')

   scheduleSort()
end

local lastStep = 0
function onStepHit()
    for i = lastStep+1, curStep do
        stepEvent(i)
    end
    if lightBeat and curStep % 8 == 0 then
        for i = 1,4 do
            setProperty('light'..i..'.alpha', 0.5)
            doTweenAlpha('light'..i,'light'..i, 0.3, crochet/1000)
        end
        zoomBeat = zoomBeat + 0.015
        hudBeat = hudBeat + 0.03
    end
    
    if (curStep >= 1408 and curStep < 1664) and curStep % 4 == 0 then
        zoomBeat = zoomBeat + 0.015
        hudBeat = hudBeat + 0.03
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

    if curStep == 1 then
        doTweenAlpha('black', 'black', 0, 12)
    end
    if curStep == 240 and not HardMode and not EasyMode then
        for i = 4, 7 do
            noteTweenX('noteX'..i, i, getPropertyFromGroup("strumLineNotes", i, 'x') - 150, 1, 'quadInOut')
        end
    end
    if curStep == 252 then
        playAnim('dad', 'cute', true)
        setProperty('dad.specialAnim', true)
        setProperty("dad.colorTransform.redOffset", 0)
        setProperty("dad.colorTransform.greenOffset", 0)
        setProperty("dad.colorTransform.blueOffset", 0)
        setProperty("iconP2.colorTransform.redOffset", 0)
        setProperty("iconP2.colorTransform.greenOffset", 0)
        setProperty("iconP2.colorTransform.blueOffset", 0)
    end
    if curStep == 256 then
        cancelTween('black') setProperty('black.alpha', 0)
        flash(1, 2)
        setProperty("chardark.alpha", 0)
        setProperty("vignette.alpha", 0.35)

        for i = 1,4 do
            setProperty('light'..i..'.alpha', 0.3)
        end
        lightBeat = true
    end
    if curStep == 320 and not HardMode and not EasyMode then
        for i = 4, 7 do
            noteTweenX('noteX'..i, i, getPropertyFromGroup("strumLineNotes", i, 'x') + 150, 1, 'quadInOut')
        end
    end
    if curStep == 512 or curStep == 896 or curStep == 1152 or curStep == 1920 then
        lightBeat = false
    end
    if curStep == 640 or curStep == 900 then
        lightBeat = true
    end
    if curStep == 656 then
        doTweenY('feizao', 'feizao', 550, 1, 'quadOut')
    end
    if curStep == 720 then
        doTweenY('hazzy', 'hazzy', 630, 1, 'quadOut')
    end
    if curStep == 792 then
        doTweenY('roy', 'roy', 550, 1, 'quadOut')
        setProperty('fox.visible', true)
    end
    if curStep == 896 then
        playAnim('dad', 'cute', true)
        setProperty('dad.specialAnim', true)
    end
    if curStep == 1276 or curStep == 1404 then
        playAnim('dad', 'cute', true)
        setProperty('dad.specialAnim', true)

        runHaxeCode("game.moveCamera(true);")
        setProperty('camFollowPos.x', getProperty('camFollow.x'))
        setProperty('camFollowPos.y', getProperty('camFollow.y'))
    end
    if curStep == 1408 then
        centerCam = true
    end
    if curStep == 1152 then
        flash(1, 3)
        setProperty("chardark.alpha", 0.2)
        setProperty("vignette.alpha", 0.35)
        doTweenAlpha('chardark', 'chardark', 0.75, crochet/1000*4*8)
        doTweenAlpha('vignette', 'vignette', 1, crochet/1000*4*8)

        for i = 1,4 do
            setProperty('light'..i..'.alpha', 0)
        end
    end
    if curStep == 1668 then
        cancelTween('chardark')
        cancelTween('vignette')
        flash(1, 3)
        setProperty("chardark.alpha", 0)
        setProperty("vignette.alpha", 0.35)

        for i = 1,4 do
            setProperty('light'..i..'.alpha', 0.3)
        end
        lightBeat = true
        centerCam = false
        runHaxeCode("game.moveCamera(true);")
    end
    if curStep == 1920 then
        centerCam = true
    end
    if curStep == 1924 then
        playAnim('dad', 'cute', true)
        setProperty('dad.specialAnim', true)
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
        setProperty('camGame.angle', math.sin(getSongPosition()/1000))
        if not EasyMode and Mechanic then
            for i = 0, getProperty('notes.length')-1 do --start 600
                local strumTime = getPropertyFromGroup("notes", i, 'strumTime')
                local distance = math.abs(strumTime - getSongPosition())
                local SUS = getPropertyFromGroup("notes", i, 'isSustainNote')
                setPropertyFromGroup("notes", i, 'multAlpha', math.min((600-distance)*0.01*0.4, 1) * (SUS and 0.6 or 1))
            end
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


local dad = 1
local bf = 0
function modchart()
    ease(60, 2, 'transformX', -100, 'linear', bf)
    ease(64, 8, 'transformX', 0, 'linear', bf)

    setValue('transformY-a', -50)

    if not Modchart then return end
    
    for beat = 0, (4*16)-1 do
        local time = 64 + beat
        if beat%2 == 0 then
            set(time, 'reverse', 0.1)
            ease(time, 1, 'reverse', 0, 'quadOut')
        end
    end

    setValue('wiggleFreq', 0.5)
    for beat = 0, (4*16)-1 do
        local time = 160 + beat
        if beat%2 == 0 then
            set(time, 'reverse', 0.1)
            ease(time, 1, 'reverse', 0, 'quadOut')
            if time >= 176 then
                set(time, 'wiggle', 5)
                ease(time, 1.5, 'wiggle', 0, 'quadOut')
            end
        end
    end

    for beat = 0, (4*16)-1 do
        local time = 224 + beat
        if beat%2 == 0 and time >= 225 then
            set(time, 'reverse', 0.1)
            ease(time, 1, 'reverse', 0, 'quadOut')
        end
    end

    for beat = 0, (4*16)-1 do
        local time = 352 + beat
        set(time, 'reverse', 0.05)
        ease(time, 1, 'reverse', 0, 'quadOut')
        set(time, 'invert', beat%2==0 and 0.3 or -0.3)
        ease(time, 1, 'invert', 0, 'quadOut')
    end

    for beat = 0, (4*16)-1 do
        local time = 416 + beat
        if beat%2 == 0 and time >= 417 then
            set(time, 'reverse', 0.1)
            ease(time, 1, 'reverse', 0, 'quadOut')
        end
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