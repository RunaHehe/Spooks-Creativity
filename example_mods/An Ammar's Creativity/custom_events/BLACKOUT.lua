--Created by RamenDominoes
--Credit appreciated, but not necessary thanks <3

function onCreate()
	
	makeLuaSprite('BlackOut', 'Gone', -300, -100)
	makeGraphic('BlackOut', 100, 100, '000000')
	setObjectCamera('BlackOut', 'hud')
	setProperty('BlackOut.alpha', 0)
	addLuaSprite('BlackOut', false)
	scaleObject('BlackOut', 50, 30)
end

StartStop = 0
Speed = 0


function onEvent(name,value1,value2)

	if name == 'BLACKOUT' then
	
	StartStop = tonumber(value1)
	Speed = tonumber(value2)
end
end
	
function onUpdate()

	if StartStop == 1 then

	doTweenAlpha('FadeIn', 'BlackOut', 1, Speed, 'linear')
end	

	if StartStop == 2 then

	doTweenAlpha('FadeOut', 'BlackOut', 0, Speed, 'linear')
end
end	