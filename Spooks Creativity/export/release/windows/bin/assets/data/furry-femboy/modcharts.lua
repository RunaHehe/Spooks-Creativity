function onCreate()
    luaDebugMode = true
    if Modchart then
        setProperty('useModchart', true)
        setPropertyFromClass("ClientPrefs", "middleScroll", false)
    end
end
function onCreatePost() if Modchart then initModchart() end end
function onDestroy() setPropertyFromClass("ClientPrefs", "middleScroll", middlescroll) end


--ease(step, duration, modName, percent, style, player,startVal) 
--set(step, modName, perc, player)
local notesSpace = 635
local noteSus = 36
local bf = 0 dad = 1
function initModchart()
    setProperty('spawnTime', 2500);

    local mod = downscroll and -1 or 1
    setValue('transformY', -155 * mod)
    setValue('opponentSwap', 0.5)
    setValue('wiggleFreq', 1)

    ease(8, 1 ,'transformY', 0, 'quadOut', dad)
    for beat = 0, (4*8)-2 do
        local time = 8 + beat
        if not EasyMode then
            ease(time, 1 ,'centerrotateZ', beat % 2 == 0 and 0.3 or -0.3, 'linear', dad)
            if HardMode then
                ease(time, 1 ,'transformX', beat % 2 == 0 and 50 or -50, 'linear', dad)
            end
        end
        ease(time, 1 ,'confusion', beat % 2 == 0 and 11 or -11, 'linear', dad)
        ease(time, 0.5 ,'reverse', 0.2, 'quadOut', dad)
        ease(time+0.5, 0.5 ,'reverse', 0, 'quadIn', dad)

        if time >= 24 then
            if not EasyMode then
                ease(time, 1 ,'centerrotateZ', beat % 2 == 0 and -0.3 or 0.3, 'linear', bf)
                if HardMode then
                    ease(time, 1 ,'transformX', beat % 2 == 0 and -50 or 50, 'linear', bf)
                end
            end
            ease(time, 1 ,'confusion', beat % 2 == 0 and -11 or 11, 'linear', bf)
            ease(time, 0.5 ,'reverse', 0.2, 'quadOut', bf)
            ease(time+0.5, 0.5 ,'reverse', 0, 'quadIn', bf)
        end

        if beat % 2 == 1 and time ~= 23 and time ~= 39 then 
            local short = 1
            easeB(time, short ,'wiggle', 0, 'quadOut', -1, 10)
        end
    end
    easeB(22, 0.75 ,'wiggle', 0, 'quadOut', -1, 10)
    easeB(22.75, 0.75 ,'wiggle', 0, 'quadOut', -1, 10)
    easeB(23.5, 0.5 ,'wiggle', 0, 'quadOut', -1, 10)
    easeB(38, 0.75 ,'wiggle', 0, 'quadOut', -1, 10)
    easeB(38.75, 0.75 ,'wiggle', 0, 'quadOut', -1, 10)
    easeB(39.5, 0.5 ,'wiggle', 0, 'quadOut', -1, 10)

    ease(39, 1, 'transformX', 0, 'linear')
    ease(39, 1, 'centerrotateZ', 0, 'linear')
    ease(39, 0.5, 'reverse', 0.2, 'quadOut')
    ease(39.5, 0.5, 'reverse', 0, 'quadIn')
    ease(39, 1, 'confusion', 0, 'linear')

    set(40, 'xmod', -0.75)
    ease(40, 4, 'xmod', 0.75, 'quadOut')

    ease(22, 0.5 ,'alpha', EasyMode and 0.6 or 0.5, 'quadOut', dad)
    ease(24, 1 ,'transformY', 0, 'quadOut', bf)

    ease(43, 1 ,'transformZ', -0.2, 'quadInOut', dad)
    set(44, 'wiggleFreq', 0.25)
    --set(44-4, 'xmod', 0.75)
    for beat = 0, (4*8)-1 do
        local time = 44 + beat
        if time ~= 75 then
            ease(time, 1, 'transformZ', beat % 2 == 0 and 0 or -0.2, beat % 2 == 0 and 'linear' or 'quadOut', dad)
            ease(time, 1, 'transformZ', beat % 2 == 1 and 0 or -0.2, beat % 2 == 1 and 'linear' or 'quadOut', bf)
        end

        local mul = (EasyMode and 0.2 or 1)
        local bounciness = 250 * mul
        if beat % 2 == 0 then
            ease(time, 0.5, 'transformX', time % 4 == 0 and bounciness or -bounciness, 'quadOut', dad)
            ease(time+0.5, 0.5, 'transformX', 0, 'quadIn', dad)

            ease(time, 0.5, 'wiggle', (time % 4 == 0 and 13 or -13) * mul, 'quadOut', bf)
            ease(time+0.5, 0.5, 'wiggle', 0, 'quadIn', bf)

            if HardMode then
                ease(time, 0.5, 'flip', 0.3, 'quadOut', bf)
                ease(time+0.5, 0.5, 'flip', 0, 'quadIn', bf)
            end
        end
        if beat % 2 == 1 then
            ease(time, 0.5, 'transformX', time % 4 == 1 and -bounciness or bounciness, 'quadOut', bf)
            ease(time+0.5, 0.5, 'transformX', 0, 'quadIn', bf)

            ease(time, 0.5, 'wiggle', (time % 4 == 1 and -13 or 13) * mul, 'quadOut', dad)
            ease(time+0.5, 0.5, 'wiggle', 0, 'quadIn', dad)

            if HardMode and time < 75 then
                ease(time, 0.5, 'flip', 0.3, 'quadOut', dad)
                ease(time+0.5, 0.5, 'flip', 0, 'quadIn', dad)
            end
        end
    end
    ease(75, 1, 'transformZ', 0, 'linear')
    if not EasyMode then
        ease(75, 1, 'flip', 0.5, 'quadin')
        ease(75, 1, 'alpha', 0.75, 'quadin', dad)
        ease(75, 1, 'reverse', 0.5, 'quadin')
        -- if HardMode then
        --     easeB(76, 108-76, 'tipsy', 0, 'linear', -1 ,1)
        -- end
    else 
        ease(76, 2, 'opponentSwap', 0, 'quadOut')
        ease(76, 2, 'alpha', 0, 'quadOut')
    end
    ease(84, 4, 'confusion', 360, 'circOut')  easeB(84, 4, 'xmod', 0.75, 'quadOut', -1, 0.6)
    ease(92, 4, 'confusion', 0, 'circOut')  easeB(92, 4, 'xmod', 0.75, 'quadOut', -1, 0.6)
    ease(100, 4, 'confusion', -360, 'circOut')  easeB(100, 4, 'xmod', 0.75, 'quadOut', -1, 0.6)
    easeB(104, 1, 'xmod', 0.75, 'quadOut', -1, 0.6)
    easeB(104 + 3/4, 1, 'xmod', 0.75, 'quadOut', -1, 0.9)
    easeB(105.5, 1, 'xmod', 0.75, 'quadOut', -1, 0.6)
    easeB(106, 1, 'xmod', 0.75, 'quadOut', -1, 0.9)
    easeB(106 + 3/4, 1, 'xmod', 0.75, 'quadOut', -1, 0.6)
    easeB(107.5, 1, 'xmod', 0.75, 'quadOut', -1, 0.9)
    set(108, 'confusion', 0)

    ease(108, 1, 'reverse', 0, 'quadOut')
    ease(108, 1, 'flip', 0, 'quadOut')
    --ease(108, 1, 'opponentSwap', 1, 'quadOut')
    ease(108, 1, 'xmod', EasyMode and 1 or 0.8, 'quadOut')
    ease(108, 1, 'alpha', EasyMode and 0 or 0.65, 'quadOut', dad)

    local debounce = false
    for beat = 0, (4*8)-1 do
        local time = 108 + beat
        if beat % 2 == 0 then
            if not EasyMode then
                ease(time, 0.5, 'opponentSwap', beat%4==0 and 1 or 0, 'quadOut')
            end
            debounce = debounce == false
            easeB(time, 0.5, 'transformX', 0, 'quadOut', -1, 35 * (debounce and 1 or -1))
            easeB(time+0.75, 0.5, 'transformX', 0, 'quadOut', -1, -35 * (debounce and 1 or -1))
            easeB(time+1.5, 0.5, 'transformX', 0, 'quadOut', -1, 35 * (debounce and 1 or -1))


            easeB(time, 0.5, 'transformZ', 0, 'quadOut', -1, -0.2)
            easeB(time+0.75, 0.5, 'transformZ', 0, 'quadOut', -1, -0.2)
            easeB(time+1.5, 0.5, 'transformZ', 0, 'quadOut', -1, -0.2)

            easeB(time, 0.5, 'wiggle', 0, 'quadOut', -1, 3 * (debounce and 1 or -1))
            easeB(time+0.75, 0.5, 'wiggle', 0, 'quadOut', -1, -3 * (debounce and 1 or -1))
            easeB(time+1.5, 0.5, 'wiggle', 0, 'quadOut', -1, 3 * (debounce and 1 or -1))

            if HardMode then
                easeB(time, 0.5, 'tipsy', 0, 'quadOut', -1, 2)
                easeB(time+0.75, 0.5, 'tipsy', 0, 'quadOut', -1, 2)
                easeB(time+1.5, 0.5, 'tipsy', 0, 'quadOut', -1, 2)
            end
        end

    end
    ease(140, 16, 'hidden', EasyMode and 0.9 or 1, 'linear')
    if HardMode then
        ease(140, 16, 'tipZ', 1, 'linear')
    end
    ease(140, 1, 'alpha', 0, 'linear', dad)

    for beat = 0, (4*8)-1 do
        local time = 140 + beat
        if beat % 4 == 0 then
            easeB(time, 1, 'transformX', 0, 'quadOut', -1, -50)
            easeB(time+2.5, 1, 'transformX', 0, 'quadOut', -1, 50)
        end
        if beat % 8 == 0 then
            easeB(time+4+3.5, 0.5, 'transformX', 0, 'quadOut', -1, 50)
        end
    end
    ease(143, 0.5, 'invert', -0.4, 'quadOut', bf)
    ease(144, 0.5, 'invert', 1, 'quadOut', bf)
    ease(147, 0.5, 'invert', 1.4, 'quadOut', bf)
    ease(148, 0.5, 'invert', 0, 'quadOut', bf)
    ease(151, 0.3, 'invert', 1, 'quadOut', bf)
    ease(151.5, 0.3, 'invert', 0, 'quadOut', bf)
    ease(152, 0.3, 'invert', 1, 'quadOut', bf)
    ease(155.25, 0.3, 'invert', 0, 'quadOut', bf)


    ease(172, 1, 'alpha', EasyMode and 0 or 0.5, 'linear', dad)
    ease(172, 1, 'wave', 1)
    ease(172, 1, 'xmod', 0.75)
    ease(172, 1, 'hidden', 0)
    if HardMode then
        ease(172, 1, 'tipZ', 0)
    end
    for beat = 0, (4*8)-1 do
        local time = 172 + beat
        if beat % 2 == 0 then
            if not EasyMode then
                ease(time, 0.5, 'opponentSwap', beat%4==0 and 1 or 0, 'quadOut')
            end
            debounce = debounce == false
            easeB(time, 0.5, 'transformX', 0, 'quadOut', -1, 35 * (debounce and 1 or -1))
            easeB(time+0.75, 0.5, 'transformX', 0, 'quadOut', -1, -35 * (debounce and 1 or -1))
            easeB(time+1.5, 0.5, 'transformX', 0, 'quadOut', -1, 35 * (debounce and 1 or -1))


            easeB(time, 0.5, 'transformZ', 0, 'quadOut', -1, -0.2)
            easeB(time+0.75, 0.5, 'transformZ', 0, 'quadOut', -1, -0.2)
            easeB(time+1.5, 0.5, 'transformZ', 0, 'quadOut', -1, -0.2)

            easeB(time, 0.5, 'wiggle', 0, 'quadOut', -1, 3 * (debounce and 1 or -1))
            easeB(time+0.75, 0.5, 'wiggle', 0, 'quadOut', -1, -3 * (debounce and 1 or -1))
            easeB(time+1.5, 0.5, 'wiggle', 0, 'quadOut', -1, 3 * (debounce and 1 or -1))

            if HardMode then
                easeB(time, 0.5, 'tipsy', 0, 'quadOut', -1, 2)
                easeB(time+0.75, 0.5, 'tipsy', 0, 'quadOut', -1, 2)
                easeB(time+1.5, 0.5, 'tipsy', 0, 'quadOut', -1, 2)
            end
        end

    end
    ease(204, 1, 'wave', 0)
    ease(206-0.25, 0.25, 'tipsy', 2, 'expoIn') ease(206, 0.6, 'tipsy', 0, 'quadOut')
    ease(206.75-0.25, 0.25, 'tipsy', -2, 'expoIn') ease(206.75, 0.6, 'tipsy', 0, 'quadOut')
    ease(207.5-0.25, 0.25, 'tipsy', 2, 'expoIn') ease(207.5, 0.6, 'tipsy', 0, 'quadOut')

    ease(208, 1, 'transformZ', -0.3, 'quadOut', bf)
    ease(208, 1, 'opponentSwap', 0.5, 'quadOut')
    ease(208, 1, 'alpha', 0, 'linear')
    for beat = 0, (4*16)-1-1 do
        local time = 208 + beat
        if not EasyMode then
            ease(time, 1 ,'centerrotateZ', beat % 2 == 0 and 0.3 or -0.3, 'linear', dad)
        end
        ease(time, 1 ,'confusion', beat % 2 == 0 and 11 or -11, 'linear', dad)
        if time >= 240 and not EasyMode then
            ease(time, 0.5 ,'reverse', (time%2==0 and 0.2 or 0.8), 'quadOut', dad)
            ease(time+0.5, 0.5 ,'reverse', (time%2==0 and 1 or 0), 'quadIn', dad)
        else
            ease(time, 0.5 ,'reverse', 0.2, 'quadOut', dad)
            ease(time+0.5, 0.5 ,'reverse', 0, 'quadIn', dad)
        end

        if time >= 224 then
            if not EasyMode then
                ease(time, 1 ,'centerrotateZ', beat % 2 == 0 and -0.3 or 0.3, 'linear', bf)
            end
            ease(time, 1 ,'confusion', beat % 2 == 0 and -11 or 11, 'linear', bf)
            if time >= 240 and not EasyMode then
                ease(time, 0.5 ,'reverse', (time%2==0 and 0.2 or 0.8), 'quadOut', bf)
                ease(time+0.5, 0.5 ,'reverse', (time%2==0 and 1 or 0), 'quadIn', bf)
            else
                ease(time, 0.5 ,'reverse', 0.2, 'quadOut', bf)
                ease(time+0.5, 0.5 ,'reverse', 0, 'quadIn', bf)
            end
        end

        if beat % 2 == 1 and time ~= 223 and time ~= 239 then 
            local short = 1
            easeB(time, short ,'wiggle', 0, 'quadOut', -1, 10)
        end
    end
    easeB(222, 0.75 ,'wiggle', 0, 'quadOut', -1, 10)
    easeB(222.75, 0.75 ,'wiggle', 0, 'quadOut', -1, 10)
    easeB(223.5, 0.5 ,'wiggle', 0, 'quadOut', -1, 10)
    easeB(238, 0.75 ,'wiggle', 0, 'quadOut', -1, 10)
    easeB(238.75, 0.75 ,'wiggle', 0, 'quadOut', -1, 10)
    easeB(239.5, 0.5 ,'wiggle', 0, 'quadOut', -1, 10)
    ease(223, 1, 'transformZ', 0, 'quadInOut', bf)
    ease(223, 1, 'alpha', EasyMode and 0.4 or 0.25, 'quadInOut', dad)

    ease(271, 1, 'centerrotateZ', 0, 'linear')
    ease(271, 0.5, 'reverse', 0.2, 'quadOut')
    ease(271.5, 0.5, 'reverse', 0, 'quadIn')
    ease(271, 1, 'confusion', 0, 'linear')

    ease(272, 2, 'opponentSwap', 0, 'quadOut')
    if EasyMode then
        ease(272, 2, 'alpha', 0, 'quadOut')
        ease(272, 2, 'xmod', 1, 'quadOut')
        local debounce = false
        for beat = 0, (4*24)-1 do
            local time = 272 + beat
            if time % 2 == 0 and (time < 302 or time >= 304) then
                debounce = debounce == false
                easeB(time, 0.5, 'transformX', 0, 'quadOut', -1, 50 * (debounce and 1 or -1))
                easeB(time+0.75, 0.5, 'transformX', 0, 'quadOut', -1, -50 * (debounce and 1 or -1))
                easeB(time+1.5, 0.5, 'transformX', 0, 'quadOut', -1, 50 * (debounce and 1 or -1))
            end
        end
    elseif HardMode then
        set(272, 'wiggleFreq', 0.3)
        for beat = 0, (4*24)-1 do
            local time = 272 + beat
            if time % 2 == 0 and (time < 302 or time >= 304) then
                debounce = debounce == false
                easeB(time, 0.5, 'tipsy', 0, 'quadOut', -1, 2 * (debounce and 1 or -1))
                easeB(time+0.75, 0.5, 'tipsy', 0, 'quadOut', -1, -2 * (debounce and 1 or -1))
                easeB(time+1.5, 0.5, 'tipsy', 0, 'quadOut', -1, 2 * (debounce and 1 or -1))
                if time >= 304 then
                    if time % 2 == 0 then
                        ease(time, 1, 'wiggle', time%4==0 and 4 or -4, 'quadOut')
                        ease(time+1, 1, 'wiggle', 0, 'quadIn')
                    end
                else
                    if time % 4 == 0 then
                        ease(time, 2, 'wiggle', time%8==0 and 3 or -3, 'quadOut')
                        ease(time+2, 2, 'wiggle', 0, 'quadIn')
                    end
                end
            end
        end
    end
    ease(368, 2, 'alpha', 0, 'linear')
end


function onUpdate(elapsed)
    local dat = {}
    if not inGameOver and Modchart then
        for i = 0, getProperty('notes.length')-1 do
            local strumTime = getPropertyFromGroup('notes', i, 'strumTime')
            local distance = (strumTime - getSongPosition())*0.4
            local mustPress = getPropertyFromGroup('notes', i, 'mustPress')
            local sus = getPropertyFromGroup('notes', i, 'isSustainNote')
            local susDis = sus and noteSus or 0
            if not EasyMode and strumTime >= 32571.4 and strumTime < 46285.7 then -- note come to center
                local extra = (mustPress and 1 or 0) + ((mustPress and not sus and table.contains(dat, strumTime)) and 0.5 or 0)
                local x = math.sin(strumTime + extra) * (distance*(getValue('xmod')+0.25))
                local y = math.cos(strumTime + extra) * (distance*(getValue('xmod')+0.25))
                setPropertyFromGroup('notes', i, 'offsetX', x)
                setPropertyFromGroup('notes', i, 'offsetY', y)
                if mustPress then
                    table.insert(dat, strumTime)
                end
            end
            if not EasyMode and strumTime >= 46285.7 and curStep < 432 then
                setPropertyFromGroup('notes', i, 'offsetY', distance * (downscroll and -1 or 1))
            end
            if not EasyMode and curStep >= 432 and curStep < 560 and strumTime < 60000 then
                local strumStep = strumTime / stepCrochet
                local stepMove = getValue('opponentSwap') * (notesSpace * (mustPress and 1 or -1))
                setPropertyFromGroup('notes', i, 'offsetX', stepMove + susDis + ((strumStep%16 <= 8) and (notesSpace * (mustPress and -1 or 1)) or 0))
                setPropertyFromGroup('notes', i, 'offsetY', 0)
            end

            if not EasyMode and curStep >= 688 and curStep < 816 and strumTime < 87426.5 then
                local strumStep = strumTime / stepCrochet
                local stepMove = getValue('opponentSwap') * (notesSpace * (mustPress and 1 or -1))
                setPropertyFromGroup('notes', i, 'offsetX', stepMove + susDis + ((strumStep%16 <= 8) and (notesSpace * (mustPress and -1 or 1)) or 0))
                setPropertyFromGroup('notes', i, 'offsetY', 0)
            end
        end
    end
end


function onStepEvent(curStep)
    if Modchart then
        if curStep == 288 then
            setProperty('spawnTime', 4500)
        end  
        if curStep == 432 then
            setProperty('spawnTime', 2500)
        end  
    end
end

function table.contains(table, element)
    for _, value in pairs(table) do
      if value == element then
        return true
      end
    end
    return false
end

function easeB(beat, duration, modName, percent, style, player, startVal)
    set(beat, modName, startVal, player)
    ease(beat, duration ,modName, percent, style, player)
end
