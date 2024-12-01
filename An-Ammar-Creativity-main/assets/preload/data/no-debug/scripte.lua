local defaultMiddle = false
thingLerp = 1

local shader = true

local hardmodeb4 = false
local isHardmode = false
local mechanic = true
function onCreate()
    mechanic = not EasyMode and Mechanic
    defaultMiddle = getPropertyFromClass("ClientPrefs", "middleScroll")
    if mechanic then
         setPropertyFromClass("ClientPrefs", "middleScroll", true)
    end

    setProperty("cameraSpeed", 1.1)

end

local backupShader = false
function onDestroy()
    setPropertyFromClass("ClientPrefs", "shaders", backupShader)
end

function onCreatePost()
    backupShader = getPropertyFromClass("ClientPrefs", "shaders")
    setPropertyFromClass("ClientPrefs", "shaders", true)
    shader = true

    addHaxeLibrary("ShaderFilter", "openfl.filters")
    initLuaShader("scroll")
    makeLuaSprite("scrollShader")
    setSpriteShader("scrollShader", "scroll")
    setShaderFloat('scrollShader', "xSpeed", 10)
    setShaderFloat('scrollShader', "ySpeed", 0)
    setShaderFloat('scrollShader', "timeMulti", 0.1)
    setShaderFloat("scrollShader", "iTime", 0)

    if shader then 
        initLuaShader("ColorsEdit")
        makeLuaSprite("colorShader")
       
        setSpriteShader("colorShader", "ColorsEdit")
        runHaxeCode([[
            game.camGame.setFilters([new ShaderFilter(game.getLuaObject("colorShader").shader)]);
            game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("colorShader").shader)]);
         ]])
        setShaderFloat("colorShader", "contrast", 1)
        setShaderFloat("colorShader", "saturation", 1.5)
        setShaderFloat("colorShader", "brightness", 1)
    end
  

    setProperty("camGame.maxScrollY", 1100)
end

function onSongStart()
    setProperty('camZooming', true)
end



function onUpdatePost(elapsed)
    if not inGameOver then
        if curBeat >= 68 then
            thingLerp = lerp(thingLerp, 0.8, elapsed*7)
            setProperty("cameraSpeed", thingLerp)
        end
        if shader and mechanic then
            setShaderFloat("scrollShader", "iTime", getProperty("scrollShader.x"))
        end
    end
end


function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if not isSustainNote and mechanic then
        addHealth(-0.015)
    end
end

function onDestroy()
    setPropertyFromClass("ClientPrefs", "middleScroll", defaultMiddle)
end

function lerp(a, b, t) return a + (b - a) * t end
