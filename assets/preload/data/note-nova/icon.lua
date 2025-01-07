function onCreatePost()
    if CuteMode then
        setProperty("dad.healthIcon", "annoyer")
        runHaxeCode([[
            game.iconP2.changeIcon("icon-annoyer");
        ]])
    else
        runHaxeCode([[
            game.iconP2.changeIcon("icon-annoyer");
        ]])
    end

setHealthBarColors("ffc400", "60f542")
end