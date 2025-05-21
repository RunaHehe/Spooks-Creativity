function onCountdownStarted()
    setProperty('spawnTime', 4000)
end

function onCreatePost()
    if HardMode then
        initMods()
        initSetup()
        initModchart()
    end
end

function initPlayfields()
    addPlayfield(0, 0, 0)
end

function initMods()
    -- op
    startMod("opStealth", "StealthModifier", "opponent", -1)
    startMod("opFlip", "FlipModifier", "opponent", -1)
    startMod("opRe", "ReverseModifier", "opponent", -1)
    startMod("opX", "XModifier", "opponent", -1)
    startMod("opZ", "ZModifier", "opponent", -1)
    startMod("oppRe", "ReverseModifier", "opponent", -1)
    startMod("opXMod", "SpeedModifier", "opponent", -1)
    -- plr
    startMod("plrZ", "ZModifier", "player", -1)
    startMod("plrStealth", "StealthModifier", "player", -1)
    startMod("plrFlip", "FlipModifier", "player", -1)
    startMod("plrRe", "ReverseModifier", "player", -1)
    startMod("plrX", "XModifier", "player", -1)
    startMod("plrXMod", "SpeedModifier", "player", -1)
    -- both
    startMod("tipsyY", "TipsyYModifier", "", -1)
    startMod("alpha", "StealthModifier", "", -1)
    startMod("brake", "BrakeModifier", "", -1)
    startMod("xmod", "SpeedModifier", "", -1)
    startMod("tipsyZ", "TipsyZModifier", "", -1)
    startMod("drunkX", "DrunkXModifier", "", -1)
    startMod("rotate", "StrumAngleModifier", "", -1)
    startMod("x", "XModifier", "", -1)
    startMod("confusion", "ConfusionModifier", "", -1)
    startMod("invert", "InvertModifier", "", -1)
    startMod("sudden", "SuddenModifier", "", -1)
    startMod("boost", "BoostModifier", "", -1)
    startMod("flip", "FlipModifier", "", -1)
    startMod("wave", "WaveYModifier", "", -1)

    -- playfields
    startMod("stealth1", "StealthModifier", "", 1)
    startMod("x1", "XModifier", "", 1)
end

function initSetup()
    setSubMod("sudden", "offset", "10")
    setMod("stealth1", 1)
    setMod("x1", 110)
end

local plr, opp = "plr", "opp"

function initModchart()
    ease(0, 7 * 4, "sineInOut", "0.5, opSwap")
    ease(28, 2, "quadOut", "3, tipsyY, 1, alpha")
    set(40, "0, alpha, 0.75, brake, 0.5, xmod, 0, tipsyY")

    ease(52, 4, "linear", "1, opStealth")
    set(52 + 4 + 12, "0, opStealth")

    local beat = {0, 3, 4.5, 6, 0 + 8, 3 + 8, 4.5 + 8, 6 + 8, 0 + 16, 3 + 16, 4.5 + 16, 6 + 24, 0 + 24, 1.5 + 24,
                  3 + 24, 4.5 + 24, 6 + 24, 7 + 24}
    local db = false
    for _, beat in pairs(beat) do
        db = db == false
        local time = 40 + beat
        local player = time >= 56 and plr or opp
        set(time, (5 * (db and 1 or -1)) .. "," .. player .. "Wig")
        ease(time, 1, 'quadOut', "0," .. player .. "Wig")
    end

    ease(72, 8, "linear", "1, tipsyZ, 0.75, drunkX, 0.25, brake")

    ease(84, 4, "linear", '1, opStealth')
    set(84 + 4 + 12, '0, opStealth')

    for beat = 0, 7 - 1 do
        local time = 72 + (beat * 4) + 2

        ease(time - 0.2, 0.2, "expoIn", [[
            ]] .. (beat % 2 == 0 and 40 or -40) .. [[, rotate,
            ]] .. (beat % 2 == 0 and -40 or 40) .. [[, x,
            ]] .. (beat % 2 == 0 and -6 or 6) .. [[, wiggle
        ]])
        ease(time, 2, 'quadOut', "0, rotate, 0, x")
        ease(time, 1, 'quadOut', "0, wiggle")
    end

    ease(100, 1, "linear", [[
        0, tipsyZ,
        0, drunkX,
        0, brake
    ]])
    ease(100, 2, "circOut", "3, wiggle")
    ease(103, 2, "circIn", "0, wiggle")
    ease(102, 2, "quadIn", "0.75, xmod")
    ease(104, 2, "quadOut", "-500, plrZ")

    for beat = 0, (4 * 14) - 1 do
        ease(104 + (beat) - 0.25, 0.25, "expoIn", [[
            ]] .. beat % 2 == 0 and 100 or -100 .. [[, x,
            ]] .. beat % 2 == 0 and 4 or -4 .. [[, wiggle,
            0.25, brake
        ]])
        ease(104 + (beat), 0.75, 'circOut', [[
            0, x,
            0, wiggle,
            0, brake
        ]])

        if beat % 2 == 1 then
            ease(104 + (beat) - 0.25, 0.25, 'expoIn', [[
                ]] .. (beat % 4 == 1 and 30 or -30) .. [[, rotate,
                ]] .. (beat % 4 == 1 and -30 or 30) .. [[, x,
                ]] .. (beat % 4 == 1 and 40 or -40) .. [[, confusion,
                ]] .. (beat % 4 == 1 and 3 or -3) .. [[, tipsyY
            ]])
            ease(104 + (beat), 0.75, "circOut", [[
                0, rotate,
                0, x,
                0, confusion,
                0, tipsyY
            ]])
        end
    end

    local db = false
    local beatBox = function(time)
        set(time, [[
            ]] .. (2 * (db and 1 or -1)) .. [[, tipsyY,
            ]] .. (2 * (db and 1 or -1)) .. [[, wiggle,
            ]] .. (0.4 * (db and 1 or -1)) .. [[, invert
        ]])
        ease(time, 1.5, "expoOut", [[
            0, tipsyY,
            0, wiggle,
            0, invert
        ]])
    end
    for beat = 0, 7 do
        local time = 160 + beat
        db = db == false
        beatBox(time)
    end
    beatBox(162.75)
    beatBox(164.75)
    beatBox(165.75)
    beatBox(166.25)

    ease(112, 4, "linear", '0.5, sudden')
    ease(120, 1, "linear", '0, sudden')

    ease(133.5, 1.5, "linear", '0, plrZ')
    ease(133.5, 1.5, "linear", '1, opStealth')

    ease(167, 1, "quadIn", "0, opStealth, -0.6, opFlip, 0, stealth1")
    ease(167 + 1, 1, "quadIn", "1, plrStealth")

    for beat = 0, (4 * 16) - 1 do
        local time = 168 + beat
        if beat % 4 == 0 then
            ease(time - 2, 2, "quadIn", [[
                0.5, boost,
                0.35, xmod
            ]])

            ease(time, 2, "quadOut", [[
                0, boost,
                0.35, xmod
            ]])
        end

        set(time, 0.25 * (beat % 2 == 0 and 1 or -1) .. ', invert')
        ease(time, 1, 'quadOut', '0, invert')
    end

    set(170, "1, plrRe, -0.6, plrFlip")
    ease(196, 4, "linear", "0, plrStealth")
    ease(200, 2, "quadOut", "0, plrRe, 1, opStealth, 1, opRe")

    ease(230, 2, "quadIn", "0, opFlip, 0, plrFlip, 1, stealth1")
    ease(232, 2, "linear", "0, opRe, 0.4, opStealth")

    for beat = 0, (4 * 16) - 1 do
        local time = 232 + beat

        ease(time, 0.5, "quadOut", [[
            0.15, ]] .. (time < 264 and opp or plr) .. [[Re
        ]])

        ease(time + 0.5, 0.5, "quadIn", [[
            0, ]] .. (time < 264 and opp or plr) .. [[Re
        ]])
        if beat % 2 == 0 then
            ease(time, 1, "quadOut", [[
                0.15, ]] .. (time < 264 and opp or plr) .. [[Re
            ]])

            ease(time + 1, 1, "quadIn", [[
                0, ]] .. (time < 264 and opp or plr) .. [[Re
            ]])
        end

        set(time, [[
            ]] .. (beat % 2 == 0 and 0.2 or -0.2) .. [[, flip,
            ]] .. (beat % 2 == 0 and 1 or -1) .. [[, tipsyY
        ]])
        ease(time, 0.5, 'quadOut', '0, flip')
        ease(time, 0.6, 'quadOut', '0, tipsyY')
    end

    ease(296, 1, 'quadOut', '0, opZ, 0, plrZ, 0, opX, 0, plrX')

    ease(304, 4 * 15, 'linear', '2, wiggle')

    for beat = 0, (4 * 16) - 1 do
        local time = 304 + beat
        if beat % 4 == 0 then
            ease(time + 2, 2, 'quadIn', "" .. (0.75 - 0.25) .. ', xmod')
            ease(time, 2, 'quadOut', '0.75, xmod')
        end
    end
    ease(364, 4, 'quadIn', '0, wiggle')
    ease(368, 2, 'quadOut', "0.85, opXMod, -1.5, drunkX")

    for beat = 0, (4 * 16) - 1 do
        local time = 368 + beat
        set(time, "" .. (2 * (beat % 2 == 0 and 1 or -1)) .. ', tipsyY')
        ease(time, 1, 'quadOut', '0, tipsyY')
    end

    ease(432, 1, 'quadOut', '0, drunkX')

    ease(432, 8 * 4, 'linear', '0, opSwap, 1, opXMod, 0.85, xmod')
    ease(432, 4, 'wave', 2, 'linear')

    ease(448, 8, "linear", '0, wave')
    ease(448, 1, "linear", '2, opXMod, 0, x1, 0, stealth1')
    ease(463, 1, "linear", '0.75, opXMod, 0, opStealth')

    for beat = 0, (4 * 16) - 1 do
        local time = 528 + beat
        set(time, [[
            ]] .. (7 * (beat % 2 == 0 and 1 or -1)) .. [[, wiggle,
            ]] .. (0.2 * (beat % 2 == 0 and 1 or -1)) .. [[, flip,
            ]] .. (1 * (beat % 2 == 0 and 1 or -1)) .. [[, tipsyZ
        ]])
        ease(time, 1, 'quadOut', [[
            0, wiggle,
            0, flip,
            0, tipsyZ
        ]])
    end
    ease(592, 8, 'alpha', 1)
end

function onUpdate(elapsed)
    if HardMode and not inGameOver then
        if curBeat >= 232 and curBeat < 296 then
            setMod('plrX', continuous_sin(curDecBeat / 8) * 300)
            setMod('opX', continuous_sin((curDecBeat) / 8 + 0.5) * 300)

            setMod('plrZ', -100 + continuous_cos(curDecBeat / 8) * 200)
            setMod('opZ', -(100 + continuous_cos((curDecBeat) / 8 + 500) * 200))
        end
    end
end

function onUpdatePost(elapsed)
    if HardMode and not inGameOver then
        if curBeat >= 464 and curBeat < 528 then
            if curBeat < 528 then
                --     setMod("x", ((curDecBeat % 4) / 4) * 1280)
                --     setMod("x1", -1280 + ((curDecBeat % 4) / 4) * 1280)
            end
        end
    end
end

function onStepHit()
    if HardMode and not inGameOver then
        if step == (528 * 4) then
            setMod("x", 0)
            setMod("x1", 0)
        end
    end
end

function continuous_sin(x)
    return math.sin((x % 1) * 2 * math.pi)
end
function continuous_cos(x)
    return math.cos((x % 1) * 2 * math.pi)
end
function lerp(a, b, t)
    return a + (b - a) * t
end
