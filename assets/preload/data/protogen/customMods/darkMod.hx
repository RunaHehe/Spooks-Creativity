//
function initMod(mod)
{
    mod.strumMath = function(noteData, lane, pf)
    {
        noteData.alpha *= 1 - mod.currentValue;
        mod.noteMath(noteData, lane, 0, pf);
    }
}