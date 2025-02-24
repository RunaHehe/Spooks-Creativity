local module = {}

local steps = {}

function module.getSteps()
    return steps
end
function module.checkStep()
    if steps ~= nil then 
        for i,v in pairs(steps) do 
            if _G[v.var] >= v.value then
                if v.func ~= nil then
                    v.func()
                end
                table.remove(steps, i)
            else
                break
            end
        end
    end
end

function module.addStep(varName, requiredValue, functionToRun)
    local varN = varName
    if varN == "curBeat" then
        varN = curStep
        requiredValue = requiredValue * 4
    end
    if varN == "curDecBeat" then
        varN = curDecStep
        requiredValue = requiredValue * 4
    end

    table.insert(steps, 1, {var = varN, value = requiredValue, func = functionToRun})

    table.sort(steps, function (k1, k2) return k1.value < k2.value end )
end

return module