function onCreate()
    setPropertyFromClass("openfl.Lib", "application.window.title", "Friday Night Funkin': Psych Engine" )
    function onEvent(name, value1, value2)
      if name == "windowName" then
      setPropertyFromClass("openfl.Lib", "application.window.title", (value1))
      end
    end
end