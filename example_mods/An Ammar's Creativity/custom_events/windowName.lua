--nvm it isnt a lie
function onCreate()
    setPropertyFromClass("openfl.Lib", "application.window.title", "FNF: Spook's Creativity V1" )
    function onEvent(name, value1, value2)
      if name == "windowName" then
      setPropertyFromClass("openfl.Lib", "application.window.title", (value1))
      end
    end
end