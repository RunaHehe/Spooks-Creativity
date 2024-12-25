function onCreatePost()

	for i=0,getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes',i,'noteType') == 'Error Note' then
			setPropertyFromGroup('unspawnNotes',i,'ignoreNote', getPropertyFromGroup("unspawnNotes", i, "mustPress"))
			setPropertyFromGroup('unspawnNotes',i,'noAnimation', getPropertyFromGroup("unspawnNotes", i, "mustPress"))
			if getRandomBool(90) or not getPropertyFromGroup("unspawnNotes", i, "mustPress") then
				setPropertyFromGroup('unspawnNotes',i,'texture', 'ERRORNOTE_assets')
			end
			setPropertyFromGroup('unspawnNotes',i,'lateHitMult', 0.35)
			setPropertyFromGroup('unspawnNotes',i,'earlyHitMult', 0.35)
			if getPropertyFromGroup("unspawnNotes", i, "mustPress") then
				if getPropertyFromGroup('unspawnNotes',i,'isSustainNote') then 
					setPropertyFromGroup('unspawnNotes',i,'multAlpha', '0.4')
				else 
					setPropertyFromGroup('unspawnNotes',i,'multAlpha', '0.8')
				end
			end
		end
		
	end
end

function onUpdatePost()
	for note = 0, getProperty("notes.length")-1 do 
		if getPropertyFromGroup('notes',note,'noteType') == 'Error Note' and getPropertyFromGroup('notes',note,'distance') <= getRandomFloat(400, 600) * (downscroll and -1 or 1) then
			setPropertyFromGroup('notes',note,'texture', 'ERRORNOTE_assets')
		end
	end
end
function goodNoteHit(noteID, direction, noteType, sus)
	if noteType == "Error Note" then 
		if getProperty("health") > 0.2 then
			setProperty("health", -1)
			setGlobalFromScript("data/malfunction/script", "camShake", 0.5)
		else 
			setProperty("health", -1)
		end
		playSound("glitch", 1.5, "glitchyNote")
	end
end
