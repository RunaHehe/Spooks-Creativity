font = "Twitter/ggsans-Medium.ttf"
folder = "twitter/"

SpriteUtil = nil

barsX = {left = -575 + 350, right = 1280 - 350}

replies = {}
replyStartY = 405

camFollowY = 0;

--vocals mechanic
lastStrumTime = {-999, -999}
vocals = {
    {
        {{{"cr"}, "i", {'nge'}}, {{"e"}, "e", {''}}}, 
        {{{"n"}, "o", {' lol'}}, {{"o"}, "o", {''}}}, 
        {{{"b"}, "a", {"d"}}}, 
        {{{"c"}, "a", {"p"}}, {{"bl"}, "a", {""}}}}, -- dad, eee, ooo ,aaa ,e
    {
        {{{"ee"}, "e", {''}}}, 
        {{{"oo"}, "o", {''}}}, 
        {{{"aa"}, "a", {"h"}}}, 
        {{{"e"}, "e", {"h"}}}} -- player, eee, ooo ,aaa ,e
}
ratios = {
    {
        {{{"d"}, "i", {"dn't ask +"}}, {{""}, "L", {" +"}}}, 
        {{{"l"}, "o", {'g off +'}}, {{"t"}, "o", {'uch grass +'}}, {{"wh"}, "o", {'o ask +'}}}, 
        {{{"cr"}, "y", {" about it +"}}}, 
        {{{"r"}, "a", {"tio +"}}}, {{"don't c"}, "a", {"re +"}}}, -- dad, eee, ooo ,aaa ,e
}
dadNumVocal = 1
bfNumVocal = 1

vocalsNotes = {bf = {}, dad = {}}

-- CHANGEABLE VARIABLES
ratioMode = false
cameraFollow = false 
barBeat = true

defaultZoom = 1



function onCreatePost()
    shaderCoordFix()
    luaDebugMode = true
    package.path = getProperty("modulePath") .. ";" .. package.path
    SpriteUtil = require("SpriteUtil")

    setProperty("camGame.visible", false)
    addHaxeLibrary("FlxObject", "flixel")
    runHaxeCode([[
        twitterHUD = new FlxCamera();
        twitterHUD.bgColor = 0x00;

        twitterCam = new FlxCamera();
        twitterCam.bgColor = 0x00;

        game.variables.set("twitterHUD", twitterHUD);
        game.variables.set("twitterCam", twitterCam);

        FlxG.cameras.remove(game.camOther,false);
        FlxG.cameras.remove(game.camHUD,false);
        FlxG.cameras.add(twitterCam,false);
        FlxG.cameras.add(twitterHUD,false);
        FlxG.cameras.add(game.camHUD,false);
        FlxG.cameras.add(game.camOther,false);

        camPos = new FlxObject(637, 300, 1, 1);
        twitterCam.follow(camPos, null, 1);

        camZoom = new FlxObject(1, 0, 1, 1);

        game.variables.set("camPos", camPos);
        game.variables.set("camZoom", camZoom);
    ]])

    setProperty("twitterCam.followLerp", (0.002*800) / getPropertyFromClass("flixel.FlxG", "updateFramerate"))


    SpriteUtil.makeSprite({tag="bg",graphicWidth = 1400, graphicHeight = 900, graphicColor = "000000"})
    screenCenter("bg")
    setCam("bg", 1)

    SpriteUtil.makeSprite({tag="status", image = folder.."status"})
    screenCenter("status")
    setCam("status", 1)

    SpriteUtil.makeSprite({tag="opponentP", image = folder.."opponentReply", y = replyStartY})
    screenCenter("opponentP", "X")
    setCam("opponentP", 1)

    SpriteUtil.makeSprite({tag="opponentInfo", image = folder.."infoBar", y = replyStartY})
    setCam("opponentInfo", 1)

    SpriteUtil.makeText({tag="opponentText", text = "...", size = 18, font = font, borderSize = 0, borderColor = "0x00000000", width = 500, align = "left"})
    setCam("opponentText", 1)
    runHaxeCode("game.getLuaObject('opponentText').scrollFactor.set(1,1);")

    SpriteUtil.makeSprite({tag="playerP", image = folder.."AmmarReply", y = replyStartY})
    screenCenter("playerP", "X")
    setCam("playerP", 1)

    SpriteUtil.makeSprite({tag="playerInfo", image = folder.."infoBar", y = replyStartY})
    setCam("playerInfo", 1)

    SpriteUtil.makeText({tag="playerText", text = "...", size = 18, font = font, borderSize = 0, borderColor = "0x00000000", width = 500, align = "left"})
    setCam("playerText", 1)
    runHaxeCode("game.getLuaObject('playerText').scrollFactor.set(1,1);")


    SpriteUtil.makeSprite({tag="leftBar", image = folder.."profileBar", x = barsX.left, y = -50})
    setCam("leftBar", 2)

    SpriteUtil.makeSprite({tag="rightBar", image = folder.."rightBar", x = barsX.right, y = -50})
    setCam("rightBar", 2)  
    
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

function onSongStart()
    cameraFollow = true
end

function onEvent(name, value1, value2)
    if name == "Add Camera Zoom" then 
        setProperty("twitterCam.zoom", getProperty("twitterCam.zoom") + value1 or 0.015)
        setProperty("twitterHUD.zoom",getProperty("twitterHUD.zoom") + value2 or 0.05)
    end
end

function onSectionHit()
    setProperty("twitterCam.zoom", getProperty("twitterCam.zoom") + 0.015)
    setProperty("twitterHUD.zoom",getProperty("twitterHUD.zoom") + 0.05)
end

function updateReplies()
    local playerStartY = #replies > 0 and getProperty(replies[1].tagInfo .. ".y") + 35 or replyStartY
    local oppStartY = #replies > 0 and getProperty(replies[1].tagInfo .. ".y") + 35 or replyStartY

    local playerTarget = playerStartY
    local oppTarget = oppStartY
    local playerUntarget = oppTarget + 90 + getProperty("opponentText.height")
    local oppUntarget = playerTarget + 90 + getProperty("playerText.height")

    setProperty("playerP.y", mustHitSection and playerTarget or playerUntarget)
    setProperty("opponentP.y", mustHitSection == false and oppTarget or oppUntarget)

    local playerTextXTarget = getProperty("playerP.x") + 73
    local playerTextYTarget = getProperty("playerP.y") + 54
    local oppTextXTarget = getProperty("opponentP.x") + 73
    local oppTextYTarget = getProperty("opponentP.y") + 54

    setProperty("playerText.y", playerTextYTarget); setProperty("playerText.x", playerTextXTarget)
    setProperty("opponentText.y", oppTextYTarget); setProperty("opponentText.x", oppTextXTarget)

    local playerInfoY = getProperty("playerText.y") + getProperty("playerText.height") + 5
    local oppInfoY = getProperty("opponentText.y") + getProperty("opponentText.height") + 5

    setProperty("playerInfo.y", playerInfoY);
    setProperty("playerInfo.x", getProperty("playerP.x") + 80);

    setProperty("opponentInfo.y", oppInfoY);
    setProperty("opponentInfo.x", getProperty("opponentP.x") + 80);

    camFollowY = (mustHitSection and playerTarget + getProperty("playerText.height") or oppTarget + getProperty("opponentText.height")) + 75
end

function replyType(isPlayer, id, dir, type, sus)
    local texter = isPlayer and "playerText" or "opponentText"

    if getTextString(texter) == "..." then setTextString(texter, "") end

    local dontSing = lastStrumTime[isPlayer and 2 or 1] == getPropertyFromGroup("notes", id, "strumTime")
    local numVocalName = isPlayer and "bfNumVocal" or "dadNumVocal"

    local empty = (#getTextString(texter) < 1)

    lastStrumTime[isPlayer and 2 or 1] = getPropertyFromGroup("notes", id, "strumTime")

    if dontSing then return end

    if true then 
        _G[numVocalName] = getPropertyFromGroup("notes", id, "singData")+1
        if _G[numVocalName] == nil or _G[numVocalName] <= 0 then
            _G[numVocalName] = 1
        end
    end

    local isEnd = not getPropertyFromGroup("notes",id,"nextNote.isSustainNote") and getPropertyFromGroup("notes",id, "isSustainNote")
        local notSusAtAll = (not getPropertyFromGroup("notes",id,"nextNote.isSustainNote")) and (not getPropertyFromGroup("notes",id, "isSustainNote"))
    if ratioMode and not isPlayer then 
        local singTexts = ratios[1][_G[numVocalName]][getRandomInt(1, #ratios[1][_G[numVocalName]])]
        local idSing = (isEnd and 3 or (sus and 2 or 1))
        local text = singTexts[idSing]
        text = (isEnd or not sus) and (text[getRandomInt(1, #text)]) or text
        text = text .. (notSusAtAll and singTexts[2]..singTexts[3][1] or "")

        setTextString(texter, getTextString(texter)..((empty or sus) and "" or " ")..text)
    else
        local singTexts = vocals[isPlayer and 2 or 1][_G[numVocalName]][getRandomInt(1, #vocals[isPlayer and 2 or 1][_G[numVocalName]])]
        local text = singTexts[(isEnd and 3 or (sus and 2 or 1))]
        text = (isEnd or not sus) and (text[getRandomInt(1, #text)]) or text
        text = text .. (notSusAtAll and singTexts[2]..singTexts[3][1] or "")
        setTextString(texter, getTextString(texter)..((empty or sus) and "" or " ")..text)
    end

end

function goodNoteHit(id, dir, type, sus)
    replyType(true ,id, dir, type, sus)
end

function opponentNoteHit(id, dir, type, sus)
    replyType(false ,id, dir, type, sus)
end


function onStepHit()
    if barBeat then
        if curStep%8 == 7 then
            doTweenX("barLeftBeat", "leftBar", barsX.left + 25, crochet/1000/4, "cubeIn")
            doTweenX("barRightBeat", "rightBar", barsX.right - 25, crochet/1000/4, "cubeIn")
        end
        if curStep%8 == 0 then
            doTweenX("barLeftBeat", "leftBar", barsX.left, crochet/1000*1.75, "quadOut")
            doTweenX("barRightBeat", "rightBar", barsX.right, crochet/1000*1.75, "quadOut")
        end
    end
end

local oldMustHit = false
function onUpdatePost(elapsed)
    if not inGameOver then
        setProperty("twitterCam.zoom", lerp(getProperty("twitterCam.zoom"), getProperty("camZoom.x"), elapsed * 6))
        setProperty("twitterHUD.zoom", 1 + (1-getProperty("twitterCam.zoom"))*-0.75)

        if oldMustHit ~= mustHitSection then 
            oldMustHit = mustHitSection
            sendReply(mustHitSection == false)
        end

        updateReplies()

        if cameraFollow then
            setProperty("camPos.y", camFollowY)
        end
    end
end

function sendReply(isPlayerSend)
    local tagP = "replyP"..#replies
    local tagInfo = "replyI"..#replies
    local tagText = "replyT"..#replies

    local targetP = isPlayerSend and "playerP" or "opponentP"
    local targetInfo = isPlayerSend and "playerInfo" or "opponentInfo"
    local targetText = isPlayerSend and "playerText" or "opponentText"

    if #getTextString(targetText) <= 3 then return end

    SpriteUtil.makeSprite({tag=tagP, image = folder..(isPlayerSend and "AmmarReply" or "opponentReply"), x = getProperty(targetP..".x"), y = getProperty(targetP..".y")})
    setCam(tagP, 1)

    SpriteUtil.makeSprite({tag=tagInfo, image = folder.."infoBar", x = getProperty(targetInfo..".x"), y = getProperty(targetInfo..".y")})
    setCam(tagInfo, 1)

    SpriteUtil.makeText({tag=tagText, text = getTextString(targetText), size = 18, font = font, borderSize = 0, borderColor = "0x00000000", width = 500, align = "left",
    --[[aaaaaaaaaa]]   x = getProperty(targetText..".x"), y = getProperty(targetText..".y")})
    setCam(tagText, 1)

    runHaxeCode("game.getLuaObject('"..tagText.."').scrollFactor.set(1,1);")

    table.insert(replies, 1, {tagP = tagP, tagInfo = tagInfo, tagText = tagText, isPlayer = isPlayerSend})
    setTextString(targetText, "...")
end

function setCam(tag, campart)
    runHaxeCode("game.getLuaObject('"..tag.."').camera = ".. (campart <= 1 and "twitterCam" or "twitterHUD"))
 end
 
function lerp(a, b, t)
	return a + (b - a) * t
end

befCamLerp = 0
function onPause()
    befCamLerp = getProperty("twitterCam.followLerp")
    setProperty("twitterCam.followLerp", 0)
end

function onResume()
    setProperty("twitterCam.followLerp", befCamLerp)
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
            resetCamCache(twitterCam.flashSprite);
            resetCamCache(twitterHUD.flashSprite);
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