//
function initMod(mod)
{
	var posPlayer = 320;
	var posOP = 640;

	mod.noteMath = function(noteData, lane, curPos, pf)
	{
		if (lane >= 2 && lane <= 3)
		{
			noteData.x += posOP * mod.currentValue;
		}
		if (lane >= 4 && lane <= 7)
		{
			noteData.x -= posPlayer * mod.currentValue;
		}
	}

	mod.strumMath =  function (noteData, lane, pf)
	{
		mod.noteMath(noteData, lane, 0, pf);
	}
}
