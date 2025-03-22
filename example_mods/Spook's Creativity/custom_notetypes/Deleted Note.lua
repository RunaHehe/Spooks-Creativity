function onCreate()
    for i = 0, getProperty('unspawnNotes.length') - 1 do
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Deleted Note' then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'Deleted Note')
            setPropertyFromGroup('unspawnNotes', i, 'hitHealth', -0.1)
            setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
            if botPlay then
                setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
            end
            if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
                setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
            end
        end
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if noteType == 'Deleted Note' then
        playSound('staticShock', 1)
        cameraShake('camHUD', 0.01, 0.2)
        cameraShake('camDiscord', 0.01, 0.2)
        triggerEvent('Screen Shake', '0.01, 0.2', '')
    end
end