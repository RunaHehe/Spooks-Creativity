playVideo = true
playDialouge = false

function onStartCountdown()
	if isStoryMode and not seenCutscene then
		if playVideo then
			startVideo('Random Girl Cutscene') -- default cutscene
			playVideo = false
			return Function_Stop -- prevents song from starting naturally
		end
	end
	return Function_Continue -- played the video, song can start :3
end