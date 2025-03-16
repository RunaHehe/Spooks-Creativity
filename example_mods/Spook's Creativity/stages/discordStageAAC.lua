

fontName = "Discord/ggsans-Medium.ttf"
dancingPanel = false
folder = "discord/"

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

lastStrumTime = {-999, -999}

vocals = {
    {{{"ee"}, "e", {''}}, {{"oo"}, "o", {''}}, {{"aa"}, "a", {"h"}}, {{"e"}, "e", {"h"}}}, -- dad, eee, ooo ,aaa ,e
    {{{"ee"}, "e", {''}}, {{"oo"}, "o", {''}}, {{"aa"}, "a", {"h"}}, {{"e"}, "e", {"h"}}} -- player, eee, ooo ,aaa ,e
}

local membersSprites = {}

function onCreate()
    setProperty("introSoundsSuffix", "-discord")
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
        precacheImage(folder.."MembersList2B")
        precacheImage(folder.."MembersList2B-Light")
        precacheImage(folder.."Boy")
        precacheImage(folder.."MembersList2-Light")
    end

    opponentTyping = songName:lower() == "shut-up" and "(Random Girl is MAD...)" or opponentTyping
    opponentCaps = songName:lower() == "shut-up"
    barIntensity = songName:lower() == "shut-up" and 30 or barIntensity
    

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
    
    makeSpr({tag = "topBar", image = folder.."topBar", y = 0, cam = "camDiscord",  xSize = 1.05})
    screenCenter("topBar", "X")

    makeSpr({tag = "message", image = folder.."messageBar", y = 640, cam = "camDiscord"})
    screenCenter("message", "X")

    --characters!!!!! 

    local xx = 320
    local tw = 505
    makeText({tag = "opponentText", text = "...", cam = "camBDiscord", width = tw})
    makeSpr({tag = "opponent", image = folder..(songName:lower() == "shut-up" and "chars/Random Girl" or "chars/Ammar"), x = xx, y = 100, cam = "camBDiscord", xSize = (songName:lower() == "shut-up" and 0.625 or 0.625)})

    makeText({tag = "playerText", text = "...", cam = "camBDiscord", width = tw})
    makeSpr({tag = "player", image = folder.."chars/Annoying User", x = xx, y = 300, cam = "camBDiscord", xSize = 0.625})

    setGraphicSize("opponent", 649 * 0.625, 146 * 0.625)
    setGraphicSize("player", 649 * 0.625, 146 * 0.625)

   pbr = getProperty("playbackRate")
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

   setProperty("camGame.visible")
end

function setupMembers()
    local members = {"Ammar", "Ams", "An Ammar Plumber", "Annoyer", "Asser", "Danny14", "IdiotXD", "NotAlpha", "Pakachi", "Professor", "Random Girl", "Random", "Sirnotify", "Spook", "Swordsy", "Tabbee", "Vander", "Virus"}
    
    addHaxeLibrary("AttachedSprite")
    addHaxeLibrary("AttachedFlxText", "editors.ChartingState")
    addHaxeLibrary("FlxRect", "flixel.math")
    addHaxeLibrary("Paths", "")
    addHaxeLibrary("Std")
    runHaxeCode "setVar('memberList', [])"
    runHaxeCode "setVar('membersSprites', [])"


    if string.gsub(songName:lower(), " ", "-") == "discord-annoyer" then
        setProperty("memberList", {"Ammar", "Ams", "An Ammar Plumber", "Annoyer", "Asser", "Danny14", "IdiotXD", "NotAlpha", "Tabbee", "Vander"})
    else
        setProperty("memberList", members)
    end

    runHaxeCode([[
        var memberList = getVar('memberList');
        var memberPlace = game.getLuaObject("members");
        var memberOrder = [];

        memberList.sort(function(a:String, b:String):Int {
            a = a.toUpperCase();
            b = b.toUpperCase();
          
            if (a < b) {
              return -1;
            }
            else if (a > b) {
              return 1;
            } else {
              return 0;
            }
          });

        //var ttest = new AttachedFlxText(50, 50, 0, "test test", 16);
        //ttest.camera = game.camHUD;
        //game.add(ttest);
        var membersSprites = [];

        var modList = ["Professor", "Sirnotify"];
        var boosterList = ["Tabbee"];
        var ownerList = ["Ammar"];
        var updateMemberList = [];
        for (i in ownerList) {
            if (memberList.contains(i))
                updateMemberList.push(i);
        }
        for (i in modList) {
            if (memberList.contains(i))
                updateMemberList.push(i);
        }
        for (i in boosterList) {
            if (memberList.contains(i))
                updateMemberList.push(i);
        }
        for (i in memberList) {
            if (!updateMemberList.contains(i))
                updateMemberList.push(i);
        }

        if (updateMemberList.length <= 12) {
            for (i in 0...(17 - updateMemberList.length)) {
                updateMemberList.push("User" + FlxG.random.int(1, 3));
            }
        }

        var indexNum = 0;
        var space = 40;
        var offsetX = 7;
        var categoryXOff = 16 + offsetX;
        for (memberName in updateMemberList) {
            if (memberName == "Ammar") { //Owner
                space += 40;
            } else if (memberName == "Professor"){  //Mod
                space += 40;
            } else if (memberName == "Tabbee")  //Booster
                space += 40;
            else if (memberName == "Ams")  //Members
                space += 40;
            

            var member = new AttachedSprite('discord/members/'+memberName);
            member.setGraphicSize(Std.int(member.width * 0.75));
            member.updateHitbox();
            member.yAdd = indexNum * 66 + space;
            member.xAdd = offsetX;
            member.camera = camDiscord;
            game.add(member);
            member.sprTracker = memberPlace;
            indexNum += 1;
            memberOrder.push(memberName);
            Paths.image('discord/members/'+memberName+" L");

            game.variables.set("s-"+memberName+indexNum, member);
            membersSprites.push(["s-"+memberName+indexNum, 'discord/members/'+memberName, false]);


            if (memberName == "Ammar") { //Owner
                var category = new AttachedSprite('discord/category/Content Creator');
                category.setGraphicSize(Std.int(category.width * 0.75));
                category.updateHitbox();
                category.yAdd = member.yAdd - 18;
                category.xAdd = categoryXOff;
                category.camera = camDiscord;
                game.add(category);
                category.sprTracker = memberPlace;
                Paths.image('discord/category/Content Creator L');

                game.variables.set("c-contentcreator", category);
                membersSprites.push(["c-contentcreator", 'discord/category/Content Creator', true]);

            } else if (memberName == "Professor"){  //Mod
                var category = new AttachedSprite('discord/category/Moderator');
                category.setGraphicSize(Std.int(category.width * 0.75));
                category.updateHitbox();
                category.yAdd = member.yAdd - 18;
                category.xAdd = categoryXOff;
                category.camera = camDiscord;
                game.add(category);
                category.sprTracker = memberPlace;
                Paths.image('discord/category/Moderator L');

                game.variables.set("c-moderator", category);
                membersSprites.push(["c-moderator", 'discord/category/Moderator', true]);
            } else if (memberName == "Tabbee"){  //Booster
                var category = new AttachedSprite('discord/category/Server Booster');
                category.setGraphicSize(Std.int(category.width * 0.75));
                category.updateHitbox();
                category.yAdd = member.yAdd - 18;
                category.xAdd = categoryXOff;
                category.camera = camDiscord;
                game.add(category);
                category.sprTracker = memberPlace;
                Paths.image('discord/category/Server Booster L');

                game.variables.set("c-booster", category);
                membersSprites.push(["c-booster", 'discord/category/Server Booster', true]);
            } else if (memberName == "Ams") { //Members
                var category = new AttachedSprite('discord/category/Member');
                category.setGraphicSize(Std.int(category.width * 0.75));
                category.updateHitbox();
                category.yAdd = member.yAdd - 18;
                category.xAdd = categoryXOff;
                category.camera = camDiscord;
                game.add(category);
                category.sprTracker = memberPlace;
                Paths.image('discord/category/Member L');

                game.variables.set("c-member", category);
                membersSprites.push(["c-member", 'discord/category/Member', true]);
            }
            
            
        }
        setVar('membersSprites', membersSprites)
    ]])

    membersSprites = getProperty("membersSprites")
end

function onUpdate(elapsed)
    if inGameOver then return end
    dadNoteNear = nearNotes(1000, false)
    bfNoteNear = nearNotes(1000, true)

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
    loadGraphic("topBar", folder.."topBar"..prefix)

    local color = (lightMode and "36393F" or "FFFFFF")
    setTextColor("opponentText", color)
    setTextColor("playerText", color)
    setProperty("background.color", getColorFromHex( (lightMode and "FFFFFF" or "36393F")))

    local membersSprites = getProperty("membersSprites")
    for i,v in pairs(membersSprites) do
        loadGraphic(v[1], v[2] .. (lightMode and " L" or ""))
    end

        setShaderFloat("colorShader", "saturation", (lightMode and 3 or 1))
        setShaderFloat("colorShader", "brightness", (lightMode and 3 or 1))
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
    local dontSing = lastStrumTime[2] == getPropertyFromGroup("notes", id, "strumTime")

    local empty = false
    if idleTimer.bfDone then 
        setTextString("playerText", "")
        empty = true
    end
    idleTimer.bf = 0
    idleTimer.bfDone = false

    if not dontSing then 
        local time = getPropertyFromGroup("notes", id, "strumTime")+1
        local data = 1
        local isFound = false
        for i,v in pairs(vocalsNotes.bf) do 
            if v.time <= time then 
                data = v.data + 1
                isFound = true
                --table.remove(vocalsNotes.bf, i)
                break
            end
        end

        if isFound then 
            bfNumVocal = data
        end
    else 
        --debugPrint("DOUBLE")
    end

    lastStrumTime[2] = getPropertyFromGroup("notes", id, "strumTime")

    if not disableBFTextTyping and not dontSing then 
        if getProperty("playerText.textField.numLines") > 6 then 
            setTextString("playerText", "")
        end
        local isEnd = not getPropertyFromGroup("notes",id,"nextNote.isSustainNote") and getPropertyFromGroup("notes",id, "isSustainNote")
        local text = vocals[2][bfNumVocal][(isEnd and 3 or (sus and 2 or 1))]
        text = (isEnd or not sus) and (text[getRandomInt(1, #text)]) or text
        setTextString("playerText", getTextString("playerText")..((empty or sus) and "" or " ")..text)
    end
end

function opponentNoteHit(id, dir, type, sus)
    local dontSing = lastStrumTime[1] == getPropertyFromGroup("notes", id, "strumTime")

    local empty = false
    if idleTimer.dadDone then 
        setTextString("opponentText", "")
        empty = true
    end
    idleTimer.dad = 0
    idleTimer.dadDone = false

    if not dontSing then 
        local time = getPropertyFromGroup("notes", id, "strumTime")+1
        local data = 1
        local isFound = false
        for i,v in pairs(vocalsNotes.dad) do 
            if v.time <= time  then 
                data = v.data + 1
                isFound = true
                --table.remove(vocalsNotes.dad, i)
                break
            end
        end
        if isFound then 
            dadNumVocal = data
        end
    end

    lastStrumTime[1] = getPropertyFromGroup("notes", id, "strumTime")

    if not disableDadTextTyping and not dontSing then 
        if getProperty("opponentText.textField.numLines") > 6 then 
            setTextString("opponentText", "")
        end
        local isEnd = not getPropertyFromGroup("notes",id,"nextNote.isSustainNote") and getPropertyFromGroup("notes",id, "isSustainNote")
        local text = vocals[1][dadNumVocal][(isEnd and 3 or (sus and 2 or 1))]
        text = (isEnd or not sus) and (text[getRandomInt(1, #text)]) or text
        text = opponentCaps and text:upper() or text
        setTextString("opponentText", getTextString("opponentText")..((empty or sus) and "" or " ")..text)
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
function lerp(a, b, t) return a + (b - a) * t end
function continuous_cos(x) return math.cos((x % 1) * 2*math.pi) end