local notesSpeeds =  {}
local notesOffset = {}

local distancePerOne = 1
function onCreatePost()
    luaDebugMode = true
    distancePerOne = (1 * scrollSpeed)
    setProperty("cpuControlled", true)

    for i = 0, getProperty("unspawnNotes.length")-1 do 
      table.insert(notesSpeeds, {getPropertyFromGroup("unspawnNotes", i, "strumTime"), getPropertyFromGroup("unspawnNotes", i, "multSpeed")})
    end

    for event = 0, getProperty('eventNotes.length') - 1 do 
        local pauser = (getPropertyFromGroup('eventNotes', event, 'event') == 'Speed Change v2')
        local eventTime = getPropertyFromGroup('eventNotes', event, 'strumTime')
        local value1 = tonumber(getPropertyFromGroup('eventNotes', event, 'value1') )
        local value2 = tonumber(getPropertyFromGroup('eventNotes', event, 'value2') )

        local currentScrollSpeed = getCurrentSpeed(eventTime);
        local nnspeed = getTotalValueBefore(eventTime)
        
        
        if pauser then
            
            for note = 0, getProperty('unspawnNotes.length') - 1 do
                local strumTime = getPropertyFromGroup('unspawnNotes', note, 'strumTime')
                local offse = (((math.abs(eventTime - strumTime)) * 0.45) *  ((value1-1) * -1) * (currentScrollSpeed + nnspeed)) * (downscroll and 1 or -1)
               if eventTime <= strumTime  then 
                    setPropertyFromGroup('unspawnNotes', note, 'offsetY', getPropertyFromGroup('unspawnNotes', note, 'offsetY') + offse)
                 end
            end
           table.insert( notesOffset, {eventTime, currentScrollSpeed, nnspeed})
        end
    end
end

function getTotalValueBefore(time)
    local speedEvent = {}
    for event = 0, getProperty('eventNotes.length')-1 do 
        if (getPropertyFromGroup('eventNotes', event, 'event') == 'Speed Change v2') then 
            table.insert(speedEvent, {
                ["strumTime"] = getPropertyFromGroup('eventNotes', event, 'strumTime'),
                ["value1"] = getPropertyFromGroup('eventNotes', event, 'value1'),
                ["value2"] = getPropertyFromGroup('eventNotes', event, 'value2')
            })
        end
    end
    local totalValue = 0
    for event = 1, #speedEvent do 
        if speedEvent[event]["strumTime"] >= time then 
            return totalValue
        else 
            totalValue = totalValue + speedEvent[event]["value1"]
        end
    end
end

function getCurrentSpeed(time)
    local speedEvent = {}
    for event = 0, getProperty('eventNotes.length')-1 do 
        if (getPropertyFromGroup('eventNotes', event, 'event') == 'Speed Change v2') then 
            table.insert(speedEvent, {
                ["strumTime"] = getPropertyFromGroup('eventNotes', event, 'strumTime'),
                ["value1"] = getPropertyFromGroup('eventNotes', event, 'value1'),
                ["value2"] = getPropertyFromGroup('eventNotes', event, 'value2')
            })
        end
    end
    if #speedEvent <= 1 then return scrollSpeed end
    for event = 1, #speedEvent do 
        if speedEvent[1]["strumTime"] == time then 
            return scrollSpeed
        else
            if speedEvent[event]["strumTime"] >= time then 
                return speedEvent[event - 1]["value1"]
            end
        end
    end
end

function onEvent(name, value1, value2)
    if name == "Speed Change v2" then 
        triggerEvent("Change Scroll Speed", value1, value2)
        for i = 1,2 do
            local groups = {"notes", "unspawnNotes"}
            local group = groups[i]
            local nnspeed = notesOffset[1][3]
            for note = 0, getProperty(group..'.length') - 1 do
                local strumTime = getPropertyFromGroup(group, note, 'strumTime')
                if  notesOffset[1][1] <= strumTime then 
                    local offse = (((math.abs(notesOffset[1][1] - strumTime)) * 0.45) *   ((value1-1) * -1) * (notesOffset[1][2] + nnspeed)) * (downscroll and 1 or -1)
                    setPropertyFromGroup(group, note, 'offsetY', getPropertyFromGroup(group, note, 'offsetY') - offse)
                end
            end
        end
        
        table.remove( notesOffset, 1 )
    end
end


