package mobile;

import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEvent;

using StringTools;

//ADD MULTITOUCH

class HitboxControl extends FlxSpriteGroup
{
    private var facer:Array<String> = ['left', 'down', 'up', 'right'];
	private var hitboxPath:String = 'mobile/hitbox';

    public var noteData:Int = 0;
    public var hitbox:FlxSprite;
    public var hint:FlxSprite;

    public var onPress:Bool = false;
    public var onJustPress:Bool = false;
    public var onJustRelease:Bool = false;
    public var framePasses:Float = 0;

    private var maxX:Float = 0;
    private var minX:Float = 0;
    
    public function new(order:Int) {
        hitbox = new FlxSprite(0, 0);
        hitbox.frames = Paths.getSparrowAtlas(hitboxPath);
        hitbox.animation.addByPrefix('idle', facer[order], 0, false);
        hitbox.animation.play('idle', true);
        hitbox.alpha = 0.01;
        
        hint = new FlxSprite(0, 0).loadGraphic(Paths.image('mobile/hitbox_hint'), true, Std.int(1280/4), 720);
        hint.animation.add('idle', [order], 0, false);
        hint.animation.play('idle', true);
        hint.alpha = 0.4;

        super((1280/4) * (order), 0);
        maxX = (1280/4) * (order+1);
        minX = (1280/4) * (order);

        add(hitbox);
        add(hint);

        noteData = order;

        //FlxMouseEvent.add(hitbox, press, release, null, null, true, true);
    }

    override function update(elapsed:Float) {
        if (!onPress && FlxG.mouse.pressed) {
            if (checkInTouch()) {
                onPress = true;
                onJustPress = true;
                onJustRelease = false;
                framePasses = 0;
            }
        } else if (onPress && (FlxG.mouse.released || !checkInTouch())) {
            onPress = false;
            onJustRelease = true;
            onJustPress = false;
            framePasses = 0;
        }

        hitbox.alpha = onPress ? 0.75 : 0;
        if (onJustPress) {
            framePasses += 1;
            if (framePasses >= 5)
                onJustPress = false;
        }
        if (onJustRelease) {
            framePasses += 1;
            if (framePasses >= 5)
                onJustRelease = false;
        }
    }

    private function checkInTouch():Bool {
        for (touch in FlxG.touches.list)
        {
            var mousePos:FlxPoint = touch.getScreenPosition(FlxG.cameras.list[FlxG.cameras.list.length-1]);
            return (mousePos.x >= minX && mousePos.x <= maxX);
        }
        return false;
        //var mousePos:FlxPoint = FlxG.mouse.getScreenPosition(FlxG.cameras.list[FlxG.cameras.list.length-1]);
        //return (mousePos.x >= minX && mousePos.x <= maxX);
    }

}