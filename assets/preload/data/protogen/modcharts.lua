function onCreate()
    if SourceCodeVer then
        setProperty('useModchart', true)
    end
end

function onCreatePost()
    luaDebugMode = true
    if SourceCodeVer then
        if HardMode and Modchart then
            setProperty('spawnTime', 2500)
            initModcharts()
            runHaxeCode([[
                for (strum in game.strumLineNotes) {
                    strum.scrollFactor.set(0, 0);
                }
        
                for (note in game.unspawnNotes) {
                    note.scrollFactor.set(0, 0);
                }
            ]]) -- cant even read lol
            setPropertyFromClass("NoteSplash", 'scrollX', 0)
            setPropertyFromClass("NoteSplash", 'scrollY', 0)
            setPropertyFromClass("NoteHoldSplash", 'scrollX', 0)
            setPropertyFromClass("NoteHoldSplash", 'scrollY', 0)

            setObjectOrder("grpNoteSplashes", getObjectOrder("strumLineNotes") + 1)
            setObjectOrder("grpNoteHoldSplashes", getObjectOrder("strumLineNotes") + 1)
        else
            if Mechanic then
                setValue('opponentSwap', 1)
                if not EasyMode then
                    setValue('opponentSwap', 0.86)
                    setValue('transformX', 100)
                end
            end
        end
    end
end

local bf = 0
local dad = 1
function initModcharts()
    setValue('opponentSwap', 0.5)
    setValue('sudden', 1)
    setValue('suddenOffset', 0.5)
    setValue('alpha', 1)
    setValue('transformY', -100)
    setValue('wiggleFreq', 0.5)
    setValue('xmod', 0.85)

    ease(0, 2, 'alpha', 0, 'quadOut', dad)
    ease(0, 2, 'transformY', 0, 'quadOut', dad)
    ease(14, 2, 'alpha', 0, 'expoIn', bf)
    ease(14, 2, 'transformY', 0, 'expoIn', bf)
    ease(14, 2, 'alpha', 1, 'expoIn', dad)
    ease(14, 2, 'transformY', 100, 'expoIn', dad)

    ease(30, 2, 'alpha', 0, 'expoIn', dad)
    ease(30, 2, 'transformY', 0, 'expoIn', dad)
    ease(30, 2, 'opponentSwap', 1, 'expoIn')
    local beatFunc = function(time) 
        set(time, 'tipsy', 1) ease(time, 1, 'tipsy', 0, 'quadOut')
        set(time, 'drunk', time%3==0 and 2 or -2) ease(time, 1, 'drunk', 0, 'quadOut')
    end
    for beat = 0, (4)-1 do
        local time = 0 + beat * 8

        beatFunc(0 + time)
        beatFunc(1.5 + time)
        beatFunc(3 + time)
        beatFunc(4.5 + time)
        beatFunc(6 + time)
        beatFunc(7 + time)
    end
    set(32, 'beat', 2)
    for beat = 0, (4*4)-1 do
        local time = 32 + beat

        if time < 46 then
            if beat % 2 == 0 then
                ease(time, 0.5, 'beat', 2)
            else
                ease(time, 0.5, 'beat', -2)
            end
        end
    end
    set(46, 'beat', 0)
    ease(46, 1, 'opponentSwap', 0, 'quadOut')
    ease(47, 1, 'opponentSwap', 0.9, 'quadOut')
    ease(48, 8, 'alpha', 1, 'linear', dad)
    ease(48, 8, 'opponentSwap', 0.5, 'sineInOut')

    set(62, 'transformX', 1000, dad)
    ease(62, 0.2, 'alpha', 0, 'linear', dad)
    ease(62, 1, 'transformX', 0, 'expoIn', dad)
    ease(62, 1, 'transformX', 0, 'expoIn', dad)
    ease(63, 1, 'transformX', -200, 'quadOut', bf)
    ease(63, 1, 'alpha', 1, 'quadOut', bf)

    for beat = 0, (4*16)-1 do
        local time = 64 + beat

        local intensity = 0.1;
        if time ~= 127 then
            if beat % 2 == 0 then
                ease(time-0.5, 0.5, 'transform0Z', intensity, 'expoIn')
                ease(time-0.5, 0.5, 'transform1Z', -intensity, 'expoIn')
                ease(time-0.5, 0.5, 'transform2Z', intensity, 'expoIn')
                ease(time-0.5, 0.5, 'transform3Z', -intensity, 'expoIn')
                ease(time-0.5, 0.5, 'confusion0', 360, 'quadIn')
                ease(time-0.5, 0.5, 'confusion1', -360, 'quadIn')
                ease(time-0.5, 0.5, 'confusion2', 360, 'quadIn')
                ease(time-0.5, 0.5, 'confusion3', -360, 'quadIn')
            else
                ease(time-0.5, 0.5, 'transform0Z', -intensity, 'expoIn')
                ease(time-0.5, 0.5, 'transform1Z', intensity, 'expoIn')
                ease(time-0.5, 0.5, 'transform2Z', -intensity, 'expoIn')
                ease(time-0.5, 0.5, 'transform3Z', intensity, 'expoIn')
                ease(time-0.5, 0.5, 'confusion0', 0, 'quadIn')
                ease(time-0.5, 0.5, 'confusion1', 0, 'quadIn')
                ease(time-0.5, 0.5, 'confusion2', 0, 'quadIn')
                ease(time-0.5, 0.5, 'confusion3', 0, 'quadIn')
            end
        end
            
    end

    ease(94, 2, 'alpha', 0, 'quadInOut', bf)
    ease(94, 2, 'transformX', 0, 'quadInOut', bf)
    ease(94, 2, 'opponentSwap', 0.16, 'quadInOut')

    ease(127, 1, 'confusion0', 0, 'quadOut')
    ease(127, 1, 'confusion1', 0, 'quadOut')
    ease(127, 1, 'confusion2', 0, 'quadOut')
    ease(127, 1, 'confusion3', 0, 'quadOut')
    ease(127, 1, 'transform0Z', 0, 'quadOut')
    ease(127, 1, 'transform1Z', 0, 'quadOut')
    ease(127, 1, 'transform2Z', 0, 'quadOut')
    ease(127, 1, 'transform3Z', 0, 'quadOut')
    ease(127, 1, 'opponentSwap', 0.9, 'quadOut')

    for beat = 0, 1 do
        local time = 128

        beatFunc(0 + time)
        beatFunc(1.5 + time)
        beatFunc(3 + time)
        beatFunc(4.5 + time)
        beatFunc(6 + time)
        beatFunc(7 + time)
    end
    for beat = 0, 1 do
        local time = 144

        beatFunc(0 + time)
        beatFunc(1.5 + time)
        beatFunc(3 + time)
        beatFunc(4.5 + time)
        beatFunc(6 + time)
        beatFunc(7 + time)
    end

    ease(136, 8, 'opponentSwap', 0.1, 'linear')
    ease(136, 8, 'confusion', 360, 'linear')
    ease(152, 2, 'opponentSwap', 0.5, 'quadOut')
    ease(152, 2, 'confusion', 0, 'quadOut')
    ease(158, 2, 'opponentSwap', 0.9, 'quadInOut')

    set(160, 'beat', 2)
    for beat = 0, (4*4)-1 do
        local time = 160 + beat

        if time < 174 then
            if beat % 2 == 0 then
                ease(time, 0.5, 'beat', 2)
                ease(time, 1, 'centerrotateZ', 0.5, 'quadOut')
            else
                if time == 173 then
                    ease(time, 1, 'centerrotateZ', 0, 'quadOut')
                    ease(time, 0.5, 'beat', 0)
                else
                    ease(time, 1, 'centerrotateZ', -0.5, 'quadOut')
                    ease(time, 0.5, 'beat', -2)
                end
            end
        end
    end

    ease(174, 1, 'opponentSwap', 0, 'quadOut')
    ease(175, 1, 'opponentSwap', 0.9, 'quadOut')
    ease(176, 8, 'alpha', 1, 'linear', dad)
    ease(176, 8, 'opponentSwap', 0.5, 'sineInOut')

    set(188, 'alpha', 1, bf)
    set(188, 'flip', -1, dad)
    ease(188, 4, 'alpha', 0, 'quadOut', dad)
    ease(188, 4, 'flip', 0, 'quadOut', dad)

    local switch = false
    local hardBeat = function(time)
        switch = switch == false
        local who = time < 208 and dad or bf
        set(time, 'flip', -0.7, who)
        ease(time, 1, 'flip', 0, 'quadOut', who)
        set(time, 'tipsy', 2 * (switch and 1 or -1), who)
        ease(time, 1, 'tipsy', 0, 'quadOut', who)
    end
    for beat = 0, (4*8)-1 do
        local time = 192 + beat
        if time < 220 then
            hardBeat(time)
        end
    end
    hardBeat(199.5)
    hardBeat(207.25) hardBeat(207.5) hardBeat(207.75)
    hardBeat(215.25) hardBeat(215.5)
    hardBeat(216.5)

    ease(206, 2, 'alpha', 1, 'linear', dad)
    ease(206, 2, 'alpha', 0, 'linear', bf)
    ease(220, 4, 'flip', 0.25, 'quadOut')
    set(224, 'alpha', 0, dad)
    set(224, 'opponentSwap', 1)
    set(224, 'tipZ', 0.25)
    set(224, 'tipsy', 0.4)
    set(224, 'xmod', 0.75)
    set(224, 'suddenOffset', 0.5)

    ease(224, 4, 'flip', 0, 'quadOut', dad)
    ease(224, 4, 'alpha', 0, 'quadOut', dad)
    set(224, 'dark', 1, bf)
    ease(232, 4, 'flip', 0, 'quadOut', bf)
    ease(232, 4, 'dark', 0, 'quadOut', bf)

    set(288, 'tipZ', 0)
    set(288, 'tipsy', 0)
    set(288, 'xmod', 0.85)
    set(288, 'suddenOffset', 0.5)

    local switchBool = false
    local kickbeat = function(time)
        switchBool = switchBool == false
        set(time, 'xmod', 0.5)
        ease(time+0.001, 0.5, 'xmod', 0.75, 'quadOut')
        set(time, 'invert', 0.2 * (switchBool and 1 or -1))
        ease(time+0.001, 0.5, 'invert', 0, 'quadOut')
    end
    local kicksnare = function(time)
        set(time, 'wiggle', 4)
        ease(time, 4, 'wiggle', 0, 'expoOut')
    end
    kickbeat(256)
    kickbeat(257.5)
    kickbeat(259)
    kickbeat(259.5)
    kickbeat(261)
    kickbeat(263.5)

    kickbeat(264)
    kickbeat(265.5)
    kickbeat(269)
    kickbeat(270.5)
    kickbeat(271.5)

    kicksnare(257)
    kicksnare(262)
    kicksnare(266)
    kicksnare(270)

    for beat = 0, (2*4)-1 do
        kickbeat(272 + beat)
    end
    for beat = 0, (4)-1 do
        kickbeat(280 + beat)
        kickbeat(280.5 + beat)
    end
    ease(284, 2, 'wiggle', 10, 'quadIn')
    ease(286, 2, 'wiggle', 0, 'quadOut')
    
    for beat = 0, (4*15)-1 do
        local time = 288 + beat
        if time % 2 == 0 then
            ease(time, 1, 'transformZ', 0.3, 'quadInOut', dad)
            ease(time, 1, 'transformZ', -0.02, 'quadInOut', bf)
        else 
            ease(time, 1, 'transformZ', -0.02, 'quadInOut', dad)
            ease(time, 1, 'transformZ', 0.3, 'quadInOut', bf)
        end
        if time >= 304 and time < 336 then
            if time >= 320 then
                set(time, 'tipsy', 2 * (beat%2==0 and 1 or -1))
                ease(time, 1, 'tipsy', 0, 'quadOut')
            else
                set(time, 'invert', 0.4 * (beat%2==0 and 1 or -1))
                ease(time, 1, 'invert', 0, 'quadOut')
            end
        end
    end
    ease(348, 4, 'transformZ', 0, 'quadOut')

    ease(352, 1, 'opponentSwap', 0.5, 'quadOut')
    ease(352, 1, 'transformZ', -0.2, 'quadOut', bf)

    ease(382, 2, 'transformZ', 0, 'quadIn', bf)
    ease(384, 1, 'transformZ', 0.2, 'quadOut', dad)


    for beat = 0, (4*16)-1 do
        local time = 352 + beat
        ease(time, 1, 'transformX', 75 * (beat%2==0 and 1 or -1), 'linear')
        ease(time, 0.5, 'transformY', -40 * (downscroll and -1 or 1), 'quadOut')
        ease(time+0.5, 0.5, 'transformY', 0, 'quadIn')

        set(time, 'wiggle', 6 * (beat%2==0 and 1 or -1))
        ease(time, 1, 'wiggle', 0, 'quadOut')

        if (beat % 4 == 0) then
            if time < 384 then
                ease(time, 1, 'reverse', beat%8==0 and 0 or 1, 'quadOut', dad)
            else
                ease(time, 1, 'reverse', beat%8==0 and 0 or 1, 'quadOut', bf)
            end        
        end
    end
    ease(384, 1, 'reverse', 0, 'quadOut', dad)
    set(416, 'transformX', 0)
    set(416, 'reverse', 0)
    set(416, 'transformZ', 0)
    set(416, 'alpha', 1, dad)
    set(416, 'xmod', 0.6)

    ease(448, 24, 'alpha', 0, 'linear', dad)
    ease(464, 14, 'opponentSwap', 1, 'sineInOut')
    
    set(480, 'xmod', 0.92)
    set(480, 'beat', 2)
    set(480, 'transformX', 0)
    for beat = 0, (4*32)-1 do
        local time = 480 + beat

        if beat % 2 == 0 then
            ease(time, 0.5, 'beat', 2)
        else
            ease(time, 0.5, 'beat', -2)
        end
  
    end

    ease(544, 8, 'centerrotateY', 1, 'linear')
    ease(552, 8, 'centerrotateY', 0, 'linear')
    ease(560, 8, 'centerrotateY', -1, 'linear')
    ease(568, 8, 'centerrotateY', 0, 'linear')

    ease(544 + 32, 8, 'centerrotateY', 1, 'linear')
    ease(552 + 32, 8, 'centerrotateY', 0, 'linear')
    ease(560 + 32, 8, 'centerrotateY', -1, 'linear')
    ease(568 + 32, 8, 'centerrotateY', 0, 'linear')

    set(608, 'xmod', 0.6)
    set(608, 'beat', 0)

    ease(640, 8, 'alpha', 1, 'linear')
end