function onCreatePost()
    if InsaneMode then
        createNoteBlocker()
    end
end

function createNoteBlocker()
    for i = 1, 5 do
        local tag = 'blockerDis'..i
        makeLuaSprite(tag, 'mod/Timeout Note Blocker', 1300 , 20 + ((i-1) * 150))
        scaleObject(tag, 0.75, 0.75)
        setObjectCamera(tag, 'hud')
        addLuaSprite(tag)
        setObjectOrder(tag, getObjectOrder('notes')+10)
    end
end

function onStepEvent(curStep)
    if InsaneMode then
        if (curStep >= 1280 and curStep < 1408) and curStep % 4 == 0 then
            local tag = 'blockerDis'..((curStep%(4*5))/4) + 1
            setProperty(tag..'.angle', 20)
            doTweenX(tag, tag, 800, crochet/500, 'quadOut')
            doTweenAngle(((curStep%(4*6))/4)..'hehehehe', tag, 0, crochet/500, 'quadOut')
        end
    end
end

function onTweenCompleted(tag)
    if InsaneMode then
        if string.find(tag, 'blockerDis') and not string.find(tag, 'outt') then
            doTweenX(tag..'outt', tag, 1300, crochet/1000, 'quadIn')
        end
    end
end