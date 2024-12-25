local susOff = 0
function onCreatePost()
    for i = 0, getProperty("unspawnNotes.length")-1 do
        if getPropertyFromGroup("unspawnNotes", i, 'isSustainNote') then
            susOff = getPropertyFromGroup("unspawnNotes", i, 'offsetX') 
            break
        end
    end

    if Modchart and HardMode then
        makeLuaSprite('split', 1, 0)
        setSpriteShader("split", "split")
        setShaderFloat("split", "multi", 1)

        runHaxeCode([[
            camNotes.setFilters([new ShaderFilter(game.getLuaObject("split").shader)]);
            game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("split").shader)]);
            game.camGame.setFilters([new ShaderFilter(game.getLuaObject("split").shader)]);
        ]])
    end
end

local plr, opp, all = 0, 1, -1
function onCountdownStarted()
    luaDebugMode = true
    if not SourceCodeVer or not Modchart or not HardMode then return end
    setProperty('spawnTime', 4000)
    setValue('wiggleFreq', 0.6)
    local downsc = downscroll and -1 or 1
    -- player 0 = bf
    -- player 1 = dad
    ease(0, 7*4, 'opponentSwap', 0.5, 'sineInOut', all)
    ease(28, 2, 'tipsy', 3, 'quadOut', all)
    ease(28, 2, 'alpha', 1, 'quadOut', all)
    set(40, 'alpha', 0, all)
    set(40, 'brake', 0.75, all)
    set(40, 'xmod', 0.5, all)
    set(40, 'tipsy', 0, all)
    ease(52, 4, 'alpha', 1, 'linear', opp)  set(52+4+12, 'alpha', 0, opp)
    local beat = {0, 3, 4.5, 6, 0+8, 3+8, 4.5+8, 6+8, 0+16, 3+16, 4.5+16, 6+24, 0+24, 1.5+24, 3+24, 4.5+24, 6+24, 7+24}
    local db = false
    for _, beat in pairs(beat) do
        db = db == false
        local time = 40 + beat
        local player = time >= 56 and plr or opp
        set(time, 'wiggle', 5 * (db and 1 or -1), player)
        ease(time, 1, 'wiggle', 0, 'quadOut', player)
    end
    ease(72, 8, 'tipZ', 1, 'linear', all)
    ease(72, 8, 'drunk', 0.75, 'linear', all)
    ease(72, 8, 'brake', 0.25, 'linear', all)
    ease(84, 4, 'alpha', 1, 'linear', opp)  set(84+4+12, 'alpha', 0, opp)

    for beat = 0, 7-1 do
        local time = 72 + (beat * 4) + 2
        ease(time-0.2, 0.2, 'localrotateZ', math.rad(beat%2==0 and 40 or -40), 'expoIn')
        ease(time, 2, 'localrotateZ', 0, 'quadOut')

        ease(time-0.2, 0.2, 'wiggle',beat%2==0 and -6 or 6, 'expoIn')
        ease(time, 1, 'wiggle', 0, 'quadOut')
    end
    ease(100, 1, 'tipZ', 0)
    ease(100, 1, 'drunk', 0)
    ease(100, 1, 'brake', 0)
    --ease(100, 2, 'opponentSwap', 1, 'circOut')
    ease(100, 2, 'wiggle', 3, 'circOut')
    --ease(102, 2, 'opponentSwap', 0, 'circIn')
    ease(103, 2, 'wiggle', 0, 'circIn')
    ease(102, 2, 'xmod', 0.75, 'quadIn')
    ease(104, 2, 'transformZ', -0.5, 'quadOut', plr)

    for beat = 0, (4*14)-1 do
        --set(104+(beat)-0.5, 'beat', beat%2==0 and 1 or -1)
        ease(104+(beat)-0.25, 0.25, 'transformX', beat%2==0 and 100 or -100, 'expoIn')
        ease(104+(beat), 0.75, 'transformX', 0, 'circOut')

        ease(104+(beat)-0.25, 0.25, 'wiggle', beat%2==0 and 4 or -4, 'expoIn')
        ease(104+(beat), 0.75, 'wiggle', 0, 'circOut')

        ease(104+(beat)-0.25, 0.25, 'brake', 2, 'expoIn')
        ease(104+(beat), 0.75, 'brake', 0, 'circOut')

        if beat % 2 == 1 then
            ease(104+(beat)-0.25, 0.25, 'localrotateZ', math.rad(beat%4==1 and 30 or -30), 'expoIn')
            ease(104+(beat), 0.75, 'localrotateZ', 0, 'circOut')

            ease(104+(beat)-0.25, 0.25, 'confusion', beat%4==1 and 40 or -40, 'expoIn')
            ease(104+(beat), 0.75, 'confusion', 0, 'circOut')

            ease(104+(beat)-0.25, 0.25, 'tipsy', beat%4==1 and 3 or -3, 'expoIn')
            ease(104+(beat), 0.75, 'tipsy', 0, 'circOut')
        end
    end
    local db = false
    local beatBox = function(time)
        set(time, 'tipsy', 2 * (db and 1 or -1))
        ease(time, 1.5, 'tipsy', 0, 'expoOut')

        set(time, 'wiggle', 2 * (db and 1 or -1))
        ease(time, 1.5, 'wiggle', 0, 'expoOut')

        set(time, 'invert', 0.4 * (db and 1 or -1))
        ease(time, 1.5, 'invert', 0, 'expoOut')
    end
    for beat = 0, 7 do
        local time = 160 + beat
        db = db == false
        beatBox(time)
    end
    beatBox(162.75)
    beatBox(164.75)
    beatBox(165.75)
    beatBox(166.25)


    ease(112, 4, 'sudden', 0.5)
    ease(120, 1, 'sudden', 0)

    ease(133.5, 1.5, 'transformZ', 0, '',plr)
    ease(133.5, 1.5, 'alpha', 1, 'linear',opp)

    ease(167, 1, 'alpha', 0, 'quadIn', opp)
    ease(168, 1, 'alpha', 1, 'quadIn', plr)
    ease(167, 1, 'flip', -0.6, 'quadIn', opp)

    for beat = 0, (4*16)-1 do
        local time = 168 + beat
        if beat % 4 == 0 then
            ease(time - 2, 2, 'boost', 0.5, 'quadIn')
            ease(time, 2, 'boost', 0, 'quadOut')
            ease(time - 2, 2, 'xmod', 0.35, 'quadIn')
            ease(time, 2, 'xmod', 0.75, 'quadOut')
        end

        set(time, 'invert', 0.25 * (beat%2==0 and 1 or -1))
        ease(time, 1, 'invert', 0, 'quadOut')
    end

    set(170, 'reverse', 1, plr)
    set(170, 'flip', -0.6, plr)
    ease(196, 4, 'alpha', 0, 'linear', plr)
    ease(200, 2, 'reverse', 0, 'quadOut', plr)
    ease(200, 2, 'reverse', 1, 'quadOut', opp)
    ease(200, 2, 'alpha', 1, 'quadOut', opp)


    ease(230, 2, 'flip', 0, 'quadIn')
    ease(232, 2, 'alpha', 0.4, 'linear', opp)
    ease(232, 2, 'reverse', 0, 'linear')

    for beat = 0, (4*16)-1 do
        local time = 232 + beat

        ease(time , 0.5, 'reverse', 0.15, 'quadOut', time < 264 and opp or plr)
        ease(time + 0.5, 0.5, 'reverse', 0, 'quadIn', time < 264 and opp or plr)
        if beat%2==0 then
            ease(time , 1, 'reverse', 0.15, 'quadOut', time < 264 and plr or opp)
            ease(time + 1, 1, 'reverse', 0, 'quadIn', time < 264 and plr or opp)
        end
        
        set(time, 'flip', beat%2==0 and 0.2 or -0.2)
        ease(time , 0.5, 'flip', 0, 'quadOut')

        set(time, 'tipsy', beat%2==0 and 1 or -1)
        ease(time , 0.6, 'tipsy', 0, 'quadOut')
        
    end

    ease(296, 1, 'transformZ', 0, 'quadOut')
    ease(296, 1, 'transformX', 0, 'quadOut')

    ease(304, 4*15, 'wiggle', 2, 'linear')
    for beat = 0, (4*16)-1 do
        local time = 304 + beat
        if beat % 4 == 0 then
            ease(time + 2, 2, 'xmod', 0.75- 0.25, 'quadIn')
            ease(time, 2, 'xmod', 0.75, 'quadOut')
        end
    end
    ease(364, 4, 'wiggle', 0, 'quadIn')

    ease(368, 2, 'xmod', 0.85, 'quadOut', opp)
    ease(368, 2, 'drunk', -1.5, 'quadOut')
    for beat = 0, (4*16)-1 do
        local time = 368 + beat
        set(time, 'tipsy', 2 * (beat%2 == 0 and 1 or -1))
        ease(time, 1, 'tipsy', 0, 'quadOut')
        
    end


    ease(432, 1, 'drunk', 0, 'quadOut')
    ease(432, 8*4, 'opponentSwap', 0, 'linear')
    ease(432, 4, 'wave', 2, 'linear')
    ease(432, 1, 'xmod', 0.85, 'quadOut')

    ease(448, 8, 'wave', 0, 'linear')
    ease(448, 1, 'xmod', 2, 'linear', opp)
    ease(463, 1, 'xmod', 0.75, 'linear', opp)
    ease(463, 1, 'alpha', 0, 'linear', opp)

    for beat = 0, (4*16)-1 do
        local time = 528 + beat
        set(time, 'wiggle', 7 * (beat%2 == 0 and 1 or -1))
        ease(time, 1, 'wiggle', 0, 'quadOut')

        set(time, 'flip', 0.2 * (beat%2 == 0 and 1 or -1))
        ease(time, 1, 'flip', 0, 'quadOut')

        set(time, 'tipZ', 1 * (beat%2 == 0 and 1 or -1))
        ease(time, 1, 'tipZ', 0, 'quadOut')
        
    end
    ease(592, 8, 'alpha', 1)
end

function onUpdate(elapsed)
    if HardMode and not inGameOver then
        if curBeat >= 232 and curBeat < 296 then
            setValue('transformX', continuous_sin(curDecBeat/8) * 300, plr)
            setValue('transformX', continuous_sin((curDecBeat)/8 + 0.5) * 300, opp)

            setValue('transformZ', -0.1 + continuous_cos(curDecBeat/8) * 0.2, plr)
            setValue('transformZ', -0.1 + continuous_cos((curDecBeat)/8 + 0.5) * 0.2, opp)
        end
        if curBeat >= (528) and curBeat < (592) then
            setShaderFloat("split", "multi", getProperty('split.x'))
        end
    end
end

function onUpdatePost(elapsed)
    if not inGameOver and HardMode then
        if curBeat < 464 then
            if curBeat < 296 then
                setProperty('camNotesFake.zoom', getProperty('camHUD.zoom') + (curBeat >= 232 and -0.6 or 0))
            elseif curBeat >= 298 then
                setProperty('camNotesFake.zoom', 1)
            else
                setProperty('camNotesFake.zoom', lerp(0.4, 1, ((curDecBeat-296) / 1.5)))
            end
        end

        if curBeat >= 464 and curBeat < 528 then
            setProperty('camNotesFake.zoom', getProperty('camHUD.zoom'))
            if curBeat < 528 then
                setProperty("camNotes.x", ((curDecBeat%4)/4) * 1280)
                setProperty("camNotesFake.x", -1280 + ((curDecBeat%4)/4) * 1280)
            end
        end
    end
end

function onStepEvent(step)
    if HardMode then
        if step == (167*4) then
            setProperty('camNotesFake.alpha', 0)
            setProperty('camNotesFake.visible', true)
            doTweenAlpha('fake', 'camNotesFake', 1, crochet/1000, 'quadIn')
            doTweenX('camNotesX', 'camNotes', -55, crochet/1000, 'quadIn')
            doTweenX('camNotesFakeX', 'camNotesFake', 55, crochet/1000, 'quadIn')
        end

        if step == (230*4) then
            doTweenAlpha('fake', 'camNotesFake', 0.75, crochet/1000, 'expoIn')
            doTweenX('camNotesX', 'camNotes', 0, crochet/1000, 'quadIn')
            doTweenX('camNotesFakeX', 'camNotesFake', 0, crochet/1000, 'quadIn')
        end
        if step == (232*4) then
            doTweenAngle('fake2', 'camNotesFake', 180, crochet/1000*2, 'quadOut')
        end
        if step == (304*4) then
            doTweenAlpha('fake', 'camNotesFake', 0.5, crochet/1000*2, 'quadOut')
        end
        if step == (306*4) then
            doTweenAlpha('fake', 'camNotesFake', 0, crochet/1000*4*12, 'linear')
        end
        if step == (464*4) then
            cancelTween('fake')
            setProperty('camNotesFake.angle', 0);
            setProperty('camNotesFake.alpha', 1);
            setProperty('camNotesFake.x', -1280);
        end
        if step == (528*4) then
            setProperty("camNotes.x", 0)
            setProperty("camNotesFake.x", -1280)
        end
        if step >= (528*4) and step < (592*4) then
            if (step >= (544*4) and step < (560*4)) or (step >= (576*4)) then
                if step % 8 == 0 then
                    doTweenX('split', 'split', 2, 0.05, 'quadOut')
                elseif step % 8 == 4 then
                    doTweenX('split', 'split', 3, 0.05, 'quadOut')
                end
            else
                if step % 8 == 0 then
                    doTweenX('split', 'split', 2, 0.05, 'quadOut')
                elseif step % 8 == 4 then
                    doTweenX('split', 'split', 1, 0.05, 'quadOut')
                end
            end
        end
        if step == 592 * 4 then
            setShaderFloat("split", "multi", 1)
        end
    end
end

function continuous_sin(x) return math.sin((x%1)*2*math.pi) end
function continuous_cos(x) return math.cos((x%1)*2*math.pi) end
function lerp(a, b, t)
	return a + (b - a) * t
end