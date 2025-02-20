playVideo = true
playDialouge = false

function onStartCountdown()
	if not seenCutscene then
		if playVideo then
			math.randomseed(os.time())
			if math.random(5) == 1 then
				startVideo('unfortunate') -- 1/5 chance
			else
				startVideo('Identity Cutscene') -- default cutscene
			end
			playVideo = false
			return Function_Stop -- prevents song from starting naturally
		end
	end
	return Function_Continue -- played the video, song can start :3
end