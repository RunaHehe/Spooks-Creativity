local module = {}

local TimeStuff = {}

tagNum = 0
function module.startTimer(duration, functionToTrigger, loops)
    tagNum = tagNum + 1

    runTimer("timerModuleTag"..tagNum, tonumber(duration) or 1, loops or 1)
    TimeStuff["timerModuleTag"..tagNum] = functionToTrigger or function()end
end
function module.timerEnd(tag, loops, loopsLeft) -- put this on onTimerCompleted
    if TimeStuff[tag] ~= nil then 
        TimeStuff[tag](loops, loopsLeft)
        if loopsLeft <= 0 then 
            TimeStuff[tag] = nil
        end
    end
end

return module