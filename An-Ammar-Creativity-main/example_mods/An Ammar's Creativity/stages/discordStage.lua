

fontName = "Discord/ggsans-Medium.ttf"
dancingPanel = false
folder = ""

LightMode = false

sideBarStuff = {
    channels = {y1 = 50, y2 = 0, x = 0},
    members = {y1 = 0, y2 = 50, x = 0}
}
barIntensity = 16
dmSpace = 10
centerScreenY = 720/2

idleTimer = {bf = 0, dad = 0, bfDone = true, dadDone = true}

dadNoteNear = false
bfNoteNear = false

dadNumVocal = 1
bfNumVocal = 1

vocalsNotes = {bf = {}, dad = {}}
pbr = 1

--Customizable
--lightingMode(isLightMode)
disableIsTyping = false
disableDadTextRemove = false
disableBFTextRemove = false
disableDadTextTyping = false
disableBFTextTyping = false
disableCamLerp = false
camsFollowDefault = true

opponentTyping = "(An Ammar is typing...)"
opponentCaps = false
sideSinning = false 

barBeatPhase = 1

local nopro = ''

vocals = {
    {{{"ee"}, "e", {''}}, {{"oo"}, "o", {''}}, {{"aa"}, "a", {"h"}}, {{"e"}, "e", {"h"}}}, -- dad, eee, ooo ,aaa ,e
    {{{"ee"}, "e", {''}}, {{"oo"}, "o", {''}}, {{"aa"}, "a", {"h"}}, {{"e"}, "e", {"h"}}} -- player, eee, ooo ,aaa ,e
}

local membersSprites = {}

function onCreate()
    MechanicOption = not EasyMode
    shader = shadersEnabled
    setProperty("introSoundsSuffix", "-discord")
    nopro = NoPromotion and '-nopromo' or ''
    shaderCoordFix()
end
function onCreatePost()
    makeCam()
    addHaxeLibrary('Paths')
    luaDebugMode = true 
    runHaxeCode([[
        Paths.clearUnusedMemory();
    ]])
    precacheImage(folder.."ChannelsList-Light")
    precacheImage(folder.."MembersListBG-Light")
    precacheImage(folder.."messageBar-Light")
    precacheImage(folder.."topBar-Light")

    if songName:lower() == "shut-up" then 
        --precacheImage(folder.."MembersList2B")
        --precacheImage(folder.."MembersList2B-Light")
        --precacheImage(folder.."Boy")
        --precacheImage(folder.."MembersList2-Light")
    end

    local isShutUp = songName:lower() == "shut-up" or songName:lower() == "banned"

    opponentTyping = isShutUp and "(Random Girl is MAD...)" or opponentTyping
    opponentCaps = isShutUp
    barIntensity = isShutUp and 30 or barIntensity
    
    vocalsSetup()

    makeSpr({tag = "background", x = -50, y = -50, cam = "camBDiscord"})
    makeGraphic("background", 1280,720, "FFFFFF")
    scaleObject("background", 1.2, 1.2)
    screenCenter("background")
    setProperty("background.color", getColorFromHex("36393F"))

    makeSpr({tag = "channels", image = folder.."ChannelsList", x = -5, y = 50, xSize = 0.85, cam = "camDiscord"})

    --makeSpr({tag = "members", image = folder..(songName:lower() == "shut-up" and "MembersList2" or "MembersList"), xSize = 0.85, cam = "camDiscord"})
    makeSpr({tag = "members", cam = "camDiscord", image = folder.."MembersListBG", xSize = 0.85})
    --makeGraphic("members", 371*0.85, 1440*0.85, "FFFFFF")
    --setProperty("members.color", getColorFromHex("2B2D31"))
    setProperty("members.x", screenWidth - getProperty("members.width") + 5)
    setProperty("members.y", screenHeight - getProperty("members.height") + 5)
    setProperty("members.antialiasing", false)
    setupMembers()

    sideBarStuff.channels.y2 = screenHeight - getProperty("channels.height") + 5
    sideBarStuff.members.y1 = getProperty("members.y")
    sideBarStuff.channels.x = getProperty("channels.x")
    sideBarStuff.members.x = getProperty("members.x")
    
    makeSpr({tag = "topBar", image = folder.."topBar"..nopro, y = 0, cam = "camDiscord",  xSize = 1.05})
    screenCenter("topBar", "X")

    makeSpr({tag = "message", image = folder.."messageBar", y = 640, cam = "camDiscord"})
    screenCenter("message", "X")

    --characters!!!!! 

    local xx = 320
    local tw = 505
    makeText({tag = "opponentText", text = "...", cam = "camBDiscord", width = tw})
    makeSpr({tag = "opponent", image = folder..(isShutUp and "chars/Random Girl" or "chars/Ammar"), x = xx, y = 100, cam = "camBDiscord", xSize = (isShutUp and 0.625 or 0.625)})

    makeText({tag = "playerText", text = "...", cam = "camBDiscord", width = tw})
    makeSpr({tag = "player", image = folder.."chars/Annoying User", x = xx, y = 300, cam = "camBDiscord", xSize = 0.625})
    makeText({tag = "playerText", text = "...", cam = "camBDiscord", width = tw})
    makeSpr({tag = "player", image = folder.."chars/Ammar Player", x = xx, y = 300, cam = "camBDiscord", xSize = 0.625})
    makeText({tag = "opponentText", text = "...", cam = "camBDiscord", width = tw})
    makeSpr({tag = "opponent", image = folder.."chars/Who", x = xx, y = 300, cam = "camBDiscord", xSize = 0.625})

    setGraphicSize("opponent", 649 * 0.625, 146 * 0.625)
    setGraphicSize("player", 649 * 0.625, 146 * 0.625)

   pbr = getProperty("playbackRate")
   if MechanicOption and getPropertyFromClass("ClientPrefs", "shaders") then 
        addHaxeLibrary("ShaderFilter", "openfl.filters")
        initLuaShader("ColorsEdit")
        makeLuaSprite("colorShader")
        setSpriteShader("colorShader", "ColorsEdit")

        runHaxeCode([[
            game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("colorShader").shader)]);
         ]])
        setShaderFloat("colorShader", "contrast", 1)
        setShaderFloat("colorShader", "saturation", 1)
        setShaderFloat("colorShader", "brightness", 1)
   end

   setProperty("camGame.visible")
end

function setupMembers()
    local textFile = ''
    if checkFileExists('mods/stages/discordMembers.txt', true) then 
        textFile = getTextFromFile("stages/discordMembers.txt", false)
    end
    local onSongPath = "data/"..((songName:lower()):gsub(' ', '-'))..'/discordMembers.txt'
    if checkFileExists('assets/'..onSongPath, true) then 
        textFile = getTextFromFile(onSongPath, false) 
    end
    local members = {} -- {{name, category}}
    local categories = {}
    local cate = ''
    for line in textFile:gmatch("[^\r\n]+") do
        if stringStartsWith(line, "-") then
            cate = line:sub(2, #line)
            table.insert(categories, cate)
        else
            table.insert(members, {line, cate});
        end
    end

    addHaxeLibrary("AttachedSprite") addHaxeLibrary("AttachedFlxText", "editors.ChartingState") addHaxeLibrary("FlxRect", "flixel.math") addHaxeLibrary("Paths", "") addHaxeLibrary("Std")
    runHaxeCode "setVar('memberList', [])"
    runHaxeCode "setVar('categoryList', [])"
    runHaxeCode "setVar('membersSprites', [])"

    setProperty("memberList", members)
    setProperty("categoryList", categories)

    runHaxeCode([=[
        var memberList = getVar('memberList');
        var categoryList = getVar('categoryList');
        var memberPlace = game.getLuaObject("members");
        var memberOrder = [];

        /*memberList.sort(function(a:Array<String>, b:Array<String>):Int {
            a = a[0].toUpperCase();
            b = b[0].toUpperCase();
          
            if (a < b) {
              return -1;
            }
            else if (a > b) {
              return 1;
            } else {
              return 0;
            }
          });*/

        var membersSprites = [];
        var updateMemberList = memberList;

        if (updateMemberList.length <= 8 && !ClientPrefs.lowQuality) {
            for (i in 0...(17 - updateMemberList.length)) {
                updateMemberList.push(["User" + FlxG.random.int(1, 3), categoryList[categoryList.length-1]]);
            }
        }

        var indexNum = 0;
        var space = 40;
        var offsetX = 7;
        var categoryXOff = 16 + offsetX;
        var categoryIndex = 0;
        for (memberA in updateMemberList) {
            var addNewCategory:Bool = false; var categoryName:String = '';
            if (memberA[1] == categoryList[categoryIndex]) {
                categoryName = categoryList[categoryIndex];
                addNewCategory = true;
                space += 40;
                categoryIndex += 1;
            }
            var memberName:String = memberA[0];

            var member = new AttachedSprite('members/'+memberName);
            member.setGraphicSize(Std.int(member.width * 0.75));
            member.updateHitbox();
            member.yAdd = indexNum * 66 + space;
            member.xAdd = offsetX;
            member.camera = camDiscord;
            game.add(member);
            member.sprTracker = memberPlace;
            indexNum += 1;
            memberOrder.push(memberName);
            Paths.image('members/'+memberName+" L");

            game.variables.set("s-"+memberName+indexNum, member);
            membersSprites.push(["s-"+memberName+indexNum, 'members/'+memberName, false]);

            if (addNewCategory) { // Add New Category
                var category = new AttachedSprite('category/'+categoryName);
                category.setGraphicSize(Std.int(category.width * 0.75));
                category.updateHitbox();
                category.yAdd = member.yAdd - 18;
                category.xAdd = categoryXOff;
                category.camera = camDiscord;
                game.add(category);
                category.sprTracker = memberPlace;
                Paths.image('category/'+categoryName+' L');

                var lowCate:String = StringTools.trim(categoryName.toLowerCase());
                game.variables.set('c-'+lowCate, category);
                membersSprites.push(['c-'+lowCate, 'category/'+categoryName, true]);

            }
            
            
        }
        setVar('membersSprites', membersSprites)
    ]=])

    membersSprites = getProperty("membersSprites")
end

local totalElapsed = 0
function onUpdate(elapsed)
    if inGameOver then return end
    dadNoteNear = nearNotes(1000, false)
    bfNoteNear = nearNotes(1000, true)

    if LightMode and HardMode then
        if getPropertyFromClass("ClientPrefs", "shaders") then 
            totalElapsed = totalElapsed + elapsed
            setShaderFloat("colorShader", "saturation", 2 + (math.sin(totalElapsed * 8.01)*0.6))
            setShaderFloat("colorShader", "brightness", 2 + (math.sin(totalElapsed * 8.01)*0.6))
        end

        for i = 0, getProperty('notes.length')-1 do
            if (not getPropertyFromGroup("notes", i, 'isSustainNote')) then
                setPropertyFromGroup('notes', i, 'offsetAngle', getPropertyFromGroup("notes", i, 'distance')/5)
            end
        end
    end

    if mustHitSection then 
        local oY = centerScreenY - dmSpace - getProperty("opponent.height") - ((getProperty("opponentText.textField.numLines")-1)*33)
        local pY = centerScreenY + dmSpace
        setProperty("opponent.y", lerp(getProperty("opponent.y"), oY, elapsed*7*pbr))
        setProperty("player.y", lerp(getProperty("player.y"), pY, elapsed*7*pbr))
    else 
        local oY = centerScreenY + dmSpace
        local pY = centerScreenY - dmSpace - getProperty("player.height") - ((getProperty("playerText.textField.numLines")-1)*33)
        setProperty("opponent.y", lerp(getProperty("opponent.y"), oY, elapsed*7*pbr))
        setProperty("player.y", lerp(getProperty("player.y"), pY, elapsed*7*pbr))
    end

    setProperty("opponentText.y", getProperty("opponent.y")+40)
    setProperty("playerText.y", getProperty("player.y")+40)

    setProperty("opponentText.x", getProperty("opponent.x")+103)
    setProperty("playerText.x", getProperty("player.x")+103)

    if idleTimer.bf > 1 and not idleTimer.bfDone then 
        idleTimer.bfDone = true
        if not disableBFTextRemove then 
            setTextString("playerText", "...")
        end

    elseif not idleTimer.bfDone  then
        idleTimer.bf = idleTimer.bf + elapsed*pbr
    end

    if idleTimer.dad > 1 and not idleTimer.dadDone then 
        idleTimer.dadDone = true
        if not disableDadTextRemove then 
            setTextString("opponentText", "...")
        end
     
    elseif not idleTimer.dadDone  then
        idleTimer.dad = idleTimer.dad + elapsed*pbr
    end

    if idleTimer.dadDone and not disableDadTextRemove then 
        if dadNoteNear and not disableIsTyping  then 
            cancelTween("opponentTextHide")
            setProperty("opponentText.alpha", 1)
            setTextString("opponentText", opponentTyping)
        else
            setTextString("opponentText", "...")
        end
    end

    if not disableCamLerp then 
        setProperty("camDiscord.zoom", lerp(getProperty("camDiscord.zoom"), camsFollowDefault and getProperty("defaultCamZoom")+0.1 or 1, elapsed*6.875*pbr))
        setProperty("camBDiscord.zoom", lerp(getProperty("camBDiscord.zoom"), camsFollowDefault and (0.5 + ((getProperty("defaultCamZoom")+0.1)/2)) or 1, elapsed*6*pbr))
    end

    if sideSinning then 
        local chanY = continuous_cos(curDecBeat/8) * (getProperty("channels.height")/3.75) - (getProperty("channels.height")/5)
        setProperty("channels.y", lerp(getProperty("channels.y"), chanY , elapsed*8))
        local memY = continuous_cos(curDecBeat/8) * -(getProperty("members.height")/3.75) - (getProperty("members.height")/4)
        setProperty("members.y", lerp(getProperty("members.y"), memY , elapsed*8))
    end

    for i,v in pairs(membersSprites) do
        if string.find(v[2], "/User") then
            setProperty(v[1] .. ".alphaMult", 0.65 + (math.sin(getSongPosition()/200 + i*0.25) * 0.35))
        end
    end
end

function lightingMode(lightMode)
    LightMode = lightMode
    local prefix = (lightMode and "-Light" or "")
    loadGraphic("channels", folder.."ChannelsList"..prefix)
    loadGraphic("members", folder.."MembersListBG"..prefix)
    --setProperty("members.color", getColorFromHex((lightMode and "F2F3F5" or "2B2D31")))
    loadGraphic("message", folder.."messageBar"..prefix)
    loadGraphic("topBar", folder.."topBar"..nopro..prefix)

    local color = (lightMode and "36393F" or "FFFFFF")
    setTextColor("opponentText", color)
    setTextColor("playerText", color)
    setProperty("background.color", getColorFromHex( (lightMode and "FFFFFF" or "36393F")))

    local membersSprites = getProperty("membersSprites")
    for i,v in pairs(membersSprites) do
        loadGraphic(v[1], v[2] .. (lightMode and " L" or ""))
    end

    if MechanicOption and getPropertyFromClass("ClientPrefs", "shaders") then 
        setShaderFloat("colorShader", "saturation", (lightMode and 3 or 1) * (HardMode and 1.25 or 1))
        setShaderFloat("colorShader", "brightness", (lightMode and 3 or 1) * (HardMode and 1.25 or 1))
    end
end

function onStepHit()
    if barBeatPhase == 1 then 
        if curStep % 8 == 6 then 
            doTweenX("channelXMove", "channels", sideBarStuff.channels.x - barIntensity, crochet/1000/2/pbr, "circIn")
        elseif curStep % 8 == 2 then 
            doTweenX("memberXMove", "members", sideBarStuff.members.x + barIntensity, crochet/1000/2/pbr, "circIn")
        end
    end
   
end

function onBeatHit()
    if barBeatPhase == 1 then 
        if curBeat % 2 == 0 then 
            doTweenX("channelXMove", "channels", sideBarStuff.channels.x, crochet/1000*1/pbr, "quadOut")
        else 
            doTweenX("memberXMove", "members", sideBarStuff.members.x, crochet/1000*1/pbr, "quadOut")
        end
    end
    if barBeatPhase == 2 then 
        setProperty("channels.x", sideBarStuff.channels.x - (barIntensity*(curBeat%2==0 and -1 or 1)))
        doTweenX("channelXMove", "channels", sideBarStuff.channels.x, crochet/1000*1/pbr, "quadOut")

        setProperty("members.x", sideBarStuff.members.x + (barIntensity*(curBeat%2==0 and -1 or 1)))
        doTweenX("memberXMove", "members", sideBarStuff.members.x, crochet/1000*1/pbr, "quadOut")

    end
end

function onSectionHit()
    if curBeat % 32 == 0 and not sideSinning then 
        doTweenY("channelYMove", "channels", sideBarStuff.channels.y1, crochet/1000*12/pbr, "sineInOut")
        doTweenY("memberYMove", "members", sideBarStuff.members.y1, crochet/1000*12/pbr, "sineInOut")
    elseif curBeat % 32 == 16 and not sideSinning then 
        doTweenY("channelYMove", "channels", sideBarStuff.channels.y2, crochet/1000*12/pbr, "sineInOut")
        doTweenY("memberYMove", "members", sideBarStuff.members.y2, crochet/1000*12/pbr, "sineInOut")
    end
    if not disableCamLerp then 
        setProperty("camDiscord.zoom", getProperty("camDiscord.zoom") + 0.02)
        setProperty("camBDiscord.zoom", getProperty("camBDiscord.zoom") + 0.04)
    end
end

function onEvent(eventName, value1, value2)
    if eventName == "Add Camera Zoom" then 
        local intensity = tonumber(value2 or 0.04) or 0.04
        local intensity2 = tonumber(value2 or 0.02) or 0.02
        setProperty('camBDiscord.zoom', getProperty("camBDiscord.zoom") + intensity)
        setProperty('camDiscord.zoom', getProperty("camDiscord.zoom") + intensity2)
    end
end

function goodNoteHit(id, dir, type, sus)
    messageType(id, dir, sus, true)
end

function opponentNoteHit(id, dir, type, sus)
    messageType(id, dir, sus, false)
end

--TASK: Make optimized and cleaner message (FINISHED)
lastStrumTime = {-999, -999}
latestNotePress = {player = -999, opponent = -999}
vocalType = {player = 1, opponent = 1} -- aaa, eee, ooo, eeh
function messageType(id ,direction, isSustainNote, isPlayer) 
    --Implement variables
    local notePressTime = isPlayer and latestNotePress.player or latestNotePress.opponent
    local doubleNote = isPlayer and notePressTime == getPropertyFromGroup("notes", id, "strumTime")
    local textName = isPlayer and 'playerText' or 'opponentText'
    local plrOrOpp = isPlayer and 'player' or 'opponent'
    local quickNote = false -- CHECK IF CHARACTER SING FAST (NEW!)
    local chatIsEmpty = false

    -- Set Note time on Double Note Time Checker
    latestNotePress[plrOrOpp] = getPropertyFromGroup("notes", id, "strumTime")

    if doubleNote then return; end -- NO DOUBLE NOTE!!

    if getPropertyFromGroup("notes", id, 'nextNote') ~= nil then
        local timeDifferent = math.abs(getPropertyFromGroup("notes", id, 'strumTime') - getPropertyFromGroup("notes", id, 'nextNote.strumTime'))
        if not (isSustainNote or getPropertyFromGroup("notes", id, 'nextNote.isSustainNote')) and 
        timeDifferent <= (stepCrochet*1.5) then
            quickNote = true
        end
    end

    -- What Text is '...' = become ''
    if (isPlayer and idleTimer.bfDone) or (not isPlayer and idleTimer.dadDone) then 
        setTextString(textName, "")
        chatIsEmpty = true
    end
    if isPlayer then idleTimer.bf = 0 idleTimer.bfDone = false
    else idleTimer.dad = 0 idleTimer.dadDone = false end

    -- Note data Vocal Type
    vocalType[plrOrOpp] = getPropertyFromGroup("notes", id, "singData")+1
    if vocalType[plrOrOpp] == nil or vocalType[plrOrOpp] <= 0 then vocalType[plrOrOpp] = 1 end

    -- Start Output
    if not disableBFTextTyping then 
        if getProperty(textName..".textField.numLines") > 6 then setTextString(textName, "") end
        local isSustainEnd = not getPropertyFromGroup("notes",id,"nextNote.isSustainNote") and getPropertyFromGroup("notes",id, "isSustainNote")

        local textEnding = (isSustainEnd and 3 or (isSustainNote and 2 or 1))
        local text = vocals[isPlayer and 2 or 1][vocalType[plrOrOpp]][textEnding]

        text = textEnding ~= 2 and (text[getRandomInt(1, #text)]) or text
        if textEnding == 1 and quickNote then
            text = string.sub(text, 1, #text / 2)
        end
        if not isPlayer and (songName:lower() == 'shut-up' or opponentCaps) then
            text = text:upper()
        end
        setTextString(textName, getTextString(textName)..((chatIsEmpty or isSustainNote) and "" or " ")..text)
    end
end

function onTweenCompleted(tag)
    if tag == "playerTextHide" then 
        setTextString("playerText", "...")
        setProperty("playerText.alpha", 1)
    end
    if tag == "opponentTextHide" then 
        setTextString("opponentText", "...")
        setProperty("opponentText.alpha", 1)
    end
end

function makeCam()
    runHaxeCode([[
        camDiscord = new FlxCamera();
        camDiscord.bgColor = 0xF;
        camBDiscord = new FlxCamera();
        camBDiscord.bgColor = 0xF;

        FlxG.cameras.remove(game.camHUD, false);
        FlxG.cameras.remove(game.camOther, false);

        FlxG.cameras.add(camBDiscord, false);
        FlxG.cameras.add(camDiscord, false);

        FlxG.cameras.add(game.camHUD, false);
        FlxG.cameras.add(game.camOther, false);

        game.variables.set("camBDiscord", camBDiscord);
        game.variables.set("camDiscord", camDiscord);
    ]])
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
    setScrollFactor(tag, 0 ,0)
    addLuaSprite(tag, true)
    if tabler.xSize ~= null then
        scaleObject(tag, tabler.xSize or 1, tabler.ySize or tabler.xSize or 1)
    end
    setObjectCameraCustom(tag, tabler.cam or "game.camGame")
end

function makeText(tabler)
    local tag = tabler.tag or "teg"
   makeLuaText(tag, tabler.text or tag, tabler.width or 0, tabler.x or 0, tabler.y or 0)
   setScrollFactor(tag, 0 ,0)
   addLuaText(tag)

   setTextFont(tag, fontName)
   setTextAlignment(tag, 'left')
   setTextBorder(tag, 0, "0x00000000")
   setTextSize(tag, 24)
   setProperty(tag..".antialiasing", getPropertyFromClass("ClientPrefs", "globalAntialiasing"))
   setObjectCameraCustom(tag, tabler.cam or "game.camHUD")
   setProperty(tag..".borderQuality", 0)
end

function nearNotes(_timeNear, mustPress)
    local timeNear = _timeNear
    for i = getProperty("notes.length")-1, 0, -1 do 
        local at = getPropertyFromGroup("notes",i,"strumTime") - getSongPosition()
        if at < timeNear and at > -50 and getPropertyFromGroup("notes",i,"mustPress") == mustPress then 
            return true
        end
    end
    return false
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
            resetCamCache(camDiscord.flashSprite);
            resetCamCache(camBDiscord.flashSprite);
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
function lerp(a, b, t) return a + (b - a) * t end
function continuous_cos(x) return math.cos((x % 1) * 2*math.pi) end