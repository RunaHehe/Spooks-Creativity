defaultNotes = {}
noteYPlace = {50,570}
noteSpace = 0;
noteSize = 0;

camShake = 0

spriteGlitchy = "before"
healthDrain = 0.01
textDistraction = false

bfDoGlitch = false

bfIcon = ""
shaky = 0 

songStart = false

beatHard = false
local mechanic = false
function onCreate()
  -- addLuaScript("custom_events/zCameraFix")
  luaDebugMode= true
  setProperty("skipCountdown", true)
 
end

function onCreatePost()
   mechanic = getDataFromSave("ammarc", "mechanic")
   makeAnimatedLuaSprite('static','skybg/staticbg',-1361.1,-681)
	addAnimationByPrefix('static','static','staticbg',24,true)
	addLuaSprite('static', true)
	playAnim('static','static',true)
	setBlendMode('static','multiply')
   if mechanic then
	   setObjectCamera("static", "other")
   else 
      setObjectCamera("static", "hud")
      setObjectOrder("static", 1)
   end
	
	setProperty('static.alpha',0.2)

   makeLuaSprite("rgbBG", "", -200, 0)
   makeGraphic("rgbBG", 1280, 720, "0x00FFFFFF")
   addLuaSprite("rgbBG")
   setProperty("rgbBG.alpha", 0)
  
   setScrollFactor("rgbBG",0 ,0)
   setProperty("rgbBG.flipY", true)
   if not mechanic then 
      setObjectCamera("rgbBG", "hud")
      setObjectOrder("rgbBG", 0)
   else 
      setObjectCamera("rgbBG", "game")
   end

   makeLuaSprite("rgb1", "", 0, 0)
   makeGraphic("rgb1", 1280, 720, "0x00FFFFFF")
   setProperty("rgb1.alpha", 0)
   setObjectCamera("rgb1", "other")

   makeLuaSprite("rgb2", "", 0, 0)
   makeGraphic("rgb2", 1280, 720, "0x00FFFFFF")
   setProperty("rgb2.alpha", 0)
   setObjectCamera("rgb2", "other")

   if mechanic then 
      addLuaSprite("rgb1")
    addLuaSprite("rgb2")
   end

   setBlendMode("rgbBG", "ADD")
   setBlendMode("rgb2", "add")
   setBlendMode("rgb1", "add")
   --screenCenter("testSprite")

   addHaxeLibrary("FlxSpriteUtil" ,"flixel.util")

   setTiru("rgbBG", false)
   setTiru("rgb2", true)
   setTiru("rgb1", true)

   

   makeLuaSprite("blackBF", "", 0, 0)
   makeGraphic("blackBF", getProperty("boyfriend.width"), getProperty("boyfriend.height"), "000000")
   addLuaSprite("blackBF", true)
   setProperty("blackBF.alpha", 0)
   setObjectCamera("blackBF", "game")
   setProperty("blackBF.x", getProperty("boyfriend.x") - (getProperty("boyfriend.width") / 2))
   setProperty("blackBF.y", getProperty("boyfriend.y") - (getProperty("boyfriend.height") / 2) + 50)

   makeLuaSprite("whiteFlash", "", -500, -500)
   makeGraphic("whiteFlash", 2000, 1300, "0xFFFFFFFF")
   addLuaSprite("whiteFlash", true)
   setProperty("whiteFlash.alpha", 0)
   setScrollFactor("whiteFlash",0 ,0)


   makeLuaSprite("noteSpeedP", "", 1, 0)
   makeGraphic("noteSpeedP", 1, 1, "0x00FFFFFF")

   makeLuaSprite("noteSpeedE", "", 1, 0)
   makeGraphic("noteSpeedE", 1, 1, "0x00FFFFFF")

   bfIcon = getProperty("iconP1.char")

   setPropertyFromClass('GameOverSubstate', "deathSoundName", "fnf_loss_sfx")
   setPropertyFromClass('GameOverSubstate', "loopSoundName", "gameOver")
   setPropertyFromClass('GameOverSubstate', "endSoundName", "gameOverEnd")
   setPropertyFromClass('GameOverSubstate', "characterName", "bf-pixel-dead")

end

function onSongStart()
   for note = 0, 7 do 
      local _x = getPropertyFromGroup("strumLineNotes", note, "x")
      local _y = getPropertyFromGroup("strumLineNotes", note, "y")
      local _s = getPropertyFromGroup("strumLineNotes", note, "scale")
      table.insert( defaultNotes, {_x , _y, _x})
   end
   noteSpace = defaultNotes[2][1] - defaultNotes[1][1]
   noteSize = getPropertyFromGroup("strumLineNotes", 0, "width")
   songStart = true
end

function opponentNoteHit(id, direction, type, sus)
   if not sus then 
      camShake = camShake + 0.01
   else 
      camShake = camShake + 0.001
   end

   local hpp = getProperty("health")
   if not sus then
	   hpp = hpp - healthDrain
   end
   if hpp < 0.2 then 
      hpp = 0.2
   end

   setProperty("health", hpp)

   setGlitchy()

   local targetSpr = "rgb1"
   local bgSprite = "rgbBG"
   if not sus then 
     

     
      
      
     
      if getRandomBool(50) then targetSpr = "rgb2" end
      setTiru(targetSpr, true)  
      if getRandomBool(20) then 
         runTimer("RgbBG", 0.02)
      end
   end

    

   setProperty(targetSpr..".x", getProperty(targetSpr..".x") + getRandomFloat(-40, 40))
   setProperty(targetSpr..".alpha", 0.8)
   doTweenAlpha(targetSpr, targetSpr, 0, 0.2)
   doTweenX(targetSpr.."xx", targetSpr, 0, 0.2, "quadIn")

   
   setProperty(bgSprite..".x", getProperty(bgSprite..".x") + getRandomFloat(-60, 60))
   setProperty(bgSprite..".alpha", 0.8)
   doTweenAlpha(bgSprite, bgSprite, 0, 0.2)
   doTweenX(bgSprite.."xx", bgSprite, 0, 0.2, "quadIn")
end

function goodNoteHit(id, direction, type, sus)

   if bfDoGlitch then
      if getRandomBool(80) then setGlitchy() end
      local targetSpr = "rgb1"
      local bgSprite = "rgbBG"
      if not sus then 

        
         if getRandomBool(50) then targetSpr = "rgb2" end
         setTiru(targetSpr, true)  
         if getRandomBool(20) then 
            runTimer("RgbBG", 0.02)
         end
      end

      
      setProperty(targetSpr..".x", getProperty(targetSpr..".x") + getRandomFloat(-40, 40))
      setProperty(targetSpr..".alpha", 0.8)
      doTweenAlpha(targetSpr, targetSpr, 0, 0.2)
      doTweenX(targetSpr.."xx", targetSpr, 0, 0.2, "quadIn")

      
      setProperty(bgSprite..".x", getProperty(bgSprite..".x") + getRandomFloat(-60, 60))
      setProperty(bgSprite..".alpha", 0.8)
      doTweenAlpha(bgSprite, bgSprite, 0, 0.2)
      doTweenX(bgSprite.."xx", bgSprite, 0, 0.2, "quadIn")
   end
end

function onBeatHit()
   if curBeat == 140 then 
      for data = 0, 3 do 
         --setPropertyFromGroup("strumLineNotes", data, "downScroll", true)
         noteTweenX("noteGoX"..data, data, 40, 1, "elasticOut")
         noteTweenDirection("noteGoDir"..data, data, (downscroll and 180 or 0), 1, "elasticOut")
         noteTweenY("noteGoY"..data, data, 120 + ((4 - (data+1)) * noteSpace), 1, "elasticOut")
         noteTweenAngle("noteGoAn"..data, data, -90, 1, "elasticOut")
         noteTweenAlpha("noteGoAl"..data, data, 0.35, 1, "linear")
      end

      for data = 4, 7 do 
         --setPropertyFromGroup("strumLineNotes", data, "downScroll", false)
         noteTweenX("noteGoX"..data, data, 1280 - 120, 1, "elasticOut")
         noteTweenDirection("noteGoDir"..data, data, (downscroll and 0 or -180), 1, "elasticOut")
         noteTweenY("noteGoY"..data, data, 120 + (data%4 * noteSpace), 1, "elasticOut")
         noteTweenAngle("noteGoAn"..data, data, 90, 1, "elasticOut")
      end
   end
   if curBeat == 172 then 
      for data = 0, 7 do 
         --setPropertyFromGroup("strumLineNotes", data, "downScroll", true)
         noteTweenX("noteGoX"..data, data, defaultNotes[data + 1][1], 1, "elasticOut")
         noteTweenAngle("noteGoAn"..data, data, 0, 1, "elasticOut")
         noteTweenAlpha("noteGoAl"..data, data, 1, 1, "linear")
         noteTweenDirection("noteGoDir"..data, data, 90, 1, "elasticOut")
      end

      for data = 0, 3 do 
         noteTweenY("noteGoY"..data, data, noteYPlace[(downscroll and 1 or 2)], 1, "elasticOut")
      end

      for data = 4, 7 do 
         noteTweenY("noteGoY"..data, data, noteYPlace[(downscroll and 2 or 1)], 1, "elasticOut")
      end

   end
   if curBeat >= 172 and curBeat < 204 then 
      local duration = 0.6
      if curBeat % 4 == 0 then
         for data = 0, 3 do 
            noteTweenY("noteGoY"..data, data, noteYPlace[(downscroll and 1 or 2)], duration, "elasticOut")  
         end
         for data = 4, 7 do 
            noteTweenY("noteGoY"..data, data, noteYPlace[(downscroll and 2 or 1)], duration, "elasticOut")
         end

         doTweenX("noteSpeedE", "noteSpeedE", -1, duration, "elasticOut")
         doTweenX("noteSpeedP", "noteSpeedP", 1, duration, "elasticOut")
      elseif curBeat % 4 == 2 then 
         for data = 0, 3 do 
            noteTweenY("noteGoY"..data, data, noteYPlace[(downscroll and 2 or 1)], duration, "elasticOut")
         end
         for data = 4, 7 do 
            noteTweenY("noteGoY"..data, data, noteYPlace[(downscroll and 1 or 2)], duration, "elasticOut")
         end
         doTweenX("noteSpeedE", "noteSpeedE", 1, duration, "elasticOut")
         doTweenX("noteSpeedP", "noteSpeedP", -1, duration, "elasticOut")
      end

   end
   if curBeat == 206 then 
      local theY = 720/2
      local centerX = 1280/2
      local duration = 1
      local placement = 
      { -- X , Y , DIRECTION
      {centerX - 60, theY, 180}, --PLAYER
      {centerX, theY + 60, 90}, 
      {centerX, theY - 60, -90}, 
      {centerX + 60 ,theY, 0}
      }
      for data = 0,7 do 
         local _X = placement[data%4 + 1][1] - noteSize/2
         local _Y = placement[data%4 + 1][2] - noteSize/2
         setPropertyFromGroup("strumLineNotes", data, "downScroll", false)
         noteTweenY("noteGoY"..data, data, _Y, duration, "elasticOut")
         noteTweenX("noteGoX"..data, data, _X, duration, "elasticOut")
         if downscroll then
            setPropertyFromGroup("strumLineNotes", data, "direction", getPropertyFromGroup("strumLineNotes", data, "direction") + 180)
         end
         noteTweenDirection("noteGoDir"..data, data, placement[data%4 + 1][3], duration*0.5, "linear")

         if data < 4 then 
            setPropertyFromGroup("strumLineNotes", data, "alpha", 0.2)
         end
      end

      doTweenX("noteSpeedE", "noteSpeedE", 1, duration, "linear")
      doTweenX("noteSpeedP", "noteSpeedP", 1, duration, "linear")

      setProperty("songSpeed", scrollSpeed * 0.7)
   end
   if curBeat >= 268 and curBeat < 332 then 
      if curBeat % 8 == 0 then 
         local duration = 1;
         for data = 0, 7 do 
            setPropertyFromGroup("strumLineNotes", data, "downScroll", downscroll)
            noteTweenX("noteGoX"..data, data, defaultNotes[data + 1][1], duration, "elasticOut")
            noteTweenY("noteGoY"..data, data, defaultNotes[data + 1][2], duration, "elasticOut")
            noteTweenAngle("noteGoAn"..data, data, 0, duration, "elasticOut")
            noteTweenAlpha("noteGoAl"..data, data, 1, duration, "linear")
            noteTweenDirection("noteGoDir"..data, data, 90, duration, "elasticOut")
         end
         doTweenX("noteSpeedE", "noteSpeedE", 1, duration, "elasticOut")
         doTweenX("noteSpeedP", "noteSpeedP", 1, duration, "elasticOut")
      end
      if curBeat % 8 == 2 then 
         local duration = 1;
         for data = 0, 3 do 
            setPropertyFromGroup("strumLineNotes", data, "downScroll", downscroll)
            noteTweenX("noteGoX"..data, data, 40, duration, "elasticOut")
            noteTweenDirection("noteGoDir"..data, data, (downscroll and 180 or 0), duration, "elasticOut")
            noteTweenY("noteGoY"..data, data, 120 + ((4 - (data+1)) * noteSpace), duration, "elasticOut")
            noteTweenAngle("noteGoAn"..data, data, -90, duration, "elasticOut")
            noteTweenAlpha("noteGoAl"..data, data, 0.35, duration, "linear")
         end
   
         for data = 4, 7 do 
            --setPropertyFromGroup("strumLineNotes", data, "downScroll", false)
            noteTweenX("noteGoX"..data, data, 1280 - 120, duration, "elasticOut")
            noteTweenDirection("noteGoDir"..data, data, (downscroll and 0 or -180), duration, "elasticOut")
            noteTweenY("noteGoY"..data, data, 120 + (data%4 * noteSpace), duration, "elasticOut")
            noteTweenAngle("noteGoAn"..data, data, 90, duration, "elasticOut")
         end

         doTweenX("noteSpeedE", "noteSpeedE", 1, duration, "elasticOut")
         doTweenX("noteSpeedP", "noteSpeedP", 1, duration, "elasticOut")
      end
      if curBeat % 8 == 4 then 
         local duration = 1;
         for data = 0, 7 do 
            --setPropertyFromGroup("strumLineNotes", data, "downScroll", true)
            noteTweenX("noteGoX"..data, data, defaultNotes[data + 1][1], duration, "elasticOut")
            noteTweenAngle("noteGoAn"..data, data, 0, duration, "elasticOut")
            noteTweenAlpha("noteGoAl"..data, data, 1, duration, "linear")
            noteTweenDirection("noteGoDir"..data, data, 90, duration, "elasticOut")
         end
         for data = 0, 3 do 
            noteTweenY("noteGoY"..data, data, noteYPlace[(downscroll and 1 or 2)], duration, "elasticOut")  
         end
         for data = 4, 7 do 
            noteTweenY("noteGoY"..data, data, noteYPlace[(downscroll and 2 or 1)], duration, "elasticOut")
         end

         doTweenX("noteSpeedE", "noteSpeedE", -1, duration, "elasticOut")
         doTweenX("noteSpeedP", "noteSpeedP", 1, duration, "elasticOut")
      end
      if curBeat % 8 == 6 then 
         local theY = 720/2
         local centerX = 1280/2
         local duration = 1
         local placement = 
         { -- X , Y , DIRECTION
         {centerX - 60, theY, 180}, --PLAYER
         {centerX, theY + 60, 90}, 
         {centerX, theY - 60, -90}, 
         {centerX + 60 ,theY, 0}
         }
         for data = 0,7 do 
            local _X = placement[data%4 + 1][1] - noteSize/2
            local _Y = placement[data%4 + 1][2] - noteSize/2
            setPropertyFromGroup("strumLineNotes", data, "downScroll", false)
            noteTweenY("noteGoY"..data, data, _Y, duration, "elasticOut")
            noteTweenX("noteGoX"..data, data, _X, duration, "elasticOut")
            if downscroll then
               setPropertyFromGroup("strumLineNotes", data, "direction", getPropertyFromGroup("strumLineNotes", data, "direction") + 180)
            end
            noteTweenDirection("noteGoDir"..data, data, placement[data%4 + 1][3], duration*0.4, "linear")
   
            if data < 4 then 
               setPropertyFromGroup("strumLineNotes", data, "alpha", 0.2)
            end
         end
      end
   end
   if curBeat == 332 then 
      for data = 0, 7 do 
         --setPropertyFromGroup("strumLineNotes", data, "downScroll", true)
         noteTweenX("noteGoX"..data, data, defaultNotes[data + 1][1], 1, "elasticOut")
         noteTweenY("noteGoY"..data, data, defaultNotes[data + 1][2], 1, "elasticOut")
         noteTweenAngle("noteGoAn"..data, data, 0, 1, "elasticOut")
         noteTweenAlpha("noteGoAl"..data, data, 1, 1, "linear")
         noteTweenDirection("noteGoDir"..data, data, 90, 1, "elasticOut")
      end
   end
   if curBeat == 140 or curBeat == 332 then 
      textDistraction = true
   end
   if curBeat == 204 or curBeat == 400 then 
      textDistraction = false
   end
   if curBeat == 332 then 
      bfDoGlitch = true
   end
   if curBeat == 140 then 
      shaky = 0.005
   end
   if curBeat == 332 then 
      shaky = 0.018
   end
   if curBeat == 204 or curBeat == 400 then 
      shaky = 0
   end

   if curBeat == 72 or curBeat == 140 or curBeat == 206 or curBeat == 332 then 
      flash(3)
      beatHard = true
   end
   if curBeat == 136 or curBeat == 204 or curBeat == 396 then 
      beatHard = false
   end
   if curBeat == 268 then 
      cameraFlash("game", "0xFFffffff", 2)
      flash(2)
      beatHard = false

      setProperty('songSpeed', scrollSpeed)
   end
   if textDistraction and mechanic then
      if curBeat % 2 == 0 then
         runHaxeCode([[
         game.addTextToDebug("Error loading lua script: Die.lua", 0xFFff0000);
         ]])
      else 
         runHaxeCode([[
            game.addTextToDebug("deleteFile: Error trying to delete Friday Night Funkin': Psych Engine : at Line 19902542095824592", 0xFFff0000);
         ]])
      end
   end
   if beatHard then 
      triggerEvent("Add Camera Zoom", 0.015 * 3, 0.03 * 3)
      setProperty("bg.color", getColorFromHex("404040"))
      doTweenColor("bg", "bg", "FFFFFF", crochet/1000)

      setProperty("camOther.angle", (curBeat % 2 == 0 and -10 or 10))
      doTweenAngle('canOteh', "camOther", 0, crochet/1000, "quadOut")
   end
end

canGameX = 0
canGameY = 0
canHUDX = 0
canHUDY = 0
function onUpdatePost(elasped)
   camShake = lerp(camShake, 0, elasped * 6)
   local resultShake = camShake + shaky
   
   canGameX = 0.5 * getPropertyFromClass("flixel.FlxG", "width") * (1 - getProperty("camGame.zoom")) * getPropertyFromClass("flixel.FlxG", "scaleMode.scale.x")
   canGameY = 0.5 * getPropertyFromClass("flixel.FlxG", "height") * (1 - getProperty("camGame.zoom")) * getPropertyFromClass("flixel.FlxG", "scaleMode.scale.y")
   canHUDX = 0.5 * getPropertyFromClass("flixel.FlxG", "width") * (1 - getProperty("camHUD.zoom")) * getPropertyFromClass("flixel.FlxG", "scaleMode.scale.x")
   canHUDY = 0.5 * getPropertyFromClass("flixel.FlxG", "height") * (1 - getProperty("camHUD.zoom")) * getPropertyFromClass("flixel.FlxG", "scaleMode.scale.y")
   if resultShake > 0 then 
      --cameraShake("game", resultShake, 0.01)
      --cameraShake("hud", resultShake/2, 0.01)
      local randomX =  getRandomFloat(-resultShake, resultShake) * 400
      local randomY =  getRandomFloat(-resultShake, resultShake) * 400
      setProperty("camGame.canvas.x", canGameX + randomX)
      setProperty("camGame.canvas.y", canGameY + randomY)

      if mechanic then
         setProperty("camHUD.canvas.x", canHUDX + -randomX)
         setProperty("camHUD.canvas.y", canHUDY + -randomY)
      end

      setProperty("camGame.canvas.rotation", randomX/6)
   end

   if not inGameOver then
      if getRandomBool(80) then 
         setProperty("static.flipX", getRandomBool(50))
      end
      if getRandomBool(80) then 
         setProperty("static.flipY", getRandomBool(50))
      end
      setProperty("static.animation.frameIndex", getProperty("static.animation.frameIndex") + getRandomInt(-2, 2))
   
   end

   for note = 1, getProperty("notes.length")-1 do 
      local theValue = (getPropertyFromGroup("notes", note, "mustPress") and getProperty("noteSpeedP.x") or getProperty("noteSpeedE.x"))
      setPropertyFromGroup("notes", note, "multSpeed", theValue)
   end
end

function setTiru(_spr, isCamHUD)
   local spr = _spr
   local cam = "game.camGame"
   if isCamHUD then cam = "game.camHUD" end
   runHaxeCode([[
      
      var cam = ]]..cam..[[;
      var sprite = game.getLuaObject("]].. spr ..[[", false);
      //game.addTextToDebug(cam, 0xFFff0000);
      FlxSpriteUtil.fill(sprite, 0x00);
      sprite.pixels.draw(cam.canvas);    

      if (FlxG.random.bool(33)) {
         sprite.color = 0xFFFF0000;
      }else if (FlxG.random.bool(33)) {
         sprite.color = 0xFF00FF00;
      }else {
         sprite.color = 0xFF0000FF;
      }
   ]])
end

function setGlitchy()
   cancelTimer("backNormal")
   setProperty("timeBar.scale.x", getRandomFloat(0.5, 1.5))
   setProperty("timeBarBG.scale.x", getRandomFloat(0.5, 1.5))
   setProperty("scoreTxt.scale.x", getRandomFloat(0.9, 1.2))
   setProperty("timeTxt.scale.x", getRandomFloat(0.9, 2))
   setProperty("timeTxt.text", "0:" .. getRandomInt(10, 59))
   setProperty("static.alpha", getRandomFloat(0.2, 0.8))
   if getRandomBool(10) then
      setProperty("blackBF.alpha", 1)
   end
   if getRandomBool(5) then 
      runHaxeCode([[
         game.iconP1.changeIcon("icons/icon-face");
      ]])
   end

   runTimer("backNormal", getRandomFloat(0.05, 0.20))
end

function flash(duration)
   cancelTween("flashWWW")
   setProperty("whiteFlash.alpha", 1)
   doTweenAlpha("flashWWW", "whiteFlash", 0 , duration)
end

function onTimerCompleted(tag, loop, loopLeft)
   if tag == "backNormal" then 
      setProperty("timeBar.scale.x", 1)
      setProperty("timeBarBG.scale.x", 1)
      setProperty("scoreTxt.scale.x", 1)
      setProperty("timeTxt.scale.x", 1)
      setProperty("blackBF.alpha", 0)
      setProperty("static.alpha", 0.2)

      runHaxeCode([[
         game.iconP1.changeIcon("]]..bfIcon..[[");
      ]])
   end
   if tag == "RgbBG" then 
      setTiru("rgbBG", false)
   end
end

function lerp(a, b, t)
	return a + (b - a) * t
end