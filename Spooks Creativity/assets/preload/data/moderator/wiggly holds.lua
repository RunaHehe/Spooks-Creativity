WIGGLE_AMPLITUDE = 0.06                            --amplitude/size/width of the waves
WIGGLE_FREQUENCY = 25                                --frequency/amount of waves
WIGGLE_SPEED = 4                                  --speed of the waves
WIGGLE_AMPLITUDE_DRAIN_MULTIPLIER = 6               --how fast the amplitude drains every frame
WIGGLE_STEP_MOD = 4                                 --at what steps should the wave amplitude be set at (4 steps = 1 beat, 8 steps = 2 beats, 2 steps = 0.5 beats)









---------------------------------
---- IGNORE THIS DOWN BELOW! ----
---------------------------------


local l = false
local amplit = 0
local function lerp(a,b,t) return a + (b-a) * t end

function onCreatePost()
	addHaxeLibrary('Paths')
	addHaxeLibrary('OverlayShader')
	addHaxeLibrary('ColorSwap')
	addHaxeLibrary('WiggleEffectType', 'WiggleEffect')
	addHaxeLibrary('BlendMode', 'openfl.display')
	addHaxeLibrary('ShaderFilter', 'openfl.filters')
	addHaxeLibrary('FlxCamera', 'flixel')

    runHaxeCode([[
		wiggg = new WiggleEffect();

        susCam = new FlxCamera();
		susCam.bgColor = '#569677';

		FlxG.cameras.remove(game.camHUD, false);
		FlxG.cameras.remove(game.camOther, false);

		FlxG.cameras.add(susCam, false);
		FlxG.cameras.add(game.camHUD, false);
		FlxG.cameras.add(game.camOther, false);
    ]])
end
function onUpdate(elapsed)
    amplit = lerp(amplit, 0, elapsed*WIGGLE_AMPLITUDE_DRAIN_MULTIPLIER)
    runHaxeCode([[
        susCam.setFilters([new ShaderFilter(wiggg.shader)]);

		wiggg.waveSpeed = ]]..tostring(WIGGLE_SPEED)..[[;
        wiggg.waveFrequency = ]]..tostring(WIGGLE_FREQUENCY)..[[;
        wiggg.waveAmplitude = ]]..tostring(amplit)..[[;

        wiggg.update(]]..elapsed..[[);

        for (note in game.notes)
        {
            if (note.isSustainNote)
            {
                note.cameras = [susCam];//[game.camOther];
            }
        }
	]])
end
function onStepHit()
    if curStep % WIGGLE_STEP_MOD == 0 then
        l = not l
        if l then
            amplit = -WIGGLE_AMPLITUDE
        else
            amplit = WIGGLE_AMPLITUDE
        end
    end
end