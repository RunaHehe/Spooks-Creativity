function onCreatePost()
    addHaxeLibrary('FlxSprite', 'flixel')
    addHaxeLibrary('FlxCamera', 'flixel')
    luaDebugMode = true


    runHaxeCode([[

        camNotes = new FlxCamera();
        camNotes.bgColor = 0x00;
        camNotesFake = new FlxCamera();
        camNotesFake.x = 0;
        camNotesFake.y = 0;
        camNotesFake.bgColor = 0x00;

        game.notes.cameras = [camNotes, camNotesFake];
        game.strumLineNotes.cameras = [camNotes, camNotesFake];
        game.grpNoteSplashes.cameras = [camNotes, camNotesFake];
        game.grpNoteHoldSplashes.cameras = [camNotes, camNotesFake];


        FlxG.cameras.remove(game.camOther, false);
        FlxG.cameras.remove(game.camHUD, false);
        FlxG.cameras.add(camNotesFake, false);
        FlxG.cameras.add(camNotes, false);
        FlxG.cameras.add(game.camHUD, false);
        FlxG.cameras.add(game.camOther, false);

        setVar('camNotes', camNotes);
        setVar('camNotesFake', camNotesFake);
    ]])

    setProperty("camNotesFake.visible", false)
    
end

function onUpdatePost(elapsed)
    setProperty('camNotes.zoom', getProperty('camHUD.zoom'))
end
