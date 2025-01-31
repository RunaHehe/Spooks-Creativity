-- script by spook >:3


-- how far is tilt
local intensity = 2.5

-- how fast is tilt
local speed = 1.1

-- edit this if you know how to fix black edges
local camGameScale = 1.07

-- theres no bug here
local camHUDScale = 1.02

-- close up look = X
local zoom = 0.95

-- dynamic tilting!! :3
local offset = 10

-- even the opponent!?
local opTiltEnabled = true


-- don't touch this unless u know what doing
function onCreatePost()

setProperty('camGame.flashSprite.scaleX', camGameScale)
setProperty('camGame.flashSprite.scaleY', camGameScale)
setProperty('camHUD.flashSprite.scaleX', camHUDScale)
setProperty('camHUD.flashSprite.scaleY', camHUDScale)
setProperty('defaultCamZoom', zoom)
end

function goodNoteHit(id, direction, noteType, isSustainNote)

 if mustHitSection == true then
    if not isSustainNote then
        if direction == 0 then
            doTweenAngle('CamTween1', 'camGame', (0-intensity), speed, 'quartOut')
            doTweenAngle('CamTween2', 'camHUD', (0-intensity), speed, 'quartOut')
            doTweenX('CamTween3', 'camGame', offset, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', offset, speed, 'quartOut')
        end

        if direction == 1 then
            doTweenAngle('CamTween1', 'camGame', 0, speed, 'quartOut ')
            doTweenAngle('CamTween2', 'camHUD', 0, speed, 'quartOut ')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', (0 - offset), speed, 'quartOut')
        end

        if direction == 2 then
            doTweenAngle('CamTween1', 'camGame', 0, speed, 'quartOut')
            doTweenAngle('CamTween2', 'camHUD', 0, speed, 'quartOut')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', offset, speed, 'quartOut')
        end

        if direction == 3 then
            doTweenAngle('CamTween1', 'camGame', intensity, speed, 'quartOut')
            doTweenAngle('CamTween2', 'camHUD', intensity, speed, 'quartOut')
            doTweenX('CamTween3', 'camGame', Xval, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', (0 - offset), speed, 'quartOut')
        end
    end
end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
if opTiltEnabled then
 if mustHitSection == false then
    if not isSustainNote then
        if direction == 0 then
            doTweenAngle('CamTween1', 'camGame', (0-intensity), speed, 'quartOut')
            doTweenAngle('CamTween2', 'camHUD', (0-intensity), speed, 'quartOut')
            doTweenX('CamTween3', 'camGame', offset, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', offset, speed, 'quartOut')
        end

        if direction == 1 then
            doTweenAngle('CamTween1', 'camGame', 0, speed, 'quartOut ')
            doTweenAngle('CamTween2', 'camHUD', 0, speed, 'quartOut ')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', (0 - offset), speed, 'quartOut')
        end

        if direction == 2 then
            doTweenAngle('CamTween1', 'camGame', 0, speed, 'quartOut')
            doTweenAngle('CamTween2', 'camHUD', 0, speed, 'quartOut')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', offset, speed, 'quartOut')
        end

        if direction == 3 then
            doTweenAngle('CamTween1', 'camGame', intensity, speed, 'quartOut')
            doTweenAngle('CamTween2', 'camHUD', intensity, speed, 'quartOut')
            doTweenX('CamTween3', 'camGame', Xval, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', (0 - offset), speed, 'quartOut')
        end
    end
end
end
end

function onUpdate()
if getProperty('dad.animation.curAnim.name') == 'idle' and mustHitSection == false and opTiltEnabled then
            doTweenAngle('CamTween1', 'camGame', 0, 0.3, 'quartOut')
            doTweenAngle('CamTween2', 'camHUD', 0, 0.3, 'quartOut')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', 0, speed, 'quartOut')
	end
if mustHitSection == false and not opTiltEnabled then
            doTweenAngle('CamTween1', 'camGame', 0, 0.3, 'quartOut')
            doTweenAngle('CamTween2', 'camHUD', 0, 0.3, 'quartOut')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', 0, speed, 'quartOut')
	end
if getProperty('boyfriend.animation.curAnim.name') == 'idle' and mustHitSection == true then
            doTweenAngle('CamTween1', 'camGame', 0, 0.3, 'quartOut')
            doTweenAngle('CamTween2', 'camHUD', 0, 0.3, 'quartOut')
            doTweenX('CamTween3', 'camGame', 0, speed, 'quartOut')
            doTweenY('CamTween4', 'camGame', 0, speed, 'quartOut')
	end
end