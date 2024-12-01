--Arrows Distance : 640


function onCreate()
    luaDebugMode = true
    setProperty('cpuControlled', true)
    setProperty('spawnTime', 2500)
end
function onCreatePost()
 
    initMods()
end

local rev = downscroll and -1 or 1
local bassBeat = {
    0, 3, 6, 9, 12, 14,
    16, 19, 22, 25, 28, 30,
    32, 35, 38, 41, 44, 46,
    48, 51, 54, 56, 59, 62
}
function initMods()
    startMod('px', 'XModifier', 'player', -1); startMod('ox', 'XModifier', 'opponent', -1)
    startMod('px-a', 'XModifier', 'player', -1); startMod('ox-a', 'XModifier', 'opponent', -1)
    startMod('py', 'YModifier', 'player', -1); startMod('oy', 'YModifier', 'opponent', -1)
    startMod('pz', 'ZModifier', 'player', -1); startMod('oz', 'ZModifier', 'opponent', -1)
    startMod('pstealth', 'StealthModifier', 'player', -1); startMod('ostealth', 'StealthModifier', 'opponent', -1)
    startMod('pdrunkx', 'DrunkXModifier', 'player', -1); startMod('odrunkx', 'DrunkXModifier', 'opponent', -1)
    startMod('ptipsyy', 'TipsyYModifier', 'player', -1); startMod('otipsyy', 'TipsyYModifier', 'opponent', -1)
    startMod('psplit', 'SplitModifier', 'player', -1); startMod('osplit', 'SplitModifier', 'opponent', -1)
    startMod('boost', 'BoostModifier', '', -1)
    startMod('wave', 'BoostModifier', '', -1)
    startMod('wiggle', 'EaseCurveXModifier', '', -1); setModEaseFunc('wiggle', 'sineinout'); setSubMod('wiggle','speed' , 0.3)
    startMod('protate', 'StrumLineRotateModifier', 'player', -1); startMod('orotate', 'StrumLineRotateModifier', 'opponent', -1)
    startMod('preverse', 'ReverseModifier', 'player', -1); startMod('oreverse', 'ReverseModifier', 'opponent', -1)
    startMod('ptornado', 'TordnadoModifier', 'player', -1); startMod('otornado', 'TordnadoModifier', 'opponent', -1)

    setMod('px', -640/2)
    setMod('ox', 640/2)
    setMod('oy', -180 * rev)
    setMod('py', -180 * rev)
    setSubMod('pdrunkx', 'speed', 5)
    setSubMod('pdrunky', 'speed', 5)

    for i = 0,4 do
        startMod('px'..tostring(i), 'XModifier', 'lane', -1)
        setModTargetLane('px'..tostring(i), i+4)

        startMod('ox'..tostring(i), 'XModifier', 'lane', -1)
        setModTargetLane('ox'..tostring(i), i)
    end

    ease(0, 16, 'sineOut', '0, oy')

   
    ease(14, 16, 'sineInOut', [[
        0, py,
        -250, ox0,
        -250, ox1,
        250, ox2,
        250, ox3,
        -200, oz,
    ]])

    ease(30, 2, 'expoIn', [[
        0, py,
        0, ox0,
        0, ox1,
        0, ox2,
        0, ox3,
        0, oz,
        -250, pz,
        0.5, pstealth
    ]])
    

    for i, v in pairs(bassBeat) do
        local time = (v/4) + 16
        local inten = i%2 == 0 and 1 or -1
        set(time, [[
        ]]..inten..[[, pdrunkx,
        ]]..inten..[[, ptipsyy
        ]])
        ease(time, 1, 'quadOut', [[
        0, pdrunkx,
        0, ptipsyy
        ]], 'drunk')
    end

    ease(32, 1, 'linear', '1, boost')
    for beat = 0, (4*8-1) do
        local time = 32 + beat
        local char = (time < 48 and 'o' or 'p')
        ease(time, 0.5, 'quadOut', '0.2 ,' .. char .. 'split:Var' .. (beat%2==0 and 'A' or 'B'))
        ease(time+0.5, 0.5, 'quadIn', '0 ,' .. char .. 'split:Var' .. (beat%2==0 and 'A' or 'B'))

        if beat % 2 == 0 then
            local oppo = (beat % 4 == 0 and 1 or -1)
            ease(time+0.5, 0.5, 'expoIn', string.format("%s, wiggle, %s, %srotate:y, %s, %sx-a", 1000 * oppo, 50 * oppo, char, -100*oppo, char))
            ease(time+1, 1.25, 'quadOut', string.format("0, wiggle, 0, %srotate:y", char))
            ease(time+1, 1.25, 'quadOut', string.format("0, ox-a, 0, px-a"))
        end
    end

    ease(46, 2, 'expoInOut', [[
        0, pstealth,
        0.5, ostealth,
        0, pz,
        -250, oz,
    ]])

    ease(60, 4, 'quadInOut', [[
        0, oz,
        0, ostealth,
        0, ox,
        0, px
    ]])

    ease(64, 2, 'quadOut', [[
        90, ox,
        -90, px
    ]])
    set(64, '0.2 ,wiggle:speed')
    ease(64, 2, 'linear', '1, ptornado, 0.4, pstealth')
    ease(78, 2, 'linear', '0, ptornado, 0, pstealth')
    ease(80, 2, 'linear', '1, otornado, 0.4, ostealth')
    ease(94, 2, 'linear', '0, otornado, 0, ostealth')
    
    for beat = 0, (4*8-1) do
        local time = 64 + beat
        ease(time, 1, 'sineIn', [[
            ]]..(beat%2==0 and -150 or 125)..[[, oz,
            ]]..(beat%2==0 and 125 or -150)..[[, pz,
        ]])

        ease(time, 0.5, 'quadOut', '0.2, preverse, 0.2, oreverse')
        ease(time+0.5, 0.5, 'quadIn', '0, preverse, 0, oreverse')

        set(time, (time%2==0 and 600 or -600) ..' ,wiggle, 1, brake')
        ease(time, 1, 'quadOut', '0 ,wiggle, 0, brake')
    end

end