function onCreate()
    setProperty('skipCountdown', true)
end

function onCreatePost()
    setupMods()
    setMod("dadY", -155)
    setMod("bfY", -155)
    setMod("wiggle", 1)
    setMod("opSwap", 0.5)
    setupEvents()
end

function setupMods()
    -- opponent
    startMod("dadY", "YDModifier", "opponent", -1)
    startMod("dadCenterRotate", "StrumAngleModifier", "opponent", -1)
    startMod("dadReverse", "ReverseModifier", "opponent", -1)
    startMod("dadX", "XModifier", "opponent", -1)
    startMod("dadStealth", "StealthModifier", "opponent", -1)
    startMod("dadZ", "ZModifier", "opponent", -1)
    startMod("dadFlip", "FlipModifier", "opponent", -1)
    startMod("dadWiggle", "InvertSineModifier", "opponent", -1)
    -- player
    startMod("bfY", "YDModifier", "player", -1)
    startMod("bfCenterRotate", "StrumAngleModifier", "player", -1)
    startMod("bfReverse", "ReverseModifier", "player", -1)
    startMod("bfX", "XModifier", "player", -1)
    startMod("bfStealth", "StealthModifier", "player", -1)
    startMod("bfZ", "ZModifier", "player", -1)
    startMod("bfFlip", "FlipModifier", "player", -1)
    startMod("bfWiggle", "InvertSineModifier", "player", -1)
    startMod("bfInv", "InvertModifier", "player", -1)
    -- both
    startMod("wiggle", "InvertSineModifier", "", -1)
    startMod("xmod", "SpeedModifier", "", -1)
    startMod("flip", "FlipModifier", "", -1)
    startMod("reverse", "ReverseModifier", "", -1)
    startMod("x", "XModifier", "", -1)
    startMod("z", "ZModifier", "", -1)
    startMod("tipsy", "TipsyYModifier", "", -1)
    startMod("hidden", "HiddenModifier", "", -1)
    startMod("tipsyZ", "TipsyZModifier", "", -1)
    startMod("wave", "WaveYModifier", "", -1)
end

function setupEvents()
    setProperty('spawnTime', 2500);
    ease(8, 1, "quadOut", "0, dadY")
    ease(24, 1, "quadOut", "0, bfY")
    for beat = 0, (4 * 8) - 2 do
        local time = 8 + beat
        ease(time, 1, "linear", [[
            ]] .. (beat % 2 == 0 and 27 or -27) .. [[, dadCenterRotate,
            ]] .. (beat % 2 == 0 and 11 or -11) .. [[, dadAngle,
            ]] .. (beat % 2 == 0 and 50 or -50) .. [[, dadX
        ]])
        ease(time, 0.5, "quadOut", "0.2, dadReverse")
        ease(time + 0.5, 0.5, "quadIn", "0, dadReverse")

        if time >= 24 then
            ease(time, 1, "linear", [[
                ]] .. (beat % 2 == 0 and -27 or 27) .. [[, bfCenterRotate,
                ]] .. (beat % 2 == 0 and -11 or 11) .. [[, bfAngle,
                ]] .. (beat % 2 == 0 and -50 or 50) .. [[, bfX
            ]])
            ease(time, 0.5, "quadOut", "0.2, bfReverse")
            ease(time + 0.5, 0.5, "quadIn", "0, bfReverse")
        end
        if beat % 2 == 1 and time ~= 23 and time ~= 39 then
            local short = 1
            easeB(time, short, 'wiggle', 0, 'quadOut', 10)
        end
    end
    easeB(22, 0.75, 'wiggle', 0, 'quadOut', 10)
    easeB(22.75, 0.75, 'wiggle', 0, 'quadOut', 10)
    easeB(23.5, 0.5, 'wiggle', 0, 'quadOut', 10)
    easeB(38, 0.75, 'wiggle', 0, 'quadOut', 10)
    easeB(38.75, 0.75, 'wiggle', 0, 'quadOut', 10)
    easeB(39.5, 0.5, 'wiggle', 0, 'quadOut', 10)

    ease(39, 1, "linear", [[
        0, bfX, 
        0, dadX, 
        0, dadCenterRotate,
        0, bfCenterRotate,
        0, bfAngle,
        0, dadAngle
    ]])
    ease(39, 0.5, "quadOut", "0.2, bfReverse, 0.2, dadReverse")
    ease(39 + 0.5, 0.5, "quadIn", "0, bfReverse, 0, dadReverse")

    ease(22, 0.5, 'quadOut', '0.5, dadStealth')

    set(40, '-0.75, xmod')
    ease(40, 4, 'quadOut', '0.75, xmod')
    ease(43, 1, "quadInOut", "-200, dadZ")

    for beat = 0, (4 * 8) - 1 do
        local time = 44 + beat
        if time ~= 75 then
            ease(time, 1, (beat % 2 == 0 and "linear or quadOut"), [[
                ]] .. (beat % 2 == 0 and 0 or -200) .. [[, dadZ,
                ]] .. (beat % 2 == 1 and 0 or -200) .. [[, bfZ
            ]])
        end

        local mul = 1
        local bounciness = 250 * mul
        if beat % 2 == 0 then
            ease(time, 0.5, "quadOut", (time % 4 == 0 and bounciness or -bounciness) .. ", dadX")
            ease(time + 0.5, 0.5, 'quadIn', '0, dadX')
            if NormalMode then
                ease(time, 0.5, 'quadOut', ((time % 4 == 0 and 6 or -6) * mul) .. ', bfWiggle')
            elseif HardMode then
                ease(time, 0.5, 'quadOut', ((time % 4 == 0 and 13 or -13) * mul) .. ', bfWiggle')
            end
            ease(time + 0.5, 0.5, 'quadIn', '0, bfWiggle')

            ease(time, 0.5, 'quadOut', '0.3, bfFlip')
            ease(time + 0.5, 0.5, 'quadIn', '0, bfFlip')
        end
        if beat % 2 == 1 then
            ease(time, 0.5, "quadOut", (time % 4 == 1 and -bounciness or bounciness) .. ", bfX")
            ease(time + 0.5, 0.5, 'quadIn', '0, bfX')

            ease(time, 0.5, 'quadOut', ((time % 4 == 1 and -13 or 13) * mul) .. ', dadWiggle')
            ease(time + 0.5, 0.5, 'quadIn', '0, dadWiggle')

            if time < 75 then
                ease(time, 0.5, 'quadOut', '0.3, dadFlip')
                ease(time + 0.5, 0.5, 'quadIn', '0, dadFlip')
            end
        end
    end
    set(75, "1, spiral")
    ease(75, 1, "linear", "0, dadZ, 0, bfZ")
    ease(75, 1, "quadIn", "0.5, flip, 0.75, dadStealth, 1, center")
    ease(84, 4, "circOut", "360, angle")
    easeB(84, 4, 'xmod', 0.75, 'quadOut', 0.6)
    ease(92, 4, 'circOut', '0, angle')
    easeB(92, 4, 'xmod', 0.75, 'quadOut', 0.6)
    ease(100, 4, 'circOut', '-360, angle')
    easeB(100, 4, 'xmod', 0.75, 'quadOut', 0.6)
    easeB(104 + 3 / 4, 1, 'xmod', 0.75, 'quadOut', 0.9)
    easeB(105.5, 1, 'xmod', 0.75, 'quadOut', 0.6)
    easeB(106, 1, 'xmod', 0.75, 'quadOut', 0.9)
    easeB(106 + 3 / 4, 1, 'xmod', 0.75, 'quadOut', 0.6)
    easeB(107.5, 1, 'xmod', 0.75, 'quadOut', 0.9)
    set(108, '0, angle, 0, spiral, 1, beatswap')

    ease(108, 1, "quadOut", "0, flip, 0, center, 0.8, xmod, 0.9, dadStealth, 0, opSwap")

    local debounce = false
    for beat = 0, (4 * 8) - 1 do
        local time = 108 + beat
        if beat % 2 == 0 then
            ease(time, 0.5, "quadOut", (beat % 4 == 0 and 1 or 0) .. ", beatswap:switchStrum")
            debounce = debounce == false

            easeB(time, 0.5, 'x', 0, 'quadOut', 35 * (debounce and 1 or -1))
            easeB(time + 0.75, 0.5, 'x', 0, 'quadOut', -35 * (debounce and 1 or -1))
            easeB(time + 1.5, 0.5, 'x', 0, 'quadOut', 35 * (debounce and 1 or -1))

            easeB(time, 0.5, 'z', 0, 'quadOut', -200)
            easeB(time + 0.75, 0.5, 'z', 0, 'quadOut', -200)
            easeB(time + 1.5, 0.5, 'z', 0, 'quadOut', -200)

            easeB(time, 0.5, 'wiggle', 0, 'quadOut', 3 * (debounce and 1 or -1))
            easeB(time + 0.75, 0.5, 'wiggle', 0, 'quadOut', -3 * (debounce and 1 or -1))
            easeB(time + 1.5, 0.5, 'wiggle', 0, 'quadOut', 3 * (debounce and 1 or -1))

            easeB(time, 0.5, 'tipsy', 0, 'quadOut', 2)
            easeB(time + 0.75, 0.5, 'tipsy', 0, 'quadOut', 2)
            easeB(time + 1.5, 0.5, 'tipsy', 0, 'quadOut', 2)
        end
    end
    set(140, "0, beatswap, 0, beatswap:switchStrum")
    ease(140, 16, "linear", "1, hidden, 1, tipsyZ")
    ease(140, 1, "linear", "0, dadStealth")

    for beat = 0, (4 * 8) - 1 do
        local time = 140 + beat
        if beat % 4 == 0 then
            easeB(time, 1, 'x', 0, 'quadOut', -50)
            easeB(time + 2.5, 1, 'x', 0, 'quadOut', 50)
        end
        if beat % 8 == 0 then
            easeB(time + 4 + 3.5, 0.5, 'x', 0, 'quadOut', 50)
        end
    end

    ease(143, 0.5, 'quadOut', '-0.4, bfInv')
    ease(144, 0.5, 'quadOut', '1, bfInv')
    ease(147, 0.5, 'quadOut', '1.4, bfInv')
    ease(148, 0.5, 'quadOut', '0, bfInv')
    ease(151, 0.3, 'quadOut', '1, bfInv')
    ease(151.5, 0.3, 'quadOut', '0, bfInv')
    ease(152, 0.3, 'quadOut', '1, bfInv')
    ease(155.25, 0.3, 'quadOut', '0, bfInv')

    ease(172, 1, "linear", "0.5, dadStealth")
    ease(172, 1, "", "0.75, xmod, 0, hidden, 0, tipsyZ")
    set(172, "1, beatswap")
    for beat = 0, (4 * 8) - 1 do
        local time = 172 + beat
        if beat % 2 == 0 then
            ease(time, 0.5, "quadOut", (beat % 4 == 0 and 1 or 0) .. ", beatswap:switchStrum")
            debounce = debounce == false
            easeB(time, 0.5, 'x', 0, 'quadOut', 35 * (debounce and 1 or -1))
            easeB(time + 0.75, 0.5, 'x', 0, 'quadOut', -35 * (debounce and 1 or -1))
            easeB(time + 1.5, 0.5, 'x', 0, 'quadOut', 35 * (debounce and 1 or -1))

            easeB(time, 0.5, 'z', 0, 'quadOut', -0.2)
            easeB(time + 0.75, 0.5, 'z', 0, 'quadOut', -0.2)
            easeB(time + 1.5, 0.5, 'z', 0, 'quadOut', -0.2)

            easeB(time, 0.5, 'wiggle', 0, 'quadOut', 3 * (debounce and 1 or -1))
            easeB(time + 0.75, 0.5, 'wiggle', 0, 'quadOut', -3 * (debounce and 1 or -1))
            easeB(time + 1.5, 0.5, 'wiggle', 0, 'quadOut', 3 * (debounce and 1 or -1))

            easeB(time, 0.5, 'tipsy', 0, 'quadOut', 2)
            easeB(time + 0.75, 0.5, 'tipsy', 0, 'quadOut', 2)
            easeB(time + 1.5, 0.5, 'tipsy', 0, 'quadOut', 2)
        end
    end
    set(204, "0, beatswap, 0, beatswap:switchStrum")
    ease(206 - 0.25, 0.25, 'expoIn', '2, tipsy')
    ease(206, 0.6, 'quadOut', '0, tipsy')
    ease(206.75 - 0.25, 0.25, 'expoIn', '2, tipsy')
    ease(206.75, 0.6, 'quadOut', '0, tipsy')
    ease(207.5 - 0.25, 0.25, 'expoIn', '2, tipsy')
    ease(207.5, 0.6, 'quadOut', '0, tipsy')

    ease(208, 1, 'quadOut', '-300, bfZ, 0.5, opSwap, 0, dadStealth')

    for beat = 0, (4 * 16) - 1 - 1 do
        local time = 208 + beat
        ease(time, 1, "linear", [[
            ]] .. (beat % 2 == 0 and 27 or -27) .. [[, dadCenterRotate,
            ]] .. (beat % 2 == 0 and 11 or -11) .. [[, dadAngle,
            ]] .. (beat % 2 == 0 and 50 or -50) .. [[, dadX
        ]])
        if time >= 240 then
            ease(time, 0.5, "quadOut", (time % 2 == 0 and 0.2 or 0.8) .. ", dadReverse")
            ease(time + 0.5, 0.5, "quadIn", (time % 2 == 0 and 1 or 0) .. ", dadReverse")
        else
            ease(time, 0.5, "quadOut", "0.2, dadReverse")
            ease(time + 0.5, 0.5, "quadIn", "0, dadReverse")
        end
        if time >= 224 then
            ease(time, 1, "linear", [[
                ]] .. (beat % 2 == 0 and -27 or 27) .. [[, bfCenterRotate,
                ]] .. (beat % 2 == 0 and -11 or 11) .. [[, bfAngle,
                ]] .. (beat % 2 == 0 and -50 or 50) .. [[, bfX
            ]])
            if time >= 240 then
                ease(time, 0.5, "quadOut", (time % 2 == 0 and 0.2 or 0.8) .. ", bfReverse")
                ease(time + 0.5, 0.5, "quadIn", (time % 2 == 0 and 1 or 0) .. ", bfReverse")
            else
                ease(time, 0.5, "quadOut", "0.2, bfReverse")
                ease(time + 0.5, 0.5, "quadIn", "0, bfReverse")
            end
        end
        if beat % 2 == 1 and time ~= 23 and time ~= 39 then
            local short = 1
            easeB(time, short, 'wiggle', 0, 'quadOut', 10)
        end
    end

    easeB(222, 0.75, 'wiggle', 0, 'quadOut', 10)
    easeB(222.75, 0.75, 'wiggle', 0, 'quadOut', 10)
    easeB(223.5, 0.5, 'wiggle', 0, 'quadOut', 10)
    easeB(238, 0.75, 'wiggle', 0, 'quadOut', 10)
    easeB(238.75, 0.75, 'wiggle', 0, 'quadOut', 10)
    easeB(239.5, 0.5, 'wiggle', 0, 'quadOut', 10)

    ease(223, 1, "quadInOut", "0, bfZ, 0.25, dadStealth")

    ease(271, 1, "linear", "0, bfCenterRotate, 0, dadCenterRotate, 0, bfAngle, 0, dadAngle")
    ease(271, 0.5, "quadOut", "0.2, bfReverse, 0.2, dadReverse")
    ease(271 + 0.5, 0.5, "quadOut", "0, bfReverse, 0, dadReverse")
    ease(272, 2, "quadOut", '0 , opSwap')

    for beat = 0, (4 * 24) - 1 do
        local time = 272 + beat
        if time % 2 == 0 and (time < 302 or time >= 304) then
            debounce = debounce == false
            easeB(time, 0.5, 'tipsy', 0, 'quadOut', 2 * (debounce and 1 or -1))
            easeB(time + 0.75, 0.5, 'tipsy', 0, 'quadOut', -2 * (debounce and 1 or -1))
            easeB(time + 1.5, 0.5, 'tipsy', 0, 'quadOut', 2 * (debounce and 1 or -1))
            if time >= 304 then
                if time % 2 == 0 then
                    ease(time, 1, 'quadOut', (time % 4 == 0 and 4 or -4)..', wiggle')
                    ease(time + 1, 1,'quadIn', '0, wiggle')
                end
            else
                if time % 4 == 0 then
                    ease(time, 2, "quadOut", (time % 8 == 0 and 3 or -3)..', wiggle')
                    ease(time + 2, 2, "quadIn",'0, wiggle')
                end
            end
        end
    end
    ease(368, 2, "linear", "0, dadStealth")
end

function onStepEvent(curStep)
    if curStep == 288 then
        setProperty('spawnTime', 4500)
    end
    if curStep == 432 then
        setProperty('spawnTime', 2500)
    end
end

function easeB(beat, duration, modName, percent, style, startVal)
    set(beat, startVal .. "," .. modName)
    ease(beat, duration, style, percent .. "," .. modName)
end
