package;

import flixel.FlxG;
import flixel.FlxSprite;
import sys.io.Process;
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import flixel.util.FlxTimer;

class RunaPiracy extends FlxState
{
    private var timer:FlxTimer;

    override public function create():Void
    {
        super.create();

        var image = new FlxSprite().loadGraphic(Paths.image("runa/piracy/run"));
        add(image);

        FlxG.sound.playMusic(Paths.music('youthief'), 1, true);

        FlxG.sound.music.volume = 1;

        timer = new FlxTimer();
        timer.start(5, onTimerComplete);
    }

    private function onTimerComplete(t:FlxTimer):Void
    {
        showMessage();
    }

    private function showMessage():Void
    {
        #if desktop
            Application.current.window.alert("YOU THIEF.");

            Sys.exit(1);
        #end
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        // make sure sound keep playing when no focus on game >:3
        if (FlxG.sound.music.playing)
        {
            FlxG.sound.playMusic(Paths.music('youthief'), 1, true);
        }
    }
}
