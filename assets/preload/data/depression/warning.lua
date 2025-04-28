function onCreate()
    makeAnimatedLuaSprite('depressionWarning', 'depressionWarning', 0, 0)
    addAnimationByPrefix('depressionWarning', 'frame0', 'warning0000', 24, false)
    addAnimationByPrefix('depressionWarning', 'frame1', 'warning0001', 24, false)
    addLuaSprite('depressionWarning', true)
    screenCenter('depressionWarning')
    setObjectCamera('depressionWarning', 'hud')
    scaleObject('depressionWarning', 0.5, 0.5)
    setProperty("depressionWarning.alpha", 0)
    setProperty('depressionWarning.offset.x', 0)
    setProperty('depressionWarning.offset.y', 50)
    playAnim('depressionWarning', 'frame0') -- make sure it starts on first frame
end

function onBeatHit()
    if curBeat == 256 then
        doTweenAlpha("warningHello", "depressionWarning", 1, 0.5, 'linear')
    end
    if curBeat >= 256 and curBeat < 296 then
        local frameName = (curBeat % 2 == 0) and 'frame0' or 'frame1'

        local alphaBefore = getProperty('depressionWarning.alpha')
        playAnim('depressionWarning', frameName, true)
        setProperty('depressionWarning.alpha', alphaBefore)
    end
    if curBeat == 288 then
        doTweenAlpha("warningBye", "depressionWarning", 0, 1, 'linear')
    end
end 