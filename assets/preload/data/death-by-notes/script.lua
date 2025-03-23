beatSpeed = 2;
spotsSide = {}
lightSpeed = 4
lightSideAlpha = 0;
lightSideAlphaIN = 0;
lightBeatSpeed = 4

local mechanic = false
function onCreatePost()
   mechanic = getDataFromSave("ammarc", "mechanic")

   precacheImage("deathNotes/" .. "remember1")
   precacheImage("deathNotes/" .. "remember2")
   precacheImage("deathNotes/" .. "remember3")
   precacheImage("deathNotes/" .. "remember4")
   precacheImage("deathNotes/" .. "remember4-5")

   makeLuaSprite("blackLight", "", 200, 0)
   makeGraphic("blackLight", 1800, 1000 ,"000000")
   addLuaSprite("blackLight")
   setProperty("blackLight.alpha", 0)
   setObjectOrder("blackLight", getObjectOrder("boyfriendGroup") - 2)

   createSpotLight("bfLight", getProperty("boyfriend.x") - 50 , getProperty("boyfriend.y") - 560, 1)
   setProperty("bfLight.alpha", 0)
   setObjectOrder("bfLight", getObjectOrder("boyfriendGroup") - 1)


   createSpotLight("leftLight", -300, 460, 0.8)
   setProperty("leftLight.origin.y", 0)
   setProperty("leftLight.angle", -90)
   setProperty("leftLight.alpha", 0)
   setObjectCamera("leftLight", "hud")
   setObjectOrder("leftLight", 100)


   createSpotLight("rightLight", 800 + 300, 460, 0.8)
   setProperty("rightLight.origin.y", 0)
   setProperty("rightLight.angle", 90)
   setProperty("rightLight.alpha", 0)
   setObjectCamera("rightLight", "hud")
   setObjectOrder("rightLight", 100)

   makeLuaSprite("rember", "deathNotes/remember1", 200, 0)
   scaleObject("rember", 0.8, 0.8)
   screenCenter("rember")
   addLuaSprite("rember")
   setProperty("rember.alpha", 0)
   setObjectCamera("rember", "hud")

   table.insert( spotsSide, "leftLight")
   table.insert( spotsSide, "rightLight")

   setProperty("camZooming", true)
end
function showRember(image)
   cancelTimer("runOutRember")
   cancelTween("forgot")
   loadGraphic("rember", "deathNotes/" .. image)

   setProperty("rember.alpha", 1)
   runTimer("runOutRember", 1.5)
end


function createSpotLight(tag, _x, _y, size)
   makeLuaSprite(tag, "spotlight", _x , _y)
   addLuaSprite(tag)
   scaleObject(tag, size, size)
end

function onStepHit()
   if mechanic then
      if curStep == 384 then 
         showRember("remember1")
      end
      if curStep == 448 then 
         showRember("remember2")
      end
      if curStep == 512 then 
         showRember("remember3")
      end
      if curStep == 576 then 
         showRember("remember4")
      end
      if curStep == 592 then 
         showRember("remember4-5")
      end
   end
   if curStep == 896 then 
      setProperty("blackLight.alpha", 0.6)
      setProperty("bfLight.alpha", 1)
   end

   if curStep == 1152 then 
      setProperty("blackLight.alpha", 0)
      setProperty("bfLight.alpha", 0)
   end

   if curStep == 880 then 
      beatSpeed = 2;
   end
   if curStep == 64 or curStep == 256 or curStep == 608 or curStep == 896 then 
      beatSpeed = 4
   end
   if curStep == 128 or curStep == 384 or curStep == 640 or curStep == 1152 then 
      beatSpeed = 8
   end

   if curStep == 127 or curStep == 895 then 
      lightSideAlpha = 0.5;
      lightSideAlphaIN = 0.1;
      lightBeatSpeed = 4
   end
   if curStep == 191 or curStep == 511 or curStep == 1151 then 
      lightSideAlpha = 0.5;
      lightSideAlphaIN = 0.1;
      lightBeatSpeed = 8
   end
   if curStep == 255 or curStep == 639 then 
      lightSideAlpha = 0.3;
      lightSideAlphaIN = 0;
      lightBeatSpeed = 2
   end
   if curStep == 383 or curStep == 631 or curStep == 879 or curStep == 1280 then 
      lightSideAlpha = 0;
      lightSideAlphaIN = 0;
   end

   if curStep % (32 / beatSpeed) == 0 and curStep % 16 ~= 0 then 
      triggerEvent("Add Camera Zoom", "", "")
   end

   if curStep % (32 / lightBeatSpeed) == 0 then 
      for i = 1, #spotsSide do 
         local light = spotsSide[i]
         setProperty(light .. ".alpha", lightSideAlpha)
         doTweenAlpha(light .. "Tween", light, lightSideAlphaIN, (crochet / 1000) / (lightBeatSpeed / 4), "sineIn")
         
      end
   end


   if curStep < 256 or (curStep >= 384 and curStep < 640) or curStep >= 1152 then 
      if curStep % 4 == 0 and mechanic then 
         runTimer("doneSpeed", crochet/1000/4)
         triggerEvent("Change Scroll Speed", 0.6, crochet/1000/4)
      end
   end
end 



beatElapsed = 0;
function onUpdatePost()
   beatElapsed = getSongPosition() / (crochet * 1000) * 90 * 4
   setProperty("leftLight.angle",  -90 + math.sin(beatElapsed * lightSpeed) * 20)
   setProperty("rightLight.angle",  90 + math.sin(beatElapsed * lightSpeed) * 20)

  
end

function onTimerCompleted(tag, loops, loopsLeft)
   if tag == "doneSpeed" then 
      triggerEvent("Change Scroll Speed", 1, crochet/1000/4 * 3)
   end
   if tag == "runOutRember" then 
      doTweenAlpha("forgot", "rember", 0, 0.4)
   end
end