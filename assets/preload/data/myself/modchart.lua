function onCountdownStarted()
    if HardMode then
        setProperty('spawnTime', 4000)
    else
        setProperty('spawnTime', 3000)
    end
end

function onCreatePost()
    if HardMode then
        initHardMods()
        initHardSetup()
        initHardModchart()
    elseif not HardMode then
        initMods()
        initSetup()
        initModchart()
    end
    initModCam()
end

function initModCam()
    runHaxeCode([[
        game.playfieldRenderer.cameras = [camNotes, camNotesFake];
    ]])
end

function initMods()
    local op, plr = "opponent", "player"
    -- op
    startMod("opTip", "TipsyY", op)
    startMod("opFlip", "Flip", op)
    startMod("opInvert", "Invert", op)
    startMod("opZ", "Z", op)
    startMod("oppconf", "Confusion", op)
    startMod("opAlpha", "Stealth", op)
    startMod("oppY", "YD", op)
    startMod("opprotate", "StrumAngle", op)
    startMod("oppz", "Z", op)
    startMod("opX", "X", op)
    -- plr
    startMod("plrTip", "TipsyY", plr)
    startMod("plrFlip", "Flip", plr)
    startMod("plrInvert", "Invert", plr)
    startMod("plrZ", "Z", plr)
    startMod("plrconf", "Confusion", plr)
    startMod("plrAlpha", "Stealth", plr)
    startMod("plrY", "YD", plr)
    startMod("plrReverse", "Reverse", plr)
    startMod('plrX', "X", plr)
    -- both
    startMod("Tip", "TipsyY")
    startMod("invert", "Invert")
    startMod("xmod", "Speed")
    startMod("rotate", "StrumAngle")
    startMod("Y", "YD")
    startMod("conf", "Confusion")
    startMod("z", "Z")
    startMod("reverse", "Reverse")
    startMod("flip", "Flip")
    startMod("sudden", "Sudden")
    startMod("brake", "Brake")
end

function initSetup()
    setSubMod("Wig", "freq", 0.6)
end

function initModchart()
    ease(0, 31, "quadInOut", "0.5, opSwap")
    -- set(32, "3, opTip:speed, 3, plrTip:speed")
    local beat = {0, 4, 8, 12, 14}
    for section = 0, 1 do
        local player = 1 - section
        local plr = (player < 1 and "plr" or "op")
        for i, beat in pairs(beat) do
            local time = 32 + (section * 16) + beat
            set(time, "" .. ((i + section) % 2 == 0 and 0.4 or -0.4) .. ", " .. plr .. 'Flip')
            set(time, "" .. ((i + section) % 2 == 0 and 1 or -1) .. ", " .. plr .. 'Tip')
            set(time, "" .. ((i + section) % 2 == 0 and math.deg(1) or math.deg(-1)) .. ', rotate') -- ROtATE SIDEWAY!11111
            ease(time, 2, 'quadOut', '0,' .. plr .. 'Flip')
            ease(time, 2, 'quadOut', '0,' .. plr .. 'Tip')
            ease(time, 2, 'quadOut', '0, rotate')

            if not EasyMode then
                ease(time, 2, 'elasticOut', "" .. (i % 2 == 0 and 1 or 0) .. ", " .. plr .. 'Invert')
            end
        end
    end

    ease(32, 4, "expoOut", "-500, plrZ, 360, plrconf, 0.5, plrAlpha")

    ease(47, 1, "quadInOut", [[
        0, plrZ,
        0, plrconf,
        0, plrAlpha,
        -500, opZ,
        360, oppconf,
        0.5, opAlpha
    ]])

    ease(63, 1, "quadIn", "0, opAlpha, 0, opZ, 0, oppconf, 0, opSwap")

    if not EasyMode then
        for section = 0, 7 do
            for beat = 0, (4 * 6) - 1 do
                local time = 64 + section + (beat * 1)
                set(time, beat % 2 == 0 and 0.4 or -0.4 .. ', invert')
                ease(time, 1, 'cubeOut', '0, invert')
            end
        end
    end

    ease(95, 1, "quadIn", "0.5, oppSwap, 0.5, plrSwap, -200, plrY")

    if not EasyMode then
        ease(97, 1, 'cubeOut', '1, invert')
        set(97, '0.5, xmod')
        ease(97, 1, 'expoOut', '1, xmod')
        ease(98, 1, 'cubeOut', '0, invert')
        set(98, '0.5, xmod')
        ease(98, 2, 'expoOut', '1, xmod')

        ease(100, 1, 'cubeOut', '1, invert')
        set(100, '0.5, xmod')
        ease(100, 1, 'expoOut', '1, xmod')
        ease(101, 1, 'cubeOut', '0, invert')
        set(101, '0.5, xmod')
        ease(101, 2, 'expoOut', '1, xmod')
    end

    ease(99, 1, "bounceOut", "0, plrY, 1, plrReverse")
    ease(104, 1, "quadOut", "0, plrReverse")
    ease(104, 2, "quadIn", "-200, plrY")
    set(106, "0, plrSwap")
    set(104, '0.5, WigFreq')

    for beat = 0, (4 * 14) - 1 do
        local time = 104 + beat
        local player = (time >= 136 and "" or "opp")
        if beat % 2 == 0 then
            ease(time, 1, 'quadOut', '-25, ' .. player .. 'Y')
            ease(time, 1, 'expoOut',
                (-0.2 * (beat % 4 == 0 and math.deg(1) or math.deg(-1))) .. ", " .. player .. 'rotate')
            ease(time, 1, 'expoOut', (-10 * (beat % 4 == 0 and 1 or -1)) .. ", " .. player .. 'conf')
        end

        if beat % 2 == 1 then
            ease(time, 1, 'quadIn', '0, ' .. player .. 'Y')
            ease(time, 1, 'cubeIn', "0, " .. player .. 'rotate')
            ease(time, 1, 'cubeIn', "0, " .. player .. 'conf')

            set(time, (6 * (beat % 4 == 1 and 1 or -1)) .. ", " .. player .. 'Wig')
            ease(time, 1.5, 'quadOut', "0, " .. player .. 'Wig')

            if time >= 136 and not EasyMode then
                set(time, "4, " .. player .. 'Tip')
                ease(time, 1.5, 'quadOut', "0, " .. player .. 'Tip')
            end
        end

        -- if time == 158 then
        --     for i = 0, 3 do
        --         ease(time, 2 ,'transform'..i..'Z', 0, 'cubeInOut', player)
        --     end
        -- else
        --     if beat%4==0 then
        --         for i = 0, 3 do
        --             ease(time, 2 ,'transform'..i..'Z', -0.05 * (i%2==0 and 1 or -1), 'cubeInOut', player)
        --         end
        --     elseif beat%4==2 then
        --         for i = 0, 3 do
        --             ease(time, 2 ,'transform'..i..'Z', 0.05 * (i%2==0 and 1 or -1), 'cubeInOut', player)
        --         end
        --     end
        -- end
    end

    ease(133, 2, "quadInOut", "0, plrY, 0, oppSwap")
    ease(160, 1, "linear", "180, oppconf")
    if not EasyMode then
        ease(161, 0.5, 'cubeOut', '1, opFlip')
    end
    set(161, "2, Tip")
    ease(161, 1.5, "cubeout", "0, Tip")

    ease(162, 1, "linear", "0, oppconf")
    if not EasyMode then
        ease(163, 0.5, 'cubeOut', '0, opFlip')
    end
    set(163, '2, Tip')
    ease(163, 1.5, 'cubeout', "0, Tip")

    ease(164, 1, 'linear', '-180, plrconf')
    if not EasyMode then
        ease(165, 0.5, 'cubeOut', '0.5, invert')
    end
    set(165, '2, Tip')
    ease(165, 1.5, 'cubeout', "0, Tip")

    ease(166, 1, "linear", "0, plrconf")
    if not EasyMode then
        ease(167, 0.5, "cubeout", "0, invert")
    end
    set(167, "2, Tip")
    ease(167, 1.5, "cubeout", "0, Tip")

    for beat = 0, (4 * 16) - 1 do
        local time = 168 + beat
        local condition = time >= 199 and time <= 228 and not EasyMode
        if beat % 2 == 0 then
            ease(time, 1, "quadOut", [[
                ]] .. (condition and 0.8 or 0.2) .. [[, reverse,
                4, Wig
            ]])
        else
            ease(time, 1, "quadIn", [[
                ]] .. (condition and 1 or 0) .. [[, reverse,
                0, Wig
            ]])

            ease(time - 0.5, 0.5, "expoIn", [[
                ]] .. ((EasyMode and -0.2 or -0.5) * (beat % 4 == 1 and 1 or -1)) .. [[, flip,
                ]] .. (-25 * (beat % 4 == 1 and 1 or -1)) .. [[, conf,
                ]] .. (beat % 4 == 1 and math.deg(-0.5) or math.deg(0.5)) .. [[, rotate
            ]])
            ease(time, 1, 'quadOut', "0, flip, 0, conf, 0, rotate")

        end

        if beat % 4 == 0 then
            ease(time, 2, "linear", (condition and 0.8 or 0.2) .. ", opSwap")
        elseif beat % 4 == 2 and time < 230 then
            ease(time, 2, "linear", (condition and 1 or 0) .. ", opSwap")
        end
    end

    set(198.5, '2, Tip')
    ease(198.5, 2, 'cubeOut', "0, Tip")

    set(230.5, '2, Tip')
    ease(230.5, 1, 'cubeOut', '0, Tip')

    ease(230, 2, "linear", "0.5, opSwap")

    -- set(58, '3, Tip:speed')
    local beat = {0, 4, 8, 12, 14}
    for section = 0, 1 do
        local player = 1 - section
        local plr = (player < 1 and "plr" or "op")
        for i, beat in pairs(beat) do
            local time = 232 + (section * 16) + beat
            set(time, "" .. ((i + section) % 2 == 0 and 0.4 or -0.4) .. ", " .. plr .. 'Flip')
            set(time, "" .. ((i + section) % 2 == 0 and 1 or -1) .. ", " .. plr .. 'Tip')
            set(time, "" .. ((i + section) % 2 == 0 and math.deg(1) or math.deg(-1)) .. ', rotate') -- ROtATE SIDEWAY!11111
            ease(time, 2, 'quadOut', '0,' .. plr .. 'Flip')
            ease(time, 2, 'quadOut', '0,' .. plr .. 'Tip')
            ease(time, 2, 'quadOut', '0, rotate')

            if not EasyMode then
                ease(time, 2, 'elasticOut', "" .. (i % 2 == 0 and 1 or 0) .. ", " .. plr .. 'Invert')
            end
        end
    end
    set(232, "10, sudden:offset")
    if not EasyMode then
        ease(232, 22, "linear", "1, sudden")
    end
    ease(232, 22, 0.75, "linear", "0.75, brake")

    ease(232, 4, "expoOut", "-500, plrZ, 360, plrconf, 0.5, plrAlpha")

    ease(247, 1, "quadInOut", [[
        0, plrZ,
        0, plrconf,
        0, plrAlpha,
        -500, opZ,
        360, oppconf,
        1, opAlpha
    ]])

    ease(264, 1, "linear", "1, plrAlpha")
    set(264, [[
        0, sudden:offset,
        0, sudden,
        0, brake,
        0, opZ,
        0, opconf
    ]])

    ease(322, 6, "linear", "1, opAlpha")
    ease(324, 4, "linear", "0, plrAlpha")

    set(264, "0.5, plrWig:freq")
    for beat = 0, (4 * 15) - 1 do
        local time = 264 + beat
        if beat % 2 == 0 then
            set(time, "20, opY")
            ease(time, 1, "quadOut", "0, opY")
        end
    end

    for beat = 0, (4 * 15) - 1 do
        local time = 328 + beat
        ease(time - 0.25, 0.25, 'expoIn', [[
            ]] .. (2 * (beat % 2 == 0 and 1 or -1)) .. [[, plrTip,
            ]] .. (80 * (beat % 2 == 0 and 1 or -1)) .. [[, plrX,
            ]] .. (-1 * (beat % 2 == 0 and 1 or -1)) .. [[, plrWig
        ]])
        ease(time, 0.75, "quadOut", "0, plrTip, 0, plrX, 0, plrWig")
    end

    if not EasyMode then
        ease(343, 1, 'cubeIn', '0.5, plrFlip')
        ease(344, 2, 'quadout', '1, plrFlip')

        ease(347, 1, 'cubeIn', '0.5, plrFlip')
        ease(348, 2, 'quadout', '0, plrFlip')
        ease(347, 1, 'cubeIn', '0.5, plrInvert')
        ease(348, 2, 'quadout', '1, plrInvert')

        ease(351, 1, 'cubeIn', '0.5, plrInvert')
        ease(352, 2, 'quadout', '0, plrInvert')
    end

    ease(357, 1.5, "quadout", "360, plrconf")
    ease(359, 1.5, "quadout", "0, plrconf")

    if not EasyMode then
        ease(377.5, 2.5, 'linear', '1, plrInvert')
        ease(381.5, 2.5, "linear", '1, plrFlip')
        ease(381.5, 2.5, 'linear', '0, plrInvert')
        ease(385.5, 2.5, "linear", '0, plrFlip')
    end

    ease(388, 1, "cubeout", '1, plrFlip')
    ease(388+1, 1, "cubeout", '-1, plrInvert')
    ease(388+2, 1, "cubeout", '1, plrInvert, 0, plrFlip')
    ease(388+3, 1, "cubeout", '0, plrInvert')

    ease(392, 2, "quadOut", "-150, opZ")
    ease(392-1 ,1 , "cubein", ""..(EasyMode and 0.4 or 0.15)..", opAlpha")

    local circling = {0, 300, 0, -300}
    local circlingZ = {-300, 0, 300, 0}
    local easeA = {'In', 'Out', 'In', 'Out'}
    for section = 0, (8-1) do -- for spin
        for circle = 0, (8-1) do
            local revers = section > 3 and -1 or 1
            local time = 392 + circle + (section * 8)
            local index = ((circle+1)%4)+1
            local indexO = ((circle+1-2)%4)+1
            
            ease(time, 1, "quad"..easeA[index], ""..circling[index]*revers..", plrX")
            ease(time, 1, "quad"..easeA[indexO], ""..circling[indexO]*revers..", opX")

            if time < 454 then
                ease(time, 1, "quad"..easeA[index], ""..circlingZ[index]*revers..", plrZ")
                ease(time, 1, "quad"..easeA[indexO], ""..circlingZ[indexO]*revers..", opZ")
            else
                ease(time, 1, "quad"..easeA[index], "0, opZ, 0, plrZ")
            end
        end
    end

    set(392, "0.32, wiggle:freq")
    set(392, '1, sudden, 10, sudden:offset')
    for beat = 0, (64-1) do 
        local time = 392 + beat
        local playerA = time >= 424 and "opp" or "plr"
        if beat%4==0 then
            set(time, "" ..(time >= 424 and 360 or -360).. ", plrconf")
            ease(time, 2, "cubeOut", "0, " .. playerA.."conf")

            set(time, (3*(beat%4==0 and 1 or -1))..", opTip")
            ease(time, 2, "cubeout", "0, opTip")
        elseif beat%4==2 then
            set(time, "" ..(time >= 424 and 360 or -360).. ", opconf")
            ease(time, 2, "cubeOut", "0, " .. playerA.."conf")

            set(time, (3*(beat%4==0 and 1 or -1))..", plrTip")
            ease(time, 2, "cubeout", "0, plrTip")
        end

        if beat%2==1 then
            set(time, (10*(beat%4==1 and 1 or -1)) .. ", Wig")
            ease(time, 2, 'cubeOut', '0, Wig')
        else
        end
    end

    ease(456, 3.5, "quadOut", "-350, plrX, 350, opX, 1, opAlpha, 1, plrAlpha")
end

-- hardMode
function initHardMods()
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
    startMod("x1", "XModifier", "", -1)
end

function initHardSetup()
    setSubMod("sudden", "offset", "10")
end

local plr, opp = "plr", "opp"

function initHardModchart()
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
            ]] .. (beat % 2 == 0 and -6 or 6) .. [[, Wig
        ]])
        ease(time, 2, 'quadOut', "0, rotate, 0, x")
        ease(time, 1, 'quadOut', "0, Wig")
    end

    ease(100, 1, "linear", [[
        0, tipsyZ,
        0, drunkX,
        0, brake
    ]])
    ease(100, 2, "circOut", "3, Wig")
    ease(103, 2, "circIn", "0, Wig")
    ease(102, 2, "quadIn", "0.75, xmod")
    ease(104, 2, "quadOut", "-500, plrZ")

    for beat = 0, (4 * 14) - 1 do
        ease(104 + (beat) - 0.25, 0.25, "expoIn", [[
            ]] .. (beat % 2 == 0 and 100 or -100) .. [[, x,
            ]] .. (beat % 2 == 0 and 4 or -4) .. [[, Wig,
            0.25, brake
        ]])
        ease(104 + (beat), 0.75, 'circOut', [[
            0, x,
            0, Wig,
            0, brake
        ]])

        if beat % 2 == 1 then
            ease(104 + (beat) - 0.25, 0.25, 'expoIn', [[
                ]] .. (beat % 4 == 1 and 30 or -30) .. [[, rotate,
                ]] .. (beat % 4 == 1 and -30 or 30) .. [[, x1,
                ]] .. (beat % 4 == 1 and 40 or -40) .. [[, confusion,
                ]] .. (beat % 4 == 1 and 3 or -3) .. [[, tipsyY
            ]])
            ease(104 + (beat), 0.75, "circOut", [[
                0, rotate,
                0, x1,
                0, confusion,
                0, tipsyY
            ]])
        end
    end

    local db = false
    local beatBox = function(time)
        set(time, [[
            ]] .. (2 * (db and 1 or -1)) .. [[, tipsyY,
            ]] .. (2 * (db and 1 or -1)) .. [[, Wig,
            ]] .. (0.4 * (db and 1 or -1)) .. [[, invert
        ]])
        ease(time, 1.5, "expoOut", [[
            0, tipsyY,
            0, Wig,
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
                0.75, xmod
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

    ease(304, 4 * 15, 'linear', '2, Wig')

    for beat = 0, (4 * 16) - 1 do
        local time = 304 + beat
        if beat % 4 == 0 then
            ease(time + 2, 2, 'quadIn', "" .. (0.75 - 0.25) .. ', xmod')
            ease(time, 2, 'quadOut', '0.75, xmod')
        end
    end
    ease(364, 4, 'quadIn', '0, Wig')
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
            ]] .. (7 * (beat % 2 == 0 and 1 or -1)) .. [[, Wig,
            ]] .. (0.2 * (beat % 2 == 0 and 1 or -1)) .. [[, flip,
            ]] .. (1 * (beat % 2 == 0 and 1 or -1)) .. [[, tipsyZ
        ]])
        ease(time, 1, 'quadOut', [[
            0, Wig,
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

    if not HardMode and not inGameOver then
        if curStep == 252 then
            setProperty("camNotesFake.visible", true)
        end
        if curStep >= 252 and curStep <= 380 then
            setProperty("camNotes.y", ((curDecBeat % 4) / 4) * 720)
            setProperty("camNotesFake.y", -720 + ((curDecBeat % 4) / 4) * 720)
        end
        if curStep == 380 then
            doTweenY("camNotes", "camNotes", 0, 0.5, "quadIn")
            setProperty("camNotesFake.y", -720)
            setProperty("camNotesFake.visible", false)
        end
        if curStep == 408 then
            doTweenAngle("camRotate", "camNotes", 360, 0.25, "quadIn")
        end
        if curBeat == 104 then
            setProperty("camNotes.angle", 0)
        end
        if curBeat == 368 then
            doTweenAngle("camRotate", "camNotes", 360, 0.25, "quadInOut")
        end
        if curBeat == 370 then
            doTweenAngle("camRotate", "camNotes", 0, 0.5, "quadInOut")
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
