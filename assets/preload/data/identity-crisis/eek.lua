local membersSprites = {}
local folder = "twitter/"

pbr = 1

function onCreatePost()
    healthIconPOS = getProperty("iconP1.y")

    luaDebugMode = true
    
    package.path = getProperty("modulePath") .. ";" .. package.path
    SpriteUtil = require("SpriteUtil")

    makeLuaSprite("blackFade", nil, 0, 0)
    makeGraphic("blackFade", 1300, 800, "000000")
    setObjectCamera("blackFade", "camHUD")
    addLuaSprite("blackFade")

    makeLuaSprite("vignette", "vignette", 0, 0)
    setObjectCamera("vignette", "other")
    screenCenter('vignette')
    setProperty('vignette.alpha', 0.5)
    addLuaSprite("vignette", true)

    makeLuaSprite("lightbottom", "downGlowIdentitiyCrisis", 0, 0)
    setObjectCamera("lightbottom", "other")
    screenCenter("lightbbottom")
    setProperty('lightbottom.alpha', 0)
    setProperty('lightbottom.color', getColorFromHex("CCCCCC"))
    addLuaSprite("lightbottom")

    makeLuaSprite("flash", nil, 0, 0)
    makeGraphic("flash", screenWidth, screenHeight, "FFFFFF")
    setObjectCamera("flash", "other")
    setProperty('flash.alpha', 0)
    addLuaSprite("flash")

    setProperty("scoreTxt.alpha", 0)
    setProperty("missTxt.alpha", 0)
    setProperty("rateTxt.alpha", 0)
    setProperty("comboTxt.alpha", 0)

    setProperty("scoreTxt.visible", false)
    setProperty("missTxt.visible", false)
    setProperty("rateTxt.visible", false)
    setProperty("comboTxt.visible", false)

    setProperty('iconP1.alpha', 0)
    setProperty('iconP2.alpha', 0)
    setProperty('healthBar.alpha', 0)
    setProperty('healthBarBG.alpha', 0)

    setProperty('iconP2.color', '000000')
    setHealthBarColors("000000", "00FF00")

    setProperty('opponent.alpha', 0)
    setProperty('opponentText.alpha', 0)

    setProperty('opponent.visible', false)
    setProperty('opponentText.visible', false)

    SpriteUtil.makeSprite({tag="miss", image = folder.."miss", cam = "camOther"})
    screenCenter("miss")
    setProperty("miss.alpha", 0)

    membersSprites = getProperty("membersSprites")
end

function onSongStart()
    doTweenAlpha("goodbye blackFade", "blackFade", 0, 10, "linear")
end

function onUpdate(elapsed)
    if curStep > 0 and curStep < 64 then
        setProperty('opponent.alpha', 0)
        setProperty('opponentText.alpha', 0)
    end

    if curStep > 0 and curStep < 256 then
        setProperty("scoreTxt.alpha", 0)
        setProperty("missTxt.alpha", 0)
        setProperty("rateTxt.alpha", 0)
        setProperty("comboTxt.alpha", 0)
    end

    if ((curStep > 512 and curStep < 760)) then
        setProperty("camHUD.angle", continuous_sin(curDecStep / 16) * 5)
        if curStep == 760 then
            setProperty("camHUD.angle", 0)
        end
    end
end

function onStepHit()
    if curStep == 64 then
        setProperty('opponent.visible', true)
        setProperty('opponentText.visible', true)

        doTweenAlpha('hi who', 'opponent', 1, 2, 'linear')
        doTweenAlpha('hi who text', 'opponentText', 1, 2, 'linear')
    end

    if curStep == 144 then
        doTweenAlpha('hi blackFade', 'blackFade', 1, 10)
    end

    if curStep == 248 then
        cancelTween("hi blackFade")
        doTweenAlpha("goodbye blackFade", "blackFade", 0, 5, "expoOut")
    end

    if curStep >= 1152 and curStep < 1408 then
        if curStep % 16 == 0 or curStep % 16 == 18 or curStep % 16 == 12 then
            setProperty('miss.alpha', (curStep >= 896 and 0.6 or (Mechanic and 1 or 0.6)))
            doTweenAlpha('miss', 'miss', 0, 0.5, 'quadOut')
        end
    end

    if curStep == 256 then
        camFlash(1, 1)

        cancelTween("goodbye blackFade")
        setProperty('blackFade.alpha', 0)

        setProperty("scoreTxt.visible", true)
        setProperty("missTxt.visible", true)
        setProperty("rateTxt.visible", true)
        setProperty("comboTxt.visible", true)

        doTweenAlpha('hi iconP1', 'iconP1', 1, 2, 'linear')
        doTweenAlpha('hi iconP2', 'iconP2', 1, 2, 'linear')
        doTweenAlpha('hi healthBar', 'healthBar', 1, 2, 'linear')
        doTweenAlpha('hi healthBarBG', 'healthBarBG', 1, 2, 'linear')

        doTweenAlpha('hi scoreTxt', 'scoreTxt', 1, 2, 'linear')
        if misses > 1 then doTweenAlpha('hi missTxt', 'missTxt', 1, 2, 'linear') end
        doTweenAlpha('hi rateTxt', 'rateTxt', 1, 2, 'linear')
    end

    if curStep == 512 then
        camFlash(1, 1)
    end

    if ((curStep > 512 - 1 and curStep < 736) or (curStep > 768 - 1 and curStep < 1142) or (curStep > 1152 - 1 and curStep < 1408) or (curStep > 1536 - 1 and curStep < 1808)) then
        if curStep % 4 == 0 then
            triggerEvent("Add Camera Zoom", 0.025, 0.05)
            theyBeat(15)
            lightFlash()
            if (curStep > 768 - 1 and curStep < 1142) or (curStep > 1152 - 1 and curStep < 1408) or (curStep > 1536 - 1 and curStep < 1808) then
                camBeat(2)
            end
        end
    end
    if curStep > 256 - 1 and curStep < 368 then
        if curStep % 16 == 0 then
            triggerEvent("Add Camera Zoom", 0.025, 0.05)
            lightFlash()
            theyBeat(20)
            camBeat(5)
        end
    end
    if curStep > 384 - 1 and curStep < 512 then
        if curStep % 8 == 0 then
            triggerEvent("Add Camera Zoom", 0.025, 0.05)
            lightFlash()
            theyBeat(15)
            camBeat(5)
        end
    end
    if curStep == 368 then
        doTweenAlpha('hi blackFade', 'blackFade', 1, 0.25, 'expoOut')
    end
    if curStep == 384 then
        camFlash(1, 1)
        setProperty('blackFade.alpha', 0)
    end
    if curStep == 512 then
        camFlash(1, 1)
    end
    if ((curStep > 736 - 1 and curStep < 760)) then
        triggerEvent("Add Camera Zoom", 0.025, 0.05)
        theyBeat(15)
        lightFlash()
        --camBeat(2)
    end
    if curStep == 760 then
        setObjectCamera("blackFade", "other")
        setProperty('blackFade.alpha', 1)
    end
    if curStep == 768 then
        setProperty('blackFade.alpha', 0)
        camFlash(1, 1)
    end
    if curStep == 1142 then
        setObjectCamera("blackFade", "camHUD")
        setProperty('blackFade.alpha', 1)
    end
    if curStep == 1152 then
        setProperty('blackFade.alpha', 0)
        camFlash(1, 1)
        setObjectCamera("blackFade", "other")
    end
    if curStep == 1408 then
        camFlash(1, 1)
        doTweenAlpha('hi blackFade', 'blackFade', 1, 2)
        doTweenAlpha('bye camHUD', 'camHUD', 0, 2)
    end
    if curStep == 1536 then
        camFlash(1, 1)
        setProperty('blackFade.alpha', 0)
        setProperty('camHUD.alpha', 1)
    end
    if curStep == 1792 then
        setProperty('blackFade.alpha', 1)
        setObjectCamera("blackFade", "camHUD")
    end
    if curStep == 1808 then
        camFlash(1, 1)
        setProperty('blackFade.alpha', 0)
        setObjectCamera("blackFade", "other")
        doTweenAlpha('hi blackFade', 'blackFade', 1, 2)
        doTweenAlpha('bye camHUD', 'camHUD', 0, 2)
    end
    if curStep > 1856 then
        endSong()
    end

    if ((curStep > 512 - 1 and curStep < 736) or (curStep > 768 - 1 and curStep < 1142) or (curStep > 1152 - 1 and curStep < 1408) or (curStep > 1536 - 1 and curStep < 1808)) then
        if curStep % 4 == 0 then
            doTweenY('iconP1 bounce', 'iconP1', healthIconPOS - 12, stepCrochet * 0.002, 'circOut')
            doTweenY('iconP2 bounce', 'iconP2', healthIconPOS - 12, stepCrochet * 0.002, 'circOut')
        end
        if curStep % 4 == 2 then
            doTweenY('iconP1 bounce 2', 'iconP1', healthIconPOS, stepCrochet * 0.002, 'sineIn')
            doTweenY('iconP2 bounce 2', 'iconP2', healthIconPOS, stepCrochet * 0.002, 'sineIn')
        end
    end

    if (curStep >= 384 and curStep < 1800) then 
        if curStep % 4 == 0 then
            for i,v in pairs(membersSprites) do
                if not v[3] then
                    local offsetX = 7
                    setProperty(v[1]..".xAdd", offsetX + (7*(i%2==0 and 1 or -1)*(curStep%16==0 and 1 or -1)))
                end
            end
        end
    end
end

function onUpdatePost(elapsed)
    if not inGameOver then
        if (curStep >= 384 and curStep < 1800) then 
            for i,v in pairs(membersSprites) do
                if not v[3] then
                    local offsetX = 7
                    setProperty(v[1]..".xAdd", lerp(getProperty(v[1]..".xAdd"), offsetX, elapsed*7*pbr))
                end
            end
            
        end
     end
end

function noteMiss(id, nd, nt, sus)
    if (curStep > 1151 and curStep < 1342) then
        -- get current health
        local health = getProperty('health')

        -- fucking kill the player NOW!!
        setProperty('health', health - 500)
    end

    if not sus then
        if curStep > 256 then
            --SOMEHOW SOMEWAY, I BUGGED THE COMBOTXT Y AND COMBOMISS ALPHA
            --DONT ASK HOW I FUCKED IT UPPPPPP 😭😭😭
            --erm what thhe fuck
            setProperty('comboTxt.y', 590)
            setProperty('missTxt.alpha', 1)
        end
    end
end

function camFlash(v1, v2)
    setProperty('flash.alpha', v1)
    doTweenAlpha('goodbye Flash', 'flash', 0, v2, 'linear')
end

function continuous_sin(x)
    return math.sin((x % 1) * 2 * math.pi)
end

local first = true
function theyBeat(v1)
    if first then
        setProperty('opponent.x', 320 + v1 + 20)
        setProperty('player.x', 320 - v1)

        setProperty('opponentText.x', 423 + v1 + 20)
        setProperty('playerText.x', 423 - v1)
        first = false
    else
        setProperty('opponent.x', 320 - v1)
        setProperty('player.x', 320 + v1 + 20)

        setProperty('opponentText.x', 423 - v1)
        setProperty('playerText.x', 423 + v1 + 20)
        first = true
    end
    doTweenX("theyBeatLOLopp", "opponent", 320, 1, "expoOut")
    doTweenX("theyBeatLOLpla", "player", 320, 1, "expoOut")
end

local camfirst = true
function camBeat(v1)
    if camfirst then
        setProperty('camHUD.angle', v1)
        camfirst = false
    else
        setProperty('camHUD.angle', -v1)
        camfirst = true
    end
    doTweenAngle("camHUD go back", "camHUD", 0, 1, "expoOut")
end

function lightFlash()
    setProperty('lightbottom.alpha', 0.5)
    doTweenAlpha("lightbottom bye", "lightbottom", 0, 1, "linear")
end
function lerp(a, b, t) return a + (b - a) * t end