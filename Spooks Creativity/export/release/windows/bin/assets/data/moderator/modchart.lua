local defaultMiddle = false
function onCreate()
    if SourceCodeVer then
        setProperty('useModchart', Modchart)
        defaultMiddle = middlescroll
        if Modchart then
            setPropertyFromClass("ClientPrefs", "middleScroll", false)
        end
    end
end

local bassBeat = {
    0, 3, 6, 9, 12, 14,
    16, 19, 22, 25, 28, 30,
    32, 35, 38, 41, 44, 46,
    48, 51, 54, 56, 59, 62
}

local bf = 0
local dad = 1
function onDestroy()
    setPropertyFromClass("ClientPrefs", "middleScroll", defaultMiddle)
end
function onCreatePost()
    if SourceCodeVer and Modchart then
        firstSet()
    end
end

function onCountdownStarted()
    luaDebugMode = true
    if SourceCodeVer and Modchart then
        modchart()
    end
end

function firstSet()
    setValue('transformY', -165 * (downscroll and -1 or 1))
    setValue('opponentSwap', 0.5)
    if HardMode then
        setValue('bumpy', 1)
        setValue('bumpyPeriod', 4)
    end
end

function modchart()
    firstSet()
    setProperty('spawnTime', 3000)
    -- player 0 = bf
    -- player 1 = dad

    ease(0, 16, 'transformY', 0, 'quadOut', dad)
    if HardMode then
    ease(0, 16, 'randomVanish', 1, 'linear', dad)
    end

    ease(16, 16, 'transformY', 0, 'quadInOut', bf)
    ease(16, 16, 'opponentSwap', 0, 'quadInOut', dad)
    ease(16, 16, 'transform2X', 640, 'quadInOut', dad) ease(16, 16, 'transform3X', 640, 'quadInOut', dad)
    ease(16, 16, 'transformZ', -0.25, 'quadInOut', dad)
    if HardMode then
        ease(16, 16, 'randomVanish', 1, 'linear', bf)
        for beat = 0, (3*4)-1 do
            local time = 16 + beat
            if time % 8 == 0 then
                ease(time, 3, 'centerrotateZ', 0.5, 'quadOut', bf)
            end
            if time % 8 == 3 then
                ease(time, 1, 'centerrotateZ', 0, 'quadIn', bf)
            end
            if time % 8 == 4 then
                ease(time, 3, 'centerrotateZ', -0.5, 'quadOut', bf)
            end
            if time % 8 == 7 then
                ease(time, 1, 'centerrotateZ', 0, 'quadIn', bf)
            end
        end
        ease(28, 1, 'centerrotateZ', -0.5, 'quadOut', bf)
        ease(29, 1, 'centerrotateZ', 0, 'quadIn', bf)
        ease(30, 1, 'centerrotateZ', 0.5, 'quadOut', bf)
        ease(31, 1, 'centerrotateZ', 0, 'quadIn', bf)
    end

    ease(32, 2, 'transformZ', 0, 'expoOut', dad)
    ease(32, 2, 'transform2X', 0, 'expoOut', dad) ease(32, 2, 'transform3X', 0, 'expoOut', dad)
    ease(32, 2, 'opponentSwap', 0.5, 'expoOut', dad)
    ease(32, 2, 'transformZ', -0.5, 'expoOut', bf)
    ease(32, 2, 'alpha', 0.5, 'expoOut', bf)
    if HardMode then
        ease(30, 2, 'randomVanish', 0, 'linear')
        ease(32, 2, 'bumpy', 0, 'quadOut')
    end

    set(32, 'drunkPeriod', 15)
    set(32, 'wiggleFreq', 0.5)
    ease(32, 2, 'boost', (EasyMode and 0.5 or 1), 'linear')
    if not EasyMode then
        for i, v in pairs(bass(16)) do
            set(v, 'tipsy', 1*(i%2==0 and 1 or -1)*(HardMode and 1.5 or 1), bf)
            set(v, 'drunk', 1*(i%2==0 and 1 or -1)*(HardMode and 1.5 or 1), bf)
            ease(v, 1, 'tipsy', 0, 'cubeOut', bf)
            ease(v, 1, 'drunk', 0, 'cubeOut', bf)
        end
    end

    local downsc = downscroll and -1 or 1
    for beat = 0, (4*8)-1 do
        local turn = beat >= 16 and bf or dad
        local time = beat + 32
        if beat%2==1 then
            ease(time-0.2, 0.2, 'transformX', 100 * (beat%4==1 and 1 or -1), 'quadIn', turn)
            ease(time, 0.8, 'transformX', 0, 'quadOut', turn)
            ease(time-0.2, 0.2, 'localrotateZ', math.rad(25) * (beat%4==1 and 1 or -1), 'quadIn', turn)
            ease(time, 0.8, 'localrotateZ', 0, 'quadOut', turn)

            set(time, 'wiggle', 8, turn)
            ease(time, 2, 'wiggle', 0, 'quadOut', turn)
        end
        if not EasyMode then
            for i = 0, 1 do
                local index = (beat%2==0 and 0 or 2)+i
                --ease(time, 0.5, 'transform'..index..'Y', 100 * downsc , 'quadOut', turn)
                --ease(time+0.5, 0.5, 'transform'..index..'Y', 0, 'quadIn', turn)
                ease(time, 0.5, 'reverse'..index, 0.2 , 'quadOut', turn)
                ease(time+0.5, 0.5, 'reverse'..index, 0, 'quadIn', turn)

                if (beat%4<2) then
                    set(time, 'confusion'..index, 0, turn)
                end
                ease(time, 1, 'confusion'..index, beat%4 >= 2 and 360 or 180, 'linear', turn)
            end
        end
        
    end

    ease(46, 2, 'transformZ', 0, 'expoInOut', bf)
    ease(46, 2, 'alpha', 0, 'expoInOut', bf)
    ease(46, 2, 'transformZ', -0.5, 'expoInOut', dad)
    ease(46, 2, 'alpha', 1, 'expoInOut', dad)
    set(48, 'transformX', -550, dad)
    set(48, 'opponentSwap', 0, dad)
    set(48, 'alpha', 0, dad)
    set(48, 'transformZ', 0, dad)

    if HardMode then
        ease(36, 1, 'invert', 1, 'quadOut', dad)
        ease(37, 1, 'invert', 0, 'quadOut', dad)
        ease(38, 1, 'flip', 1, 'quadOut', dad)
        ease(39, 1, 'flip', 0, 'quadOut', dad)
        ease(44, 2, 'reverse', 1, 'linear', dad)
        ease(46, 2, 'reverse', 0, 'linear', dad)

        ease(52, 1, 'invert', 1, 'quadOut', bf)
        ease(53, 1, 'invert', 0, 'quadOut', bf)
        ease(54, 1, 'flip', 1, 'quadOut', bf)
        ease(55, 1, 'flip', 0, 'quadOut', bf)
        ease(60, 2, 'reverse', 1, 'linear', bf)
        ease(62, 2, 'reverse', 0, 'linear', bf)
    
    end

    ease(60, 4, 'opponentSwap', 0, 'quadInOut')
    ease(60, 4, 'transformX', 0, 'quadInOut')
    ease(60, 4, 'boost', 0, 'expoInOut')

    --bouncing 
    set(60, 'drunkPeriod', 1)
    for beat = 0, (4*8)-1 do
        local time = 64 + beat
        local turn = beat >= 16 and bf or dad

        ease(time, 0.5, 'transformY-a', 60 * downsc, 'quadOut')
        ease(time+0.5, 0.5, 'transformY-a', 0, 'quadIn')

        if (time ~= 95) then
            ease(time, 1, 'transformZ-a', -0.1 * (beat%2==0 and 1 or -1), 'sineInOut', dad)
            ease(time, 1, 'transformZ-a', 0.1 * (beat%2==0 and 1 or -1), 'sineInOut', bf)
        else
            ease(time, 1, 'transformZ-a', 0, 'sineInOut', dad)
            ease(time, 1, 'transformZ-a', 0, 'sineInOut', bf)
        end

        set(time, 'tipsy', (EasyMode and 1 or 2)*(beat%2==0 and 1 or -1), turn)
        set(time, 'drunk', (EasyMode and 1 or 2)*(beat%2==0 and 1 or -1), turn)
        ease(time, 1, 'tipsy', 0, 'quadOut', turn)
        ease(time, 1, 'drunk', 0, 'quadOut', turn)

    end
    if not EasyMode then
        ease(64, 1, 'hidden', 1, 'linear', bf); ease(64, 2, 'wiggle', 1, 'linear', bf)
        ease(64, 1, 'flip', -0.1, 'quadOut', bf); ease(64+1, 1, 'flip', 1, 'cubeOut', bf)
        ease(68, 1, 'flip', 1.1, 'quadOut', bf); ease(68+1, 1, 'flip', 0, 'cubeOut', bf)
        ease(72, 1, 'flip', -0.1, 'quadOut', bf); ease(72+1, 1, 'flip', 1, 'cubeOut', bf)
        ease(76, 1, 'flip', 1.1, 'quadOut', bf); ease(76+1, 1, 'flip', 0, 'quadOut', bf)
        ease(76, 1, 'invert', -0.1, 'quadOut', bf)
        ease(76+1, 1, 'invert', 1, 'cubeOut', bf)
        ease(78, 1, 'invert', 1.1, 'quadOut', bf)
        ease(78+1, 1, 'invert', 0, 'cubeOut', bf)
        ease(78, 2, 'hidden', 0, 'linear', bf); ease(78, 2, 'wiggle', 0, 'linear', bf)
        
        ease(80, 1, 'hidden', 1, 'linear', dad); ease(80, 1, 'wiggle', 1, 'linear', dad)
        ease(80, 1, 'flip', -0.1, 'quadOut', dad); ease(80+1, 1, 'flip', 1, 'cubeOut', dad)
        ease(84, 1, 'flip', 1.1, 'quadOut', dad); ease(84+1, 1, 'flip', 0, 'cubeOut', dad)
        ease(88, 1, 'flip', -0.1, 'quadOut', dad); ease(88+1, 1, 'flip', 1, 'cubeOut', dad)
        ease(92, 1, 'flip', 1.1, 'quadOut', dad); ease(92+1, 1, 'flip', 0, 'quadOut', dad)
        ease(92, 1, 'invert', -0.1, 'quadOut', dad)
        ease(92+1, 1, 'invert', 1, 'cubeOut', dad)
        ease(94, 1, 'invert', 1.1, 'quadOut', dad)
        ease(94+1, 1, 'invert', 0, 'cubeOut', dad)
        ease(94, 2, 'hidden', 0, 'linear', dad); ease(94, 2, 'wiggle', 0, 'linear', dad)
    end
    if HardMode then
        for beat = 0, 8-1 do
            local time = 64 + (beat*4)
                ease(time, 1, 'localrotateY', 0.5, 'sineOut')
                ease(time+1, 1, 'localrotateY', 0, 'sineIn')
                ease(time+2, 1, 'localrotateY', -0.5, 'sineOut')
                ease(time+3, 1, 'localrotateY', 0, 'sineIn')
        end
    end

    set(81, 'confusion', 0)
    for i = 0, 1 do
        local add = i* 16
        ease(65 + add, 2, 'confusion', 360, 'quadOut')
        ease(69 + add, 2, 'confusion', 0, 'quadOut')
        ease(73 + add, 2, 'confusion', 360, 'quadOut')
        ease(77 + add, 2, 'confusion', 0, 'quadOut')
        ease(79 + add, i == 1 and 1 or 2, 'confusion', 360, 'quadOut')

    end
    set(96, 'confusion', 0)
    if HardMode then
        ease(96, 1, 'tipZ', 0.5, 'sineInOut')
    end

    ease(95, 1, 'opponentSwap', 0.5, 'sineInOut')
    ease(95, 1, 'transformZ', -0.2, 'sineInOut', bf)
    ease(95, 1, 'alpha', 0.5, 'sineInOut', bf)

    if not EasyMode then
        for i = 0, 1 do
            local add = i*16
            local turn = i==0 and dad or bf
            ease(96 + add, 1, 'reverse', 1, 'linear', turn)
            ease(100 + add, 1, 'reverse', 0, 'linear', turn)
            ease(104 + add, 1, 'reverse', 1, 'linear', turn)
            ease(109 + add, 1, 'reverse', 0, 'linear', turn)
            ease(111 + add, 1, 'reverse', 0.5, 'linear', turn)
        end
    end
    for beat = 0, (4*8)-1 do
        local time = 96 + beat
        local turn = beat >= 16 and bf or dad

        set(time, 'tipsy', 2*(beat%2==0 and 1 or -1), turn)
        set(time, 'drunk', 2*(beat%2==0 and 1 or -1), turn)
        ease(time, 1, 'tipsy', 0, 'quadOut', turn)
        ease(time, 1, 'drunk', 0, 'quadOut', turn)

    end

    ease(111, 1, 'alpha', 1, 'linear', dad)
    ease(111, 1, 'alpha', 0, 'linear', bf)
    ease(111, 1, 'transformZ', -0.2, 'linear', dad)
    ease(111, 1, 'transformZ', 0, 'linear', bf)

    if HardMode then
        ease(127, 1, 'tipZ', 0, 'sineInOut')
    end
    set(127, 'transformZ', 0, dad)
    ease(127, 1, 'reverse', 0, 'linear', dad)
    ease(127, 1, 'alpha', 0, 'linear', dad)
    ease(127, 1, 'alpha', 1, 'linear', bf)

    ease(128, 4, 'tipZ', 0.5, 'quadOut', dad);  ease(128, 4, 'tipZ', -0.5, 'quadOut', bf)
    ease(128, 4, 'tipsy', 0.5, 'quadOut', dad);  ease(128, 4, 'tipsy', -0.5, 'quadOut', bf)
    ease(128, 4, 'brake', (EasyMode and 0.5 or 1), 'quadOut')
    ease(128, 4, 'boost', (EasyMode and 1 or 2), 'quadOut')

    ease(143, 2, 'alpha', 0, 'sineInOut', bf)
    ease(143, 2, 'alpha', (EasyMode and 0.75 or 0.5), 'sineInOut', dad)
    ease(143, 2, 'transformZ', 0, 'sineInOut', bf)
    ease(143, 2, 'transformZ', -0.3, 'sineInOut', dad)
    ease(143, 2, 'reverse', 0, 'sineInOut', bf)

    for beat = 0, (4*8)-3 do
        local time = 160 + beat
        local turn = beat >= 16 and bf or dad

        ease(time, 0.5, 'transformZ', (beat%2==0 and -0.4 or 0), 'quadOut', bf)
        ease(time, 0.5, 'transformZ', (beat%2==1 and -0.4 or 0), 'quadOut', dad)

        set(time, 'drunk', (EasyMode and 1.5 or 3) * (beat%2==0 and -1 or 1), bf)
        set(time, 'drunk', (EasyMode and 1.5 or 3) * (beat%2==0 and 1 or -1), dad)
        ease(time, 1 ,'drunk', 0, 'quadOut')
        
        if beat%4 == 0 and HardMode then
            ease(time, 1 ,'centerrotateZ', 0.5, 'quadOut', bf)
            ease(time, 1 ,'centerrotateZ', -0.5, 'quadOut', dad)
        elseif beat%4 == 1 then
            ease(time, 1 ,'centerrotateZ', 0, 'quadOut')
        elseif beat%4 == 2 then
            ease(time, 1 ,'centerrotateZ', -0.5, 'quadOut', bf)
            ease(time, 1 ,'centerrotateZ', 0.5, 'quadOut', dad)
        elseif beat%4 == 3 then
            ease(time, 1 ,'centerrotateZ', 0, 'quadOut')
        end
    end

    if HardMode then
        ease(190, 2 ,'centerrotateZ', 0, 'quadOut')
    end
    ease(190, 2, 'transformZ', 0, 'linear')
    ease(190, 2, 'alpha', 0, 'linear')
    ease(190, 2, 'transformY', -210 * downsc, 'linear')
    if HardMode then ease(190, 2, 'wiggle', 4, 'linear', bf) end
    ease(190, 2, 'brake', 0, 'linear')
    ease(190, 2, 'boost', 0, 'linear')
    ease(190, 2, 'alpha', 0.5, 'linear')
    ease(190, 2, 'alpha', 1, 'linear', dad)

    ease(220, 4, 'transformY', 0, 'quadOut')

    if HardMode then ease(320, 2, 'wiggle', 0, 'linear', bf) end
    set(320, 'alpha', 0)
    set(320, 'transformY', 0)
    set(320, 'opponentSwap', 0)
    for beat = 0, (4*16)-1 do
        local time = 320 + beat
        if time ~= 352 and time ~= 368 then
            ease(time-0.1, 0.1, 'tipZ', 0.5, 'expoIn');
            ease(time-0.1, 0.1, 'tipsy', (EasyMode and 0.5 or 1), 'expoIn');
            ease(time-0.1, 0.1, 'reverse', 0.1, 'expoIn');
            ease(time-0.1, 0.1, 'transformX', -25 * (beat%2==0 and 1 or -1), 'expoIn');
            ease(time-0.1, 0.1, 'wiggle', (EasyMode and 2 or 5) * (beat%2==0 and 1 or -1), 'expoIn');

            ease(time, 0.9, 'tipZ', 0, 'quadOut');
            ease(time, 0.9, 'tipsy', 0, 'quadOut');
            ease(time, 0.9, 'reverse', 0, 'quadOut');
            ease(time, 0.9, 'transformX', 0, 'quadOut');
            ease(time, 0.9, 'wiggle', 0, 'quadOut');
        end
    end

    for beat = 0, (4*8)-1 do
        local time = 416 + beat
        set(time, 'flip', 0.2 * (beat%2 == 0 and 1 or -1))
        ease(time, 1, 'flip', 0, 'quadOut');
        ease(time, 1, 'transformX', 50 * (beat%2 == 0 and 1 or -1), 'linear');
        ease(time, 0.5, 'reverse', -0.1, 'quadOut');
        ease(time+0.5, 0.5, 'reverse', (EasyMode and 0 or 0.1), 'quadIn');
    end

    ease(448, 1, 'transformX', 0, 'quadOut');
    ease(448, 1, 'alpha', 1, 'quadOut');
end

function bass(startAt)
    local arr = {}
    for i, v in pairs(bassBeat) do
        table.insert(arr, startAt+(v/4))
    end
    return arr
end

























-- songStart = false
-- defaultPosition = {}
-- centerPosition = {418, 530, 642, 754       ,88, 200, 977, 1089}
-- downPosition = {570 , 50} -- down, up

-- sustainOffset = 0

-- Timer = nil

-- function onCreate()
--     luaDebugMode = true
--     mechanicOption = DifficultyOption == "classic" or DifficultyOption == "challenging"
--     hardMode = DifficultyOption == "challenging"
--     setProperty("cpuControlled", true)

--     setGlobalFromScript("scripts/engine/engine", "New_NotesIntro", false)
--     setProperty("skipArrowStartTween", true)
--     setPropertyFromClass("ClientPrefs", "middleScroll", false)

--     package.path = getProperty("modulePath") .. ";" .. package.path
--     Timer = require("Timer")
-- end

-- function onCreatePost()
--     addHaxeLibrary 'FunkinLua'
--     addHaxeLibrary('Lua_helper', 'llua')
--     addHaxeLibrary('FlxEase', 'flixel.tweens')
--     runHaxeCode([=[
--         game.strumLineNotes.camera = camNotes;
--         game.notes.camera = camNotes;

--         notesVar = [];
--         setVar("wiggle", 0);
--         setVar("wiggleFreq", 1);
--         setVar("noteSpeed", 1);
--         for (i in 0...7){
--             notesVar = 
--             [
--                 ("x"+i) => 0, 
--                 ("y"+i) => 0,

--                 ("2x"+i) => 0, 
--                 ("2y"+i) => 0
--             ];
--         }

--         getFlxEaseByString = function(?ease = '') {
--             switch(ease.toLowerCase()) {
--                 case 'backin': return FlxEase.backIn;
--                 case 'backinout': return FlxEase.backInOut;
--                 case 'backout': return FlxEase.backOut;
--                 case 'bouncein': return FlxEase.bounceIn;
--                 case 'bounceinout': return FlxEase.bounceInOut;
--                 case 'bounceout': return FlxEase.bounceOut;
--                 case 'circin': return FlxEase.circIn;
--                 case 'circinout': return FlxEase.circInOut;
--                 case 'circout': return FlxEase.circOut;
--                 case 'cubein': return FlxEase.cubeIn;
--                 case 'cubeinout': return FlxEase.cubeInOut;
--                 case 'cubeout': return FlxEase.cubeOut;
--                 case 'elasticin': return FlxEase.elasticIn;
--                 case 'elasticinout': return FlxEase.elasticInOut;
--                 case 'elasticout': return FlxEase.elasticOut;
--                 case 'expoin': return FlxEase.expoIn;
--                 case 'expoinout': return FlxEase.expoInOut;
--                 case 'expoout': return FlxEase.expoOut;
--                 case 'quadin': return FlxEase.quadIn;
--                 case 'quadinout': return FlxEase.quadInOut;
--                 case 'quadout': return FlxEase.quadOut;
--                 case 'quartin': return FlxEase.quartIn;
--                 case 'quartinout': return FlxEase.quartInOut;
--                 case 'quartout': return FlxEase.quartOut;
--                 case 'quintin': return FlxEase.quintIn;
--                 case 'quintinout': return FlxEase.quintInOut;
--                 case 'quintout': return FlxEase.quintOut;
--                 case 'sinein': return FlxEase.sineIn;
--                 case 'sineinout': return FlxEase.sineInOut;
--                 case 'sineout': return FlxEase.sineOut;
--                 case 'smoothstepin': return FlxEase.smoothStepIn;
--                 case 'smoothstepinout': return FlxEase.smoothStepInOut;
--                 case 'smoothstepout': return FlxEase.smoothStepInOut;
--                 case 'smootherstepin': return FlxEase.smootherStepIn;
--                 case 'smootherstepinout': return FlxEase.smootherStepInOut;
--                 case 'smootherstepout': return FlxEase.smootherStepOut;
--             }
--             return FlxEase.linear;
--         }

--         for(thing in game.luaArray){
--         if(thing.scriptName == "]=]..scriptName:gsub('"', '\\"')..[=[")
--             Lua_helper.add_callback(thing.lua, 'noteVarTween', function(note, varName, value, duration, ease) {
--                 var varNam = varName+note;

--                 if(game.modchartTweens.exists(varNam)) {
--                     game.modchartTweens.get(varNam).cancel();
--                     game.modchartTweens.get(varNam).destroy();
--                     game.modchartTweens.remove(varNam);
--                 }
                
--                 game.modchartTweens.set(varNam, FlxTween.num(notesVar[varNam], value, duration, {ease: getFlxEaseByString(ease),
--                     onComplete: function(twn) {
--                         notesVar[varNam] = twn.value;
--                         game.callOnLuas('onTweenCompleted', [varNam]);
--                         game.modchartTweens.remove(varNam);
--                     } , onUpdate: function(twn) {
--                         notesVar[varNam] = twn.value;
--                     }}));
                
--             });

--             Lua_helper.add_callback(thing.lua, 'getVarNote', function(note, varName) {
--                 var varNam = varName+note;
--                 return Std.parseFloat(notesVar[varNam]);
--             });

--             Lua_helper.add_callback(thing.lua, 'setVarNote', function(note, varName, value) {
--                 var varNam = varName+note;
--                 notesVar[varNam] = value;
--             });

--             Lua_helper.add_callback(thing.lua, 'wiggleTween', function(value, duration, ease) {
--                 var tweenName = "wiggleTween";
--                 if(game.modchartTweens.exists(tweenName)) {
--                     game.modchartTweens.get(tweenName).cancel();
--                     game.modchartTweens.get(tweenName).destroy();
--                     game.modchartTweens.remove(tweenName);
--                 }
                
                
--                 game.modchartTweens.set(tweenName, FlxTween.num(getVar("wiggle"), value, duration, {ease: getFlxEaseByString(ease),
--                     onComplete: function(twn) {
--                         setVar("wiggle" ,twn.value);
--                         game.callOnLuas('onTweenCompleted', [tweenName]);
--                         game.modchartTweens.remove(tweenName);
--                     } , onUpdate: function(twn) {
--                         setVar("wiggle" ,twn.value);
--                     }}));
                
--             });

--             Lua_helper.add_callback(thing.lua, 'wiggleFreqTween', function(value, duration, ease) {
--                 var tweenName = "wiggleFreqTween";
--                 if(game.modchartTweens.exists(tweenName)) {
--                     game.modchartTweens.get(tweenName).cancel();
--                     game.modchartTweens.get(tweenName).destroy();
--                     game.modchartTweens.remove(tweenName);
--                 }
                
                
--                 game.modchartTweens.set(tweenName, FlxTween.num(getVar("wiggleFreq"), value, duration, {ease: getFlxEaseByString(ease),
--                     onComplete: function(twn) {
--                         setVar("wiggleFreq" ,twn.value);
--                         game.callOnLuas('onTweenCompleted', [tweenName]);
--                         game.modchartTweens.remove(tweenName);
--                     } , onUpdate: function(twn) {
--                         setVar("wiggleFreq" ,twn.value);
--                     }}));
                
--             });

--             Lua_helper.add_callback(thing.lua, 'noteSpeedTween', function(value, duration, ease) {
--                 var tweenName = "noteSpeedTween";
--                 if(game.modchartTweens.exists(tweenName)) {
--                     game.modchartTweens.get(tweenName).cancel();
--                     game.modchartTweens.get(tweenName).destroy();
--                     game.modchartTweens.remove(tweenName);
--                 }
                
                
--                 game.modchartTweens.set(tweenName, FlxTween.num(getVar("noteSpeed"), value, duration, {ease: getFlxEaseByString(ease),
--                     onComplete: function(twn) {
--                         setVar("noteSpeed" ,twn.value);
--                         game.callOnLuas('onTweenCompleted', [tweenName]);
--                         game.modchartTweens.remove(tweenName);
--                     } , onUpdate: function(twn) {
--                         setVar("noteSpeed" ,twn.value);
--                     }}));
                
--             });

--         }
--     ]=])

--     if mechanicOption then
--         setProperty("camNotes.alpha", 0)
--     end

--     for i = 0, getProperty("unspawnNotes.length")-1 do
--         if getPropertyFromGroup("unspawnNotes",i,"isSustainNote") then
--             sustainOffset = getPropertyFromGroup("unspawnNotes",i,"offsetX")
--             break;
--         end
--     end

--     makeLuaSprite("longTimeout", "mod/Timeout Note Long Blocker", 0, (downscroll and -150 or 720)) -- 150, 600
--     scaleObject("longTimeout", 0.85, 0.85)
--     addLuaSprite("longTimeout", true)
--     setObjectCamera("longTimeout", "camHUD")
--     screenCenter("longTimeout", "X")
-- end

-- function onSongStart()
--     for i = 0,7 do
--         table.insert(defaultPosition, {
--             x = getPropertyFromGroup("strumLineNotes", i, "x"), 
--             y = getPropertyFromGroup("strumLineNotes", i, "y")})

--         setPropertyFromGroup("strumLineNotes", i, "y", downscroll and 1280 + 120 or -120)
--         setPropertyFromGroup("strumLineNotes", i, "x", centerPosition[i%4+1])
--         setVarNote(i, "x", getPropertyFromGroup("strumLineNotes", i, "x"))
--         setVarNote(i, "y", getPropertyFromGroup("strumLineNotes", i, "y"))
--         setVarNote(i, "2x", 0)
--         setVarNote(i, "2y", 0)
--     end

--     if mechanicOption then
--         doTweenAlpha("camNotes", "camNotes", 1, crochet/1000*2)
--         for i = 0, 3 do
--             noteVarTween(i, "y", defaultPosition[i+1].y, crochet/1000*14, "quadOut")
--         end
--     end
--     songStart = true

    
-- end

-- function onStepHit()
--     if mechanicOption then
--         if curStep == 54 then
--             for i = 0, 3 do
--                 noteVarTween(i, "x", centerPosition[i%4+5], crochet/1000*16, "quadInOut")
--             end
--         end

--         if curStep == 64 then
--             for i = 4, 7 do
--                 noteVarTween(i, "y", defaultPosition[i+1].y, crochet/1000*16, "quadOut")
--             end
--         end

--         if (curStep >= 64 and curStep < 128) or (curStep >= 576 and curStep < 760) then
--             if ((curStep % 16 == 0 or curStep % 16 == 3 or curStep % 16 == 6 or curStep % 16 == 9 or curStep % 16 == 12 or curStep % 16 == 14) and curStep % 64 < 48) or 
--             (curStep % 64 >= 48 and (curStep % 16 == 0 or curStep % 16 == 3 or curStep % 16 == 6 or curStep % 16 == 8 or curStep % 16 == 11 or curStep % 16 == 14)) then
--                 for i = 4, 7 do
--                     setVarNote(i, "2y", math.sin(getSongPosition()/ 10 + i) * 50)
--                     setVarNote(i, "2x", math.cos(getSongPosition()/ 10 + i) * 10)
--                     noteVarTween(i, "2y", 0, 0.4, "cubeOut")
--                     noteVarTween(i, "2x", 0, 0.4, "cubeOut")
--                 end
--             end
--         end

--         if curStep == 120 then
--             for i = 0, 3 do
--                 noteVarTween(i, "x", centerPosition[i%4+1], crochet/1000*2, "expoIn")
--             end
--         end
--         if curStep == 124 then
--             for i = 4, 7 do
--                 noteVarTween(i, "x", centerPosition[i%4+1] + 1200, crochet/1000*2, "quadIn")
--             end
--         end
        
--         if curStep >= 128 and curStep < 256 then
--             local minNote, maxNote = (curStep < 192 and 0 or 4), (curStep < 192 and 3 or 7)
--             if curStep % 8 == 3 then
--                 for i = minNote, maxNote do
--                     noteVarTween(i, "2x", (curStep%16==3 and -150 or 150), crochet/1000*0.25, "expoIn")
--                 end
                
--             end
--             if curStep % 8 == 4 then
--                 for i = minNote, maxNote do
--                     noteVarTween(i, "2x", 0, crochet/1000*1, "cubeOut")
--                 end
--                 setProperty("wiggleFreq", 1.5)
--                 setProperty("wiggle", 6)
--                 wiggleTween(0, crochet/1000*1.5, "quadOut")
--             end
--             if curStep % 4 == 0 then
--                 for i = minNote, maxNote do 
--                     if (curStep % 8 == 0 and i%4<2) or (curStep % 8 == 4 and i%4>=2) then
--                         noteVarTween(i, "2y", 80, crochet/1000*0.5, "quadOut")

--                         setPropertyFromGroup("strumLineNotes", i, "angle", getPropertyFromGroup("strumLineNotes", i, "angle")%360)
--                         noteTweenAngle("noteAngle"..i,i, getPropertyFromGroup("strumLineNotes", i, "angle")+180, crochet/1000, "sineOut")
--                     end
--                 end
--                 triggerEvent("Change Scroll Speed", 0.75, 0)
--                 triggerEvent("Change Scroll Speed", 1, crochet/1000*0.5)
--             end
--             if curStep % 4 == 2 then
--                 for i = minNote, maxNote do 
--                     if (curStep % 8 == 2 and i%4<2) or (curStep % 8 == 6 and i%4>=2) then
--                         noteVarTween(i, "2y", 0, crochet/1000*0.5, "quadIn")
--                     end
--                 end
--             end
--         end

--         if curStep == 184 then
--             for i = 0, 3 do
--                 noteVarTween(i, "x", centerPosition[i%4+1]-1200, crochet/1000*2, "quadin")
--             end
--             for i = 4, 7 do
--                 noteVarTween(i, "x", centerPosition[i%4+1], crochet/1000*2, "quadOut")
--             end
--         end
--         if curStep == 240 then
--             for i = 0, 7 do
--                 noteVarTween(i, "x", defaultPosition[i+1].x, crochet/1000*4, "quadInOut")
--             end
--         end

--         if curStep >= 256 and curStep < 508 then
--             if curStep % 4 == 3 then
--                 setProperty("wiggleFreq", 1.25)
--                 wiggleTween(curStep%8==3 and -7 or 7, crochet/1000*0.25, "expoIn")
--             end
--             if curBeat ~= 96 and curBeat ~= 112 then
--                 if curStep % 4 == 0 then
--                     doTweenY("camBounceY", "camNotes", downscroll and -50 or 50 * (getProperty("noteSpeed")), crochet/1000/2, "quadOut")
--                     doTweenX("camBounceX", "camNotes", curStep%8==0 and -50 or 50, crochet/1000, "quadOut")

--                     wiggleTween(curStep%8==0 and 1 or -1, crochet/1000*0.75, "quadOut")

--                     for i = (curStep%128 < 64 and 0 or 4), (curStep%128 < 64 and 3 or 7) do
--                         setVarNote(i, "2y", math.sin(getSongPosition()/ 10 + i) * 100)
--                         setVarNote(i, "2x", math.cos(getSongPosition()/ 10 + i) * 20)
--                         noteVarTween(i, "2y", 0, 0.4, "cubeOut")
--                         noteVarTween(i, "2x", 0, 0.4, "cubeOut")

--                         setPropertyFromGroup("strumLineNotes", i, "angle", (curStep%8==0 and -20 or 20) * (i%2==0 and 1 or -1))
--                         noteTweenAngle("noteAngle"..i, i, 0, crochet/1000, "cubeOut")
--                     end
                
--                 elseif curStep % 4 == 2 then
--                     doTweenY("camBounceY", "camNotes", 0, crochet/1000/2, "quadIn")
--                 end
--             end
--             if curStep % 8 == 0 and curStep < 384 then
--                 for i = (curStep%128 < 64 and 4 or 0), (curStep%128 < 64 and 7 or 3) do
--                     noteVarTween(i, "x", defaultPosition[((i+(curStep%16==0 and 2 or 0))%4) +1+ (i>3 and 4 or 0)].x, crochet/1000*2, "bounceOut")
--                 end
--             end
--         end
--         if curStep == 384 then
--             for i = 0, 7 do
--                 noteVarTween(i, "y", downPosition[downscroll and 2 or 1], crochet/1000, "linear")
--             end
--             noteSpeedTween(-1, crochet/1000, "linear")

--             for i = 0, 3 do
--                 noteVarTween(i, "x", centerPosition[i%4+1], crochet/1000*1, "quadOut")
--             end
--             for i = 4, 7 do
--                 noteVarTween(i, "x", centerPosition[i%4+1]+1200, crochet/1000*1, "quadIn")
--             end
--         end

--         if curBeat == 96 then
--             for i = 0, 3 do
--                 setVarNote(i, "x", centerPosition[(i+curStep)%4 + 1])
--             end
--         end
--         if curStep == 388 then
--             for i = 0, 3 do
--                 setVarNote(i, "x", centerPosition[i%4 + 1])
--             end
--         end

--         if curStep == 440 then
--             for i = 0, 3 do
--                 noteVarTween(i, "x", centerPosition[i%4+1]-1200, crochet/1000*2, "quadin")
--             end
--             for i = 4, 7 do
--                 noteVarTween(i, "x", centerPosition[i%4+1], crochet/1000*2, "quadOut")
--             end
--         end

--         if curBeat == 112 then
--             for i = 4, 7 do
--                 setVarNote(i, "x", centerPosition[(i+curStep)%4 + 1])
--             end
--         end
--         if curStep == 452 then
--             for i = 4, 7 do
--                 setVarNote(i, "x", centerPosition[i%4 + 1])
--             end
--         end
        

--         if curStep == 508 then
--             for i = 0, 7 do
--                 noteVarTween(i, "y", defaultPosition[i+1].y, crochet/1000, "linear")
--             end

--             doTweenY("camBounceY", "camNotes", 0, crochet/1000, "linear")
--             doTweenX("camBounceX", "camNotes", 0, crochet/1000, "linear")
--             noteSpeedTween(1, crochet/1000, "linear")
--             wiggleTween(0, crochet/1000, "linear")
--         end

--         if curStep == 512 then
--             for i = 0, 3 do
--                 setPropertyFromGroup("strumLineNotes", i, "alpha", 0)
--                 setVarNote(i, "x", centerPosition[i%4 + 1])
--                 noteVarTween(i, "x", centerPosition[i%4+5], crochet/1000*16, "quadInOut")
--                 noteTweenAlpha("noteAlpha"..i, i, 1, crochet/1000*4)
--             end
--         end

--         if curStep == 632 and hardMode then
--             doTweenY("longTimeCome", "longTimeout", (downscroll and -150 + 300 or 720 - 300), crochet/1000*32, "quadOut")
--         end

--         if curStep >= 640 and curStep < 760 then
--             if curStep % 4 == 0 then
--                 doTweenY("camBounceY", "camNotes", downscroll and -50 or 50 * (getProperty("noteSpeed")), crochet/1000/2, "quadOut")
--                 doTweenX("camBounceX", "camNotes", curStep%8==0 and -50 or 50, crochet/1000, "quadOut")
--                 noteSpeedTween(0.5, crochet/1000/2, "quadOut")
--             elseif curStep % 4 == 2 then
--                 doTweenY("camBounceY", "camNotes", 0, crochet/1000/2, "quadIn")
--                 noteSpeedTween(1, crochet/1000/2, "quadIn")
--             end
--         end

--         if curStep == 760 then
--             doTweenY("longTimeOut", "longTimeout", (downscroll and -150 or 720), crochet/1000*2, "quadIn")
--             doTweenX("camBounceX", "camNotes", 0, crochet/1000*2, "quadIn")
--             doTweenY("camBounceY", "camNotes", 0, crochet/1000*2, "quadOut")
--         end
--     end

--     if curStep == 760 then
--         for i = 0, 7 do
--             noteVarTween(i, "y", -100, crochet/1000*2, "quadIn")
--             noteTweenAlpha("noteAlpha"..i, i, (i < 4 and 0 or 0.25), crochet/1000*2, "quadIn")
--         end
--     end
--     if curStep == 880 or curStep == 1136 then
--         for i = 4, 7 do
--             setVarNote(i, "x", centerPosition[i%4 + 5])
--             noteVarTween(i, "y", defaultPosition[i+1].y, crochet/1000*4, "quadOut")
--         end
--     end
--     if curStep == 1008 then
--         for i = 4, 7 do
--             noteVarTween(i, "y", -100, crochet/1000*4, "quadIn")
--         end
--     end
--     if curStep == 1264 then
--         for i = 0, 7 do
--             noteVarTween(i, "y", defaultPosition[i+1].y, crochet/1000*4, "quadOut")
--             noteVarTween(i, "x", defaultPosition[i+1].x, crochet/1000*4, "quadInOut")
--             noteTweenAlpha("noteAlpha"..i, i, 1, crochet/1000*4, "quadOut")
--         end
--     end
-- end

-- function onBeatHit()
--     if ((curStep >= 256 and curStep < 384) or (curStep >= 452 and curStep < 508)) and hardMode then
--         createTimeout()
--     end
-- end

-- local timeOutID = 0
-- function createTimeout()
--     timeOutID = timeOutID + 1
--     local tag = "timeoutSmall"..timeOutID
--     makeLuaSprite(tag, "mod/Timeout Note Blocker", 1280, 200 + (curBeat%4 * 100)) -- 150, 600
--     scaleObject(tag, 0.75, 0.75)
--     addLuaSprite(tag, true)
--     setObjectCamera(tag, "camHUD")

--     local distance = curStep >= 384 and 900 or (curBeat%2 == 0 and 600 or 400)
--     local duration = 0.6
--     doTweenX(tag.."comeIn", tag, getProperty(tag..".x") - distance, duration, "quadOut")
--     Timer.startTimer(duration, function(loops, loopsLeft)
--         doTweenX(tag, tag, getProperty(tag..".x") + distance, duration, "quadIn")
--     end, 1)
-- end

-- function onTimerCompleted(tag, loops, loopsLeft)
--     Timer.timerEnd(tag, loops, loopsLeft)
-- end

-- function onTweenCompleted(tag)
--     if string.find(tag, "timeoutSmall") then
--         removeLuaSprite(tag, true)
--     end
-- end


-- function getNote(id, var)return getPropertyFromGroup("notes", id, var) end
-- function setNote(id, var, value)return setPropertyFromGroup("notes", id, var, value) end
-- function lerp(a, b, t) return a + (b - a) * t end

-- function onUpdate(elapsed)
--     if songStart and not inGameOver and mechanicOption then
--         local wiggle, freq = getProperty("wiggle"), getProperty("wiggleFreq")
--         for i = 0, getProperty("notes.length")-1 do
--             local isSus = getPropertyFromGroup("notes", i, "isSustainNote")
--             local strumTime = getPropertyFromGroup("notes", i, "strumTime")
--             local distance = (strumTime - getSongPosition())/100
--             local wiggleX = math.sin(distance*freq)*(wiggle*25)
--             if strumTime >= 49548 and strumTime < 73548.38 then
--                 wiggleX = math.sin(distance*distance*0.25)*(distance*35)
--             end
--             setPropertyFromGroup("notes", i, "offsetX", (isSus and sustainOffset or 0) + wiggleX)
--             setPropertyFromGroup("notes", i, "multSpeed", getProperty("noteSpeed"))
--         end
--     end
-- end

-- function onUpdatePost(elapsed)
--     if mechanicOption then
--         if songStart and not inGameOver then
--             directionFixer()
--             for i = 0,7 do
--                 setPropertyFromGroup("strumLineNotes", i, "x", getVarNote(i, "x") + getVarNote(i, "2x"))
--                 setPropertyFromGroup("strumLineNotes", i, "y", getVarNote(i, "y") + getVarNote(i, "2y"))
--             end
--         end
--     end
-- end

-- function directionFixer()
--     for i = 0, getProperty("notes.length")-1 do
--         local isSus = getNote(i, "isSustainNote")
--         local noteData = getNote(i, "noteData")
--         if isSus then
--             setNote(i, "angle", getPropertyFromGroup("strumLineNotes", noteData, "direction")-90)
--         else
--             setNote(i, "angle", getPropertyFromGroup("strumLineNotes", noteData, "angle"))
--         end
--     end
-- end