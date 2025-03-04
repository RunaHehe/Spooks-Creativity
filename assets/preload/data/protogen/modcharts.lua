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
    -- player mods
    startMod("bfStealth", "StealthModifier", "player", -1)
    startMod("bfY", "YDModifier", "player", -1)
    startMod("bfX", "XModifier", "player", -1)
    -- both mods
    startMod("sudden", "SuddenModifier", "", -1)
    startMod("wiggle", "InvertSineModifier", "", -1)
    startMod("xmod", "SpeedModifier", "", -1)
    startMod("tipsy", "TipsyYModifier", "", -1)
    startMod("drunk", "DrunkYModifier", "", -1)
    startMod("beat", "BeatXModifier", "", -1)
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
            if beat % 2 == 0 then
                ease(time, 0.5, "linear", "2, beat")
            else
                ease(time, 0.5, "linear", "-2, beat")
            end
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
                ease(time-0.5, 0.5, "quadIn", [[
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
        ease(127, 1, "quadOut", "0, zMod" .. i ..", 0, angle"..i)
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
end
