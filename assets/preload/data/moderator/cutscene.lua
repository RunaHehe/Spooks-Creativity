playVideo = true
playDialouge = false

function onStartCountdown()
	if isStoryMode and not seenCutscene then
		startVideo('Moderator Cutscene') -- default cutscene
		playVideo = false
		return Function_Stop -- prevents song from starting naturally
	end
	return Function_Continue -- played the video, song can start :3
end