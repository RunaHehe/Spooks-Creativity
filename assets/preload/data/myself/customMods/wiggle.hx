//
function initMod(mod)
{
	mod.noteMath = function (noteData:NotePositionData, lane:Int, curPos:Float, pf:Int)
	{
		noteData.x += FlxMath.fastSin(0 + (curPos * 0.004)) * (NoteMovement.arrowSizes[lane] * 1 * mod.currentValue * 0.5);
	}
}
