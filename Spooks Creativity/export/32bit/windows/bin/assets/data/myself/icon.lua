function onCreatePost()
    if CuteMode then
        setProperty("boyfriend.healthIcon", "spook")
        runHaxeCode([[
            game.iconP1.changeIcon("icon-spook");
        ]])
    end
end