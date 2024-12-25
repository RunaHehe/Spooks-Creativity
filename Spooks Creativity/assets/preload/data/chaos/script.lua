function onCreatePost()
   loadGraphic("chaos/jevil")
   luaDebugMode = true
   makeAnimatedLuaSprite('jevilBG','chaos/jevil',-600,-250)
   addAnimationByIndices('jevilBG','still','jailrevolving0','0',15)
   addAnimationByPrefix('jevilBG','vibe','jailrevolving0',15,true)
   addLuaSprite('jevilBG', false)
   scaleObject("jevilBG", 3, 3)
   
   playAnim("jevilBG", "still", true)
   setProperty("camGame.zoom", 1)

   setProperty("boyfriend.x", getProperty("boyfriend.x") + 300)
   setProperty("gf.x", getProperty("gf.x") - 420)
   setProperty("dad.visible", false)
   setProperty("defaultCamZoom", 0.6)
   setProperty("camFollow.x", 800 + 300)
end
function onUpdatePost()
   if curBeat >= 64 then
      setProperty("camFollow.x", 800)
      setProperty("camFollow.y", 454)
   end
end
function onBeatHit()
   if curBeat == 64 then 
      playAnim("jevilBG", "vibe", true)
      cameraFlash("game", "FFFFFF", 2)
      setProperty("camZooming", true)
   end
   if curBeat == 128 or curBeat == 160 or curBeat == 256 then 
      cameraFlash("game", "0x7DFFFFFF", 1)
   end
   if curBeat >= 64 then 
      triggerEvent("Add Camera Zoom", "", "")
   end
end