//
function initMod(mod)
{
	mod.incomingAngleMath = function(lane, curPos, pf)
	{
		if (lane >= 4 && lane <= 5)
			return [0, mod.currentValue * -(curPos * 0.015)];
		else
			return [0, mod.currentValue * (curPos * 0.015)];
	};
}
