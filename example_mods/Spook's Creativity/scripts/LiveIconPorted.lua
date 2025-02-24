-- "Hi meow" - AnAmmar
--? Just put this script into scripts folder
--? To make the icon play animation, insert the animation in images/animicons (create new folder)
--? you can get The animation template from An Ammar
local enable = true --! To Enable/Disable the scripts

local playerHasAnim = false
local enemyHasAnim = false

local playerTime = 0.0
local enemyTime = 0.0

local playerFrame = 0
local enemyFrame = 0

local playerPos = {0, 0}
local enemyPos = {0, 0}

local positionAdd = {{-1, 0}, {0, 1}, {0, -1}, {1, 0}}

local defaultPosition = {}


function onCreatePost()


    if songName == "Any Song" then
        enable = false
    end

    --------------


    if enable then
        local epath = "animicons/"
        local ppath = "animicons/"
        --? check if anim file exists
        if true then
            enemyHasAnim = true
            loadGraphic("iconP2", epath, 150, 150)
            addAnimation('iconP2', 'idle', {1, 3, 2, 0, 5, 4}, false, 0) -- idle, lose, left, down, up, right
        end

        if true then
            playerHasAnim = true
            loadGraphic("iconP1", ppath, 150, 150)
            addAnimation('iconP1', 'idle', {1, 3, 4, 0, 5, 2}, false, 0) -- idle, lose, left, down, up, right
            setProperty('iconP1.flipX', true)
        end
        local songIconSettings = {
            ["hate-comment"] = {
                playerIcon = {"runa", true},
                enemyIcon = {"annoyer", false}
            },
            ["big-problem"] = {
                playerIcon = {"runa", true}
            },
            ["discord-annoyer"] = {
                enemyIcon = {"runa", false},
                playerIcon = {"annoyer", true}
            },
            ["depression"] = {
                playerIcon = {"annoyer", true}
            },
            ["shut-up"] = {
                playerIcon = {"annoyer", true},
                enemyIcon = {"random-girl", false}
            },
            ["myself"] = {
                playerIcon = {"runa", true}
            },
            ["no-debug"] = {
                enemyIcon = {"runa", false}
            },
            ["programming-an-ammar"] = {
                enemyIcon = {"runa", false}
            },
            ["twitter-argument"] = {
                playerIcon = {"runa", true},
                enemyIcon = {"annoyer", false}
            },
            ["furry femboy"] = {
                playerIcon = {"runa", true},
            },
        }

        local icons = songIconSettings[songName:lower()]
        if icons then
            if icons.playerIcon then
                loadGraphic("iconP1", ppath .. icons.playerIcon[1], 150, 150)
                addAnimation('iconP1', 'idle', {1, 3, 4, 0, 5, 2}, false, 0)
                setProperty('iconP1.flipX', icons.playerIcon[2])
            end

            if icons.enemyIcon then
                loadGraphic("iconP2", epath .. icons.enemyIcon[1], 150, 150)
                addAnimation('iconP2', 'idle', {1, 3, 2, 0, 5, 4}, false, 0)
            end
        end
    end
end

function onStepHit()
    if curStep == 784 and songName:lower() == "depression" then
        loadGraphic("iconP1", ppath.. "runa", 150, 150)
        addAnimation('iconP1', 'idle', {1, 3, 4, 0, 5, 2}, false, 0) -- idle, lose, left, down, up, right
        setProperty('iconP1.flipX', true)
    end
end


function onSongStart()
    defaultPosition = {getProperty('iconP1.y'), getProperty('iconP2.y')}
end

function onUpdatePost(elapsed)
    if enable then
        if enemyHasAnim and enemyTime > 0 then
            enemyTime = enemyTime - elapsed
            setProperty("iconP2.animation.curAnim.curFrame", enemyFrame + 2)
        end

        if playerHasAnim and playerTime > 0 then
            playerTime = playerTime - elapsed
            setProperty("iconP1.animation.curAnim.curFrame", playerFrame + 2)
        end

        setProperty("iconP1.x", getProperty('iconP1.x') + playerPos[1])
        setProperty("iconP2.x", getProperty('iconP2.x') + enemyPos[1])
        if defaultPosition[1] ~= nil then
            setProperty("iconP1.y", defaultPosition[1] + playerPos[2])
            setProperty("iconP2.y", defaultPosition[2] + enemyPos[2])
        end

        playerPos[1] = lerp(playerPos[1], 0, elapsed*7)
        playerPos[2] = lerp(playerPos[2], 0, elapsed*7)
        enemyPos[1] = lerp(enemyPos[1], 0, elapsed*7)
        enemyPos[2] = lerp(enemyPos[2], 0, elapsed*7)
    end
end

function noteHit(isPlayer, noteData)
    local icon = isPlayer and "iconP1" or "iconP2"
    if isPlayer then
        playerTime = crochet/500
        playerFrame = noteData
        playerPos[1] = positionAdd[noteData + 1][1] * 10
        playerPos[2] = positionAdd[noteData + 1][2] * 10
    else
        enemyTime = crochet/500
        enemyFrame = noteData
        enemyPos[1] = positionAdd[noteData + 1][1] * 10
        enemyPos[2] = positionAdd[noteData + 1][2] * 10
    end
end

function goodNoteHit(membersIndex, noteData, noteType, isSustainNote) noteHit(true, noteData) end
function opponentNoteHit(membersIndex, noteData, noteType, isSustainNote) noteHit(false, noteData) end
function lerp(a, b, t) return a + (b - a) * t end