local membersSprites = {}
pbr = 1

function onCreatePost()
    pbr = getProperty("playbackRate")
    membersSprites = getProperty("membersSprites")
end

function onStepEvent(curStep)
    if (curStep >= 512 and curStep < 768) or (curStep >= 1024 and curStep < 1280) or (curStep >= 1536 and curStep < 2560) then 
        if curStep % 4 == 0 then
            for i,v in pairs(membersSprites) do
                if not v[3] then
                    local offsetX = 9
                    setProperty(v[1]..".xAdd", offsetX + (9*(i%2==0 and 1.4 or -1.4)*(curStep%8==0 and 1.4 or -1.4)))
                end
            end
        end
    end
    if curStep == 512 then
        setGlobalFromScript("stages/discordStage", "sideSinning", true)
        cancelTween('channelYMove')
        cancelTween('memberYMove')
    end
    if curStep == 768 then
        setGlobalFromScript("stages/discordStage", "sideSinning", false)
        cancelTween('channelYMove')
        cancelTween('memberYMove')
    end
    if curStep == 1024 then
        setGlobalFromScript("stages/discordStage", "sideSinning", true)
        cancelTween('channelYMove')
        cancelTween('memberYMove')
    end
    if curStep == 1280 then
        setGlobalFromScript("stages/discordStage", "sideSinning", false)
        cancelTween('channelYMove')
        cancelTween('memberYMove')
    end
    if curStep == 1536 then
        setGlobalFromScript("stages/discordStage", "sideSinning", true)
        cancelTween('channelYMove')
        cancelTween('memberYMove')
    end
    if curStep == 2560 then
        setGlobalFromScript("stages/discordStage", "sideSinning", false)
        cancelTween('channelYMove')
        cancelTween('memberYMove')
    end
end


function onUpdatePost(elapsed)
    if not inGameOver then
        for i,v in pairs(membersSprites) do
            if not v[3] then
                local offsetX = 7
                setProperty(v[1]..".xAdd", lerp(getProperty(v[1]..".xAdd"), offsetX, elapsed*7*pbr))
            end
        end
    end
end

function lerp(a, b, t) return a + (b - a) * t end
function continuous_sin(x) return math.sin((x % 1) * 2 * math.pi) end
