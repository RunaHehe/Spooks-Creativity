//
function initMod(mod)
{
    var differenceBetween:Float = 0;
    mod.strumMath = function(noteData, lane, pf)
    {
        var screenCenter:Float = (FlxG.height/2) - (NoteMovement.arrowSizes[lane]/2);
        differenceBetween = noteData.y - screenCenter;
        noteData.y -= mod.currentValue * differenceBetween;
    }
    mod.noteMath = function (noteData, lane, curPos, pf)
    {
        noteData.y -= mod.currentValue * differenceBetween;
    }
}