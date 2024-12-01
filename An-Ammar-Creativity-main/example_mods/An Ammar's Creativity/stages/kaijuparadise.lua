local folder = 'kaijuparadise/'

local backupShader = true;
function onCreate()
	luaDebugMode = true

	shaderCoordFix()

	shadersEnabled = getPropertyFromClass("ClientPrefs", "shaders")
	backupShader = shadersEnabled
	runHaxeCode("setVar('shaderBack', "..(shadersEnabled and 'true' or 'false')..")")
	setPropertyFromClass("ClientPrefs", "shaders", true)

	makeLuaSprite('bg', '', 0,0)
	makeGraphic("bg", 1280, 720, '777995')
	scaleObject('bg', 3, 3)
	setScrollFactor('bg', 0, 0)
	screenCenter('bg')
	addLuaSprite('bg')

	makeLuaSprite('ground', folder..'Ground', -2930, 300)
	scaleObject('ground', 2, 0.5)
	addLuaSprite('ground')
	
	setPerspective('ground', 1) -- WOW
	setVanishOffset(0, -500)
	setScrollFactor('ground', 1.262, 1.262)

	makeLuaSprite('wallbackdoor', '', -400,-70)
	makeGraphic("wallbackdoor", 700, 420, '777995')
	scaleObject('wallbackdoor', 1, 1)
	setScrollFactor('wallbackdoor', 0.75, 0.75)
	addLuaSprite('wallbackdoor')

	makeLuaSprite('bgbackdoor', '', -400,0)
	makeGraphic("bgbackdoor", 700, 420, '000000')
	scaleObject('bgbackdoor', 1, 1)
	setScrollFactor('bgbackdoor', 0.75, 0.75)
	setProperty('bgbackdoor.alpha', 0.3)
	
	makeAnimatedLuaSprite("charbackdoor", folder..'BehindDoorChars', -210, 220)
	addAnimationByPrefix("charbackdoor", "idle", "CharsBehindDoor", 0, false)
	scaleObject('charbackdoor', 1.65, 1.65)
	setScrollFactor('charbackdoor', 0.75, 0.75)
	playAnim('charbackdoor', 'idle', true)
	addLuaSprite('charbackdoor')
	addLuaSprite('bgbackdoor')
	
	makeLuaSprite('ldoor', folder..'Left Door', -375, 165)
	scaleObject('ldoor', 0.75, 0.75)
	setScrollFactor('ldoor', 0.75, 0.8)
	addLuaSprite('ldoor')
	
	makeLuaSprite('rdoor', folder..'Right Door', -165, 165)
	scaleObject('rdoor', 0.75, 0.75)
	setScrollFactor('rdoor', 0.75, 0.8)
	addLuaSprite('rdoor')
	
	
	makeLuaSprite('backdoor', folder..'Backdoor', -810, -175)
	scaleObject('backdoor', 0.75, 0.75)
	setScrollFactor('backdoor', 0.75, 0.8)
	addLuaSprite('backdoor')
	
	makeLuaSprite('wall', folder..'Walls', -1600, -1000)
	scaleObject('wall', 0.75, 0.75)
	setScrollFactor('wall', 0.8, 0.8)
	addLuaSprite('wall')
	
	
	makeLuaSprite('vent1', folder..'Vent', 100, -90)
	scaleObject('vent1', 0.75, 0.75)
	setScrollFactor('vent1', 0.8, 0.8)
	addLuaSprite('vent1')
	
	makeLuaSprite('ventfan1', folder..'VentFan', 137, -50)
	scaleObject('ventfan1', 0.75, 0.75)
	setScrollFactor('ventfan1', 0.8, 0.8)
	setProperty('ventfan1.origin.x', 12 * 2.4)
	setProperty('ventfan1.origin.y', 13 * 2.35)
	addLuaSprite('ventfan1')

	makeLuaSprite('vent2', folder..'Vent', 315, -90)
	scaleObject('vent2', 0.75, 0.75)
	setScrollFactor('vent2', 0.8, 0.8)
	addLuaSprite('vent2')

	makeLuaSprite('ventfan2', folder..'VentFan', 352, -50)
	scaleObject('ventfan2', 0.75, 0.75)
	setScrollFactor('ventfan2', 0.8, 0.8)
	setProperty('ventfan2.origin.x', 12 * 2.4)
	setProperty('ventfan2.origin.y', 13 * 2.35)
	addLuaSprite('ventfan2')

	makeLuaSprite('furnitures', folder..'Furnitures', 385, -28)
	scaleObject('furnitures', 0.75, 0.75)
	setScrollFactor('furnitures', 0.81, 0.81)
	addLuaSprite('furnitures')

	makeAnimatedLuaSprite("thegirl", folder..'The Girl', -780, 260)
	addAnimationByPrefix("thegirl", "bop", "thegirl_bop", 24, false)
	scaleObject('thegirl', 1.2, 1.2)
	setScrollFactor('thegirl', 0.8, 0.8)
	addLuaSprite('thegirl')
	playAnim('thegirl', 'bop', true)

	makeAnimatedLuaSprite("chars", folder..'Back Chars', 400, 120)
	addAnimationByIndices("chars", "bop1", "Stage Back Chars", "0,1,2,3,4,5,6,7,8,9,10,11,12,13,14", 24)
	addAnimationByIndices("chars", "bop2", "Stage Back Chars", "15,16,17,18,19,20,21,22,23,24,25,26,27,28,29", 24)
	scaleObject('chars', 1.2, 1.2)
	setScrollFactor('chars', 0.85, 0.85)
	addLuaSprite('chars')
	playAnim('chars', 'bop1', true)

	makeLuaSprite('upground', folder..'UpGround', -225, 280)
	scaleObject('upground', 0.75, 0.75)
	setScrollFactor('upground', 0.85, 0.85)
	addLuaSprite('upground')

	makeAnimatedLuaSprite("fox", folder..'KreatorFox', 1600, 250)
	addAnimationByPrefix("fox", "bop", "KreatorFox_Bop", 24, false)
	scaleObject('fox', 1.2, 1.2)
	setScrollFactor('fox', 0.85, 0.85)
	addLuaSprite('fox')
	playAnim('fox', 'bop', true)

	makeLuaSprite('crate', folder..'Front Furnitures', 450, 400)
	scaleObject('crate', 0.75, 0.75)
	setScrollFactor('crate', 0.88, 0.88)
	addLuaSprite('crate')

	--LIGHTS
	makeLuaSprite('light1', folder..'Light', -1820, -440)
	scaleObject('light1', 1, 1)
	setScrollFactor('light1', 0.8, 0.8)
	addLuaSprite('light1', true)
	setBlendMode('light1', 'add')
	setProperty('light1.alpha', 0.3)

	makeLuaSprite('light2', folder..'Light', -750, -500)
	scaleObject('light2', 1, 1)
	setScrollFactor('light2', 0.8, 0.8)
	addLuaSprite('light2', true)
	setBlendMode('light2', 'add')
	setProperty('light2.alpha', 0.3)

	makeLuaSprite('light3', folder..'Light', 480, -500)
	scaleObject('light3', 1, 1)
	setScrollFactor('light3', 0.8, 0.8)
	addLuaSprite('light3', true)
	setBlendMode('light3', 'add')
	setProperty('light3.alpha', 0.3)

	makeLuaSprite('light4', folder..'Light', 1420, -440)
	scaleObject('light4', 1, 1)
	setScrollFactor('light4', 0.8, 0.8)
	addLuaSprite('light4', true)
	setBlendMode('light4', 'add')
	setProperty('light4.alpha', 0.3)
	--LIGHTS

	-- FRONT CHARS
	makeAnimatedLuaSprite("roy", folder..'front/RoyTheWolf', -1100, 550)
	addAnimationByPrefix("roy", "bop", "Roy The Wolf", 24, false)
	scaleObject('roy', 2, 2)
	setScrollFactor('roy', 1.2, 0.5)
	addLuaSprite('roy', true)
	playAnim('roy', 'bop', true)

	makeAnimatedLuaSprite("feizao", folder..'front/Feizao', -500, 550)
	addAnimationByPrefix("feizao", "bop", "Feizao", 24, false)
	scaleObject('feizao', 2, 2)
	setScrollFactor('feizao', 1.2, 0.5)
	addLuaSprite('feizao', true)
	playAnim('feizao', 'bop', true)

	makeAnimatedLuaSprite("hazzy", folder..'front/Hazzy', 1700, 630)
	addAnimationByPrefix("hazzy", "bop", "Hazzy", 24, false)
	scaleObject('hazzy', 2, 2)
	setScrollFactor('hazzy', 1.2, 0.5)
	addLuaSprite('hazzy', true)
	playAnim('hazzy', 'bop', true)
	--

	makeLuaSprite('chardark', '', -500,-300)
	makeGraphic("chardark", 1280, 720, '000000')
	scaleObject('chardark', 1.75, 1.75)
	setScrollFactor('chardark', 0, 0)
	setProperty("chardark.alpha", 0)
	addLuaSprite('chardark')

	makeLuaSprite('topdark', folder..'Top Darkness', -1400, -1000)
	scaleObject('topdark', 0.75, 0.75)
	setScrollFactor('topdark', 0.8, 0.8)
	addLuaSprite('topdark', true)
	setBlendMode("topdark", 'overlay')

	makeLuaSprite('vignette', 'vignette', 0, 0)
	setObjectCamera("vignette", 'hud')
	setProperty('vignette.alpha', 0.75)
	screenCenter('vignette')
	addLuaSprite('vignette')

	makeLuaSprite('black', '', -500,-300)
	makeGraphic("black", 1280, 720, '000000')
	scaleObject('black', 1.1, 1.1)
	screenCenter('black')
	setScrollFactor('black', 0, 0)
	setObjectCamera('black', 'hud')
	setProperty("black.alpha", 0)
	addLuaSprite('black')
end
function onDestory()
	setPropertyFromClass("ClientPrefs", "shaders", backupShader)
	runHaxeCode([[
        FlxG.signals.gameResized.remove(fixShaderCoordFix);
    ]])
end

function onCreatePost()
	onPerspectiveCreate()
end

function onUpdatePost(elapsed)
	if not inGameOver then
		onPerspectiveUpdate()
		setProperty('ventfan1.angle', getProperty('ventfan1.angle') + elapsed*500)
		setProperty('ventfan2.angle', getProperty('ventfan2.angle') + elapsed*450)
	end
end

function onBeatHit()
	playAnim('chars', 'bop'..(curBeat%2==0 and '1' or '2'), true)
	if curBeat % 2 == 0 then
		playAnim('roy', 'bop', true)
		playAnim('feizao', 'bop', true)
		playAnim('hazzy', 'bop', true)
		playAnim('fox', 'bop', true)
		playAnim('thegirl', 'bop', true)
	end
	if curBeat % 64 == 0 then -- charbackdoor
		local randomIndex = curBeat % 128 == 0 and 0 or 1
		setProperty('charbackdoor.animation.frameIndex', randomIndex)
		doTweenX('charbackdoor', 'charbackdoor', -210 , 1, 'sineOut')
	end
	if curBeat % 64 == 2 then
		doTweenX('ldoor', 'ldoor', -375 -175, 0.5, 'sineinOut')
		doTweenX('rdoor', 'rdoor', -165 +175, 0.5, 'sineinOut')
	end
	if curBeat % 64 == 10 then
		doTweenX('ldoor', 'ldoor', -375, 0.5, 'sineinOut')
		doTweenX('rdoor', 'rdoor', -165, 0.5, 'sineinOut')
	end
	if curBeat % 64 == 14 then -- charbackdoor
		doTweenX('charbackdoor', 'charbackdoor', -210 + 400, 1, 'sineIn')
	end
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

function shaderCoordFix()
    runHaxeCode([[
        resetCamCache = function(?spr) {
            if (spr == null || spr.filters == null) return;
            spr.__cacheBitmap = null;
            spr.__cacheBitmapData = null;
        }
        
        fixShaderCoordFix = function(?_) {
            resetCamCache(game.camGame.flashSprite);
            resetCamCache(game.camHUD.flashSprite);
            resetCamCache(game.camOther.flashSprite);
        }
    
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
    ]])
end