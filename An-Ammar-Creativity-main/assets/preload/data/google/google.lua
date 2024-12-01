--MODULE 
SpriteUtil = nil
--

--* White BG = FFFFFF, Black BG = 202124
local googleChatBoxY = 470
local folder = "google/"
local font = "Google/Product Sans Regular.ttf"

local opponentSingTime = ""

local colors = {
   "008744", "0057E7", "D62D20", "FFA700",
   "00cf68", "2b7bff", "ed4a3e", "ffc24f" -- flash
}
local beatDrum = {
   {0, 6, 10 ,16, 22, 24, 26,  32, 38, 42, 46,  48, 54, 58, 62,  0+64, 6+64, 10+64 ,16+64, 22+64, 24+64, 26+64,  32+64, 38+64, 42+64, 46+64,  48+64, 52+64, 58+64, 62+64}, -- kick
   {4, 12,  4+16, 12+16,  4+32, 12+32,  4+48, 8+48, 12+48,  4+64, 12+64,  4+16+64, 12+16+64,  4+32+64, 12+32+64,   2+48+64, 6+48+64, 8+48+64, 12+48+64}
}
local bloomTween = false
local defaultMiddle = false

local defaultNote = {}

--vocals
lastStrumTime = {-999, -999}

vocals = {
    {{{"Ee"}, "e", {''}}, {{"Oo"}, "o", {''}}, {{"Aa"}, "a", {""}}, {{"O"}, "o", {"h"}}}, -- dad, eee, ooo ,aaa ,e
    {{{"ee"}, "e", {''}}, {{"oo"}, "o", {''}}, {{"aa"}, "a", {"h"}}, {{"e"}, "e", {"h"}}} -- player, eee, ooo ,aaa ,e
}

dadNumVocal = 1
bfNumVocal = 1
local dadSingTimer = 0

vocalsNotes = {bf = {}, dad = {}}

local playerSingNote = ""


--
function onCreate()

   if HardMode then
      beatDrum = {{}, {}}
      for i = 0, (64*2)-1 do
         if i % 8 == 0 then
            table.insert(beatDrum[1], i)
         end
         if i % 8 == 4 then
            table.insert(beatDrum[2], i)
         end
         if i % 32 == (32-2) then
            table.insert(beatDrum[2], i)
         end
      end
   end

   defaultMiddle = middlescroll
   setPropertyFromClass("ClientPrefs", "middleScroll", true)

   runHaxeCode([[  
   googleHUD = new FlxCamera();
   googleHUD.bgColor = 0x00;

   googleWave = new FlxCamera();
   googleWave.bgColor = 0x00;
   googleWave.height = 550;

   googleCam = new FlxCamera();
   googleCam.bgColor = 0x00;

   game.variables.set("googleHUD", googleHUD);
   game.variables.set("googleWave", googleWave);
   game.variables.set("googleCam", googleCam);
   
   ]])
end
susOffset = 0
function onCreatePost()
   luaDebugMode = true

   setProperty('iconSpeed', 4)

   package.path = getProperty("modulePath") .. ";" .. package.path
   SpriteUtil = require("SpriteUtil")
   
   setProperty("camGame.visible", false)

   runHaxeCode([[
        FlxG.cameras.remove(game.camOther,false);
        FlxG.cameras.remove(game.camHUD,false);
        FlxG.cameras.add(googleCam,false);
        FlxG.cameras.add(googleWave,false);
        FlxG.cameras.add(googleHUD,false);
        FlxG.cameras.add(game.camHUD,false);
        FlxG.cameras.add(game.camOther,false);
    ]])

   precacheImage(folder.."GoogleBoxB")
   SpriteUtil.makeSprite({tag="bg",graphicWidth = 1400, graphicHeight = 900, graphicColor = "FFFFFF"})
   screenCenter("bg")
   setCam("bg", 1)

   SpriteUtil.makeSprite({tag="blueOverlay", image = folder.."blueOverlay"})
   screenCenter("blueOverlay")
   setCam("blueOverlay", 1)
   setBlendMode("blueOverlay", "overlay")

   SpriteUtil.makeSprite({tag="whiteOverlay", image = folder.."whiteOverlay"})
   screenCenter("whiteOverlay")
   setCam("whiteOverlay", 1)
   setBlendMode("whiteOverlay", "overlay")
   setProperty("whiteOverlay.alpha", 0.25)
   
   SpriteUtil.makeSprite({tag="coverBg",graphicWidth = 1400, graphicHeight = 900, graphicColor = "000000"})
   screenCenter("coverBg")
   setProperty('coverBg.alpha', 0.99)
   setCam("coverBg", 1)

   readyVideo()
   createWaves()

   SpriteUtil.makeSprite({tag="chatBox",image=folder.."GoogleBoxW", xSize =0.7, y = googleChatBoxY})
   screenCenter("chatBox", "x")
   setCam("chatBox", 2)

   SpriteUtil.makeText({
      tag = "chatText" , text = "(listening...)", font = font,
      align = "left", borderColor = "0x00000000", size = 26, borderSize = 0, borderQuality = 0, color = "000000",
      x = getProperty("chatBox.x") + 40 , y= getProperty("chatBox.y") + 63, width = 1150
   })
   runHaxeCode("game.getLuaObject('chatText').camera = googleHUD")

   SpriteUtil.makeText({
      tag = "chatTextFX" , text = "", font = font,
      align = "left", borderColor = "0x00000000", size = 26, borderSize = 0, borderQuality = 0, color = "000000",
      x = getProperty("chatBox.x") + 40 , y= getProperty("chatBox.y") + 63, width = 1150
   })
   runHaxeCode("game.getLuaObject('chatTextFX').camera = googleHUD")

   setProperty('chatBox.y', getProperty('chatBox.y')+250)
   setProperty('chatText.y', getProperty('chatText.y')+250)
   setProperty('googleWave.visible', false)

   SpriteUtil.makeSprite({tag="flashBlack",graphicWidth = 1400, graphicHeight = 900, graphicColor = "000000"})
   screenCenter("flashBlack")
   setObjectCamera('flashBlack', 'other')
   setProperty('flashBlack.alpha', 0)

   for i = 0, getProperty("unspawnNotes.length")-1 do
      if getPropertyFromGroup("unspawnNotes", i, "isSustainNote") then
         susOffset = getPropertyFromGroup("unspawnNotes", i, "offsetX")
      end
   end

   for i = 0, getProperty("unspawnNotes.length")-1 do
      if not getPropertyFromGroup("unspawnNotes", i, "mustPress") then
         if getPropertyFromGroup("unspawnNotes", i, "isSustainNote") then
            setPropertyFromGroup("unspawnNotes", i, "angle", 180)  
         end
      end
   end

   setProperty("boyfriend.healthIcon", "ammar"..(CuteMode and 'cute' or ''))
   runHaxeCode([[
       game.iconP1.changeIcon("icon-ammar]]..(CuteMode and 'cute' or '')..[[");
   ]])
   setHealthBarColors("FFFFFF", "60f542")
   setProperty("iconP2.visible", false)

   if HardMode then
      setProperty("bg.color", getColorFromHex("202124"))
      setProperty("blueOverlay.visible", false)
      setProperty("whiteOverlay.visible", false)
      loadGraphic("chatBox", folder.."GoogleBoxB")
      setTextColor("chatText", "FFFFFF")
      setTextColor("chatTextFX", "FFFFFF")
   end
   
   makeLuaSprite("bloom", "", 0, 0) 
   makeGraphic('bloom', 1400, 900, 'FFFFFF')
   setObjectCamera("bloom", 'other')
   screenCenter('bloom')
   addLuaSprite("bloom")
   setBlendMode('bloom', 'add')
   setProperty('bloom.alpha', 0)

   if shadersEnabled then 

      initLuaShader("radialBlur")
      makeLuaSprite("radialBlurEffect", "", 0, 0)
      setSpriteShader("radialBlurEffect", "radialBlur")
      setShaderFloat("radialBlurEffect", "cx", 0.5)
      setShaderFloat("radialBlurEffect", "cy", 0.5)
      setShaderFloat("radialBlurEffect", "blurWidth", 0)

      makeLuaSprite("bloomVar", "", 0, -500)

      
      -- setSpriteShader("bloom", "bloom")
      -- setShaderFloatArray("bloom", "u_samples", {2, 2})
      -- setShaderFloatArray("bloom", "u_size", {60, 2})
      -- setShaderFloat("bloom", "u_brightness", 0) -- MAIN
      -- setShaderFloatArray("bloom", "u_tint", {0.95, 0.95, 1}) --color multiply
      -- setShaderFloat("bloom", "u_threshold", 0.2) -- 0-1
      -- setShaderFloat("bloom", "u_range", 0.05) --softness

      runHaxeCode([[
         var blur = new ShaderFilter(game.getLuaObject("radialBlurEffect").shader);
         //var bloom = new ShaderFilter(game.getLuaObject("bloom").shader);
         //game.camHUD.setFilters([bloom]);
         googleHUD.setFilters([blur]);
         googleCam.setFilters([blur]);
         googleWave.setFilters([blur]);
      ]])
  end

  loadParticles()
end

function setBloom(intensity)
   cancelTween("bloomtween")
   setProperty('bloom.alpha', intensity)
end

function easeBloom(intensity, dur, ease)
   doTweenAlpha('bloomtween', 'bloom', intensity, dur, ease)
end


function onCountdownStarted() 
   runHaxeCode([[
      for (strum in game.opponentStrums)
      {
          strum.camera = googleCam;
          strum.scrollFactor.set(1, 1);
      }

      for (note in game.unspawnNotes)
      {
          if (!note.mustPress) {
              note.camera = googleCam;
              note.scrollFactor.set(1, 1);
          }
      }
  ]])

   local spfg = setPropertyFromGroup
   local space = {-1.5, -0.5, 0.5, 1.5}
   for i = 0,3 do
      spfg("strumLineNotes", i, "downScroll", true)
      spfg("strumLineNotes", i, "x", (1280/2) + (250*space[i+1]) - (getPropertyFromGroup("strumLineNotes", i, "width")/2))
      spfg("strumLineNotes", i, "y", 490)
      spfg("strumLineNotes", i, "visible", false)
   end
   for i = 1, 8 do
         table.insert(defaultNote, {x = getPropertyFromGroup("strumLineNotes", i-1, "x"), y = getPropertyFromGroup("strumLineNotes", i-1, "y")})
   end

  
end

function setCam(tag, campart)
   runHaxeCode("game.getLuaObject('"..tag.."').camera = ".. (campart <= 1 and "googleCam" or "googleHUD"))
end

waves = {}
function createWaves()
   local amount = 19
   local space = 50
   local startX = (1280/2) - (90*0.5) - (amount/2 * space)  + (90*0.25)  

   for i = 0, amount do
      local tag = "waveGoogle" .. #waves 
      SpriteUtil.makeSprite({tag=tag,image=folder.."waveBar", xSize =0.5, y = 500, x = startX + i * space})
      setProperty(tag..'.color', getColorFromHex(colors[i%4 + 1]))
      runHaxeCode("game.getLuaObject('"..tag.."').camera = googleWave")
      table.insert(waves, {tag = tag, defaultY = 500, targetY = 500})
   end
end

circles = {}
circleId = 0
circleSpawnrate = 4
spawnDirection = "left"
function createCircle()
   circleId = circleId + 1
   local tag = "circleBG" .. circleId 
   local sizee = getRandomFloat(0.35, 0.75)
   local colorName = colors[circleId%4 + 1]
   local randomX = spawnDirection == "left" and getRandomFloat(0, 640) or  getRandomFloat(640, 1280)
   spawnDirection = (spawnDirection == "left" and "right" or "left")
   SpriteUtil.makeSprite({tag=tag,image=folder.."circle", xSize = sizee, y = 730, x = randomX})
   setProperty(tag..'.color', getColorFromHex(colorName))
   setCam(tag, 1)
   table.insert(circles, 1, {tag = tag, speed = getRandomFloat(0.8, 1) * sizee, dead = false, id = circleId, color = colorName})
   doTweenY(tag, tag, -350, getRandomFloat(10, 15))
   setObjectOrder(tag, getObjectOrder("whiteOverlay")-1)
end

particles = {}
particleID = 0
maxParticles = 300
function loadParticles()
   for i = 1, maxParticles do
      local color = colors[getRandomInt(1,4)]
      local tag = "googleParticle"..i
      
      SpriteUtil.makeSprite({tag=tag,image=folder.."particle", y = 720, x = 0, xSize = getRandomFloat(1.5, 3)})
      setBlendMode(tag, "add")
      setProperty(tag..'.color', getColorFromHex(color))
      setProperty(tag..'.active', false)
      setProperty(tag..'.alpha', 0)
      --table.insert(particles, 1, {tag = tag})
      local duration = getRandomFloat(3, 5)
      setObjectCamera(tag, 'other')
      setObjectOrder(tag, getObjectOrder("notes")+5)
   end
end

function createParticle(amount)
   if (lowQuality and getRandomBool(10)) or not lowQuality then
      if particleID > maxParticles then
         particleID = 0
      end
      for i = 1, amount do
         particleID = particleID + 1
         if particleID > maxParticles then
            particleID = 1
         end
         local color = colors[getRandomInt(1,4)]
         local tag = "googleParticle"..particleID
         
         setProperty(tag..'.alpha', 1)
         setProperty(tag..'.y', 720)
         setProperty(tag..'.x', getRandomFloat(0, 1280))

         local duration = getRandomFloat(3, 5)
         doTweenY(tag, tag, getRandomFloat(20, 600), duration, "sineOut")
         doTweenAlpha("googleparalpha"..particleID, tag, 0, duration)
      end
   end
end


beatSquares = {}
beatSquareID = 0
function createBeatSquare(rightSide)
   if rightSide then
      triggerEvent("Add Camera Zoom", nil, nil)
   end
   beatSquareID = beatSquareID + 1
   local color = colors[getRandomInt(1,4)]
   local tag = "googleBeatSquare"..beatSquareID
   
   local posX = (rightSide and 1280-50 or -100+50)
   SpriteUtil.makeSprite({tag=tag,graphicColor = "2b7bff", graphicWidth = 100, graphicHeight = 1300, y = -50, x = posX})
   setBlendMode(tag, "overlay")
   setProperty(tag..".alpha", 0.8)

   local duration = 1
   doTweenX(tag, tag, posX + (rightSide and -400 or 400), duration, "quadOut")
   doTweenAlpha("googlebeatsquarealpha"..beatSquareID, tag, 0, duration, "quadOut")
   setCam(tag, 1)
end

local flashToggle = false
function circleFlash(halfOfThem)
   if halfOfThem then
      flashToggle = flashToggle == false
   end
   for i,v in pairs(circles) do
      if v.dead == false then
         if halfOfThem then
            if (v.id%2 == 0 and flashToggle) or (v.id%2 == 1 and not flashToggle) then
               setProperty(v.tag..".color", getColorFromHex(colors[v.id%4 + 1 + 4]))
               doTweenColor(v.id.."circleFlash", v.tag, v.color, 0.6)
            end
         else
            setProperty(v.tag..".color", getColorFromHex(colors[v.id%4 + 1 + 4]))
            doTweenColor(v.id.."circleFlash", v.tag, v.color, 0.3)
         end
      end
   end
end

function onUpdate(elapsed) 
   if inGameOver then return end

   for i = 0, getProperty("notes.length")-1 do
      if not getPropertyFromGroup("notes", i, "mustPress") then 
         local distance = getPropertyFromGroup("notes", i, "distance")/200
         if getPropertyFromGroup("notes", i, "isSustainNote") then
            setPropertyFromGroup("notes", i, "offsetX", getPropertyFromGroup("notes", i, "parent.offsetX") + susOffset)  
         else
            setPropertyFromGroup("notes", i, "offsetX", math.sin(distance + getPropertyFromGroup("notes", i, "strumTime")) * 30)  
         end
      end
   end

   if curBeat >= 256 and curBeat < 448 then --256
      setProperty("camHUD.y", con_sin(curDecBeat/8) * 8)
      if curBeat >= 320 and (not EasyMode and Mechanic) then
         setProperty("camHUD.angle", con_sin(curDecBeat/16) * 8)
      end
      if curBeat >= 384 then
         setProperty("googleHUD.angle", con_sin(curDecBeat/20) * 5)
         setProperty("googleWave.angle", con_sin(curDecBeat/20) * 5.5)
         setProperty("googleCam.angle", con_sin(curDecBeat/20) * 4)
      end
   end
   if HardMode and curBeat >= 456 and curBeat < 584 then
      for i = 0, 7 do
         setPropertyFromGroup("strumLineNotes", i, 'x', defaultNote[i+1].x + (con_sin(curDecBeat/8) * 200))
      end
   end

   if curBeat >= 520 and curBeat < 584 then --256
      if not EasyMode then
         setProperty("camHUD.angle", con_sin(curDecBeat/16) * 4)
      end
      setProperty("googleHUD.angle", con_sin(curDecBeat/20) * 5)
      setProperty("googleWave.angle", con_sin(curDecBeat/20) * 5.5)
      setProperty("googleCam.angle", con_sin(curDecBeat/20) * 4)
      
   end
end
local oldMustHit = false
function onUpdatePost(elapsed)
   if inGameOver then return end
   if waves ~= nil then
      for i,v in pairs(waves) do
         local tag, defY = v.tag, v.defaultY
         v.targetY = lerp(math.max(v.targetY, 180), defY, elapsed*4)
         setProperty(tag..".y", lerp(getProperty(tag..'.y'), v.targetY, elapsed*12))
      end
   end
 
   if dadSingTimer < 1 then 
      dadSingTimer = dadSingTimer + elapsed
      
   elseif getTextString("chatText") ~= "(listening...)" then
      endChat()
   end

   if curBeat >= 32 then
      setProperty("chatBox.y", googleChatBoxY + (math.sin(getSongPosition()/1000)*5))
      setProperty("chatText.y", getProperty('chatBox.y') + 63)
   end

   setProperty("googleCam.zoom", lerp(getProperty("googleCam.zoom"), 1, elapsed*4))
   setProperty("googleHUD.zoom", lerp(getProperty("googleHUD.zoom"), 1, elapsed*4))
   setProperty("googleWave.zoom", 1 + ((getProperty("googleHUD.zoom")-1) * 5))

   if bloomTween and false then
      setShaderFloat("bloom", "u_brightness", getProperty('bloomVar.x'))
   end
end  
 
function onStepHit()
   if (curStep >= 512 and curStep < 1008) then
      for i,v in pairs(beatDrum[1]) do
         if v == curStep%128 then
            createBeatSquare(false)
         end
      end
      for i,v in pairs(beatDrum[2]) do
         if v == curStep%128 then
            createBeatSquare(true)
         end
      end
      if curStep % 16 ==0 then
         setBloom((HardMode and 0.25 or 0.4))
         easeBloom(0.02, crochet/1000*3, 'quadOut')
      end
   end
   if (curStep >= 1824 and curStep < 2336) then
      for i,v in pairs(beatDrum[1]) do
         if v == (curStep-32)%128 then
            createBeatSquare(false)
         end
      end
      for i,v in pairs(beatDrum[2]) do
         if v == (curStep-32)%128 then
            createBeatSquare(true)
         end
      end
      if curStep % 16 ==0 then
         setBloom((HardMode and 0.25 or 0.4))
         easeBloom(0.02, crochet/1000*3, 'quadOut')
      end
   end
   if curStep >= 1024 and curStep < 1280 then
      createParticle(1)
   end
   if (curStep >= 1280 and curStep < 1536) or (curStep >= 2080 and curStep < 2332) then
      createParticle(3)
   end
   if curStep >= 1536 and curStep < 1788 then
      createParticle(5)
   end
   if curStep % (32 - circleSpawnrate) == 0 then
      if getRandomBool(30) then createCircle() end
      createCircle()
   end

   if curStep == 576 or curStep == 640 or curStep == 704 or curStep == 768 or curStep == 1152 or curStep == 1280 or curStep == 1408 or curStep == 1536 or curStep == 1664
   or curStep == 1888 or curStep == 1952 or curStep == 2016 or curStep == 2080 or curStep == 2144 or curStep == 2208 or curStep == 2272 or curStep == 2336 then
      endChat()
   end
end

function onSectionHit()
   setProperty("googleCam.zoom", getProperty("googleCam.zoom") + 0.03)
   setProperty("googleHUD.zoom", getProperty("googleHUD.zoom") + 0.01)
end

function onEvent(eventName, value1, value2)
   if (eventName == "Add Camera Zoom") then
      local value = (value1 == nil or value1 == "") and 0.01 or tonumber(value1)
      setProperty("googleCam.zoom", getProperty("googleCam.zoom") + value * 1.0195)
      setProperty("googleHUD.zoom", getProperty("googleHUD.zoom") + value)
   end 
end

function sing(isPlayer, id, dir, type, sus)
   local targetSing = 1 + ((dir) * 4) + (isPlayer and 7 or 0)
   local susMul = (sus and 0.5 or 2.25)

   if waves[targetSing -2] ~= nil then waves[targetSing -2].targetY = waves[targetSing -2].targetY - 50*susMul end
   if waves[targetSing -1] ~= nil then waves[targetSing -1].targetY = waves[targetSing -1].targetY - 125*susMul end
   waves[targetSing].targetY = waves[targetSing].targetY - 150*susMul
   if waves[targetSing +1] ~= nil then waves[targetSing +1].targetY = waves[targetSing +1].targetY - 125*susMul end
   if waves[targetSing +2] ~= nil then waves[targetSing +2].targetY = waves[targetSing +2].targetY - 50*susMul end
end

function onStepEvent(curStep)
   if curStep == 112 then
      local targetLol = googleChatBoxY + (math.sin((9142.857)/1000)*5)
      doTweenY('chatboxy', 'chatBox', targetLol, crochet/1000*4, 'quadOut')
      doTweenY('chattexty', 'chatText', targetLol + 63, crochet/1000*4, 'quadOut')
   end
   if curStep == 128 then
      setProperty('googleWave.visible', true)
   end
   if curStep == 176 then
      doTweenAlpha('camHUD', 'camHUD', 1, 1)
   end
   if curStep == 256 then
      doTweenAlpha("goneCoverBg", "coverBg", 0, 1, "quadOut")
      easeBloom(0.05, 1, 'quadOut') -- will lag
      setProperty('iconSpeed', 2)
   end
   if curStep == 512 then
      setProperty('iconSpeed', 1)
   end
   if curStep == 1008 then
      doTweenAlpha("goneCoverBg", "coverBg", 1, 0.4)
   end
   if curStep == 1024 then
      setProperty('iconSpeed', 4)
      setBloom(0)
      doTweenAlpha("goneCoverBg", "coverBg", 0, 4)
      if HardMode then
         setProperty("bg.color", getColorFromHex("FFFFFF"))
         setProperty("blueOverlay.visible", true)
         setProperty("whiteOverlay.visible", true)
         loadGraphic("chatBox", folder.."GoogleBoxW")
         setTextColor("chatText", "000000")
         setTextColor("chatTextFX", "000000")
      else
         setProperty("bg.color", getColorFromHex("202124"))
         setProperty("blueOverlay.visible", false)
         setProperty("whiteOverlay.visible", false)
         loadGraphic("chatBox", folder.."GoogleBoxB")
         setTextColor("chatText", "FFFFFF")
         setTextColor("chatTextFX", "FFFFFF")
      end
      --cameraFlash("other", "000000", 8, true)
      if HardMode then setProperty('camHUD.alpha', 0.5) end
      setProperty('flashBlack.alpha', 1)
      doTweenAlpha('flashBlack', 'flashBlack', 0, 8, 'linear')
      if shadersEnabled then
         setShaderFloat("radialBlurEffect", "blurWidth", -0.026)
      end
   end
   if curStep == 1824 then
      setProperty('iconSpeed', 1)
      if HardMode then
         setProperty("bg.color", getColorFromHex("202124"))
         setProperty("blueOverlay.visible", false)
         setProperty("whiteOverlay.visible", false)
         loadGraphic("chatBox", folder.."GoogleBoxB")
         setTextColor("chatText", "FFFFFF")
         setTextColor("chatTextFX", "FFFFFF")
      else
         setProperty("bg.color", getColorFromHex("FFFFFF"))
         setProperty("blueOverlay.visible", true)
         setProperty("whiteOverlay.visible", true)
         loadGraphic("chatBox", folder.."GoogleBoxW")
         setTextColor("chatText", "000000")
         setTextColor("chatTextFX", "000000")
      end
      cameraFlash("other", "0xF0FFFFFF", 1, true)
      if HardMode then setProperty('camHUD.alpha', 1) end
      setProperty('camHUD.x', 0); setProperty('camHUD.y', 0)
      if shadersEnabled then
         setShaderFloat("radialBlurEffect", "blurWidth", 0)
      end
   end
   if curStep == 1792 then
      doTweenAlpha("goneCoverBg", "coverBg", 1, 0.4)
      doTweenX("camHUDX", "camHUD", 0, 1, 'quadOut')
      doTweenAngle("camHUDA", "camHUD", 0, 1, 'quadOut')
      doTweenAngle("camGA", "googleCam", 0, 1, 'quadOut')
      doTweenAngle("camGH", "googleHUD", 0, 1, 'quadOut')
      doTweenAngle("camGW", "googleWave", 0, 1, 'quadOut')
   end
   if curStep == 1824 then
      doTweenAlpha("goneCoverBg", "coverBg", 0, 0.4)
   end
   if curStep == 2336 then
      doTweenX("camHUDX", "camHUD", 0, 1, 'quadOut')
      doTweenAngle("camHUDA", "camHUD", 0, 1, 'quadOut')
      doTweenAngle("camGA", "googleCam", 0, 1, 'quadOut')
      doTweenAngle("camGH", "googleHUD", 0, 1, 'quadOut')
      doTweenAngle("camGW", "googleWave", 0, 1, 'quadOut')

      for i = 0, 7 do
         setPropertyFromGroup("strumLineNotes", i, 'x', defaultNote[i+1].x)
      end
   end

   if curStep == 2384 then
      setProperty('iconSpeed', 4)
      setTextString("chatText", "Nice!!")
      dadSingTimer = -5
      cameraFlash("camHUD", "0xF0FFFFFF", 3, true)
   end
end

function onBeatHit()
   circleFlash(true)
end

function endChat()
   setTextString("chatTextFX", getTextString("chatText"))
   setTextString("chatText", "(listening...)")

   setProperty("chatTextFX.y", getProperty("chatText.y"))
   setProperty("chatTextFX.alpha", 1)
   doTweenY("chatSendY", "chatTextFX", getProperty("chatText.y") - 50, 1, "quadOut")
   doTweenAlpha("chatSendAl", "chatTextFX", 0, 1, "linear")

end

function onTweenCompleted(tag) 
   if string.find(tag, "circleBG") then
      for i,v in pairs(circles) do
         if v.tag == tag then 
            table.remove(circles, i) 
            removeLuaSprite(tag)
            break;
         end
      end
   end
   -- if string.find(tag, "googleParticle") then
   --    removeLuaSprite(tag)
   -- end
   if string.find(tag, "googleBeatSquare") then
      removeLuaSprite(tag)
   end
   if tag == 'bloomtween' then
      bloomTween = false
   end
end

function goodNoteHit(id, dir, type, sus)
   sing(true ,id, dir, type, sus)
end
function opponentNoteHit(id, dir, type, sus)
   sing(false ,id, dir, type, sus)

   local texter = "chatText"

   if getTextString(texter) == "(listening...)" or getProperty(texter..".textField.numLines") > 2 then setTextString(texter, "") end

   local dontSing = lastStrumTime[1] == getPropertyFromGroup("notes", id, "strumTime")
   local numVocalName = "dadNumVocal"

   local empty = (#getTextString(texter) < 1)

   lastStrumTime[1] = getPropertyFromGroup("notes", id, "strumTime")

   if dontSing then return end

   local time = getPropertyFromGroup("notes", id, "strumTime")+1
   local data = 1
   local isFound = false
   local vocalsN = vocalsNotes.dad 

   for i,v in pairs(vocalsN) do 
       if v.time <= time then 
           data = v.data + 1
           isFound = true
           break
       end
   end

   if true then 
       _G[numVocalName] = getPropertyFromGroup("notes", id, "singData")+1
        if _G[numVocalName] == nil or _G[numVocalName] <= 0 then
            _G[numVocalName] = 1
        end
   end

   local isEnd = not getPropertyFromGroup("notes",id,"nextNote.isSustainNote") and getPropertyFromGroup("notes",id, "isSustainNote")
      local notSusAtAll = (not getPropertyFromGroup("notes",id,"nextNote.isSustainNote")) and (not getPropertyFromGroup("notes",id, "isSustainNote"))

      local singTexts = vocals[1][_G[numVocalName]]
      local text = singTexts[(isEnd and 3 or (sus and 2 or 1))]
      text = (isEnd or not sus) and (text[getRandomInt(1, #text)]) or text
      text = text .. (notSusAtAll and singTexts[2]..singTexts[3][1] or "")
      setTextString(texter, getTextString(texter)..((empty or sus) and "" or " ")..text)

      --{{{"ee"}, "e", {''}}, {{"oo"}, "o", {''}}, {{"aa"}, "a", {"h"}}, {{"e"}, "e", {"h"}}}

   dadSingTimer = 0
end

function readyVideo()
   runHaxeCode([[
       video = new FlxVideoSprite(0, 0);
       video.antialiasing = true;
       video.bitmap.onFormatSetup.add(function()
           {
               video.setGraphicSize(FlxG.width, FlxG.height);
               video.updateHitbox();
               video.screenCenter();
               video.camera = googleCam;
           });
       video.bitmap.onEndReached.add(function(){
            game.setOnLuas('inCutscene', false);
           video.destroy();
       });
       video.autoPause = false;
       video.load(Paths.video("Google Cutscene"));
       game.add(video);
       video.pause();

       setVar('video', video);
   ]])
end


inCutscene = false
function onSongStart()
   inCutscene = true
   runHaxeCode([[
      video.play();
   ]])
   setObjectOrder('video', getObjectOrder("coverBg")+1)

   doTweenAlpha('camHUD', 'camHUD', 0, 1)
   setObjectCamera("songLogo", 'camOther')
   setObjectCamera("songTitle", 'camOther')
   setObjectCamera("songDiff", 'camOther')
   setObjectCamera("songDesc", 'camOther')
end

local inPause = false
function onFocus()
    if inCutscene and not inPause then
        runHaxeCode('video.resume();')
    end
end
function onFocusLost()
    if inCutscene and not inPause then
        runHaxeCode('video.pause();')
    end
end
function onPause()
    inPause = true
    if inCutscene then
        runHaxeCode('video.pause();')
    end
end
function onResume()
    inPause = false
    if inCutscene then
        runHaxeCode('video.resume();')
    end
end

function onDestroy()
    runHaxeCode([[
      if (video != null)
         video.destroy();
   ]])
   setPropertyFromClass("ClientPrefs", "middleScroll", defaultMiddle)
end

function lerp(a, b, t) return a + (b - a) * t end
function con_sin(x) return math.sin((x%1)*2*math.pi) end
function con_cos(x) return math.cos((x%1)*2*math.pi) end