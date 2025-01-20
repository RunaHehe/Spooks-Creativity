local folder = "roblox/kaiju/"
local crystalPath = folder .. "crystal/crystals/"
local repositionX = -1200
local repositionY = -1000

local repositionCryX = -1200
local repositionCryY = -1200

--MORAL = Create animated sprite during playing will not lag the game!!! so don't prepare the sprite in the beginning or it will lag a lot
--MORAL = A lot of shaders will lag the PC even though The computer is very powerful.

factoryGroup = { "ground", "backRoom", "wall", "fans", "topGround", "crates", "crystal" }
crystalGroup = {
	"cryGround", "cryMiniCrystalBack", "cryBackPillar", "cryPillar",
	"cryHill1", "cryHill2", "cryHill3", "cryHill4", "cryHill5",
	"cryBackHill1", "cryBackHill2", "cryBackHill3", "cryBackHill4", "cryBackHill5",
	"cryHillWall1", "cryHillWall2", "cryHillWall3",
	"cryWallFarRight", "cryWallFarLeft", "cryWallNear",
	"lightning1", "lightning2", "lightning3",
	"cryBackRed", "cryRed",
	"furryGas",
	"cryRoof"
}
allCrystals = {}

crystals = {}
crystalsGlow = {}
crystalsAttack = {}

local cryWallPos = { -259.5, 1185 } --real right wall x is 39
local cryWallWidth = { 280, 1146 }

local bgColor = "003c61"
local bgAlpha = 0.03
camShake = 0
shaky = 0

local crystalBeat = true
local mechanic = true

shaderDropAlpha = 1
shaderDropDis = 0
downGlowAlpha = 1;

colorHue = 0;
colorBrightness = 0;
colorSaturation = 0;
shaderBlur = 0;
blurShake = 0;

shaderWaveX = 0
shaderWaveY = 0
shaderWaveXTime = 0
shaderWaveYTime = 0

furryGasMode = false

shaderEnable = true
function onCreate()
	luaDebugMode = true
	setProperty("cpuControlled", false)
end

function onCreatePost()

	precacheImage(crystalPath.."crystalHalf1"); precacheImage(crystalPath.."crystalHalf2"); precacheImage(crystalPath.."crystalHalf3"); initLuaShader('dropShadow1')

	if shaderEnable then
		initLuaShader('demon_blur'); initLuaShader('bloom1'); initLuaShader('radialBlur'); initLuaShader('wavy')
		makeLuaSprite("bloom1Shader", "", 0, 0)
		makeLuaSprite("blurShader", "", 0, 0)
		makeLuaSprite("wavyShader", "", 0, 0)
		initLuaShader("dropShadow1", "", 0, 0)
	end
	addHaxeLibrary("FlxSpriteUtil", "flixel.util")
	addHaxeLibrary("FlxTrail", "flixel.addons.effects")
	addHaxeLibrary("Playstate", "")

	--FACTORY STAGE
	makeSprite("ground", folder .. "factory/Ground", repositionX - 100, repositionY + 1100)

	makeSprite("backRoom", folder .. "factory/FactoryBackRoom", repositionX + 660, repositionY + 1050, 1.05, 0.95)

	makeSprite("wall", folder .. "factory/FactoryWall", repositionX, repositionY, 0.95, 0.95)

	makeAnSprite("fans", folder .. "factory/FactoryFan", repositionX + 1500, repositionY + 835, 0.95, 0.95, 3, 3)
	addAnimationByPrefix("fans", "idle", "FactoryVents0", 24)
	playAnim("fans", "idle")
	setProperty("fans.antialiasing", getPropertyFromClass('ClientPrefs', "globalAntialiasing"))

	makeSprite("topGround", folder .. "factory/FactoryFloor2", repositionX + 1145, repositionY + 830, 0.965, 0.965)

	makeSprite("crates", folder .. "factory/FactoryFrontCrates", repositionX + 1880, repositionY + 1140, 0.975, 0.975)

	makeSprite("crystal", folder .. "factory/Crystals", repositionX - 50, repositionY + 1020, 0.985, 0.985)
	--

	--CRYSTAL STAGE
	makeSprite("cryGround", folder .. "crystal/CryGround", repositionCryX + 200, repositionCryY + 600, 1, 1)
	makeSprite("cryWallFarRight", folder .. "crystal/CryWallsFarRight", 39, -901.5, 1, 1)
	makeSprite("cryWallFarLeft", folder .. "crystal/CryWallsFarLeft", -259.5, -796, 1, 1)
	makeSprite("cryWallNear", folder .. "crystal/CryWallsNear", -1028, -1099.5, 1, 1)

	makeSprite("cryRoof", folder .. "crystal/CryRoof", -1073.5, -1444, 1, 1)

	makeSprite("cryBackRed", folder .. "crystal/CryRed2", -91.5, -109.5, 1, 1, 1)

	createCrystalByOne("crystalBack1", crystalPath .. "crystal5", "Cry5Come", 106, -195, 0.33, 10.1, false) --back2

	createCrystalByOne("crystalBack2", crystalPath .. "crystal2", "Cry2Come", 281.5, -150, 1.02, -11.466667, false) --back5

	makeLuaSprite("lightning1", "", -700, -700)
	makeGraphic("lightning1", 1500, 1200, bgColor)
	scaleObject("lightning1", 2, 2)
	setScrollFactor("lightning1", 0, 0)
	setProperty("lightning1.alpha", bgAlpha)
	addLuaSprite("lightning1", false)

	makeSprite("cryBackHill1", folder .. "crystal/Hills/HillBack1", -410, -133.5, 0.94, 0.98, 1)
	makeSprite("cryBackHill2", folder .. "crystal/Hills/HillBack2", -410, -133.5, 0.92, 0.97, 1)
	makeSprite("cryBackHill3", folder .. "crystal/Hills/HillBack3", -410, -133.5, 0.91, 0.97, 1)
	makeSprite("cryBackHill4", folder .. "crystal/Hills/HillBack4", -410, -133.5, 0.91, 0.97, 1)
	makeSprite("cryBackHill5", folder .. "crystal/Hills/HillBack5", -410, -133.5, 0.9, 0.96, 1)

	setScrollFactor("crystalBack1", getProperty("cryBackHill2.scrollFactor.x"), getProperty("cryBackHill2.scrollFactor.y"))
	setScrollFactor("crystalBack2", getProperty("cryBackHill5.scrollFactor.x"), getProperty("cryBackHill5.scrollFactor.y"))

	createCrystalByOne("crystalWall1", crystalPath .. "crystal2", "Cry2Come", -455.5, -300, 1.8, 99.0666667, false)
	makeSprite("cryHillWall1", folder .. "crystal/Hills/WallHill1", -598.5, -372.5, 1, 1, 1)

	makeSprite("cryBackPillar", folder .. "crystal/BackPillar", -628.5, -1271, 1, 1, 0.9025)

	createCrystalByOne("crystalWall2", crystalPath .. "crystal3", "Cry3Come", 1500, -371.5, 1.7, -88.766667, false)
	makeSprite("cryHillWall2", folder .. "crystal/Hills/WallHill2", 1788, -345.5, 1, 1, 1)
	createCrystalByOne("crystalWall3", crystalPath .. "crystal4", "Cry4Come", 380.5, -908, 1.7, 166.033334, false)
	makeSprite("cryHillWall3", folder .. "crystal/Hills/WallHill3", 253.5, -964.5, 1, 1, 1)
	setProperty("cryHillWall3.angle", 180)

	makeLuaSprite("lightning2", "", -700, -700)
	makeGraphic("lightning2", 1500, 1200, bgColor)
	scaleObject("lightning2", 2, 2)
	setScrollFactor("lightning2", 0, 0)

	setProperty("lightning2.alpha", bgAlpha)
	addLuaSprite("lightning2", false)

	makeSprite("cryRed", folder .. "crystal/CryRed", -458.5, 233, 1, 1, 1)

	makeSprite("cryHill1", folder .. "crystal/Hills/HillFront1", -974.5, 124.5, 0.98, 0.99, 1.01) --cry1
	makeSprite("cryHill2", folder .. "crystal/Hills/HillFront2", -974.5, 124.5, 0.98, 0.99, 1.01) --cry3
	makeSprite("cryHill3", folder .. "crystal/Hills/HillFront3", -974.5, 124.5, 0.96, 0.99, 1.01) --cry5
	makeSprite("cryHill4", folder .. "crystal/Hills/HillFront4", -974.5, 124.5, 0.94, 0.98, 1.01) --cry4
	makeSprite("cryHill5", folder .. "crystal/Hills/HillFront5", -974.5, 124.5, 0.96, 0.98, 1.01) --cry2

	createCrystals(crystalPath)
	table.insert(crystals, table.maxn(crystals) + 1, { "crystalBack1", "crystalBack1beat" })
	table.insert(crystals, table.maxn(crystals) + 1, { "crystalBack2", "crystalBack2beat" })
	table.insert(crystals, table.maxn(crystals) + 1, { "crystalWall1", "crystalWall1beat" })
	table.insert(crystals, table.maxn(crystals) + 1, { "crystalWall2", "crystalWall2beat" })
	table.insert(crystals, table.maxn(crystals) + 1, { "crystalWall3", "crystalWall3beat" })

	makeLuaSprite("lightning3", "", -700, -700)
	makeGraphic("lightning3", 1500, 1200, bgColor)
	scaleObject("lightning3", 2, 2)
	setScrollFactor("lightning3", 0, 0)
	setProperty("lightning3.alpha", bgAlpha)
	addLuaSprite("lightning3", false)

	createGlowForCrystals() 

	makeAnimatedLuaSprite("furryGas", folder.."crystal/FurryGas", 304, 334.5)
	addAnimationByIndicesLoop("furryGas", "stand", "FurryGas0", 0, 24)
	addAnimationByIndices("furryGas", "fall", "FurryGas0", betweenNumber(1, 32), 34)
	addAnimationByIndicesLoop("furryGas", "gasOut", "FurryGas0", betweenNumber(33, 48), 24)
	addAnimationByIndices("furryGas", "gasEnd", "FurryGas0",betweenNumber(49, 54), 24)
	playAnim("furryGas", "stand", true)
	scaleObject("furryGas", 1.6675, 1.6675)
	addLuaSprite("furryGas")

	makeSprite("cryPillar", folder .. "crystal/GiantPillar", 1575.5, -1129, 1, 1, 0.9325)

	makeSprite("darkVignette", folder .. "crystal/Vignette", 0, 0, 0, 0, 0.361, true)
	setObjectCamera("darkVignette", "hud")
	screenCenter("darkVignette")
	setProperty('darkVignette.alpha', 0)

	makeLuaSprite("downGlow", folder .. "crystal/blueGlowingDown", 0, 0)
	scaleObject("downGlow", 1, 1)
	setScrollFactor("downGlow", 0, 0)
	setObjectCamera("downGlow", "hud")
	addLuaSprite("downGlow", true)
	setProperty("downGlow.alpha", 0)

	makeLuaSprite("crystalEffect", "", 0, 0)
	makeGraphic("crystalEffect", 1300, 1000, "03FFFF")
	setProperty("crystalEffect" .. ".alpha", 0)
	addLuaSprite("crystalEffect", false)
	setObjectCamera("crystalEffect", "hud")
	screenCenter('crystalEffect')
	
	setBlendMode("crystalEffect", "multiply")

	makeLuaSprite("gasEffect", "", 0, 0)
	makeGraphic("gasEffect", 1300, 1000, "ff6efa")
	setProperty("gasEffect" .. ".alpha", 0)
	addLuaSprite("gasEffect", false)
	setObjectCamera("gasEffect", "hud")
	screenCenter('gasEffect')
	--

	addHaxeLibrary('ColorSwap')
	addHaxeLibrary('NumTween', 'flixel.tweens.misc')

	if shaderEnable then
		setSpriteShader('bloom1Shader', 'demon_blur')
		setSpriteShader('blurShader', 'radialBlur')
		--setSpriteShader('wavyShader', 'wavy')
		setShaderFloat("blurShader", "blurWidth", 0)
		setShaderFloat("blurShader", "cx", 0.5)
		setShaderFloat("blurShader", "cy", 0.5)

		setShaderFloat("bloom1Shader", "u_size", 5)
		setShaderFloat("bloom1Shader", "u_alpha", 0.05)

		shaderWaveX = 100000
		shaderWaveY = 100000
		shaderWaveXTime = 100000
		shaderWaveYTime = 100000

		setSpriteShader("boyfriend", "dropShadow1")
        setShaderFloat("boyfriend", "_alpha", 0.8)
        setShaderFloat("boyfriend", "_disx", 100)
        setShaderFloat("boyfriend", "_disy", 15)
        setShaderBool("boyfriend", "inner", true)
        setShaderBool("boyfriend", "inverted", true)

		setSpriteShader("dad", "dropShadow1")
        setShaderFloat("dad", "_alpha", 0.8)
        setShaderFloat("dad", "_disx", -10)
        setShaderFloat("dad", "_disy", 15)
        setShaderBool("dad", "inner", true)
        setShaderBool("dad", "inverted", true)
	end


	for i = 1, #factoryGroup do
		setProperty(factoryGroup[i] .. ".visible", true)
	end

	for i = 1, #crystalGroup do
		setProperty(crystalGroup[i] .. ".visible", false)
	end

	setProperty("dad.x", getProperty("DAD_X"))
	setProperty("dad.y", getProperty("DAD_Y"))
	setProperty("boyfriend.x", getProperty("BF_X"))
	setProperty("boyfriend.y", getProperty("BF_Y"))

	getAllCrystals()
	setShader()

	--showCrystalStage()
	--setProperty("boyfriend.visible", false)
	--setProperty("dad.visible", false)
end

function onSongStart()
	setObjectOrder("crystalEffect", getObjectOrder("notes") + 5)
	setObjectOrder("gasEffect", getObjectOrder("crystalEffect") - 1)
end

function setShader()
	if shaderEnable then
		runHaxeCode([[
			game.camGame.setFilters([
				new ShaderFilter(game.getLuaObject("bloom1Shader").shader)
			]);

			game.camHUD.setFilters([
				new ShaderFilter(game.getLuaObject("blurShader").shader)
			]);
		]])
	end
end

local crystalPlace = false
function showCrystalStage()
	crystalPlace = true
	for i = 1, #factoryGroup do
		setProperty(factoryGroup[i] .. ".visible", false)
	end

	for i = 1, #crystalGroup do
		setProperty(crystalGroup[i] .. ".visible", true)
	end

	setProperty("BF_Y", getProperty("BF_Y") + 105)
	setProperty("BF_X", getProperty("BF_X") - 100)

	setProperty("DAD_Y", getProperty("DAD_Y") + 100)

	setProperty("boyfriend.y", getProperty("BF_Y"))
	setProperty("boyfriend.x", getProperty("BF_X"))

	
	setProperty("dad.y", getProperty("DAD_Y"))

	setShaderFloat("bloom1Shader", "u_alpha", 0.6)
end

function createGlowForCrystals()
	for i = 1, #crystals do
		local spr = crystals[i][1]
		local tag = "crystalGlow" .. i
		local floorTag = "crystalFloorGlow" .. i

		makeSprite(tag, crystalPath .. "BlueGlow", getProperty(spr .. ".x") - getProperty(spr .. ".width") / 4,
			getProperty(spr .. ".y") - getProperty(spr .. ".height") / 4, 1, 1, 1)
		setGraphicSize(tag, getProperty(spr .. ".width") * 2, getProperty(spr .. ".height") * 1.9)
		setScrollFactor(tag, getProperty(spr .. ".scrollFactor.x"), getProperty(spr .. ".scrollFactor.y"))

		makeSprite(floorTag, crystalPath .. "BlueGlow", 0, 0)
		setGraphicSize(floorTag, getProperty(spr .. ".width") * 1.8, getProperty(spr .. ".height") * 1)
		setScrollFactor(floorTag, getProperty(spr .. ".scrollFactor.x"), getProperty(spr .. ".scrollFactor.y"))

		table.insert(crystalsGlow, #crystalsGlow + 1, { tag, spr, floorTag })
	end
end

function createCrystals(_path)
	local path = _path
	createCrystalByOne("crystal1", path .. "crystal1", "Cry1Come", -515.5, 78.5, 1.65, 5.4, true)
	setScrollFactor("crystal1", 0.98, 0.99)

	createCrystalByOne("crystal2", path .. "crystal2", "Cry2Come", 800, -30, 1.7, 5.5, true)
	setScrollFactor("crystal2", 0.96, 0.98)

	createCrystalByOne("crystal3", path .. "crystal3", "Cry3Come", 370, 65, 1.81, 2.066667, true)
	setScrollFactor("crystal3", 0.98, 0.99)

	createCrystalByOne("crystal4", path .. "crystal4", "Cry4Come", -43.5, -50, 1.37, -9.6666667, true)
	setScrollFactor("crystal4", 0.94, 0.98)

	createCrystalByOne("crystal5", path .. "crystal5", "Cry5Come", 1061.5, 72.5, 1.7, -19.1666667, true)
	setScrollFactor("crystal5", 0.96, 0.99)

end

function createCrystalByOne(_tag, _image, _animName, _x, _y, _scale, _angle, _addToTable) -- LAG PROBLEM
	local tag = _tag
	local tagBeat = _tag .. "beat"

	makeAnimatedLuaSprite(tag, _image, _x, _y)
	if _scale ~= nil then
		scaleObject(tag, _scale, _scale)
	end
	addAnimationByIndices(tag, "ground", _animName, "1", 0)
	addAnimationByPrefix(tag, "growing", _animName, 10, false)
	addAnimationByIndices(tag, "idle", _animName, "60", 0)
	setProperty(tag .. ".angle", _angle)
	playAnim(tag, "idle", true)
	addLuaSprite(tag)
	setProperty(tag .. '.alpha', 0)

	makeAnimatedLuaSprite(tagBeat, _image, _x, _y)
	if _scale ~= nil then
		scaleObject(tagBeat, _scale, _scale)
	end
	addAnimationByIndices(tagBeat, "idle", _animName, "60", 0)
	setProperty(tagBeat .. ".angle", _angle)
	playAnim(tagBeat, "idle", true)
	addLuaSprite(tagBeat)
	setProperty(tagBeat .. '.alpha', 0)

	setSpriteShader(tag, 'bloom1')

	if _addToTable then
		table.insert(crystals, table.maxn(crystals) + 1, { tag, tagBeat })
	end
end

local crystalShowAlpha = 0.8;
function onStepEvent(curStep)
	if curStep == 512 and not crystalPlace then
		showCrystalStage()
	end
	if curStep == 702 then
		playAnim(crystals[1][1], "growing", true, false, 6)
		setProperty(crystals[1][1] .. '.alpha', crystalShowAlpha)

		cameraWatch(-285, 332.5, 1.23, 0.1, 4) -- x y zoom tweenDur duration
	end
	if curStep == 960 then
		doValueTween("downGlowAlping", "downGlowAlpha", 1, 0, 2, "linear")
		cameraWatch(getProperty("boyfriend.x") + 130, getProperty("boyfriend.y") + 110, 0.85, 2, crochet/1000*4 * 8)
	end
	if curSelect == 1088 then 
		playAnim(crystals[2][1], "growing", true, false, 3)
		setProperty(crystals[2][1] .. '.alpha', crystalShowAlpha)
	end
	if curStep == 1216 then
		playAnim(crystals[3][1], "growing", true, false, 3)
		setProperty(crystals[3][1] .. '.alpha', crystalShowAlpha)
		doValueTween("downGlowAlping", "downGlowAlpha", 0, 1, 2, "linear")

	end
	if curStep == 1456 then
		doValueTween("downGlowAlping", "downGlowAlpha", 1, 0, 2, "linear")
	end
	if curStep == 1472 then --change blue to yellow -120
		cameraWatch(562.5, 80, 0.5342, 3, 8) -- x y zoom tweenDur duration

		changeColor(-116,-180 ,1, 4)

		local duration = 4;
		doValueTween("dropShadow1Alpha", "shaderDropAlpha", 1, 0.4, duration, "linear")
		doValueTween("dropShadow1Dis", "shaderDropDis", 0, 15, duration, "linear")

		doTweenAlpha("darkVignette", "darkVignette", 1, duration)
	end
	if curStep == 1592 then
		playAnim("furryGas", "fall", true)
	end
	if curStep == 1600 then
		playAnim("furryGas", "gasOut", true)
		playAnim(crystals[4][1], "growing", true, false, 3)
		setProperty(crystals[4][1] .. '.alpha', crystalShowAlpha)
		furryGasMode = true
	end
	if curStep == 1728 then
		playAnim(crystals[5][1], "growing", true, false, 3)
		setProperty(crystals[5][1] .. '.alpha', crystalShowAlpha)
		playAnim(crystals[8][1], "growing", true, false, 3)
		setProperty(crystals[8][1] .. '.alpha', crystalShowAlpha)
		doValueTween("downGlowAlping", "downGlowAlpha", 0, 1, 2, "linear")
	end
	if curStep == 1984 then
		playAnim(crystals[9][1], "growing", true, false, 3)
		setProperty(crystals[9][1] .. '.alpha', crystalShowAlpha)
	end
	if curStep == 2232 then 
		furryGasMode = false
		playAnim("furryGas", "gasEnd", true)
	end
	if curStep == 2368 then
		cameraWatch(562.5, 80, 0.5342, 3, 8) -- x y zoom tweenDur duration
		playAnim(crystals[6][1], "growing", true, false, 3)
		setProperty(crystals[6][1] .. '.alpha', crystalShowAlpha)

		changeColor(-180,0, 2 , 4)
	end
	if curStep == 2240 then 
		cameraWatch(getProperty("boyfriend.x") + 130, getProperty("boyfriend.y") + 110, 0.85, 2, crochet/1000*4 * 8)
	end
	if curStep == 2624 then
		playAnim(crystals[7][1], "growing", true, false, 3)
		setProperty(crystals[7][1] .. '.alpha', crystalShowAlpha)
	end
	if curStep == 2752 then
		playAnim(crystals[10][1], "growing", true, false, 3)
		setProperty(crystals[10][1] .. '.alpha', crystalShowAlpha)
		cameraWatch(460, -717.5, 0.91779, 2, 6) -- x y zoom tweenDur duration
	end
	if curStep == 2880 then 
		cameraWatch(getProperty("boyfriend.x") + 130, getProperty("boyfriend.y") + 110, 0.85, 2, crochet/1000*4 * 16)
	end
	if curStep % 16 == 0 and crystalBeat then
		for i = 1, #crystals do
			local ogSpr = crystals[i][1]
			local beatSpr = crystals[i][2]
			if getProperty(ogSpr .. '.animation.curAnim.name') == "idle" and getProperty(ogSpr .. '.alpha') >= 0.5 then
				setProperty(beatSpr .. ".scale.x", getProperty(ogSpr .. ".scale.x"))
				setProperty(beatSpr .. ".scale.y", getProperty(ogSpr .. ".scale.y"))
				setProperty(beatSpr .. ".alpha", 0.9)
				setScrollFactor(beatSpr, getProperty(ogSpr .. ".scrollFactor.x"), getProperty(ogSpr .. ".scrollFactor.y"))

				doTweenX(beatSpr .. "zoomX", beatSpr .. ".scale", getProperty(beatSpr .. ".scale.x") * 1.4, 1, "quadOut")
				doTweenY(beatSpr .. "zoomY", beatSpr .. ".scale", getProperty(beatSpr .. ".scale.y") * 1.4, 1, "quadOut")
				doTweenAlpha(beatSpr .. "alpha", beatSpr, 0, 1, "quadOut")
			end
		end
	end

end

function onEvent(tag, value1, value2)
	if tag == "Change Character" then 
		local isDad = false
		if tostring(value1) == "dad" or tostring(value1) == "opponent" or tostring(value1) == "0" then isDad = true end

		if isDad then 
			runHaxeCode([[
				game.dadGroup.clear();
				game.dadGroup.add(game.dad);
			]])
		else 
			runHaxeCode([[
				game.boyfriendGroup.clear();
				game.boyfriendGroup.add(game.boyfriend);
			]])
		end
		

		if isDad then
			setSpriteShader('dad', 'dropShadow1')
			setProperty("dad.y", getProperty("DAD_Y"))
		else
			setSpriteShader('boyfriend', 'dropShadow1')
			setProperty("boyfriend.y", getProperty("BF_Y"))
			setProperty("boyfriend.x", getProperty("BF_X"))
		end
		
	end	
end
local isCamWatch, isCamWatchPrev = false;
camWatchX, camWatchY, camWatchZoom = 0;
function cameraWatch(_x, _y, _zoom, _tweenDur, _duration)
	cancelTweenValue("camWatchX") --CANCELTWEENS
	cancelTweenValue("camWatchY")
	cancelTweenValue("camWatchZ")

	camWatchX = getProperty("camFollowPos.x")
	camWatchY = getProperty("camFollowPos.y")
	camWatchZoom = getProperty("camGame.zoom")

	doValueTween("camWatchX", "camWatchX", getProperty("camFollowPos.x"), _x, _tweenDur, "quadInOut")
	doValueTween("camWatchY", "camWatchY", getProperty("camFollowPos.y"), _y, _tweenDur, "quadInOut")
	doValueTween("camWatchZ", "camWatchZoom", getProperty("camGame.zoom"), _zoom, _tweenDur, "quadInOut")
	isCamWatch = true;

	cancelTimer("endCameraWatch")
	runTimer("endCameraWatch", _duration)
end

function getAllCrystals()
	local tablet = {} --allCrystals
	for i = 1, #crystals do
		for a = 1, #crystals[i] do
			table.insert(tablet, crystals[i][a])
		end
	end

	for i = 1, #crystalsGlow do
		for a = 1, #crystalsGlow[i] do
			local alreadyIn = false
			for check = 1, #tablet do
				if crystalsGlow[i][a] == tablet[check] then
					alreadyIn = true;
					break;
				end
			end
			if not alreadyIn then
				table.insert(tablet, crystalsGlow[i][a])
			end
		end
	end

	for i = 1, #crystalsAttack do
		local alreadyIn = false
		for check = 1, #tablet do
			if crystalsAttack[i][1] == tablet[check] then
				alreadyIn = true;
				break;
			end
		end
		if not alreadyIn then
			table.insert(tablet, crystalsAttack[i][1])
		end
	end

	allCrystals = tablet

	--makeLuaText("aaaa", "", 800, 100, 100)
	--addLuaText("aaaa")
	--setTextString("aaaa", )
end

local tweenDur = 0
function changeColor(_color, _saturation, _brightness, _duration)
	cancelTimer("endChangeBrightness")
	tweenDur = _duration;
	doValueTween("changeColorHue", "colorHue", colorHue, _color, _duration, "linear")
	doValueTween("changeColorBright1", "colorBrightness", colorBrightness, _brightness, _duration / 2, "linear")
	doValueTween("changeColorSat", "colorSaturation", colorSaturation, _saturation, _duration, "linear")
	runTimer("endChangeBrightness", _duration / 2)
end

local eaaa = 0
local glowOffset = {
	["crystal1"] = { -10, 0 },
	["crystal2"] = { -8, -8 },
	["crystal3"] = { 0, -13 },
	["crystal4"] = { 2, 0 },
	["crystal5"] = { 18, -15 },
	["crystalBack1"] = { 0, -20 },
	["crystalBack2"] = { 0, -30 },
	["crystalWall1"] = { -130, -100 },
	["crystalWall2"] = { 160, -140 },
	["crystalWall3"] = { 0, -500 },
}
function onUpdatePost(elapsed)
	eaaa = eaaa + elapsed * 1

	if isCamWatch then
		isCamWatchPrev = true;
		setProperty("camFollowPos.x", camWatchX)
		setProperty("camFollowPos.y", camWatchY)
		setProperty("camGame.zoom", camWatchZoom)
	else
		if isCamWatchPrev then

		end
		isCamWatchPrev = false;
	end

	crystalAttacking()
	--crystalAttackFunction()
	updateColor()
	
	
	
	if furryGasMode then  --1600
		if curStep == 1 then 
			shaderWaveXTime = 100
			shaderWaveYTime = 100
		end
		shaderWaveX = lerp(shaderWaveX, 70  + (math.sin(eaaa*1) * 50), elapsed*2)
		shaderWaveY = lerp(shaderWaveY, 50  + (math.sin(eaaa*0.8) * 70) , elapsed*2)
		shaderWaveXTime = lerp(shaderWaveXTime, 100 , elapsed*2)
		shaderWaveYTime = lerp(shaderWaveYTime, 100 , elapsed*2)
		shaderBlur = math.sin(eaaa*0.6)*1
		setProperty("gasEffect.alpha", lerp(getProperty("gasEffect.alpha"), 0.4 + (math.sin(eaaa)*0.2) , elapsed))
	else 
		shaderWaveX = lerp(shaderWaveX, 100000 , elapsed)
		shaderWaveY = lerp(shaderWaveY, 100000 , elapsed)
		shaderWaveXTime = lerp(shaderWaveXTime, 100000 , elapsed)
		shaderWaveYTime = lerp(shaderWaveYTime, 100000 , elapsed)
		setProperty("gasEffect.alpha", lerp(getProperty("gasEffect.alpha"), 0 , elapsed))
	end
	
	if shaderEnable then
		--setShaderFloat("blurShader", "amount", tonumber(shaderBlur))
		blurShake = lerp(blurShake, 0 ,elapsed*8)
		setShaderFloat("blurShader", "blurWidth", tonumber(shaderBlur + (blurShake/10)) / -4)
		setShaderFloat("blurShader", "cx", 0.5 + math.sin(eaaa)*0.1)
		setShaderFloat("blurShader", "cy", 0.5 + math.cos(eaaa)*0.1)

		setShaderFloat("boyfriend", "_alpha", shaderDropAlpha)
		setShaderFloat("dad", "_alpha", shaderDropAlpha)

		setShaderFloat("boyfriend", "_disx", shaderDropDis)
		setShaderFloat("boyfriend", "_disy", shaderDropDis)

		setShaderFloat("dad", "_disx", shaderDropDis)
		setShaderFloat("dad", "_disy", shaderDropDis)


	end
	

	setProperty("cryWallFarLeft.scale.x", 1 + (getProperty("camFollowPos.x") - 385) * 0.0006)
	setProperty("cryWallFarRight.scale.x", 1 - ((getProperty("camFollowPos.x") - 385) * 0.00006))
	setProperty("cryWallFarLeft.x", cryWallPos[1])
	setProperty("cryWallFarRight.x", cryWallPos[2] - getProperty("cryWallFarRight.width"))

	for i = 1, #crystalsGlow do
		local spr = crystalsGlow[i][1]
		local target = crystalsGlow[i][2]
		local floorSpr = crystalsGlow[i][3]

		local midY = getProperty(target .. ".y") + getProperty(target .. ".height") / 2 - getProperty(spr .. ".height") / 2
		local midX = getProperty(target .. ".x") + getProperty(target .. ".width") / 2 - getProperty(spr .. ".width") / 2
		local bottomY = getProperty(target .. ".y") + getProperty(target .. ".height") - getProperty(floorSpr .. ".height") / 2

		local scaleMultiply = 1
		if getProperty(target .. ".animation.curAnim.name") == "growing" then
			addShake(0.0004)
			scaleMultiply = (getProperty(target .. ".animation.curAnim.curFrame") / 60)

			if not (string.find(string.lower(target), "wall")) then
				local randomX = getRandomFloat(-(getProperty(target .. ".width") / 1.9), getProperty(target .. ".width") / 1.9)
				local randomY = getRandomFloat(-30, 30)
				local particleMidX = getProperty(target .. ".x") + getProperty(target .. ".width") / 2
				local particleY = getProperty(target .. ".y") + getProperty(target .. ".height")

				local color = "1a3c52"
				if curStep >= 2368 then --2368
					color = "521a1a"
				elseif curStep >= 1472 then --2368
					color = "FFFFFF"
				end
				createParticle(particleMidX + randomX, particleY + randomY, 15, color, 1)
			end
		elseif getProperty(target .. ".animation.curAnim.name") == "ground" or getProperty(target .. ".alpha") == 0 then
			scaleMultiply = 0.01
		end

		setGraphicSize(spr, (getProperty(target .. ".width") * 1.6) * scaleMultiply,
			(getProperty(target .. ".height") * 1.5) * scaleMultiply)
		setGraphicSize(floorSpr, (getProperty(target .. ".width") * 1.6) * scaleMultiply,
			(getProperty(target .. ".height") * 0.4) * scaleMultiply)

		local multipl = (shaderDropDis / 15 * 1.4)
		setProperty(spr .. '.alpha',
			((scaleMultiply * 0.4 / 2 * multipl) + (math.sin(eaaa + i) * (scaleMultiply * 0.4 / 2 * multipl))))
		setProperty(spr .. ".x", midX)
		setProperty(spr .. ".y", midY)
		setProperty(spr .. ".angle", getProperty(target .. ".angle"))

		setProperty(floorSpr .. '.alpha', scaleMultiply * 0.5)
		setProperty(floorSpr .. ".x", midX + glowOffset[target][1])
		setProperty(floorSpr .. ".y", bottomY + glowOffset[target][2])
		setProperty(floorSpr .. ".angle", getProperty(target .. ".angle"))

		setProperty(spr .. ".angle", getProperty(target .. ".angle"))

		if getProperty(target .. ".animation.curAnim.name") == "growing" and
			getProperty(target .. ".animation.curAnim.curFrame") >= 60 then
			playAnim(target, "idle", true)
			--new(Target:FlxSprite, ?Graphic:Null<FlxGraphicAsset>, Length:Int = 10, Delay:Int = 3, Alpha:Float = 0.4, Diff:Float = 0.05)
		end
	end

	if not inGameOver then
		local amountgus = 0
		for i = 1, #crystals do
			if getProperty(crystals[i][1] .. ".alpha") > 0.5 then
				amountgus = amountgus + 1
			end
		end
		local percent = amountgus / #crystals
		setProperty("downGlow.alpha", ((percent / 2) + ((math.sin(eaaa * 3) * percent) / 2)) * downGlowAlpha * 0.5)
		if getRandomBool((percent * 12)) then
			local color = "00FFFF"
			if curStep >= 2368 then
				color = "FF0000"
			elseif curStep >= 1472 then
				color = "FFFFFF"
			end
			createParticle(getRandomFloat(0, 1280), 730, 15, color, 0.7 * downGlowAlpha, "camHUD", 2, -200)
		end
		shakeFunction()
	end
	--setShader()
end

function updateColor()
	local crystalsIntoString = table.concat(allCrystals, '", "')
	runHaxeCode([[
		var duration = 4;
		var crystals = [
			"]] .. crystalsIntoString .. [["
		];
		var colorSwap = new ColorSwap();
		game.getLuaObject("downGlow").shader = colorSwap.shader;
		game.getLuaObject("crystalEffect").shader = colorSwap.shader;
		for (i in 0...crystals.length){
			game.getLuaObject(crystals[i]).shader = colorSwap.shader;
		}

		colorSwap.hue = ]] .. colorHue .. [[ / 360;
		colorSwap.brightness = ]] .. colorBrightness .. [[ / 360;
		colorSwap.saturation = ]] .. colorSaturation .. [[ / 360;

		]])
end

local particleId = 0
function createParticle(_x, _y, _size, _color, _alpha, _camera, _dur, _yDis)
	particleId = particleId + 1

	local tag = "particle" .. particleId
	makeLuaSprite(tag, "", _x - (_size / 2), _y - (_size / 2))
	makeGraphic(tag, _size, _size, _color)
	setScrollFactor(tag, 1, 1)
	setProperty(tag .. ".alpha", _alpha)
	addLuaSprite(tag, false)
	local duration = 1
	local yDis = -40;
	if _dur ~= nil then
		duration = _dur
	end
	if _yDis ~= nil then
		yDis = _yDis
	end
	doTweenAlpha(tag, tag, 0, duration)
	doTweenY("partYy" .. particleId, tag, getProperty(tag .. ".y") + yDis, duration, "quadOut")
	if _camera ~= nil then
		setObjectCamera(tag, _camera)
	end
end

countAttackCry = 0
local attDirection2 = {
	{270},
	{0},
	{180},
	{90}
}
local crystalOffset = {
	{0, 0},
	{0, 8},
	{0, 43}
}
function createAttackCrystal(noteID, isGrowing, forceData)
	
	countAttackCry = countAttackCry + 1
	local randomCrystal = (forceData or (countAttackCry % 3) + 1)
	local tag = "cryAttack" .. countAttackCry
	local animName = "CrystalAttack" .. tostring(randomCrystal)
	local noteDat = (getPropertyFromGroup("notes", noteID, "noteData") % 4)
	local randans = (attDirection2[noteDat + 1][1] + getRandomFloat(-45, 45)) * (math.pi / 180) 
	local xRange, yRange = 220, 100;
	local _xAddon = math.sin(randans) * xRange 
	local _yAddon =  math.cos(randans) * yRange 
	local _x = ((getProperty("boyfriend.x") ) + getProperty("boyfriend.width") / 4) + 10 + getRandomFloat(-10, 10)
	local _y = ((getProperty("boyfriend.y") ) + getProperty("boyfriend.height") / 8 ) + 60 + getRandomFloat(-5, 5)
	makeAnimatedLuaSprite(tag, crystalPath .. "crystalAttack" .. tostring(randomCrystal), _x, _y)
	addAnimationByIndices(tag, "growing", animName, betweenNumber(0, 23), 35)
	addAnimationByIndices(tag, "destroyed", animName, betweenNumber(24, 48), 24)
	addAnimationByIndices(tag, "idle", animName, "23", 0)
	scaleObject(tag, 1.9, 1.9)
	setProperty(tag .. ".x", (getProperty(tag .. ".x")) + _xAddon + crystalOffset[randomCrystal][1])
	setProperty(tag .. ".y", (getProperty(tag .. ".y")) + _yAddon + crystalOffset[randomCrystal][2])
	local inFront = (getProperty(tag..".y") + getProperty(tag..".height") - 5) > (getProperty("boyfriend.y") + getProperty("boyfriend.height")) or noteDat == 1 or _yAddon > 2
	addLuaSprite(tag, inFront)
	playAnim(tag, "growing", true)
	if inFront then 
		setObjectOrder(tag, getObjectOrder("boyfriendGroup") + 10)
	end
	
	if not isGrowing then
		setProperty(tag .. '.alpha', 0) --- on ground
	end

	local _tag = tag
	table.insert(crystalsAttack, { 
		tag = _tag,
		strumTime = getPropertyFromGroup("notes", noteID, "strumTime"),
		noteData = getPropertyFromGroup("notes", noteID, "noteData"),
		destroyed = false,
		part = randomCrystal,
		isFront = inFront,
		spawned = isGrowing,
		duration = 0, -- how long does the crystal idling?
		noteID = getPropertyFromGroup("notes", noteID, "ID"),
		deleted = false
	})

	runHaxeCode([[
		var colorSwap = new ColorSwap();
		game.getLuaObject("]]..tag..[[").shader = colorSwap.shader;
		
		colorSwap.hue = ]] .. colorHue .. [[ / 360;
		colorSwap.brightness = ]] .. colorBrightness .. [[ / 360;
		colorSwap.saturation = ]] .. colorSaturation .. [[ / 360;
	]])

end

function crystalAttacking()
	local amountOfActiveCrystal = 0
	for cry = 1, #crystalsAttack do
		local crystal = crystalsAttack[cry]
		if crystal.deleted then goto continue end
		local noteID = 1;
		for note = 0, getProperty("notes.length")-1 do 
			if getPropertyFromGroup("notes", note, "ID") == crystal.noteID then 
				noteID = note;
				break;
			end
		end
		
		if (getPropertyFromGroup("notes", noteID, "strumTime") - getSongPosition()) < 1000 and not crystal.isGrowing then 
			playAnim(crystal.tag, "growing", true)
			setProperty(crystal.tag .. '.alpha', 1)
			crystal.isGrowing = true
		elseif crystal.isGrowing then 
			crystal.duration = crystal.duration + getPropertyFromClass("flixel.FlxG", "elapsed")
		end

		if crystal.duration >= 10 and not crystal.destroyed and getProperty(crystal.tag .. ".animation.curAnim.name") ~= "destroyed" then 
			crystal.destroyed = true
			playAnim(crystal.tag, "growing", true, true)
		elseif crystal.duration >= 2 and not crystal.destroyed and getProperty(crystal.tag .. ".animation.curAnim.name") ~= "destroyed" then 
			amountOfActiveCrystal = amountOfActiveCrystal + 1
			addHealth(-0.000000001 * getPropertyFromClass("flixel.FlxG", "elapsed"))
		end

		if crystal.duration >= 10.6  or (getProperty(crystal.tag .. ".animation.curAnim.name") == "destroyed" and getProperty(crystal.tag .. ".animation.finished")) then 
			removeLuaSprite(crystal.tag)
			crystal.deleted = true
		end
		::continue::
	end
	local preecent = amountOfActiveCrystal/5
	if preecent > 1 then preecent = 1 end
	local effAlpha = lerp(getProperty("crystalEffect.alpha") , preecent * 0.85, getPropertyFromClass("flixel.FlxG", "elapsed") * 0.6)
	setProperty("crystalEffect.alpha", effAlpha)
	if not furryGasMode then 
		shaderBlur = lerp(shaderBlur , preecent * 2, getPropertyFromClass("flixel.FlxG", "elapsed") * 1)
	end
	
end

function onSpawnNote(noteID, noteData, noteType, isSus)
	if noteType == "Alt Animation" and not isSus then 
		createAttackCrystal(noteID, false)
	end
end

function crystalAttackFunction()
	local amountOfActiveCrystal = 0
	for i = 1, #crystalsAttack do
		local spr = crystalsAttack[i][1]

		local strumTime = crystalsAttack[i][2].strumTime
		local noteData = crystalsAttack[i][2].noteData
		local isDestroy = crystalsAttack[i][2].destroyed

		local noteNear = false
		if not isDestroy then
			for i = 0, getProperty("notes.length") - 1 do
				if getPropertyFromGroup("notes", i, "strumTime") == strumTime and
					getPropertyFromGroup("notes", i, "noteData") == noteData then
					local distance = (getPropertyFromGroup("notes", i, "strumTime") - getSongPosition()) / 1000
					if distance < 1 then
						noteNear = true
						break;
					end
				end
			end
		end
		if noteNear then
			if getProperty(spr .. ".alpha") < 0.5 then
				if getRandomBool(50) and (noteData%4) == 2 then 
					playAnim(spr, "idle", true)
				else 
					playAnim(spr, "growing", true)
				end
				setProperty(spr .. ".alpha", 1)
			end
		end
		if not isDestroy then
			if getProperty(spr .. ".animation.finished") and getProperty(spr .. ".animation.curAnim.name") == "growing" then
				playAnim(spr, "idle", true)
			end
			if getProperty(spr .. ".animation.curAnim.name") == "idle" and getProperty(spr .. ".alpha") > 0.5 then
				crystalsAttack[i][2].duration = crystalsAttack[i][2].duration + getPropertyFromClass("flixel.FlxG", "elapsed")
				if crystalsAttack[i][2].duration > 1 then 
					amountOfActiveCrystal = amountOfActiveCrystal + 1
				end
			end
			if getProperty(spr .. ".animation.curAnim.name") == "growing" and getRandomBool(0) then
				local randomX = getRandomFloat(-(getProperty(spr .. ".width") / 1.9), getProperty(spr .. ".width") / 1.9)
				local randomY = getRandomFloat(-30, 30)
				local particleMidX = getProperty(spr .. ".x") + getProperty(spr .. ".width") / 2
				local particleY = getProperty(spr .. ".y") + getProperty(spr .. ".height")

				local color = "1a3c52"
				if curStep >= 2368 then --2368
					color = "521a1a"
				elseif curStep >= 1472 then --2368
					color = "FFFFFF"
				end
				createParticle(particleMidX + randomX, particleY + randomY, 15, color, 1)
			end
		end
		if isDestroy and luaSpriteExists(spr) then 
			if getProperty(spr .. ".animation.curAnim.name") == "destroyed" and
				(getProperty(spr .. ".animation.finished") or getProperty(spr .. ".animation.curAnim.curFrame") > 47) then
				--removeLuaSprite(spr, true) -- sadly I can't remove the sprite, It will cause problem
				setProperty(spr..".visible", false)
				setProperty(spr..".alpha", 0)
			end
		end
	end
	
	local preecent = amountOfActiveCrystal/5
	if preecent > 1 then preecent = 1 end
	local effAlpha = lerp(getProperty("crystalEffect.alpha") , preecent * 0.85, getPropertyFromClass("flixel.FlxG", "elapsed") * 0.6)
	setProperty("crystalEffect.alpha", effAlpha)
	if not furryGasMode then 
		shaderBlur = lerp(shaderBlur , preecent * 2, getPropertyFromClass("flixel.FlxG", "elapsed") * 1)
	end
	
end

local breakDirection = { -- x, y, (-randomx, +randomx)
		{ -1, 0 },
		{ -1, 1 },
		{ 1, 1 },
		{ 1, 1 }
	}
function breakCrystal(noteID)
	local crystal = nil;
	for i = 1, #crystalsAttack do 
		if getPropertyFromGroup("notes", noteID, "ID") == crystalsAttack[i].noteID then 
			crystal = crystalsAttack[i];
			break;
		end
	end

	if crystal == nil then return end 
	
	local dur = getRandomFloat(0.3, 0.7)
	local sprData = crystal.noteData + 1
	local sprPart = crystal.part
	local sprIsFront = crystal.isFront
	local spr = crystal.tag
	
	particleId = particleId + 1
	local brokeSpr = "brokenPart" .. particleId
	playAnim(spr, "destroyed", true)
	crystal.destroyed = true
	
	
	if not lowQuality then
		makeLuaSprite(brokeSpr, crystalPath.."crystalHalf"..sprPart, getProperty(spr..".x"), getProperty(spr..".y"))
		addLuaSprite(brokeSpr, sprIsFront)
		if sprIsFront then 
			setObjectOrder(brokeSpr, getObjectOrder(spr) + 10)
		end
		setProperty(brokeSpr..".y", getProperty(brokeSpr..".y") - getProperty(spr..".height")/4 )
		scaleObject(brokeSpr, getProperty(spr..".scale.x") * 0.4, getProperty(spr..".scale.y") * 0.4)
		runHaxeCode([[
			var colorSwap = new ColorSwap();
			game.getLuaObject("]]..brokeSpr..[[").shader = colorSwap.shader;

			colorSwap.hue = ]] .. colorHue .. [[ / 360;
			colorSwap.brightness = ]] .. colorBrightness .. [[ / 360;
			colorSwap.saturation = ]] .. colorSaturation .. [[ / 360;
		]])

		--doTweenX(brokeSpr, brokeSpr, getProperty(brokeSpr..".x") + (getRandomFloat(100 * breakDirection[sprData][1], 100 * breakDirection[sprData][2]) * 2), dur, "sineOut")
		--doTweenY(brokeSpr.."y", brokeSpr, getProperty(brokeSpr..".y") + getRandomFloat(-50, -150), dur, "quadOut")
		--doTweenAngle(brokeSpr.."an", brokeSpr, getProperty(brokeSpr..".angle") + (getRandomFloat(-20, 20)*4), dur, "sineOut")
		--doTweenAlpha(brokeSpr.."gone", brokeSpr, 0, dur, "quadIn")

		--more advanced tween vvv
		runHaxeCode([[
			
			var sprTag = "]]..brokeSpr..[[";
			var spr = game.getLuaObject(sprTag, false);
			if (spr == null) return;
			
			var data = ]]..tostring(sprData)..[[;
			
			var xMult = ((data == 2 || data == 3) ? FlxG.random.int(-1, 1, [0]) : (data == 1 ? -1 : 1));
			var vectorX = FlxG.random.float(180, 310);
			var vectorY = -50;
			var duration = FlxG.random.float(0.8, 0.9);
	
			
			FlxTween.tween(spr, {x: spr.x + (vectorX * xMult)}, duration, {ease: FlxEase.sineOut});
		
			new FlxTimer().start(duration/2, function(tmr) {
				FlxTween.tween(spr, {alpha: 0}, duration/2 + 0.2, {ease: FlxEase.quadIn, onComplete: function(twn){
					spr.kill();
					game.remove(spr);
					game.modchartSprites.remove(sprTag);
				}});
			});

			FlxTween.tween(spr, {y: spr.y + (vectorY)}, duration/3, {ease: FlxEase.quadOut, onComplete: function(twn){
				FlxTween.tween(spr, {y: spr.y - (vectorY) + (spr.height / 2) + 20}, duration/2, {ease: FlxEase.quadIn});
			}});
			
			FlxTween.tween(spr, {angle: 90 * xMult}, duration/1.1, {ease: FlxEase.quadOut});
			
			
		]])
	end
	addShake(0.006)
end

function addShake(intensity)
	camShake = camShake + intensity
	blurShake = 1;
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == "Alt Animation" and getPropertyFromGroup("notes", id, "ratingMod") >= 0.75 then 
		breakCrystal(id)
	elseif noteType == "GF Sing" and not isSustainNote then 
		playAnim("boyfriend", "defend", true)
		setProperty("boyfriend.specialAnim", true)
		addShake(0.007)
	end
end

function shakeFunction()
	camShake = lerp(camShake, 0, getPropertyFromClass("flixel.FlxG", "elapsed") * 6)
	local resultShake = camShake + shaky

	canGameX = 0.5 * getPropertyFromClass("flixel.FlxG", "width") * (1 - getProperty("camGame.zoom")) *
		getPropertyFromClass("flixel.FlxG", "scaleMode.scale.x")
	canGameY = 0.5 * getPropertyFromClass("flixel.FlxG", "height") * (1 - getProperty("camGame.zoom")) *
		getPropertyFromClass("flixel.FlxG", "scaleMode.scale.y")
	canHUDX = 0.5 * getPropertyFromClass("flixel.FlxG", "width") * (1 - getProperty("camHUD.zoom")) *
		getPropertyFromClass("flixel.FlxG", "scaleMode.scale.x")
	canHUDY = 0.5 * getPropertyFromClass("flixel.FlxG", "height") * (1 - getProperty("camHUD.zoom")) *
		getPropertyFromClass("flixel.FlxG", "scaleMode.scale.y")
	if resultShake > 0 then
		--cameraShake("game", resultShake, 0.01)
		--cameraShake("hud", resultShake/2, 0.01)
		local randomX = getRandomFloat(-resultShake, resultShake) * 700
		local randomY = getRandomFloat(-resultShake, resultShake) * 700
		setProperty("camGame.canvas.x", canGameX + randomX*1.8)
		setProperty("camGame.canvas.y", canGameY + randomY*1.5)

		if mechanic then
			setProperty("camHUD.canvas.x", canHUDX + -randomX)
			setProperty("camHUD.canvas.y", canHUDY + -randomY)
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == "endCameraWatch" then
		isCamWatch = false
	end
	if tag == "endChangeBrightness" then
		cancelTweenValue("changeColorBright1")
		doValueTween("changeColorBright2", "colorBrightness", colorBrightness, 0, tweenDur / 2, "linear")
	end
end

function onTweenCompleted(tag)
	if string.find(tag, "particle") then
		removeLuaSprite(tag)
	end
	if string.find(tag, "beat") and string.find(tag, "crystal") then
		removeLuaSprite(tag)
	end
	if string.find(tag, "brokenPart") and string.find(tag, "gone") then
		removeLuaSprite(tag)
	end
end

function doValueTween(_tag, _variable, _startValue, _endValue, _dur, _ease)
	callScript("scripts/coolFunctions", "varTween", { _tag, _variable, _startValue, _endValue, _dur, _ease, scriptName })
end

function cancelTweenValue(_tag)
	callScript("scripts/coolFunctions", "cancelVarTween", { _tag })
end

function makeSprite(_tag, _image, _x, _y, _factorX, _factorY, _scale, _frontCharacter)
	makeLuaSprite(_tag, _image, _x, _y)
	if _factorX ~= nil and _factorY ~= nil then
		setScrollFactor(_tag, _factorX, _factorY)
	end
	if _scale ~= nil then
		scaleObject(_tag, _scale, _scale)
	end
	addLuaSprite(_tag, _frontCharacter)
end

function makeAnSprite(_tag, _image, _x, _y, _factorX, _factorY, _scale)
	makeAnimatedLuaSprite(_tag, _image, _x, _y)
	if _factorX ~= nil and _factorY ~= nil then
		setScrollFactor(_tag, _factorX, _factorY)
	end
	if _scale ~= nil then
		scaleObject(_tag, _scale, _scale)
	end
	addLuaSprite(_tag)
end

function betweenNumber(_min, _max)
	local numbers = ""
	for i = _min, _max - 1 do
		numbers = numbers .. tostring(i) .. ","
	end
	numbers = numbers .. tostring(_max)
	return numbers
end

function lerp(a, b, t)
	return a + (b - a) * t
end

--[[
	"crystal1", "crystal1beat", "crystalGlow1", "crystalFloorGlow1",
	"crystal2", "crystal2beat", "crystalGlow2", "crystalFloorGlow2",
	"crystal3", "crystal3beat", "crystalGlow3", "crystalFloorGlow3",
	"crystal4", "crystal4beat", "crystalGlow4", "crystalFloorGlow4",
	"crystal5", "crystal5beat", "crystalGlow5", "crystalFloorGlow5",
	"crystalBack1", "crystalBack1beat", "crystalGlow6", "crystalFloorGlow6",
	"crystalBack2", "crystalBack2beat", "crystalGlow7", "crystalFloorGlow7",
	"crystalWall1", "crystalWall1beat", "crystalGlow8", "crystalFloorGlow8",
	"crystalWall2", "crystalWall2beat", "crystalGlow9", "crystalFloorGlow9",
	"crystalWall3", "crystalWall3beat", "crystalGlow10", "crystalFloorGlow10"
]]
