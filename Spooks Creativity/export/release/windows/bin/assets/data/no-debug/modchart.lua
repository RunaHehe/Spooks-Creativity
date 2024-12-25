songStart = false
defaultPosition = {}
centerPosition = {418, 530, 642, 754       ,88, 200, 977, 1089}
downPosition = {570 , 50} -- down, up

sustainOffset = 0

local mechanic = true
function onCreatePost()
    mechanic = not EasyMode and Mechanic
    makeLuaSprite("noteOffset")
    makeLuaSprite("noteAlpha")
    setProperty("noteAlpha.alpha", 1)
    for i = 0, getProperty("unspawnNotes.length")-1 do
        if getPropertyFromGroup("unspawnNotes",i,"isSustainNote") then
            sustainOffset = getPropertyFromGroup("unspawnNotes",i,"offsetX")
            break;
        end
    end
   
end

function onCountdownStarted()
    if not EasyMode and Mechanic and not HardMode and not EasyMode then
        for i = 0, 3 do 
            setPropertyFromGroup("strumLineNotes", i, "visible", false)
        end
    end
end


function onSongStart()
    for i = 0,7 do
        table.insert(defaultPosition, {
            x = getPropertyFromGroup("strumLineNotes", i, "x"), 
            y = getPropertyFromGroup("strumLineNotes", i, "y")})

        if mechanic and not HardMode then
            if i < 4 then
                setPropertyFromGroup("strumLineNotes", i, "x", centerPosition[i+1])
            end
        end
    end

    if mechanic then
        for i = 0, getProperty("unspawnNotes.length")-1 do
            if getPropertyFromGroup("unspawnNotes",i,"noteType") == "Hurt Note" then
                setPropertyFromGroup("unspawnNotes", i, "colorSwap.hue", 120 / 360)
            end
            local strumTime = getPropertyFromGroup("unspawnNotes",i,"strumTime")
            if strumTime >= 87600 and strumTime < 108000 then
                setPropertyFromGroup("unspawnNotes", i, "multSpeed", 0.25)
            end

            if strumTime >= 127200 and not getPropertyFromGroup("unspawnNotes", i, "mustPress") then
                setPropertyFromGroup("unspawnNotes", i, "copyAlpha", true)
                setPropertyFromGroup("unspawnNotes", i, "visible", true)
                if not getPropertyFromGroup("unspawnNotes", i, "isSustainNote") then
                    setPropertyFromGroup("unspawnNotes", i, "multAlpha", 0)
                end
            elseif not getPropertyFromGroup("unspawnNotes", i, "mustPress") then
                setPropertyFromGroup("unspawnNotes", i, "visible", HardMode)
            end
        end
    end

    songStart = true
end

function onStepHit()
    if mechanic then
        if curStep >= 784 and curStep < 1040 then
            if curStep % 4 == 0 then
                for i = 4,7 do
                    noteTweenY("noteY"..i, i, defaultPosition[i+1].y + (math.sin(getSongPosition()/300 + i*1) * (downscroll and 70 or -70)), crochet/1000/2, "quadOut")
                end
            end
            if curStep % 4 == 2 then
                for i = 4,7 do
                    noteTweenY("noteY"..i, i, defaultPosition[i+1].y, crochet/1000/2, "quadIn")
                end
            end
        end
        if curStep == 1040 then
            setProperty("camHUD.angle", 0)
            setProperty("songSpeed", 2.7)
            setProperty("noteOffset.x", 0)
            setProperty("noteKillOffset", 1000)
            for i = 0,7 do 
                setPropertyFromGroup("strumLineNotes", i, "x", centerPosition[i%4 + 1])
            end
        end
        if curStep >= 1168 and curStep < 1420 then
            if curStep % 16 == 12 then
                for i = 4,7 do 
                    setPropertyFromGroup("strumLineNotes", i, "angle", getPropertyFromGroup("strumLineNotes", i, "angle") % 360)
                    noteTweenAngle("noteAngle"..i, i, getPropertyFromGroup("strumLineNotes", i, "angle") + 90, crochet/1000*2,"elasticInOut")
                end
            end
            if curStep % 8 == 0 then
                doTweenY("camHUD", "camHUD", (downscroll and 20 or -20), crochet/1000, "quadOut")
            end
            if curStep % 8 == 4 then
                doTweenY("camHUD", "camHUD", 0, crochet/1000, "quadIn")
            end
        end
        if curStep >= 1168 and curStep < 1440 then
            if curStep % 8 == 0 then
                doTweenY("camHUD", "camHUD", (downscroll and 20 or -20), crochet/1000, "quadOut")
            end
            if curStep % 8 == 4 then
                doTweenY("camHUD", "camHUD", 0, crochet/1000, "quadIn")
            end
        end
        if curStep == 1420 then
            for i = 4,7 do 
                setPropertyFromGroup("strumLineNotes", i, "angle", getPropertyFromGroup("strumLineNotes", i, "angle") % 360)
                noteTweenAngle("noteAngle"..i, i, 0, crochet/1000*4,"quadOut")
            end
        end
        if curStep == 1440 then
            setProperty("noteKillOffset", 350 / scrollSpeed)
            noteTweenY("noteAngle4", 4, downPosition[downscroll and 2 or 1], crochet/1000*4,"bounceOut")
            for i = 4,7 do 
                noteTweenDirection("noteDir"..i, i, -90, crochet/1000*4,"bounceOut")
            end
            doTweenY("camHUD", "camHUD", 0, crochet/1000, "quadIn")
        end
        if curStep == 1441 then
            noteTweenY("noteAngle5", 5, downPosition[downscroll and 2 or 1], crochet/1000*4,"bounceOut")
        end
        if curStep == 1442 then
            noteTweenY("noteAngle6", 6, downPosition[downscroll and 2 or 1], crochet/1000*4,"bounceOut")
        end
        if curStep == 1443 then
            noteTweenY("noteAngle7", 7, downPosition[downscroll and 2 or 1], crochet/1000*4,"bounceOut")
        end
        
        if curStep == 1696 then
            for i = 0,3 do 
                setPropertyFromGroup("strumLineNotes", i, "visible", true)
                setPropertyFromGroup("strumLineNotes", i, "alpha", 0)
                noteTweenAlpha("noteAlpha"..i, i, 0.4, 2)
            end
            for i = 4,7 do 
                noteTweenDirection("noteDir"..i, i, 90, crochet/1000*4,"quadInOut")
                noteTweenY("noteAngle"..i, i, defaultPosition[i+1].y, crochet/1000*4,"quadInOut")
            end
            for i = 0, getProperty("notes.length")-1 do
                if not getPropertyFromGroup("notes", i, "mustPress") and not getPropertyFromGroup("notes", i, "isSustainNote") and getPropertyFromGroup("notes", i, "strumTime") >= 127200 then
                    setPropertyFromGroup("notes", i, "multAlpha", 1)
                end
            end
            for i = 0, getProperty("unspawnNotes.length")-1 do
                if not getPropertyFromGroup("unspawnNotes", i, "mustPress") and not getPropertyFromGroup("unspawnNotes", i, "isSustainNote") and getPropertyFromGroup("unspawnNotes", i, "strumTime") >= 127200 then
                    setPropertyFromGroup("unspawnNotes", i, "multAlpha", 1)
                end
            end
        end
        if curStep == 1952 then
            setProperty("noteOffset.x", 0)
            for i = 0,7 do 
                setPropertyFromGroup("strumLineNotes", i, "x", centerPosition[i%4 + 1])
            end
        end
    end
    if HardMode and not mustHitSection and curStep < 1952 and curBeat >= 8 then
        addHealth(curStep >= 400 and -0.01 or -0.005)
    end
end

local notePos = {-2 ,-1, 1, 2}
function onUpdate(elapsed)
    if not inGameOver and mechanic then
        if (curStep >= 784 and curStep < 912) or (curStep >= 1696 and curStep < 1824) then
            local moveOff = 200 * continuous_sin(curDecBeat/8)
            setProperty("noteOffset.x", moveOff)
        end
        if (curStep >= 912 and curStep < 1040) or (curStep >= 1824 and curStep < 1952) then
            local moveOff = 200 * continuous_sin(curDecBeat/8)
            setProperty("noteOffset.x", moveOff*2)
            for i = 0,7 do 
                setPropertyFromGroup("strumLineNotes", i, "x", centerPosition[i%4 + 1] + (-moveOff * (i<4 and -1 or 1)))
            end
        end

        for i = 0, getProperty("notes.length")-1 do
            local strumTime = getPropertyFromGroup("notes", i, "strumTime")
            local noteData = getPropertyFromGroup("notes", i, "noteData")
            local distance = (strumTime - getSongPosition())/100
            local isSus = getPropertyFromGroup("notes", i, "isSustainNote")

            local susOff = (isSus and sustainOffset or 0)
            if getPropertyFromGroup("notes", i, "noteType") == '' then
                if strumTime < 19200 then
                    local offY = math.sin(distance)*100*(downscroll and -1 or 1)
                    setPropertyFromGroup("notes", i, "offsetY", offY)
                    setPropertyFromGroup("notes", i, "offsetX", (offY/100*(downscroll and -1 or 1)) * (notePos[noteData%4 + 1]*25) + susOff)
                    --setPropertyFromGroup("notes", i, "multAlpha", (isSus and 0.6 or 1) * getProperty("noteAlpha.alpha"))
                end
                if strumTime >= 30000 and strumTime < 49200 then
                    local offX = math.sin(distance*2.5)*5
                    setPropertyFromGroup("notes", i, "offsetX", (offX * (5-distance)) + susOff)
                end
                if strumTime >= 49200 and strumTime < 58800 then
                    local mult = math.sin(strumTime*0.5) * 30
                    local offX = distance * notePos[noteData%4 + 1] * mult
                    setPropertyFromGroup("notes", i, "offsetX", offX + susOff)
                end

                if (strumTime >= 58800 and strumTime < 78000) or (strumTime >= 127200 and strumTime < 146400) then
                    local offX = getProperty('noteOffset.x')
                    setPropertyFromGroup("notes", i, "offsetX", (offX * (getPropertyFromGroup("notes", i, "mustPress") and 1 or -1)) + susOff)
                end

                if strumTime >= 87600 and strumTime < 108000 and getPropertyFromGroup("notes", i, "noteType") ~= "Hurt Note" then
                    local offX = math.max(0, distance - 6) * 20 * (noteData%4 < 2 and -1 or 1)
                    setPropertyFromGroup("notes", i, "offsetX", offX + susOff)
                end

                if strumTime >= 108000 and strumTime < 117600 then
                    local mult = (5 + (math.sin(strumTime) * 2.5))*5
                    local offX = math.sin(distance*1.5)*mult
                    setPropertyFromGroup("notes", i, "offsetX", (offX * (5-(distance*2))) + susOff)
                end

                if strumTime >= 117600 and strumTime < 127200 then
                    local mult = (math.sin(strumTime*0.5) * 300)
                    local offX = math.sin(distance*0.2)*mult
                    setPropertyFromGroup("notes", i, "offsetX", offX + susOff)
                end

                if strumTime >= 108000 and strumTime < 127200 and not isSus then
                    setPropertyFromGroup("notes", i, "offsetAngle",180)
                end
            end
        end


        if curStep >= 912 and curStep < 1040 then
            setProperty("songSpeed", 2.4 + (0.7* continuous_sin(curDecBeat/4)))
        end
        if curStep >= 784 and curStep < 1040 then
            setProperty("camHUD.angle", continuous_sin(curDecBeat/8)*7)
        end
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    -- if curBeat < 64 and not isSustainNote and mechanic then
    --     setProperty("noteAlpha.alpha", 0 )
    --     doTweenAlpha("noteAlpha", 'noteAlpha', 1, 0.25)
        
    -- end
end


function continuous_sin(x) return math.sin((x % 1) * 2*math.pi) end