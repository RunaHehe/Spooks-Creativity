-- improved by VideoBot
local middleEnabled = false

local tweens = {} -- array to store tweens

local easings = {
    -- ok listen easings werent automatically supported :sob:
    linear = function(t)
        return t
    end,

    sineInOut = function(t)
        return -0.5 * (math.cos(math.pi * t) - 1)
    end,

    expoIn = function(t)
        return t == 0 and 0 or math.pow(2, 10 * (t - 1))
    end,
    expoOut = function(t)
        return t == 1 and 1 or 1 - math.pow(2, -10 * t)
    end,

    quadIn = function(t)
        return t * t;
    end,
    quadOut = function(t)
        return -t * (t - 2)
    end
}

function onCreate()
    middleEnabled = getPropertyFromClass('ClientPrefs', 'middleScroll')
    setPropertyFromClass('ClientPrefs', 'middleScroll', false)
    setPropertyFromClass('PlayState', 'middleScroll', false)
end
function onCreatePost()
    if Modchart then
        setupMods()
        modSetup()
        initShaders()
        setupEvents()
    end
end

function setupMods()
    -- dad
    startMod("dadAlpha", "StealthModifier", "opponent", -1)
    startMod("dadY", "YDModifier", "opponent", -1)

    -- bf
    startMod("bfX", "XModifier", "player", -1)

    -- both
    startMod("strumA", "LaneStealthModifier", "", -1)
    startMod("flip", "Flip", "", -1)
    startMod("invert", "Invert", "", -1)
    startMod("tipsy", "TipsyY", "", -1)
end

function modSetup()
    setMod("dadAlpha", 1)
    setMod("dadY", -150)
    setMod("bfX", -350)

    addHaxeLibrary('FlxSprite', 'flixel')
    addHaxeLibrary('FlxCamera', 'flixel')
    luaDebugMode = true

    runHaxeCode([[
        camNotes = new FlxCamera();
        camNotes.bgColor = 0x00;
        camNotesFake = new FlxCamera();
        camNotesFake.x = 0;
        camNotesFake.y = 0;
        camNotesFake.bgColor = 0x00;

        game.notes.cameras = [camNotes, camNotesFake];
        game.strumLineNotes.cameras = [camNotes, camNotesFake];
        game.grpNoteSplashes.cameras = [camNotes, camNotesFake];
        game.grpNoteHoldSplashes.cameras = [camNotes, camNotesFake];

        game.playfieldRenderer.cameras = [camNotes, camNotesFake];

        FlxG.cameras.remove(game.camOther, false);
        FlxG.cameras.remove(game.camHUD, false);
        FlxG.cameras.add(game.camHUD, false);
        FlxG.cameras.add(camNotesFake, false);
        FlxG.cameras.add(camNotes, false);
        FlxG.cameras.add(game.camOther, false);

        setVar('camNotes', camNotes);
        setVar('camNotesFake', camNotesFake);
    ]])
    setProperty("camNotesFake.visible", false)
end

function initShaders()
    makeLuaSprite('split', 1, 0)
    setSpriteShader("split", "split")
    setShaderFloat("split", "multi", 1)

    makeLuaSprite('split2', 1, 0)
    setSpriteShader("split2", "split")
    setShaderFloat("split2", "multi", 1)

    runHaxeCode([[
            camNotesFake.setFilters([new ShaderFilter(game.getLuaObject("split").shader)]);
            camNotes.setFilters([
                new ShaderFilter(game.getLuaObject("split2").shader)
            ]);
        ]])
end

local beats = false

function setupEvents()
    ease(16, 16, "linear", "0, dadAlpha")
    ease(16, 16, "quadOut", "0, dadY")
    ease(16, 16, "quadIn", "0, bfX")
    ease(48, 15, "linear", "1, strumA")
    ease(62, 3, "linear", "0, strumA")
    ease(92, 1, "linear", "1, strumA")
    set(96, "0, strumA")

    for beat = 0, (4 * 8) - 1 do
        local time = 64 + beat

        if time % 4 == 0 then
            set(time, "4, wiggle, 0.2, flip")
            ease(time, 2, "sineOut", "0, wiggle, 0, flip")
        end
    end

    for beat = 0, (4 * 16) - 1 do
        local time = 128 + beat
        local inten = set(time, [[
            ]] .. 0.5 * (beat % 2 == 0 and 1 or -1) .. [[, invert,
            ]] .. 4 * (beat % 2 == 0 and 1 or -1) .. [[, wiggle
        ]])
        ease(time, 1, 'quadOut', '0, invert, 0, wiggle')
    end

    for beat = 0, (4 * 24) - 1 do
        local time = 192 + beat
        local inten = (beat % 2 == 0 and 1 or -1)

        if beat % 8 == 0 then
            beats = beats == false
        end

        set(time, [[
            ]] .. 0.5 * inten .. [[, invert,
            ]] .. 4 * inten .. [[, wiggle
        ]])
        ease(time, 1, 'quadOut', '0, invert, 0, wiggle')

        if beats and time <= 256 then
            set(time, 2 * inten .. ", tipsy")
            ease(time, 1, 'quadOut', '0, tipsy')
        end
    end

    for beat = 0, (4 * 16) - 1 do
        local time = 288 + beat
        local inten = (beat % 2 == 0 and 1 or -1)

        set(time, [[
            ]] .. 0.5 * inten .. [[, invert
        ]])
        ease(time, 1, 'quadOut', '0, invert')
    end

    for i = 0, 7 do
        ease(448, 2, "quartOut", "0, y" .. i .. ", 0, invert")
    end
end

function onDestroy()
    if middleEnabled then
        setPropertyFromClass('ClientPrefs', 'middleScroll', true)
        setPropertyFromClass('PlayState', 'middleScroll', true)
    end
end

function onBeatHit()
    if Modchart then
        if curBeat == 192 then
            setProperty("camNotesFake.visible", true)
            -- doTweenVar("fakeSplit", "split", "multi", 3, 2, "quadOut", true)
            -- doTweenX("fakeSplit", "split", 3, 2, "quadOut")
            setProperty("camNotesFake.alpha", 0.5)
        end

        if curBeat == 288 then
            doTweenVar("fakeSplit", "split", "multi", 2, 1, "quadOut", true)
        end

        if curBeat == 352 then
            doTweenVar("fakeSplit", "split", "multi", 1, 2, "quadOut", true)
            doTweenVar("notesSplit", "split2", "multi", 1, 2, "quadOut", true)
            doTweenAlpha("fakeBye", "camNotesFake", 0, 2, "linear")

            doTweenX("returnCamFakeX", "camNotesFake", 0, 2, "quartOut")
            doTweenY("returnCamFakeY", "camNotesFake", 0, 2, "quartOut")
            doTweenY("returnCam", "camNotes", 0, 2, "quartOut")
        end
        if curBeat == 354 then
            setShaderFloat("split", "multi", 0)
            setShaderFloat("split2", "multi", 0)
        end

        if curBeat == 448 then
            doTweenAngle("camFakeReturn", "camNotesFake", 0, 2, "circOut")
        end
    end
end

function onUpdatePost(elapsed)
    if Modchart then
        setProperty('camNotes.zoom', getProperty('camHUD.zoom'))
        setProperty('camNotesFake.zoom', getProperty('camHUD.zoom'))
        setProperty('camNotes.angle', getProperty('camHUD.angle'))
        setProperty('camNotesFake.angle', getProperty('camHUD.angle'))

        if curBeat >= 192 and curBeat < 288 then
            setShaderFloat("split", "multi", 3 * continuous_cos(curDecBeat / 24))
        end

        if curBeat >= 288 and curBeat < 352 then
            setProperty("camNotesFake.x", 200 * continuous_sin(curDecBeat / 8))
        end
        if curBeat >= 319.5 and curBeat < 352 then
            setProperty("camNotesFake.y", 200 * continuous_cos(curDecBeat / 8))
            -- setProperty("camNotes.x", 200*continuous_cos(curDecBeat/8))
            setProperty("camNotes.y", 100 * continuous_cos(curDecBeat / 8))
        end

        if curBeat >= 384 and curBeat < 447.5 then
            setProperty("camNotes.angle", 5 * continuous_sin(curDecBeat / 8))
            setProperty("camNotesFake.alpha", 1)
            setProperty("camNotesFake.zoom", 0.6)
            setProperty("camNotesFake.angle", 180)

            local moveY = continuous_cos(curDecBeat / 2)
            local inv = continuous_sin(curDecBeat / 6)

            for i = 0, 7 do
                if i % 2 == 0 then
                    setMod("y" .. i, 40 * (-moveY))
                else
                    setMod("y" .. i, 40 * moveY)
                end
            end
            setMod("invert", (inv / 4))
        end
    end
end

function onUpdate(elapsed)
    for tag, tween in pairs(tweens) do
        tween.elapsedTime = tween.elapsedTime + elapsed
        local t = math.min(tween.elapsedTime / tween.duration, 1)

        local easeFunc = easings[tween.easing] or easings.linear
        local easedT = easeFunc(t)

        local current = tween.startValue + (tween.endValue - tween.startValue) * easedT

        if tween.isShader then
            setShaderFloat(tween.shaderTag, tween.variable, current)
        else
            setProperty(tween.object, current)
        end

        if tween.elapsedTime >= tween.duration then
            if tween.isShader then
                setShaderFloat(tween.shaderTag, tween.variable, tween.endValue)
            else
                setProperty(tween.object, tween.endValue)
            end
            tweens[tag] = nil
        end
    end
end

function doTweenVar(tag, objectOrShaderTag, variableOrEndValue, endValueOrDuration, durationOreasing, easing, isShader)
    if isShader then
        local shaderTag = objectOrShaderTag
        local variable = variableOrEndValue
        local endValue = endValueOrDuration
        local duration = durationOreasing

        local startValue = getShaderFloat(shaderTag, variable)

        tweens[tag] = {
            isShader = true,
            shaderTag = shaderTag,
            variable = variable,
            startValue = startValue,
            endValue = endValue,
            duration = duration,
            elapsedTime = 0,
            easing = easing or 'linear'
        }
    else
        local object = objectOrShaderTag
        local endValue = variableOrEndValue
        local duration = endValueOrDuration

        local startValue = getProperty(object)

        tweens[tag] = {
            isShader = false,
            object = object,
            startValue = startValue,
            endValue = endValue,
            duration = duration,
            elapsedTime = 0,
            easing = easing or 'linear'
        }
    end
end

function continuous_sin(x)
    return math.sin((x % 1) * 2 * math.pi)
end
function continuous_cos(x)
    return math.cos((x % 1) * 2 * math.pi)
end
