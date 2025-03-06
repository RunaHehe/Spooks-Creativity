//
function initMod(mod)
{
    mod.noteMath = function(noteData, lane, curPos, pf)
    {
        var strumTime = Conductor.songPosition - curPos / PlayState.SONG.speed;
        var strumStem = strumTime / Conductor.stepCrochet;
    }
}