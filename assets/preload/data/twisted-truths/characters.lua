function onCreatePost()
    luaDebugMode = true
    MechanicOption = not EasyMode and Mechanic

    songSpeed = getProperty('songSpeed')

    setProperty('spawnTime', 2500)

    precacheImage("chars/Annoyer")

    loadGraphic("opponent", "chars/Annoying User")
    loadGraphic("player", "chars/Ammar Player")
    setGraphicSize("player", 649 * 0.625, 146 * 0.625)
    setGraphicSize("opponent", 649 * 0.625, 146 * 0.625)

    opponentTyping = "(Vision is typing...)"
    opponentCaps = false
end