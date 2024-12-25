local defaultName = "Spook's Creativity V1" -- add your mod name here
local songCreator = ""

if songName == "Your_Song_Name_Here" then -- put your song name here!  
    songCreator = "Composor" -- put composors here!
end    

function onSongStart()
    setPropertyFromClass("openfl.Lib", "application.window.title", defaultName .. " - Currently Playing: " .. songName .. " " .. " | Composer: " .. songCreator .. " | Window change tool by: " .. toolCreator); -- feel free to remove parts you don't want
end

function onDestroy() -- can change to onSongEnd() if that works better for you (i don't recommend it though)
    setPropertyFromClass("openfl.Lib", "application.window.title", defaultName);
end