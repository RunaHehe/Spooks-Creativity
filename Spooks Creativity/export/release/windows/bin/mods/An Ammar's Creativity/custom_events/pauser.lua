--[[
folder = "youtube/"
eventOffset = {}





--EVENTS NOTE
--[[ 'eventNotes'
   strumTime
   event
   value1
   value2
]]
--[[
local mechanic = false
function onCreatePost()
   mechanic = getDataFromSave("ammarc", "mechanic")
   makeLuaSprite("pause", folder.."pause", 0 , 0)
   setScrollFactor("pause", 0 ,0)
   scaleObject("pause", 0.7, 0.7)
   setObjectCamera("pause", "hud")
   addLuaSprite("pause", true)
   screenCenter("pause")
   setProperty("pause.alpha", 0)
   

   makeLuaSprite("resume", folder.."resume", 0 , 0)
   setScrollFactor("resume", 0 ,0)
   scaleObject("resume", 0.7, 0.7)
   setObjectCamera("resume", "hud")
   addLuaSprite("resume", true)
   screenCenter("resume")
   setProperty("resume.alpha", 0)
   if not mechanic then 
      return
   else 
      for event = 0, getProperty('eventNotes.length') - 1 do
         local pauser = getPropertyFromGroup('eventNotes', event, 'event') == 'pauser'
         local eventtime = getPropertyFromGroup('eventNotes', event, 'strumTime')
         local time = getPropertyFromGroup('eventNotes', event, 'value1') 
         if pauser then
            local offse = (time * 450 * scrollSpeed) * (downscroll and 1 or -1)
            for note = 0, getProperty('unspawnNotes.length') - 1 do
               local strumTime = getPropertyFromGroup('unspawnNotes', note, 'strumTime')
               if eventtime < strumTime and getPropertyFromGroup('unspawnNotes', note, 'mustPress') then -- this doesnt work, gonna have to desync your chart traditionally
                  
                  
                  setPropertyFromGroup('unspawnNotes', note, 'offsetY', getPropertyFromGroup('unspawnNotes', note, 'offsetY') + offse)
                  
               end
            end
            table.insert( eventOffset, offse)
         end
      end
      setProperty("spawnTime", 10000)
   end
end

paused = false
function pause(isPause)
   paused = isPause
   cancelTween("goHideUIpause")
   setProperty("resume.alpha", 0)
   setProperty("pause.alpha", 0)

   if isPause then 
      setProperty("pause.alpha", 0.8)
      doTweenAlpha("goHideUIpause", "pause", 0, 0.5)
      setGlobalFromScript("data/hate-comment/youtube", "isPausing", true)
   else 
      setProperty("resume.alpha", 0.8)
      doTweenAlpha("goHideUIpause", "resume", 0, 0.5)
      setGlobalFromScript("data/hate-comment/youtube", "isPausing", false)
   end
end



curTime = 0
local pausing = false
function onEvent(name, value1, value2)
   if name == "pauser" and mechanic then 
      local time = value1 
      curTime = time
      --setPropertyFromClass('Conductor', 'songPosition', pos) 
      runTimer('UPNotes', time, 1)
      for i = 0, getProperty('notes.length') - 1 do
         if getPropertyFromGroup('notes', i, 'mustPress') then
            --setPropertyFromGroup('notes', i, 'y', getPropertyFromGroup('notes', i, 'y') + (time * 450 * scrollSpeed) * (downscroll and 1 or -1))
             setPropertyFromGroup('notes', i, 'copyY', false)
         end
      end
      pausing = true
      pause(true)
   end
	-- event note triggered
	-- triggerEvent() does not call this function!!

	-- print('Event triggered: ', name, value1, value2);
end

function onTimerCompleted(t)
	if t == 'UPNotes' then
      for i = 0, getProperty('notes.length') - 1 do
         if getPropertyFromGroup('notes', i, 'mustPress') then
            setPropertyFromGroup('notes', i, 'offsetY', getPropertyFromGroup('notes', i, 'offsetY') - eventOffset[1])
			   setPropertyFromGroup('notes', i, 'copyY', true)
         end
		end
      for i = 0, getProperty('unspawnNotes.length') - 1 do
         if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
            setPropertyFromGroup('unspawnNotes', i, 'offsetY', getPropertyFromGroup('unspawnNotes', i, 'offsetY') - eventOffset[1])
			   setPropertyFromGroup('unspawnNotes', i, 'copyY', true)
         end
		end
      table.remove( eventOffset, 1 )
      setPropertyFromClass('Conductor', 'songPosition', getPropertyFromClass('flixel.FlxG', 'sound.music.time'))
      pausing = false
      pause(false)
	end
end]]