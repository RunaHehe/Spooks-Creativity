local safeZoneOffset = (10 / 60) * 1000;

function string.endsWith(str, ended)
	return str:sub(#str-#ended+1) == ended;
end

function strumCallScripts(functionName, args)
	callScript('data/'..songName:lower():gsub(" ", "-")..'/strumline', functionName, args);
	callScript('scripts/strumline/script', functionName, args);
end

function onCreatePost() -- blah blah backwards compatibility code
	for i=0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Third Player Note' then
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
		end
	end

	addHaxeLibrary('FlxRect', 'flixel.math');
	addHaxeLibrary('Note');
end

function onUpdate()

	local songPosition = getSongPosition();

	for i=0, getProperty('notes.length')-1 do
		if getPropertyFromGroup('notes', i, 'noteType') == 'Third Player Note' then

			local isSustainNote = getPropertyFromGroup('notes', i, 'isSustainNote');
			local noteData = getPropertyFromGroup('notes', i, 'noteData');
			local wasGoodHit = getPropertyFromGroup('notes', i, 'wasGoodHit');
			local mustPress = getPropertyFromGroup('notes', i, 'mustPress');
			local hitByOpponent = getPropertyFromGroup('notes', i, 'hitByOpponent');

			runHaxeCode([[
				var daNote = game.notes.members[]]..i..[[];
				var strumY = game.opponentStrums.members[daNote.noteData].y;
				var strumScroll = game.opponentStrums.members[daNote.noteData].downScroll;
				var center = strumY + Note.swagWidth / 2;

				if(game.opponentStrums.members[daNote.noteData].sustainReduce && daNote.isSustainNote && (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					if (strumScroll)
					{
						if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
							swagRect.height = (center - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;
							daNote.clipRect = swagRect;
						}
					}
					else
					{
						if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
							swagRect.y = (center - daNote.y) / daNote.scale.y;
							swagRect.height -= swagRect.y;
							daNote.clipRect = swagRect;
						}
					}
				}
			]])

			if (not mustPress) and wasGoodHit and not hitByOpponent then
				local time = 0.15;
				if isSustainNote and not getPropertyFromGroup('notes', i, 'animation.curAnim.name'):endsWith('end') then time = time + 0.15 end

				runHaxeCode([[
					var spr = game.strumLineNotes.members[]]..noteData..[[];
					spr.playAnim('confirm', true);
					spr.resetAnim = ]]..time..[[;
				]])

				setPropertyFromGroup('notes', i, 'hitByOpponent', true);
				strumCallScripts('strumNoteHit', {i, noteData, isSustainNote})

				if not isSustainNote then
					removeFromGroup('notes', i);
				end
			end
		end
	end
end