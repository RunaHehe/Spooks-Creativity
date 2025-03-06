//
function initMod(mod)
{
	mod.incomingAngleMath = function(lane:Int, curPos:Float, playField:Int)
	{
		var strumTime = Conductor.songPosition - curPos / PlayState.SONG.speed;
		return [0, mod.currentValue * (strumTime * 0.08)];
	}
}
