function onCreatePost()
    luaDebugMode = true
    MechanicOption = not EasyMode and Mechanic
    shadersOption = getPropertyFromClass("ClientPrefs", "shaders")

    songSpeed = getProperty('songSpeed')

    setProperty('spawnTime', 3500)

    if shadersOption then 
        initLuaShader("Glitching")
        initLuaShader("OldTV")
        makeLuaSprite("oldTvEffect", "", 0, 0)
        setSpriteShader("oldTvEffect", "OldTV")
    end

    precacheImage("ChannelsList")
    precacheImage("ChannelsList-Light")
    precacheImage("EveryPing")
    precacheImage("chars/Who")

    opponentTyping = "(You are typing..?)"
    opponentCaps = false
end