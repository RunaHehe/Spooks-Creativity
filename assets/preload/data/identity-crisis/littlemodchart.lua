local middleEnabled = false
function onCreate()
    middleEnabled = getPropertyFromClass('ClientPrefs', 'middleScroll')
    setPropertyFromClass('ClientPrefs', 'middleScroll', false)
    setPropertyFromClass('PlayState', 'middleScroll', false)
end
function onCreatePost()
    setupMods()
    setMod("dadAlpha", 1)
    setMod("dadY", -150)
    setMod("bfX", -350)
    setupEvents()
end

function setupMods()
    startMod("dadAlpha", "StealthModifier", "opponent", -1)
    startMod("dadY", "YDModifier", "opponent", -1)
    startMod("bfX", "XModifier", "player", -1)
    startMod("strumA", "LaneStealthModifier", "", -1)
end

function setupEvents()
    ease(16, 16, "linear", "0, dadAlpha")
    ease(16, 16, "quadOut", "0, dadY")
    ease(16, 16, "quadIn", "0, bfX")
    ease(48, 15, "linear", "1, strumA")
    ease(62, 3, "linear", "0, strumA")
    ease(92, 1, "linear", "1, strumA")
    set(96, "0, strumA")
end

function onDestroy()
    if middleEnabled then
        setPropertyFromClass('ClientPrefs', 'middleScroll', true)
        setPropertyFromClass('PlayState', 'middleScroll', true)
    end
end