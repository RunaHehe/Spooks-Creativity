local addY = -100
local fireX = -1100
local fireY = -420
function onCreate()
	luaDebugMode = true

	
end
function onCreatePost()
	makeLuaSprite("bg", "", 0,0)
	makeGraphic("bg", 1400, 900, "ffffff")
	setScrollFactor("bg", 0, 0)
	scaleObject("bg", 1, 1)
	addLuaSprite('bg')

	makeLuaSprite("ground", "malfunction/Ground", -500,630 + addY)
	scaleObject("ground", 15, 10)
	addLuaSprite('ground')
	setProperty("ground.antialiasing", false)

	local tag = "fire1"
	makeAnimatedLuaSprite(tag, "malfunction/Fire1", 600 + fireX, 150 + addY + fireY)
	addAnimationByPrefix(tag, "animation", "Fire", 8)
	addLuaSprite(tag)
	scaleObject(tag, 15, 15)
	playAnim(tag, "animation")
	setProperty(tag..".antialiasing", false)

	local tag = "fire2"
	makeAnimatedLuaSprite(tag, "malfunction/Fire2", 600 + fireX, 150 + addY + fireY)
	addAnimationByPrefix(tag, "animation", "Fire", 7)
	addLuaSprite(tag)
	scaleObject(tag, 15, 15)
	playAnim(tag, "animation")
	setProperty(tag..".antialiasing", false)

	local tag = "fire3"
	makeAnimatedLuaSprite(tag, "malfunction/Fire3", 600 + fireX, 150 + addY + fireY)
	addAnimationByPrefix(tag, "animation", "Fire", 6)
	addLuaSprite(tag)
	scaleObject(tag, 15, 15)
	playAnim(tag, "animation")
	setProperty(tag..".antialiasing", false)

	local tag = "fire4"
	makeAnimatedLuaSprite(tag, "malfunction/Fire4", 600 + fireX, 150 + addY + fireY)
	addAnimationByPrefix(tag, "animation", "Fire", 4)
	addLuaSprite(tag)
	scaleObject(tag, 15, 15)
	playAnim(tag, "animation")
	setProperty(tag..".antialiasing", false)
	
	setProperty("camFollowPos.x", 250)
	setProperty("camFollowPos.y", -2500)
	setProperty("cameraSpeed", 0.5)
end

idParticle = 0
function onStepHit()
	idParticle = idParticle + 1
	local tag = "bgParticle"..idParticle
	makeLuaSprite(tag, "", getRandomFloat(-400,1600),600 + addY)
	makeGraphic(tag, 50, 50, "000000")
	addLuaSprite(tag)
	setProperty(tag..".alpha", getRandomFloat(0.1,0.8) )

	local duration = getRandomFloat(2,4)
	doTweenX(tag.."SX", tag..".scale", 0, duration, "quadIn")
	doTweenY(tag.."SY", tag..".scale", 0, duration, "quadIn")
	doTweenY(tag, tag, 300, duration)

	if curStep >= 32 and getProperty("cameraSpeed") ~= 1.5 then 
		setProperty("cameraSpeed", 1.5)
	end
end

function onTweenCompleted(tag)
	if string.find(tag, "bgParticle") then 
		removeLuaSprite(tag)
	end
end