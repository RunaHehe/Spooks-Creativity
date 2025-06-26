package funkin.backend.system;

import haxe.Log;
import haxe.PosInfos;
import lime.app.Application;
using funkin.backend.system.Logs.LogTools;
using StringTools;

class LogTools
{
    public static inline function levelToString(level:Level):String
    {
        switch (level)
        {
            case INFO:
                return AnsiColors.LightPurple + '[  INFO    ]';
            case WARNING:
                return AnsiColors.LightYellow + '[  WARNING ]';
            case ERROR:
                return AnsiColors.Error + '[  ERROR   ]';
            default:
                return '[  MISC    ]';
        }
    }
}

class Logs
{
	public static var nativeTrace = Log.trace;

    public static function init()
    {
        Log.trace = traceOverride;
    }

    static function levelToInt(l:Level):Int
    {
        switch(l)
        {
            case INFO:
                return 0;
            case MISC:
                return 1;
            case NONE:
                return 2;
            case WARNING:
                return 3;
            case ERROR:
                return 4;
        }
    }

    static function traceOverride(v:Dynamic, ?infos:PosInfos):Void traceNew(v, NONE, infos);

    public static function traceNew(v:Dynamic, level:Level = NONE, ?infos:PosInfos):Void
    {
        var str = '${level.levelToString()} : ' + Log.formatOutput(v, infos).replace('\n\n', '\n').replace('\n', '\n${level.levelToString()} : ${infos.fileName}:${infos.lineNumber}: ') + AnsiColors.Reset;
        #if js
        if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
            (untyped console).log(str);
        #elseif lua
        untyped __define_feature__("use._hx_print", _hx_print(str));
        #elseif sys
        Sys.println(str);
        #else
        throw new haxe.exceptions.NotImplementedException()
        #end
    }
}

enum abstract Level(Int)
{
    var INFO = 0;
    var MISC = 1;
    var NONE = 2;
	var WARNING = 3;
	var ERROR = 4;
}

// Thank you @notbilly in the Haxe Discord for the color codes!
enum abstract AnsiColors(String) to String {
	// Reset
	var Reset = "\u001b[0m";

	// Basic 16 colors (bright versions)
	var Black = "\u001b[30m";
	var Red = "\u001b[31m";
	var Green = "\u001b[32m";
	var Yellow = "\u001b[33m";
	var Blue = "\u001b[34m";
	var Magenta = "\u001b[35m";
	var Cyan = "\u001b[36m";
	var White = "\u001b[37m";

	// Bright versions
	var BrightBlack = "\u001b[90m";
	var BrightRed = "\u001b[91m";
	var BrightGreen = "\u001b[92m";
	var BrightYellow = "\u001b[93m";
	var BrightBlue = "\u001b[94m";
	var BrightMagenta = "\u001b[95m";
	var BrightCyan = "\u001b[96m";
	var BrightWhite = "\u001b[97m";

	// 256-color palette - Popular colors
	var Orange = "\u001b[38;5;208m";
	var Pink = "\u001b[38;5;205m";
	var Purple = "\u001b[38;5;135m";
	var Lime = "\u001b[38;5;154m";
	var Gold = "\u001b[38;5;220m";
	var Silver = "\u001b[38;5;249m";
	var Brown = "\u001b[38;5;130m";
	var Maroon = "\u001b[38;5;88m";
	var Navy = "\u001b[38;5;17m";
	var Olive = "\u001b[38;5;58m";
	var Teal = "\u001b[38;5;30m";
	var Aqua = "\u001b[38;5;51m";
	var Coral = "\u001b[38;5;203m";
	var Salmon = "\u001b[38;5;209m";
	var Khaki = "\u001b[38;5;185m";
	var Violet = "\u001b[38;5;177m";
	var Indigo = "\u001b[38;5;54m";
	var Turquoise = "\u001b[38;5;80m";

	// Grays/Greys
	var Gray1 = "\u001b[38;5;232m";
	var Gray2 = "\u001b[38;5;234m";
	var Gray3 = "\u001b[38;5;236m";
	var Gray4 = "\u001b[38;5;238m";
	var Gray5 = "\u001b[38;5;240m";
	var Gray6 = "\u001b[38;5;242m";
	var Gray7 = "\u001b[38;5;244m";
	var Gray8 = "\u001b[38;5;246m";
	var Gray9 = "\u001b[38;5;248m";
	var Gray10 = "\u001b[38;5;250m";

	// Vibrant colors
	var ElectricBlue = "\u001b[38;5;33m";
	var NeonGreen = "\u001b[38;5;46m";
	var HotPink = "\u001b[38;5;198m";
	var BrightOrange = "\u001b[38;5;202m";
	var ElectricPurple = "\u001b[38;5;129m";
	var LimeGreen = "\u001b[38;5;118m";
	var DeepPink = "\u001b[38;5;199m";
	var SkyBlue = "\u001b[38;5;117m";
	var SpringGreen = "\u001b[38;5;48m";
	var Crimson = "\u001b[38;5;196m";

	// Pastel-ish colors
	var LightPink = "\u001b[38;5;217m";
	var LightBlue = "\u001b[38;5;152m";
	var LightGreen = "\u001b[38;5;157m";
	var LightYellow = "\u001b[38;5;230m";
	var LightPurple = "\u001b[38;5;183m";
	var LightCyan = "\u001b[38;5;159m";

	// Dark variants
	var DarkRed = "\u001b[38;5;124m";
	var DarkGreen = "\u001b[38;5;22m";
	var DarkBlue = "\u001b[38;5;18m";
	var DarkYellow = "\u001b[38;5;136m";
	var DarkMagenta = "\u001b[38;5;90m";
	var DarkCyan = "\u001b[38;5;23m";
	var DarkOrange = "\u001b[38;5;166m";

	// Earth tones
	var Beige = "\u001b[38;5;223m";
	var Tan = "\u001b[38;5;180m";
	var RustRed = "\u001b[38;5;160m";
	var ForestGreen = "\u001b[38;5;28m";
	var SandBrown = "\u001b[38;5;137m";
	var MossGreen = "\u001b[38;5;65m";

	// Common use case colors
	var Success = "\u001b[38;5;46m"; // Bright green
	var Warning = "\u001b[38;5;226m"; // Bright yellow
	var Error = "\u001b[38;5;196m"; // Bright red
	var Info = "\u001b[38;5;39m"; // Bright blue
	var Debug = "\u001b[38;5;245m"; // Gray

	// Special formatting (not colors but useful)
	var Bold = "\u001b[1m";
	var Dim = "\u001b[2m";
	var Italic = "\u001b[3m";
	var Underline = "\u001b[4m";
	var Blink = "\u001b[5m";
	var Reverse = "\u001b[7m";
	var Strikethrough = "\u001b[9m";
}