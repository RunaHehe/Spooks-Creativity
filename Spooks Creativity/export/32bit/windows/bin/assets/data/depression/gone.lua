local pauses = {
    {648, false},
    {651, false},
    {654, false},
    {656, true},
    
    {664, false},
    {667, false},
    {670, false},
    {672, true},

    {680, false},
    {683, false},
    {686, false},
    {688, true},

    {712, false},
    {715, false},
    {718, false},
    {720, true},

    {728, false},
    {731, false},
    {734, false},
    {736, true},

    {744, false},
    {747, false},
    {750, false},
    {752, true},

    {768, false},
    {772, false},
    {776, false},
    {780, false},
    {784, true},


    {1240, false},
    {1243, false},
    {1246, false},
    {1248, true},

    {1256, false},
    {1259, false},
    {1262, false},
    {1264, true},

    {1272, false},
    {1275, false},
    {1278, false},
    {1280, true},

    {1288, false},
    {1291, false},
    {1294, false},
    {1296, true},

    {1304, false},
    {1307, false},
    {1310, false},
    {1312, true},

    {1320, false},
    {1323, false},
    {1326, false},
    {1328, true},

    {1336, false},
    {1339, false},
    {1342, false},
    {1344, true},

    {1352, false},
    {1355, false},
    {1358, false},
    {1360, true},

    -- enemy only
    {1496, false},
    {1499, false},
    {1502, false},
    {1504, true},

    {1512, false},
    {1515, false},
    {1518, false},
    {1520, true},

    {1528, false},
    {1531, false},
    {1534, false},
    {1536, true},

    {1544, false},
    {1547, false},
    {1550, false},
    {1552, true},

    --players

    {1560, false},
    {1563, false},
    {1566, false},
    {1568, true},

    {1576, false},
    {1579, false},
    {1582, false},
    {1584, true},

    {1592, false},
    {1595, false},
    {1598, false},
    {1600, true},
}

pingID = 0
pings = {}
draining = false


local songSpeed = 1;
function onCreatePost()
    luaDebugMode = true
    MechanicOption = not EasyMode and Mechanic
    shadersOption = getPropertyFromClass("ClientPrefs", "shaders")

    songSpeed = getProperty('songSpeed')

    setProperty('spawnTime', 3500)

    if shadersOption then 
        initLuaShader("Glitching")
        initLuaShader("OldTV")
        makeLuaSprite("oldTvEffect", "", 0, 0)
        setSpriteShader("oldTvEffect", "OldTV")
    end

    precacheImage("ChannelsListRaid")
    precacheImage("ChannelsListRaid-Light")
    precacheImage("EveryPing")
    precacheImage("chars/Deleted User Dark")

    if Mechanic then 
        for i = 0, getProperty("unspawnNotes.length")-1 do
            local strumTime = getPropertyFromGroup("unspawnNotes",i,"strumTime")

            if strumTime < 19200 then 
                setPropertyFromGroup("unspawnNotes",i,"multSpeed", 0.5)
            end

            if strumTime >= 58200 and strumTime < 67800 then 
                setPropertyFromGroup("unspawnNotes",i,"multSpeed", 0.5)
            end
            if strumTime >= 67800 and strumTime < 82200 then 
                setPropertyFromGroup("unspawnNotes",i,"multSpeed", 0.85)
            end

            if strumTime >= 130800 and strumTime < 150000 then 
                setPropertyFromGroup("unspawnNotes",i,"multSpeed", 0.8)
            end
            if strumTime >= 150000 and strumTime < 169200 then 
                setPropertyFromGroup("unspawnNotes",i,"multSpeed", 0.6)
            end

            if not EasyMode and strumTime >= 58200 and strumTime < 82200 and not getPropertyFromGroup("unspawnNotes",i,"isSustainNote") then 
                setPropertyFromGroup("unspawnNotes",i,"copyAngle", false)
                setPropertyFromGroup("unspawnNotes",i,"angle", 90 * getRandomInt(0, 3))
            end
        end
    end
    loadGraphic("opponent", "chars/Deleted User")
    loadGraphic("player", "chars/Annoying User")

    setGraphicSize("player", 649 * 0.625, 146 * 0.625)
    setGraphicSize("opponent", 649 * 0.625, 146 * 0.625)


    makeAnimatedLuaSprite('vintage', 'vintage', -200, -350)
    scaleObject('vintage', 3, 3)
    addAnimationByPrefix('vintage', 'idle', 'idle', 16, true)
    playAnim('vintage', 'idle', true)
    setBlendMode('vintage', 'lighten')
    setObjectCamera('vintage', 'hud')
    setProperty('vintage.alpha', 0)
    addLuaSprite('vintage', true)

    makeLuaSprite("shout", 'ammarShout', 0, 0)
    addLuaSprite('shout', true)
    screenCenter('shout')
    setObjectCamera('shout', 'hud')
    setObjectOrder('shout', 5)
    setProperty('shout.y', getProperty('shout.y') - 600)
   -- runHaxeCode("game.getLuaObject('shout').camera = game.camHUD;")

    setProperty('camGame.visible', false)

    if shadersOption then 
        setSpriteShader("opponent", "Glitching")
        setSpriteShader('opponentStrums.members[0]', 'Glitching')
        setSpriteShader('opponentStrums.members[1]', 'Glitching')
        setSpriteShader('opponentStrums.members[2]', 'Glitching')
        setSpriteShader('opponentStrums.members[3]', 'Glitching')

        setShaderFloat("opponent", "iTime", 0)
    end

    setGlobalFromScript("stages/discordStage", "opponentTyping", "(Who is Typing...)")

    setProperty("dad.healthIcon", "depress")
    setProperty("boyfriend.healthIcon", "annoyer")
    runHaxeCode([[
        game.iconP2.changeIcon("icon-depress");
        game.iconP1.changeIcon("icon-annoyer");
      ]])
      
     setHealthBarColors("CC57ED", "ffc400") -- dad, bf

     setProperty("defaultCamZoom", 2)
end


function onUpdate(elapsed)
    if MechanicOption then 
        for i = 0, getProperty("notes.length")-1 do 
            local strum = getPropertyFromGroup("notes",i,"strumTime")
            local copyY = getPropertyFromGroup("notes",i,"copyY")
            if ((strum < 19200) or (strum >= 82200 and strum < 130800) or (strum >= 150000)) and copyY then 
                local progress = (getPropertyFromGroup("notes",i,"strumTime") - getSongPosition()) * 0.9
                local sus = getPropertyFromGroup("notes",i,"isSustainNote")
                local speed = getPropertyFromGroup("notes",i,"multSpeed")
                local speeds = songSpeed*speed
                local offsetY = (-progress*speeds) + (1300)
            
                if offsetY > 0 then 
                    offsetY = 0
                    setPropertyFromGroup("notes",i,"multAlpha", sus and 0.6 or 1)
                    if sus then 
                        setPropertyFromGroup("notes",i,"flipY", downscroll)
                    end
                else 
                    if strum >= 111000 and strum < 120800 then 
                        setPropertyFromGroup("notes",i,"multAlpha", 0.25)
                    else 
                        setPropertyFromGroup("notes",i,"multAlpha", 0.5)
                    end
                    if sus then 
                        setPropertyFromGroup("notes",i,"flipY", not downscroll)
                    end
                end
                setPropertyFromGroup("notes",i,"offsetY", offsetY*(downscroll and -1 or 1))
            end
        end
    end
    if curStep >= 2016 and curStep < 2272 then 
        setProperty("healthBar.angle", getRandomFloat(-3, 3, '0'))
        setProperty("healthBarBG.angle", getRandomFloat(-3, 3, '0'))
        setProperty("iconP1.angle", getRandomFloat(-5, 5, '0'))
        setProperty("iconP2.angle", getRandomFloat(-5, 5, '0'))
        setProperty("scoreText.angle", getRandomFloat(-5, 5, '0'))
        setProperty("rateText.angle", getRandomFloat(-5, 5, '0'))
        setProperty("missText.angle", getRandomFloat(-5, 5, '0'))
        setProperty("comboText.angle", getRandomFloat(-5, 5, '0'))
    end

    if #pauses > 0 and MechanicOption then 
        if curStep >= pauses[1][1]  then 
            for i = 0, getProperty("notes.length")-1 do 
                setPropertyFromGroup("notes",i,"copyY", true)
                
            end
            for i = 0, getProperty("unspawnNotes.length")-1 do 
                setPropertyFromGroup("unspawnNotes",i,"copyY", true)
            end
            cancelTimer('noteUnableMove')
            if pauses[1][2] == false then 
                runTimer("noteUnableMove", 0.05)
            end
            table.remove(pauses, 1)
        end
    end

    if shadersOption then 
        if curStep >= 256 and curStep < 2272 then
            setShaderFloat("opponent", "iTime", os.clock()%100)
        end
        setShaderFloat("oldTvEffect", "iTime", os.clock()%100)
    end

    if #pings > 0 then
        for i,v in pairs(pings) do
            if v.ended == false then
                setProperty(v.tag..".x", v.midX + math.sin((getProperty(v.tag..".y")*0.02))*50)
                if getProperty(v.tag..".y") <= -100 then
                    v.ended = true
                end 
            end
        end
        
    end
        
end

function onStepEvent(curStep)
    if curStep == 128 then 
        doTweenAlpha("vintage", "vintage", 0.3, 5)
    end
    if curStep == 1108 then
        doTweenY('shout', 'shout', getProperty('shout.y') + 600, 0.75, 'quadOut')
    end
    if curStep == 1156 then
        doTweenY('shout', 'shout', getProperty('shout.y') + 600, 0.75, 'quadIn')
    end
    if curStep == 1104 then
        for i = 0,7 do
            setPropertyFromGroup("strumLineNotes", i, "angle", 0)
        end
    end
    if curStep == 256 then 
        if shadersOption then 
            runHaxeCode([[
                camDiscord.setFilters([new ShaderFilter(game.getLuaObject("oldTvEffect").shader)]);
                camBDiscord.setFilters([new ShaderFilter(game.getLuaObject("oldTvEffect").shader)]);
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("oldTvEffect").shader)]);
            ]])
        end
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x90FFFFFF", 2)

        setGlobalFromScript("stages/discordStage", "sideSinning", true)
        cancelTween('channelYMove')
        cancelTween('memberYMove')
        loadGraphic("channels", "ChannelsListRaid")
    end
    if curStep == 784 then --- Ammar turn
        setProperty("boyfriend.healthIcon", "ammar"..(CuteMode and 'cute' or ''))
        runHaxeCode([[
            game.iconP1.changeIcon("icon-ammar]]..(CuteMode and 'cute' or '')..[[");
        ]])
        setHealthBarColors("CC57ED", "60f542") -- dad, bf
        loadGraphic("player", "chars/Ammar")
        setGraphicSize("player", 649 * 0.625, 146 * 0.625)

        cameraFlash("HUD", "FFFFFF", 1)

        setTextString("playerText", "")
        
    end
    if curStep == 1104 then
        setProperty("boyfriend.healthIcon", "annoyer")
        setProperty("dad.healthIcon", "depression")
        runHaxeCode([[
            game.iconP1.changeIcon("icon-annoyer");
            game.iconP2.changeIcon("icon-depression");
        ]])

        setHealthBarColors("CC57ED", "ffc400") -- dad, bf 
        loadGraphic("player", "chars/Annoying User")
        setGraphicSize("player", 649 * 0.625, 146 * 0.625)

        setTextString("playerText", "...")
        draining = true
    end
    if curStep+1 == 384 or curStep+1 == 1104 then 
        setGlobalFromScript("stages/discordStage", "barBeatPhase", 2)
        setGlobalFromScript("stages/discordStage", "sideSinning", false)
    end
    if curStep+1 == 512 then 
        setGlobalFromScript("stages/discordStage", "barBeatPhase", 1)
        setGlobalFromScript("stages/discordStage", "barIntensity", 25)
    end
    if curStep+1 == 768 then 
        setGlobalFromScript("stages/discordStage", "barBeatPhase", 2)
        setGlobalFromScript("stages/discordStage", "barIntensity", 10)
    end
    if curStep+1 == 784 or curStep+1 == 1616 then 
        setGlobalFromScript("stages/discordStage", "barBeatPhase", 1)
        setGlobalFromScript("stages/discordStage", "barIntensity", 16)
    end

    if curStep == 384 or curStep == 1104 or curStep == 2016 then 
        callScript("stages/discordStage", "lightingMode", {true})
        cameraFlash("camHUD", "FFFFFF", 1)

        if curStep == 1104 or curStep == 2016 then
            loadGraphic("channels", "ChannelsListRaid-Light")
        end
        loadGraphic("opponent", "chars/Deleted User Dark")
        setGraphicSize("opponent", 649 * 0.625, 146 * 0.625)
    end
    if curStep == 512 or curStep == 1360 or curStep == 2272 then 
        callScript("stages/discordStage", "lightingMode", {false})
        cameraFlash("camHUD", "FFFFFF", 1)

        if curStep == 1360 then
            setGlobalFromScript("stages/discordStage", "sideSinning", true)
            cancelTween('channelYMove')
            cancelTween('memberYMove')
            loadGraphic("channels", "ChannelsListRaid")
        end
        loadGraphic("opponent", "chars/Deleted User")
        setGraphicSize("opponent", 649 * 0.625, 146 * 0.625)
    end

    if curStep == 1632 then 
        setGlobalFromScript("stages/discordStage", "sideSinning", false)
        loadGraphic("channels", "ChannelsList")
        cameraFlash("camHUD", "FFFFFF", 1)
    end

    if curStep == 1760 then 
        cameraFlash("camHUD", "FFFFFF", 1)
        
        if shadersOption then 
            setSpriteShader("opponentText", "Glitching")
            runHaxeCode([[
                camDiscord.setFilters([new ShaderFilter(game.getLuaObject("oldTvEffect").shader), new ShaderFilter(game.getLuaObject("opponent").shader)]);
            ]])
        end

        setGlobalFromScript("stages/discordStage", "sideSinning", true)
        cancelTween('channelYMove')
        cancelTween('memberYMove')
    end

    if curStep == 2016 then 
        cameraFlash("camHUD", "FFFFFF", 1, true)
    end

    if curStep == 2272 then 
        setGlobalFromScript("stages/discordStage", "sideSinning", false)
        cameraFlash("camHUD", "FFFFFF", 2)
        setGlobalFromScript("stages/discordStage", "barBeatPhase", 0)

        setProperty("opponent.visible", false)
        setProperty("opponentText.visible", false)
        setProperty("vintage.alpha", 0.6)

        if shadersOption then 
            runHaxeCode([[
                camDiscord.setFilters([]);
                camBDiscord.setFilters([]);
                game.camHUD.setFilters([]);
            ]])
        end

        setProperty("healthBar.angle", 0)
        setProperty("healthBarBG.angle", 0)
        setProperty("iconP1.angle", 0)
        setProperty("iconP2.angle", 0)
        setProperty("scoreTxt.angle", 0)
        setProperty("rateText.angle", 0)
        setProperty("missText.angle", 0)
        setProperty("comboText.angle", 0)

        setHealthBarColors("000000", "ffc400") 
        setProperty("iconP2.visible", false)
        setShaderFloat("opponent", "iTime", 0)
    end
end

function onStepHit()
    if curStep >= 256 and curStep < 384 and curStep%16==0 then 
        triggerEvent("Add Camera Zoom", "0.03", "0.06")
    end
    if curStep >= 512 and curStep < 640 and curStep%4==0 then 
        triggerEvent("Add Camera Zoom", "", "")
    end
    if curStep >= 384 and curStep < 496 and curStep%4==0 then 
        triggerEvent("Add Camera Zoom", "", "")
    end
    if curStep >= 1104 and curStep < 1232 and curStep%4==0 then 
        triggerEvent("Add Camera Zoom", "", "")
    end
    if curStep >= 1360 and curStep < 1488 and curStep%4==0 then 
        triggerEvent("Add Camera Zoom", "", "")
    end

    if (curStep >= 2128 and curStep+16 < 2272) and curStep % 2 == 0 then
        spawnPing(4)
    end
end

function onBeatHit()
    if (curStep >= 512 and curStep+8 < 640) or (curStep >= 1104 and curStep+8 < 1360) or (curStep >= 2016 and curStep+8 < 2128) then
        spawnPing(4)
    end

    if #pings > 0 then
        for i,v in pairs(pings) do
            if not v.ended and (curBeat%2==0 and v.id%2==0) or (curBeat%2==1 and v.id%2==1) then 
                setProperty(v.tag..".alpha", 1)
                doTweenAlpha(v.tag.."alphaBeat", v.tag, 0.4, crochet/1000 * (HardMode and 1.25 or 1))
            end
        end 
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == "noteUnableMove" then 
        for i = 0, getProperty("notes.length")-1 do 
            local player = getPropertyFromGroup("notes",i,"mustPress")
            if (curStep >= 1496 and curStep < 1552 and not player) or (curStep >= 1560 and curStep < 1600 and player) or (curStep < 1496) then 
                setPropertyFromGroup("notes",i,"copyY", false)
            end
        end
        for i = 0, getProperty("unspawnNotes.length")-1 do 
            local player = getPropertyFromGroup("unspawnNotes",i,"mustPress")
            if (curStep >= 1496 and curStep < 1552 and not player) or (curStep >= 1560 and curStep < 1600 and player) or (curStep < 1496) then 
                setPropertyFromGroup("unspawnNotes",i,"copyY", false)
            end
        end
    end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
    if curStep >= 784 and curStep < 1104 and not isSustainNote then
        setPropertyFromGroup("strumLineNotes", noteData+4, "angle", getPropertyFromGroup("notes", id, "angle"))
    end
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)
    if curStep >= 784 and curStep < 1104 and not isSustainNote then
        setPropertyFromGroup("strumLineNotes", noteData, "angle", getPropertyFromGroup("notes", id, "angle"))
    end
    if draining and MechanicOption then
        if not isSustainNote then
            addHealth(HardMode and -0.016 or 0.01)
        else
            addHealth(HardMode and -0.004 or 0.003)
        end
    end
end

function spawnPing(duration)
    if EasyMode or not Mechanic then return end
    pingID = pingID + 1

    local tag = "everyonePing"..pingID
    local recycle = false
    if #pings > 0 then
        for i, v in pairs(pings) do
            if v.ended then
                recycle = true
                tag = v.tag
                v.ended = false
                pingID = pingID - 1
                setProperty(tag..'.y', 750)
                setProperty(tag..'.x', 0)
                break
            end
        end
    end
    if not recycle then
        makeLuaSprite(tag, "EveryPing", 0, 750)
        setObjectCamera(tag, "hud")
        scaleObject(tag, 1.2, 1.2)
        screenCenter(tag, "x")
        addLuaSprite(tag)
        if not HardMode then
            setBlendMode(tag, 'overlay')
        end
    end
    setProperty(tag..".alpha", 0.4)
    setObjectOrder(tag, getObjectOrder("notes")+(MechanicOption and 5 or -5))

    doTweenY(tag, tag, -100, duration)

    if not recycle then
        table.insert(pings, {tag = tag, id = pingID, midX = getProperty(tag..".x"), ended = false})
    end

end