playVideo = true;
playDialogue = false;

function onStartCountdown()
    if not seenCutscene then
        if playVideo then --cutscene plays first lmao
            startVideo('Identity Cutscene'); --video lmao
            playVideo = false;
            return Function_Stop; --prevents song from starting
        end
    end
    return Function_Continue; --played video, song can start >:3
end