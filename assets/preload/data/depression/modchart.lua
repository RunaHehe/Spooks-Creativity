function onCreatePost()

    setupMods()

    if getPropertyFromClass('ClientPrefs', 'downScroll') then
        setSubMod("plrStrums", "y", 400)
    else
        setSubMod("plrStrums", "y", -400)
    end
    setMod("opX", 320)
    setMod("opStealth", 0.5)

    setupEvents()
end

function setupMods()
    -- player
    startMod("plrInv", "InvertModifier", "player", -1)
    startMod("plrY", "YDModifier", "player", -1)
    startMod("plrTipsyY", "TipsyYModifier", "player", -1)
    startMod("plrDrunkY", "DrunkYModifier", "player", -1)
    -- opponent
    startMod("opInv", "InvertModifier", "opponent", -1)
    startMod("opStealth", "StealthModifier", "opponent", -1)
    startMod("opX", "XModifier", "opponent", -1)
    startMod("opFlip", "FlipModifier", "opponent", -1)
    startMod("opTipsyY", "TipsyYModifier", "opponent", -1)
    startMod("opDrunkY", "DrunkYModifier", "opponent", -1)
    -- both
    startMod("re", "ReverseModifier", "", -1)
    startMod("invSine", "InvertSineModifier")
    startMod("jumpNote", "JumpNotesModifier", "", -1)
    startMod("skewX", "SkewXModifier", "", -1)
    startMod("incoming", "IncomingAngleModifier", "", -1)
    startMod("xModifier", "XModifier", "", -1)
    startMod("tipsy", "TipsyYModifier", "", -1)
    startMod("drunk", "DrunkYModifier", "", -1)
end

function setupEvents()
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

    set(64, "0.5, wiggle")
    ease(64, 1, "linear", "1, center")
    ease(65, 1, "quadOut", "0, center")
    ease(66, 1, "circOut", "0.3, re")
    ease(67, 1, "circOut", "1, re")
    ease(80, 1, "linear", "1, center")
    ease(81, 1, "quadOut", "0, center")
    ease(82, 1, "circOut", "0.7, re")
    ease(83, 1, "circOut", "0, re")

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

        set(time, [[
        ]].. inten .. [[, skewX,
        ]].. incInten .. [[, incoming:y,
        ]].. wiggleInten ..[[, wiggle
        ]])
        ease(time, 1, "quadOut", [[
            0, skewX,
            0, incoming:y,
            0, wiggle
        ]])
    end

    ease(144, 1, "circOut", [[
        0, opSwap, 
        0, opStealth
    ]])
    set(144, "1, opSpiral, 1, opCenter, 0.5, opFlip, 0, opDrunkY, 0, opTipsyY")
    set(160, "0, opSpiral, 0, opCenter, 0, opFlip, 0, plrDrunkY, 0, plrTipsyY")
    set(192, "0.5, opSwap, 1, opStealth")
    ease(207, 2, "quadInOut", "0, opSwap, 0, opStealth")
    ease(222, 2, "circIn", "0.5, opSwap, 0.5, opStealth")

    local beatWiggle = function (beat, left)
        if left then
            set(beat, "-200, xModifier, -4, wiggle,")
        else
            set(beat, "200, xModifier, 4, wiggle,")
        end
        set(beat, "4, tipsy, 4, drunk, 0.3, re")
    
        ease(beat, 2, "circOut", [[
            0, xModifier,
            0, wiggle,
            0, tipsy,
            0, drunk,
            0, re
        ]])
    end

    beatWiggle(225.5, true)
    beatWiggle(227.25, false)
    beatWiggle(232, false)
    beatWiggle(233.75, false)
    beatWiggle(235, true)
    beatWiggle(240, true)
    beatWiggle(241.5, false)
    beatWiggle(243, true)
    beatWiggle(248, true)
    beatWiggle(249.75, false)
    beatWiggle(251, true)
end
