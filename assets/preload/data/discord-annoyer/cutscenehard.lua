playVideo = true;
playDialouge = false;

function onStartCountdown()
	if not seenCutscene then
		if playVideo and HardMode then
			startVideo('Annoying Cutscene HARD'); -- hard cutscene
			playVideo = false;
			return Function_Stop; -- prevents song from starting naturally
		end
	end
	return Function_Continue; -- played the video, song can start :3
end