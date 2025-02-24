local desempleo = false
local shit = false
local middle = false
local bfCam = {x = 0, y = 0}
local dadCam = {x = 0, y = 0}
local midCam = {x = 0, y = 0}

function onCreatePost()
    dadCam = {x = (getMidpoint('dad').x + 150) + (getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]')), y = (getMidpoint('dad').y - 100) + (getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]'))}
    bfCam = {x = (getMidpoint('boyfriend').x - 100) - (getProperty('boyfriend.cameraPosition[0]') - getProperty('boyfriendCameraOffset[0]')), y = (getMidpoint('boyfriend').y - 100) + (getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]'))}
    midCam = {x = dadCam.x + (bfCam.x - dadCam.x)*0.5, y = dadCam.y + (bfCam.y - dadCam.y)*0.5}
end

function onEvent(n,v1,v2)
    if n == 'Camera Shit' then
        local lowV1 = v1:lower()
        local lowV2 = v2:lower()
        desempleo = (lowV2 == 'true' or lowV2 == '' and true or lowV2 == 'false' and false)
        shit = (lowV1 ~= '' and (lowV1 == 'false' and false or lowV1 == 'true' and true) or (not desempleo and (mustHitSection) or (not shit)))
        middle = lowV1 == 'middle'
    end
end

function onUpdatePost()
    if desempleo then
        setProperty('camGame.followLerp', 1)
        setProperty('camFollow.x', (not middle and (shit and bfCam.x or dadCam.x) or midCam.x))
        setProperty('camFollow.y', (not middle and (shit and bfCam.y or dadCam.y) or midCam.y))
    end
end

function getMidpoint(shit)
    local farsy = {x = 0, y = 0}
    farsy.x = getProperty(shit..'.x') + getProperty(shit..'.width')*0.5
    farsy.y = getProperty(shit..'.y') + getProperty(shit..'.height')*0.5
    
    return farsy
end