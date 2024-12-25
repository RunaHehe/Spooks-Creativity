--Settings
local Icon = 'Spook' -- Icon Name (Put It In Images Folder)
local Name = "Spook's Creativity V4" -- Window Name
local FNF = false -- Puts (Vs stev Defenitive 2.1':) Before Window Name
local Loading_Text = true -- When Loading It Says (Loading Song Please Wait...) Put (mod) For It To Say Mod Instead Of Song 
local Info = false -- More Info For Window Name  
local Difficulty = false -- Shows Difficulty For Info

--Watermark Settings   
local Watermark = false -- Puts Text At The Bottom
local Psych_Version = false -- Tells You What Version Of Psych Engine Your Using.
local Watermark_FNF = false -- Puts (FNF:) For Watermark
local Watermark_Difficulty = false -- Shows Difficulty For Watermark
local Watermark_Font = false -- Custom Font For Watermark | Name The Font (Watermark) And Put It In The Fonts Folder
local FontType = '.ttf' -- (.ttf) Or (.otf) For Watermark Font
local Watermark_Color = false -- Custom Color For Watermark
local Color = 'FFFFFF' -- Hex Codes







----------------------[CODE]---------------------
function onCreatePost()
	hardwareCacheExists = type(getPropertyFromClass("Paths", "hardwareCache")) == "boolean"
	setObjectCamera("songText", "other")
        setObjectCamera("Goofy", "other")
	createVarImage("inGame",Icon)
	createVarImage("original", "GoofyAhhEngine")

if Watermark_Font == true then
local Font = 'Watermark'
setTextFont('songText', Font ..FontType)
end

if Watermark_Font == false then
local Font = 'Default Font.ttf'
setTextFont('songText', Font)
end

if Psych_Version == true then
local Font = 'Default Font.ttf'
setTextFont('Goofy Ahh', Font)
end

if Watermark_Color == true then
setTextColor('songText', Color)
end
end

function onDestroy()

   songended = true
    setPropertyFromClass('lime.app.Application', 'current.window.title', "Vs Stev Defenitive 2.1': Goofy Ahh Engine")

	setWindowIconWithVar('original');
	for i,v in pairs(varImgs) do
		destroyVarImage(i);
	end
      end

hardwareCacheExists = true;
local curImg = 'inGame';
function file_exists(name)
   local f = io.open(name, "r");
   return f ~= nil and io.close(f);
end

function getImagePath(path)
	if (path:sub(#path - 4, #path) == ".png" and file_exists(path)) then return path end
	
	addHaxeLibrary("Paths");
	runHaxeCode([[
	var path = "]] .. tostring(path) .. [[";
	game.setOnLuas("socoolpathog", Paths.modsImages(path));
	game.setOnLuas("socoolpathmod", Paths.getPath('images/' + path + '.png', null, "preload"));
	]]);
	local og = socoolpathog
	local mod = socoolpathmod
	if (og == nil or mod == nil) then return end
	
	local path = file_exists(mod) and mod or (file_exists(og) and og or (file_exists(path) and path or nil))
	return path
end

varImgs = {}
function createVarImage(var, path)
	path = getImagePath(path);
	if (path == nil) then return end
	
	addHaxeLibrary("Image", "lime.graphics");
	runHaxeCode(
	[[
	var image = Image.fromFile("]] .. path .. [[");
	setVar("]] .. var .. [[", image);
	]]
	.. (hardwareCacheExists and "Paths.compress();" or "")
	);
	varImgs[var] = path
	
end

function destroyVarImage(var)
	if (not varImgs[var]) then return end
	runHaxeCode(
	[[
	var image = getVar("]] .. var .. [[");
	setVar("]] .. var .. [[", null);
	image.buffer = null;
	image = null;
	]]
	.. (hardwareCacheExists and "Paths.compress();" or "")
	);
	varImgs[var] = nil
end

function setWindowIcon(path)
	path = getImagePath(path)
	if (path == nil) then return end
	
	addHaxeLibrary("Image", "lime.graphics");
	runHaxeCode(
	[[
	var image = Image.fromFile("]] .. path .. [[");
	Application.current.window.setIcon(image);
	
	image.buffer = null;
	]]
	.. (hardwareCacheExists and "Paths.compress();" or "")
	);
end

function setWindowIconWithVar(var)
	addHaxeLibrary("Application", "lime.app");
	
	runHaxeCode(
	[[
	Application.current.window.setIcon(getVar("]] .. tostring(var) .. [["));
	]]
	);
end

local prevImg = ""
function onUpdate()
	if (prevImg ~= curImg) then
		setWindowIconWithVar(curImg);
	end
	prevImg = curImg
end
local Full = "Vs Stev Defenitive 2.1: Goofy Ahh Engine':"
songended = false

function onCreate()

if Loading_Text == mod then
 setPropertyFromClass('lime.app.Application', 'current.window.title',Name .." | Loading Mod Please Wait...")
end

if Loading_Text == mod and FNF == true then
 setPropertyFromClass('lime.app.Application', 'current.window.title',Full ..Name .." | Loading Mod Please Wait...")
end

if Loading_Text == true then
 setPropertyFromClass('lime.app.Application', 'current.window.title',Name .." | Loading Song Please Wait...")
end

if Loading_Text == true and FNF == true then
 setPropertyFromClass('lime.app.Application', 'current.window.title',Full ..Name .." | Loading Song Please Wait...")
end 
 if (not downscroll) then
  makeLuaText('songText', " ", 0, 2, 701);
    setTextAlignment('songText', 'left');
    setTextSize('songText', 15);
    setTextBorder('songText', 1, '000000');
    addLuaText('songText');
end

if (downscroll) then
  makeLuaText('songText', " ", 0, 2, 0.4);
    setTextAlignment('songText', 'left');
    setTextSize('songText', 15);
    setTextBorder('songText', 1, '000000');
    addLuaText('songText');
end

if (not downscroll) and Watermark == true and Psych_Version == true then
  makeLuaText('Psych', " ", 0, 2, 687);
    setTextAlignment('Goofy Ahh', 'left');
    setTextSize('Goofy Ahh', 15);
    setTextBorder('Goofy Ahh', 1, '000000');
    addLuaText('Goofy Ahh');
end

if (downscroll) and Watermark == true and Psych_Version == true then
  makeLuaText('Psych', " ", 0, 2, 18);
    setTextAlignment('Goofy Ahh', 'left');
    setTextSize('Goofy Ahh', 15);
    setTextBorder('Goofy Ahh', 1, '000000');
    addLuaText('Goofy Ahh');
end
function onUpdatePost()
if songended == false and Info == false and FNF == false then
    setPropertyFromClass('lime.app.Application', 'current.window.title',Name)
    end

 if songended == false and Info == false and FNF == true then
    setPropertyFromClass('lime.app.Application', 'current.window.title',Full ..Name)
    end

if songended == false and Info == true and FNF == false and Difficulty == false then
    setPropertyFromClass('lime.app.Application', 'current.window.title',Name .." | Now Playing : "..getProperty("curSong").." | "..getProperty("scoreTxt.text"))
    end

if songended == false and Info == true and FNF == true and Difficulty == false then
    setPropertyFromClass('lime.app.Application', 'current.window.title',Full ..Name .." | Now Playing : "..getProperty("curSong").." | "..getProperty("scoreTxt.text"))
    end

if songended == false and Info == true and FNF == false and Difficulty == true then
    setPropertyFromClass('lime.app.Application', 'current.window.title',Name .." | Now Playing : "..getProperty("curSong").." Difficulty: " .. difficultyName .. " | "..getProperty("scoreTxt.text"))
    end

if songended == false and Info == true and FNF == true and Difficulty == true then
    setPropertyFromClass('lime.app.Application', 'current.window.title',Full ..Name .." | Now Playing : "..getProperty("curSong").." Difficulty: " .. difficultyName .. " | "..getProperty("scoreTxt.text"))
end

if Watermark == true then
 setTextString('songText', songName .. " | "..Name.. "");
end

if Watermark == true and Watermark_Difficulty == true then
    currentDifficulty = getProperty('storyDifficultyText');
    setTextString('songText', songName .. " Difficulty: " .. currentDifficulty .. " | "..Name.. "");
end

if Watermark == true and Watermark_FNF == true then
 setTextString('songText', songName .. " | FNF: "..Name.. "");
end

if Watermark == true and Watermark_Difficulty == true and Watermark_FNF == true then
    currentDifficulty = getProperty('storyDifficultyText');
    setTextString('songText', songName .. " Difficulty: " .. currentDifficulty .. " | FNF: "..Name.. "");
end

if Psych_Version == true then
    setTextString('Goofy Ahh', "Goofy Ahh Engine "..version.."");
end
end


function onGameOver()

if Info == true and FNF == false then
    songended = true
    setPropertyFromClass('lime.app.Application', 'current.window.title',Name .. " | Final Results : "..getProperty("scoreTxt.text"))
    return Function_Continue
end

if Info == true and FNF == true then
    songended = true
    setPropertyFromClass('lime.app.Application', 'current.window.title',Full ..Name .. " | Final Results : "..getProperty("scoreTxt.text"))
    return Function_Continue
end
end
end