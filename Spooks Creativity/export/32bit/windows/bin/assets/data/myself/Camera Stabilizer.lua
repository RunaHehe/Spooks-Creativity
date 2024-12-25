---------- Config ----------
local windowX = -150
local windowY = -400

-- if the window scrolling is off a bit, try changing these by a decimal
local multX = 2
local multY = 1.6

-- idk the point of this but its there ig
local camWidth = 1280
local camHeight = 720
local scale = 0.55 -- multiplies the window scale, if it gets too big you can make it smaller using this
----------------------------



local stabilize = false
local start = false
local camX = -300
local camY = -200
local camrWidth = camWidth*scale
local camrHeight = camHeight*scale
local finishLength = nil


camX = camX*multX
camY = camY*multY

function onCreatePost()
	camZoom = getProperty('camGame.zoom')
	
	windowX = (windowX + getProperty("boyfriend.x")/camZoom)
	windowY = (windowY + getProperty("boyfriend.y")/camZoom)
	makeLuaSprite('windowSprite', '', windowX, windowY)
	setProperty('windowSprite.alpha', 0)
	addLuaSprite('windowSprite')
end

function onCountdownStarted()
	stabilize = true
	return Function_Continue;
end

function onCreate()
	setPropertyFromClass("openfl.Lib", "application.window.borderless", true)
	setWindowColor(0x0000ff00)
end

function onSongStart()
	-- If the song starts and the window dissapears, uncomment this line of script below and try to restart the song.
	-- The text file will find where the window is right now, then saves in the script folder. That will probably help with changing window x & y variables.
	--saveFile("mods/An Ammar\'s Creativity/scripts/Window Positions.txt", "Window X: "..getPropertyFromClass('openfl.Lib', 'application.window.x').." | Window Y: "..getPropertyFromClass('openfl.Lib', 'application.window.y'))
	
	finishLength = songLength - 50
	start = true
	if stabilize == false then
		stabilize = true
	end
	return Function_Continue;
end

function idk(t)
	camrX = camX/getProperty('camGame.zoom')
	camrY = camY/getProperty('camGame.zoom')
	theZoom = getProperty('camGame.zoom')/camZoom
	windowX2 = getProperty('windowSprite.x')
	windowY2 = getProperty('windowSprite.y')
	if t == 1 then
		setPropertyFromClass('openfl.Lib', 'application.window.x', (((getProperty('camFollowPos.x') + (camrX/camZoom)/0.9 * (camZoom))) * (camrWidth/1280) + windowX2)*camZoom)
		setPropertyFromClass('openfl.Lib', 'application.window.y', (((getProperty('camFollowPos.y') + (camrY/camZoom)/0.9 * (camZoom))) * (camrHeight/720) - windowY2)*camZoom)
	elseif t == 2 then
		setPropertyFromClass("openfl.Lib", "application.window.width", camrWidth / theZoom)
		setPropertyFromClass("openfl.Lib", "application.window.height", camrHeight / theZoom)
	end
end

function onUpdate()
	if start == false then
		idk(1)
	end
	if stabilize == true and getSongPosition() < finishLength then
		idk(1)
	end
end

function onUpdatePost()
	if start == false then
		idk(2)
	end
	if stabilize == true and getSongPosition() < finishLength then
		idk(2)
	end
end

function onGameOver()
	setPropertyFromClass("openfl.Lib", "application.window.width", camWidth)
	setPropertyFromClass("openfl.Lib", "application.window.height", camHeight)
	return Function_Continue;
end

function onEndSong()
	setPropertyFromClass("openfl.Lib", "application.window.width", camWidth)
	setPropertyFromClass("openfl.Lib", "application.window.height", camHeight)
	return Function_Continue;
end