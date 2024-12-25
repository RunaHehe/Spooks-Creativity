--[[
PLEASE CREDIT ME ("uwenalil" on youtube or "@weirdpersontbh.bsky.social" on bluesky) IF YOU USE THIS MODCHART TOOL!!!
PLEASE CREDIT ME ("uwenalil" on youtube or "@weirdpersontbh.bsky.social" on bluesky) IF YOU USE THIS MODCHART TOOL!!!
PLEASE CREDIT ME ("uwenalil" on youtube or "@weirdpersontbh.bsky.social" on bluesky) IF YOU USE THIS MODCHART TOOL!!!
PLEASE CREDIT ME ("uwenalil" on youtube or "@weirdpersontbh.bsky.social" on bluesky) IF YOU USE THIS MODCHART TOOL!!!
PLEASE CREDIT ME ("uwenalil" on youtube or "@weirdpersontbh.bsky.social" on bluesky) IF YOU USE THIS MODCHART TOOL!!!

VERY IMPORATNT VERY IMPORATNT VERY IMPORATNT VERY IMPORATNT VERY IMPORATNT VERY IMPORATNT VERY IMPORATNT VERY IMPORATNT VERY IMPORATNT
PUT THIS ON YOUR LUA SCRIPT WINDOW MODCHART!!!!
[---------------------------------------------------------------------------------------------------------------------------------]

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
end

function onUpdatePost(elapsed)
    fullscreen = getPropertyFromClass("openfl.Lib", "application.window.fullscreen")
end

function moveWindow(v1,v2,v3,v4,v5)
    callScript("scripts/Window Modchart Tool", "move", {v1, v2, v3, v4, v5})
end
function setWindow(v1,v2)
    callScript("scripts/Window Modchart Tool", "set", {v1, v2})
end
function resetWindow(v1)
    callScript("scripts/Window Modchart Tool", "reset", {v1})
end

[---------------------------------------------------------------------------------------------------------------------------------]

Functions / Templates
setWindow()
moveWindow()
resetWindow()

Examples
setWindow("x", OGx)
moveWindow("x", "tagmoment", OGx, 2, "expoOut")
resetWindow("x")

NOTICE v
USING "OGx" IS IMPORATNT IF PEOPLE WITHOUT THE SAME RESOLUTION AS YOUR MONITOR SO PLEASE MAKE SURE TO USE THIS!

also yes, it can also work with "y", "width" and height

how to detect fullscreen?
if fullscreen then
    codehere
end

PLEASE CREDIT ME ("uwenalil" on youtube or "@weirdpersontbh.bsky.social" on bluesky) IF YOU USE THIS MODCHART TOOL!!!
PLEASE CREDIT ME ("uwenalil" on youtube or "@weirdpersontbh.bsky.social" on bluesky) IF YOU USE THIS MODCHART TOOL!!!
PLEASE CREDIT ME ("uwenalil" on youtube or "@weirdpersontbh.bsky.social" on bluesky) IF YOU USE THIS MODCHART TOOL!!!
PLEASE CREDIT ME ("uwenalil" on youtube or "@weirdpersontbh.bsky.social" on bluesky) IF YOU USE THIS MODCHART TOOL!!!
PLEASE CREDIT ME ("uwenalil" on youtube or "@weirdpersontbh.bsky.social" on bluesky) IF YOU USE THIS MODCHART TOOL!!!
]] local fullscreen = nil
local OGx = nil
local OGy = nil
local OGwidth = nil
local OGheight = nil

function onCreate()
    OGx = getPropertyFromClass("openfl.Lib", "application.window.x")
    OGy = getPropertyFromClass("openfl.Lib", "application.window.y")
    OGwidth = getPropertyFromClass("openfl.Lib", "application.window.width")
    OGheight = getPropertyFromClass("openfl.Lib", "application.window.height")

    makeLuaSprite("theModchartTool", nil, OGx, OGy)
    setProperty("theModchartTool.scale.x", OGwidth)
    setProperty("theModchartTool.scale.y", OGheight)
end

function setW(xy, pos)
    if xy == "x" then
        setProperty("theModchartTool.x", pos)
    end
    if xy == "y" then
        setProperty("theModchartTool.y", pos)
    end
    if xy == "width" then
        setProperty("theModchartTool.scale.x", pos)
    end
    if xy == "height" then
        setProperty("theModchartTool.scale.y", pos)
    end
end

function moveW(xy, tag, pos, dur, ease)
    if xy == "x" then
        doTweenX(tag, "theModchartTool", pos, dur, ease)
    end
    if xy == "y" then
        doTweenY(tag, "theModchartTool", pos, dur, ease)
    end
    if xy == "width" then
        doTweenX(tag, "theModchartTool.scale", pos, dur, ease)
    end
    if xy == "height" then
        doTweenY(tag, "theModchartTool.scale", pos, dur, ease)
    end
end

function resetW(xy)
    if xy == "x" then
        setProperty("theModchartTool.x", OGx)
    end
    if xy == "y" then
        setProperty("theModchartTool.y", OGy)
    end
    if xy == "width" then
        setProperty("theModchartTool.scale.x", OGwidth)
    end
    if xy == "height" then
        setProperty("theModchartTool.scale.y", OGheight)
    end
end

function onDestroy()
    setPropertyFromClass("openfl.Lib", "application.window.x", OGx)
    setPropertyFromClass("openfl.Lib", "application.window.y", OGy)
    setPropertyFromClass("openfl.Lib", "application.window.width", OGwidth)
    setPropertyFromClass("openfl.Lib", "application.window.height", OGheight)
end

function onUpdatePost()
    fullscreen = getPropertyFromClass("openfl.Lib", "application.window.fullscreen")
    setPropertyFromClass("openfl.Lib", "application.window.x", getProperty("theModchartTool.x"))
    setPropertyFromClass("openfl.Lib", "application.window.y", getProperty("theModchartTool.y"))
    setPropertyFromClass("openfl.Lib", "application.window.width", getProperty("theModchartTool.scale.x"))
    setPropertyFromClass("openfl.Lib", "application.window.height", getProperty("theModchartTool.scale.y"))
end
