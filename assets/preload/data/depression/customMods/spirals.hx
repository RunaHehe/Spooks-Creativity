//
function initMod(mod)
{
	mod.incomingAngleMath = function(lane, curPos, pf)
	{
		if (lane % 2 == 0)
		{
			return [0, (mod.currentValue * 360) * 2 + curPos / 6];
		}
		return [0, (mod.currentValue * 360) * 2 - curPos / 6];
	}
}
