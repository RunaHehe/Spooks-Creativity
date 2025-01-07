package stagesprite;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import AttachedSprite;

using StringTools;

class DiscordChannels extends FlxSprite
{
    public var defaultX:Float = 0;
    var distanceScroll:Float = 0;
    public function new(x:Float, y:Float)
    {
        super(x,y);

        //Da BG!!
        loadGraphic(Paths.image("ChannelsList"));
        setGraphicSize(Std.int(width*0.85));
        updateHitbox();
        antialiasing = ClientPrefs.globalAntialiasing;
        scrollFactor.set(0, 0);

        distanceScroll = height - 720; 
    }

    public var beatTween:FlxTween;
    public var scrollTween:FlxTween;
    public var beatPhase(default, set):Int = 1; // 1 = Beat, 2 = Moving Up and Down FAST
    public var intensity:Float = 16;
    public function stepHit(step:Int):Void {
        if (step % 8 == 6) {
            if (beatTween != null)
                beatTween.cancel();
            beatTween = FlxTween.tween(this, {x: defaultX - intensity}, Conductor.crochet/1000/2, {ease: FlxEase.circIn, onComplete: function(tw:FlxTween){beatTween = null;}});
        }
        if (step % 8 == 0) {
            if (beatTween != null)
                beatTween.cancel();
            beatTween = FlxTween.tween(this, {x: defaultX}, Conductor.crochet/1000, {ease: FlxEase.quadOut, onComplete: function(tw:FlxTween){beatTween = null;}});
        }

        //Scroll
        if (step % 64 == 0) {
            if (scrollTween != null)
                scrollTween.cancel();
            var targetY:Float = step%128 == 0 ? 50 : 50 - distanceScroll;
            scrollTween = FlxTween.tween(this, {y: targetY}, Conductor.crochet/1000*12, {ease: FlxEase.sineInOut, onComplete: function(tw:FlxTween){scrollTween = null;}});
        }
    }

    private function set_beatPhase(value:Int):Int {
        if (value != beatPhase && value == 2)
            if (scrollTween != null)
                scrollTween.cancel();

        beatPhase = value;
		return value;
    }
}