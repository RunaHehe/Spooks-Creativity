function onCreate()
    luaDebugMode = true

    shadersEnabled = getPropertyFromClass('ClientPrefs', 'shaders')
    backupShader = getPropertyFromClass('ClientPrefs', 'shaders')
    setPropertyFromClass('ClientPrefs', 'shaders', true)

    if shadersEnabled then
        initLuaShader("dropShadow")
    end
end

function onCreatePost()

    --Shader
    if shadersEnabled then
        setSpriteShader("dad", "dropShadow")
        setShaderFloat("dad", "_alpha", 0.8)
        setShaderFloat("dad", "_disx", -10)
        setShaderFloat("dad", "_disy", 15)
        setShaderBool("dad", "inner", true)
        setShaderBool("dad", "inverted", true)

        setSpriteShader("boyfriend", "dropShadow")
        setShaderFloat("boyfriend", "_alpha", 0.8)
        setShaderFloat("boyfriend", "_disx", 10)
        setShaderFloat("boyfriend", "_disy", 15)
        setShaderBool("boyfriend", "inner", true)
        setShaderBool("boyfriend", "inverted", true)
    end
end