function onEvent(name, value1, value2)
    if name == "Borderless" then
        setPropertyFromClass("openfl.Lib", "application.window.borderless", true)
    end
end