local bassBeat = {0, 3, 6, 9, 12, 14, 16, 19, 22, 25, 28, 30, 32, 35, 38, 41, 44, 46, 48, 51, 54, 56, 59, 62}

function onCreatePost()
    modSetup()

    setMod("opY", -165)
    setMod("bfY", -165)
    setMod("opSwap", 0.5)
    if HardMode or InsaneMode then
        setMod("bumpy", 1)
        setSubMod("bumpy", "speed", 1.2)
        setSubMod("hidden", "offset", 4)
    end

    easeSetup()
end

function modSetup()
    --opponent mods
    startMod("opY", "YDModifier", "opponent", -1)
    startMod("opX", "XModifier", "opponent", -1)
    startMod("opZ", "ZModifier", "opponent", -1)
    startMod("stealthOP", "StealthModifier", "opponent", -1)
    startMod('oAngle', 'StrumAngleModifier', 'opponent', -1)
    startMod("orotate", "StrumLineRotateModifier", "opponent", -1)
    startMod('osplit', 'SplitModifier', 'opponent', -1)
    startMod("opInv", "InvertModifier", "opponent", -1)
    startMod('opReverse', "ReverseModifier", "opponent", -1)
    startMod('opFlip', 'FlipModifier', 'opponent', -1)
    startMod('opHid', "HiddenModifier", 'opponent', -1)
    -- startMod('opWiggle', 'InvertSineModifier', 'opponent', -1)
    startMod('opTipsy', 'TipsyYModifier', 'opponent', -1)
    startMod('opDrunk', 'DrunkYModifier', 'opponent', -1)
    startMod('opTipZ', 'TipsyZModifier', 'opponent', -1)

    --player mods
    startMod("bfY", "YDModifier", "player", -1)
    startMod("stealthBF", "StealthModifier", "player", -1)
    startMod("bfTipsy", "TipsyYModifier", "player", -1)
    startMod("bfDrunk", "DrunkYModifier", "player", -1)
    startMod('psplit', 'SplitModifier', 'player', -1)
    startMod('pAngle', 'StrumAngleModifier', 'player', -1)
    startMod("protate", "StrumLineRotateModifier", "player", -1)
    startMod("bfX", "XModifier", "player", -1)
    startMod("bfInv", "InvertModifier", "player", -1)
    startMod('bfReverse', "ReverseModifier", "player", -1)
    startMod('bfFlip', 'FlipModifier', 'player', -1)
    startMod('bfHid', 'HiddenModifier', 'player', -1)
    -- startMod('bfWiggle', 'InvertSineModifier', 'player', -1)
    startMod('bfTipZ', 'TipsyZModifier', 'player', -1)
    startMod("bfZ", "ZModifier", "player", -1)

    --both mods
    startMod("bumpy", "BumpyModifier", "", -1)
    -- startMod("wiggle", "InvertSineModifier", "", -1)
    startMod("hidden", "HiddenModifier", "", -1)
    startMod("boost", "BoostModifier", "", -1)
    startMod('curveX', 'EaseCurveXModifier', '', -1)
    startMod("reverse", "ReverseModifier", '', -1)
    startMod("brake", "BrakeModifier", "", -1)
    startMod("localRotate", "StrumLineRotateModifier", "", -1)
    startMod("tipZ", "TipsyZModifier", "", -1)
    startMod("tipsy", "TipsyYModifier", "", -1)
    startMod("x", "XModifier", "", -1)
    startMod("flip", "FlipModifier", "", -1)
    startMod("drunk", "DrunkYModifier", "", -1)
    startMod("bothSplit", "SplitModifier", '', -1)
    startMod("rotate", "StrumLineRotateModifier", "", -1)
    startMod("stealth", "StealthModifier", "", -1)
    
    setModEaseFunc('curveX', 'sineinout')
    setSubMod('curveX', 'speed', 0.3)
end

function easeSetup()
    setProperty('spawnTime', 3000)
    ease(0, 16, "quadOut", [[
        0, opY
    ]])
    if HardMode or InsaneMode then
        ease(0, 16, "linear", [[
            1, hidden
        ]])
    end
    ease(16, 16, "quadOut", [[
        0, bfY,
        0, opSwap,
        1, middle,
        -200, opZ
    ]])
    ease(32, 2, "expoOut", [[
        0, opZ,
        0, middle,
        0.5, opSwap,
        -400, bfZ,
        0.5, stealthBF,
        0, hidden
    ]])
    ease(32, 2, "quadOut", [[
        0, bumpy
    ]])
    ease(32, 2, "linear", [[
        1, boost
    ]])

    for i, v in pairs(bass(16)) do
        local inten = i % 2 == 0 and 1 or -1
        set(v, [[
            ]] .. inten .. [[, bfTipsy,
            ]] .. inten .. [[, bfDrunk
        ]])
        ease(v, 1, "cubeOut", [[
            0, bfTipsy,
            0, bfDrunk
        ]])
    end
    for beat = 0, (4 * 8) - 1 do
        local time = beat + 32
        local char = (time < 48 and 'o' or 'p')
        ease(time, 0.5, 'quadOut', '0.2 ,' .. char .. 'split:Var' .. (beat % 2 == 0 and 'A' or 'B'))
        ease(time + 0.5, 0.5, 'quadIn', '0 ,' .. char .. 'split:Var' .. (beat % 2 == 0 and 'A' or 'B'))

        if beat % 2 == 0 then
            local oppo = (beat % 4 == 0 and 1 or -1)
            ease(time + 0.5, 0.5, 'expoIn', string.format("%s, curveX, %s, %srotate:y, %s, %sx-a", 1000 * oppo, 50 * oppo, char, -100 * oppo, char))
            ease(time + 1, 1.25, 'quadOut', string.format("0, curveX, 0, %srotate:y", char))
            --ease(time + 1, 1.25, 'quadOut', string.format("0, opX, 0, bfX"))
        end

        if not EasyMode then
            for i = 1, 2 do
                local index = (beat%2==0 and 0 or 2)+i
                if (beat%4<2) then
                    set(time, [[
                        0, ]] .. char .. [[Angle]].. index .. [[
                    ]])
                end
                ease(time, 1, "linear", [[
                    ]] .. (beat%4 >= 2 and 360 or 180) .. [[, ]]..char..[[Angle]]..index..[[
                ]])
            end
        end
    end

    if HardMode or InsaneMode then
        ease(36, 1,"quadOut", "1, opInv")
        ease(37, 1,"quadOut", "0, opInv")
        ease(38, 1,"quadOut", "1, opFlip")
        ease(39, 1,"quadOut", "0, opFlip")
        ease(44, 2,"linear", "1, opReverse")
        ease(46, 2,"linear", "0, opReverse")

        ease(52, 1,"quadOut", "1, bfInv")
        ease(53, 1,"quadOut", "0, bfInv")
        ease(54, 1,"quadOut", "1, bfFlip")
        ease(55, 1,"quadOut", "0, bfFlip")
        ease(60, 2,"linear", "1, bfReverse")
        ease(62, 2,"linear", "0, bfReverse")
    end

    ease(46, 2, "expoInOut", [[
        0, bfZ,
        0, stealthBF,
        -400, opZ,
        1, stealthOP
    ]])
    set(48, [[
        0, stealthOP,
        0, opSwap,
        -550, opX,
        -320, bfX,
        0, opZ
    ]])
    ease(60, 4, "quadInOut", [[
        0, opX,
        0, boost,
        0, bfX
    ]])

    for beat = 0, (4*8-1) do
        local time = 64 + beat
        local turn = beat >= 16 and "bf" or "op"
        local inten = 2*(beat%2==0 and 1 or -1)
        ease(time, 1, 'sineIn', [[
            ]]..(beat%2==0 and -150 or 125)..[[, opZ,
            ]]..(beat%2==0 and 125 or -150)..[[, bfZ,
        ]])

        ease(time, 0.5, 'quadOut', '0.2, bfReverse, 0.2, opReverse')
        ease(time+0.5, 0.5, 'quadIn', '0, bfReverse, 0, opReverse')

        set(time, (time%2==0 and 600 or -600) ..' ,curveX, 1, brake')
        ease(time, 1, 'quadOut', '0 ,curveX, 0, brake')

        if not EasyMode then
            set(time, [[
            ]] .. inten .. [[,]] .. turn .. [[Tipsy,
            ]] .. inten .. [[,]] .. turn .. [[Drunk
            ]])
            ease(time, 1, 'quadOut', [[
                0, ]] .. turn .. [[Tipsy,
                0, ]] .. turn .. [[Drunk
            ]])
        end
    end
    if HardMode or InsaneMode then
        for beat = 0, 8-1 do
            local time = 64 + (beat*4)
            ease(time, 1, 'sineOut', '45, localRotate:x')
            ease(time+1, 1, 'sineIn', '0, localrotate:x')
            ease(time+2, 1, 'sineOut', '-45, localRotate:x')
            ease(time+3, 1, 'sineIn', '0, localrotate:x')
        end
    end
    if HardMode or InsaneMode then
        --bf side
        ease(64, 1, "linear", "1, bfHid"); ease(64, 2, "linear", "1, bfWiggle")
        ease(64, 1, "quadOut", "-0.1, bfFlip"); ease(64+1, 1, "cubeOut", "1, bfFlip")
        ease(68, 1, "quadOut", "1.1, bfFlip"); ease(68+1, 1, "cubeOut", "0, bfFlip")
        ease(72, 1, "quadOut", "-0.1, bfFlip"); ease(72+1, 1, "cubeOut", "1, bfFlip")
        ease(76, 1, "quadOut", "1.1, bfFlip"); ease(76+1, 1, "quadOut", "0, bfFlip")
        ease(76, 1, "quadOut", "-0.1, bfInv"); ease(76+1, 1, "cubeOut", "1, bfInv")
        ease(78, 1, "quadOut", "1.1, bfInv"); ease(78+1, 1, "cubeOut", "0, bfInv")
        ease(78, 1, "linear", "1, bfHid"); ease(78, 2, "linear", "0, bfWiggle")

        --dad side
        ease(80, 1, "linear", "1, opHid"); ease(80, 2, "linear", "1, opWiggle")
        ease(80, 1, "quadOut", "-0.1, opFlip"); ease(80+1, 1, "cubeOut", "1, opFlip")
        ease(84, 1, "quadOut", "1.1, opFlip"); ease(84+1, 1, "cubeOut", "0, opFlip")
        ease(88, 1, "quadOut", "-0.1, opFlip"); ease(88+1, 1, "cubeOut", "1, opFlip")
        ease(92, 1, "quadOut", "1.1, opFlip"); ease(92+1, 1, "quadOut", "0, opFlip")
        ease(92, 1, "quadOut", "-0.1, opInv"); ease(92+1, 1, "cubeOut", "1, opInv")
        ease(94, 1, "quadOut", "1.1, opInv"); ease(94+1, 1, "cubeOut", "0, opInv")
        ease(94, 1, "linear", "1, opHid"); ease(94, 2, "linear", "0, opWiggle")
    end

    if HardMode or InsaneMode then
        for i = 0, 1 do
            local add = i * 16
            ease(65 + add, 2, "quadOut", "360, angle")
            ease(69 + add, 2, "quadOut", "0, angle")
            ease(73 + add, 2, "quadOut", "360, angle")
            ease(77 + add, 2, "quadOut", "0, angle")
            ease(79 + add, i == 1 and 1 or 2, "quadOut", "360, angle")
        end
        set(96, "0, angle, 0, localRotate:x")
    end
    ease(96, 1, "sineInOut", "0.5, tipZ")
    ease(95, 1, "sineInOut", [[
        0.5, opSwap,
        -200, bfZ,
        0.5, stealthBF
    ]])

    if not EasyMode then
        for i = 0, 1 do
            local add = i * 16
            local turn = i==0 and "op" or "bf"
            ease(96+add, 1, "linear", [[1, ]] .. turn .. [[Reverse]])
            ease(100+add, 1, "linear", [[0, ]] .. turn .. [[Reverse]])
            ease(104+add, 1, "linear", [[1, ]] .. turn .. [[Reverse]])
            ease(109+add, 1, "linear", [[0, ]] .. turn .. [[Reverse]])
            ease(111+add, 1, "linear", [[0.5, ]] .. turn .. [[Reverse]])
        end
    end
    for beat = 0, (4*8)-1 do
        local time = 96 + beat
        local turn = beat >= 16 and "bf" or "op"
        local inten = 2*(beat%2==0 and 1 or -1)

        set(time, [[
        ]] .. inten .. [[,]] .. turn .. [[Tipsy,
        ]] .. inten .. [[,]] .. turn .. [[Drunk
        ]])
        ease(time, 1, 'quadOut', [[
            0, ]] .. turn .. [[Tipsy,
            0, ]] .. turn .. [[Drunk
        ]])
    end
    ease(111, 1, "linear", [[
        0, stealthBF,
        1, stealthOP,
        -200, opZ,
        0, bfZ
    ]])
    ease(127, 1, "sineInOut", "0, tipsZ")
    set(127, "0, opZ")
    ease(127, 1, "linear", [[
        0, stealthOP,
        1, stealthBF,
        0, opReverse
    ]])
    ease(128, 4, "quadOut", [[
        0.5, opTipZ,
        0.5, opTipsy,
        -0.5, bfTipZ,
        -0.5, bfTipsy,
        1, brake,
        2, boost
    ]])
    ease(143, 2, "sineInOut", [[
        0, stealthBF,
        0.5, stealthOP,
        0, bfZ,
        -300, opZ,
        0, bfReverse
    ]])

    for beat = 0, (4*8)-3 do
        local time = 160 + beat
        local turn = beat >= 16 and "bf" or "op"

        ease(time, 0.5, "quadOut", [[
            ]] .. (beat%2==0 and -400 or 0) .. [[, bfZ,
            ]] .. (beat%2==1 and -400 or 0) ..[[, opZ
        ]])
        set(time, [[
            ]] .. 3 * (beat%2==0 and -1 or 1) .. [[, bfDrunk,
            ]] .. 3 * (beat%2==0 and 1 or -1) .. [[, opDrunk
        ]])
        ease(time, 1, "quadOut", "0, bfDrunk, 0, opDrunk")
        if HardMode or InsaneMode then
            if beat%4 == 0 then
                ease(time, 1 ,'quadOut', '45, pAngle, -100, bfX')
                ease(time, 1 ,'quadOut', '-45, oAngle, 100, opX')
            elseif beat%4 == 1 then
                ease(time, 1 ,'quadOut', '0, pAngle, 0, bfX')
                ease(time, 1 ,'quadOut', '0, oAngle, 0, opX')
            elseif beat%4 == 2 then
                ease(time, 1 ,'quadOut', '-45, pAngle, 100, bfX')
                ease(time, 1 ,'quadOut', '45, oAngle, -100, opX')
            elseif beat%4 == 3 then
                ease(time, 1 ,'quadOut', '0, pAngle, 0, bfX')
                ease(time, 1 ,'quadOut', '0, oAngle, opX')
            end
        end
    end
    ease(190, 2, "linear", [[
        0, opZ, 
        0, bfZ, 
        0, stealthOP, 
        0, stealthBF,
        -210, bfY,
        -210, opY,
        0, brake,
        0, boost,
        0.5, stealthBF,
        1, stealthOP,
        0, protate,
        0, orotate
    ]])
    if HardMode or InsaneMode then ease(190, 2, "linear", "2, bfWiggle") end
    ease(210, 4, "quadOut", "0, opY, 0, bfY")
    if HardMode or InsaneMode then ease(320, 2, "linear", "0, bfWiggle") end
    set(320, "0, stealthOP, 0, stealthBF, 0, opSwap, 0, opTipZ, 0, opTipsy, 0, bfTipZ, 0, bfTipsy")
    for beat = 0, (4*16)-1 do
        local time = 320 + beat
        local inten = (beat%2==0 and 1 or -1)
        if time ~= 352 and time ~=368 then
            if not EasyMode then
                ease(time-0.1, 0.1, "expoIn", [[
                    0.5, tipZ,
                    1, tipsy,
                    0.1, reverse,
                    ]] .. -25 * inten .. [[, x,
                    ]] .. 5 * inten .. [[, wiggle
                ]])
            else
                ease(time-0.1, 0.1, "expoIn", [[
                    0.5, tipZ,
                    1, tipsy,
                    0.1, reverse,
                    ]] .. -25 * inten .. [[, x
                ]])
            end
            ease(time, 0.9, "quadOut", [[
                0, tipZ,
                0, tipsy,
                0, reverse,
                0, x,
                0, wiggle
            ]])
        end
    end
    if HardMode or InsaneMode then
        for beat = 0, (4*8)-1 do
            local time = 384 + beat
            local inten = 2*(beat%2==0 and 0.5 or -0.5)

            set(time, [[
            ]] .. inten .. [[, tipsy,
            ]] .. inten .. [[, drunk
            ]])
            ease(time, 1, 'quadOut', [[
                0, tipsy,
                0, drunk
            ]])
        end
    end
    for beat = 0, (4*8)-1 do
        local time = 416 + beat
        local inten = (beat%2 == 0 and 1 or -1)
        set(time, "" .. 0.2 * inten .. ", flip")
        ease(time, 1, "quadOut", "0, flip")
        ease(time, 1, "linear", "" .. 50 * inten .. ", x")
        ease(time, 0.5, "quadOut", "-0.1, reverse")
        ease(time + 0.5, 0.5, "quadin", "0.1, reverse")
    end
    ease(448, 1, "quadOut", "0, x, 0, reverse")
    for beat = 0, (4 * 8) - 1 do
        local time = beat + 448
        ease(time, 0.5, 'quadOut', '0.2 , bothSplit:Var' .. (beat % 2 == 0 and 'A' or 'B'))
        ease(time + 0.5, 0.5, 'quadIn', '0 , bothSplit:Var' .. (beat % 2 == 0 and 'A' or 'B'))
        if beat % 2 == 0 then
            local oppo = (beat % 4 == 0 and 1 or -1)
            ease(time + 0.5, 0.5, 'expoIn', "" .. 50 * oppo .. ", rotate:y")
            ease(time + 1, 1.25, 'quadOut', "0, rotate:y")
            --ease(time + 1, 1.25, 'quadOut', string.format("0, opX, 0, bfX"))
        end
    end
    ease(480, 1, "quadOut", "1, stealth")
end
function bass(startAt)
    local arr = {}
    for i, v in pairs(bassBeat) do
        table.insert(arr, startAt + (v / 4))
    end
    return arr
end
