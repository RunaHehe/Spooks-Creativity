//
function initMod(mod) {
    mod.noteMath = function(noteData, lane, curPos, pf)
    {
        var strumTime = Conductor.songPosition - (curPos / PlayState.SONG.speed);
        var noteDist = noteData.noteDist;
        var extra = 1 + strumTime;
        var distance = (strumTime - Conductor.songPosition)*0.4;
        var x = Math.sin(strumTime + extra) * (distance*noteDist);
        var y = Math.cos(strumTime + extra) * (distance*noteDist);

        noteData.x = x * mod.currentValue;
        noteData.y = y * mod.currentValue;
    }
}