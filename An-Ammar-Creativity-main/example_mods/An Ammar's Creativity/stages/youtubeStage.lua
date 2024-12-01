local folder = ""

--pause
eventOffset = {}
paused = false

comments = {}
commentSpace = 12;
commentYStart = 920

commentFont = {
    cam = "camBYoutube",
    width = 1000,
    color = {"0xFFFFFFFF", "0xFF0F0F0F"},
    scale = 0.39,
    size = 32
}
local commentTextXSpace = 39
local commentTextYSpace = 12

playerTopComment = false
playerTargetY, opponentTargetY = 0, 0
playerOffset, opponentOffset = 0, 0

focusCam = true


--vocals mechanic
lastStrumTime = {-999, -999}
vocals = {
    {
        {{{"DI"}, "I", {'SLIKE'}}}, 
        {{{"NO"}, "O", {'B'}}}, 
        {{{"B"}, "A", {"D"}}}, 
        {{{"FA"}, "A", {"KE"}}}}, -- dad, eee, ooo ,aaa ,e
    {
        {{{"pl"}, "e", {'ase'}}}, 
        {{{"n"}, "o", {'o'}}}, 
        {{{"wh"}, "y", {"y"}}}, 
        {{{"r"}, "e", {"al"}}}} -- player, eee, ooo ,aaa ,e
}
dadNumVocal = 1
bfNumVocal = 1

vocalsNotes = {bf = {}, dad = {}}
--
pbr = 1

beatCooldown = 0
defaultZoom = 1
zoomIntense = 0.1

--*thumbnails
thumbnailsImageLimit = 18 -- start at 1
thumbnailYStart = 1350
thumbnailXStart = 600 + 200
thumbnails = {}
thumbnailPhase = 1

--PIXEL

tweeningPixels = false
tweeningColors = false
--

healthDrain = 0.005

lightMode = false

local shaderE = true
function onCreate()
    mechanicOption = (DifficultyOption == "normal" or DifficultyOption == "hard") and Mechanic
    hardmode = (DifficultyOption == "hard" or InsaneMode) and Mechanic
    shaderE = getPropertyFromClass("ClientPrefs", "shaders")
    shaderCoordFix()
end
local songSpeed = 1;
function onCreatePost()
    songSpeed = getProperty('songSpeed')
    makeCam()

    if shaderE then
        createShader()
    end

    makeLuaSprite("zoomYT", "", 1, 0)

    makeSpr({tag = "bg", cam = "camBYoutube", sFactorX = 0})
    makeGraphic("bg", 1400, 900, "FFFFFF") -- DARK MODE = 0F0F0F
    screenCenter('bg')
    

    makeSpr({tag = "bgVideo", cam = "camBYoutube"})
    makeGraphic("bgVideo", 1400, 620, "000000")

    makeSpr({tag = "videoTitle", cam = "camBYoutube", image = folder.."infoYoutube", y = 620.5, x = 50})
    setGraphicSize("videoTitle", 1280 * 0.95)

    makeSpr({tag = "topBar", cam = "camBYoutube", image = folder.."TopBar"})
    setGraphicSize("topBar", 1280)

    makeText({tag = "commentsTotal", text = "0 Comment", cam = "camBYoutube", width = 400, size = 30, x = 65, y = 875, borderQuality = 0, sFactorX = 1, sFactorY = 1, antialiasing = false})
    scaleObject('commentsTotal', 0.5, 0.5)
    setTextColor("commentsTotal", "0xFFDDDDDD")
   
    createUI()
    setupPause()

    makeSpr({tag = "opponentPFP", cam = "camBYoutube", image = folder .. "profiles/HaterM", xSize = 0.08, x = 60, y = commentYStart})
    makeSpr({tag = "playerPFP", cam = "camBYoutube", image = folder .. "profiles/AmmarM", xSize = 0.08, x = 60, y = 1000})

    makeText({tag = "opponentText", text = "", cam = commentFont.cam, width = commentFont.width, size = commentFont.size, x = 55, y = commentYStart, borderQuality = 0, sFactorX = 1, sFactorY = 1, antialiasing = false})
    scaleObject("opponentText", commentFont.scale, commentFont.scale)
    setTextColor("opponentText", commentFont.color[1])
    setProperty("opponentText.x", getProperty("opponentPFP.x") + commentTextXSpace)
    setProperty("opponentText.y", getProperty("opponentPFP.y") + commentTextYSpace)

    makeText({tag = "playerText", text = "", cam = commentFont.cam, width = commentFont.width, size = commentFont.size, x = 55, y = commentYStart, borderQuality = 0, sFactorX = 1, sFactorY = 1, antialiasing = false})
    scaleObject("playerText", commentFont.scale, commentFont.scale)
    setTextColor("playerText", commentFont.color[1])
    setProperty("playerText.x", getProperty("playerPFP.x") + commentTextXSpace)
    setProperty("playerText.y", getProperty("playerPFP.y") + commentTextYSpace)

    makeSpr({tag = "thumbnailsPos", cam = "camBYoutube", x = thumbnailXStart, y = thumbnailYStart})
    if not lowQuality then
        createThumbnails()
    end

    makeSpr({tag = "swearVig", cam = "game.camHUD", image = folder.."redVignette"})
    screenCenter("swearVig")
    setProperty("swearVig.alpha", 0)
    setBlendMode("swearVig", "add")

    --setProperty("camBYoutube.antialiasing", true)
    topY = commentYStart

    changeTheme(lightMode)

    setProperty("camGame.visible", false)
    precacheImage(folder .. "profiles/HaterMD"); precacheImage(folder .. "profiles/AmmarMD")
end

function createUI()
    makeSpr({tag = "darkBottom", cam = "camYoutube", image = folder.."darkBottomGradient", sFactorX = 0, sFactorY = 0})
    makeSpr({tag = "darkTop", cam = "camYoutube", image = folder.."darkBottomGradient", sFactorX = 0, sFactorY = 0})
    setProperty("darkTop.flipY", true)

    makeSpr({tag = "pauseA", cam = "camYoutube", image = folder.."pauseUI", xSize = 0.2, sFactorX = 0, sFactorY = 0})
    makeSpr({tag = "resumeA", cam = "camYoutube", image = folder.."resumeUI", xSize = 0.2, sFactorX = 0, sFactorY = 0})
    screenCenter("pauseA"); screenCenter("resumeA")
    setProperty("resumeA.alpha", 0)
    setProperty("pauseA.alpha", 0)
    
    makeSpr({tag = "smallUI", cam = "camYoutube", image = folder.."FullUI", sFactorX = 0, sFactorY = 0})
    makeSpr({tag = "resumeS", cam = "camYoutube", image = folder.."FullUI-ResumeSIcon", sFactorX = 0, sFactorY = 0})
    makeSpr({tag = "pauseS", cam = "camYoutube", image = folder.."FullUI-PauseSIcon", sFactorX = 0, sFactorY = 0})
    setProperty("pauseS.alpha", 0)

    setProperty("resumeS.alpha", 0.9)
    setProperty("smallUI.alpha", 0.9)
    makeText({tag = "videoTime", text = "000", cam = "camYoutube", width = 200, size = 16, x = 130, y = 689, borderSize = 1, borderColor = "0x20DDDDDD", borderQuality = 1, sFactorX = 0, sFactorY = 0})
    setTextColor("videoTime", "0xFFDDDDDD")
    updateTimeBar()

    setProperty("camYoutube.alpha", 0)


end

function createThumbnails()
    precacheImage(folder.."thumbnails/thumbEmpty")
    local thumbnailAmount = 40
    for i = 1, thumbnailAmount do 
        local extraY = #thumbnails * (110)
        local tag = "thumbnail"..#thumbnails
        local imageName = folder.."thumbnails/thumb"..getRandomInt(1, thumbnailsImageLimit)
        makeSpr({tag = tag, cam = "camBYoutube", image = imageName, y = thumbnailYStart + extraY, x = thumbnailXStart})
        setGraphicSize(tag, 180)
        table.insert(thumbnails, {tag = tag, id = #thumbnails, image = imageName})
        if (i == 1) then setProperty(tag..'.visible', false) end
    end

end

function createShader()
    addHaxeLibrary("ShaderFilter", "openfl.filters")
    initLuaShader("LowQuality")
    makeLuaSprite("lowShader")
    setSpriteShader("lowShader", "LowQuality")
 
    runHaxeCode([[
       camBYoutube.setFilters([new ShaderFilter(game.getLuaObject("lowShader").shader)]);
       game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("lowShader").shader)]);
    ]])

    setShaderFloat("lowShader", "PIXEL_FACTOR", 15000)
    setShaderFloat("lowShader", "COLOR_FACTOR", 15000)
    --setPixel()
    setProperty("lowShader.x", 15000)
    setProperty("lowShader.y", 15000)
end

function setPixel(pixels, colors)
    if not (mechanicOption and shaderE) then return end
    setShaderFloat("lowShader", "PIXEL_FACTOR", pixels or 15000)
    setShaderFloat("lowShader", "COLOR_FACTOR", colors or 15000)

    setProperty("lowShader.x", pixels or 15000)
    setProperty("lowShader.y", colors or 15000)
end

function tweenPixel(pixels, colors, duration, ease)
    if not (mechanicOption and shaderE) then return end
    if pixels ~= nil then
        tweeningPixels = true
        doTweenX("lowShaderX", "lowShader", pixels<=0 and 15000 or pixels, duration, ease)
    end
    if colors ~= nil then
        tweeningColors = true
        doTweenY("lowShaderY", "lowShader", colors<=0 and 15000 or colors, duration, ease)
    end
end

function setupPause()
    if not mechanicOption then 
        return
    end

    setProperty("spawnTime", 10000)
    for event = 0, getProperty('eventNotes.length') - 1 do
        local pauser = getPropertyFromGroup('eventNotes', event, 'event') == 'pauser'
        local eventtime = getPropertyFromGroup('eventNotes', event, 'strumTime')
        local time = getPropertyFromGroup('eventNotes', event, 'value1') -- * (crochet/1000) 
        if pauser then
            local offse = (time * 450 * songSpeed) * (downscroll and 1 or -1)
            for note = 0, getProperty('unspawnNotes.length') - 1 do
                local strumTime = getPropertyFromGroup('unspawnNotes', note, 'strumTime')
                if eventtime < strumTime and getPropertyFromGroup('unspawnNotes', note, 'mustPress') then -- this doesnt work, gonna have to desync your chart traditionally
                setPropertyFromGroup('unspawnNotes', note, 'offsetY', getPropertyFromGroup('unspawnNotes', note, 'offsetY') + offse)
                end
            end
            table.insert( eventOffset, offse)
        end
    end

end

function updateTimeBar()
    setProperty("timeBar.visible", true)
    setProperty("timeBarBG.visible", false)

    --setGraphicSize("timeBar", 1, 5)
   
    setProperty("timeBar.barWidth", 1230)
    setProperty("timeBar.width", 1230)
    setProperty("timeBar.barHeight", 5)
    setProperty("timeBar.height", 5)
    screenCenter("timeBar")
    setProperty("timeBar.y", 680)
    setProperty("timeTxt.visible" , false)
    setProperty("timeBarBG.visible" , false)
    --setProperty("timeBar.color", getColorFromHex("FF0000"))
    setProperty("timeBar.numDivisions", 10000)
    
    runHaxeCode([[
        game.timeBar.createFilledBar(0xFFA8ABB7, 0xFFFF0000);
        game.timeBar.camera = camYoutube;
    ]]) --0xFFA8ABB7
end

function changeTheme(isLightMode)
    lightMode = isLightMode

    local textColor = getColorFromHex(isLightMode and "000000" or "FFFFFF")

    setProperty("bg.color", getColorFromHex(isLightMode and "FFFFFF" or "0F0F0F"))
    for i,v in pairs(comments) do 
        setProperty(v.text..".color", textColor)
        loadGraphic(v.pfp, folder.."profiles/"..(v.isPlayer and "AmmarM" or "HaterM") .. (isLightMode and "D" or ""))
       
    end

    setProperty("opponentText.color", textColor)
    setProperty("playerText.color", textColor)
    loadGraphic("opponentPFP", folder.."profiles/".."HaterM" .. (isLightMode and "D" or ""))
    loadGraphic("playerPFP", folder.."profiles/".."AmmarM" .. (isLightMode and "D" or ""))
    setBlendMode("swearVig", (isLightMode and "normal" or "add"))
end

function makeCam()
    addHaxeLibrary("FlxObject", "flixel")
    addHaxeLibrary("FlxCameraFollowStyle", "flixel")
    runHaxeCode([[
        camEffect = new FlxCamera();
        camEffect.bgColor = 0xF;

        camYoutube = new FlxCamera();
        camYoutube.bgColor = 0xF;
        camBYoutube = new FlxCamera();
        camBYoutube.bgColor = 0xF;

        FlxG.cameras.remove(game.camHUD, false);
        FlxG.cameras.remove(game.camOther, false);

        FlxG.cameras.add(camBYoutube, false);

        FlxG.cameras.add(game.camHUD, false);
        FlxG.cameras.add(camEffect, false);
        FlxG.cameras.add(camYoutube, false);
        FlxG.cameras.add(game.camOther, false);

        game.variables.set("camEffect", camEffect);
        game.variables.set("camYoutube", camYoutube);
        game.variables.set("camBYoutube", camBYoutube);

        camPos = new FlxObject(637, 360, 1, 1);
      
        camBYoutube.follow(camPos, null, 1);

        game.variables.set("camPos", camPos);
    ]])
    setProperty("camPos.x", -100)
    setProperty("camBYoutube.minScrollX", 0)
end

local oldMustHit = false
local commentID = 0
function sendMessage(isPlayer)

    local curTxt = isPlayer and "opponentText" or "playerText"
    local curSpr = isPlayer and "opponentPFP" or "playerPFP"

    if oldMustHit ~= isPlayer and #getTextString(curTxt) > 2 then 
        oldMustHit = isPlayer
        commentID = commentID + 1

        local tagPFP = "commentPFP" .. commentID
        local tagTxt = "commentTxt"  .. commentID

        local imagePath = (isPlayer and "HaterM" or "AmmarM") .. (lightMode and "D" or "")
        local offff = (isPlayer == false and playerOffset or opponentOffset)

        makeSpr({tag = tagPFP, cam = "camBYoutube", image = folder .. "profiles/" ..imagePath, xSize = 0.08, x = getProperty(curSpr..".x"), y = getProperty(curSpr..".y")})

        makeText({tag = tagTxt, text = getTextString(curTxt), cam = commentFont.cam, width = commentFont.width, size = commentFont.size,
         x = getProperty(curTxt..".x"), y = getProperty(curTxt..".y") + offff, 
        borderQuality = 0, sFactorX = 1, sFactorY = 1, antialiasing = false})
        scaleObject(tagTxt, commentFont.scale, commentFont.scale)
        setTextColor(tagTxt, lightMode and "000000" or "FFFFFF")
        setObjectOrder(tagPFP, getObjectOrder("bg") + 2)
        setObjectOrder(tagTxt, getObjectOrder("bg") + 2)

        table.insert(comments, 1, {pfp = tagPFP, text = tagTxt, isPlayer = isPlayer == false, postAt = getSongPosition()/1000})
        setTextString(curTxt, "")

        setTextString('commentsTotal', #comments..' Comment'.. (#comments <= 1 and '' or 's'))
        if #comments >= 10 then
            local idComment = #comments
            removeLuaSprite(comments[idComment].pfp)
            removeLuaText(comments[idComment].text)
            table.remove(comments, idComment)
        end
    end
    
end

camFocusY = 0
topY = 0
function updateComment(elapsed)
    playerTopComment = mustHitSection

    if #comments > 0 then 
        topY = getProperty(comments[1].text .. ".y") + getProperty(comments[1].text..".height") + commentSpace
    end
  

    playerOffset = getProperty("playerText.textField.numLines") > 1 and ((getProperty("playerText.textField.numLines")-1)*31*commentFont.scale) or 0
    opponentOffset = getProperty("opponentText.textField.numLines") > 1 and ((getProperty("opponentText.textField.numLines")-1)*31*commentFont.scale) or 0


    playerTargetY   =  (playerTopComment   and    topY or getProperty("opponentText.y") + opponentOffset + (getProperty("opponentText.textField.numLines") * 16) + commentSpace)
    opponentTargetY = (not playerTopComment and topY or getProperty("playerText.y") + playerOffset + (getProperty("playerText.textField.numLines") * 16) + commentSpace)


    setProperty("opponentPFP.y", lerp(getProperty("opponentPFP.y"), opponentTargetY, elapsed*7))
    setProperty("playerPFP.y", lerp(getProperty("playerPFP.y"), playerTargetY, elapsed*7))

    camFocusY = mustHitSection and playerTargetY or opponentTargetY

    setProperty("opponentText.x", getProperty("opponentPFP.x") + commentTextXSpace)
    setProperty("opponentText.y", getProperty("opponentPFP.y") + commentTextYSpace - opponentOffset)

    setProperty("playerText.x", getProperty("playerPFP.x") + commentTextXSpace)
    setProperty("playerText.y", getProperty("playerPFP.y") + commentTextYSpace - playerOffset)
end

function updateThumbnail()
    if thumbnailPhase == 1 then 
        for i,v in pairs(thumbnails) do
            if v.far == false then
                setProperty(v.tag ..".x", getProperty("thumbnailsPos.x") + math.sin((getSongPosition()/200) + v.id*0.5) * 30)
            end
        end
    end
end

function hideThumbnail()
    for i,v in pairs(thumbnails) do
        if v.far == false and (getProperty(v.tag ..".y")+340) < getProperty('camPos.y') then
            setProperty(v.tag..'.visible', false)
            v.far = true
        elseif v.far == false and (getProperty(v.tag ..".y")-250) > getProperty('camPos.y') then
            setProperty(v.tag..'.visible', false)
            v.far = true
        else 
            setProperty(v.tag..'.visible', true)
            v.far = false
        end
    end
end

function onSongStart()
    showYT(3)
    doTweenY("camPosY", "camPos", 1000, 4, "sineInOut")
end

local befCamLerp = 0
function setCameraLerp(intense) -- AAAAAAAAAAAAA
    setProperty("camBYoutube.followLerp", (intense*800) / getPropertyFromClass("flixel.FlxG", "updateFramerate"))
end

function onUpdate(elapsed)
    if not inGameOver then
        setTextString("videoTime", secondsToClock(getSongPosition()/1000) .. " / " .. secondsToClock(songLength/1000))
        if focusCam then 
            setProperty("camPos.y", camFocusY)
        end
        if tweeningPixels and shaderE and mechanicOption then 
            setShaderFloat("lowShader", "PIXEL_FACTOR", getProperty("lowShader.x"))
        end
        if tweeningColors and shaderE and mechanicOption then 
            setShaderFloat("lowShader", "COLOR_FACTOR", getProperty("lowShader.y"))
        end
        updateThumbnail()
    end
end

local oldMustHit2 = false
function onUpdatePost(elapsed)
    if not inGameOver then
        if oldMustHit2 ~= mustHitSection then 
            oldMustHit2 = mustHitSection
            sendMessage(mustHitSection)
        end
        updateComment(elapsed)

        if beatCooldown ~= 0 then 
            setProperty("camBYoutube.zoom", lerp(getProperty("camBYoutube.zoom"), getProperty("zoomYT.x"), elapsed*6))
        end
    end
end

function onStepHit()
    if beatCooldown ~= 0 then 
        if curStep%(beatCooldown*4) == 0 then 
            setProperty("camBYoutube.zoom", getProperty("camBYoutube.zoom") + zoomIntense)
           
        end
    end
    if curStep % 4 == 0 then
        hideThumbnail()
        local appearTime = getProperty("thumbnailsPos.x") < 800
        if appearTime then
            if thumbnailPhase == 1 then 
                for i,v in pairs(thumbnails) do 
                    if v.far == false then 
                        setProperty(v.tag..".angle", curStep%8==0 and 10 or -10)
                        doTweenAngle(v.tag.."goBackA", v.tag, 0, crochet/1000, "quadOut")
                    end
                end
            elseif thumbnailPhase == 2 then 
                for i,v in pairs(thumbnails) do 
                    if v.far == false then
                        setProperty(v.tag..".x", getProperty("thumbnailsPos.x") + ((curStep%8==0 and 30 or -30) * (v.id%2==0 and -1 or 1)))
                        setProperty(v.tag..".angle", curStep%8==0 and 10 or -10)
                        doTweenX(v.tag.."goBackX", v.tag, getProperty("thumbnailsPos.x"), crochet/1000, "quadOut")
                        doTweenAngle(v.tag.."goBackA", v.tag, 0, crochet/1000, "quadOut")
                    end
                end
            end
        end
    end

    if curStep >= 2128 then
        for i,v in pairs(thumbnails) do 
           loadGraphic(v.tag, getRandomBool(20) and folder.."thumbnails/thumbEmpty" or v.image)
        end
    end
end

function commentType(isPlayer ,id, dir, type, sus)
    local texter = isPlayer and "playerText" or "opponentText"

    local dontSing = lastStrumTime[isPlayer and 2 or 1] == getPropertyFromGroup("notes", id, "strumTime")
    local numVocalName = isPlayer and "bfNumVocal" or "dadNumVocal"
    local quickNote = false -- CHECK IF CHARACTER SING FAST (NEW!)
    local empty = (#getTextString(texter) < 1)

    lastStrumTime[isPlayer and 2 or 1] = getPropertyFromGroup("notes", id, "strumTime")
    if dontSing then return; end -- NO DOUBLE NOTE

    _G[numVocalName] = getPropertyFromGroup("notes", id, "singData")+1
    if _G[numVocalName] == nil or _G[numVocalName] <= 0 then
        _G[numVocalName] = 1
    end

    if getPropertyFromGroup("notes", id, 'nextNote') ~= nil then
        local timeDifferent = math.abs(getPropertyFromGroup("notes", id, 'strumTime') - getPropertyFromGroup("notes", id, 'nextNote.strumTime'))
        if not (isSustainNote or getPropertyFromGroup("notes", id, 'nextNote.isSustainNote')) and 
        timeDifferent <= (stepCrochet*1.5) then
            quickNote = true
        end
    end



    if not dontSing then 
        local isEnd = not getPropertyFromGroup("notes",id,"nextNote.isSustainNote") and getPropertyFromGroup("notes",id, "isSustainNote")
            local notSusAtAll = (not getPropertyFromGroup("notes",id,"nextNote.isSustainNote")) and (not getPropertyFromGroup("notes",id, "isSustainNote"))
        if (type == "Hurt Note") and not isPlayer then 
            local singTexts = swears[CensoredOption and 2 or 1][_G[numVocalName]][getRandomInt(1, #swears[CensoredOption and 2 or 1][_G[numVocalName]])]
            local idSing = (isEnd and 3 or (sus and 2 or 1))
            local text = singTexts[idSing]
            text = (isEnd or not sus) and (text[getRandomInt(1, #text)]) or text
            text = text .. (notSusAtAll and singTexts[2]..singTexts[3][1] or "")
            
 
            setTextString(texter, getTextString(texter)..((empty or sus) and "" or " ")..text .. (isEnd and "!!" or ""))
        else
            local singTexts = vocals[isPlayer and 2 or 1][_G[numVocalName]][getRandomInt(1, #vocals[isPlayer and 2 or 1][_G[numVocalName]])]
            local text = singTexts[(isEnd and 3 or (sus and 2 or 1))]
            text = (isEnd or not sus) and (text[getRandomInt(1, #text)]) or text
            text = text .. (notSusAtAll and singTexts[2]..singTexts[3][1] or "")
            if (not isEnd and not sus) and quickNote then
                text = string.sub(text, 1, #text / 2) .. '-'
            end
            setTextString(texter, getTextString(texter)..((empty or sus) and "" or " ")..text)
        end
    end


    
    --setTextString(texter, getTextString(texter) .. "a")
end


function goodNoteHit(id, dir, type, sus)
    commentType(true ,id, dir, type, sus)
end

function opponentNoteHit(id, dir, type, sus)
    commentType(false ,id, dir, type, sus)

    if type == "Hurt Note" then 
        setProperty("swearVig.alpha", 1)
        doTweenAlpha("swearVig", "swearVig", 0, 1, "expoOut")
        if getHealth() > 0.2 and (not EasyMode) then 
            addHealth((-0.2) * (sus and 0.05 or 1) * (hardmode and 1 or 0.25))
        end
    end
    if healthDrain >= 0 and not sus and mechanicOption then 
        if getHealth() > 0.2 then 
            addHealth(-healthDrain)
        end
    end
end


function showYT(duration)
    cancelTween("camYoutubeHIDE")
    setProperty("camYoutube.alpha", 1)
    runTimer("hideYoutubeUI", duration)
end

function pause(isPause)
    paused = isPause
    local targetSpr = isPause and "pauseA" or "resumeA"
    cancelTween("goHideUIpause")
    cancelTween("goBigXUIPause")
    cancelTween("goBigYUIPause")
    setProperty("resumeA.alpha", 0)
    setProperty("pauseA.alpha", 0)
 
    scaleObject(targetSpr, 0.2, 0.2, false)
    setProperty(targetSpr..".alpha", 1)
    doTweenAlpha("goHideUIpause", targetSpr, 0, 0.6)
    doTweenX("goBigXUIPause", targetSpr..".scale", 0.35, 0.6)
    doTweenY("goBigYUIPause", targetSpr..".scale", 0.35, 0.6)

    showYT(2)
end
 
function onPause()
    befCamLerp = getProperty("camBYoutube.followLerp")
    setProperty("camBYoutube.followLerp", 0)
end

function onResume()
    setProperty("camBYoutube.followLerp", befCamLerp)
end

function onEvent(name, value1, value2)
if name == "pauser" and mechanicOption then 
    local time = value1 --* (crochet/1000)  
    --setPropertyFromClass('Conductor', 'songPosition', pos) 

    if paused then
        resumeNote()
    end
    runTimer('resumeNote', time, 1)
    for i = 0, getProperty('notes.length') - 1 do
        if getPropertyFromGroup('notes', i, 'mustPress') then
            --setPropertyFromGroup('notes', i, 'y', getPropertyFromGroup('notes', i, 'y') + (time * 450 * scrollSpeed) * (downscroll and 1 or -1))
            setPropertyFromGroup('notes', i, 'copyY', false)
            setPropertyFromGroup('notes', i, 'copyX', false)
        end
    end
    for i = 0, getProperty('unspawnNotes.length') - 1 do
    if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
        --setPropertyFromGroup('notes', i, 'y', getPropertyFromGroup('notes', i, 'y') + (time * 450 * scrollSpeed) * (downscroll and 1 or -1))
        setPropertyFromGroup('unspawnNotes', i, 'copyY', false)
        setPropertyFromGroup('unspawnNotes', i, 'copyX', false)
    end
    end
    paused = true
    pause(true)
end
if name == "Change Zoom" then 
    local zoom = tonumber(value1)
    local time = tonumber((value2 == "" or value2 == nil or value2 == " ") and 0 or value2) -- beat

    if time <= 0 then
        cancelTween("zooming")
        setProperty("zoomYT.x", zoom)
    else 
        doTweenX("zooming", "zoomYT", zoom, time*(crochet/1000), "quadInOut")
    end
    end

end
 
function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "hideYoutubeUI" then 
        doTweenAlpha("camYoutubeHIDE", "camYoutube", 0, 1, "circIn")
    end

    if tag == 'resumeNote' then
        resumeNote()
    end
end

function resumeNote()
    for i = 0, getProperty('notes.length') - 1 do
        if getPropertyFromGroup('notes', i, 'mustPress') then
           setPropertyFromGroup('notes', i, 'offsetY', getPropertyFromGroup('notes', i, 'offsetY') - eventOffset[1])
              setPropertyFromGroup('notes', i, 'copyY', true)
              setPropertyFromGroup('notes', i, 'copyX', true)
        end
       end
     for i = 0, getProperty('unspawnNotes.length') - 1 do
        if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
           setPropertyFromGroup('unspawnNotes', i, 'offsetY', getPropertyFromGroup('unspawnNotes', i, 'offsetY') - eventOffset[1])
              setPropertyFromGroup('unspawnNotes', i, 'copyY', true)
              setPropertyFromGroup('unspawnNotes', i, 'copyX', true)
        end
       end
     table.remove( eventOffset, 1 )
     setPropertyFromClass('Conductor', 'songPosition', getPropertyFromClass('flixel.FlxG', 'sound.music.time'))
     paused = false
     pause(false)
end

function onTweenCompleted(tag)
    if tag == 'lowShaderX' then 
        tweeningPixels = false
    end
    if tag == 'lowShaderY' then 
        tweeningColors = false
    end
end

function vocalsSetup()
    if not checkFileExists("data/"..songPath.."/vocals.json") then return end
    local vocals = stringTrim(getTextFromFile("data/"..songPath.."/vocals.json"))
    addHaxeLibrary("Song")
     runHaxeCode([[
         var vocals = ']]..vocals..[[';
         var vocalsArray = Song.parseJSONshit(vocals);
         game.variables.set("vocalsArray", vocalsArray);
     ]])
     local vocalArray = getProperty('vocalsArray')
     for noteI, note in pairs(vocalArray.notes) do 
        for i, v in pairs(note.sectionNotes) do 
            local _mustPress = (v[2] > 3)
            if note.mustHitSection then _mustPress = (v[2] <= 3) end
            local _data = v[2]%4
            
            if _mustPress then 
                table.insert(vocalsNotes.bf, 1,{time = v[1], data = _data})
            else 
                table.insert(vocalsNotes.dad, 1,{time = v[1], data = _data})
            end
           
        end
     end
end

function secondsToClock(seconds)
    local seconds = tonumber(seconds)
  
    if seconds <= 0 then
      return "0:00";
    else
      hours = string.format("%02.f", math.floor(seconds/3600));
      mins = string.format("%01.f", math.floor(seconds/60 - (hours*60)));
      secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
      return mins..":"..secs
    end
end

function setObjectCameraCustom(tag, cam)
    runHaxeCode([[
        game.getLuaObject("]]..tag..[[").camera = ]]..cam..[[;
    ]])
end

function makeSpr(tabler)
    if tabler.cache ~= null then 
        for i,v in pairs(tabler.cache) do
            preloadImage(v)
        end
    end
    local tag = tabler.tag or "tag"
    makeLuaSprite(tag, tabler.image or "", tabler.x or 0 , tabler.y or 0)
    setScrollFactor(tag, tabler.sFactorX or 1 ,tabler.sFactorY or tabler.sFactorX or 1)
    addLuaSprite(tag, true)
    if tabler.xSize ~= null then
        scaleObject(tag, tabler.xSize or 1, tabler.ySize or tabler.xSize or 1, true)
    end
    setObjectCameraCustom(tag, tabler.cam or "game.camGame")
end

function makeText(tabler)
    local tag = tabler.tag or "teg"
   makeLuaText(tag, tabler.text or tag, tabler.width or 0, tabler.x or 0, tabler.y or 0)
   setScrollFactor(tag, 0 ,0)
   addLuaText(tag)

   setTextFont(tag, "Youtube/YoutubeSansMedium.otf")
   setTextAlignment(tag, 'left')
   setTextBorder(tag, tabler.borderSize or 0, tabler.borderColor or "0x00000000")
   setTextColor(tag, tabler.color)
   setTextSize(tag, tabler.size or 12)
   setProperty(tag..".antialiasing", tabler.antialiasing or getPropertyFromClass("ClientPrefs", "globalAntialiasing"))
   setObjectCameraCustom(tag, tabler.cam or "game.camHUD")
   setProperty(tag..".borderQuality", tabler.borderQuality or 0)
   runHaxeCode([[
    game.getLuaObject("]]..tag..[[").scrollFactor.set(]]..tostring(tabler.sFactorX or 0)..[[, ]]..tostring(tabler.sFactorY or tabler.sFactorX or 0)..[[);
]])
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
            resetCamCache(camYoutube.flashSprite);
            resetCamCache(camEffect.flashSprite);
            resetCamCache(camBYoutube.flashSprite);
        }
    
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
    ]])
end
function onDestroy()
    runHaxeCode([[
        FlxG.signals.gameResized.remove(fixShaderCoordFix);
    ]])
end

function lerp(a, b, t)
	return a + (b - a) * t
end

--im so sorry im so sorry im so sorry
swears = {
    {
        {{{"SH"}, "I", {'T'}}}, 
        {{{"F"}, "U", {'CK'}}}, 
        {{{"F"}, "U", {"CK"}}}, 
        {{{"SH"}, "I", {"T"}}} -- dad, eee, ooo ,aaa ,e
    },{

        {{{"SH"}, "#", {'T'}}}, 
        {{{"F"}, "#", {'CK'}}}, 
        {{{"F"}, "#", {"CK"}}}, 
        {{{"SH"}, "#", {"T"}}}
    }
    }   