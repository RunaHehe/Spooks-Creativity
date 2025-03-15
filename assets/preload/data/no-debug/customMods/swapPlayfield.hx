//
function initMod(mod)
{
	mod.noteMath = function(noteData, lane, curPos, pf)
	{
		var swap = 640;
		if (lane >= 0 && lane <= 3)
		{
			noteData.x += swap * mod.currentValue;
		}
		if (lane >= 4 && lane <= 7)
		{
			noteData.x -= swap * mod.currentValue;
		}
	}
    mod.strumMath = function(noteData, lane, pf)
    {
        mod.noteMath(noteData, lane, 0, pf);
    }
}
