function goodNoteHit(id, noteData, noteType, isSustainNote)

	-- directional movement
	--[[if noteData == 0 then
		noteTweenX('hitL', 4, defaultPlayerStrumX0 - 20, 0.1, 'sineIn')
		runTimer('returnL', 0.1, 1) 
	elseif noteData == 1 then
		noteTweenY('hitD', 5, defaultPlayerStrumY1 + 20, 0.1, 'sineIn')
		runTimer('returnD', 0.1, 1) 
	elseif noteData == 2 then
		noteTweenY('hitU', 6, defaultPlayerStrumY2 - 20, 0.1, 'sineIn')
		runTimer('returnU', 0.1, 1) 
	elseif noteData == 3 then
		noteTweenX('hitR', 7, defaultPlayerStrumX3 + 20, 0.1, 'sineIn')
		runTimer('returnR', 0.1, 1) 
	end]]

	-- directional movement [constant, will go offscreen if allowed]
	--[[if noteData == 0 then
		noteTweenX('hitL', 4, getPropertyFromGroup('playerStrums', noteData,'x') - 20, 0.1, 'sineIn')
		runTimer('returnL', 0.1, 1)
	elseif noteData == 1 then
		noteTweenY('hitD', 5, getPropertyFromGroup('playerStrums', noteData,'y') + 20, 0.1, 'sineIn')
		runTimer('returnD', 0.1, 1)
	elseif noteData == 2 then
		noteTweenY('hitU', 6, getPropertyFromGroup('playerStrums', noteData,'y') - 20, 0.1, 'sineIn')
		runTimer('returnU', 0.1, 1)
	elseif noteData == 3 then
		noteTweenX('hitR', 7, getPropertyFromGroup('playerStrums', noteData,'x') + 20, 0.1, 'sineIn')
		runTimer('returnR', 0.1, 1)
	end]]

	-- just up (no directions) make + for down
	if not downscroll then
		if noteData == 0 then
			noteTweenY('hitL', 4, defaultPlayerStrumY0 - 20, 0.1, 'sineIn')
			runTimer('returnL', 0.1, 1)
		elseif noteData == 1 then
			noteTweenY('hitD', 5, defaultPlayerStrumY1 - 20, 0.1, 'sineIn')
			runTimer('returnD', 0.1, 1)
		elseif noteData == 2 then
			noteTweenY('hitU', 6, defaultPlayerStrumY2 - 20, 0.1, 'sineIn')
			runTimer('returnU', 0.1, 1)
		elseif noteData == 3 then
			noteTweenY('hitR', 7, defaultPlayerStrumY3 - 20, 0.1, 'sineIn')
			runTimer('returnR', 0.1, 1)
		end
	else
		if noteData == 0 then
			noteTweenY('hitL', 4, defaultPlayerStrumY0 + 20, 0.1, 'sineIn')
			runTimer('returnL', 0.1, 1)
		elseif noteData == 1 then
			noteTweenY('hitD', 5, defaultPlayerStrumY1 + 20, 0.1, 'sineIn')
			runTimer('returnD', 0.1, 1)
		elseif noteData == 2 then
			noteTweenY('hitU', 6, defaultPlayerStrumY2 + 20, 0.1, 'sineIn')
			runTimer('returnU', 0.1, 1)
		elseif noteData == 3 then
			noteTweenY('hitR', 7, defaultPlayerStrumY3 + 20, 0.1, 'sineIn')
			runTimer('returnR', 0.1, 1)
		end
	end

	-- just up (no directions) make + for down [constant, will go offscreen if allowed]
	--[[if noteData == 0 then
		noteTweenY('hitL', 4, getPropertyFromGroup('playerStrums', noteData,'y') - 20, 0.1, 'sineIn')
		runTimer('returnL', 0.1, 1)
	elseif noteData == 1 then
		noteTweenY('hitD', 5, getPropertyFromGroup('playerStrums', noteData,'y') - 20, 0.1, 'sineIn')
		runTimer('returnD', 0.1, 1)
	elseif noteData == 2 then
		noteTweenY('hitU', 6, getPropertyFromGroup('playerStrums', noteData,'y') - 20, 0.1, 'sineIn')
		runTimer('returnU', 0.1, 1)
	elseif noteData == 3 then
		noteTweenY('hitR', 7, getPropertyFromGroup('playerStrums', noteData,'y') - 20, 0.1, 'sineIn')
		runTimer('returnR', 0.1, 1)
	end]]
end

function opponentNoteHit(id, noteData, noteType, isSustainNote)

		-- directional movement
	--[[if noteData == 0 then
		noteTweenX('hitLOP', 0, defaultOpponentStrumX0 - 20, 0.1, 'sineIn')
		runTimer('returnLOP', 0.1, 1) 
	elseif noteData == 1 then
		noteTweenY('hitDOP', 1, defaultOpponentStrumY1 + 20, 0.1, 'sineIn')
		runTimer('returnDOP', 0.1, 1) 
	elseif noteData == 2 then
		noteTweenY('hitUOP', 2, defaultOpponentStrumY2 - 20, 0.1, 'sineIn')
		runTimer('returnUOP', 0.1, 1) 
	elseif noteData == 3 then
		noteTweenX('hitROP', 3, defaultOpponentStrumX3 + 20, 0.1, 'sineIn')
		runTimer('returnROP', 0.1, 1) 
	end]]

	-- directional movement [constant, will go offscreen if allowed]
	--[[if noteData == 0 then
		noteTweenX('hitLOP', 0, getPropertyFromGroup('opponentStrums', noteData,'x') - 20, 0.1, 'sineIn')
		runTimer('returnLOP', 0.1, 1)
	elseif noteData == 1 then
		noteTweenY('hitDOP', 1, getPropertyFromGroup('opponentStrums', noteData,'y') + 20, 0.1, 'sineIn')
		runTimer('returnDOP', 0.1, 1)
	elseif noteData == 2 then
		noteTweenY('hitUOP', 2, getPropertyFromGroup('opponentStrums', noteData,'y') - 20, 0.1, 'sineIn')
		runTimer('returnUOP', 0.1, 1)
	elseif noteData == 3 then
		noteTweenX('hitROP', 3, getPropertyFromGroup('opponentStrums', noteData,'x') + 20, 0.1, 'sineIn')
		runTimer('returnROP', 0.1, 1)
	end]]

	-- just up (no directions) make + for down
	if not downscroll then
		if noteData == 0 then
			noteTweenY('hitLOP', 0, defaultOpponentStrumY0 - 20, 0.1, 'sineIn')
			runTimer('returnLOP', 0.1, 1)
		elseif noteData == 1 then
			noteTweenY('hitDOP', 1, defaultOpponentStrumY1 - 20, 0.1, 'sineIn')
			runTimer('returnDOP', 0.1, 1)
		elseif noteData == 2 then
			noteTweenY('hitUOP', 2, defaultOpponentStrumY2 - 20, 0.1, 'sineIn')
			runTimer('returnUOP', 0.1, 1)
		elseif noteData == 3 then
			noteTweenY('hitROP', 3, defaultOpponentStrumY3 - 20, 0.1, 'sineIn')
			runTimer('returnROP', 0.1, 1)
		end
	else
		if noteData == 0 then
			noteTweenY('hitLOP', 0, defaultOpponentStrumY0 + 20, 0.1, 'sineIn')
			runTimer('returnLOP', 0.1, 1)
		elseif noteData == 1 then
			noteTweenY('hitDOP', 1, defaultOpponentStrumY1 + 20, 0.1, 'sineIn')
			runTimer('returnDOP', 0.1, 1)
		elseif noteData == 2 then
			noteTweenY('hitUOP', 2, defaultOpponentStrumY2 + 20, 0.1, 'sineIn')
			runTimer('returnUOP', 0.1, 1)
		elseif noteData == 3 then
			noteTweenY('hitROP', 3, defaultOpponentStrumY3 + 20, 0.1, 'sineIn')
			runTimer('returnROP', 0.1, 1)
		end
	end

	-- just up (no directions) make + for down [constant, will go offscreen if allowed]
	--[[if noteData == 0 then
		noteTweenY('hitLOP', 0, getPropertyFromGroup('opponentStrums', noteData,'y') - 20, 0.1, 'sineIn')
		runTimer('returnLOP', 0.1, 1)
	elseif noteData == 1 then
		noteTweenY('hitDOP', 1, getPropertyFromGroup('opponentStrums', noteData,'y') - 20, 0.1, 'sineIn')
		runTimer('returnDOP', 0.1, 1)
	elseif noteData == 2 then
		noteTweenY('hitUOP', 2, getPropertyFromGroup('opponentStrums', noteData,'y') - 20, 0.1, 'sineIn')
		runTimer('returnUOP', 0.1, 1)
	elseif noteData == 3 then
		noteTweenY('hitROP', 3, getPropertyFromGroup('opponentStrums', noteData,'y') - 20, 0.1, 'sineIn')
		runTimer('returnROP', 0.1, 1)
	end]]
end

function onTimerCompleted(tag, loops, loopsLeft)
	
	--=========================[BF]==============================--

	--[[if tag == 'returnL' then -- for directional movement
		noteTweenX('backL', 4, defaultPlayerStrumX0, 0.1, 'sineIn')
	end
	if tag == 'returnD' then
		noteTweenY('backD', 5, defaultPlayerStrumY1, 0.1, 'sineIn')
	end
	if tag == 'returnU' then
		noteTweenY('backU', 6, defaultPlayerStrumY2, 0.1, 'sineIn')
	end
	if tag == 'returnR' then
		noteTweenX('backR', 7, defaultPlayerStrumX3, 0.1, 'sineIn')
	end]]

	if tag == 'returnL' then -- Just up n down
		noteTweenY('backL', 4, defaultPlayerStrumY0, 0.1, 'sineIn')
	end
	if tag == 'returnD' then
		noteTweenY('backD', 5, defaultPlayerStrumY1, 0.1, 'sineIn')
	end
	if tag == 'returnU' then
		noteTweenY('backU', 6, defaultPlayerStrumY2, 0.1, 'sineIn')
	end
	if tag == 'returnR' then
		noteTweenY('backR', 7, defaultPlayerStrumY3, 0.1, 'sineIn')
	end

	--=========================[DAD]=============================--
	
	--[[if tag == 'returnLOP' then -- for directional movement
		noteTweenX('backLOP', 0, defaultOpponentStrumX0, 0.1, 'sineIn')
	end
	if tag == 'returnDOP' then
		noteTweenY('backDOP', 1, defaultOpponentStrumY1, 0.1, 'sineIn')
	end
	if tag == 'returnUOP' then
		noteTweenY('backUOP', 2, defaultOpponentStrumY2, 0.1, 'sineIn')
	end
	if tag == 'returnROP' then
		noteTweenX('backROP', 3, defaultOpponentStrumX3, 0.1, 'sineIn')
	end]]

	if tag == 'returnLOP' then -- Just up n down
		noteTweenY('backLOP', 0, defaultOpponentStrumY0, 0.1, 'sineIn')
	end
	if tag == 'returnDOP' then
		noteTweenY('backDOP', 1, defaultOpponentStrumY1, 0.1, 'sineIn')
	end
	if tag == 'returnUOP' then
		noteTweenY('backUOP', 2, defaultOpponentStrumY2, 0.1, 'sineIn')
	end
	if tag == 'returnROP' then
		noteTweenY('backROP', 3, defaultOpponentStrumY3, 0.1, 'sineIn')
	end
end