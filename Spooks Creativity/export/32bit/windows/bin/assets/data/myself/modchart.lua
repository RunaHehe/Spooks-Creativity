local defaultGhostTap = true
local defaultMid = false
local susOff = 0
function onCreate()
    if SourceCodeVer and Modchart then
        setProperty('useModchart', true)
    end
    defaultMid = middlescroll
    if Modchart then
        defaultGhostTap = getPropertyFromClass("ClientPrefs", "ghostTapping")
        setPropertyFromClass("ClientPrefs", "middleScroll", false)
    end
end
function onCreatePost()
    for i = 0, getProperty("unspawnNotes.length")-1 do
        if getPropertyFromGroup("unspawnNotes", i, 'isSustainNote') then
            susOff = getPropertyFromGroup("unspawnNotes", i, 'offsetX') 
            break
        end
    end
end
function onDestroy()
    setPropertyFromClass("ClientPrefs", "middleScroll", defaultMid)
end

function onCountdownStarted()
    luaDebugMode = true
    if not SourceCodeVer or not Modchart then return end
    setProperty('spawnTime', 3000)
    setValue('wiggleFreq', 0.6)
    local downsc = downscroll and -1 or 1
    -- player 0 = bf
    -- player 1 = dad

    queueEase(0,128-4 , 'opponentSwap', 0.5, 'quadInOut')
    local beat = {0, 16, 32, 48, 56}
    queueSet(128, 'tipsySpeed', 3)
    for section = 0, 1 do
        local player = 1-section
        for i,beat in pairs(beat) do
            local time = 128 + (section*64) + beat
            queueSet(time, 'flip', ((i+section)%2 == 0 and 0.4 or -0.4), player)
            queueSet(time, 'tipsy', ((i+section)%2 == 0 and 1 or -1), player)
            queueSet(time, 'localrotateZ', ((i+section)%2 == 0 and 1 or -1)) -- ROtATE SIDEWAY!11111
            queueEase(time,time+8 , 'flip', 0, 'quadOut', player)
            queueEase(time,time+8 , 'tipsy', 0, 'quadOut', player)
            queueEase(time,time+8 , 'localrotateZ', 0, 'quadOut')

            if not EasyMode then
                queueEase(time,time+8 , 'invert', (i%2 == 0 and 1 or 0), 'elasticOut', player)
            end
        end
    end

    queueEase(128,128+16 , 'transformZ', -0.5, 'expoOut', 0)
    queueEase(128,128+16 , 'confusion', 360, 'expoOut', 0)
    queueEase(128,128+16 , 'alpha', 0.5, 'expoOut', 0)

    queueEase(188,188+4 , 'transformZ', 0, 'quadInOut', 0)
    queueEase(188,188+4 , 'transformZ', -0.5, 'quadInOut', 1)
    queueEase(188,188+4 , 'confusion', 0, 'quadInOut', 0)
    queueEase(188,188+4 , 'confusion', 360, 'quadInOut', 1)
    queueEase(188,188+4 , 'alpha', 0, 'quadInOut', 0)
    queueEase(188,188+4 , 'alpha', 0.5, 'quadInOut', 1)
    
    queueEase(252,252+4 , 'alpha', 0, 'quadIn', 1)
    queueEase(252,252+4 , 'confusion', 0, 'quadIn', 0)
    queueEase(252,252+4 , 'transformZ', 0, 'quadIn', 1)

    queueEase(252,252+4 , 'opponentSwap', 0, 'quadIn')

    --boing ;3 
    --[[
    for section = 0, 7 do
        for beat = 0, 3 do
            local time = 256 + (section*16) + (beat*4)
            queueEase(time   ,time+2 , 'transformY', -50 + 20, 'quadOut')
            queueEase(time+2,time+2+2 , 'transformY', 0 + 20, 'quadIn', -1, -50)
        end
    end 
    ]]
    --test
    queueEase(252,252+4 , 'receptorScroll', 1, 'quadInOut', -1)
    if not EasyMode then
        for section = 0, 7 do
            for beat = 0, 3 do
                local time = 256 + (section*16) + (beat*4)
                queueSet(time , 'invert', beat%2==0 and 0.4 or -0.4)
                queueEase(time,time+4 , 'invert', 0, 'cubeOut', -1)
            end
        end
    end 

    if HardMode then
        for section = 0, 1 do
            for i,beat in pairs(beat) do
                local time = 256 + (section*64) + beat
                queueSet(time, 'wiggle', ((i+section)%2 == 0 and 3 or -3))
                queueEase(time,time+8 , 'wiggle', 0, 'quadOut')
            end
        end
    end

    queueEase(380,380+4 , 'receptorScroll', 0, 'quadIn', -1)
    queueEase(380,380+4 , 'opponentSwap', 0.5, 'quadIn', -1)
    queueEase(380,380+4 , 'transformY', -200 * downsc, 'quadIn', 0)

    if not EasyMode then
        ease(97, 1, 'invert', 1, 'cubeOut', -1) set(97, 'xmod', 0.5) ease(97, 1, 'xmod', 1, 'expoOut')
        ease(98, 1, 'invert', 0, 'cubeOut', -1) set(98, 'xmod', 0.5) ease(98, 2, 'xmod', 1, 'expoOut')

        ease(100, 1, 'invert', 1, 'cubeOut', 0) set(100, 'xmod', 0.5) ease(100, 1, 'xmod', 1, 'expoOut')
        ease(101, 1, 'invert', 0, 'cubeOut', 0) set(101, 'xmod', 0.5) ease(101, 2, 'xmod', 1, 'expoOut')
    end

    queueEase(396,396+4 , 'transformY', 0, 'bounceOut', 0)
    queueEase(396,396+4 , 'reverse', 1, 'bounceOut', 1)

    queueEase(408,408+8 , 'localrotateZ', math.rad(360), 'quadIn', -1)
    ease(104,1 , 'reverse', 0, 'quadOut', 1)
    set(104, 'localrotateZ', 0, -1)
    ease(104, 2, 'transformY', -200 * downsc ,'quadIn', 0)
    set(106, 'opponentSwap', 0, 0)

    set(104, 'wiggleFreq', 0.5, -1)
    for beat = 0, (4*14)-1 do
        local time = 104 + beat
        local player = (time >= 136 and -1 or 1)
        if beat%2==0 then
            ease(time, 1 ,'transformY', -25 * downsc, 'quadOut', player)
            ease(time, 1 ,'localrotateZ', -0.2 * (beat%4==0 and 1 or -1), 'expoOut', player)
            ease(time, 1 ,'confusion', -10 * (beat%4==0 and 1 or -1), 'expoOut', player)
        end

        if beat%2==1 then
            ease(time, 1 ,'transformY', 0, 'quadIn', player)
            ease(time, 1 ,'localrotateZ', 0, 'cubeIn', player)
            ease(time, 1 ,'confusion', 0, 'cubeIn', player)

            set(time, 'wiggle', 6 * (beat%4==1 and 1 or -1), player)
            ease(time, 1.5 ,'wiggle', 0, 'quadOut', player)

            if time >= 136 and not EasyMode then
                set(time, 'tipsy', 4, player)
                ease(time, 1.5 ,'tipsy', 0, 'quadOut', player)
            end
        end

        if time == 158 then
            for i = 0, 3 do
                ease(time, 2 ,'transform'..i..'Z', 0, 'cubeInOut', player)
            end
        else
            if beat%4==0 then
                for i = 0, 3 do
                    ease(time, 2 ,'transform'..i..'Z', -0.05 * (i%2==0 and 1 or -1), 'cubeInOut', player)
                end
            elseif beat%4==2 then
                for i = 0, 3 do
                    ease(time, 2 ,'transform'..i..'Z', 0.05 * (i%2==0 and 1 or -1), 'cubeInOut', player)
                end
            end
        end
    end

    ease(133, 2, 'transformY', 0 ,'quadInOut', 0)
    ease(133, 2, 'opponentSwap', 0 ,'quadInOut', 1)

    ease(160, 1, 'confusion', 180 ,'linear', 1)
    if not EasyMode then ease(161, 0.5, 'flip', 1 ,'cubeOut', 1) end
    set(161, 'tipsy', 2, -1)
    ease(161, 1.5, 'tipsy', 0 ,'cubeOut', -1)

    ease(162, 1, 'confusion', 0 ,'linear', 1)
    if not EasyMode then ease(163, 0.5, 'flip', 0 ,'cubeOut', 1) end
    set(163, 'tipsy', 2, -1)
    ease(163, 1.5, 'tipsy', 0 ,'cubeOut', -1)

    ease(164, 1, 'confusion', -180 ,'linear', 0)
    if not EasyMode then  ease(165, 0.5, 'invert', 0.5 ,'cubeOut', -1) end
    set(165, 'tipsy', 2, -1)
    ease(165, 1.5, 'tipsy', 0 ,'cubeOut', -1)

    ease(166, 1, 'confusion', 0 ,'linear', 0)
    if not EasyMode then ease(167, 0.5, 'invert', 0 ,'cubeOut', -1) end
    set(167, 'tipsy', 2, -1)
    ease(167, 1.5, 'tipsy', 0 ,'cubeOut', -1)
    if HardMode then
        ease(168, 1, 'centerrotateX', -0.7 ,'cubeOut', -1)
    end

    for beat = 0, (4*16)-1 do
        local time = 168 + beat
        local condition = time >= 199 and time <= 228 and not EasyMode
        if beat % 2 == 0 then
            ease(time, 1, 'reverse', (condition and 0.8 or 0.2), 'quadOut', -1)
            ease(time, 1, 'wiggle', 4, 'quadOut', -1)
        else
            ease(time, 1, 'reverse', (condition and 1 or 0), 'quadIn', -1)
            ease(time, 1, 'wiggle', 0, 'quadIn', -1)

            ease(time-0.5, 0.5, 'flip', (EasyMode and -0.2 or -0.5) * (beat%4==1 and 1 or - 1), 'expoIn', -1)
            ease(time, 1, 'flip', 0, 'quadOut', -1)

            ease(time-0.5, 0.5, 'confusion', -25 * (beat%4==1 and 1 or - 1), 'expoIn', -1)
            ease(time, 1, 'confusion', 0, 'quadOut', -1)

            ease(time-0.5, 0.5, 'localrotateZ', (beat%4==1 and -0.5 or 0.5), 'expoIn', -1)
            ease(time, 1, 'localrotateZ', 0, 'quadOut', -1)

        end

        if beat % 4 == 0 then
            ease(time, 2, 'opponentSwap', (condition and 0.8 or 0.2), 'linear', -1)
        elseif beat % 4 == 2 and time < 230 then
            ease(time, 2, 'opponentSwap', (condition and 1 or 0), 'linear', -1)
        end
    end

    set(198.5, 'tipsy', 2, -1)
    ease(198.5, 1, 'tipsy', 0 ,'cubeOut', -1)

    set(230.5, 'tipsy', 2, -1)
    ease(230.5, 1, 'tipsy', 0 ,'cubeOut', -1)

    ease(230, 2, 'opponentSwap', 0.5, 'linear', -1)

    local beat = {0, 16, 32, 48, 56}
    queueSet(232, 'tipsySpeed', 3)
    for section = 0, 1 do
        local player = 1-section
        for i,beat in pairs(beat) do
            local time = (232*4) + (section*64) + beat
            queueSet(time, 'flip', ((i+section)%2 == 0 and 0.4 or -0.4), player)
            queueSet(time, 'tipsy', ((i+section)%2 == 0 and 1 or -1), player)
            queueSet(time, 'localrotateZ', ((i+section)%2 == 0 and 1 or -1)) -- ROtATE SIDEWAY!11111
            queueEase(time,time+8 , 'flip', 0, 'quadOut', player)
            queueEase(time,time+8 , 'tipsy', 0, 'quadOut', player)
            queueEase(time,time+8 , 'localrotateZ', 0, 'quadOut')

            if not EasyMode then
                queueEase(time,time+8 , 'invert', (i%2 == 0 and 1 or 0), 'elasticOut', player)
            end
        end
    end

    set(232, 'suddenOffset', 0.25)
    if not EasyMode then
        ease(232, 22, 'sudden', 1 ,'linear', -1)
    end
    ease(232, 22, 'brake', 0.75 ,'linear', -1)
    if HardMode then
        ease(232, 1, 'centerrotateX', 0 ,'cubeOut', -1)
    end

    ease(232,4 , 'transformZ', -0.5, 'expoOut', 0)
    ease(232,4 , 'confusion', 360, 'expoOut', 0)
    ease(232,4 , 'alpha', 0.5, 'expoOut', 0)

    ease(247,1 , 'transformZ', 0, 'quadInOut', 0)
    ease(247,1 , 'transformZ', -0.5, 'quadInOut', 1)
    ease(247,1 , 'confusion', 0, 'quadInOut', 0)
    ease(247,1 , 'confusion', 360, 'quadInOut', 1)
    ease(247,1 , 'alpha', 0, 'quadInOut', 0)
    ease(247,1 , 'alpha', 1, 'quadInOut', 1)

    if HardMode then
        ease(264,1 , 'alpha', 0, 'quadInOut', 1)
    end
    ease(264,1 , 'alpha', 1, 'linear', 0)
    set(264, 'suddenOffset', 0)
    set(264, 'sudden', 0)
    set(264, 'brake', 0)
    set(264, 'transformZ', 0)
    set(264, 'confusion', 0)

    ease(322,6 , 'alpha', 1, 'linear', 1)
    ease(324,4 , 'alpha', 0, 'linear', 0)

    for beat = 0, (4*15)-1 do
        local time = 264 + beat
        if beat%2==0 then
            set(time, 'transformY', 20 * downsc, 1)
            ease(time ,1 , 'transformY', 0, 'quadOut', 1)
        end
    end

    for beat = 0, (4*15)-1 do
        local time = 328 + beat
        ease(time-0.25 ,0.25 , 'tipsy', 2 * (beat%2==0 and 1 or -1), 'expoIn', 0)
        ease(time ,0.75 , 'tipsy', 0, 'quadOut', 0)

        ease(time-0.25 ,0.25 , 'transformX', 80 * (beat%2==0 and 1 or -1), 'expoIn', 0)
        ease(time ,0.75 , 'transformX', 0, 'quadOut', 0)

        ease(time-0.25 ,0.25 , 'wiggle', -1 * (beat%2==0 and 1 or -1), 'expoIn', 0)
        ease(time ,0.75 , 'wiggle', 0, 'quadOut', 0)
    end

    if not EasyMode then
        ease(343 ,1 , 'flip', 0.5, 'cubeIn', 0)
        ease(344 ,2 , 'flip', 1, 'quadOut', 0)

        ease(347 ,1 , 'flip', 0.5, 'cubeIn', 0)
        ease(348 ,2 , 'flip', 0, 'quadOut', 0)
        ease(347 ,1 , 'invert', 0.5, 'cubeIn', 0)
        ease(348 ,2 , 'invert', 1, 'quadOut', 0)

        ease(351 ,1 , 'invert', 0.5, 'cubeIn', 0)
        ease(352 ,2 , 'invert', 0, 'quadOut', 0)
    end

    ease(357 ,1.5 , 'confusion', 360, 'quadOut', 0)
    ease(359 ,1.5 , 'confusion', 0, 'quadOut', 0)

    ease(368 ,2 , 'localrotateZ', math.rad(360), 'quadInOut', 0)
    ease(370 ,2 , 'localrotateZ', 0, 'quadInOut', 0)

    if not EasyMode then
        ease(377.5 ,2.5 , 'invert', 1, 'linear', 0)
        ease(381.5 ,2.5 , 'flip', 1, 'linear', 0)
        ease(381.5 ,2.5 , 'invert', 0, 'linear', 0)
        ease(385.5 ,2.5 , 'flip', 0, 'linear', 0)
    end

        ease(388 ,1 , 'flip', 1, 'cubeOut', 0)
        ease(389 ,1 , 'invert', -1, 'cubeOut', 0)
        ease(390 ,1 , 'invert', 1, 'cubeOut', 0)
        ease(390 ,1 , 'flip', 0, 'cubeOut', 0)
        ease(391 ,1 , 'invert', 0, 'cubeOut', 0)


    ease(392 ,2 , 'transformZ', -0.15, 'quadOut', 1)
    ease(392-1 ,1 , 'alpha', (EasyMode and 0.4 or 0.15), 'cubeIn', 1)
    local circling = {0, 300, 0, -300}
    local circlingZ = {-0.3, 0, 0.3, 0}
    local easeA = {'In', 'Out', 'In', 'Out'}
    for section = 0, (8-1) do -- for spin
        for circle = 0, (8-1) do
            local revers = section > 3 and -1 or 1
            local time = 392 + circle + (section * 8)
            local index = ((circle+1)%4)+1
            local indexO = ((circle+1-2)%4)+1
            ease(time, 1, 'transformX-a', circling[index] * revers, 'quad'..easeA[index], 0)
            ease(time, 1, 'transformX-a', circling[indexO] * revers, 'quad'..easeA[indexO], 1)

            if time < 454 then
                ease(time, 1, 'transformZ-a', circlingZ[index] * revers, 'quad'..easeA[index], 0)
                ease(time, 1, 'transformZ-a', circlingZ[indexO] * revers, 'quad'..easeA[indexO], 1)
            else
                ease(time, 1, 'transformZ-a', 0, 'quad'..easeA[index], -1)
            end
        end
    end

    set(392, 'wiggleFreq', 0.32)
    set(392, 'sudden', 1)
    set(392, 'suddenOffset', 0.7)
    for beat = 0, (64-1) do 
        local time = 392 + beat
        local playerA = time >= 424 and 1 or 0
        if beat%4==0 then
            set(time, 'confusion', time >= 424 and 360 or -360, 0)
            ease(time, 2, 'confusion', 0, 'cubeOut', (0+playerA)%2)

            set(time, 'tipsy', 3 * (beat%4==0 and 1 or -1), 1)
            ease(time, 2, 'tipsy', 0, 'cubeOut', 1)
        elseif beat%4==2 then
            set(time, 'confusion', time >= 424 and 360 or -360, 1)
            ease(time, 2, 'confusion', 0, 'cubeOut', (1+playerA)%2)

            set(time, 'tipsy', -3 * (beat%4==0 and 1 or -1), 0)
            ease(time, 2, 'tipsy', 0, 'cubeOut', 0)
        end

        if beat%2==1 then
            set(time, 'wiggle', 10 * (beat%4==1 and 1 or -1), -1)
            ease(time, 2, 'wiggle', 0, 'cubeOut', -1)
        else
        end
    end

    ease(456, 3.5, 'transformX', -350, 'quadOut', 0)
    ease(456, 3.5, 'transformX', 350, 'quadOut', 1)
    ease(456, 3.5, 'alpha', 1, 'quadOut', -1)
end

local faroff = {-2 ,-1, 1, 2}
local odd = {-1 ,1, -1, 1}
function onUpdate(elapsed)
    if not inGameOver and HardMode then
        for i = 0, getProperty('notes.length') -1 do
            local pos = getPropertyFromGroup("notes", i, 'strumTime')
            local beatPos = pos / crochet
            local distance = (pos - getSongPosition()) * 0.1
            local data = getPropertyFromGroup("notes", i, 'noteData')
            local sus = getPropertyFromGroup("notes", i, 'isSustainNote')
            local susO = sus and susOff or 0
            local id = (math.floor(pos)%16)
            if pos >= 35056 and pos < 53932 then
                setPropertyFromGroup("notes", i, 'offsetX', (distance * faroff[data%4 + 1]) + susO)
            end
            if (pos >= 53932 and pos < 56292) or (beatPos >= 232 and beatPos < 264) then
                setPropertyFromGroup("notes", i, 'offsetX', (math.sin(distance*0.1) * distance * 2 * (odd[data%4 + 1])) + susO)
            end
            if (beatPos >= 264 and beatPos < 328) then
                setPropertyFromGroup("notes", i, 'offsetX', (math.sin(distance*0.1) * distance * 8 * ((id-2)%4 +1) * (id%2==0 and -1 or 1)) + susO)
            end
        end
    end
end