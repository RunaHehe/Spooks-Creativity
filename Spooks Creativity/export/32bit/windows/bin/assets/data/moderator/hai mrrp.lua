local fullscreen = nil
local OGx = nil
local OGy = nil
local OGwidth = nil
local OGheight = nil

function onCreate()
    OGx = getPropertyFromClass("openfl.Lib", "application.window.x")
    OGy = getPropertyFromClass("openfl.Lib", "application.window.y")
    OGwidth = getPropertyFromClass("openfl.Lib", "application.window.width")
    OGheight = getPropertyFromClass("openfl.Lib", "application.window.height")
    setPropertyFromClass("openfl.Lib", "application.window.borderless", true)
    setWindowColor(0x0000ff00)
end

function onUpdatePost(elapsed)
    fullscreen = getPropertyFromClass("openfl.Lib", "application.window.fullscreen")
end

function moveW(v1,v2,v3,v4,v5)
    callScript("scripts/Window Modchart Tool", "moveW", {v1, v2, v3, v4, v5})
end
function setWindow(v1,v2)
    callScript("scripts/Window Modchart Tool", "setW", {v1, v2})
end
function resetWindow(v1)
    callScript("scripts/Window Modchart Tool", "resetW", {v1})
end

function onDestroy()
    setPropertyFromClass("openfl.Lib", "application.window.x", OGx)
    setPropertyFromClass("openfl.Lib", "application.window.y", OGy)
    setPropertyFromClass("openfl.Lib", "application.window.width", OGwidth)
    setPropertyFromClass("openfl.Lib", "application.window.height", OGheight)
    setPropertyFromClass("openfl.Lib", "application.window.fullscreen", false)
    setPropertyFromClass("openfl.Lib", "application.window.borderless", false)
    setWindowColor(0x0000ff00)
end

function onStepHit()
    if curStep == 64 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 50, 1, "expoOut"})
    end

    if curStep == 80 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 650, 1, "expoOut"})
    end

    if curStep == 96 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -30, 1, "expoOut"})
    end

    if curStep == 112 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "move", 80 + 50, 1, "expoOut"})
    end

    if curStep == 120 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 650, 1, "expoOut"})
    end

    if curStep == 128 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 1, "expoOut"})
    end

    if curStep == 144 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 600, 1, "expoOut"})
    end

    if curStep == 148 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -50, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -40, 0.6, "expoOut"})
    end

    if curStep == 152 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 200, 0.6, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 600, 0.6, "expoOut"})
    end

    if curStep == 156 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -30, 1, "expoOut"})
    end

    if curStep == 160 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 0.6, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 0.6, "expoOut"})
    end

    if curStep == 176 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 200, 1.1, "expoOut"})
    end

    if curStep == 184 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -20, 1, "expoOut"})
    end

    if curStep == 192 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 0.6, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 0.6, "expoOut"})
    end

    if curStep == 208 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 600, 1, "expoOut"})
    end

    if curStep == 212 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -50, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -40, 0.6, "expoOut"})
    end

    if curStep == 216 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 200, 0.6, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 600, 0.6, "expoOut"})
    end

    if curStep == 220 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -30, 1, "expoOut"})
    end

    if curStep == 224 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 0.6, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 0.6, "expoOut"})
    end

    if curStep == 240 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 200, 1.1, "expoOut"})
    end

    if curStep == 248 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -20, 0.9, "expoOut"})
    end

    if curStep == 252 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -20, 1, "expoOut"})
    end

    if curStep == 256 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1, "expoOut"})
    end

    if curStep == 272 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -20, 1, "expoOut"})
    end

    if curStep == 284 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 650, 1, "expoOut"})
    end

    if curStep == 288 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 10, 1, "expoOut"})
    end

    if curStep == 300 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 150, 1, "expoOut"})
    end

    if curStep == 304 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -10, 1, "expoOut"})
    end

    if curStep == 312 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 600, 1, "expoOut"})
    end

    if curStep == 320 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1, "expoOut"})
    end

    if curStep == 368 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -10, 1, "expoOut"})
    end

    if curStep == 370 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 400, 1, "expoOut"})
    end

    if curStep == 372 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 1, "expoOut"})
    end

    if curStep == 374 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1, "expoOut"})
    end

    if curStep == 375 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 0.2, "expoOut"})
    end

    if curStep == 388 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 1, "expoOut"})
    end

    if curStep == 404 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1, "expoOut"})
    end

    if curStep == 420 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 1, "expoOut"})
    end

    if curStep == 436 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1, "expoOut"})
    end

    if curStep == 444 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1, "expoOut"})
    end

    if curStep == 448 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 1, "expoOut"})
    end

    if curStep == 452 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 1, "expoOut"})
    end

    if curStep == 468 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1, "expoOut"})
    end

    if curStep == 484 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 1, "expoOut"})
    end

    if curStep == 500 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1, "expoOut"})
    end

    if curStep == 508 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 1, "expoOut"})
    end

    if curStep == 512 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1, "expoOut"})
    end

    if curStep == 575 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 150, 1, "expoOut"})
    end

    if curStep == 592 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -60, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -20, 1, "expoOut"})
    end

    if curStep == 608 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -40, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1, "expoOut"})
    end

    if curStep == 624 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 500, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 0.1, "expoOut"})
    end

    if curStep == 627 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 0.3, "expoOut"})
    end

    if curStep == 630 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 150, 0.3, "expoOut"})
    end

    if curStep == 632 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 0.3, "expoOut"})
    end

    if curStep == 635 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 0.3, "expoOut"})
    end

    if curStep == 638 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 250, 0.3, "expoOut"})
    end

    if curStep == 640 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 0.3, "expoOut"})
    end

    if curStep == 652 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -50, 1, "expoOut"})
    end

    if curStep == 656 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 1, "expoOut"})
    end

    if curStep == 668 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 0.3, "expoOut"})
    end

    if curStep == 672 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 3, "expoOut"})
    end

    if curStep == 684 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 0.3, "expoOut"})
    end

    if curStep == 688 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -250, 2, "expoOut"})
    end

    if curStep == 696 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 500, 0.3, "expoOut"})
    end

    if curStep == 708 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 0.3, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 0.3, "expoOut"})
    end

    if curStep == 724 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 0.3, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -250, 2, "expoOut"})
    end

    if curStep == 740 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 500, 0.6, "expoOut"})
    end

    if curStep == 752 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 1.3, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1.3, "expoOut"})
    end

    if curStep == 756 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 1.5, "expoOut"})
    end

    if curStep == 760 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 0.3, "expoOut"})
    end

    if curStep == 768 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 8, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 8, "expoOut"})
    end

    if curStep == 1280 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 2, "expoOut"})
    end

    if curStep == 1295 then
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -100, 2, "expoOut"})
    end

    if curStep == 1312 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 500, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"height", "appear Height", OGheight * 1.1, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"width", "appear Width", OGwidth * 1.09, 1, "expoOut"})
    end

    if curStep == 1328 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1, "expoOut"})
    end

    if curStep == 1344 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 500, 1, "expoOut"})
    end

    if curStep == 1360 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -20, 1, "expoOut"})
    end

    if curStep == 1376 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 300, 1, "expoOut"})
    end

    if curStep == 1392 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1, "expoOut"})
    end

    if curStep == 1412 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 300, 1, "expoOut"})
    end

    if curStep == 1428 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -20, 1, "expoOut"})
    end

    if curStep == 1444 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1.5, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1.4, "expoOut"})
    end

    if curStep == 1460 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 200, 1, "expoOut"})
    end

    if curStep == 1468 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1, "expoOut"})
    end

    if curStep == 1476 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 300, 1, "expoOut"})
    end

    if curStep == 1492 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -20, 1, "expoOut"})
    end

    if curStep == 1508 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 250, 1.5, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1.4, "expoOut"})
    end

    if curStep == 1524 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + -15, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + 200, 1, "expoOut"})
    end

    if curStep == 1532 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 80 + 100, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 80 + -10, 1, "expoOut"})
    end

    if curStep == 1535 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1, "expoOut"})
    end

    if curStep == 1552 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + -10, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + 300, 1, "expoOut"})
    end

    if curStep == 1568 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + 150, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + -10, 1, "expoOut"})
    end

    if curStep == 1584 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1, "expoOut"})
    end

    if curStep == 1600 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + 250, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1, "expoOut"})
    end

    if curStep == 1616 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + -10, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + 300, 1, "expoOut"})
    end

    if curStep == 1632 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + 150, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + -10, 1, "expoOut"})
    end

    if curStep == 1648 then
        callScript("scripts/Window Modchart Tool", "moveW", {"y", "set", 0 + OGy, 1, "expoOut"})
        callScript("scripts/Window Modchart Tool", "moveW", {"x", "move", 0 + OGx, 1, "expoOut"})
    end

end 