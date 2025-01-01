local defaultName = "Spook's Creativity V1"

function onDestroy() -- can change to onSongEnd() if that works better for you (i don't recommend it though)
    setPropertyFromClass("openfl.Lib", "application.window.title", defaultName);
end