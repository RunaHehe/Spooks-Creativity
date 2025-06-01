local opacity = 1

function onCreatePost()
    setPropertyFromClass("lime.app.Application", "current.window.opacity", 1)
    for i = 0, getProperty('unspawnNotes.length') - 1 do
        if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'opacity' then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'Opacity Note')
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
    if noteType == "opacity" then
        if not isSustainNote then
            opacity = math.max(opacity - 0.05, 0.25)
            setPropertyFromClass("lime.app.Application", "current.window.opacity", opacity)
        end
        playSound('staticShock', 1)
        cameraShake('camHUD', 0.01, 0.2)
        cameraShake('camDiscord', 0.01, 0.2)
        cameraShake('camBDiscord', 0.01, 0.2)
    end
end

function onDestroy()
    setPropertyFromClass("lime.app.Application", "current.window.opacity", 1)
end

function onUpdate(elapsed)
    if opacity < 1 then
        opacity = math.min(opacity + (elapsed * 0.05), 1)
        setPropertyFromClass("lime.app.Application", "current.window.opacity", opacity)
    end
end