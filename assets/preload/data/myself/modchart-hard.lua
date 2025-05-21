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
    luaDebugMode = false
    if not SourceCodeVer or not Modchart or not HardMode then return end
    setProperty('spawnTime', 4000)
    local downsc = downscroll and -1 or 1
end

function onUpdate(elapsed)
    if HardMode and not inGameOver then
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