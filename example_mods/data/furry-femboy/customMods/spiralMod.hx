//
function initMod(mod)
{
	/**
		code written by An Ammar 
		*i'm not smart enough for this
	**/
	mod.incomingAngleMath = function(lane:Int, curPos:Float, playField:Int)
	{
		var strumTime = Conductor.songPosition - curPos / PlayState.SONG.speed;
		return [0, mod.currentValue * (strumTime * 0.08)];
	}
	mod.noteMath = function(noteData, lane, curPos, pf)
	{
		noteData.angle = mod.currentValue - (curPos / 15);
	}
}
