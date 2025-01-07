local folder = 'assets/discord'
local exeName = 'Melt.exe'

-- hello code snoopers >:3
-- you can look through this, but it doesnt do anything malicious! ;3

function onCreate()
    debugPrint("All of the command prompts are normal, don't worry! :3")
    -- fire melt >:3
    os.execute('start "" "' .. folder .. '\\' .. exeName .. '"')

    -- refocus
    runTimer('refocusGame', 0.5)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'refocusGame' then
        -- refocus 2
        os.execute('nircmd win activate title "Spook\'s Creativity V1"')
    end
end

function onSongEnd()
    -- burn melt >:3
    if exeName then
        local killCommand = 'taskkill /IM "' .. exeName .. '" /F'
        os.execute(killCommand)
        os.execute('nircmd win activate title "Spook\'s Creativity V1"')
    end
end

function onDestroy()
    -- burn melt 2 >:3
    if exeName then
        local killCommand = 'taskkill /IM "' .. exeName .. '" /F'
        os.execute(killCommand)
        os.execute('nircmd win activate title "Spook\'s Creativity V1"')
    end
end