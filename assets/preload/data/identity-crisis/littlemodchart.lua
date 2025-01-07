function onCreatePost()
    setPropertyFromGroup("opponentStrums", 0, "x", 412)
    setPropertyFromGroup("opponentStrums", 1, "x", 524)
    setPropertyFromGroup("opponentStrums", 2, "x", 636)
    setPropertyFromGroup("opponentStrums", 3, "x", 748)

    setPropertyFromGroup("playerStrums", 0, "x", 412)
    setPropertyFromGroup("playerStrums", 1, "x", 524)
    setPropertyFromGroup("playerStrums", 2, "x", 636)
    setPropertyFromGroup("playerStrums", 3, "x", 748)
end

function onUpdate(elapsed)
    if curStep > 0 and curStep < 64 then
        setPropertyFromGroup("opponentStrums", 0, "alpha", 0.25)
        setPropertyFromGroup("opponentStrums", 1, "alpha", 0.25)
        setPropertyFromGroup("opponentStrums", 2, "alpha", 0.25)
        setPropertyFromGroup("opponentStrums", 3, "alpha", 0.25)

        setPropertyFromGroup("playerStrums", 0, "alpha", 1)
        setPropertyFromGroup("playerStrums", 1, "alpha", 1)
        setPropertyFromGroup("playerStrums", 2, "alpha", 1)
        setPropertyFromGroup("playerStrums", 3, "alpha", 1)
    end
end

function onStepHit()
    if curStep == 64 then
        noteTweenAlpha("note lol oppo nent alpha 1", 0, 1, 5, "linear")
        noteTweenAlpha("note lol oppo nent alpha 2", 1, 1, 5, "linear")
        noteTweenAlpha("note lol oppo nent alpha 3", 2, 1, 5, "linear")
        noteTweenAlpha("note lol oppo nent alpha 4", 3, 1, 5, "linear")

        noteTweenX('note lol play er 1', 4, 732, 5, 'cubeInOut')
        noteTweenX('note lol play er 2', 5, 844, 5, 'cubeInOut')
        noteTweenX('note lol play er 3', 6, 956, 5, 'cubeInOut')
        noteTweenX('note lol play er 4', 7, 1068, 5, 'cubeInOut')

        noteTweenX('note lol oppo nent 1', 0, 92, 5, 'cubeInOut')
        noteTweenX('note lol oppo nent 2', 1, 204, 5, 'cubeInOut')
        noteTweenX('note lol oppo nent 3', 2, 316, 5, 'cubeInOut')
        noteTweenX('note lol oppo nent 4', 3, 428, 5, 'cubeInOut')
    end

    if curStep == 160 then
        noteTweenAlpha("note lol oppo nent alpha 1", 0, 0.25, 5, "cubeInOut")
        noteTweenAlpha("note lol oppo nent alpha 2", 1, 0.25, 5, "cubeInOut")
        noteTweenAlpha("note lol oppo nent alpha 3", 2, 0.25, 5, "cubeInOut")
        noteTweenAlpha("note lol oppo nent alpha 4", 3, 0.25, 5, "cubeInOut")

        noteTweenX('note lol play er 1', 4, 412, 5, 'cubeInOut')
        noteTweenX('note lol play er 2', 5, 524, 5, 'cubeInOut')
        noteTweenX('note lol play er 3', 6, 636, 5, 'cubeInOut')
        noteTweenX('note lol play er 4', 7, 748, 5, 'cubeInOut')

        noteTweenX('note lol oppo nent 1', 0, 412, 5, 'cubeInOut')
        noteTweenX('note lol oppo nent 2', 1, 524, 5, 'cubeInOut')
        noteTweenX('note lol oppo nent 3', 2, 636, 5, 'cubeInOut')
        noteTweenX('note lol oppo nent 4', 3, 748, 5, 'cubeInOut')
    end

    if curStep == 248 then
        noteTweenAlpha("note lol oppo nent alpha 1", 0, 1, 2, "expoOut")
        noteTweenAlpha("note lol oppo nent alpha 2", 1, 1, 2, "expoOut")
        noteTweenAlpha("note lol oppo nent alpha 3", 2, 1, 2, "expoOut")
        noteTweenAlpha("note lol oppo nent alpha 4", 3, 1, 2, "expoOut")
    end

    if curStep == 256 then
        cancelTween("note lol oppo nent alpha 1")
        cancelTween("note lol oppo nent alpha 2")
        cancelTween("note lol oppo nent alpha 3")
        cancelTween("note lol oppo nent alpha 4")

        setPropertyFromGroup("opponentStrums", 0, "alpha", 1)
        setPropertyFromGroup("opponentStrums", 1, "alpha", 1)
        setPropertyFromGroup("opponentStrums", 2, "alpha", 1)
        setPropertyFromGroup("opponentStrums", 3, "alpha", 1)

        setPropertyFromGroup("opponentStrums", 0, "x", defaultOpponentStrumX0)
        setPropertyFromGroup("opponentStrums", 1, "x", defaultOpponentStrumX1)
        setPropertyFromGroup("opponentStrums", 2, "x", defaultOpponentStrumX2)
        setPropertyFromGroup("opponentStrums", 3, "x", defaultOpponentStrumX3)

        setPropertyFromGroup("playerStrums", 0, "x", defaultPlayerStrumX0)
        setPropertyFromGroup("playerStrums", 1, "x", defaultPlayerStrumX1)
        setPropertyFromGroup("playerStrums", 2, "x", defaultPlayerStrumX2)
        setPropertyFromGroup("playerStrums", 3, "x", defaultPlayerStrumX3)
    end

    if curStep == 512 then
        setPropertyFromGroup("opponentStrums", 0, "alpha", 0.25)
        setPropertyFromGroup("opponentStrums", 1, "alpha", 0.25)
        setPropertyFromGroup("opponentStrums", 2, "alpha", 0.25)
        setPropertyFromGroup("opponentStrums", 3, "alpha", 0.25)

        setPropertyFromGroup("opponentStrums", 0, "x", 412)
        setPropertyFromGroup("opponentStrums", 1, "x", 524)
        setPropertyFromGroup("opponentStrums", 2, "x", 636)
        setPropertyFromGroup("opponentStrums", 3, "x", 748)
    
        setPropertyFromGroup("playerStrums", 0, "x", 412)
        setPropertyFromGroup("playerStrums", 1, "x", 524)
        setPropertyFromGroup("playerStrums", 2, "x", 636)
        setPropertyFromGroup("playerStrums", 3, "x", 748)
    end

    if curStep == 768 then
        setPropertyFromGroup("opponentStrums", 0, "alpha", 1)
        setPropertyFromGroup("opponentStrums", 1, "alpha", 1)
        setPropertyFromGroup("opponentStrums", 2, "alpha", 1)
        setPropertyFromGroup("opponentStrums", 3, "alpha", 1)

        setPropertyFromGroup("opponentStrums", 0, "x", defaultOpponentStrumX0)
        setPropertyFromGroup("opponentStrums", 1, "x", defaultOpponentStrumX1)
        setPropertyFromGroup("opponentStrums", 2, "x", defaultOpponentStrumX2)
        setPropertyFromGroup("opponentStrums", 3, "x", defaultOpponentStrumX3)

        setPropertyFromGroup("playerStrums", 0, "x", defaultPlayerStrumX0)
        setPropertyFromGroup("playerStrums", 1, "x", defaultPlayerStrumX1)
        setPropertyFromGroup("playerStrums", 2, "x", defaultPlayerStrumX2)
        setPropertyFromGroup("playerStrums", 3, "x", defaultPlayerStrumX3)
    end
end
