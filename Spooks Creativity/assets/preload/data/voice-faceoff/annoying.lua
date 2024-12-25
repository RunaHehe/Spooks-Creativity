local scaleX, scaleY = nil, nil
function onCreate()
    scaleX = getPropertyFromClass("flixel.FlxG", "scaleMode.scale.x")
    scaleY = getPropertyFromClass("flixel.FlxG", "scaleMode.scale.y")
end

local colorSingMode = false

local membersSprites = {}

pbr = 1
function onCreatePost()
    pbr = getProperty("playbackRate")

    --setGlobalFromScript("stages/discordStage", "disableCamLerp", true)
    setProperty("camBDiscord.zoom", 1.6)
    setProperty("camDiscord.zoom", 2)

    makeLuaSprite("shakeSpr", "", 0 , 0)

    makeLuaSprite("blackFade", "", 0 , 0)
    makeGraphic("blackFade", 2000,2000, "000000")
    setScrollFactor("blackFade", 0 ,0)
    addLuaSprite("blackFade", true)
    screenCenter("blackFade")
    setObjectCamera("blackFade", "hud")
    setProperty('blackFade.alpha', 0);

    setProperty("dad.healthIcon", "ammar")
    setProperty("boyfriend.healthIcon", "annoyer")
    runHaxeCode([[
        game.iconP2.changeIcon("icon-ammar");
        game.iconP1.changeIcon("icon-annoyer");
      ]])
      
     setHealthBarColors("60f542", "ffc400")

     membersSprites = getProperty("membersSprites")

end

function onSongStart()
   -- setGlobalFromScript("stages/discordStage", "disableCamLerp", false)
end


function onStepHit()
end


function goodNoteHit(id, dir)

end

function onUpdate(elapsed) 

end

function onUpdatePost(elapsed)
    if not inGameOver then
        shakyi(elapsed)

     end
end



function shakyi(elapsed)
    local resultShake = getProperty("shakeSpr.x")

    local HUDX = 0.5 * screenWidth * (1 - getProperty("camHUD.zoom")) * scaleX
    local HUDY = 0.5 * screenHeight * (1 - getProperty("camHUD.zoom")) * scaleY

    local randomX =  getRandomFloat(-resultShake, resultShake) * 1
    local randomY =  getRandomFloat(-resultShake, resultShake) * 1
    
    local rotate = math.sin(getSongPosition()/500) * 10
    setProperty("camHUD.canvas.x", HUDX + -randomX*-0.6)
    setProperty("camHUD.canvas.y", HUDY + -randomY*-0.6)
    setProperty("camBDiscord.x", -randomX*0.7)
    setProperty("camBDiscord.y", -randomY*0.7)
    setProperty("camDiscord.x", -randomX)
    setProperty("camDiscord.y", -randomY)
    
    
end


function opponentNoteHit(id, dir, type, sus)
    if HardMode and not sus then 
        if getHealth() > 0.2 then 
            addHealth(-0.008)
        end
    end
end

function continuous_sin(x) return math.sin((x % 1) * 2*math.pi) end
function lerp(a, b, t) return a + (b - a) * t end