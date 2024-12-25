function onUpdate(elapsed)
    if keyPressed('left') then
        doTweenColor('timeBar', 'timeBar', 'C24B99', 0.01, 'linear');
    elseif keyPressed('right') then
        doTweenColor('timeBar', 'timeBar', 'F9393F', 0.01, 'linear');
    elseif keyPressed('down') then
        doTweenColor('timeBar', 'timeBar', '00FFFF', 0.01, 'linear');
    elseif keyPressed('up') then
        doTweenColor('timeBar', 'timeBar', '15FF00', 0.01, 'linear');
    else
        doTweenColor('timeBar', 'timeBar', 'FFFFFF', 0.4, 'linear');
    end
end