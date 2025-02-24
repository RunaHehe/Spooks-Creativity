function onCreate()
    luaDebugMode = true;
    runHaxeCode([[
        for (note in game.unspawnNotes)
        {
            if (note.noteType == 'Third Player Note')
            {
                note.noteData += 4;
		note.mustPress = false;
                note.noAnimation = true;
            }
        }
    ]])
end