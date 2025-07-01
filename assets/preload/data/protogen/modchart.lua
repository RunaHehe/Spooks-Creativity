function onCreatePost()
    setupMods()
    setMod("opSwap", 0.5)
    setMod("sudden", 1)
    setMod("opStealth", 1)
    setMod("bfStealth", 1)
    setMod("opY", -100)
    setMod("bfY", -100)
    setMod("xmod", 0.85)
    setMod("wiggle", 0.5)
    setSubMod("sudden", "offset", 10)
    setupEvents()
end

function setupMods()
    -- opponent mods
    startMod("opStealth", "StealthModifier", "opponent", -1)
    startMod("opY", "YDModifier", "opponent", -1)
    startMod("opX", "XModifier", "opponent", -1)
    startMod("opFlip", "FlipModifier", "opponent", -1)
    startMod("opTip", "TipsyYModifier", "opponent", -1)
    startMod("opZ", "ZModifier", "opponent", -1)
    startMod("opRe", "ReverseModifier", "opponent", -1)
    -- player mods
    startMod("bfStealth", "StealthModifier", "player", -1)
    startMod("bfY", "YDModifier", "player", -1)
    startMod("bfX", "XModifier", "player", -1)
    startMod("bfFlip", "FlipModifier", "player", -1)
    startMod("bfTip", "TipsyYModifier", "player", -1)
    startMod("bfZ", "ZModifier", "player", -1)
    startMod("bfRe", "ReverseModifier", "player", -1)
    -- both mods
    startMod("sudden", "SuddenModifier", "", -1)
    -- startMod("wiggle", "InvertSineModifier", "", -1)
    startMod("xmod", "SpeedModifier", "", -1)
    startMod("tipsy", "TipsyYModifier", "", -1)
    startMod("drunk", "DrunkYModifier", "", -1)
    startMod("beat", "BeatXModifier", "", -1)
    startMod("centerRotate", "StrumAngle", "", -1)
    startMod("flip", "FlipModifier", "", -1)
    startMod("tipZ", "TipsyZModifier", "", -1)
    startMod("invert", "InvertModifier", "", -1)
    startMod("x", "XModifier", "", -1)
    startMod("y", "YDModifier", "", -1)
end

function setupEvents()
    ease(0, 2, "quadOut", "0, opStealth, 0, opY")
    ease(14, 2, "expoIn", [[
        0, bfStealth, 
        0, bfY, 
        1, opStealth,
        100, opY
    ]])
    ease(30, 2, "expoIn", [[
        0, opStealth, 
        0, opY, 
        1, opSwap
    ]])
    local beatFunc = function(time)
        set(time, [[
            1, tipsy,
            ]] .. time % 3 == 0 and 2 or -2 .. [[, drunk
        ]])
        ease(time, 1, "quadOut", [[
            0, tipsy,
            0, drunk
        ]])
    end
    for beat = 0, (4) - 1 do
        local time = 0 + beat * 8

        beatFunc(0 + time)
        beatFunc(1.5 + time)
        beatFunc(3 + time)
        beatFunc(4.5 + time)
        beatFunc(6 + time)
        beatFunc(7 + time)
    end
    set(32, "2, beat")
    for beat = 0, (4 * 4) - 1 do
        local time = 32 + beat

        if time < 46 then
            ease(time, 0.5, "linear", "2, beat")
        end
    end
    set(46, "0, beat")
    ease(46, 1, "quadOut", "0, opSwap")
    ease(47, 1, "quadOut", "0.9, opSwap")
    ease(48, 8, "linear", "1, opStealth")
    ease(48, 8, "sineInOut", "0.5, opSwap")

    set(62, "1000, opX")
    ease(62, 0.2, "linear", "0, opStealth")
    ease(62, 1, "expoIn", "0, opX")
    ease(62, 1, "quadOut", "-200, bfX, 1, bfStealth")

    for beat = 0, (4 * 16) - 1 do
        local time = 64 + beat
        local intesity = 100
        if time ~= 127 then
            if beat % 2 == 0 then
                ease(time - 0.5, 0.5, "expoIn", [[
                    ]] .. intesity .. [[, zMod0,
                    ]] .. -intesity .. [[, zMod1,
                    ]] .. intesity .. [[, zMod2,
                    ]] .. -intesity .. [[, zMod3,
                    ]] .. intesity .. [[, zMod4,
                    ]] .. -intesity .. [[, zMod5,
                    ]] .. intesity .. [[, zMod6,
                    ]] .. -intesity .. [[, zMod7
                ]])
                ease(time - 0.5, 0.5, "quadIn", [[
                    360, angle0,
                    -360, angle1,
                    360, angle2,
                    -360, angle3,
                    360, angle4,
                    -360, angle5,
                    360, angle6,
                    -360, angle7
                ]])
            else
                ease(time - 0.5, 0.5, "expoIn", [[
                    ]] .. -intesity .. [[, zMod0,
                    ]] .. intesity .. [[, zMod1,
                    ]] .. -intesity .. [[, zMod2,
                    ]] .. intesity .. [[, zMod3,
                    ]] .. -intesity .. [[, zMod4,
                    ]] .. intesity .. [[, zMod5,
                    ]] .. -intesity .. [[, zMod6,
                    ]] .. intesity .. [[, zMod7
                ]])
                ease(time - 0.5, 0.5, "quadIn", [[
                    0, angle0,
                    0, angle1,
                    0, angle2,
                    0, angle3,
                    0, angle4,
                    0, angle5,
                    0, angle6,
                    0, angle7
                ]])
            end
        end
    end
    ease(94, 2, "quadInOut", [[
        0, bfStealth,
        0, bfX,
        0.16, opSwap
    ]])

    for i = 0, 7 do
        ease(127, 1, "quadOut", "0, zMod" .. i .. ", 0, angle" .. i)
    end
    ease(127, 1, "quadOut", "0.9, opSwap")
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
    ease(136, 8, "linear", "0.1, opSwap, 360, angle")
    ease(152, 2, "quadOut", "0.5, opSwap, 0, angle")
    ease(158, 2, "quadInOut", "0.9, opSwap")
    set(160, "2, beat")
    for beat = 0, (4 * 4) - 1 do
        local time = 160 + beat
        if time < 174 then
            if beat % 2 == 0 then
                ease(time, 0.5, "", "2, beat")
                ease(time, 1, "quadOut", "45, centerRotate")
            else
                if time == 173 then
                    ease(time, 1, "quadOut", "0, centerRotate")
                    ease(time, 0.5, "", "0, beat")
                else
                    ease(time, 1, "quadOut", "-45, centerRotate")
                end
            end
        end
    end
    ease(174, 1, "quadOut", "0, opSwap")
    ease(175, 1, "quadOut", "0.9, opSwap")
    ease(176, 8, "linear", "1, opStealth")
    ease(176, 8, "sineInOut", "0.5, opSwap")

    set(188, "1, bfStealth, -1, opFlip")
    ease(188, 4, "quadOut", "0, opStealth, 0, opFlip")

    local switch = false
    local hardBeat = function(time)
        switch = switch == false
        local who = time < 208 and "op" or "bf"
        set(time, "-0.7, " .. who .. "Flip")
        ease(time, 1, "quadOut", "0, " .. who .. "Flip")
        set(time, 2 * (switch and 1 or -1) .. ", " .. who .. "Tip")
        ease(time, 1, "quadOut", "0, " .. who .. "Tip")
    end
    for beat = 0, (4 * 8) - 1 do
        local time = 192 + beat
        if time < 220 then
            hardBeat(time)
        end
    end
    hardBeat(199.5)
    hardBeat(207.25)
    hardBeat(207.5)
    hardBeat(207.75)
    hardBeat(215.25)
    hardBeat(215.5)
    hardBeat(216.5)
    ease(206, 2, "linear", "0, bfStealth, 1, opStealth")
    ease(220, 4, "quadOut", "0.25, opFlip, 0.25, bfFlip")
    set(224, [[
        0, opStealth,
        1, opSwap,
        0.25, tipZ,
        0.75, xmod,
        1, bfDark,
        0.4, tipsy
    ]])
    ease(224, 4, "quadOut", "0, opFlip, 0, opStealth")
    ease(232, 4, "quadOut", "0, bfFlip, 0, bfDark")

    set(288, "0.85, xmod, 0, tipZ, 0, tipsy")

    local switchBool = false
    local kickbeat = function(time)
        switchBool = switchBool == false
        set(time, [[
            0.5, xmod,
            ]] .. 0.2 * (switchBool and 1 or -1) .. [[, invert
        ]])
        ease(time + 0.001, 0.5, "quadOut", "0.75, xmod, 0, invert")
    end
    local kicksnare = function(time)
        set(time, '4, wiggle')
        ease(time, 4, 'expoOut', '0, wiggle')
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

    for beat = 0, (2 * 4) - 1 do
        kickbeat(272 + beat)
    end
    for beat = 0, (4) - 1 do
        kickbeat(280 + beat)
        kickbeat(280.5 + beat)
    end
    ease(284, 2, 'quadIn', '10, wiggle')
    ease(286, 2, 'quadOut', '0, wiggle')

    for beat = 0, (4 * 15) - 1 do
        local time = 288 + beat
        local inten = (beat % 2 == 0 and 1 or -1)
        if time % 2 == 0 then
            ease(time, 1, "quadInOut", "300, opZ, -20, bfZ")
        else
            ease(time, 1, "quadInOut", "-20, opZ, 300, bfZ")
        end
        if time >= 304 and time < 336 then
            if time >= 320 and time < 336 then
                set(time, 2 * inten .. ", tipsy")
                ease(time, 1, "quadOut", "0, tipsy")
            else
                set(time, 0.4 * inten .. ", invert")
                ease(time, 1, "quadOut", "0, invert")
            end
        end
    end
    ease(348, 4, "quadOut", "0, bfZ, 0, opZ")
    ease(352, 1, "quadOut", "0.5, opSwap, -200, bfZ")
    ease(382, 2, "quadIn", "0, bfZ")
    ease(384, 1, "quadOut", "0.2, opZ")

    for beat = 0, (4 * 16) - 1 do
        local time = 352 + beat
        local intenWig = (beat % 2 == 0 and 1 or -1)
        local intenRe = beat % 8 == 0 and 0 or 1
        ease(time, 1, "linear", 75 * intenWig .. ", x")
        ease(time, 0.5, "quadOut", "-40, y")
        ease(time + 0.5, 0.5, "quadIn", "0, y")

        set(time, 6 * intenWig .. ", wiggle")
        ease(time, 1, "quadOut", "0, wiggle")

        if (beat % 4 == 0) then
            if time < 384 then
                ease(time, 1, "quadOut", intenRe .. ", opRe")
            else
                ease(time, 1, "quadOut", intenRe .. ", bfRe")
            end
        end
    end
    ease(384, 1, "quadOut", "0, opRe")
    set(416, [[
        0, x,
        0, opRe,
        0, bfRe,
        0, opZ,
        0, bfZ,
        1, opStealth,
        0.6, xmod
    ]])
    ease(448, 24, "linear", "0, opStealth")
    ease(464, 14, "sineInOut", "1, opSwap")
    set(480, "0.92, xmod, 2, beat, 0, x")

    for beat = 0, (4 * 32) - 1 do
        local time = 480 + beat

        if beat % 2 == 0 then
            ease(time, 0.5, "", '2, beat')
        end
    end
    for beat = 0, (4 * 16) - 1 do
        local time = 544 + beat
        local inten = 2 * (beat % 2 == 0 and 1 or -1)

        set(time, [[
        ]] .. inten .. [[, tipsy,
        ]] .. inten .. [[, drunk
        ]])
        ease(time, 1, 'quadOut', [[
            0, tipsy,
            0, drunk
        ]])
    end
    set(608, '0.6, xmod, 0, beat')
    ease(640, 8, "linear", "1, opStealth, 1, bfStealth")
end
