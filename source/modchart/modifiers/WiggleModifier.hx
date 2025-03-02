package modchart.modifiers;
import flixel.FlxSprite;
import ui.*;
import modchart.*;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.FlxG;
import math.*;

class WiggleModifier extends NoteModifier {
    override function getName()return 'wiggle';
    
	override function getPos(time:Float, visualDiff:Float, timeDiff:Float, beat:Float, pos:Vector3, data:Int, player:Int, obj:FlxSprite)
	{
        var wiggle = getValue(player);
        var time = (Conductor.songPosition/1000);

        var xAdjust:Float = 0;
        var reverse:Dynamic = modMgr.register.get("reverse");
		var reversePercent = reverse.getReverseValue(data,player);
        var mult = CoolUtil.scale(reversePercent,0,1,1,-1);

        if (wiggle != 0) 
            xAdjust += wiggle * 20 * FlxMath.fastSin(visualDiff/45*getSubmodValue("wiggleFreq", player));
        

        pos.x += xAdjust * mult;
        return pos;
    }

    override function getSubmods(){
        return [
            'wiggleFreq'
        ];
    }

}
