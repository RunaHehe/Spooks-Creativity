function onCreatePost()
    if CuteMode then
        setProperty("boyfriend.healthIcon", "ammar"..(CuteMode and 'cute' or ''))
        runHaxeCode([[
            game.iconP1.changeIcon("icon-ammar]]..(CuteMode and 'cute' or '')..[[");
        ]])
    end
end