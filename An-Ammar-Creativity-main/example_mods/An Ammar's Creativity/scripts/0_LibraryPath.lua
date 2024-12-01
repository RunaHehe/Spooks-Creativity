function onCreate()
     -- FINALLY Fixed on mobile!!!!!!
     local folderPath = getPath() .. "modules/?.lua"
     package.path = folderPath .. ";" .. package.path
     modulePath = folderPath
     runHaxeCode([[setVar('modulePath', "]]..modulePath..[[")]])
end

function getPath() -- public
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*/)")
end