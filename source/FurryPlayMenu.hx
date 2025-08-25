import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEvent;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;

class FurryPlayMenu extends MusicBeatState
{
	var bgpath = "runa/backgrou/";
	var buttonpath = "runa/furryplay/";

	// i love my variable names 💙 - daveberry (the person who mainly created the menus lmao)
	// thank yo u for coding half of this i hate haxe :pray:
	// loeded meowowowoowowowowowowowowowowoowowoowowoow :333333333
	var bgggggggggggggggggggggggggggggggggggggggggggggggggggggg:FlxSprite;
	var vinsomethingkillmyselfteehee:FlxSprite;

	var buttons:Array<String> = ["Discord Annoyer Week", "Hating Week", "No Debug Week"];
	var buttonGrp:FlxTypedGroup<FlxSprite>;

	var curSelect:Int = 0;
	var selectedSomething:Bool = false;

	var howMuchZoom:Float = 1.2;
	var defaultZoom:Int = 1;

	override function create()
	{
		trace("loeded meowowowoowowowowowowowowowowoowowoowowoow :333333333");
		FlxG.mouse.visible = true;

		bgggggggggggggggggggggggggggggggggggggggggggggggggggggg = new FlxSprite().loadGraphic(Paths.image(bgpath + "bg"));
		add(bgggggggggggggggggggggggggggggggggggggggggggggggggggggg);

		vinsomethingkillmyselfteehee = new FlxSprite().loadGraphic(Paths.image(bgpath + "vignette"));
		add(vinsomethingkillmyselfteehee);

		buttonGrp = new FlxTypedGroup<FlxSprite>();
		add(buttonGrp);

		// discordAnnooyerWeek = new FlxSprite().loadGraphic(Paths.image(buttonpath + "Discord Annoyer Week"));
		// hatingWeek = new FlxSprite().loadGraphic(Paths.image(buttonpath + "Hating Week"));
		// noDebugWeek = new FlxSprite().loadGraphic(Paths.image(buttonpath + "No Debug Week"));

		for (drugs in 0...buttons.length)
		{
			var shit = buttons[drugs];
			var button:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image(buttonpath + shit));
			button.antialiasing = true;
			button.screenCenter();
			button.scale.set(defaultZoom, defaultZoom);
			button.updateHitbox();
			button.ID = drugs;
			buttonGrp.add(button);

			button.y -= 100;
			if (shit == "Discord Annoyer Week")
				button.x -= 250;
			if (shit == "No Debug Week")
				button.x += 250;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.BACK)
			FlxG.switchState(new TitleState());

		if (!selectedSomething)
			mouseHover();
	}

	function mouseHover(){
		for (i in buttonGrp){
			if (FlxG.mouse.overlaps(i)){
				i.scale.x = i.scale.x + (howMuchZoom - i.scale.x)/4;
				i.scale.y = i.scale.y + (howMuchZoom - i.scale.y)/4;
				if (FlxG.mouse.justPressed)
					mouseConfirm(i.ID);
			}else{
				i.scale.x = i.scale.x + (defaultZoom - i.scale.x)/4;
				i.scale.y = i.scale.y + (defaultZoom - i.scale.y)/4;
			}
		}
	}

	function mouseConfirm(week:Int){
		selectedSomething = true;
		var curWeek:String = buttons[week];
		trace(curWeek);
		FlxG.sound.play(Paths.sound("confirmMenu"));

		buttonGrp.forEach(function(spr:FlxSprite){
			if (spr.ID == week){
				FlxTween.tween(spr, {x: FlxG.width/2-100, "scale.x": 1, "scale.y": 1}, 0.6, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween){
					FlxTween.tween(spr, {angle: 360}, 1, {ease: FlxEase.backOut});
					FlxTween.tween(spr, {"scale.x": 3, "scale.y": 3}, 0.6, {ease: FlxEase.elasticOut});
				}});
			}else{
				FlxTween.tween(spr, {y: -spr.height*2, "scale.x": 0.5, "scale.y":0.5}, 0.6, {ease:FlxEase.quadOut});
			}
		});
	}
}
