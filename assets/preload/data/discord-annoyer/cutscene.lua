playVideo = true
playDialouge = false

function onStartCountdown()
	if isStoryMode and not seenCutscene then
		if HardMode then
			startVideo('Annoying Cutscene HARD') -- hard cutscene
		else
			startVideo('Annoying Cutscene') -- normal cutscene
		end
		playVideo = false
		return Function_Stop -- prevents song from starting naturally
	end
	return Function_Continue -- played the video, song can start :3
end