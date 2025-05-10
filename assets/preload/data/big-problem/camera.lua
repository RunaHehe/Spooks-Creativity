
local tweens = {}

function onStepEvent(curStep)
    if curStep == 520 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.2, 0.09)
    end
    if curStep == 523 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.4, 0.09)
    end
    if curStep == 526 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.6, 0.09)
    end
    if curStep == 528 then
        doTweenVar('camZooming', 'defaultCamZoom', 0.9, 0.09)
    end
    if curStep == 536 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.2, 0.09)
    end
    if curStep == 539 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.4, 0.09)
    end
    if curStep == 542 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.6, 0.09)
    end
    if curStep == 544 then
        doTweenVar('camZooming', 'defaultCamZoom', 0.9, 0.09)
    end
    if curStep == 552 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.2, 0.09)
    end
    if curStep == 555 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.4, 0.09)
    end
    if curStep == 558 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.6, 0.09)
    end
    if curStep == 560 then
        doTweenVar('camZooming', 'defaultCamZoom', 0.9, 0.09)
    end
    if curStep == 568 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.2, 0.09)
    end
    if curStep == 571 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.4, 0.09)
    end
    if curStep == 574 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.6, 0.09)
    end
    if curStep == 576 then
        doTweenVar('camZooming', 'defaultCamZoom', 0.9, 0.09)
    end
    if curStep == 584 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.2, 0.09)
    end
    if curStep == 587 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.4, 0.09)
    end
    if curStep == 590 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.6, 0.09)
    end
    if curStep == 592 then
        doTweenVar('camZooming', 'defaultCamZoom', 0.9, 0.09)
    end
    if curStep == 600 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.2, 0.09)
    end
    if curStep == 603 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.4, 0.09)
    end
    if curStep == 606 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.6, 0.09)
    end
    if curStep == 608 then
        doTweenVar('camZooming', 'defaultCamZoom', 0.9, 0.09)
    end
    if curStep == 616 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.2, 0.09)
    end
    if curStep == 619 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.4, 0.09)
    end
    if curStep == 622 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.6, 0.09)
    end
    if curStep == 624 then
        doTweenVar('camZooming', 'defaultCamZoom', 0.9, 0.09)
    end
    if curStep == 632 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.2, 0.09)
    end
    if curStep == 635 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.4, 0.09)
    end
    if curStep == 638 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.6, 0.09)
    end
    if curStep == 648 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.2, 0.09)
    end
    if curStep == 651 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.4, 0.09)
    end
    if curStep == 654 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.6, 0.09)
    end
    if curStep == 656 then
        doTweenVar('camZooming', 'defaultCamZoom', 0.8, 0.09)
    end
    if curStep == 664 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.2, 0.09)
    end
    if curStep == 667 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.4, 0.09)
    end
    if curStep == 670 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.6, 0.09)
    end
    if curStep == 672 then
        doTweenVar('camZooming', 'defaultCamZoom', 0.8, 0.09)
    end
    if curStep == 680 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.2, 0.09)
    end
    if curStep == 683 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.4, 0.09)
    end
    if curStep == 686 then
        doTweenVar('camZooming', 'defaultCamZoom', 1.6, 0.09)
    end
    if curStep == 688 then
        doTweenVar('camZooming', 'defaultCamZoom', 0.8, 0.09)
    end
    if curStep == 696 then
        triggerEvent("Add Camera Zoom", 0.3, 0.3)
    end
    if curStep == 699 then
        triggerEvent("Add Camera Zoom", 0.3, 0.3)
    end
    if curStep == 702 then
        triggerEvent("Add Camera Zoom", 0.45, 0.45)
    end
end

function onUpdate(elapsed)
    for tag, tweenData in pairs(tweens) do
        tweenData.elapsedTime = tweenData.elapsedTime + elapsed
        local t = tweenData.elapsedTime / tweenData.duration
        
        local currentValue = tweenData.startValue + (tweenData.endValue - tweenData.startValue) * t
        setProperty(tweenData.object, currentValue)
        
        if tweenData.elapsedTime >= tweenData.duration then
            setProperty(tweenData.object, tweenData.endValue)
            tweens[tag] = nil
        end
    end
end

function doTweenVar(tag, object, endValue, duration)
    if tweens[tag] then
        tweens[tag] = nil
    end
    
    local startValue = getProperty(object)
    tweens[tag] = {
        object = object,
        startValue = startValue,
        endValue = endValue,
        duration = duration,
        elapsedTime = 0
    }
end