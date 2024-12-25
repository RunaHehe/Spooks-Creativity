function onCreatePost()
    if not hardmodeOption then
        for i = getProperty('unspawnNotes.length')-1, 0, -1  do
            if getPropertyFromGroup("unspawnNotes", i, "noteType") == "HARD NOTE"then
                removeFromGroup("unspawnNotes", i, true)
            end
        end
    end
end