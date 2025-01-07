function onCreatePost()

	for i=0,getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes',i,'noteType') == 'MissNote' then
			setPropertyFromGroup('unspawnNotes',i,'ignoreNote',true)
			setPropertyFromGroup('unspawnNotes',i,'noAnimation',true)
			setPropertyFromGroup("unspawnNotes",i,"blockHit", true)
			
		end
		
	end

	
end
