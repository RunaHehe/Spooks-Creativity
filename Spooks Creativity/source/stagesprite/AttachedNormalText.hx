package stagesprite;

import flixel.FlxSprite;
import flixel.text.FlxText;

class AttachedNormalText extends FlxText
{
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var sprTracker:FlxSprite;
	public var copyVisible:Bool = true;
	public var copyAlpha:Bool = false;
	public function new(text:String = "", fieldWidth:Float = 0, ?size:Int = 8) {
		super(0, 0, fieldWidth, text, size);
		//antialiasing = ClientPrefs.globalAntialiasing; // make look worse 
        borderQuality = 0; // just in case there is lag
        alignment = LEFT;
	}

	override function update(elapsed:Float) {
		if (sprTracker != null) {
			setPosition(sprTracker.x + offsetX, sprTracker.y + offsetY);
			if(copyVisible) 
				visible = sprTracker.visible;
			if(copyAlpha) 
				alpha = sprTracker.alpha;
		}

		super.update(elapsed);
	}
}