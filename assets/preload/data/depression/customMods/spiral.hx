//
function initMod(mod)
{
    mod.incomingAngleMath = function (lane:Int, curPos:Float, pf:Int) {
        var strumTime = Conductor.songPosition - curPos / PlayState.SONG.speed;
        return [0, mod.currentValue * (strumTime * 0.5)];
    }
}