function onCreatePost()
    setupMods()
    setMod("dadY", -150)
    setMod("bfY", -150)
    setupEvents()
end

function setupMods()
    startMod("dadY", "YDModifier", "opponent", -1)
    startMod("bfY", "YDModifier", "player", -1)
    startMod("xModifier", "XModifier", "", -1)
    startMod("rotateStrums", "ConfusionModifier", "", -1)
    startMod("tMod", "TordnadoModifier", "", -1)
    startMod("stealthMod", "StealthModifier", "", -1)
end

function setupEvents()
    ease(0, 8, "quadOut", "0, dadY")
    ease(8, 8, "quadOut", "0, bfY")
    for beat = 0, (4 * 36) - 1 do
        local time = 16 + beat

        if (beat % 2 == 0) then
            set(time, '40, xModifier')
            set(time, '20, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
        if (beat % 2 == 1) then
            set(time, '-40, xModifier')
            set(time, '-20, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
    end

    set(96, '1, tMod')
    set(160, '0, tMod')
    set(176, '0.5, tMod')
    set(192, '1, tMod')
    set(224, '1.5, tMod')
    set(256, '0, tMod')
    set(272, '0.5, tMod')
    set(288, '0, tMod')
    ease(288, 1, "quadOut", "2, stealthMod")

    --literally just fucking repeat it lmao
    for beat = 0, (4 * 12) - 1 do
        local time = 176 + beat

        if (beat % 2 == 0) then
            set(time, '40, xModifier')
            set(time, '20, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
        if (beat % 2 == 1) then
            set(time, '-40, xModifier')
            set(time, '-20, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
    end
    for beat = 0, (4 * 8) - 1 do
        local time = 224 + beat

        if (beat % 2 == 0) then
            set(time, '50, xModifier')
            set(time, '30, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
        if (beat % 2 == 1) then
            set(time, '-50, xModifier')
            set(time, '-30, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
    end
    for beat = 0, (4 * 4) - 1 do
        local time = 272 + beat

        if (beat % 2 == 0) then
            set(time, '40, xModifier')
            set(time, '20, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
        if (beat % 2 == 1) then
            set(time, '-40, xModifier')
            set(time, '-20, rotateStrums')
            ease(time, 1, "quadOut", "0, xModifier")
            ease(time, 1, "quadOut", "0, rotateStrums")
        end
    end

end