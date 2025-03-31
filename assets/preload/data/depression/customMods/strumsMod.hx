//
function initMod(mod)
{
	mod.currentValue = 1.0;
	mod.subValues.set('x', new ModifierSubValue(0.0));
	mod.subValues.set('y', new ModifierSubValue(0.0));
	mod.subValues.set('yD', new ModifierSubValue(0.0));
	mod.subValues.set('angle', new ModifierSubValue(0.0));
	mod.subValues.set('z', new ModifierSubValue(0.0));
	mod.subValues.set('skewx', new ModifierSubValue(0.0));
	mod.subValues.set('skewy', new ModifierSubValue(0.0));
	mod.subValues.set('invert', new ModifierSubValue(0.0));
	mod.subValues.set('flip', new ModifierSubValue(0.0));

	mod.strumMath = function(noteData:NotePositionData, lane:Int, pf:Int)
	{
		var daswitch = 1;
		if (game.instance != null)
			if (ModchartUtil.getDownscroll(game.instance))
				daswitch = -1;

		noteData.x += mod.subValues.get('x').value;
		noteData.y += mod.subValues.get('y').value;
		noteData.y += mod.subValues.get('yD').value * daswitch;
		noteData.angle += mod.subValues.get('angle').value;
		noteData.z += mod.subValues.get('z').value;
		noteData.skewX += mod.subValues.get('skewx').value * -daswitch;
		noteData.skewY += mod.subValues.get('skewy').value * -daswitch;

		noteData.x += NoteMovement.arrowSizes[lane] * (lane % 2 == 0 ? 1 : -1) * mod.subValues.get('invert').value;

		var nd = lane % NoteMovement.keyCount;
		var newPos = FlxMath.remapToRange(nd, 0, NoteMovement.keyCount, NoteMovement.keyCount, -NoteMovement.keyCount);
		noteData.x += NoteMovement.arrowSizes[lane] * newPos * mod.subValues.get('flip').value;
		noteData.x -= NoteMovement.arrowSizes[lane] * mod.subValues.get('flip').value;
	}
}
