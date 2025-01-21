local camfirst = true
function camBeat(v1)
    if camfirst then
        setProperty('camHUD.angle', v1)
        camfirst = false
    else
        setProperty('camHUD.angle', -v1)
        camfirst = true
    end
    doTweenAngle("hi camHUD", "camHUD", 0, 1, "expoOut")
end

function continuous_sin(x)
    return math.sin((x % 1) * w * math.pi)
end

function onUpdate(elapsed)
    if ((curStep > 384 and curStep < 640)) then
        setProperty("camHUD.angle", continuous_sin(curDecStep / 16) * 5)
        if curStep == 640 then
            setProperty("camHUD.angle", 0)
        end
    end
end

function onStepHit()
    if curStep == 384 then
        callScript("stages/discordStage", "lightingMode", {true})
        cameraFlash("other", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", EasyMode and 0.5 or 1, true)
    end

    if (curStep >= 384 and curStep < 640) or (curStep >= 768 and curStep < 1024) or (curStep >= 1088 and curStep < 1152) then
        if curStep % 4 == 0 then
            camBeat(5)
        end
    end

    if curStep == 512 then
        cameraFlash("other", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", EasyMode and 1 or 1, true)
    end

    if curStep == 640 then
        callScript("stages/discordStage", "lightingMode", {false})
        cameraFlash("other", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", EasyMode and 0.5 or 1, true)
    end

    if curStep >= 704 and curStep < 768 then
        if curStep % 8 == 0 then
            camBeat(2)
        end
    end

    if curStep == 768 then
        callScript("stages/discordStage", "lightingMode", {true})
        cameraFlash("other", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", EasyMode and 0.5 or 1, true)
    end

    if curStep == 896 then
        cameraFlash("other", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", EasyMode and 1 or 1, true)
    end

    if curStep == 1024 then
        callScript("stages/discordStage", "lightingMode", {false})
        cameraFlash("other", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", EasyMode and 0.5 or 1, true)
    end
end
function lerp(a, b, t) return a + (b - a) * t end