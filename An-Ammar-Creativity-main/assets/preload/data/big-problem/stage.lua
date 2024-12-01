local folder = 'mistake/'
local gFolder = "google/"
local shaderUpdate = {}

local videoX = {}

local TWMessageBar = {}
local TWMessageBarB = {}
local TWMaxX = 0
local TWMinX = 0
local TWSMaxX = 0
local TWSMinX = 0
local TWMessageSwing = false
local TWMessageSpeed = 6
local TWMessageActive = false
local TWOffsetY = 0

local particleAmount = 0
local particles = {}
local particleColor = 'FF0000'

local targetYCam = 591.5
local targetXCam = {0, 850}
local centerCamera = false

BGGlowBeat = 0
beatOnBeat = false

opponentDamage = false
opponentShake = true
screamMode = false

local shaker = 0
local shakeAdd = 0
local shakeVideoAdd = 0
local shakeDes = 0
local shakerTime = 10

local videosBeatTotal = 0
local videosBeatAdd = 0
local videoBeat = false

local screenSpin = false

local tweenGlitch = false

local halfVideoDes = false
local videoShaderUpdate = true

--vocals -------------
lastStrumTime = {-999, -999}
vocals = {
    {{{"Ee"}, "e", {''}}, {{"Oo"}, "o", {''}}, {{"Aa"}, "a", {""}}, {{"O"}, "o", {"h"}}}, -- dad, eee, ooo ,aaa ,e
    {{{"ee"}, "e", {''}}, {{"oo"}, "o", {''}}, {{"aa"}, "a", {"h"}}, {{"e"}, "e", {"h"}}} -- player, eee, ooo ,aaa ,e
}

dadNumVocal = 1
bfNumVocal = 1
local dadSingTimer = 0
--------------------------------------
--GOOGLE --------------
local googleSingOppo = false
local googleTimer = 0

local colorsGoogle = {
    "008744", "0057E7", "D62D20", "FFA700",
    "00cf68", "2b7bff", "ed4a3e", "ffc24f" -- flash
 }

----------
local viewMode = false

vocalsNotes = {bf = {}, dad = {}}

--TODO:


backupShader = false
local defaultSpeed = 1
function onDestroy()
    setPropertyFromClass('ClientPrefs', 'shaders', backupShader)
    runHaxeCode([[
        FlxG.signals.gameResized.remove(fixShaderCoordFix);
    ]])
end
function onCreate()
    luaDebugMode = true
    shaderCoordFix()

    package.path = getProperty("modulePath") .. ";" .. package.path
    SpriteUtil = require("SpriteUtil")
    precacheSound("destruction")
    shadersEnabled = getPropertyFromClass('ClientPrefs', 'shaders')
    backupShader = getPropertyFromClass('ClientPrefs', 'shaders')
    setPropertyFromClass('ClientPrefs', 'shaders', true)

    initLuaShader("mirrorwarp") --MUST
    initLuaShader("scroll")
    makeLuaSprite('TWOffset', '', 0, -400)
    if shadersEnabled then
        initLuaShader("dropShadow")
        initLuaShader("GlitchShader")
        initLuaShader("lensDis")
        initLuaShader("radialBlur")
        initLuaShader("RGB_PIN_SPLIT")


        makeLuaSprite('GlitchShader', '', 0.0001, -400); setSpriteShader("GlitchShader", "GlitchShader")
        makeLuaSprite("lensEffect", "", 0, -400) setSpriteShader("lensEffect", "lensDis")
        makeLuaSprite("radialBlurEffect", "", 0, -400) setSpriteShader("radialBlurEffect", "radialBlur")
        makeLuaSprite("chrEffect", "", 0, -400) setSpriteShader("chrEffect", "RGB_PIN_SPLIT")

        setShaderFloat("lensEffect", "intensity", 0)
        setShaderFloat("GlitchShader", "GlitchAmount", 0.0001)

        setShaderFloat("radialBlurEffect", "cx", 0.5)
        setShaderFloat("radialBlurEffect", "cy", 0.5)
        setShaderFloat("radialBlurEffect", "blurWidth", 0)

        setShaderFloat("chrEffect", "amount", 0)
        setShaderFloat("chrEffect", "distortionFactor", 0.05)

        runHaxeCode([[
            game.camGame.setFilters([new ShaderFilter(game.getLuaObject("GlitchShader").shader), new ShaderFilter(game.getLuaObject("lensEffect").shader), new ShaderFilter(game.getLuaObject("radialBlurEffect").shader), new ShaderFilter(game.getLuaObject("chrEffect").shader)]);
            game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("GlitchShader").shader), new ShaderFilter(game.getLuaObject("chrEffect").shader)]);
        ]])
    end

    makeLuaSprite('btsBG', '', -100, -150)
    makeGraphic("btsBG", 1300, 900, '000000')
    setScrollFactor("btsBG", 0.1, 0.0)
    scaleObject("btsBG", 1.3, 1.5)
    screenCenter("btsBG")
    addLuaSprite("btsBG")
    setSpriteShader("btsBG", "mirrorwarp")
    setProperty('btsBG.visible', false)

    makeLuaSprite('bg', folder..'youtube/bg', -500, -350)
    scaleObject("bg", 1.3, 0.8)
    setScrollFactor("bg", 0, 0)
    addLuaSprite("bg")


    makeLuaSprite('yt', folder..'youtube/YT', 440, 200)
    scaleObject('yt', 0.75, 0.75)
    setScrollFactor("yt", 0.1, 0.1)
    addLuaSprite("yt")
    setProperty('yt.color', getColorFromHex("606060"))

    makeLuaSprite('tw', folder..'twitter/TW', 430, 160)
    scaleObject('tw', 0.75, 0.75)
    setScrollFactor("tw", 0.1, 0.1)
    addLuaSprite("tw")
    setProperty('tw.color', getColorFromHex("606060"))
    setProperty('tw.alpha', 0)

    createVideos('lvideo3', 200, 0, 0.098, 0.098, 0.4) setProperty('lvideo3.colorTransform.alphaMultiplier', 0.15)  setShaderFloat('lvideo3', "ySpeed", 0.15)
    createVideos('rvideo3', 920, 0, 0.098, 0.098, 0.4) setProperty('rvideo3.colorTransform.alphaMultiplier', 0.15) setShaderFloat('rvideo3', "ySpeed", 0.15)

    for i = 1, 9 do
        local tag = 'messageb'..i
        createTWPop(tag, -900 + (i * 250), 375, 0.105, true)
        setProperty(tag..'.color', getColorFromHex("A0A0A0"))
        setProperty(tag..'.active', false)
        table.insert(TWMessageBarB, {tag, 0, getProperty(tag..'.x'), getProperty(tag..'.y')})
        if i == 1 then TWSMinX = getProperty(tag..'.x') end
        TWSMaxX = getProperty(tag..'.x')
        setProperty(tag..'.alpha', 0)
    end
    
    createVideos('lvideo2', 110, -20, 0.1562, 0.1562, 0.55) setProperty('lvideo2.colorTransform.alphaMultiplier', 0.3) setShaderFloat('lvideo2', "ySpeed", 0.3)
    createVideos('rvideo2', 940, -20, 0.1562, 0.1562, 0.55) setProperty('rvideo2.colorTransform.alphaMultiplier', 0.3) setShaderFloat('rvideo2', "ySpeed", 0.3)

    setProperty('lvideo2.x' ,getProperty('lvideo2.x') - 700)  setProperty('rvideo2.x' ,getProperty('rvideo2.x') + 700)
    setProperty('lvideo3.x' ,getProperty('lvideo3.x') - 700)  setProperty('rvideo3.x' ,getProperty('rvideo3.x') + 700)


    makeLuaSprite('particle0', '', 0, -400)
    addLuaSprite("particle0")

    for i = 1, 7 do
        local tag = 'message'..i
        createTWPop(tag, -1000 + (i * 400), 350, 0.2, false)
        setProperty(tag..'.color', getColorFromHex("D0D0D0"))
        setProperty(tag..'.active', false)
        table.insert(TWMessageBar, {tag, 0, getProperty(tag..'.x'), getProperty(tag..'.y')})
        if i == 1 then TWMinX = getProperty(tag..'.x') end
        TWMaxX = getProperty(tag..'.x')
        setProperty(tag..'.alpha', 0)
    end

    createVideos('lvideo1', -20, -10, 0.25, 0.25, 0.7) setProperty('lvideo1.colorTransform.alphaMultiplier', 0.6) setShaderFloat('lvideo1', "ySpeed", 0.4)
    createVideos('rvideo1', 970, -10, 0.25, 0.25, 0.7) setProperty('rvideo1.colorTransform.alphaMultiplier', 0.6) setShaderFloat('rvideo1', "ySpeed", 0.4)

    --scroll divide 1.6
    createVideos('lvideo0', -200, 0, 0.4, 0.4, 0.85) 
    createVideos('rvideo0', 1030, 0, 0.4, 0.4, 0.85)

    makeLuaSprite('googleBG', '', -100, -150)
    makeGraphic("googleBG", 1300, 900, 'FFFFFF')
    setScrollFactor("googleBG", 0.0, 0.0)
    scaleObject("googleBG", 1.3, 1.5)
    addLuaSprite("googleBG")
    setProperty('googleBG.visible', false)

    makeLuaSprite('blackBehindGoogle', '', -100, -150)
    makeGraphic("blackBehindGoogle", 1300, 900, '000000')
    setScrollFactor("blackBehindGoogle", 0.0, 0.0)
    scaleObject("blackBehindGoogle", 1.3, 1.5)
    addLuaSprite("blackBehindGoogle")
    setProperty('blackBehindGoogle.visible', false)

    makeLuaSprite('googleBox', gFolder..'GoogleBoxW', 175, 420)
    scaleObject("googleBox", 0.5, 0.5)
    setScrollFactor("googleBox", 0.1, 0.1)
    addLuaSprite("googleBox")
    setProperty("googleBox.visible", false)

    SpriteUtil.makeText({
        tag = "googleChat" , text = "(listening...)", font = "Google/Product Sans Regular.ttf",
        align = "left", borderColor = "0x00000000", size = 16, borderSize = 0, borderQuality = 0, color = "000000",
        x = getProperty("googleBox.x") + 30 , y= getProperty("googleBox.y") + 46, width = 800
     })
    runHaxeCode([[
        var te = game.getLuaObject('googleChat', true);
        te.camera = game.camGame;
        te.scrollFactor.set(0.1, 0.1);
    ]])
    setProperty("googleChat.visible", false)
    setObjectOrder('googleChat', getObjectOrder('googleBox') + 1)

    SpriteUtil.makeSprite({tag="deathPCBG", graphicColor = "FFFFFF", graphicWidth = 1280 * 0.9, graphicHeight = 720 * 0.85})
    screenCenter("deathPCBG")
    setProperty("deathPCBG.color", getColorFromHex("0063BB"))
    setScrollFactor("deathPCBG", 0.1, 0.1)
    setProperty('deathPCBG.x', getProperty('deathPCBG.x')-20)

    SpriteUtil.makeText({
        tag = "deadText" , text = "Shutting Down",
        align = "center", borderColor = "0x00000000", size = 20, borderSize = 0, borderQuality = 0, color = "FFFFFFF",
        x = 560 , y= 350, width = -1, font = "SegoeUIVF.ttf"
    })
    runHaxeCode([[
        var te = game.getLuaObject('deadText', true);
        te.camera = game.camGame;
        te.scrollFactor.set(0.1, 0.1);
    ]])

    SpriteUtil.makeSprite({tag="deathPC", image = "computer", x = -20})
    setScrollFactor("deathPC", 0.1, 0.1)

    setProperty('deathPCBG.visible', false)
    setProperty('deadText.visible', false)
    setProperty('deathPC.visible', false)

    makeLuaSprite('botGlow', folder..'bottomGlow', -500, 100)
    scaleObject('botGlow', 2, 1.4)
    setScrollFactor("botGlow", 0.1, 0.1)
    addLuaSprite("botGlow")
    setProperty('botGlow.color', getColorFromHex("FF0000"))
    setProperty('botGlow.alpha', 0)

    makeLuaSprite('ground', folder..'youtube/ground', -300, 700)
    setProperty('ground.color', getColorFromHex("A0A0A0"))
    setScrollFactor("ground", 0.1, 0.1)
    scaleObject('ground', 1, 2)
    addLuaSprite("ground")

    makeLuaSprite('redbg', '', -100, -300)
    makeGraphic("redbg", 1500, 1200, "ff0000")
    setScrollFactor("redbg", 0, 0)
    addLuaSprite("redbg")
    setProperty('redbg.alpha', 0)
    setObjectCamera('redbg', 'other')
    setBlendMode("redbg", 'multiply')

    makeLuaSprite('dark', 'vignette', 0, 0)
    setObjectCamera('dark', 'other')
    screenCenter('dark')
    addLuaSprite("dark")
    setBlendMode("dark", 'overlay')

    makeLuaSprite('black', '', 0, 0)
    makeGraphic("black", 1300, 900, '000000')
    setObjectCamera('black', 'hud')
    if viewMode then
        setObjectCamera('black', 'other')
    end
    screenCenter('black')
    addLuaSprite("black")
    setProperty('black.alpha', 1)

    makeLuaSprite('shock', 'mistake/shock', 0, 0)
    setObjectCamera('shock', 'other')
    screenCenter('shock')
    addLuaSprite("shock")
    --setBlendMode("shock", 'add')
    setProperty('shock.color', getColorFromHex("FF0000"))
    setProperty('shock.alpha', 0)

    makeLuaSprite('light', '', 0, 0)
    makeGraphic("light", 1300, 900, 'FFFFFF')
    setObjectCamera('light', 'other')
    screenCenter('light')
    addLuaSprite("light")
    setProperty('light.alpha', 0)

    for i = 1, 4 do
        precacheImage(folder.."cutscene"..tostring(i))
    end
    makeLuaSprite('cutscene', folder..'cutscene1', 0, 0)
    screenCenter("cutscene")
    setObjectCamera('cutscene', 'hud')
    addLuaSprite("cutscene")
    setProperty('cutscene.alpha', 0)

    --centerCamera = true

    if CuteMode then
        setProperty("boyfriend.healthIcon", "ammar"..(CuteMode and 'cute' or ''))
        runHaxeCode([[
            game.iconP1.changeIcon("icon-ammar]]..(CuteMode and 'cute' or '')..[[");
        ]])
    end
end

function onCreatePost()
    defaultSpeed = getProperty('songSpeed')
    setProperty('gf.visible', false)

    addHaxeLibrary("Character")
    addHaxeLibrary("FlxColor", 'flixel.util')
    runHaxeCode([[
        TW = new Character(0, 0, 'TW');
        game.startCharacterPos(TW, true);
        game.startCharacterLua(TW.curCharacter);
        TW.danceIdle = true;


        game.add(TW);
        TW.scrollFactor.set(0.3, 0.05);
        TW.scale.set(1.4, 1.4); TW.updateHitbox();

        setVar("TW", TW);

        TW.x += 280;
        TW.y += 80;
    ]])

    setProperty('TW.alpha', 0)
    setProperty('TW.x', getProperty('TW.x') - 200)
    setScrollFactor("dadGroup", 0.3, 0.05)
    setScrollFactor("boyfriendGroup", 0.3, 0.05)

    scaleObject('dadGroup', 1.4, 1.4)
    scaleObject('boyfriendGroup', 1.4, 1.4)

    --Shader
    if shadersEnabled then
        setSpriteShader("dad", "dropShadow")
        setShaderFloat("dad", "_alpha", 0.8)
        setShaderFloat("dad", "_disx", -10)
        setShaderFloat("dad", "_disy", 15)
        setShaderBool("dad", "inner", true)
        setShaderBool("dad", "inverted", true)

        setSpriteShader("TW", "dropShadow")
        setShaderFloat("TW", "_alpha", 0.8)
        setShaderFloat("TW", "_disx", -10)
        setShaderFloat("TW", "_disy", 15)
        setShaderBool("TW", "inner", true)
        setShaderBool("TW", "inverted", true)

        setSpriteShader("boyfriend", "dropShadow")
        setShaderFloat("boyfriend", "_alpha", 0.8)
        setShaderFloat("boyfriend", "_disx", 10)
        setShaderFloat("boyfriend", "_disy", 15)
        setShaderBool("boyfriend", "inner", true)
        setShaderBool("boyfriend", "inverted", true)
    end

    setProperty('dadGroup.y', getProperty('dadGroup.y') - 80)
    setProperty('boyfriendGroup.y', getProperty('boyfriendGroup.y') - 250)

    --HUD IN GAME NO WAY
    local hpStuff = {'healthBar', 'healthBarBG', 'healthBarOverlay', 'iconP1', 'iconP2'}
    for i, v in pairs(hpStuff) do
        setObjectCamera(v, 'camGame')
        setScrollFactor(v, 0.1, 0.1)
        setProperty(v..'.y', getProperty(v..'.y') - 50)
        setProperty(v..'.x', getProperty(v..'.x') - 20)
        setProperty(v..'.color', getColorFromHex("A0A0A0"))
        
        setObjectOrder(v, getObjectOrder("ground")-5)
    end

    if viewMode then
        setProperty("camHUD.visible", false)
    end

    if not SpecialNotes then
        for i = getProperty('unspawnNotes.length')-1, 0, -1  do
            if getPropertyFromGroup("unspawnNotes", i, "noteType") == "Hurt Note" and getPropertyFromGroup("unspawnNotes", i, "mustPress") then
                removeFromGroup("unspawnNotes", i)
            end

        end
    end

    for i = 0, getProperty('unspawnNotes.length')-1 do
        if getPropertyFromGroup('unspawnNotes', i,'noteType') == '_GoogleSing' then
            setPropertyFromGroup('unspawnNotes', i,'noAnimation', true)
            if SpecialNotes then
                if HardMode then
                    setPropertyFromGroup('unspawnNotes', i,'multSpeed', 0.8)
                end
                setPropertyFromGroup('unspawnNotes', i,'colorTransform.redMultiplier', 3)
                setPropertyFromGroup('unspawnNotes', i,'colorTransform.greenMultiplier', 3)
                setPropertyFromGroup('unspawnNotes', i,'colorTransform.blueMultiplier', 3)
            end
        end
        if getPropertyFromGroup('unspawnNotes', i,'noteType') == '_ModSing' then
            setPropertyFromGroup('unspawnNotes', i,'colorTransform.blueOffset', 10)
        end
        if getPropertyFromGroup('unspawnNotes', i,'noteType') == '_TwitterSing' then
            setPropertyFromGroup('unspawnNotes', i,'colorTransform.blueOffset', 10)
            setPropertyFromGroup('unspawnNotes', i,'colorTransform.redOffset', 10)
        end
    end

    setProperty('healthBarBG.y', 720 * 0.89 + 30-80)
    setProperty('healthBar.y', getProperty("healthBarBG.y")+4)

    setProperty('iconP1.y', getProperty("healthBar.y")-95)
    setProperty('iconP2.y', getProperty("healthBar.y")-95)

end

function createVideos(tag,x,y,scrollx,scrolly,scale)
    makeLuaSprite(tag, folder..'youtube/videos', x, y)
    setProperty(tag..'.antialiasing', false)
    scaleObject(tag, scale or 1, scale or 1)
    setScrollFactor(tag, scrollx, scrolly)
    addLuaSprite(tag)
    setSpriteShader(tag, "scroll")
    setShaderFloat(tag, "xSpeed", 0.0)
    setShaderFloat(tag, "ySpeed", 0.6)
    setShaderFloat(tag, "timeMulti", 0.2)
    videoX[tag] = getProperty(tag..'.x')
    table.insert(shaderUpdate, tag)
end

function createTWPop(tag, x, y, scale, long)
    makeLuaSprite(tag, folder..'twitter/'..(long and 'Long' or '')..'Message', x, y)
    setProperty(tag..'.antialiasing', false)
    scaleObject(tag, (scale+0.5) or 1, (scale+0.5) or 1)
    setScrollFactor(tag, scale, scale)
    addLuaSprite(tag)
    setProperty(tag..'.origin.y', getProperty(tag..'.height'))
end

local partID = 0
function genParticles(amount, speed)
    if particleAmount > 200 or (lowQuality and getRandomBool(70)) then return end
    local speed = speed or 1
    for i = 0, amount do
        partID = partID + 1
        local tag = 'particles'..partID
        makeLuaSprite(tag, 'mistake/particle', getRandomFloat(-700, 2100), 800)
        if curStep >= 3776 then
            setProperty(tag..'.color', getColorFromHex(colorsGoogle[getRandomInt(1, 4)]))
        else
            setProperty(tag..'.color', getColorFromHex(particleColor))
        end
        setBlendMode(tag, 'add')
        local scalee = getRandomFloat(0, 0.5) 
        scaleObject(tag, 1 + (scalee * 3), 1 + (scalee * 3))
        setScrollFactor(tag, 0.1 + (scalee/4), 0.1 + (scalee/4))
        addLuaSprite(tag)
        setObjectOrder(tag, getObjectOrder("particle0"))
        setProperty(tag..".active", false)

        local duration = getRandomFloat(3, 6) / speed
        doTweenY(tag, tag, getProperty(tag..'.y') - getRandomFloat(200, 800), duration, 'quadOut')
        doTweenAlpha(tag..'alpha', tag, 0, duration, 'linear')

        particleAmount = particleAmount + 1
        table.insert(particles, tag)
    end
end

function onTweenCompleted(tag)
    if string.find(tag, 'particles') then
        removeLuaSprite(tag)
        particleAmount = particleAmount - 1
        for i, v in pairs(particles) do
            if v == tag then
                table.remove(particles, i)
                break
            end
        end
    end
    if tag == "GlitchShader" then
        tweenGlitch = false
    end
end

function onUpdate(elapsed)
    if not inGameOver then
        videosBeatTotal = videosBeatTotal + videosBeatAdd
        videosBeatAdd = lerp(videosBeatAdd, 0, elapsed * 15)

        local time = getSongPosition()/1000
        if videoShaderUpdate then
            for i, v in pairs(shaderUpdate) do
                if (not halfVideoDes and (string.find(v, 'video3') or string.find(v, 'video2'))) or (string.find(v, 'video0') or string.find(v, 'video1')) then
                    setShaderFloat(v, "iTime", time + videosBeatTotal)
                end
            end
        end
        setProperty('yt.angle', math.sin(time/4)*3)
        setProperty('tw.angle', math.sin(time/4)*3)
        if screamMode then
            setProperty('camFollow.y', targetYCam + 1400)
            setProperty('camFollow.x', (targetXCam[mustHitSection and 2 or 1]) + (mustHitSection and 600 or -600))
        else
            setProperty('camFollow.y', targetYCam)
            setProperty('camFollow.x', (not centerCamera) and (targetXCam[mustHitSection and 2 or 1]) or (math.abs(targetXCam[2] + targetXCam[1]) / 2 - 40))
        end

        if screenSpin then
            setProperty('camGame.angle', continuous_sin(curDecBeat/2) * 5)
            setProperty('camHUD.angle', continuous_sin(curDecBeat/2) * 3)
        end

        if TWMessageActive then
            TWOffsetY = getProperty('TWOffset.x')

            for i, v in pairs(TWMessageBar) do
                local tag = v[1]
                local range = TWMaxX - TWMinX
                local mod = (((v[3] + v[2])-TWMinX) % range) + TWMinX
                setProperty(tag..'.x', mod)
                v[2] = v[2] + (TWMessageSpeed * elapsed * 20)
            end
                
            for i, v in pairs(TWMessageBarB) do
                local tag = v[1]
                local range = TWSMaxX - TWSMinX
                local mod = (((v[3] + v[2])-TWSMinX) % range) + TWSMinX
                setProperty(tag..'.x', mod)
                v[2] = v[2] + (TWMessageSpeed * elapsed * 12)
            end

            if TWMessageSwing then
                for i, v in pairs(TWMessageBarB) do
                    local tag = v[1]
                    setProperty(tag..'.angle', continuous_sin(curDecBeat/8) * 10)
                end
            end

        end

        if shadersEnabled then
            if tweenGlitch then
                setShaderFloat("GlitchShader", "iTime", os.clock())
                setShaderFloat("GlitchShader", "GlitchAmount", getProperty("GlitchShader.x"))
            end
            if getShaderFloat("lensEffect", "intensity") ~= 0 then
                setShaderFloat("lensEffect", "intensity", lerp(getShaderFloat("lensEffect", "intensity"), 0, elapsed*8))
            end
        end

        setProperty('googleBox.y', 420 + math.sin(time/1.2) * 6)
        setProperty('googleChat.y', getProperty('googleBox.y') + 46)
        if googleTimer > 0 then
            googleTimer = googleTimer - elapsed
        else
            if getTextString('googleChat') ~= '(listening...)' then
                setTextString('googleChat', '(listening...)')
            end
        end
        if not EasyMode and Mechanic and curStep >= 512 and curStep < 767 then
            setProperty('songSpeed', defaultSpeed - 0.75 + (continuous_cos(curDecBeat/4) * 1))
        end
        if shadersEnabled and (curStep > 2336 and curStep < 2912) or (curStep >= 3776 and curStep < 4288) then
            setShaderFloat("radialBlurEffect", "blurWidth", getProperty('radialBlurEffect.x'))
        end
        if shadersEnabled and  curStep >= 3264 and curStep < 3776 then
            setShaderFloat("chrEffect", "amount", 0.04 + (math.sin(time) *0.02))
        end
        if curStep >= 3520 and curStep < 3776 then
            setProperty('camGame.angle', math.sin(time*3) * 5)
            setProperty('camHUD.angle', math.sin(time*2.8) * 3)
        end

        setShaderFloat("btsBG", "iTime", time)
end
end

function onStepHit()
    if (BGGlowBeat >= 1 and curStep%(BGGlowBeat*4) == 0) then
        setProperty('bg.color', getColorFromHex("FF0000"))
        doTweenColor('bgcolorfade', 'bg', 'FFFFFF', crochet/1000)
    end
    if (beatOnBeat and curStep % 4 == 0) then
        triggerEvent("Add Camera Zoom", "", "")
    end
    if (videoBeat and curStep % 4 == 0) then
        videosBeatAdd = 0.6
        shakeVideoAdd = shakeVideoAdd + 2
        if shadersEnabled and (curStep < 2880) then
            setShaderFloat("lensEffect", "intensity", -1)
        end
    end
    if (TWMessageActive and curStep % 4 == 0) then
        for i, v in pairs(TWMessageBar) do
            local tag = v[1]
            local defY = v[4]
            
            if (i%2==0 and curStep % 16 == 0) or (i%2==1 and curStep % 16 == 8) then
                doTweenY(tag, tag, defY, crochet/500, 'bounceOut')
            elseif (i%2==0 and curStep % 16 == 8) or (i%2==1 and curStep % 16 == 0) then
                doTweenY(tag, tag, defY + 300, crochet/500, 'bounceOut')
            end
        end
        for i, v in pairs(TWMessageBarB) do
            local tag = v[1]
            local defY = v[4]
            setProperty(tag..'.y', defY + (40 * (i%2==0 and -1 or 1) * (curStep % 8 == 0 and -1 or 1)))
            doTweenY(tag, tag, defY, crochet/1000, 'quadOut')
          
        end
    end
    if (curStep % 16 == 0 and curStep >= 2496 and curStep < 2880) then
       setProperty('blackBehindGoogle.alpha', 0.5)
       doTweenAlpha('googleBlack', 'blackBehindGoogle', 1, crochet/1000*4, 'expoOut')
    end
    genParticles(5)
end

function onStepEvent(curStep)
    if curStep == 32 then
        loadGraphic('cutscene', folder..'cutscene2')
        setProperty('cutscene.alpha', 1)
        doTweenAlpha('cutscene', 'cutscene', 0, crochet/1000*8)
    end
    if curStep == 64 then
        loadGraphic('cutscene', folder..'cutscene3')
        setProperty('cutscene.alpha', 1)
        doTweenAlpha('cutscene', 'cutscene', 0, crochet/1000*8)
    end
    if curStep == 96 then
        loadGraphic('cutscene', folder..'cutscene4')
        setProperty('cutscene.alpha', 1)
        doTweenAlpha('cutscene', 'cutscene', 0, crochet/1000*8)
    end
    if curStep == 128 then
        setProperty('black.alpha', 0)
    end
    if curStep == 256 then
        setProperty('camZoomingMult', 5)
        setProperty('camZoomingDecay', 0.4)
    end
    if curStep == 512 then
        beatOnBeat = true
        setProperty('camZoomingMult', 1)
        setProperty('camZoomingDecay', 2)

        doTweenX('lvideo2', 'lvideo2', videoX['lvideo2'], 3, 'quadOut')
        doTweenX('rvideo2', 'rvideo2', videoX['rvideo2'], 3, 'quadOut')

        doTweenX('lvideo3', 'lvideo3', videoX['lvideo3'], 4, 'quadOut')
        doTweenX('rvideo3', 'rvideo3', videoX['rvideo3'], 4, 'quadOut')

        videoBeat = true
    end

    if curStep == 640 then
        screenSpin = true
        centerCamera = true
        setProperty('defaultCamZoom', 0.8)

        for i = 2, 3 do
            local tagl = 'lvideo'..i
            local tagr = 'rvideo'..i

            cancelTween(tagl) setProperty(tagl..'.x', videoX['lvideo'..i])
            cancelTween(tagr) setProperty(tagr..'.x', videoX['rvideo'..i])
        end
    end

    if curStep == 768 then
        beatOnBeat = false
        setProperty('camZoomingDecay', 1)

        videoBeat = false
        screenSpin = false
        centerCamera = false

        setProperty('camGame.angle', 0)
        setProperty('camHUD.angle', 0)
        setProperty('defaultCamZoom', 0.9)
        setProperty('songSpeed', defaultSpeed)
    end
    if curStep == 896 then
        beatOnBeat = true
        setProperty('camZoomingDecay', 0.5)
        setProperty('songSpeed', defaultSpeed)
    end

    if curStep == 1024 then
        changeScreamMode(true)
    end

    if curStep == 1280 then -- TWITTER ready
        changeScreamMode(false)

        setProperty('black.alpha', 1)
        changeParticleColor('00C9FF')
        setProperty('botGlow.color', getColorFromHex("00C9FF"))
        setProperty('shock.color', getColorFromHex("00FFFF"))
        TWMessageActive = true

        setProperty('lvideo0.visible', false) setProperty('rvideo0.visible', false)
        setProperty('lvideo1.visible', false) setProperty('rvideo1.visible', false)
        setProperty('lvideo2.visible', false) setProperty('rvideo2.visible', false)


        setProperty('TW.alpha', 1)
        setProperty('dad.alpha', 0)

        runHaxeCode([[
            game.iconP2.changeIcon(TW.healthIcon);

            game.healthBar.createFilledBar(0xFF9900ff,0xFF00FF00);
		    game.healthBar.updateBar();
        ]])
    end

    if curStep == 1312 then -- phase 2 twitter
        setProperty('black.alpha', 0)
        setProperty('yt.alpha', 0)
        setProperty('tw.alpha', 1)
        setHealth(1)
        opponentShake = false

        for i, v in pairs(TWMessageBar) do
            local tag = v[1]
            setProperty(tag..'.alpha', 1)
        end

        for i, v in pairs(TWMessageBarB) do
            local tag = v[1]
            setProperty(tag..'.alpha', 1)
        end
    end

    if curStep == 1568 then
        TWMessageSwing = true
    end

    if curStep == 1816 then
        tweenGlitching(5, crochet/1000*4, 'quadIn')
    end
    if curStep == 1824 then -- phase 2 youtube
        tweenGlitching(0.0001, crochet/1000*1, 'quadOut')
        opponentDamage = true
        setProperty('yt.alpha', 1)
        setProperty('tw.alpha', 0)

        setProperty('lvideo0.visible', true) setProperty('rvideo0.visible', true)
        setProperty('lvideo1.visible', true) setProperty('rvideo1.visible', true)
        setProperty('lvideo2.visible', true) setProperty('rvideo2.visible', true)

        changeParticleColor('FF0000')
        setProperty('botGlow.color', getColorFromHex("FF0000"))
        setProperty('shock.color', getColorFromHex("FF0000"))
        opponentShake = true

        TWMessageActive = false
        for i, v in pairs(TWMessageBar) do
            local tag = v[1]
            setProperty(tag..'.alpha', 0)
        end
        for i, v in pairs(TWMessageBarB) do
            local tag = v[1]
            setProperty(tag..'.alpha', 0)
            setProperty(tag..'.angle', 0)
        end
        TWMessageSwing = false
        beatOnBeat = false
        setProperty('camZoomingDecay', 1)

        cameraFlash("camOther", "0x99FF0000", 0.5)
        setProperty('TW.alpha', 0)
        setProperty('dad.alpha', 1)
        setProperty('TW.x', getProperty('TW.x') + 200)
        setProperty('TW.y', getProperty('TW.y') + 400)

        runHaxeCode([[
            game.iconP2.changeIcon(game.dad.healthIcon);

            game.healthBar.createFilledBar(0xFFFF0000,0xFF00FF00);
		    game.healthBar.updateBar();
        ]])
    end
    if shadersEnabled and curStep == 1860 then
        cancelTween('GlitchShader')
        setProperty('GlitchShader.x', 0.0001)
    end
    if curStep == 1952 then
        beatOnBeat = true
        setProperty('camZoomingDecay', 0.5)

        setProperty('TWOffset.x', 600)
        doTweenX('TWOffset', 'TWOffset', 0, 2, 'circOut')
        for i, v in pairs(TWMessageBar) do
            local tag = v[1]
            setProperty(tag..'.alpha', 1)
            setProperty(tag..'.y', 800)
            doTweenY(tag, tag, v[4], 1, "quadOut")
        end

        for i, v in pairs(TWMessageBarB) do
            local tag = v[1]
            setProperty(tag..'.alpha', 1)
            setProperty(tag..'.y', 800)
            doTweenY(tag, tag, v[4], 1, "quadOut")
        end
    end
    if curStep == (1952 + (1/(stepCrochet/1000))) then
        TWMessageActive = true
    end

    if curStep == 2072 then
        setProperty("TW.alpha", 1)
        doTweenY("TWY", "TW", getProperty('TW.y') - 400, crochet/500, 'backOut')
    end

    if curStep == 2080 then
        beatOnBeat = false

        changeScreamMode(true)
    end

    if curStep == 2336 then
        changeScreamMode(false)
        centerCamera = true
        setProperty("TW.alpha", 0)
        setProperty('blackBehindGoogle.visible', true)
        setProperty('boyfriendGroup.visible', false)
        setProperty('dadGroup.visible', false)
        setProperty('ground.visible', false)
        setProperty('botGlow.visible', false)

        setProperty("googleBG.visible", true)
        setProperty("googleBox.alpha", 0)
        setProperty("googleBox.visible", true)
        setProperty("googleChat.visible", true)

        setProperty('deathPCBG.visible', true)
        setProperty('deadText.visible', true)
        setProperty('deathPC.visible', true)

        setProperty('iconSpeed', 4)

        cameraFlash('other', 'FFFFFF', 3, true)
        setProperty("camHUD.alpha", 0)

        setProperty('camZooming', false)
        setProperty('camGame.zoom', 0.9)
        setProperty('camHUD.zoom', 1)

        setProperty('spawnTime', 2000)
    end

    if shadersEnabled and curStep == 2358 then
        doTweenX('radialBlurEffect', 'radialBlurEffect', 0.2, crochet/1000*4, 'quadINOut')
    end
    if curStep == 2368 then -- GOOGLE
        googleSingOppo = true
        opponentShake = false
        opponentDamage = false

        doTweenAlpha('google', 'googleBox', 1, 8)
        setProperty('camZooming', false)
        setProperty('camGame.zoom', 0.9)
        doTweenZoom('camZoom', 'camGame', 1.4, crochet/1000*4*8, 'sineInOut')
        setProperty('defaultCamZoom', 1.4)

        doTweenAlpha("deathPCBG", "deathPCBG", 0, 2, "sineIn")
        doTweenAlpha("deadText", "deadText", 0, 2, "sineIn")

        setProperty('iconP1.visible', false)
        setProperty('iconP2.visible', false)
        setProperty('healthBar.visible', false)
        setProperty('healthBarBG.visible', false)
        setProperty('healthBarOverlay.visible', false)
    end
    if shadersEnabled and curStep == 2432 then
        doTweenX('radialBlurEffect', 'radialBlurEffect', 0, crochet/1000*4*4, 'quadInOut')
    end
    if curStep == 2480 then
        doTweenAlpha('camHUDA', 'camHUD', 1, crochet/1000*4)
    end
    if curStep == 2496 then
        if shadersEnabled then
            cancelTween('radialBlurEffect')
            setProperty('radialBlurEffect.x', 0)
        end
        cancelTween('google'); setProperty('googleBox.alpha', 1)
        setProperty('camZooming', true)
        cancelTween('camZoom')


        cancelTween('camHUDA')
        setProperty('camHUD.alpha', 1)
    end
    if shadersEnabled and curStep == 2864 then
        doTweenX('radialBlurEffect', 'radialBlurEffect', 0.8, crochet/1000*4, 'expoIn')
    end

    if curStep == 2880 then -- GOOGLE
        if shadersEnabled then
            doTweenX('radialBlurEffect', 'radialBlurEffect', 0, crochet/1000*2, 'quadOut')
        end
        googleSingOppo = false
        centerCamera = false

        cancelTween('googleBlack')
        setProperty('defaultCamZoom', 0.9)
        setProperty('blackBehindGoogle.visible', false)
        setProperty('boyfriendGroup.visible', true)
        setProperty('dadGroup.visible', true)
        setProperty('ground.visible', true)
        setProperty('botGlow.visible', true)
        setProperty("googleBG.visible", false)

        cameraFlash('camOther', 'FFFFFF', 1, true)

        setProperty('deathPCBG.visible', false)
        setProperty('deadText.visible', false)
        setProperty('deathPC.visible', false)

        setProperty("TW.alpha", 1)
        videoBeat = true
        beatOnBeat = true

        setProperty('iconSpeed', 2)

        setProperty('iconP1.visible', true)
        setProperty('iconP2.visible', true)
        setProperty('healthBar.visible', true)
        setProperty('healthBarBG.visible', true)
        setProperty('healthBarOverlay.visible', true)
    end
    if shadersEnabled and curStep == 2896 then
        cancelTween('radialBlurEffect')
        setProperty('radialBlurEffect.x', 0)
        setShaderFloat('radialBlurEffect', 'blurWidth', 0)
        
    end

    if curStep == 3264 then -- BG DESTROYED
        setProperty("btsBG.visible", true)
        cameraFlash('camGame', 'FF0000', 3, true)
        doTweenX('bgX', 'bg', getProperty('bg.x') + 200, 3, 'quadIn')
        doTweenY('bgY', 'bg', 1300, 3, 'quadIn')
        doTweenAngle('bgA', 'bg', 10, 3, 'quadIn')

        playSound('destruction', 0.8)

        if shadersEnabled then
            setShaderFloat("dad", "_alpha", 0.5)
            setShaderFloat("boyfriend", "_alpha", 0.5)
            setShaderFloat("TW", "_alpha", 0.5)
        end

        setProperty('dark.alpha', 0.4)

        setProperty('yt.color', getColorFromHex('FFD0D0'))
        setProperty('tw.color', getColorFromHex('FFD0D0'))

        local hpStuff = {'healthBar', 'healthBarBG', 'healthBarOverlay', 'iconP1', 'iconP2'}
        for i, v in pairs(hpStuff) do
            setProperty(v..'.color', getColorFromHex("FFD0D0"))
        end
        setProperty('boyfriendGroup.color', getColorFromHex('FFD0D0'))
        setProperty('dadGroup.color', getColorFromHex('FFD0D0'))
        setProperty('googleBox.color', getColorFromHex('FFD0D0'))

        shakeDes = 20
        shakeAdd = 0.5
    end

    if curStep == 3392 then -- Twitter BG DESTROYED
        TWMessageActive = false
        for i, v in pairs(TWMessageBar) do
            local tag = v[1]
            local dur = getRandomFloat(2, 4)
            doTweenX(tag..'X', tag, getProperty(tag..'.x') + getRandomFloat(-40, 40), dur, 'quadIn')
            doTweenY(tag..'Y', tag, getProperty(tag..'.y') + 500, dur, 'backIn')
            doTweenAngle(tag..'An', tag, getProperty(tag..'.angle') + getRandomFloat(-10, 10), dur, 'quadIn')
        end
            
        for i, v in pairs(TWMessageBarB) do
            local tag = v[1]
            local dur = getRandomFloat(2, 4)
            doTweenX(tag..'X', tag, getProperty(tag..'.x') + getRandomFloat(-40, 40), dur, 'quadIn')
            doTweenY(tag..'Y', tag, getProperty(tag..'.y') + 500, dur, 'backIn')
            doTweenAngle(tag..'An', tag, getProperty(tag..'.angle') + getRandomFloat(-20, 20), dur, 'quadIn')
        end

        shakeDes = 20
        playSound('destruction', 0.8)
        cameraFlash('camGame', 'FF0000', 3, true)
    end

    if curStep == 3520 then -- HALF VIDEOS DESTROYED
        halfVideoDes = true
        centerCamera = true
        local videos = {'lvideo3', 'rvideo3', 'lvideo2', 'rvideo2'}
        for i, video in pairs(videos) do
            local tag = video
            local dur = getRandomFloat(2, 4)
            doTweenX(tag..'X', tag, getProperty(tag..'.x') + getRandomFloat(-80, 80), dur, 'quadIn')
            doTweenY(tag..'Y', tag, getProperty(tag..'.y') + 900, dur, 'quadIn')
            doTweenAlpha(tag..'Al', tag, 0, dur, 'quadIn')
            doTweenAngle(tag..'An', tag, getProperty(tag..'.angle') + getRandomFloat(-20, 20), dur, 'quadIn')
        end

        shakeDes = 20
        playSound('destruction', 0.8)
        cameraFlash('camGame', 'FF0000', 3, true)
    end
    if curStep == 3648 then -- VIDEO AND HEALTH BAR DESTROYED
        videoShaderUpdate = false
        videoBeat = false

        local videos = {'lvideo1', 'rvideo1', 'lvideo0', 'rvideo0'}
        for i, video in pairs(videos) do
            local tag = video
            local dur = getRandomFloat(2, 4)
            doTweenX(tag..'X', tag, getProperty(tag..'.x') + getRandomFloat(-80, 80), dur, 'quadIn')
            doTweenY(tag..'Y', tag, getProperty(tag..'.y') + 900, dur, 'quadIn')
            doTweenAlpha(tag..'Al', tag, 0, dur, 'quadIn')
            doTweenAngle(tag..'An', tag, getProperty(tag..'.angle') + getRandomFloat(-20, 20), dur, 'quadIn')
        end

        local hpStuff = {'healthBar', 'healthBarBG', 'healthBarOverlay', 'iconP1', 'iconP2'}
        for i, v in pairs(hpStuff) do
            local tag = v
            local dur = getRandomFloat(2, 4)
            if not string.find(tag, 'healthBarOverlay') then
                if not string.find(tag, 'icon') then
                    doTweenX(tag..'X', tag, getProperty(tag..'.x') + getRandomFloat(-80, 80), dur, 'quadIn')
                end
                doTweenY(tag..'Y', tag, getProperty(tag..'.y') + 900, dur, 'quadIn')
            end
            doTweenAlpha(tag..'Al', tag, 0, dur, 'quadIn')
            doTweenAngle(tag..'An', tag, getProperty(tag..'.angle') + getRandomFloat(-20, 20), dur, 'quadIn')
        end

        shakeDes = 20
        playSound('destruction', 0.8)
        cameraFlash('camGame', 'FF0000', 3, true)
    end

    if curStep == 3744 then
        doTweenAlpha('light', 'light', 1, crochet/1000*4*2, 'expoIn')
    end
    if curStep == 3776 then
        doTweenAlpha('light', 'light', 0, crochet/1000*4*8, 'sineInOut')
        setProperty('camHUD.alpha', 0)
        setProperty('dark.alpha', 0)
        setProperty('dadGroup.visible', false)
        setProperty('TW.visible', false)
        setProperty('boyfriendGroup.visible', false)
        setProperty('yt.visible', false)
        setProperty('tw.visible', false)
        setProperty('googleBox.visible', false)
        setProperty('googleChat.visible', false)
        setProperty('btsBG.visible', false)
        setProperty('ground.visible', false)
        shakeAdd = 0
        beatOnBeat = false
        centerCamera = true

        setProperty('botGlow.color', getColorFromHex('FFFFFF'))
        for i, v in pairs(particles) do
            setProperty(v..'.color', getColorFromHex(colorsGoogle[getRandomInt(1, 4)]))
        end

        if shadersEnabled then
            setShaderFloat("chrEffect", "amount", 0)
        end
        setProperty('camGame.angle', 0)
        setProperty('camHUD.angle', 0)

        if shadersEnabled then
            setProperty('radialBlurEffect.x', 1)
            doTweenX('radialBlurEffect', 'radialBlurEffect', 0, crochet/1000*4*16, 'sineInOut')
        end
    end
    if curStep == 4016 then
        doTweenAlpha('camHUD', 'camHUD', 1, crochet/1000*4, 'linear')
    end
    if curStep == 4288 then
        setProperty('camGame.visible', false)
        setProperty('camHUD.visible', false)
        doTweenAlpha('camHUD', 'camHUD', 0, crochet/1000*8, 'linear')
    end
end

function onSongStart()
    setProperty('cutscene.alpha', 1)
    doTweenAlpha('cutscene', 'cutscene', 0, crochet/1000*8)
    if not middlescroll and downscroll then
        for i = 0, getProperty('unspawnNotes.length')-1 do
            setPropertyFromGroup("unspawnNotes", i, 'copyAlpha', false)
        end

        for i = 0, 7 do
            setPropertyFromGroup("strumLineNotes", i, 'alpha', 0.6)
        end
    end
end

function onBeatHit()
    if (curBeat % getProperty('TW.danceEveryNumBeats') == 0 and getProperty('TW.animation.curAnim') ~= nil and not getProperty('TW.animation.curAnim.name'):find('sing') and not getProperty('TW.stunned')) then
        runHaxeCode('TW.dance();')
    end
end

function onEvent(eventName, value1, value2)
    if eventName == 'Empty Event' then
        local name = tostring(value1):lower()
        local intensity = tonumber(value2)

        if name == 'bgglow' then
            BGGlowBeat = intensity
        elseif name == 'bigbeat' then
            genParticles(50, 4)
            triggerEvent("Add Camera Zoom", 0.05, "")
            setProperty('dark.alpha', 0)
            doTweenAlpha('dark','dark', 0.6, crochet/1000)
            setProperty('shock.alpha', 1)
            doTweenAlpha('shock','shock', 0, crochet/1000)
            setProperty('botGlow.alpha', 1)
            doTweenAlpha('botGlow','botGlow', 0.25, crochet/1000*2)
        end
    end

    if eventName == 'Change Character' then
        if value1:lower() == 'dad' then
            runHaxeCode([[
                for (char in game.dadGroup) {
                    char.alpha = 0;
                }
                game.dad.alpha = 1;
            ]])
            if shadersEnabled then
                setSpriteShader("dad", "dropShadow")
                setShaderFloat("dad", "_alpha", 0.8)
                setShaderFloat("dad", "_disx", -10)
                setShaderFloat("dad", "_disy", 15)
                setShaderBool("dad", "inner", true)
                setShaderBool("dad", "inverted", true)
            end
        end

        -- setSpriteShader("dad", "dropShadow")
        -- setShaderFloat("dad", "_alpha", 0.8)
        -- setShaderFloat("dad", "_disx", -10)
        -- setShaderFloat("dad", "_disy", 15)
        -- setShaderBool("dad", "inner", true)
        -- setShaderBool("dad", "inverted", true)

        -- setSpriteShader("boyfriend", "dropShadow")
        -- setShaderFloat("boyfriend", "_alpha", 0.8)
        -- setShaderFloat("boyfriend", "_disx", 10)
        -- setShaderFloat("boyfriend", "_disy", 15)
        -- setShaderBool("boyfriend", "inner", true)
        -- setShaderBool("boyfriend", "inverted", true)
    end
end

function changeScreamMode(boolean)
    screamMode = boolean
    if boolean then
        setProperty('defaultCamZoom', 1.2)
        setProperty('redbg.alpha', 1)
        if shadersEnabled then
            setShaderFloat("dad", "_alpha", 0)
            setShaderFloat("boyfriend", "_alpha", 0)
            setShaderFloat("TW", "_alpha", 0)
        end
        setProperty('camZoomingDecay', 1.6)
    else
        setProperty('defaultCamZoom', 0.9)
        setProperty('redbg.alpha', 0)
        if shadersEnabled then
            setShaderFloat("dad", "_alpha", 0.8)
            setShaderFloat("boyfriend", "_alpha", 0.8)
            setShaderFloat("TW", "_alpha", 0.8)
        end
        setProperty('camZoomingDecay', 1)
    end

end

local singAnimations = {'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'}
function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if opponentDamage then
        if getHealth() > 0.5 then
            addHealth(-0.02 * (isSustainNote and 0.2 or 1))
        end
    end
    if screamMode and noteData%4 == 2 then
        shaker = shadersEnabled and 2 or 3
        setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.03)
        setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.03)

        setProperty('redbg.alpha', 1)
        doTweenAlpha('redbg', 'redbg', 0, 0.5, 'linear')
        cameraFlash("camOther", "0x60FF0000", 0.5, true)

        local angle = getRandomInt(-5, 5, '0') * 3
        if not EasyMode and Mechanic then
            setProperty('camHUD.angle' ,angle) doTweenAngle('camHUDangle', 'camHUD', 0, 0.3, 'quadOut')
            setProperty('camGame.angle' ,angle) doTweenAngle('camGameangle', 'camGame', 0, 0.3, 'quadOut')
        end

        if shadersEnabled and Mechanic then
            setProperty('GlitchShader.x', 1)
            tweenGlitching(0, 0.5, 'quadOut')
        end

        if not EasyMode and Mechanic then
            setProperty('songSpeed', getPropertyFromClass('PlayState','SONG.speed') * 0.5)
            triggerEvent('Change Scroll Speed', 1, 0.3)
        end
    else
        if opponentShake then
            shaker = shaker + (0.75 * (isSustainNote and 0.4 or 1))
        end
    end
    if noteType == 'Hurt Note'  then
        shaker = shaker + (3 * (isSustainNote and 0.4 or 1))
        if getHealth() > (HardMode and 0.3 or 0.75) then
            addHealth(-0.08 * (isSustainNote and 0.2 or 1) * (EasyMode and 0.5 or 1))
        end
        setProperty('shock.alpha', 1)
        doTweenAlpha('shock','shock', 0, crochet/1000)
    end

    if noteType == '_TwitterSing' or (curStep >= 2080 and curStep < 2336) or (curStep >= 1312 and curStep < 1824) or (curStep >= 3712 and curStep < 3776) then
        local animToPlay = singAnimations[noteData%4 + 1]
        runHaxeCode('TW.playAnim("'..tostring(animToPlay)..'", true);')
        setProperty("TW.holdTimer", 0)
    end

    if googleSingOppo then
        sing(false, membersIndex, noteData, noteType, isSustainNote)
    end

    if curStep >= 2336 and curStep < 2880 then
        setProperty('camZooming', false)
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if noteType == "_GoogleSing" or (curStep >= 3712 and curStep < 3776) then
        sing(false, membersIndex, noteData, noteType, isSustainNote)
    end
    if screamMode then
        addHealth(0.1 * (isSustainNote and 0.2 or 1))
    end
    if curStep >= 2880 then
        addHealth(0.01 * (isSustainNote and 0.2 or 1))
    end
end

function onUpdatePost(elapsed)
    if not inGameOver then
        if not middlescroll and downscroll and curStep <= 5 then
            for i = 0, 7 do
                setPropertyFromGroup("strumLineNotes", i, 'alpha', 0.6)
            end
        end
        shakeUpdate(elapsed)
    end
end

function shakeUpdate(elapsed)
    if not inGameOver then
        shaker = lerp(shaker, 0 ,elapsed * shakerTime)
        shakeVideoAdd = lerp(shakeVideoAdd, 0 ,elapsed * shakerTime)
        shakeDes = lerp(shakeDes, 0, elapsed * 1.5) 
        local resultShake = (shaker + shakeAdd + shakeVideoAdd + shakeDes)/45*(ReduceShakeOption and 0.25 or 1)
       
        canGameX = 0.5 * getPropertyFromClass("flixel.FlxG", "width") * (1 - getProperty("camGame.zoom")) * getPropertyFromClass("flixel.FlxG", "scaleMode.scale.x")
        canGameY = 0.5 * getPropertyFromClass("flixel.FlxG", "height") * (1 - getProperty("camGame.zoom")) * getPropertyFromClass("flixel.FlxG", "scaleMode.scale.y")
        canHUDX = 0.5 * getPropertyFromClass("flixel.FlxG", "width") * (1 - getProperty("camHUD.zoom")) * getPropertyFromClass("flixel.FlxG", "scaleMode.scale.x")
        canHUDY = 0.5 * getPropertyFromClass("flixel.FlxG", "height") * (1 - getProperty("camHUD.zoom")) * getPropertyFromClass("flixel.FlxG", "scaleMode.scale.y")
        if resultShake > 0 then 
            --cameraShake("game", resultShake, 0.01)
            --cameraShake("hud", resultShake/2, 0.01)
            local randomX =  getRandomFloat(-resultShake, resultShake) * 700
            local randomY =  getRandomFloat(-resultShake, resultShake) * 700
            setProperty("camGame.canvas.x", canGameX + randomX)
            setProperty("camGame.canvas.y", canGameY + randomY)
    
            setProperty("camHUD.canvas.x", canHUDX + (-randomX*0.5))
            setProperty("camHUD.canvas.y", canHUDY + (-randomY/2*0.5))
        end
    end
end

function tweenGlitching(intensity, duration, ease)
    if shadersEnabled then
        tweenGlitch = true
        doTweenX('GlitchShader', 'GlitchShader', intensity, duration, ease)
    end
end

function changeParticleColor(color)
    particleColor = color
    for i, v in pairs(particles) do
        setProperty(v..'.color', getColorFromHex(color))
    end
end

function sing(isPlayer, id, dir, type, sus)
    local texter = "googleChat"

    if getTextString(texter) == "(listening...)" or getProperty(texter..".textField.numLines") > 2 then setTextString(texter, "") end
 
    local dontSing = lastStrumTime[1] == getPropertyFromGroup("notes", id, "strumTime")
    local numVocalName = "dadNumVocal"
 
    local empty = (#getTextString(texter) < 1)
 
    lastStrumTime[1] = getPropertyFromGroup("notes", id, "strumTime")
 
    if dontSing then return end
 
    local time = getPropertyFromGroup("notes", id, "strumTime")+1
    local data = 1
    local isFound = false
    local vocalsN = vocalsNotes.dad 
 
    for i,v in pairs(vocalsN) do 
        if v.time <= time then 
            data = v.data + 1
            isFound = true
            break
        end
    end
 
    if true then 
        _G[numVocalName] = getPropertyFromGroup("notes", id, "singData")+1
         if _G[numVocalName] == nil or _G[numVocalName] <= 0 then
             _G[numVocalName] = 1
         end
    end
 
    local isEnd = not getPropertyFromGroup("notes",id,"nextNote.isSustainNote") and getPropertyFromGroup("notes",id, "isSustainNote")
    local notSusAtAll = (not getPropertyFromGroup("notes",id,"nextNote.isSustainNote")) and (not getPropertyFromGroup("notes",id, "isSustainNote"))

    local singTexts = vocals[1][_G[numVocalName]]
    local text = singTexts[(isEnd and 3 or (sus and 2 or 1))]
    text = (isEnd or not sus) and (text[getRandomInt(1, #text)]) or text
    text = text .. (notSusAtAll and singTexts[2]..singTexts[3][1] or "")
    setTextString(texter, getTextString(texter)..((empty or sus) and "" or " ")..text)

    --{{{"ee"}, "e", {''}}, {{"oo"}, "o", {''}}, {{"aa"}, "a", {"h"}}, {{"e"}, "e", {"h"}}}
 
    googleTimer = 1
 end

function lerp(a, b, t) return a + (b - a) * t end
function continuous_sin(x)
    return math.sin((x % 1) * 2*math.pi)
end
function continuous_cos(x)
    return math.cos((x % 1) * 2*math.pi)
end

function shaderCoordFix()
    runHaxeCode([[
        resetCamCache = function(?spr) {
            if (spr == null || spr.filters == null) return;
            spr.__cacheBitmap = null;
            spr.__cacheBitmapData = null;
        }
        
        fixShaderCoordFix = function(?_) {
            resetCamCache(game.camGame.flashSprite);
            resetCamCache(game.camHUD.flashSprite);
            resetCamCache(game.camOther.flashSprite);
        }
    
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
    ]])
end