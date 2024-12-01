package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warnText = new FlxText(0, 0, FlxG.width,
			"
			NOTICE\n
			This Mod contains some flashing lights!\n
			You can disable it on the options menu.\n
			And also, don't try cheat!\n
			You have to enable developer mode first!\n
			Anyways,\n
			Thank you for playing!",
			32);
		warnText.setFormat(Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf"), 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter();
		warnText.x += 10;
		add(warnText);
		#if MOBILE
		FlxG.mouse.visible = false;
		#end
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			#if MOBILE
			for (movement in FlxG.touches.list) {
				if (movement.justPressed) {
					back = true;
				}
			}
			#end
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxG.save.data.flashing = true;
				FlxG.save.flush();
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
					onComplete: function (twn:FlxTween) {
						MusicBeatState.switchState(new TitleState());
					}
				});
			}
		}
		super.update(elapsed);
	}
}
