defaultNote = {}
local modchartEnable = true
local hradmodeEnable = true
local shake = 0

local lagging = false
function onCreate()
    luaDebugMode = true
    makeLuaSprite("modchartVar", "", 0, 0)
    modchartEnable = not EasyMode and Mechanic
end
function onCreatePost()
    if InsaneMode then
        createDistractionVideos()

        makeLuaSprite('loading', 'loading', 840 , 0)
        scaleObject('loading', 0.5, 0.5)
        screenCenter('loading', 'y')
        setObjectCamera('loading', 'hud')
        addLuaSprite('loading')
        setObjectOrder('loading', getObjectOrder('notes')+10)
        setProperty('loading.alpha', 0)
    end
end
function createDistractionVideos()
    for i = 1, 5 do
        local tag = 'videoDis'..i
        makeLuaSprite(tag, 'thumbnails/thumbEmpty', 1300 , 50 + ((i-1) * 150))
        scaleObject(tag, 0.75, 0.75)
        setObjectCamera(tag, 'hud')
        addLuaSprite(tag)
        setObjectOrder(tag, getObjectOrder('notes')+10)
    end
end
function onStepEvent(curStep)
    if HardMode or InsaneMode then
        if curStep == 16 then 
            for i = 0,7 do 
                table.insert(defaultNote, {x = getPropertyFromGroup("strumLineNotes", i, "x"), y = getPropertyFromGroup("strumLineNotes", i, "y")})
            end
        end
    end
    if InsaneMode then
        if curStep == 320 or curStep == 1376 then
            lagging = true
            setProperty('loading.alpha', 1)
        end
        if curStep == 576 or curStep == 1504 then
            lagging = false
            setProperty('loading.alpha', 0)
            if not getPause() then
                for i = 0, getProperty('notes.length')-1 do
                    if getPropertyFromGroup("notes", i, 'mustPress') then
                        setPropertyFromGroup("notes", i, 'copyY', true)
                    end
                end
            end
        end
        if curStep >= 1632 and (curStep%32) % 6 == 0 and curStep < 1888 then
            setProperty("camHUD.angle", (curStep%32) % 12 == 0 and 0 or 180)
            doTweenAngle('hug', 'camHUD', (curStep%32) % 12 == 0 and 180 or 0, curStep % 32 < 30 and crochet/1500 or crochet/2000, 'quadOut')
            setProperty("camBYoutube.angle", (curStep%32) % 12 == 0 and 0 or -180)
            doTweenAngle('gam', 'camBYoutube', (curStep%32) % 12 == 0 and -180 or 0, curStep % 32 < 30 and crochet/1500 or crochet/2000, 'quadOut')
            cameraFlash('hud', '0xA0FF0000', 0.3, true)
            cameraShake('hud', 0.01, 0.3)
        end
        
    end
end
function onStepHit()
    if modchartEnable and (HardMode or InsaneMode) then
        modchart()
        if InsaneMode then
            if (curStep >= 1120 and curStep < 1376) and curStep % 4 == 0 then
                local tag = 'videoDis'..((curStep%(4*5))/4) + 1
                setProperty(tag..'.angle', 50)
                doTweenX(tag, tag, 800, crochet/500, 'quadOut')
                doTweenAngle(((curStep%(4*6))/4)..'vidoaidaosdjaskdn', tag, 0, crochet/500, 'quadOut')
            end
            if lagging and not getPause() then
                local doLag = getRandomBool(60)
                for i = 0, getProperty('notes.length')-1 do
                    if getPropertyFromGroup("notes", i, 'mustPress') then
                        setPropertyFromGroup("notes", i, 'copyY', doLag)
                    end
                end
            end
        end
    end
end
function onUpdate(elapsed)
    if not inGameOver and InsaneMode then
        setProperty("loading.angle", getProperty("loading.angle") + elapsed * 500)
    end

end
function onUpdatePost(elapsed)
    if not inGameOver and modchartEnable then
        modchartUpdate(elapsed)
    end
end

local noteArray = {
    {-1, 1, -1, 1},
    {1, -1, 1, -1}
}

function modchart()
    if (curStep >= 320 and curStep < 576) or (curStep >= 1376 and curStep < 1632) then 
        if curStep % 4 == 0 then
            for i = 0,7 do 
                setPropertyFromGroup("strumLineNotes",i,"y",defaultNote[i+1].y + (noteArray[curStep%8==0 and 1 or 2][i%4+1] * 40))
                noteTweenY("noteY"..i, i, defaultNote[i+1].y, crochet/1000, "quadOut")

                setPropertyFromGroup("strumLineNotes",i,"x",defaultNote[i+1].x + (curStep%8==0 and -50 or 50))
                noteTweenX("noteX"..i, i, defaultNote[i+1].x, crochet/1000, "quadOut")
            end
        end
    end

    if curStep == 608 then
        doTweenX("modchartVar", "modchartVar", 25, crochet/1000*4, "quadInOut")
    end
    if (curStep >= 736 and curStep < 864) or (curStep >= 992 and curStep < 1120) then
        if curStep%4 == 0  then
            doTweenX("modchartVar", "modchartVar", 35, crochet/1000*0.75, "quadOut")
        elseif curStep%4 == 3 then
            doTweenX("modchartVar", "modchartVar", -25, crochet/1000*0.25, "quadIn")
        end
    end
    if curStep == 864 then
        doTweenX("modchartVar", "modchartVar", 0, crochet/1000*4, "quadIn")
    end      
    if curStep == 1120 then
        for i = 0,7 do 
            noteTweenY("noteY"..i, i, defaultNote[i+1].y, crochet/1000*2, "quadOut")
        end
    end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
end

function modchartUpdate(elapsed)
    
    if (HardMode or InsaneMode) then
        if curStep >= 16 and defaultNote[1] ~= nil then
            shake = lerp(shake, 0, elapsed * 7)
            for i = 0,7 do 
                local add = ((curStep >= 608 and curStep < 1120) and (math.sin(getSongPosition()/150 + i*0.9) * getProperty("modchartVar.x")) or 0)
                setPropertyFromGroup("strumLineNotes",i,"x",defaultNote[i+1].x + getRandomFloat(-shake, shake))
                setPropertyFromGroup("strumLineNotes",i,"y",defaultNote[i+1].y + add + getRandomFloat(-shake, shake))
            end
        else
            if curStep >= 608 and curStep < 1120 then
                for i = 0,7 do 
                    setPropertyFromGroup("strumLineNotes",i,"y",defaultNote[i+1].y + (math.sin(getSongPosition()/150 + i*0.9) * getProperty("modchartVar.x")))
                end
            end
        end
    end
end

function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if noteType == 'Hurt Note' then
        shake = 50
    end
end


function onTweenCompleted(tag)
    if string.find(tag, 'videoDis') and not string.find(tag, 'outt') then
        doTweenX(tag..'outt', tag, 1300, crochet/1000, 'quadIn')
    end
end

function getPause()
    return getGlobalFromScript("stages/youtube", "paused")
end

function lerp(a, b, t)
	return a + (b - a) * t
end