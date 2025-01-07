showMode = false
centerCam = false centerX = 550 centerY = 300
thisCameraSystem = true

local backupShader = true
function onCreate()
    addHaxeLibrary("FlxBackdrop", 'flixel.addons.display')
    luaDebugMode = true 

    shadersEnabled = getPropertyFromClass("ClientPrefs", "shaders")
    backupShader = shadersEnabled
	setPropertyFromClass("ClientPrefs", "shaders", true)

    runHaxeCode([[
        var checker = new FlxBackdrop(Paths.image("checker"));
        checker.velocity.x = 100;
        checker.velocity.y = -30;
        checker.scale.set(5, 5);
        checker.color = 0xFFDC000F;
        checker.alpha = 0.2;
        game.add(checker);
        setVar('checker', checker);
    ]])
    setScrollFactor("checker", 0.5, 0.5)
    setObjectOrder("checker", 0)

    makeLuaSprite('darkGround', 'ammarvoid/darkBottom', -800, -120)
    setScrollFactor("darkGround", 0.0, 0.0)
    scaleObject("darkGround", 3, 2)
    updateHitbox("darkGround")
    addLuaSprite('darkGround')

    makeLuaSprite('ground', '', -1400, 500)
    makeGraphic('ground', 3400, 400, 'FFFFFF')
    setProperty('ground.color', getColorFromHex("DC000F"))
    setProperty('ground.alpha', 0.9)
    addLuaSprite('ground')

    setPerspective('ground', 0.8) -- WOW
	setVanishOffset(0, 0)
	setScrollFactor('ground', 1.23, 1.23)

    runHaxeCode("setVar('showMode', false)")
end
function onCreatePost()
    onPerspectiveCreate()
end
function onDestory()
	setPropertyFromClass("ClientPrefs", "shaders", backupShader)
end

local targetCamX, targetCamY = 0, 0
local thingLerp = 1
function onUpdate(elapsed)
    if not inGameOver and not getProperty('isCameraOnForcedPos') and thisCameraSystem then
        if centerCam then
            setProperty("camFollow.x", centerX + math.sin(getSongPosition()/500)*5)
            setProperty("camFollow.y", centerY + math.cos(getSongPosition()/700)*5)
        else
            setProperty("camFollow.x", targetCamX + math.sin(getSongPosition()/500)*30)
            setProperty("camFollow.y", targetCamY + math.cos(getSongPosition()/700)*30)
        end
    end
end

function onUpdatePost(elapsed)
	if not inGameOver then
		onPerspectiveUpdate()
	end
end


function onMoveCamera(character)
    if thisCameraSystem then
        if showMode or getProperty('showMode') and not getProperty('isCameraOnForcedPos')  then
            if character == "dad" then
                --setProperty("camFollow.x", getProperty("camFollow.x") + 300)
                setProperty("camFollow.x", 230.5)
            else
                --setProperty("camFollow.x", getProperty("camFollow.x") - 360)
                setProperty("camFollow.x", 917.5)
            end
        else
            if character == "dad" then
                --setProperty("camFollow.x", getProperty("camFollow.x") + 300)
                --setProperty("camFollow.x", 230.5)
                setProperty("camFollow.x", -92)
            else
                setProperty("camFollow.x", 1275.5)
            end
        end

        targetCamX, targetCamY = getProperty("camFollow.x"), getProperty("camFollow.y")
    end
end



function beatChecker(duration)
    setProperty('checker.velocity.x', 600)
    setProperty('checker.velocity.y', -160)
    setProperty('checker.alpha', 0.5)

    doTweenX('checkerx', 'checker.velocity', 100, crochet/1000 * (duration or 1), 'quadOut')
    doTweenY('checkery', 'checker.velocity', -30, crochet/1000 * (duration or 1), 'quadOut')
    doTweenAlpha('checkera', 'checker', 0.2, crochet/1000 * (duration or 1), 'quadOut')
end










local vanish_offset = {x = 0, y = 0}
local sprites = {}

function setPerspective(tag, depth)
	depth = tonumber(depth) or 1
	
	if sprites[tag] then
		sprites[tag].depth = depth
	else
		sprites[tag] = {
			x = getProperty(tag .. ".x"),
			y = getProperty(tag .. ".y"),
			width = getProperty(tag .. ".width"),
			height = getProperty(tag .. ".height"),
			scale = {x = getProperty(tag .. ".scale.x"), y = getProperty(tag .. ".scale.y")},
			depth = depth
		}
		
		setSpriteShader(tag, "perspective")
		setShaderFloatArray(tag, "u_top", {0, 1})
		setShaderFloat(tag, "u_depth", depth)
	end
end

function removePerspective(tag)
	local sprite = sprites[tag]
	if sprite then
		scaleObject(tag, sprite.scale.x, sprite.scale.y, true)
		setProperty(tag .. ".x", sprite.x)
		setProperty(tag .. ".y", sprite.y)
		
		removeSpriteShader(tag)
		
		sprites[tag] = nil
	end
end

function setVanishOffset(x, y)
	if x then vanish_offset.x = tonumber(x) or 0 end
	if y then vanish_offset.y = tonumber(y) or 0 end
end

--

for _, func in pairs({"max"}) do _G[func] = math[func] end

function onPerspectiveCreate()
	initLuaShader("perspective")
	
	runHaxeCode([[
		createGlobalCallback("setPerspective", function(tag:String, depth:Float) {parentLua.call("_setPerspective", [tag, depth]);});
		createGlobalCallback("removePerspective", function(tag:String) {parentLua.call("_removePerspective", [tag]);});
		createGlobalCallback("setVanishOffset", function(x:Float, y:Float) {parentLua.call("_setVanishOffset", [x, y]);});
	]])
end

function onPerspectiveUpdate()
	local cam = {x = getProperty("camGame.scroll.x") + screenWidth / 2 + vanish_offset.x, y = getProperty("camGame.scroll.y") + screenHeight / 2 + vanish_offset.y}
	
	for tag, sprite in pairs(sprites) do
		local vanish = {x = (cam.x - sprite.x) / sprite.width, y = 1 - (cam.y - sprite.y) / sprite.height}
		local top = {sprite.depth * vanish.x, sprite.depth * (vanish.x - 1) + 1}
		
		if top[2] > 1 then
			scaleObject(tag, sprite.scale.x * (1 + sprite.depth * (vanish.x - 1)), sprite.scale.y * (sprite.depth * vanish.y), true)
		elseif top[1] < 0 then
			scaleObject(tag, sprite.scale.x * (1 - sprite.depth * (vanish.x)), sprite.scale.y * (sprite.depth * vanish.y), true)
			setProperty(tag .. ".x", sprite.x + sprite.width * sprite.depth * vanish.x)
		else
			scaleObject(tag, sprite.scale.x, sprite.scale.y * (sprite.depth * vanish.y), true)
		end
		
		setProperty(tag .. ".y", sprite.y + sprite.height * (1 - sprite.depth * max(vanish.y, 0)))
		
		setShaderFloatArray(tag, "u_top", top)
	end
end