package;

import Conductor.BPMChangeEvent;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	public static var nextCamera:FlxCamera;
	var isTransIn:Bool = false;
	var transBlack:FlxSprite;
	var transGradient:FlxSprite;
	var loading:FlxSprite;
	var char:FlxSprite;

	public static var charName:String = "char1";
	public static var chars:Array<String> = ["char1", "char2", "char3", "char4"];
	var charTween:FlxTween;
	var loadingTween:FlxTween;
	public static var newLoading:Bool = false;

	public function new(duration:Float, isTransIn:Bool) {
		super();

		this.isTransIn = isTransIn;
		var zoom:Float = FlxMath.bound(FlxG.camera.zoom, 0.05, 1);
		var width:Int = Std.int(FlxG.width / zoom);
		var height:Int = Std.int(FlxG.height / zoom);
		transGradient = FlxGradient.createGradientFlxSprite(1, height, (isTransIn ? [0x0, FlxColor.BLACK] : [FlxColor.BLACK, 0x0]));
		transGradient.scale.x = width;
		transGradient.updateHitbox();
		transGradient.scrollFactor.set();
		add(transGradient);

		transBlack = new FlxSprite().makeGraphic(1, height + 400, FlxColor.BLACK);
		transBlack.scale.x = width;
		transBlack.updateHitbox();
		transBlack.scrollFactor.set();
		add(transBlack);

		// Paths.image("transition/loading", true);
		// for (char in chars)
		// 	Paths.image("transition/"+char, true);

		if (newLoading) {
			loading = new FlxSprite(0, 1280);
			loading.loadGraphic(Paths.image("transition/loading"));
			loading.antialiasing = ClientPrefs.globalAntialiasing;
			insert(this.members.indexOf(transBlack) + 2, loading);

			char = new FlxSprite(0, -1280);
			char.loadGraphic(Paths.image("transition/"+charName));
			char.antialiasing = ClientPrefs.globalAntialiasing;
			insert(this.members.indexOf(transBlack) + 2, char);
		}

		transGradient.x -= (width - FlxG.width) / 2;
		transBlack.x = transGradient.x;

		if(isTransIn) {
			transGradient.y = transBlack.y - transBlack.height;
			FlxTween.tween(transGradient, {y: transGradient.height + 50}, duration, {
				onComplete: function(twn:FlxTween) {
					close();
				},
			ease: FlxEase.linear});

			if (newLoading) {
				char.y = 0;
				loading.y = 0;
				charTween = FlxTween.tween(char, {y: 1280}, duration, {ease: FlxEase.quadIn, startDelay : 0.05});
				loadingTween = FlxTween.tween(loading, {y: -1280}, duration, {ease: FlxEase.quadIn, startDelay : 0.05});
			}
			charName = chars[FlxG.random.int(0, chars.length-1)];
		} else {
			transGradient.y = -transGradient.height;
			transBlack.y = transGradient.y - transBlack.height + 50;
			leTween = FlxTween.tween(transGradient, {y: transGradient.height + 50}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.linear});

			if (newLoading) {
				charTween = FlxTween.tween(char, {y: 0}, duration, {ease: FlxEase.quadOut});
				loadingTween = FlxTween.tween(loading, {y: 0}, duration, {ease: FlxEase.quadOut});
			}
		}

		if(nextCamera != null) {
			transBlack.cameras = [nextCamera];
			transGradient.cameras = [nextCamera];
			if (newLoading) {
				char.cameras = [nextCamera];
				loading.cameras = [nextCamera];
			}
		}
		nextCamera = null;
	}

	override function update(elapsed:Float) {
		if(isTransIn) {
			transBlack.y = transGradient.y + transGradient.height;
		} else {
			transBlack.y = transGradient.y - transBlack.height;
		}
		super.update(elapsed);
		if(isTransIn) {
			transBlack.y = transGradient.y + transGradient.height;
		} else {
			transBlack.y = transGradient.y - transBlack.height;
		}
	}

	override function destroy() {
		if(leTween != null) {
			finishCallback();
			leTween.cancel();
		}
		if(charTween != null) 
			charTween.cancel();
		if(loadingTween != null) 
			loadingTween.cancel();

		super.destroy();
	}
}