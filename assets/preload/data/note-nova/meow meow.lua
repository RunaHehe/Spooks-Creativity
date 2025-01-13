function onStepHit()
    if curStep == 384 then
        callScript("stages/discordStage", "lightingMode", {true})
        cameraFlash("other", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", EasyMode and 0.5 or 1, true)
    end

    if curStep == 512 then
        callScript("stages/discordStage", "lightingMode", {true})
        cameraFlash("other", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", EasyMode and 1 or 1, true)
    end

    if curStep == 640 then
        callScript("stages/discordStage", "lightingMode", {false})
        cameraFlash("other", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", EasyMode and 0.5 or 1, true)
    end

    if curStep == 768 then
        callScript("stages/discordStage", "lightingMode", {true})
        cameraFlash("other", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", EasyMode and 0.5 or 1, true)
    end

    if curStep == 896 then
        callScript("stages/discordStage", "lightingMode", {true})
        cameraFlash("other", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", EasyMode and 1 or 1, true)
    end

    if curStep == 1024 then
        callScript("stages/discordStage", "lightingMode", {false})
        cameraFlash("other", flashingLights and "0xB0FFFFFF" or "0x90FFFFFF", EasyMode and 0.5 or 1, true)
    end
end