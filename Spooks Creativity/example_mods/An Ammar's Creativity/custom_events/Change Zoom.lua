-- Event notes hooks


local GlobalTarget = 0;
defaultZoom = 0

globalZoomTween = 0
isTweening = false

function onCreatePost()
	defaultZoom = getProperty("defaultCamZoom")
	if songName:lower() == "shut-up" then defaultZoom = 0.9 end

	makeLuaSprite("tweenZoomThingOK", "", defaultZoom ,0)
	makeGraphic("tweenZoomThingOK", 1, 1, "0x00000000")
	GlobalTarget = defaultZoom
end
function onEvent(name, value1, value2)
	if name == 'Change Zoom' then
		local operation = ""
		duration = ((value2 == nil or value2 == "" or value2 == " ") and 0 or tonumber(value2));

		if string.find(value1, "+") then operation = "+" 
		elseif string.find(value1, "-") then operation = "-" 
		else operation = ""  end

		local changedValue1 = 0
		if operation ~= "" then changedValue1 = value1:gsub("%" .. operation, "") else changedValue1 = value1 end -- get only number
		target = ((changedValue1 == nil or changedValue1 == "" or changedValue1 == " ") and defaultZoom or tonumber(changedValue1));


		if duration <= 0 then
			cancelTween("ZoomingEvent"); isTweening = false;
			local result = (operation == "+" and getProperty("defaultCamZoom") + target or (operation == "-" and getProperty("defaultCamZoom") - target or target))
			setProperty("defaultCamZoom", result);
			GlobalTarget = result
		else 
			local result = (operation == "+" and getProperty("defaultCamZoom") + target or (operation == "-" and getProperty("defaultCamZoom") - target or target))
			cancelTween("ZoomingEvent"); isTweening = true
			setProperty("tweenZoomThingOK.x", getProperty("camGame.zoom"));
			GlobalTarget = result;
			doTweenX("ZoomingEvent", "tweenZoomThingOK", result, duration/getProperty("playbackRate"), "quadInOut")
			
		end

		
		--debugPrint('Event triggered: ', name, duration, targetAlpha);
	end
end

function onUpdatePost(elapsed)
	if isTweening then 
		if getProperty("camZooming") then
			setProperty("defaultCamZoom", getProperty("tweenZoomThingOK.x"))
		else 
			setProperty("camGame.zoom", getProperty("tweenZoomThingOK.x"))
		end

	end
end

function onTweenCompleted(tag)
	if tag == "ZoomingEvent" then 
		setProperty("defaultCamZoom", GlobalTarget);
		isTweening = false
	end
end
