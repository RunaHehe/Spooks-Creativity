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
            opacity = math.max(opacity - 0.05, 0)
            setPropertyFromClass("lime.app.Application", "current.window.opacity", opacity)
        end
    end
end

function onDestroy()
    setPropertyFromClass("lime.app.Application", "current.window.opacity", 1)
end