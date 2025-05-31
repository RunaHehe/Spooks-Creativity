//
function initMod(mod)
{
    mod.noteMath = function (noteData:NotePositionData, lane:Int, curPos:Float, pf:Int) {
        noteData.angle += mod.currentValue;
    }

    mod.strumMath = function (noteData:NotePositionData, lane:Int, pf:Int) {
        mod.noteMath(noteData, lane, 0, pf);
    }

    mod.incomingAngleMath = function (lane:Int, curPos:Float, pf:Int) {
        return [0, mod.currentValue];
    }
}
