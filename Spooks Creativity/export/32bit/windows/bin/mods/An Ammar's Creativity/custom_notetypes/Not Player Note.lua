function onCountdownStarted()
	luaDebugMode = true
	if SpecialNotesOption then
		for i=0,getProperty('unspawnNotes.length')-1 do
			if getPropertyFromGroup('unspawnNotes',i,'noteType') == 'Not Player Note' then
				local data = getPropertyFromGroup("unspawnNotes", i, "noteData")
				local isSus = getPropertyFromGroup("unspawnNotes", i, "isSustainNote")
				if not getPropertyFromGroup("unspawnNotes", i, "mustPress") then
					if not middlescroll then
						setPropertyFromGroup("unspawnNotes", i, "offsetX", getPropertyFromGroup("strumLineNotes", data+4, 'x') - getPropertyFromGroup("strumLineNotes", data, 'x') + (isSus and 26 or 0))
					end
				end
			end
			
		end
	end
end

function onUpdate(elapsed)
	if SpecialNotesOption and not inGameOver then
		for note = 0, getProperty("notes.length")-1 do 
			local speed = getProperty('songSpeed') * getPropertyFromGroup('notes',note,'multSpeed')
			if getPropertyFromGroup('notes',note,'noteType') == 'Not Player Note' and math.abs(getPropertyFromGroup('notes',note,'distance')) <= 550/speed then
				setPropertyFromGroup("notes", note, "offsetX", lerp(getPropertyFromGroup("notes", note, 'offsetX'), 0, elapsed*speed*5))
			end
		end
	end
end


function lerp(a, b, t)
	return a + (b - a) * t
end