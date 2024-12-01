
local isHardmode = false
local mechanic = true

local shader = true
function onCreatePost()
    mechanic = (DifficultyOption == "classic" or DifficultyOption == "challenging") and Mechanic
    shader = shadersEnabled
end

function onBeatHit()
    if curBeat == 4 then
        doTweenX("scroll", "scrollShader", 1, 2, "quadInOut")
        if HardMode then
            debugPrint('\"HealthDrain = true;\"')
        end
    end
    if curBeat == 67 and HardMode then
        setProperty('dadGroup.visible', false)
        setProperty('dad.visible', false)
    end
    if curBeat == 68 and HardMode then
        setProperty('iconP2.visible', false)
    end
    if curBeat == 68 or curBeat == 360 then
        
        setProperty("cameraSpeed", 0.8)
        setProperty("defaultCamZoom", 0.6)

        if shader then
            setShaderFloat("colorShader", "saturation", 1)
        end
        if HardMode and curBeat == 68 then
            debugPrint('\"me gonna sleep\"')
        end
    end

    if curBeat == 292 then
        setProperty("cameraSpeed", 1.1)
        setProperty("defaultCamZoom", 0.9)
        if shader then
            setShaderFloat("colorShader", "saturation", 0.05)
            runHaxeCode([[
                game.camGame.setFilters([new ShaderFilter(game.getLuaObject("colorShader").shader)]);
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("colorShader").shader), new ShaderFilter(game.getLuaObject("scrollShader").shader)]);
            ]])
        else
            runHaxeCode([[
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("scrollShader").shader)]);
            ]])
        end
        doTweenX("scroll", "scrollShader", 8, crochet/1000*4*17, "linear")
    end

    if curBeat == 360 then
        if shader then
            runHaxeCode([[
                game.camGame.setFilters([new ShaderFilter(game.getLuaObject("colorShader").shader)]);
                game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("colorShader").shader)]);
             ]])
        end
    end

    --COMMENT
    --[[
    if curBeat == 71 and mechanic then
        debugPrint("healthBar.visible = false;")
        setProperty("healthBar.visible", false)
        setProperty("healthBarBG.visible", false)
    end

    if curBeat == 74 and mechanic then
        debugPrint("icons.visible = false;")
        setProperty("nIconP1.visible", false)
        setProperty("nIconP2.visible", false)
    end
    if curBeat == 77 and mechanic then
        debugPrint("LIVES = 3;")
        
        local live = 3 
        setGlobalFromScript("scripts/engine/engine", "LIVES", live)
        setGlobalFromScript("scripts/engine/engine", "curLive", live)

        setTextString('missText', "LIVES: " .. live .. "/" .. live)

        if not getProperty("missText.visible") then
            setProperty("comboText.y", getProperty('comboText.y') - 30)
        end
        setProperty("missText.visible", true)
    end ]]
    if not HardMode then
        if curBeat == 82 then
            setHealth(1)
            debugPrint("\"If you beat me,\"")
        end
        if curBeat == 86 then
            debugPrint("\"I will let you access to the developer mode\"")
        end

        if curBeat == 266 then
            debugPrint("\"Nooo!!111!!!1\"")
        end
        if curBeat == 276 then
            debugPrint("\"How?!!1/1/\"")
        end
        if curBeat == 285 then
            debugPrint("\"Hmm\"")
        end
        if curBeat == 492 then
            debugPrint("\"Ok fine\"")
            setProperty("canPause", false)
        end
    end

    if curBeat == 68 or curBeat == 360 then
        cameraFlash("camHUD", 'ffffff', 1, true)
    end

    if curBeat == 292 then
        cameraFlash("camHUD", 'ffffff', 2, true)
    end
end

function onMoveCamera(character)
    if curBeat >= 100 then
        setGlobalFromScript("data/no-debug/zscriptee", "thingLerp", 0)
    end
end