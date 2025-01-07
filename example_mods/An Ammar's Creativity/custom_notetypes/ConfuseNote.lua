
strumXLeft = 1;
strumXRight = 10;
strumCenter = 0

local mechanic = false
function onSongStart()

end
function onCreatePost()
	mechanic = getDataFromSave("ammarc", "mechanic")
	if not mechanic then 
		close(true)
		return
	end
	for i=0,getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes',i,'noteType') == 'ConfuseNote' then
			setPropertyFromGroup("unspawnNotes", i, "colorSwap.brightness", 0)
			setPropertyFromGroup("unspawnNotes", i, "colorSwap.saturation", -1)
		end
	end
end
function onUpdatePost(elapsed)
	if mechanic then
		strumXLeft = getPropertyFromGroup("strumLineNotes", 4, "x")
		strumXRight = getPropertyFromGroup("strumLineNotes", 7, "x")
		strumCenter = (getPropertyFromGroup("strumLineNotes", 5, "x") + getPropertyFromGroup("strumLineNotes", 6, "x"))/2
		for i=0,getProperty('notes.length')-1 do
			if getPropertyFromGroup('notes',i,'noteType') == 'ConfuseNote' then
				local distance = -0.01 * (getSongPosition() - getPropertyFromGroup('notes',i,'strumTime'))
				local range = (strumXRight - strumXLeft)/8
				local addtoMid = 0
				addtoMid = strumCenter - (getPropertyFromGroup('notes',i,'x') - getPropertyFromGroup('notes',i,'offsetX'))
				
				setPropertyFromGroup('notes',i,'angle', distance * 100)
				
				
				if distance <= 1.5 then 
					setPropertyFromGroup('notes',i,'offsetX', lerp(getPropertyFromGroup('notes',i,'offsetX'), 0 , elapsed * 7 * scrollSpeed))
				else 
					setPropertyFromGroup('notes',i,'offsetX', addtoMid + math.sin(distance + getPropertyFromGroup('notes',i,'strumTime')) * range)
				end
			end
			
		end
	end
end

function lerp(a, b, t) return a + (b - a) * t end