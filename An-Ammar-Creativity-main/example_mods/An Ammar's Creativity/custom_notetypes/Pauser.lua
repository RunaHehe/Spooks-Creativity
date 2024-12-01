-- Idea by The Shade Lord
-- Executed by Double K

function onCreatePost()
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		local pauser = getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Pauser'
		if pauser then
			if getPropertyFromGroup('unspawnNotes', i, 'strumTime') < getPropertyFromGroup('unspawnNotes', i, 'strumTime') then -- this doesnt work, gonna have to desync your chart traditionally
				setPropertyFromGroup('unspawnNotess', i, 'strumTime', getPropertyFromGroup('unspawnNotes', i, 'strumTime') + stepCrochet * 2)
			end
		end
	end
end

function goodNoteHit(id, dir, nt, sus)
	for i = 0, getProperty('notes.length') - 1 do
		if nt == 'Pauser' then
			setPropertyFromClass('Conductor', 'songPosition', pos) 
			setPropertyFromGroup('notes', i, 'copyY', false)
			setPropertyFromGroup('notes', i, 'copyX', false)
			runTimer('UPNotes', (stepCrochet / 1000) * 2, 1)
			setPropertyFromGroup('notes', i, 'strumTime', getPropertyFromGroup('notes', i, 'strumTime') + stepCrochet * 2)
		end
	end
end

local pos = 0
function onUpdatePost(el)
	for i = 0, getProperty('notes.length') - 1 do
		local pauser = getPropertyFromGroup('notes', i, 'noteType') == 'Pauser'
		if pauser then
			local piss = pauser and (getPropertyFromGroup('notes', i, 'strumTime') - getSongPosition())
			pos = getSongPosition()
		end
	end
end

function onTimerCompleted(t)
	for i = 0, getProperty('notes.length') - 1 do
		if t == 'UPNotes' then
			setPropertyFromGroup('notes', i, 'copyY', true)
			setPropertyFromGroup('notes', i, 'copyX', true)
			setPropertyFromClass('Conductor', 'songPosition', getPropertyFromClass('flixel.FlxG', 'sound.music.time'))
		end
	end
end