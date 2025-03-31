//
function initMod(mod)
    {
        /**
            Code written by An Ammar
            1st Beat, Notes at same place (player to right, opponent to left)
            3rd Beat, Notes at swap place (player to left, opponent to right)
        **/
        mod.subValues.set('switchStrum', new ModifierSubValue(0.0)); //mod.subValues.get('switchStrum').value
        var ns:Float = 640;
        
        mod.noteMath = function(noteData, lane, curPos, pf)
        {
            var swStrum:Float = mod.subValues.get('switchStrum').value;
            var strumTime = Conductor.songPosition - (curPos / PlayState.SONG.speed);
            var beat = strumTime / Conductor.crochet;
            var isOpponent = (lane%8) < 4;
    
            noteData.x += ns * (beat % 4 < 2 ? (-1 * (isOpponent ? -1 : 1)) : 0) * mod.currentValue; //(beat % 4 < 2 ? -ns : ns)
        }
    
        mod.strumMath = function(noteData, lane, pf)
        {
            var isOpponent = (lane%8) < 4;
            var swStrum:Float = mod.subValues.get('switchStrum').value * (isOpponent ? -1 : 1) * mod.currentValue;
            noteData.x -= ns * swStrum;
        }
    }