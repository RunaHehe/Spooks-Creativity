local idk = false
function onCreatePost()
    shadersOption = getPropertyFromClass("ClientPrefs", "shaders")
    if shadersOption then
        initLuaShader("OldTV")
        initLuaShader("rain")

        makeLuaSprite("oldTvEffect", "", 0, 0)
        makeLuaSprite("oldTVNoStatic")
        makeLuaSprite("rainhehe", "", 0, 0)

        setSpriteShader("rainhehe", "rain")
        setSpriteShader("oldTvEffect", "OldTV")
        setSpriteShader("oldTVNoStatic", "OldTV")
    end

    loadGraphic("opponent", "chars/Deleted User")
    loadGraphic("player", "chars/Annoying User")

    setGraphicSize("player", 649 * 0.625, 146 * 0.625)
    setGraphicSize("opponent", 649 * 0.625, 146 * 0.625)

    setGlobalFromScript("stages/discordStage", "opponentTyping", "(Delta is typing...)")

    setProperty("dad.healthIcon", "depress")
    runHaxeCode([[
        game.iconP2.changeIcon("icon-depress");
    ]])
end

function onStepEvent(curStep)
    --runa time!!
    if curStep == 256 then
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x90FFFFFF", 2)
        if shadersOption then
            runHaxeCode([[
                camDiscord.setFilters([new ShaderFilter(game.getLuaObject("oldTvEffect").shader)]);
                camBDiscord.setFilters([new ShaderFilter(game.getLuaObject("oldTvEffect").shader)]);
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("oldTvEffect").shader)]);
            ]])
        end
    end
    if curStep == 512 then 
        cameraFlash("HUD", "FFFFFF", 2)
    end
    if curStep == 768 then
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x90FFFFFF", 2)
        callScript("stages/discordStage", "lightingMode", {true})
    end
    if curStep == 896 then
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x90FFFFFF", 0.4)
        callScript("stages/discordStage", "lightingMode", {false})
        if shadersOption then
            runHaxeCode([[
                camDiscord.setFilters([new ShaderFilter(game.getLuaObject("rainhehe").shader)]);
                camBDiscord.setFilters([new ShaderFilter(game.getLuaObject("rainhehe").shader)]);
           ]])
           setShaderFloat("rainhehe", "iIntensity", 0.13)
        end
    end
    if curStep == 902 or curStep == 909 or curStep == 928 or curStep == 935 or curStep == 940 or curStep == 960 or curStep == 966 or curStep == 972 or curStep == 992 or curStep == 999 or curStep == 1004 then
        cameraFlash("camOther", flashingLights and "0x40FFFFFF", 0.3)
    end
    if curStep == 1024 then
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x80FFFFFF", 1.2)
    end
    if curStep == 1280 then
        loadGraphic("player", "chars/Ammar")
        setGraphicSize("player", 649 * 0.625, 146 * 0.625)
        cameraFlash("camOther", "FFFFFF", 1)
        setTextString("playerText", "")
        if shadersOption then
            setShaderFloat("rainhehe", "iIntensity", 0.2)
        end
    end
    if curStep == 1536 then
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x40FFFFFF", 1)
    end
    if curStep == 2560 or curStep == 2566 or curStep == 2572 then
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x30FFFFFF", 0.4)
    end
    if curStep == 2576 then
        cameraFlash("camOther", flashingLights and "FFFFFF" or "0x90FFFFFF", 1.2)
    end
end

function onUpdate(elapsed)
    if shadersOption then
        setShaderFloat("oldTvEffect", "iTime", os.clock()%100)
        setShaderFloat("rainhehe", "iTime", os.clock()%100)
        setShaderFloat("rainhehe", "iTimescale", 0.1)
    end
end