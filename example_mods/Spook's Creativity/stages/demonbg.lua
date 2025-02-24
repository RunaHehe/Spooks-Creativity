randoShake = 0
timewait = 0

function onCreate()
	--luaDebugMode = true
	--makeAnimatedLuaSprite('skyBG','skybg/fatbg',-1417.15,-1041.5)
	--addAnimationByIndices('skyBG','still','fatbg','0',24)
	--addAnimationByPrefix('skyBG','jive','fatbg',24,true)
	--addAnimationByIndices('skyBG','static','fatbg','3',24)
	--addLuaSprite('skyBG')

	makeLuaSprite("skyBG", "skybg/redbg", -1417.15 + 300,-1041.5)
    addLuaSprite("skyBG", false)

	makeAnimatedLuaSprite('speaker','skybg/speaker',879.5,471.7)
	addAnimationByPrefix('speaker','speaker','speaker',24,false)
	addLuaSprite('speaker')
	setScrollFactor('speaker',0.95,0.95)

	
end

function onCreatePost()

	makeAnimatedLuaSprite('static','skybg/staticbg',-1361.1,-681)
	addAnimationByPrefix('static','static','staticbg',0,false)
	--addAnimationByIndices('static','still','fatbg','0',24)
	--addAnimationByIndicesLoop("static", "static", "staticbg", "0,2,3,1,2,1,1,2,3,3,1,2,1,3,2,2,3,2,1", 30)
	addLuaSprite('static')
	--objectPlayAnimation('static','static',true)
	setBlendMode('static','add')
	setObjectCamera("static", "hud")
	setObjectOrder("static", getObjectOrder("notes") + 5)

	setProperty('static.alpha',0.01)

	makeLuaSprite("cover", "", 0 , 0)
    makeGraphic("cover", 2000,2000, "FFFFFF")
    setScrollFactor("cover", 0 ,0)
    addLuaSprite("cover", true)
    screenCenter("cover")
    setObjectCamera("cover", "camGame")
    setProperty('cover.alpha', 1);
	setProperty("cover.color", getColorFromHex("36393F"))

	addLuaScript("stages/discordStage")
end
function onSongStart()
	setProperty('static.alpha',0)
	playAnim('speaker','speaker',true)
end
function onBeatHit()
	playAnim('speaker','speaker',true)
end

function onUpdatePost()
	if not inGameOver then
		setProperty('static.angle', getRandomBool(50) and 180 or 0)
		setProperty("static.animation.frameIndex", getProperty("static.animation.frameIndex") + getRandomInt(-2, 2))
	end
end

function onStepHit()
	if timewait > 0 then timewait = 0 end
	anims = {'still','jive','static'}

	if flashingLights then
		playAnim('skyBG',anims[getRandomInt(1,3)])
	end
end
function opponentHit(id,d,t,s)
	playAnim('skyBG','jive')
end

	staton = false

function onEvent(n,v,b)
	if n == 'Static' then
	if timewait == 0 then
		randoShake = 0
		staton = staton == false

		if v == 'off' or  flashingLights then staton = false end
		
		if staton then
			randoShake = 10
		end
	timewait = 1
	end
end


end