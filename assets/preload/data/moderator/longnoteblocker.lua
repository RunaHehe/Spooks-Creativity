-- these two are in seperate scripts because im honestly not dealing with the bugs :3
function onCreatePost()
    if InsaneMode then
        createLongBlocker()
    end
end

function createLongBlocker()
    for i = 1, 5 do
        local tag2 = 'longBlock'..i
        makeLuaSprite(tag2, 'mod/Timeout Note Long Blocker', 1300 , 20 + ((i-1) * 150))
        scaleObject(tag2, 0.75, 0.75)
        setObjectCamera(tag2, 'hud')
        addLuaSprite(tag2)
        setObjectOrder(tag2, getObjectOrder('notes')+10)
    end
end

function onStepEvent(curStep)
    if InsaneMode then
        if (curStep >= 1411 and curStep < 1526) and curStep % 4 == 0 then
            local tag2 = 'longBlock'..((curStep%(4*5))/4) + 1
            setProperty(tag2..'.angle', 20)
            doTweenX(tag2, tag2, 650, crochet/500, 'quadOut')
            doTweenAngle(((curStep%(4*6))/4)..'hehehehe', tag2, 0, crochet/500, 'quadOut')
        end
    end
end

function onTweenCompleted(tag2)
    if InsaneMode then
        if string.find(tag2, 'longBlock') and not string.find(tag2, 'outt') then
            doTweenX(tag2..'outt', tag2, 1300, crochet/1000, 'quadIn')
        end
    end
end