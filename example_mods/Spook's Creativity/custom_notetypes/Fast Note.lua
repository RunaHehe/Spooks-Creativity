
local noteName = "Fast Note"
function onCreatePost()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == noteName then 
			--setPropertyFromGroup('unspawnNotes', i, 'multSpeed', 1.3)
		end
	end
end


