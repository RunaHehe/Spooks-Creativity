function onCreate() -- backwards compatibility
    runHaxeCode([[
        for (note in game.unspawnNotes)
        {
            if (note.noteType == 'plr3')
            {
                note.noteType == 'Third Player Note';
		note.noteData += 4;
		note.mustPress = false;
                note.noAnimation = true;
            }
        }
    ]])
end