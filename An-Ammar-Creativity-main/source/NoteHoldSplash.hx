package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class NoteHoldSplash extends FlxSprite
{
	public var colorSwap:ColorSwap = null;
	private var idleAnim:String;
	private var textureLoaded:String = null;
	public var colors:Array<String> = ['Purple' ,'Blue', 'Green', 'Red'];
	public static var scrollX:Float = 1;
	public static var scrollY:Float = 1;

	public function new(x:Float = 0, y:Float = 0, ?note:Int = 0) {
		super(x, y);

		var skin:String = 'holdCover';
		loadAnims(skin);
		
		colorSwap = new ColorSwap();
		shader = colorSwap.shader;

		setup(x, y, note);
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function setup(x:Float, y:Float, note:Int = 0, texture:String = null, hueColor:Float = 0, satColor:Float = 0, brtColor:Float = 0) {
		setPos(x, y);
		scrollFactor.set(scrollX, scrollY);
		alpha = 1;

		texture = 'holdCover'; //FORCE :3
		
		if(textureLoaded != texture) {
			loadAnims(texture, note);
		}
		colorSwap.hue = hueColor;
		colorSwap.saturation = satColor;
		colorSwap.brightness = brtColor;
		offset.set(10, 10);

		animation.play('start', true);
		if(animation.curAnim != null)animation.curAnim.frameRate = 24;
	}

	public function setPos(x:Float, y:Float):Void {
		setPosition(x - Note.swagWidth * 0.9, y - Note.swagWidth * 0.8);
	}

	public function endHold(success:Bool = false) {
		//trace('hold end ' + (success ? 'true' : 'false'));
		if (success) animation.play('end', true);
		else kill();

	}

	function loadAnims(skin:String, noteData:Int = 0) {
		final colorName:String = colors[noteData%4];
		frames = Paths.getSparrowAtlas(skin + colorName);
		animation.addByPrefix("start", 'holdCoverStart$colorName', 24, false);
		animation.addByPrefix("in", 'holdCover$colorName', 24, true);
		animation.addByPrefix("end", 'holdCoverEnd$colorName', 24, false);
		animation.finishCallback = function(name:String){
			if (animation.curAnim.name == 'start') animation.play('in', true);
			else if (animation.curAnim.name == 'end') kill();
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}
}