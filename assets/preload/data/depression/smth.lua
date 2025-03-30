local accuracy = 100
local minOpacity = 0.1
local maxOpacity = 1.0

function onCreate()
    setPropertyFromClass("lime.app.Application", "current.window.opacity", maxOpacity)
end

function onUpdate(elapsed)
    local score = rating
    accuracy = score * 100

    local newOpacity = minOpacity + (accuracy/100) * (maxOpacity - minOpacity)

    setPropertyFromClass("lime.app.Application", "current.window.opacity", newOpacity)
end

function onDestroy()
    setPropertyFromClass("lime.app.Application", "current.window.opacity", 1.0)
end