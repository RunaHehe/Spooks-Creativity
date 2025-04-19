function onCreatePost()
    setupMods()

    setMod("opHit", 0)
    setMod("plrShake", 0)

    setupEvents()
end

function setupMods()
    --player
    startMod("plrShake", "ShakyNotesModifier", "player", -1)

    --opponent
    startMod("opHit", "XModifier", "opponent", -1)
end

function setupEvents()
    for beat = 0, (4 * 16) - 1 do
        local time = 192 + beat
        if (beat % 2 == 0) then
            ease(time, 1, "expoIn", "350, opHit")
            ease(time, 0.5, "expoIn", "0, plrShake")
        end
        if (beat % 2 == 1) then
            ease(time, 1, "quadOut", "0, opHit")
            ease(time, 0, "expoIn", "20, plrShake")
        end
    end
    ease(256, 1, "quadOut", "0, opHit")
    ease(256, 0.5, "expoIn", "0, plrShake")

    for beat = 0, (4 * 8) - 1 do
        local time = 352 + beat
        if (beat % 2 == 0) then
            ease(time, 1, "expoIn", "350, opHit")
            ease(time, 0.5, "expoIn", "0, plrShake")
        end
        if (beat % 2 == 1) then
            ease(time, 1, "quadOut", "0, opHit")
            ease(time, 0, "expoIn", "20, plrShake")
        end
    end
    ease(384, 1, "quadOut", "0, opHit")
    ease(384, 0.5, "expoIn", "0, plrShake")
end