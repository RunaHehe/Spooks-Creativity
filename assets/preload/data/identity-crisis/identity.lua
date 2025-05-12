function onCreatePost()
    luaDebugMode = true
    MechanicOption = not EasyMode and Mechanic
    shadersOption = getPropertyFromClass("ClientPrefs", "shaders")

    songSpeed = getProperty('songSpeed')

    setProperty('spawnTime', 3500)

    opponentTyping = "(You are typing..?)"
    opponentCaps = false
end