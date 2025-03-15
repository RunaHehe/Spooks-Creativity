local angle = 0

function onCreatePost()
    setupMods()
    setMod("middle", 1)
    setMod("bumpy", 2)
    setMod("opDarken", 1)
    setMod("dadStealth", 0.5)
    setSubMod("bumpy", "freq", 0.3)
    setupEvents()
end

function setupMods()
    -- dad mods
    startMod("dadStealth", "StealthModifier", "opponent", -1)
    startMod("opNoteMod", "NotesModifier", "opponent", -1)
    -- bf mods
    startMod("bfTipsy", "TipsyYModifier", "player", -1)
    startMod("bfDrunk", "DrunkYModifier", "player", -1)
    startMod("bfNoteMod", "NotesModifier", "player", -1)
    -- both mods
    startMod("xmod", "SpeedModifier", "", -1)
    startMod("conf", "ConfusionModifier", "", -1)
    startMod("inc", "IncomingAngleModifier", "", -1)
    -- startMod("drunkAngle", "DrunkAngleModifier", "", -1)
    -- startMod("tor", "TornadoModifier", "", -1)
end

function setupEvents()
    set(0, "0, middle, 0.5, opSwap")
    ease(0, 4, "linear", "1, dadStealth")
    ease(63, 2, "quadOut", "0, bumpy")
    set(100, "1, wiggle, 4, wiggle:speed, 0.3, wiggle:freq")
    set(162, "0, wiggle")
    ease(162, 2, "cubeOut", "1, parra")

    ease(192, 2, "cubeOut", "0, parra")
    -- set(192, "10, drunkAngle, 2, drunkAngle:speed, 1, tor")

    for beat = 0, (4 * 16) - 1 do
        local time = 196 + beat

        if time % 2 == 0 then
            set(time, "1, bfTipsy, 1, bfDrunk")
            ease(time, 1, "linear", "0, bfTipsy, 0, bfDrunk")
        end
        if time % 2 == 1 then
            set(time, "-1, bfTipsy, -1, bfDrunk")
            ease(time, 1, "linear", "0, bfTipsy, 0, bfDrunk")
        end
    end
    set(260, "0, noteMod:x, 0, strumMod:x, 1, parra")
    set(360, "0, parra")
    ease(360, 4, "bounceOut", "1, re1, 1, cubix")
    ease(360.25, 4, "bounceOut", "1, re2")
    ease(360.5, 4, "bounceOut", "1, re3")
    ease(360.75, 4, "bounceOut", "1, re4")
    set(392, "0, cubix")
    set(424, "0, inc:y, 0, opDarken, 1, opStealth")
    ease(424, 4, "linear", "0.5, dadStealth")
    for i = 1, 4 do
        ease(424, 4, "linear", "0, re"..i)
    end
end

function onUpdate(elapsed)
    if (curStep >= 784 and curStep < 912) or (curStep >= 1696 and curStep < 1824) then
        local moveOff = 200 * continuous_sin(curDecBeat / 8)
        setSubMod("opNoteMod", "x", -moveOff/2)
        setSubMod("bfNoteMod", "x", moveOff/2)
    end
    if (curStep >= 912 and curStep < 1040) or (curStep >= 1824 and curStep < 1952) then
        local moveOff = 200 * continuous_sin(curDecBeat / 8)
        setSubMod("opNoteMod", "x", -moveOff)
        setSubMod("bfNoteMod", "x", moveOff)
        setSubMod("opStrumMod", "x", moveOff)
        setSubMod("bfStrumMod", "x", -moveOff)
    end
    if curStep >= 912 and curStep < 1040 then
        setProperty("songSpeed", 2.4 + (0.7 * continuous_sin(curDecBeat / 4)))
    end
    if curStep >= 784 and curStep < 1040 then
        setProperty("camHUD.angle", continuous_sin(curDecBeat / 8) * 7)
    end

    if curStep >= 1568 and curStep < 1695 then
        local incAngle = 20 * continuous_sin(curDecBeat / 8)
        setSubMod("inc", "y", incAngle)
    end
end

function onStepHit()
    if curStep == 1040 then
        setProperty("camHUD.angle", 0)
        setProperty("songSpeed", 2.7)
    end
    if curStep >= 1168 and curStep < 1420 then
        if curStep % 16 == 12 then
            angle = angle + 90
            tweenModifier("conf", angle, 0.5, "elasticInOut")
        end
        if curStep % 8 == 0 then
            doTweenY("camHUD", "camHUD", (downscroll and 20 or -20), crochet / 1000, "quadOut")
        end
        if curStep % 8 == 4 then
            doTweenY("camHUD", "camHUD", 0, crochet / 1000, "quadIn")
        end
    end
    if curStep == 1420 then
        tweenModifier("conf", 0, 2, "quadOut")
    end
    if curStep == 1440 then
        doTweenY("camHUD", "camHUD", 0, crochet / 1000, "quadIn")
    end
end

function continuous_sin(x)
    return math.sin((x % 1) * 2 * math.pi)
end
