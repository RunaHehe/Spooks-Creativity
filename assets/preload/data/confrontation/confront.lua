function onCreatePost()
    luaDebugMode = true
    MechanicOption = not EasyMode and Mechanic

    songSpeed = getProperty('songSpeed')

    setProperty('spawnTime', 3500)

    precacheImage("ChannelsList")
    precacheImage("ChannelsList-Light")
    precacheImage("chars/Annoying User")

    loadGraphic("opponent", "chars/Annoying User")
    loadGraphic("player", "chars/Ammar")

    setGraphicSize("player", 649 * 0.625, 146 * 0.625)
    setGraphicSize("opponent", 649 * 0.625, 146 * 0.625)

    opponentTyping = "(Vision is typing...)"
    opponentCaps = false
end


function onStepEvent(step) 
    if step == 246 then
        setGlobalFromScript("stages/discordStage", "disableDadTextRemove", true)
        setGlobalFromScript("stages/discordStage", "disableDadTextTyping", true)
    end

    if step == 252 then
        setTextString("opponentText", "Gay")
    end

    if step == 254 then
        setTextString("opponentText", "Gayass")
    end

    if step == 256 then
        setGlobalFromScript("stages/discordStage", "disableDadTextRemove", false)
        setGlobalFromScript("stages/discordStage", "disableDadTextTyping", false)
    end
end