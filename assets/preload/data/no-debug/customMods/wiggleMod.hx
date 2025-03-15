//
function initMod(mod)
    {
        mod.subValues.set('speed', new ModifierSubValue(1.0));
        mod.subValues.set('freq', new ModifierSubValue(1.0));
    
        mod.noteMath = function (noteData:NotePositionData, lane:Int, curPos:Float, pf:Int)
        {
            var speed = mod.subValues.get("speed").value;
            var freq = mod.subValues.get("freq").value;
            noteData.x += mod.currentValue * 40 * FlxMath.fastSin(curPos * freq * -(0.01 * speed));
        }
    }
    