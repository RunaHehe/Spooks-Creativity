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

	var discordAnnooyerWeek:FlxSprite;
	var hatingWeek:FlxSprite;
	var noDebugWeek:FlxSprite;

	var DAWtween:FlxTween;
	var HWtween:FlxTween;
	var NDWtween:FlxTween;

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

		discordAnnooyerWeek = new FlxSprite().loadGraphic(Paths.image(buttonpath + "Discord Annoyer Week"));
		hatingWeek = new FlxSprite().loadGraphic(Paths.image(buttonpath + "Hating Week"));
		noDebugWeek = new FlxSprite().loadGraphic(Paths.image(buttonpath + "No Debug Week"));
		var buttons:Array<FlxSprite> = [discordAnnooyerWeek, hatingWeek, noDebugWeek];

		for (drugs in buttons)
		{
			drugs.antialiasing = true;
			drugs.screenCenter();
			drugs.scale.set(defaultZoom, defaultZoom);
			drugs.updateHitbox();
			add(drugs);
		}

		for (meow in 0...3)
		{
			buttons[meow].y -= 100;
		}

		buttons[0].x -= 250;
		buttons[2].x += 250;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.BACK)
			FlxG.switchState(new TitleState());

		if (!selectedSomething)
		{
			mouseHover(elapsed);
			if (FlxG.mouse.justReleased)
				mouseConfirm();
		}
	}

	function mouseHover(elapsed:Float)
	{
		var mouseX = FlxG.mouse.x;
		var mouseY = FlxG.mouse.y;

		// pov: lazy asf
		var DAW:FlxSprite = discordAnnooyerWeek;
		var HW:FlxSprite = hatingWeek;
		var NDW:FlxSprite = noDebugWeek;

		if (DAWtween != null)
			DAWtween.cancel();
		if (HWtween != null)
			HWtween.cancel();
		if (NDWtween != null)
			NDWtween.cancel();

		if (curSelect > 0)
			curSelect = 0;

		if (mouseX > DAW.x && mouseX < DAW.x + DAW.width && mouseY > DAW.y && mouseY < DAW.y + DAW.height)
		{
			DAWtween = FlxTween.tween(DAW, {"scale.x": howMuchZoom, "scale.y": howMuchZoom}, 10 * elapsed);
			curSelect = 1;
		}
		else
		{
			DAWtween = FlxTween.tween(DAW, {"scale.x": defaultZoom, "scale.y": defaultZoom}, 10 * elapsed);
		}

		if (mouseX > HW.x && mouseX < HW.x + HW.width && mouseY > HW.y && mouseY < HW.y + HW.height)
		{
			HWtween = FlxTween.tween(HW, {"scale.x": howMuchZoom, "scale.y": howMuchZoom}, 10 * elapsed);
			curSelect = 2;
		}
		else
		{
			HWtween = FlxTween.tween(HW, {"scale.x": defaultZoom, "scale.y": defaultZoom}, 10 * elapsed);
		}

		if (mouseX > NDW.x && mouseX < NDW.x + NDW.width && mouseY > NDW.y && mouseY < NDW.y + NDW.height)
		{
			NDWtween = FlxTween.tween(NDW, {"scale.x": howMuchZoom, "scale.y": howMuchZoom}, 10 * elapsed);
			curSelect = 3;
		}
		else
		{
			NDWtween = FlxTween.tween(NDW, {"scale.x": defaultZoom, "scale.y": defaultZoom}, 10 * elapsed);
		}
	}

	function mouseConfirm()
	{
		if (curSelect > 0)
		{
			selectedSomething = true;
			trace(curSelect);
		}
		else if (curSelect < 1)
		{
			trace("faggot bro,,, hover over something man,,,");
		}
	}
}
