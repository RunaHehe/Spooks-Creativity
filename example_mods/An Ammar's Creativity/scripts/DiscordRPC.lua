--[[
HEY!!

PLEASE credit me if you use this discord rpc cool thing.
PLEASE credit me if you use this discord rpc cool thing.
PLEASE credit me if you use this discord rpc cool thing.
PLEASE credit me if you use this discord rpc cool thing.
PLEASE credit me if you use this discord rpc cool thing.

you get 2 links that you can put on your mod/engine/whatever
linktree: https://linktr.ee/uwenalil
bsky    : https://bsky.app/profile/weirdpersontbh.bsky.social
]]
local symbol = "•"
--uses stephit because it lags when its on update :p
function onStepHit()
    if curStep > 0 then
        if hits < 1 then
            changePresence(
                "".. formatTime(getSongPosition() - noteOffset) .. ' - ' .. formatTime(songLength).." "..symbol.." "..songName,
                "Score: 0 "..symbol.." Misses: 0 "..symbol.." Rating: 0% (N/A) "..symbol.." Combo: 0"
            )
        end
        if hits > 0 or misses > 1 then
            changePresence(
                "".. formatTime(getSongPosition() - noteOffset) .. ' - ' .. formatTime(songLength).." "..symbol.." "..songName,
                "Score: ".. score .." "..symbol.." Misses: ".. misses .." "..symbol.." Rating: ".. round(rating * 100, 2) .. "% (" .. ratingFC .. ") "..symbol.." Combo: "..getProperty("combo")
            )
        end
    end
end 

-- i love being freaky- i mean spying- i mean cool
function onPausePost()
    changePresence("Game Paused! "..symbol.." "..songName, "The player has paused the game! Maybe they'll be back? :3")
end
function onFocusPost()
    changePresence("Game Paused! "..symbol.." "..songName, "The player has paused the game! Maybe they'll be back? :3")
end
function onFocusLostPost()
    if not inGameOver then
        changePresence("Game Lost Focus! "..symbol.." "..songName, "The player tabbed out! Hopefully they tab back in..")
    end
end
function onGameOver()
    changePresence("Game Over... "..symbol.." "..songName, "The player has died...")
end
function onGameOverConfirm(retry)
	if retry == true then
        changePresence("Game Over... "..symbol.." "..songName, "Player has retried!")
    else
        changePresence("Game Over... "..symbol.." "..songName, "Player has quit...")
    end
end
function onCountdownTick(count)
    -- THE ACTUAL COUNTDOWN TICK
    if count == 0 then
        changePresence("Starting... "..symbol.." "..songName, "ON YOUR MARK")
    end
    if count == 1 then
        changePresence("Starting... "..symbol.." "..songName, "GET READY")
    end
    if count == 2 then
        changePresence("Starting... "..symbol.." "..songName, "GET SET")
    end
    if count == 3 then
        changePresence("Starting... "..symbol.." "..songName, "START!")
    end
end

function round(x, n) -- https://stackoverflow.com/questions/18313171/lua-rounding-numbers-and-then-truncate
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then
        x = math.floor(x + 0.5)
    else
        x = math.ceil(x - 0.5)
    end
    return x / n
end

function formatTime(millisecond)
    local seconds = math.floor(millisecond / 1000)
    return string.format("%01d:%02d", (seconds / 60) % 60, seconds % 60)
end