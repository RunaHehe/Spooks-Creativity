zoom = 0.5
zoomLerp = 0.5
zoomBeat = 0
forcePos = true
forceZoom = true
centerCamera = false

maxFurry = 10
iconJump = false
defaultIconY = 0

local dialogue = {
    {24, 'f', 'he'},
    {26, 'f', 'hehe'},
    {28, 'f', 'hehehe'},
    {32, 'f', ''},

    {54, 'a', 'what???'},
    {64, 'a', ''},
    {72, 'a', 'It can\'t be'},
    {88, 'a', ''},

    {162, 'f', 'suprise!!'},
    {176, 'f', ''},

    {200, 'a', 'please'},
    {212, 'a', ''},
    {218, 'a', 'You\'re not suppose to be here'},
    {238, 'a', ''},

    {848, 'a', 'stop'},
    {858, 'a', ''},
    {864, 'a', 'go away'},
    {876, 'a', ''},

    {1040, 'f', 'I\'m you from the future'},
    {1064, 'f', ''},

    {1480, 'f', 'We\'re furry'},
    {1492, 'a', '...'},

    {1546, 'a', 'aa'}
}
function onCreate()
    setPropertyFromClass("ClientPrefs", "shaders", true)
    setProperty('skipCountdown', true)
end
function onDestroy()
    setPropertyFromClass("ClientPrefs", "shaders", shadersEnabled)
end
function onCreatePost()
    addHaxeLibrary("FlxBackdrop", 'flixel.addons.display')
    addHaxeLibrary("FlxAxes", 'flixel.util')
    luaDebugMode = true
    setProperty('camZooming', true)

    makeLuaSprite('speedscroll', '', 0)
    makeLuaSprite('pos')
    makeLuaSprite('zoom', '', 1)
    makeLuaSprite('charpos', '', 540, -700)

    
    createLight('glow3', 200, 180, 0.6, 0.6)
    createLight('glow2', -70, 0, 0.8, 1)
    createLight('glow1', -500, -250, 0.9, 1.6)
    createLight('glow0', -1100, -400, 1.25, 2.4)

    setObjectOrder('glow0', getObjectOrder('boyfriendGroup') + 2)

    makeLuaSprite('white', '', -600, -600)
    makeGraphic('white', 1280, 720, '00FF00')
    scaleObject('white', 5, 5)
    setScrollFactor('white', 0, 0)
    screenCenter('white')
    addLuaSprite('white')
    setProperty('white.alpha', 0)

    makeLuaSprite('fade', '', 0, 0)
    makeGraphic('fade', 1380, 820, '000000')
    addLuaSprite('fade')
    setProperty('fade.alpha', 0)
    setObjectCamera('fade', 'hud')
    screenCenter('fade')
    setObjectOrder('fade', 0)

    setObjectCamera("bottomGlow", 'hud')
    screenCenter("bottomGlow")

    precacheImage("notfemboy")
    precacheImage("femboy")
    precacheImage("furry")
    

    runHaxeCode([[
        for (i in 0...]]..tostring(maxFurry+1)..[[) {
            var notfurry = new FlxBackdrop(Paths.image("notfurry"), 0x01);
            notfurry.velocity.x = 200 * (i%2==0 ? -1 : 1);
            notfurry.y = -1000 + (i * 300);
            notfurry.color = 0xFF90FF90;
            game.add(notfurry);
            notfurry.alpha = 0;
            setVar('notfurry'+i, notfurry);
    }
    ]])
    for i = 0, maxFurry do
        setObjectOrder('notfurry'..i, getObjectOrder("dadGroup")-1)
    end

    makeLuaText('furryText', 'uwu', 400, getProperty('dad.x') + 30, - 15)
    setTextFont('furryText', 'Phantomuff/aPhantomMuff Full Letters.ttf')
    setTextSize("furryText", 40)
    setTextAlignment("furryText", 'center')
    setObjectCamera('furryText', 'camGame')
    runHaxeCode('game.getLuaObject(\'furryText\').scrollFactor.set(1, 1)')
    addLuaText('furryText')

    makeLuaText('ammarText', '', 400, getProperty('boyfriend.x') + (getProperty('boyfriend.width')/2), 15)
    setTextFont('ammarText', 'Phantomuff/aPhantomMuff Full Letters.ttf')
    setTextSize("ammarText", 40)
    setTextAlignment("ammarText", 'center')
    setObjectCamera('ammarText', 'camGame')
    runHaxeCode('game.getLuaObject(\'ammarText\').scrollFactor.set(1, 1)')
    addLuaText('ammarText')

    setProperty('dadGroup.y', getProperty('dadGroup.y')-100)
    setGlobalFromScript("stages/ammarvoid", "thisCameraSystem", false)

    setProperty('pos.x', 540)
    setProperty('pos.y', -700)
    setProperty('newHealthSystem', true)

    initLuaShader("scroll")
    makeLuaSprite("scrollShader")
    setSpriteShader("scrollShader", "scroll")
    setShaderFloat('scrollShader', "xSpeed", 10)
    setShaderFloat('scrollShader', "ySpeed", 0)
    setShaderFloat('scrollShader', "timeMulti", 0.1)
    setShaderFloat("scrollShader", "iTime", 0)

    for i = 0, 3 do
        setProperty('glow'..i..'.alpha', 0)
    end

    defaultIconY = getProperty('iconP2.y')

end
function createLight(tag, x, y, scroll, scale)

    makeLuaSprite(tag, 'light', x, y)
    scaleObject(tag, scale, scale)
    setScrollFactor(tag, scroll, scroll)
    addLuaSprite(tag)
    setProperty(tag..'.color', getColorFromHex("00FF00"))
end

function onSongStart()
    doTweenY('posy', 'pos', 400, crochet/1000*8, 'quadOut')
    doTweenX('zoom', 'zoom', 0.5, crochet/1000*8, 'quadOut')
end

local switch = false
function onStepHit()
    while dialogue ~= nil and #dialogue > 0 and dialogue[1][1] <= curStep do
        setTextString(dialogue[1][2] == 'a' and 'ammarText' or 'furryText', dialogue[1][3])
        table.remove(dialogue, 1)
    end

    if iconJump then
        if curStep % 4 == 0 then
            doTweenY('iconJump', 'iconP2', defaultIconY - 30, crochet/1000/2, 'quadOut')
        elseif curStep % 4 == 2 then
            doTweenY('iconJump', 'iconP2', defaultIconY, crochet/1000/2, 'quadIn')
        end
    end


    if curStep >= 176 and curStep < 304 then
        if (curStep >= 232 and curStep < 239) or (curStep >= 296 and curStep < 304) then
            local daOff = curStep % 8
            if daOff % 3 == 0 then
                doTweenX('zoom', 'zoom', 0.5, crochet/1000/3*2, 'quadOut')
                setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.05)
            elseif daOff % 3 == 2 then
                doTweenX('zoom', 'zoom', 0.7, crochet/1000/3, 'expoIn')
            end
        else
            if curStep % 4 == 0 then
                doTweenX('zoom', 'zoom', 0.5, crochet/1000*0.75, 'quadOut')
                setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.1)
            elseif curStep % 4 == 3 then
                doTweenX('zoom', 'zoom', 0.6, crochet/1000*0.25, 'quadIn')
            end
        end
        if curStep % 4 == 0 then
            for i = 0, 3 do
                if (i % 2 == 0 and curStep % 8 == 0) or (i % 2 == 1 and curStep % 8 == 4) then
                    setProperty('glow'..i..'.alpha', 1)
                    doTweenAlpha('glowalpha'..i, 'glow'..i, 0, 0.4, 'quadIn')
                end
            end
            bottomGlow(0.4, 0.5)
            middleGlow(0.5, 0.5)
        end
    end
    if curStep >= 560 and curStep < 688 then
        if curStep % 8 == 0 then
            for i = 0, 3 do
                if (i % 2 == 0 and curStep % 16 == 0) or (i % 2 == 1 and curStep % 16 == 8) then
                    setProperty('glow'..i..'.color', getColorFromHex('00FF00'))
                else
                    setProperty('glow'..i..'.color', getColorFromHex('ee00ff'))
                end
            end
        end
    end
    if (curStep >= 432 and curStep < 560) or (curStep >= 688 and curStep < 816) or (curStep >= 1088 and curStep <= 1208) or (curStep >= 1216 and curStep < 1472) then
        if curStep % 8 == 0 or curStep % 8 == 3 or curStep % 8 == 6 then
            switch = switch == false
            setProperty('camGame.angle', switch and -5 or 5)
            zoomBeat = zoomBeat + 0.07
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.04)

            for i = 0, maxFurry do
                local tag = 'notfurry'..i
                setProperty(tag..'.velocity.x', 1400 * (i%2==0 and -1 or 1))
                setProperty(tag..'.alpha', 0.8)
                doTweenX(tag, tag..'.velocity', 250 * (i%2==0 and -1 or 1), crochet/1000*0.7, 'expoOut')
                doTweenAlpha(tag..'alpha', tag, 0.4, crochet/1000*0.7, 'quadOut')
            end
            if curStep >= 1216 then
                bottomGlow(0.6, 0.5)
            end
        end
    end
    if  (curStep >= 832 and curStep < 1088) then
        if (curStep >= 888 and curStep < 896) or (curStep >= 952 and curStep < 960) or (curStep >= 1016 and curStep < 1024) then
            local daOff = curStep % 8
            if daOff % 3 == 0 then
                zoomBeat = zoomBeat + 0.07
                setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.04)
            end
        elseif (curStep % 4 == 0) then
            zoomBeat = zoomBeat + 0.07
            setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.04)
        end
        if curStep % 4 == 0 then
            for i = 0, 3 do
                if (i % 2 == 0 and curStep % 8 == 0) or (i % 2 == 1 and curStep % 8 == 4) then
                    setProperty('glow'..i..'.alpha', 1)
                    doTweenAlpha('glowalpha'..i, 'glow'..i, 0, 0.4, 'quadIn')
                end
            end
            bottomGlow(0.5, 0.5)
        end
    end
    if curStep % 4 == 0 and (curStep >= 960 and curStep < 1088) then
        for i = 0, maxFurry do
            local tag = 'notfurry'..i
            setProperty(tag..'.velocity.x', 1400 * (i%2==0 and -1 or 1))
            doTweenX(tag, tag..'.velocity', 250 * (i%2==0 and -1 or 1), crochet/1000*0.7, 'expoOut')
        end
    end
end
function onStepEvent(curStep)
    if curStep+1 == 176 or curStep+1 == 432 or curStep+1 == 688 or curStep+1 == 960 then
        iconJump = true
    end
    if curStep+1 == 304 or curStep+1 == 560 or curStep+1 == 816 or curStep+1 == 1088 then
        iconJump = false
    end
    if curStep == 304 then
        setProperty('fade.alpha', 1)
        doTweenAlpha('fade', 'fade', 0, 12, 'sineIn')
        setProperty('white.alpha', 1)
        setProperty('dad.color', getColorFromHex('0xFF000000'))
        setProperty('boyfriend.color', getColorFromHex('0xFF000000'))
        setProperty('dadPhantom.color', getColorFromHex('0xFF000000'))
        setProperty('bfPhantom.color', getColorFromHex('0xFF000000'))
        setProperty('dadPhantom.alpha', 0.2)
        setProperty('bfPhantom.alpha', 0.2)
        setProperty('iconSpeed', 8)
        setProperty('iconP2.angle', 360*2)
        doTweenAngle('iconP2A', 'iconP2', 0, crochet/1000*2*16)
    end
    if curStep == 432 then
        cancelTween('fade') setProperty('fade.alpha', 0)
        cameraFlash('camGame', 'FFFFFF', 1, true)
        setProperty('white.alpha', 0)
        cameraFlash('hud', 'FFFFFF', 0.5, true)
        setProperty('dad.color', getColorFromHex('0xFFFFFFFF'))
        setProperty('boyfriend.color', getColorFromHex('0xFFFFFFFF'))
        setProperty('dadPhantom.color', getColorFromHex('0xFFFFFFFF'))
        setProperty('bfPhantom.color', getColorFromHex('0xFFFFFFFF'))
        setProperty('dadPhantom.alpha', 0.2)
        setProperty('bfPhantom.alpha', 0.2)
        setProperty('iconSpeed', 1)
    end
    if curStep == 560 then
        setProperty('camGame.angle', 0)
        for i = 0, maxFurry do
            local tag = 'notfurry'..i
            doTweenAlpha(tag..'alpha', tag, 0, crochet/1000*0.7, 'quadOut')
        end
        for i = 0, 3 do
            doTweenAlpha('glowalpha'..i, 'glow'..i, 1, 2)
        end
    end
    if curStep == 688 then
        for i = 0, maxFurry do
            local tag = 'notfurry'..i
            loadGraphic(tag, "notfemboy")
        end
        for i = 0, 3 do
            setProperty('glow'..i..'.color', getColorFromHex('00FF00'))
            doTweenAlpha('glowalpha'..i, 'glow'..i, 0, 0.5)
        end
    end
    if curStep == 816 then
        for i = 0, maxFurry do
            local tag = 'notfurry'..i
            doTweenAlpha(tag..'alpha', tag, 0, 1, 'quadOut')
        end
        setProperty('camGame.angle', 0)
        setProperty('iconSpeed', 4)
    end
    if curStep == 824 or curStep == 827 or curStep == 830 then
        setHealth(getHealth()*0.75)
    end
    if curStep == 832 then
        for i = 0, maxFurry do
            local tag = 'notfurry'..i
            if i%2==0 then
                loadGraphic(tag, "furry")
            else 
                loadGraphic(tag, "femboy")
            end
            doTweenAlpha(tag..'alpha', tag, 0.15, 2)
        end
        setProperty('iconSpeed', 1)
    end
    if curStep == 1088 then
        doTweenX('speed', 'speedscroll', 1.5, 1, 'quadIn')
        if not EasyMode then
            runHaxeCode([[
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("scrollShader").shader)]);
            ]])
        end
    end
    if curStep == 1216 then
        doTweenX('speed', 'speedscroll', -1.5, 2, 'linear')
    end
    if curStep == 1472 then
        setProperty('speed.x', 0)
        doTweenX('speed', 'speedscroll', -5, 2, 'expoIn')
        for i = 0, maxFurry do
            local tag = 'notfurry'..i
            setProperty(tag..'.alpha', 1)
            doTweenAlpha(tag..'alpha', tag, 0, 2)
        end
        runHaxeCode([[
            game.camHUD.setFilters([]);
        ]])
    end
    camEvent(curStep)
end
function camEvent(curStep)
    if curStep == 32 then
        forcePos = false
        forceZoom = false
    end
    if curStep == 160 then
        forcePos = true
        forceZoom = true
        doTweenX('posx', 'pos', 40, crochet/1000*4, 'quadInOut')
        doTweenY('posy', 'pos', 250, crochet/1000*4, 'quadInOut')
        doTweenX('zoom', 'zoom', 1.2, crochet/1000*4, 'quadInOut')
    end
    if curStep == 176 then
        forcePos = false
        --forceZoom = false
    end
    if curStep == 304 then
        forcePos = true
        setProperty('pos.x', 560)
        setProperty('zoom.x', 0.3)
        doTweenX('zoom', 'zoom', 0.55, crochet/1000*4*8, 'sineInOut')
    end
    if curStep == 432 then
        forcePos = false
        forceZoom = false
    end
    if curStep == 560 then
        forceZoom = true
        setProperty('zoom.x', 0.5)
        doTweenX('zoom', 'zoom', 0.6, crochet/1000*4*8, 'sineInOut')
    end
    if curStep == 688 then
        forceZoom = false
    end
    if curStep == 960 then zoom = 0.6 end
    if curStep == 976 then zoom = 0.65 end
    if curStep == 992 then zoom = 0.5 end
    if curStep == 1024 then zoom = 0.6 end
    if curStep == 1056 then zoom = 0.65 end
    if curStep == 1088 then zoom = 0.5 end
    if curStep == 1472 then
        centerCamera = true
        forceZoom = true
        setProperty('zoom.x', 0.5)
        doTweenX('zoom', 'zoom', 0.35, crochet/1000*4*2, 'circOut')
        setProperty('camGame.angle')
    end
end

local totalMovement = 0
function onUpdate(elapsed)
    if curStep >= 160 and curStep < 176 then
        if getHealth() >= 0.5 then
            addHealth(elapsed*-0.3)
        end
    end
    if curStep >= 1088 then
        totalMovement = totalMovement + (elapsed*120*(getProperty('speedscroll.x')))
        local time = (totalMovement) % 600
        for i = 0, maxFurry do
            ---1000 + (i * 300)
            local tag = 'notfurry'..i
            setProperty(tag..'.y', -1000 + (i * 300) + time)
        end
    end
    if curStep >= 1088 and curStep < 1472 and Mechanic and not EasyMode then
        setShaderFloat("scrollShader", "iTime", (curDecBeat/8))
    end
end
function onSectionHit() zoomBeat = zoomBeat + 0.03 end
function onUpdatePost(elapsed)
    if not inGameOver then
        zoomBeat = lerp(zoomBeat, 0, elapsed * 3.125)
        if not forceZoom then
            zoomLerp = lerp(zoomLerp, zoom, elapsed*5)
            setProperty('camGame.zoom', zoomLerp + zoomBeat)
        else 
            setProperty('camGame.zoom', getProperty('zoom.x') + (zoomBeat*0.5))
            zoomLerp = getProperty('camGame.zoom')
        end

        if centerCamera then
            setProperty('charpos.x', 555)
            setProperty('charpos.y', 400)
        end

        if not forcePos then
            setProperty('pos.x', lerp(getProperty('pos.x'), getProperty('charpos.x'), elapsed * 3))
            setProperty('pos.y', lerp(getProperty('pos.y'), getProperty('charpos.y'), elapsed * 3))
        end

        setProperty('camFollowPos.x', getProperty('pos.x'))
        setProperty('camFollowPos.y', getProperty('pos.y'))
    end
end
function onMoveCamera(char)
    if char == 'dad' then
        setProperty('charpos.x', 200)
        setProperty('charpos.y', 400)
    else
        setProperty('charpos.x', 700)
        setProperty('charpos.y', 400)
    end
end 


local healthMultiply = 2
function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if not isSustainNote and getHealth() >= 0.5 then
        addHealth(-0.02 * healthLossMult * healthMultiply)
    end
end


function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if not isSustainNote then
        addHealth(0.023 * healthGainMult * (healthMultiply - 1))
    end
end

function onGhostTap(key)
    local nearKey = false
    for i = 0, getProperty('notes.length')-1 do
        if getPropertyFromGroup('notes', i, 'mustPress') and not getPropertyFromGroup('notes', i, 'ignoreNote') and (getPropertyFromGroup('notes', i, 'strumTime') - getSongPosition()) <= 400 then
            nearKey = true
            break
        end
    end
    if nearKey then
        addHealth(-0.05 * healthLossMult)
        addMisses(1)
    end
end

function middleGlow(alpha, duration)
    setProperty('middleGlow.alpha', alpha)
    doTweenAlpha('middleGlow', 'middleGlow', 0.05, duration)
end

function bottomGlow(alpha, duration)
    setProperty('bottomGlow.alpha', alpha)
    doTweenAlpha('bottomGlow', 'bottomGlow', 0, duration)
end


function lerp(a, b, t)
	return a + (b - a) * t
end