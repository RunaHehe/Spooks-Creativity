local middlescrolldefault = false

function onCreate()
    middlescrolldefault = middlescroll
    setPropertyFromClass("ClientPrefs", "middleScroll", false)
end

function onCreatePost()

    setPropertyFromGroup("playerStrums", 0, "x", 732)
    setPropertyFromGroup("playerStrums", 1, "x", 844)
    setPropertyFromGroup("playerStrums", 2, "x", 956)
    setPropertyFromGroup("playerStrums", 3, "x", 1068)
end

function onStepHit()
    if curStep == 1 then
        noteTweenX('player left', 4, 412, 6, 'cubeInOut')
        noteTweenX('player down', 5, 524, 6, 'cubeInOut')
        noteTweenX('player up', 6, 636, 6, 'cubeInOut')
        noteTweenX('player right', 7, 748, 6, 'cubeInOut')

        noteTweenX('opponent left', 0, 412, 6, 'cubeInOut')
        noteTweenX('opponent down', 1, 524, 6, 'cubeInOut')
        noteTweenX('opponent up', 2, 636, 6, 'cubeInOut')
        noteTweenX('opponent right', 3, 748, 6, 'cubeInOut')
    end
    if curStep == 64 then
        noteTweenX('player left', 4, 732, 0.1, 'cubeInOut')
        noteTweenX('player down', 5, 844, 0.1, 'cubeInOut')
        noteTweenX('player up', 6, 956, 0.1, 'cubeInOut')
        noteTweenX('player right', 7, 1068, 0.1, 'cubeInOut')

        noteTweenX('opponent left', 0, 92, 0.1, 'cubeInOut')
        noteTweenX('opponent down', 1, 204, 0.1, 'cubeInOut')
        noteTweenX('opponent up', 2, 316, 0.1, 'cubeInOut')
        noteTweenX('opponent right', 3, 428, 0.1, 'cubeInOut')
    end
end