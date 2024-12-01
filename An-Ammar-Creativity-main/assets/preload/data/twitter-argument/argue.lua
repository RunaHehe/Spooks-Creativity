local barsX = {left = -575 + 350, right = 1280 - 350}
local folder = "twitter/"
defaultNotes = {}

local drumSwitch = false

messagers = {}

local beatMove = { -- x , y 
   {{-10, 0, 0, 10}, {0, -10, 10, 0}} ,
   {{2, 5, 10, 20}, {0, 0, 0, 0}} ,
   {{-20, -10, -5, -2}, {0, 0, 0, 0}} ,
   {{-5, 0, 0, 5}, {-20, -10, 10, 20}} ,
   {{-5, 0, 0, 5}, {20, 10, -10, -20}} ,
   {{-20, -10, 10, 20}, {0, 0, 0, 0}} ,
   {{20, 10, -10, -20}, {0, 0, 0, 0}} ,
   {{10, 0, 0, -10}, {0, 10, -10, 0}} ,
}


local middleX = {
    418,
    530,
    642,
    754
}

local noteXMove = {0,0,0,0,0,0,0,0}

local intenseVignette = false

local ageY = 0
local verifyingAge = false
local ages = 0
local startTimeAt = 0
local endTimeAt = 0
local ageShake = 0
local spamTextCenterX = 0

local ageYLerp = 0

local canPress = true

local clrElapsed = 9;

mechanic = true
mobileMode = false
--[[function onCreate()
    setPropertyFromClass("ClientPrefs", "middleScroll", false)
end]]
function onCreatePost()
    mobileMode = buildTarget == "android"
    luaDebugMode = true
    mechanic = not EasyMode and Mechanic

    package.path = getProperty("modulePath") .. ";" .. package.path
    SpriteUtil = require("SpriteUtil")


    if shadersEnabled then 
        initLuaShader("radchr")
        makeLuaSprite("radchr", '', 1000, -1000)
        setSpriteShader("radchr", "radchr")

        runHaxeCode([[
            var shader = new ShaderFilter(game.getLuaObject("radchr").shader);
            twitterHUD.setFilters([shader]);
            twitterCam.setFilters([shader]);
            game.camHUD.setFilters([shader]);
        ]])

        setShaderFloat("radchr", "iOffset", 0)
        setShaderFloat("iMin", "iMin", 0.01)
    end


    SpriteUtil.makeSprite({tag="vignette", image = folder.."vignette", cam = "camOther"})
    screenCenter("vignette")
    setProperty("vignette.alpha", 0)
    setBlendMode("vignette", "add")

    SpriteUtil.makeSprite({tag="blackScreen", graphicColor = "000000", graphicWidth = 1300, graphicHeight = 800, cam = "camOther"})
    screenCenter("blackScreen")
    setProperty("blackScreen.alpha", 1)
    setBlendMode("blackScreen", "multiply")

    setObjectOrder("vignette", 50)

    setProperty("playerP.alpha", 0)
    setProperty("playerText.alpha", 0)
    setProperty("playerInfo.alpha", 0)

    precacheImage(folder.."particle")
    precacheImage(folder.."Message")
    precacheImage(folder.."AgeVerification")

    SpriteUtil.makeSprite({tag="ageBG", graphicColor = "A7FFFF", graphicWidth = 1300, graphicHeight = 800, cam = "camOther"})
    screenCenter("ageBG")
    setProperty("ageBG.alpha", 0)
    setBlendMode("ageBG", "multiply")

    SpriteUtil.makeSprite({tag="ageVerify", image = folder.."AgeVerification", cam = "camOther"})
    screenCenter("ageVerify")
    ageY = getProperty("ageVerify.y")
    setProperty("ageVerify.y", -550)

    SpriteUtil.makeText({tag="ageText", text = "13", size = 40, font = "Twitter/ggsans-Medium.ttf", borderSize = 1, borderColor = "0x50FFFFFF", width = 200, align = "center", cam = "camOther"})
    screenCenter("ageText", "X")

    SpriteUtil.makeText({tag="ageTimer", text = "1010", size = 28, font = "Twitter/ggsans-Medium.ttf", borderSize = 1, borderColor = "0x10FFFFFF", width = 200, align = "right", cam = "camOther"})

    SpriteUtil.makeText({tag="spamText", text = "SPAM!!!", size = 40, font = "Twitter/ggsans-Medium.ttf", borderSize = 2, borderColor = "0xFF000000", width = 200, align = "center", cam = "camOther"})
    screenCenter("spamText", "X")
    setProperty('spamText.visible', false)
    spamTextCenterX = getProperty('spamText.x')


    SpriteUtil.makeSprite({tag="mispell", image = folder.."mispell", cam = "camOther"})
    screenCenter("mispell")
    setProperty("mispell.alpha", 0)


    setProperty("dad.healthIcon", "twitter")
    setProperty("boyfriend.healthIcon", "ammar"..(CuteMode and 'cute' or ''))
    runHaxeCode([[
        game.iconP2.changeIcon("icon-twitter");
        game.iconP1.changeIcon("icon-ammar]]..(CuteMode and 'cute' or '')..[[");
    ]])
    setHealthBarColors("AC6BE5", "60f542")

    if not HardMode then
        for i = getProperty('unspawnNotes.length')-1, 0, -1  do
            if getPropertyFromGroup("unspawnNotes", i, "noteType") == "Hurt Note" and getPropertyFromGroup("unspawnNotes", i, "mustPress") then
                setPropertyFromGroup("unspawnNotes", i, 'earlyHitMult', 0.25)
                setPropertyFromGroup("unspawnNotes", i, 'lateHitMult', 0.5)
                setPropertyFromGroup("unspawnNotes", i, 'multAlpha', 0.6)
            end
            local strumTime = getPropertyFromGroup("unspawnNotes", i, "strumTime")
            if not getPropertyFromGroup("unspawnNotes", i, "mustPress") and strumTime >= 50086 and strumTime < 108700 then
                setPropertyFromGroup("unspawnNotes", i, 'noteType', 'Hurt Note')
            end
        end
    end
    if not SpecialNotes then
        for i = getProperty('unspawnNotes.length')-1, 0, -1  do
            if getPropertyFromGroup("unspawnNotes", i, "noteType") == "Hurt Note" and getPropertyFromGroup("unspawnNotes", i, "mustPress") then
                removeFromGroup("unspawnNotes", i)
            end

        end
    end
    for i = getProperty('unspawnNotes.length')-1, 0, -1  do
        local strumTime = getPropertyFromGroup("unspawnNotes", i, "strumTime")
        if not getPropertyFromGroup("unspawnNotes", i, "mustPress") and strumTime >= 125217 then
            setPropertyFromGroup("unspawnNotes", i, 'offsetAngle', 180)
        end
    end

    setObjectCamera("songLogo", 'camOther')
    setObjectCamera("songTitle", 'camOther')
    setObjectCamera("songDiff", 'camOther')
    setObjectCamera("songDesc", 'camOther')
    setProperty('camHUD.alpha', 0)

    setProperty("camZoom.x", 0.5)
end

function onSongStart()
    setFromStage('cameraFollow', false)
    doTweenX("camZoom", "camZoom", 1, 16, "quadIn")
    doTweenAlpha("fadeBlack", "blackScreen", 0, 8, "linear")
end

function verifyAge(beatDuration, startAge)
    if not Mechanic then return end
    startTimeAt = getSongPosition()/1000
    endTimeAt = startTimeAt + beatDuration*(crochet/1000)
    verifyingAge = true
    ages = (startAge + (HardMode and -5 or 0)) + (EasyMode and 8 or 0)
    setProperty("ageVerify.y", -550)
    doTweenY("showVerify", "ageVerify", ageY, 0.5, "expoOut")

    runTimer('verifyEnd', beatDuration*(crochet/1000))

    if mobileMode then
        canPress = false
        runTimer("canPress", 0.75)
    end

    for i = 0,3 do
        setProperty("strumsBlocked["..i.."]", true)
    end
    setTextString("ageText", tostring(ages))
    setProperty('spamText.visible', true)
end

function acceptAge()
    if not verifyingAge then return end
    cancelTimer("verifyEnd")
    if ages < 18 then
        setHealth(getHealth()*0.2)
        addMisses(1)
        cameraFlash("hud", "0xA0FF0000", 1)
        playSound("missnote1", 0.8, 'acceptAge')
        doTweenY("hideVerify", "ageVerify", -550, 0.5, "quadIn")
    else 
        playSound('twitterbroke', 0.75)
        ageShake = 100
        doTweenY("hideVerify", "ageVerify", -550, 0.3, "quadIn")
    end
    verifyingAge = false
    
    for i = 0,3 do
        setProperty("strumsBlocked["..i.."]", false)
    end
    setProperty('spamText.visible', false)
end

function onStepHit()
    if verifyingAge and botPlay and curStep%2 == 0 then
        ages = ages + 1
        ageYLerp = -5
        if ages > 18 then
            acceptAge()
        end
        setTextString("ageText", tostring(ages))
    end
    if (curStep >= 256 and curStep < 768) then 
        if curStep % 8 == 0 then 
            setProperty("twitterCam.zoom", getProperty("twitterCam.zoom") + 0.05)
            setProperty("twitterHUD.zoom",getProperty("twitterHUD.zoom") + 0.1)
            setProperty("camHUD.zoom",getProperty("camHUD.zoom") + 0.01)
        end
    end
    
    
    if (curStep >= 256 and curStep < 768) or (curStep >= 1920 and curStep < 2176) then 
        if curStep % 8 == 0 then 
            setProperty("vignette.alpha", 1)
            doTweenAlpha("vigFade", "vignette", 0, crochet/1000*2)
        end
    end
    if curStep >= 512 and curStep < 768 then 
        spawnParticle(3)
    end
    if curStep >= 768 and curStep < 1664 then 
        spawnParticle(1)
    end
    if curStep >= 1664 and curStep < 1920 then 
        spawnParticle(2)
    end
    if curStep >= 1920 and curStep < 2208 then 
        spawnParticle(3)
    end
    if curStep >= 768 and curStep < 1408 then
        if curStep % 16 == 0 or curStep % 16 == 6 or curStep % 16 == 12 then
            setProperty('mispell.alpha', (curStep >= 896 and 0.6 or (Mechanic and 1 or 0.6)))
            doTweenAlpha('mispell', 'mispell', 0, 0.5, 'quadOut')
        end
    end

    if curStep >= 896 and curStep < 1408 then 
        if hardDRUM() then 
            clrElapsed = 9
            setChr(HardMode and 0.05 or 0.02)
            spawnParticle(40, 0.3)
            drumSwitch = drumSwitch == false
            setProperty("leftBar.x", barsX.left + (drumSwitch and -50 or 50))
            setProperty("rightBar.x", barsX.right + (drumSwitch and 50 or -50))

            if mechanic then
                for note = 0,7 do 
                    local _xP = beatMove[(curStep%8) + 1][1][(note % 4) + 1] * 4
                    local _yP = beatMove[(curStep%8) + 1][2][(note % 4) + 1] * 4
                    setPropertyFromGroup("strumLineNotes", note, "x", defaultNotes[note + 1][1] + _xP)
                    setPropertyFromGroup("strumLineNotes", note, "y", defaultNotes[note + 1][2] + _yP)
    
                    noteTweenX("goBackX"..note, note, defaultNotes[note + 1][1], crochet/1000, "quadOut")
                    noteTweenY("goBackY"..note, note, defaultNotes[note + 1][2], crochet/1000, "quadOut")
                end
            end
                setProperty("twitterCam.zoom", getProperty("twitterCam.zoom") + 0.05)
                setProperty("twitterHUD.zoom",getProperty("twitterHUD.zoom") + 0.1)
                setProperty("camHUD.zoom",getProperty("camHUD.zoom") + 0.01)
            
        end
    end

    if curStep >= 1408 and curStep < 1648 then 
        if curStep % 64 == 0 or curStep % 64 == 6 or curStep % 64 == 16+8 or curStep % 64 == 32+0 or curStep % 64 == 32+6 or curStep % 64 == 32+12
        or curStep % 64 == 48+0 or curStep % 64 == 48+4 or curStep % 64 == 48+6 or curStep % 64 == 48+8 or curStep % 64 == 48+12 then 
            triggerEvent("Add Camera Zoom", -0.1 , HardMode and -0.3 or 0)
            clrElapsed = 6.5
            setChr(HardMode and 0.03 or 0.02)
        end
    end

    if curStep >= 1924 and curStep < 2176 then 
        if hardDRUM() then 
            clrElapsed = 9
            setChr(HardMode and 0.05 or 0.02)
            spawnParticle(40, 0.3)
            drumSwitch = drumSwitch == false

            if mechanic then
                for note = 0,7 do 
                    local _xP = beatMove[(curStep%8) + 1][1][(note % 4) + 1] * 4
                    local _yP = beatMove[(curStep%8) + 1][2][(note % 4) + 1] * 4

                    noteXMove[note + 1] = _xP
                    setPropertyFromGroup("strumLineNotes", note, "y", (note < 4 and 570 or defaultNotes[note + 1][2]) + _yP)
                    
                    noteTweenY("goBackY"..note, note, note < 4 and 570 or defaultNotes[note + 1][2], crochet/1000, "quadOut")
                end
            end
                setProperty("twitterCam.zoom", getProperty("twitterCam.zoom") + 0.05)
                setProperty("twitterHUD.zoom",getProperty("twitterHUD.zoom") + 0.1)
                setProperty("camHUD.zoom",getProperty("camHUD.zoom") + 0.01)
            
        end
    end
end

function onBeatHit()  
    if mechanic then
        if #messagers > 0 and ((curBeat%4 == 0 and not HardMode) or (curBeat%2 == 0 and HardMode)) then 
            for i,v in pairs(messagers) do 
                if v.exist then
                    local isClose = v.isClose
                    if v.id%2 == 0 then isClose = isClose == false end
                    if isClose then
                        doTweenY("openMess"..v.id, v.tag, (HardMode and 450 or 350), 0.8 * (HardMode and 0.5 or 1), "bounceOut")
                    else 
                        doTweenY("closeMess"..v.id, v.tag, 670, 0.8 * (HardMode and 0.5 or 1), "bounceOut")
                    end
                    v.isClose = v.isClose == false
                end
            end
        end
    end
end

function onStepEvent(curStep)
    if curStep == 128 then
        setFromStage('cameraFollow', true)
        verifyAge(4*8, -10)
        doTweenAlpha("camHUD", "camHUD", 1, 8, "linear")
    end
    if curStep == 312 then 
        doTweenAlpha("fadePP", "playerP", 1, crochet/1000*2, "linear")
        doTweenAlpha("fadePT", "playerText", 1, crochet/1000*2, "linear")
        doTweenAlpha("fadePI", "playerInfo", 1, crochet/1000*2, "linear")
    end
    if curStep == 512 then
        verifyAge(4*4, -5)
    end
    if curStep == 768 then 
        intenseVignette = true
        setFromStage("ratioMode", true)
        setFromStage("barBeat", false)

        for note = 0, 7 do 
            local _x = getPropertyFromGroup("strumLineNotes", note, "x")
            local _y = getPropertyFromGroup("strumLineNotes", note, "y")
            local _s = getPropertyFromGroup("strumLineNotes", note, "scale")
            table.insert( defaultNotes, {_x , _y, _x})
         end
    end
    if curStep == 1024 then
        verifyAge(4*4, -10)
    end
    if curStep == 1664 then 
        setFromStage("ratioMode", false)
        setFromStage("barBeat", true)
        intenseVignette = false
        doTweenAlpha("vigFade", "vignette", 0, 2)
        setProperty("camHUD.angle", 0)
    end
    if curStep == 1904 then 
        setFromStage("barBeat", false)
    end
    if curStep == 1916 and mechanic then 
        doTweenX("leftBarOut", "leftBar", barsX.left - 500, crochet/1000, "quadIn")
        doTweenX("rightBarOut", "rightBar", barsX.right + 500, crochet/1000, "quadIn")
    end

    if curStep == 1920 then
        verifyAge(4*4, -10)
        if mechanic then
            for i = 0,3 do 
                noteTweenY("goDown"..i, i, (getPropertyFromClass("ClientPrefs", 'downScroll') and 50 or 570), 0.5, "quadInOut")
                noteTweenDirection("goDirDown"..i, i, 270, 0.5, "quadInOut")
                noteTweenAlpha("goInvi"..i, i, 0.65, 0.5, "quadInOut")
            end
            runHaxeCode([[
                FlxG.cameras.remove(twitterHUD,false);
                FlxG.cameras.remove(game.camOther,false);
                FlxG.cameras.add(twitterHUD,false);
                FlxG.cameras.add(game.camOther,false);
            ]])
        end
    end
    if curStep == 2176 then 
        doTweenX("camZoom", "camZoom", 6, crochet/1000*8, "quadIn")
    end
    if curStep == 2208 then 
        doTweenAlpha("fadeBlack", "blackScreen", 1, 0.1, "linear")
    end
end

function onSectionHit()
    if curStep >= 1664 and curStep < 1904 and mechanic then --1664
        spawnMessage()
    end
end

local parti = 0
local particles = {}
function spawnParticle(amount, mulCooldown)
    if lowQuality then return; end
    for i = 1, amount do 
        parti = parti + 1
        local recycle = false
        local tag = "particle"..parti
        if #particles > 0 then
            for i,v in pairs(particles) do
                if v.ended then
                    tag = v.tag
                    recycle = true
                    parti = v.id
                    v.ended = false
                    break
                end
            end
        end

        if not recycle then
            makeLuaSprite(tag, folder.."particle", getRandomFloat(-100, 1380) ,720)
            setObjectCamera(tag, "other")
            addLuaSprite(tag, true)
            setBlendMode(tag, "screen")
            setProperty(tag..'.active', false)

            --debugPrint('make new particle '..tostring(parti))
        else
            setProperty(tag..'.x', getRandomFloat(-100, 1380)) setProperty(tag..'.y', 720)
            setProperty(tag..'.alpha', 1)
        end
        local scale = getRandomFloat(1, 2)
        scaleObject(tag, scale, scale)
        
        
        local dur = getRandomFloat(1, 3) * (mulCooldown or 1)
        doTweenY(tag, tag, getRandomFloat(650, 300), dur, "quadOut")
        doTweenAlpha("alphating"..parti, tag, 0, dur-0.1)

        if not recycle then
            table.insert(particles, {tag=tag,ended=false,id=parti}) --add to last
        end
    end
end

function spawnMessage()
    local tag = #messagers .. "message"
    makeLuaSprite(tag, folder.."Message", -320, 670)
    setObjectCamera(tag, "hud")
    addLuaSprite(tag, true)
    scaleObject(tag, 0.8, 0.8, true)
    if not HardMode then
        setBlendMode(tag, 'screen')
    end
    doTweenX(tag, tag, 1300, 5)
    table.insert(messagers, 1, {tag = tag, exist = true, id = #messagers, isClose = true})
end

function onTweenCompleted(tag)
   if string.find( tag,  "particle") then 
    for i,v in pairs(particles) do
        if not v.ended and v.tag==tag then
            v.ended = true
            --debugPrint(tag)
            break
        end
    end
   end
   if string.find( tag,  "message") then 
    for i, v in pairs(messagers) do 
        if v.tag == tag then
            v.exist = false
            break;
        end
    end
    removeLuaSprite(tag)
 end
end


function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "verifyEnd" then
        acceptAge()
    end
    if tag == "canPress" then
        canPress = true
    end
end

function onUpdatePost(elapsed)
    if not inGameOver then
        ageShake = lerp(ageShake, 0, elapsed*10)
        setProperty('ageVerify.offset.x', getRandomFloat(-ageShake, ageShake))
        setProperty('ageVerify.offset.y', getRandomFloat(-ageShake, ageShake))

        setProperty("ageText.y", getProperty("ageVerify.y") + 370 + ageYLerp - getProperty('ageVerify.offset.y'))
        if (getProperty('spamText.visible')) then
            setProperty("spamText.y", getProperty("ageVerify.y") + 550 + getRandomFloat(-10, 10))
            setProperty("spamText.x", spamTextCenterX + getRandomFloat(-10, 10))
        end
        ageYLerp = lerp(ageYLerp, 0, elapsed*7)

        setProperty("ageTimer.x", getProperty("ageVerify.x") + 710 - getProperty('ageVerify.offset.x'))
        setProperty("ageTimer.y", getProperty("ageVerify.y") + 188 - getProperty('ageVerify.offset.y'))
        if verifyingAge then
            setTextString("ageTimer", tostring(math.max(numberDecision(endTimeAt - (getSongPosition()/1000), 10), 0)))
            if not botPlay then
                if ages >= 18--[[(keyJustPressed("accept") or (keyJustPressed("up") and mobileMode)) and canPress]] then
                    acceptAge()
                end
                if keyJustPressed("right") or keyJustPressed("down") or keyJustPressed("left") or keyJustPressed("up") then
                    ages = ages + (3/4)
                    ageYLerp = -5
                    setTextString("ageText", tostring(math.floor(ages)))
                    ageShake = 10
                    playSound("scrollMenu", 0.8)
                -- elseif keyJustPressed("left") then
                --     ages = ages - 1
                --     ageYLerp = 5
                --     setTextString("ageText", tostring(ages))
                --     playSound("scrollMenu", 0.8, 'changeAge')
                end
            end
        end

        if curStep >= 896 and curStep < 1408 then  
            setProperty("leftBar.x", lerp(getProperty("leftBar.x") ,barsX.left, elapsed*7))
            setProperty("rightBar.x", lerp(getProperty("rightBar.x") ,barsX.right, elapsed*7))
        end
        if curStep >= 768 and curStep < 1664 and mechanic then  
            setProperty("camHUD.angle", continuous_sin(curDecBeat/8)*5)
        end
        if intenseVignette then
            setProperty("vignette.alpha", 0.5+(math.sin(getSongPosition()/200)/2))
        end

        if curStep >= 1920 and curStep < 2176 then  
            local maxValue = (HardMode and 4 or 8)
            local lb = barsX.left + (continuous_sin(curDecBeat/maxValue) * 175)
            local rb = barsX.right + (continuous_sin(curDecBeat/maxValue) * 175)
            setProperty("leftBar.x", lerp(getProperty("leftBar.x"), lb, elapsed*10))
            setProperty("rightBar.x", lerp(getProperty("rightBar.x"), rb, elapsed*10))

            if mechanic then
                for i = 0,7 do
                    local ti = middleX[i%4 + 1] + (continuous_sin(curDecBeat/maxValue) * 175)
                    setPropertyFromGroup("strumLineNotes", i, "x", ti + noteXMove[i + 1])

                    noteXMove[i + 1] = lerp(noteXMove[i + 1], 0, elapsed*9)
                end
            end
            
        end
        if shadersEnabled then
            local rad = lerp(getShaderFloat("radchr", "iOffset")*100, 0, elapsed*clrElapsed)/100
            setChr(rad)
        end
    end
end


function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if HardMode and not isSustainNote and getHealth()>0.2 then
        addHealth(-0.005)
    end
    if noteType == 'Hurt Note' and not isSustainNote and getHealth()>0.2 then
        addHealth(-0.005)
    end
end


function hardDRUM()
    if curStep%4 == 0 or curStep%64 == 26 or curStep%64 == 27 or curStep%64 == 30 or curStep%64 == 50 or curStep%64 == 54 or curStep%64 == 55 or curStep%64 == 58
    or curStep%64 == 62 then 
        return true
    end
end

function setChr(intensity) 
    if shadersEnabled then
        setShaderFloat("radchr", "iOffset", intensity)
    end
end

function setFromStage(variable, value)
    setGlobalFromScript("stages/twitterStage", variable, value)
end

function getFromStage(variable)
    getGlobalFromScript("stages/twitterStage", variable)
end

function lerp(a, b, t)
	return a + (b - a) * t
end

function setCam(tag, campart)
    runHaxeCode("game.getLuaObject('"..tag.."').camera = ".. (campart <= 1 and "twitterCam" or "twitterHUD"))
 end

 function continuous_sin(x)
    return math.sin((x % 1) * 2*math.pi)
end

function numberDecision(number, deci)
    return math.floor(number*deci) / deci
end