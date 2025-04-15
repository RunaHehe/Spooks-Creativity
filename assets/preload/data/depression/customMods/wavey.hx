//
function initMod(mod)
{
    mod.subValues.set('period', new ModifierSubValue(0.0));
	mod.noteMath = function(noteData:NotePositionData, lane:Int, curPos:Float, pf:Int)
	{
        var period = mod.subValues.get("period").value;
        var shift = noteData.noteDist * 0.25 * (1 + period);
        noteData.y = noteData.y +  shift * mod.currentValue;
	}
}
