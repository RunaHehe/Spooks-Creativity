
local mechanic = true
local shortVer = true
defaultNotes = {}
speeder = 1;
function onCreate()
    shortVer =  getDataFromSave("ammarc", "kaijuShortMode")
end
function onCreatePost()

    for i = 0, getProperty("unspawnNotes.length")-1 do 
        local strumTime = getPropertyFromGroup("unspawnNotes", i, "strumTime")
        if getPropertyFromGroup("unspawnNotes", i, "mustPress") and strumTime >= 153776 and strumTime < 211948 then 
            setPropertyFromGroup("unspawnNotes", i, "hitHealth", 0.023 * 3 * 2)
        end
    end

   makeLuaSprite('blackScreen', "", 0 ,0)
   makeGraphic("blackScreen", 1300, 800, '000000')
   addLuaSprite("blackScreen")
   setObjectCamera("blackScreen", "other")
   setProperty("blackScreen.alpha", 0)

   makeLuaText("dialog", "", 800, 0, 600)
   addLuaText("dialog", true)
   setTextSize("dialog", 26)
   setTextBorder("dialog", 2, "000000")
   setObjectCamera("dialog", "other")
   setTextAlignment("dialog", "center")
   setProperty("dialog" .. ".antialiasing", true)
   screenCenter("dialog", "X")
   
end

textTarget = ""
textTagTarget = ""
function textType(textTag, text, delay)
    setTextString(textTag, "")
   textTagTarget = textTag
   textTarget = text
   runTimer('typerText', delay, string.len(text))
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'typerText' then
       setTextString(textTagTarget, string.sub(textTarget, 0, ((loops) - (loopsLeft))))
   end
   if tag == "playMenu" then 
    loadSong("blackout menu", -1)
end
end

function onSongStart()
    for i = 0, 7 do 
        local _x = getPropertyFromGroup("playfieldRenderer", i, "x")
        local _y = getPropertyFromGroup("playfieldRenderer", i, "y")

        table.insert(defaultNotes, {_x, _y})
    end
end
function onStepHit()
    if curStep == 492 and shortVer then 
        callScript("scripts/coolFunctions", "varTween", {"speeder", "speeder", 1, 0.01, 3.8, "sineOut", scriptName})
        runTimer("playMenu", 6)
    end
    if curStep == 512 then 
        setProperty("blackScreen.alpha", 1)
        cameraFlash("other", "FFFFFF", 6)
    end
    if curStep == 578 then 
        textType("dialog", "Are you afraid to become a furry?", 0.05)
    end
    if curStep == 608 then 
        textType("dialog", "It will be so awesome.", 0.05)
    end
    if curStep == 632 then 
        textType("dialog", "Why not be one?", 0.05)
    end
    if curStep == 656 then 
        textType("dialog", "Well...", 0.1)
    end
    if curStep == 670 then 
        textType("dialog", "Too late.", 0.05)
    end
    if curStep == 684 then 
        textType("dialog", "You are trapped here now.", 0.05)
    end
    if curStep == 704 then 
        textType("dialog", " ", 0.01)
        setProperty("blackScreen.alpha", 0)
        cameraFlash("other", "FFFFFF", 6)
    end
    if curStep == 1472 then 
        setProperty("blackScreen.alpha", 1)
        doTweenAlpha("blackFade", "blackScreen", 0, crochet/1000*4*8, "quadIn")
    end
    if curStep == 1585 then 
        triggerEvent("Camera Follow Pos", getProperty('furryGas.x') + 330, getProperty('furryGas.y') + (getProperty('furryGas.height')/2))
        setProperty("defaultCamZoom", 1.4)
    end
    if curStep == 1592 then 
        textType("dialog", "Breathe in", 0.03)
    end
    if curStep == 1600 then 
        setProperty("defaultCamZoom", 0.6)
        triggerEvent("Camera Follow Pos", "", "")
        textType("dialog", " ", 0.003)
    end
end

function onBeatHit()
    if curBeat >= 400 and curBeat <= 560 then
        if curBeat >= 448 then 
            addHealth(-0.07 * 2)
        else
            addHealth(-0.04)
        end
    end
    
    if curBeat == 560 then 
        for i = 0, 7 do 
            setPropertyFromGroup("playfieldRenderer", i, "y", defaultNotes[i+1][2])
            setPropertyFromGroup("playfieldRenderer", i, "x", defaultNotes[i+1][1])
        end
    end
end



moveElapsed = 0
function onUpdate(elapsed)
    setProperty('playbackRate', speeder)
    if curBeat >= 400 and curBeat < 560 then 
        moveElapsed = moveElapsed + elapsed
        for i = 0, 7 do 
            setPropertyFromGroup("playfieldRenderer", i, "y", defaultNotes[i+1][2] + math.sin((moveElapsed*5)+(i*0.3))*25)
            setPropertyFromGroup("playfieldRenderer", i, "x", defaultNotes[i+1][1] + math.cos((moveElapsed*5)+(i*0.3))*35)
        end
    end
end
