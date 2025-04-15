function onCreatePost()
    setupMods()

    if downscroll then
        setSubMod("plrStrums", "y", 400)
    else
        setSubMod("plrStrums", "y", -400)
    end
    setMod("opX", 320)
    setMod("opStealth", -0.5)
    setSubMod("opInc", "y", 45)
    setSubMod("opInc", "x", 90)
    setMod("opBoom", 1)

    setProperty('spawnTime', 4500)

    setupEvents()
end

function setupMods()
    -- player
    startMod("plrInv", "InvertModifier", "player", -1)
    startMod("plrY", "YDModifier", "player", -1)
    startMod("plrTipsyY", "TipsyYModifier", "player", -1)
    startMod("plrDrunkY", "DrunkYModifier", "player", -1)
    startMod("bfTipZ", "TipsyZModifier", "player", -1)
    startMod("plrX", "XModifier", "player", -1)
    startMod("plrStrumAngle", "StrumAngleModifier", "player", -1)
    startMod("plrSkewx", "SkewXModifier", "player", -1)
    startMod("plrReverse", "ReverseModifier", "player", -1)
    startMod("plrJump", "JumpNotesModifier", "player", -1)
    startMod("plrZ", "ZModifier", "player", -1)
    startMod("plrSudden", "SuddenModifier", "player", -1)
    -- opponent
    startMod("opInv", "InvertModifier", "opponent", -1)
    startMod("opStealth", "StealthModifier", "opponent", -1)
    startMod("opX", "XModifier", "opponent", -1)
    startMod("opFlip", "FlipModifier", "opponent", -1)
    startMod("opTipsyY", "TipsyYModifier", "opponent", -1)
    startMod("opDrunkY", "DrunkYModifier", "opponent", -1)
    startMod("opBoom", "BoomerangModifier", "opponent", -1)
    startMod("opInc", "IncomingAngleModifier", "opponent", -1)
    startMod("opStrumAngle", "StrumAngleModifier", "opponent", -1)
    startMod("opSkewx", "SkewXModifier", "opponent", -1)
    startMod("opJump", "JumpNotesModifier", "opponent", -1)
    startMod("opZ", "ZModifier", "opponent", -1)
    startMod("opSudden", "SuddenModifier", "opponent", -1)
    -- both
    startMod("re", "ReverseModifier", "", -1)
    startMod("invSine", "InvertSineModifier")
    startMod("jumpNote", "JumpNotesModifier", "", -1)
    startMod("skewX", "SkewXModifier", "", -1)
    startMod("incoming", "IncomingAngleModifier", "", -1)
    startMod("x", "XModifier", "", -1)
    startMod("tipsy", "TipsyYModifier", "", -1)
    startMod("drunk", "DrunkYModifier", "", -1)
    startMod("tipsyz", "TipsyZModifier", "", -1)
    startMod("angle", "ConfusionModifier", "", -1)
    startMod("flip", "FlipModifier", "", -1)
    startMod("invert", "InvertModifier", "", -1)
end

local angle = 0

function setupEvents()
    local swap = true
    local beatTip = function(beat)
        swap = swap == false
        if swap then
            set(beat, "1, tipsy, 1, drunk")
        else
            set(beat, "-1, tipsy, -1, drunk")
        end
        ease(beat, 2, "linear", "0, tipsy, 0, drunk")
    end

    if not EasyMode then
        beatTip(0)
        beatTip(8)
        beatTip(16)
        beatTip(24)
        beatTip(27)
        beatTip(32)
    end

    ease(14, 2, "circOut", [[
        0, plrStrums:y,
        0, opStealth,
        0, opX
    ]])

    ease(36, 0.5, "quadOut", "1, opInv")
    ease(37, 0.5, "quadOut", "0, opInv")
    ease(38, 0.5, "quadOut", "1, opInv")
    ease(39, 0.5, "quadOut", "0, opInv")

    ease(52, 0.5, "quadOut", "1, plrInv")
    ease(53, 0.5, "quadOut", "0, plrInv")
    ease(54, 0.5, "quadOut", "1, plrInv")
    ease(55, 0.5, "quadOut", "0, plrInv")

    set(64, "0.5, wiggle, 0, opInc:y, 0, opInc:x, 0, opBoom")
    ease(64, 1, "linear", "1, center")
    ease(65, 1, "quadOut", "0, center")
    ease(66, 1, "circOut", "0.3, re")
    ease(67, 1, "circOut", "1, re")
    ease(80, 1, "linear", "-1, center")
    ease(81, 1, "quadOut", "0, center")
    ease(82, 1, "circOut", "0.7, re")
    ease(83, 1, "circOut", "0, re")

    local switch = true
    for beat = 0, (4 * 7) - 1 do
        local time = 68 + beat

        if (beat % 4 == 0) and switch then
            ease(time, 1, "expoOut", "1 , tipsyz, 30, angle")
            switch = switch == false
        elseif (beat % 4 == 0) and not switch then
            ease(time, 1, "expoOut", "-1 , tipsyz, -30, angle")
            switch = switch == false
        end
    end

    ease(96, 1, "expoOut", "0, tipsyz, 0, angle")
    set(98, "4, jumpNote")
    set(100, "0, jumpNote")
    set(102, "4, jumpNote")
    set(104, "0, jumpNote")

    set(114, "4, jumpNote")
    set(116, "0, jumpNote")
    set(118, "4, jumpNote")
    set(120, "0, jumpNote")

    ease(126, 2, "linear", "0, wiggle")
    set(128, [[
        0.5, opSwap, 
        0.5, opStealth,
        1, plrTipsyY,
        1, plrDrunkY,
        1, opTipsyY,
        1, opDrunkY
    ]])

    for beat = 0, (4 * 8) - 1 do
        local time = 128 + beat
        local intenVar = (beat % 2 == 0 and 1 or -1)
        local inten = 100 * intenVar
        local incInten = 45 * intenVar
        local wiggleInten = 2 * intenVar

        if HardMode then
            set(time, [[
                ]] .. inten .. [[, skewX,
                ]] .. incInten .. [[, incoming:y,
                ]] .. wiggleInten .. [[, wiggle
            ]])
        elseif not EasyMode then
            set(time, [[
                ]] .. inten .. [[, skewX,
                ]] .. incInten .. [[, incoming:y
            ]])
        end
        ease(time, 1, "quadOut", [[
            0, skewX,
            0, incoming:y,
            0, wiggle
        ]])
    end

    ease(144, 1, "circOut", [[
        0, opSwap, 
        0, opStealth,
        0.1, plrReverse
    ]])
    set(144, "1, opSpiral, 1, opCenter, 0.5, opFlip, 0, opDrunkY, 0, opTipsyY")
    set(160, "0, opSpiral, 0, opCenter, 0, opFlip, 0, plrDrunkY, 0, plrTipsyY, 0, plrReverse")
    if not EasyMode then
        ease(162, 1, "quadInOut", "1, flip, 180, angle")
        ease(163, 1, "quadInOut", "0, flip, 0, angle")
        ease(166, 1, "quadInOut", "1, flip, 180, angle")
        ease(167, 1, "quadInOut", "0, flip, 0, angle")
        ease(178, 1, "quadInOut", "1, invert, 90, angle")
        ease(179, 1, "quadInOut", "0, invert, 0, angle")
        ease(182, 1, "quadInOut", "1, invert, 90, angle")
        ease(183, 1, "quadInOut", "0, invert, 0, angle")
    end
    set(192, "0.5, opSwap, 1, opStealth, 0, re, 0, x")
    ease(207, 2, "quadInOut", "0, opSwap, 0, opStealth")
    ease(222, 2, "circIn", "0.5, opSwap, 0.5, opStealth")

    for beat = 0, (4 * 8) - 1 do
        local time = 160 + beat
        local inten = (beat % 2 == 0 and 1 or -1)
        if not EasyMode then
            ease(time, 1, "linear", "" .. 50 * inten .. ", x")
        end
        ease(time, 0.5, "quadOut", "-0.05, re")
        ease(time + 0.5, 0.5, "quadin", "0.05, re")
    end

    local beatWiggle = function(beat)
        local left = getRandomInt(1, 2)
        if left == 1 then
            set(beat, "-200, x, -4, wiggle,")
        else
            set(beat, "200, x, 4, wiggle,")
        end
        if not EasyMode then
            set(beat, "4, tipsy, 4, drunk, 0.3, re")
        end

        ease(beat, 2, "circOut", [[
            0, x,
            0, wiggle,
            0, tipsy,
            0, drunk,
            0, re
        ]])
    end

    beatWiggle(224)
    beatWiggle(225.5)
    beatWiggle(227.25)
    beatWiggle(232)
    beatWiggle(233.75)
    beatWiggle(235)
    beatWiggle(240)
    beatWiggle(241.5)
    beatWiggle(243)
    beatWiggle(248)
    beatWiggle(249.75)
    beatWiggle(251)

    set(256, "0, opStealth, 0, opSwap")

    for beat = 0, (4 * 8) - 1 do
        local time = 256 + beat
        local inten = (beat % 2 == 0 and 1 or -1)
        ease(time, 1, "linear", "" .. 50 * inten .. ", x")
        ease(time, 1, "linear", "" .. 2 * inten .. ", tipsyz")
        if not EasyMode then
            ease(time, 0.5, "quadOut", "-0.05, re")
            ease(time + 0.5, 0.5, "quadin", "0.05, re")
        end
    end

    if HardMode then
        set(268, "10, wiggle, ")
        ease(268, 1, "quadOut", "0, wiggle")
        set(270, "-10, wiggle")
        ease(270, 1, "quadOut", "0, wiggle")
        set(272, "10, wiggle")
        ease(272, 1, "quadOut", "0, wiggle")

        set(284, "-8, wiggle")
        ease(284, 1, "quadOut", "0, wiggle")
        set(286, "8, wiggle")
        ease(286, 1, "quadOut", "0, wiggle")

        set(300, "-10, wiggle")
        ease(300, 1, "quadOut", "0, wiggle")
        set(302, "10, wiggle")
        ease(302, 1, "quadOut", "0, wiggle")
        set(304, "-10, wiggle")
        ease(304, 1, "quadOut", "0, wiggle")

        set(316, "8, wiggle")
        ease(316, 1, "quadOut", "0, wiggle")
        set(318, "-8, wiggle")
        ease(318, 1, "quadOut", "0, wiggle")
    end

    ease(288, 1, "linear", "0, re, 0, tipsyz, 0, x")
    set(290, "4, jumpNote")
    set(292, "0, jumpNote")
    set(294, "4, jumpNote")
    set(296, "0, jumpNote")

    set(306, "4, jumpNote")
    set(308, "0, jumpNote")
    set(310, "4, jumpNote")
    set(312, "0, jumpNote")

    ease(320, 2, "quartOut", [[
        1, center,
        0.5, flip,
        0.1, opSwap,
        90, opInc1:y,
        180, opInc3:y,
        270, opInc4:y,
        1, opSudden,
        7, opSudden:offset,
        90, plrInc1:y,
        180, plrInc3:y,
        270, plrInc4:y,
        1, plrSudden,
        10, plrSudden:offset
    ]])
    

    for beat = 0, (4 * 12) - 1 do
        local time = 320 + beat

        if beat % 1 == 0 then
            angle = angle + 30
            set(time, [[
                ]] .. (90 + angle) .. [[, opInc1:y,
                ]] .. (angle) .. [[, opInc2:y,
                ]] .. (180 + angle) .. [[, opInc3:y,
                ]] .. (270 + angle) .. [[, opInc4:y
            ]])
        end
    end

    ease(375, 4, "circOut", [[
        0, center,
        0, flip,
        0, opSwap,
        0, opInc1:y,
        0, opInc2:y,
        0, opInc3:y,
        0, opInc4:y,
        0, opSudden,
        0, plrInc1:y,
        0, plrInc2:y,
        0, plrInc3:y,
        0, plrInc4:y,
        0, plrSudden
    ]])

    if EasyMode then
        ease(380, 4, "circIn", "0.5, opSwap, 0.5, opStealth")
    else
        ease(380, 4, "circIn", "0.5, opSwap, 0.5, opStealth, 400, plrSkewx, -400, opSkewx")
    end

    set(384, "0, plrSkewx, 0, opSkewx")

    set(418, "4, jumpNote")
    set(420, "0, jumpNote")
    set(422, "4, jumpNote")
    set(424, "0, jumpNote")

    set(434, "4, jumpNote")
    set(436, "0, jumpNote")
    set(438, "4, jumpNote")
    set(440, "0, jumpNote")

    set(448, "8, plrWaveY:speed, -8, opWaveY:speed")

    for beat = 0, (4 * 8) - 1 do
        local time = 383.75 + beat
        local intenVar = (beat % 2 == 0 and 1 or -1)
        local inten = 100 * intenVar
        local incInten = 45 * intenVar
        local wiggleInten = 2 * intenVar

        if not EasyMode then
            set(time, [[
                ]] .. inten .. [[, skewX,
                ]] .. incInten .. [[, incoming:y,
                ]] .. wiggleInten .. [[, wiggle
            ]])
        end
        ease(time, 1, "quadOut", [[
            0, skewX,
            0, incoming:y,
            0, wiggle
        ]])
    end

    ease(480, 4, "quartOut", [[
        0, opZ,
        0, opX,
        0, opStrumAngle,
        0, plrZ,
        0, plrX,
        0, plrStrumAngle,
        0, wiggle,
        0, opSwap,
        0, opStealth
    ]])
end

function onUpdate(elapsed)
    if curStep >= 1535 and curStep <= 1792 then
        local moveOff = 200 * continuous_sin(curDecBeat / 8)
        local incAngle = 20 * continuous_sin(curDecBeat / 8)
        setMod("plrX", moveOff)
        setMod("opX", -moveOff)
        if not EasyMode then
            setMod("plrStrumAngle", incAngle)
            setMod("opStrumAngle", -incAngle)
        end
    end
    if curStep >= 1792 and curStep <= 1920 then
        local moveZOff = 200 * continuous_sin(curDecBeat / 8)
        local moveXOff = 200 * continuous_cos(curDecBeat / 8)
        local incAngle = 20 * continuous_sin(curDecBeat / 8)
        local wiggle = 2 * continuous_cos(curDecBeat / 8)
        if HardMode then
            setMod("plrZ", 2 * moveZOff)
            setMod("opZ", 2 * -moveZOff)
        else
            setMod("plrZ", moveZOff)
            setMod("opZ", -moveZOff)
        end
        setMod("plrX", 2 * moveXOff)
        setMod("opX", 2 * -moveXOff)
        if not EasyMode and not HardMode then
            setMod("plrStrumAngle", incAngle)
            setMod("opStrumAngle", -incAngle)
            setMod("wiggle", wiggle)
        elseif HardMode then
            setMod("plrStrumAngle", 2 * incAngle)
            setMod("opStrumAngle", 2 * -incAngle)
            setMod("wiggle", 2 * wiggle)
        end
    end
end

function continuous_sin(x)
    return math.sin((x % 1) * 2 * math.pi)
end
function continuous_cos(x)
    return math.cos((x % 1) * 2 * math.pi)
end
