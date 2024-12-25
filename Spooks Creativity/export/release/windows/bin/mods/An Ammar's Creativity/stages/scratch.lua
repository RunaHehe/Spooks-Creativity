
local addY = -100
function onCreate()
	luaDebugMode = true
end
function onCreatePost()
	makeLuaSprite("bg", "scratch/back", -300,-100)
	--setScrollFactor("bg", 0, 0)
	scaleObject("bg", 1, 1)
	addLuaSprite('bg')

	makeAnimatedLuaSprite('bottomBackBlocks','scratch/bottomBackBlocks',-200,-100)
	addAnimationByPrefix('bottomBackBlocks','idle','bottomBackBlocks',50,false)
	addLuaSprite('bottomBackBlocks')
	scaleObject("bottomBackBlocks", 0.8, 0.8)
	setScrollFactor("bottomBackBlocks", 0.7, 0.5)

	makeAnimatedLuaSprite('backBlocks','scratch/backBlocks',70,100)
	addAnimationByPrefix('backBlocks','idle','backBlocks',50,false)
	addLuaSprite('backBlocks')
	scaleObject("backBlocks", 0.8, 0.8)
	setScrollFactor("backBlocks", 0.9, 0.8)

	playAnim("bottomBackBlocks", "idle", true)
	playAnim("backBlocks", "idle", true)

	makeLuaSprite("whiteBG", "", 0,-100)
	makeGraphic("whiteBG", 1400, 1000, "FFFFFF")
	setScrollFactor("whiteBG", 0, 0)
	addLuaSprite('whiteBG')

	makeLuaSprite("web", "scratch/scratchWeb", 0, 0)
	setScrollFactor("web", 0, 0)
	scaleObject("web", 1, 1)
	addLuaSprite('web')
	setObjectCamera('web', "hud")

	setProperty("web.alpha", 0)
	setProperty("whiteBG.alpha", 0)
	
	makeLuaSprite("dark", "scratch/darkness", 0,0)
	scaleObject("dark", 0.5, 0.5)
	addLuaSprite('dark')
	setObjectCamera('dark', "other")

	makeAnimatedLuaSprite('glitch','scratch/glitch',0,0)
	addAnimationByPrefix('glitch','idle','g0',30,true)
	addLuaSprite('glitch')
	playAnim("glitch", "idle", true)
	setObjectCamera('glitch', "other")
	setBlendMode("glitch", "add")
	setObjectOrder("glitch", 50)
	setProperty("glitch.alpha",0.1)
end

function onBeatHit()
	playAnim("bottomBackBlocks", "idle", true)
	playAnim("backBlocks", "idle", true)
	if getProperty("dad.animation.curAnim.name") == "idle" then 
		playAnim("dad", "idle", true)
	end
end

movingEl = 0
function onUpdate(elapsed)
	movingEl = movingEl + elapsed*4
	setProperty("backBlocks.y", 100 + (math.sin(movingEl)*10))
	setProperty("bottomBackBlocks.y", -100 + (math.sin(movingEl + 4)*10))

	if not inGameOver then
		if getRandomBool(80) then 
			--setProperty("glitch.flipX", getRandomBool(50))
		end
		if getRandomBool(80) then 
			--setProperty("glitch.flipY", getRandomBool(50))
		end
		--setProperty("glitch.animation.frameIndex", getProperty("glitch.animation.frameIndex") + getRandomInt(-5, 5))
	
	end
end

