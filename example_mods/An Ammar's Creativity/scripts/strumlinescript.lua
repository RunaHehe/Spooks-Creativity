local directions = {'left', 'down', 'up', 'right'};
local strumSong;
strumData = {}

function toBool(str)
	return str:lower() == 'true';
end

function splitLuaText(s, delimiter)
    result = {};
    for token in s:gmatch("[^"..delimiter.."]+") do
   		table.insert(result, token)
    end
    return result;
end

function strumCallScripts(functionName, args)
	callScript('data/'..strumSong..'/strumline', functionName, args);
	callScript('scripts/strumline/script', functionName, args);
end

function loadSongData()
	local text;
	if checkFileExists('data/strumData.txt') then
		if checkFileExists('data/'..strumSong..'/strumData.txt') then
			text = getTextFromFile('data/'..strumSong..'/strumData.txt');
		else
			text = getTextFromFile('data/strumData.txt');
		end
	else
		if checkFileExists('data/'..strumSong..'/strumData.txt') then
			text = getTextFromFile('data/'..strumSong..'/strumData.txt');
		else
			return {['alreadyVisible'] = 'false'}
		end
	end

	local splitTable = splitLuaText(text, '\n');
	local dum = {}

	for stupid, str in pairs(splitTable) do
		if stupid ~= #splitTable then 
			str = str:sub(1, -2);
		end

		str = splitLuaText(str, ':');
		dum[str[1]] = str[2];
	end

	splitTable = nil;
	return dum;
end

function generateStaticArrows()
    local alreadyVisible = strumData['alreadyVisible'] or 'true';
    addHaxeLibrary('Std');

    runHaxeCode([[
		var version = Std.int(StringTools.replace(StringTools.replace("]]..version..[[", '.', ''), 'h', '.1'));
		game.setOnLuas('convertedVersion', version);

		if (version<61)
		{
			return;
		}

        for (i in 0...8)
        {
            var spr = game.strumLineNotes.members[i];
            spr.setGraphicSize(spr.width / 0.7 * 0.65);
            spr.updateHitbox();

	    	var seperation = FlxG.width / 2;
	    	if (i > 3)
				seperation += FlxG.width / 3;
        }

		var stupidList = ['left', 'down', 'up', 'right']; // God forgive me :(

        for (i in 0...4)
        {
            var babyArrow = new StrumNote(0, game.strumLine.y, i + 4, 0);

			if (version<063)
			{
				babyArrow.animation.addByPrefix('static', 'arrow' + stupidList[i].toUpperCase());
				babyArrow.animation.addByPrefix('pressed', stupidList[i]+' press', 24, false);
				babyArrow.animation.addByPrefix('confirm', stupidList[i]+' confirm', 24, false);
			}

			babyArrow.downScroll = ClientPrefs.downScroll;
			game.opponentStrums.add(babyArrow);
			game.strumLineNotes.insert(4+i, babyArrow);
			babyArrow.postAddedToGroup();

			babyArrow.visible = false;
			babyArrow.x -= FlxG.width;
			babyArrow.setGraphicSize(babyArrow.width / 0.7 * 0.65);
			babyArrow.updateHitbox();
        }

        for (note in game.unspawnNotes)
        {
			if (note.isSustainNote) 
			{
				note.setGraphicSize(note.width / 0.7 * 0.65, note.height);
			}
			else 
			{
				note.setGraphicSize(note.width / 0.7 * 0.65);
			}
            note.updateHitbox();
        }

		game.singAnimations = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT', 'singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];
    ]])

    if toBool(alreadyVisible) then
		callScript('scripts/strumlineAnims', 'returnAnim', {strumData['animationType'] or 'left'});
    end

    if convertedVersion < 63 then
		addLuaScript('scripts/strumlineCompat/062');
		
		if convertedVersion > 60 then
			if luaDebugMode then
			end
		else
			debugPrint('DEPRECATED! Update to a Psych Engine version that uses HScript technology (or use an older version).\nI would suggest using 0.6.3, but older versions such as 0.6.1 or 0.6.2 work too!')
		end
    end
end

function onCreatePost()
    luaDebugMode = true; -- Seen any issues? Report them on the GameBanana page!
    strumSong = songName:lower():gsub(" ", "-");
	strumData = loadSongData();
    generateStaticArrows();
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Third Player Note' then
		strumCallScripts('strumNoteHit', {id, direction, isSustainNote});
	end
end