package;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.Lib;

class WindowModchart
{
	public static var traceAllow = true;

	public static var fullscreen:Bool = false;
	public static var OGx:Int = 0;
	public static var OGy:Int = 0;
	public static var OGwidth:Int = 0;
	public static var OGheight:Int = 0;

	public static var moveWindowX:FlxTween;
	public static var moveWindowY:FlxTween;
	public static var moveWindowWidth:FlxTween;
	public static var moveWindowHeight:FlxTween;

    public static function init():Void
    {
		OGx = Lib.application.window.x;
		OGy = Lib.application.window.y;
		OGwidth = Lib.application.window.width;
		OGheight = Lib.application.window.height;
		fullscreen = Lib.application.window.fullscreen;
        trace("---Initialized---");
		trace(" ");
		trace("--- WINDOW MODCHART ---");
		trace("Window X: " + OGx);
		trace("Window Y: " + OGy);
		trace("Window Width: " + OGwidth);
		trace("Window Height: " + OGheight);
		trace("Window Fullscreen: " + fullscreen);
		trace("-----------------------");
		trace(" ");
    }

	function create() // unused
	{
		OGx = Lib.application.window.x;
		OGy = Lib.application.window.y;
		OGwidth = Lib.application.window.width;
		OGheight = Lib.application.window.height;
		fullscreen = Lib.application.window.fullscreen;

		if (traceAllow)
		{
			trace(" ");
			trace("--- WINDOW MODCHART ---");
			trace("Window X: " + OGx);
			trace("Window Y: " + OGy);
			trace("Window Width: " + OGwidth);
			trace("Window Height: " + OGheight);
			trace("Window Fullscreen: " + fullscreen);
			trace("-----------------------");
			trace(" ");
		}
	}

	public static function moveWindow(whichone:String, value:Int, duration:Int, easeType:String)
	{
		OGx = Lib.application.window.x;
		OGy = Lib.application.window.y;
		OGwidth = Lib.application.window.width;
		OGheight = Lib.application.window.height;
		fullscreen = Lib.application.window.fullscreen;

        var easeFunc = easeFromString(easeType);
        switch(whichone)
        {
            case "x": FlxTween.tween(Lib.application.window, {x:value}, duration, {ease:easeFunc});
            case "y": FlxTween.tween(Lib.application.window, {y:value}, duration, {ease:easeFunc});
            case "width": FlxTween.tween(Lib.application.window, {width:value}, duration, {ease:easeFunc});
            case "height": FlxTween.tween(Lib.application.window, {height:value}, duration, {ease:easeFunc});
        }

	}

	public static function setWindow(whichone:String, value:Int)
	{
		OGx = Lib.application.window.x;
		OGy = Lib.application.window.y;
		OGwidth = Lib.application.window.width;
		OGheight = Lib.application.window.height;
		fullscreen = Lib.application.window.fullscreen;

		if (whichone == "x")
		{
			Lib.application.window.x = value;
		}
		else if (whichone == "y")
		{
			Lib.application.window.y = value;
		}
		else if (whichone == "width")
		{
			Lib.application.window.width = value;
		}
		else if (whichone == "height")
		{
			Lib.application.window.height = value;
		}
	}

	public static function resetWindow(whichone:String)
	{
		OGx = Lib.application.window.x;
		OGy = Lib.application.window.y;
		OGwidth = Lib.application.window.width;
		OGheight = Lib.application.window.height;
		fullscreen = Lib.application.window.fullscreen;

		if (whichone == "x")
		{
			Lib.application.window.x = OGx;
		}
		else if (whichone == "y")
		{
			Lib.application.window.y = OGy;
		}
		else if (whichone == "width")
		{
			Lib.application.window.width = OGwidth;
		}
		else if (whichone == "height")
		{
			Lib.application.window.height = OGheight;
		}
	}

    public static function easeFromString(name:String):EaseFunction
    {
        switch(name.toLowerCase())
        {
            case "linear": return FlxEase.linear;
            case "sineIn": return FlxEase.sineIn;
            case "sineOut": return FlxEase.sineOut;
            case "sineInOut": return FlxEase.sineInOut;
            case "quadIn": return FlxEase.quadIn;
            case "quadOut": return FlxEase.quadOut;
            case "quadInOut": return FlxEase.quadInOut;
            case "expoIn": return FlxEase.expoIn;
			case "expoOut": return FlxEase.expoOut;
			case "expoInOut": return FlxEase.expoInOut;
            default:
                trace("unknown easeing type: " + name + " -- defaulting back to linear");
                return FlxEase.linear;
        }
    }

	function destroy()
	{
		Lib.application.window.x = OGx;
		Lib.application.window.y = OGy;
		Lib.application.window.width = OGwidth;
		Lib.application.window.height = OGheight;
	}
}