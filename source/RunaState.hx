// runa is window
// dave is (not) gay
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.mouse.FlxMouseEvent;
import flixel.input.mouse.FlxMouseEventManager;

class RunaState extends MusicBeatState{
	var path = "runa/story/";
	var bgpath = "runa/backgrou/";
	var charpath = "runa/charace t/";

	var fuckingBACKGROUND:FlxSprite;
	var vignettttttttttttttttttte:FlxSprite;
	var blackDOOOOOOOT:FlxSprite;
	var checkher:FlxSprite;

	var charactEEEEEEEEEErs:FlxSprite;

	var storymenu:FlxSprite;
	var freeplay:FlxSprite;
	var settings:FlxSprite;
	var achievements:FlxSprite;

	var spacing:Int = 200;
	var mouseSelect:Int = 0;
	var mouseBeforeSelect:Int = 0;

	var storyHover:FlxTween;
	var freeplayHover:FlxTween;
	var settingsHover:FlxTween;
	var achievementsHover:FlxTween;

	var howFar:Int = 150;
	var defaultX:Int = -175;
	var defaultY:Int = -125;

	var select:Bool = false;

	var fuckingOriginalCharacterX:Int = 425;
	var OHMYGODIMKILLINGMYSELF:Int = 25;

	override function create()
	{
		super.create();
		trace("Lodade!");
		FlxG.mouse.visible = true;

		// bavkgorund
		fuckingBACKGROUND = new FlxSprite().loadGraphic(Paths.image(bgpath + "bg"));
		vignettttttttttttttttttte = new FlxSprite().loadGraphic(Paths.image(bgpath + "vignette"));
		blackDOOOOOOOT = new FlxBackdrop().loadGraphic(Paths.image(bgpath + "blackDots"));
		checkher = new FlxBackdrop().loadGraphic(Paths.image(bgpath + "Checker"));

		blackDOOOOOOOT.velocity.set(40, 0);
		checkher.velocity.set(40, 40);

		checkher.color = FlxColor.BLACK;

		blackDOOOOOOOT.alpha = 0.5;

		add(fuckingBACKGROUND);
		add(blackDOOOOOOOT);
		add(checkher);

		// characket
		charactEEEEEEEEEErs = new FlxSprite().loadGraphic(Paths.image(charpath + "RunaStory"));
		add(charactEEEEEEEEEErs);

		charactEEEEEEEEEErs.scale.set(0.5, 0.5);
		charactEEEEEEEEEErs.y -= 100;
		charactEEEEEEEEEErs.x += 425;

		// button
		storymenu = new FlxSprite().loadGraphic(Paths.image(path + "storymenu"));
		freeplay = new FlxSprite().loadGraphic(Paths.image(path + "freeplay"));
		settings = new FlxSprite().loadGraphic(Paths.image(path + "settings"));
		achievements = new FlxSprite().loadGraphic(Paths.image(path + "achievements"));

		var arrowsnbutton:Array<FlxSprite> = [storymenu, freeplay, settings, achievements];

		for (item in arrowsnbutton)
		{
			item.scale.set(0.6, 0.6);
			item.updateHitbox();
			add(item);
		}
		add(vignettttttttttttttttttte);

		for (i in 0...3)
		{
			arrowsnbutton[i].x = defaultX;
		}

		arrowsnbutton[0].y += 85;
		arrowsnbutton[1].y += arrowsnbutton[0].y + spacing;
		arrowsnbutton[2].y += arrowsnbutton[1].y + spacing;

		arrowsnbutton[3].x += 900;
	}

	override function update(elapsed:Float)
	{
        super.update(elapsed);
		if (controls.BACK)
			FlxG.switchState(new TitleState());

		if (!select)
		{
			mouseHover(elapsed);
			if (FlxG.mouse.justReleased)
				mouseConfirm();
		}

		var thecharrrractersssssssGAYYY:Array<String> = ["RunaStory", "DuckFreeplay", "RunaOptions", "RunaAchievements"];

		if (mouseSelect > 0)
			charactEEEEEEEEEErs.loadGraphic(Paths.image(charpath + thecharrrractersssssssGAYYY[mouseSelect - 1]));
	}

	function mouseHover(elapsed:Float)
	{
		var mouseX = FlxG.mouse.x;
		var mouseY = FlxG.mouse.y;

		if (storyHover != null)
			storyHover.cancel();
		if (freeplayHover != null)
			freeplayHover.cancel();
		if (settingsHover != null)
			settingsHover.cancel();
		if (achievementsHover != null)
			achievementsHover.cancel();

		mouseSelect = 0;

		if (mouseX > storymenu.x
			&& mouseX < storymenu.x + storymenu.width
			&& mouseY > storymenu.y
			&& mouseY < storymenu.y + storymenu.height)
		{
			storyHover = FlxTween.tween(storymenu, {x: defaultX + howFar}, 10 * elapsed);

			mouseSelect = 1;
		}
		else
		{
			storyHover = FlxTween.tween(storymenu, {x: defaultX}, 10 * elapsed);
		}

		if (mouseX > freeplay.x
			&& mouseX < freeplay.x + freeplay.width
			&& mouseY > freeplay.y
			&& mouseY < freeplay.y + freeplay.height)
		{
			freeplayHover = FlxTween.tween(freeplay, {x: defaultX + howFar}, 10 * elapsed);

			mouseSelect = 2;
		}
		else
		{
			freeplayHover = FlxTween.tween(freeplay, {x: defaultX}, 10 * elapsed);
		}

		if (mouseX > settings.x
			&& mouseX < settings.x + settings.width
			&& mouseY > settings.y
			&& mouseY < settings.y + settings.height)
		{
			settingsHover = FlxTween.tween(settings, {x: defaultX + howFar}, 10 * elapsed);
			mouseSelect = 3;
		}
		else
		{
			settingsHover = FlxTween.tween(settings, {x: defaultX}, 10 * elapsed);
		}

		if (mouseX > achievements.x
			&& mouseX < achievements.x + achievements.width
			&& mouseY > achievements.y
			&& mouseY < achievements.y + achievements.height)
		{
			achievementsHover = FlxTween.tween(achievements, {y: defaultY + howFar - 40}, 10 * elapsed);
			mouseSelect = 4;
		}
		else
		{
			achievementsHover = FlxTween.tween(achievements, {y: defaultY}, 10 * elapsed);
		}
	}

	function mouseConfirm()
	{
		if (mouseSelect > 0)
		{
			select = true;

			trace(mouseSelect);
			FlxG.sound.play(Paths.sound("confirmMenu"));

			if (storyHover != null)
				storyHover.cancel();
			if (freeplayHover != null)
				freeplayHover.cancel();
			if (settingsHover != null)
				settingsHover.cancel();
			if (achievementsHover != null)
				achievementsHover.cancel();

			FuckassSmoothBitch(mouseSelect);
			// cameracool(mouseSelect);
		}
	}

	var epicEasing:Dynamic = FlxEase.expoOut;
	var epicEasing2:Dynamic = FlxEase.expoIn;

	var streech:Float = 0.9;
	var coolXfix:Int = 110;
	var coolYfix:Int = 60;

	var fuckingDURation:Int = 1;
	var fuckingDELAY:Int = 1;

	var howMuchGo:Int = 800;
	var howMuchGoConfirm:Int = 1200;

	// DONT FUCKING LOOK AT THIS CODE AND JUST EDIT THE ONE ON THE TOP
	// I MADE IT EASIER TO CUSTOMIZE DONT FUCKING CUSTOMIZE IT HERE BITCH 😭
	function FuckassSmoothBitch(which:Int):Void
	{
		if (which == 1)
		{
			FlxTween.tween(storymenu, {"scale.x": streech, x: storymenu.x + coolXfix}, fuckingDURation, {ease: epicEasing});
			FlxTween.tween(storymenu, {x: storymenu.x - howMuchGo}, fuckingDURation, {ease: epicEasing2, startDelay: fuckingDELAY, onComplete: function(tween:FlxTween){FlxG.switchState(new MainMenuStateAmmar());}});
			FlxTween.tween(freeplay, {x: freeplay.x - howMuchGoConfirm}, fuckingDURation, {ease: epicEasing2});
			FlxTween.tween(settings, {x: settings.x - howMuchGoConfirm}, fuckingDURation, {ease: epicEasing2});
			FlxTween.tween(achievements, {x: achievements.x - howMuchGoConfirm}, fuckingDURation, {ease: epicEasing2});
		}
		else if (which == 2)
		{
			FlxTween.tween(freeplay, {"scale.x": streech, x: freeplay.x + coolXfix}, fuckingDURation, {ease: epicEasing});
			FlxTween.tween(freeplay, {x: freeplay.x - howMuchGo}, fuckingDURation, {ease: epicEasing2, startDelay: fuckingDELAY});
			FlxTween.tween(storymenu, {x: storymenu.x - howMuchGoConfirm}, fuckingDURation, {ease: epicEasing2});
			FlxTween.tween(settings, {x: settings.x - howMuchGoConfirm}, fuckingDURation, {ease: epicEasing2});
			FlxTween.tween(achievements, {x: achievements.x - howMuchGoConfirm}, fuckingDURation, {ease: epicEasing2});
		}
		else if (which == 3)
		{
			FlxTween.tween(settings, {"scale.x": streech, x: settings.x + coolXfix}, fuckingDURation, {ease: epicEasing});
			FlxTween.tween(settings, {x: settings.x - howMuchGo}, fuckingDURation, {ease: epicEasing2, startDelay: fuckingDELAY});
			FlxTween.tween(storymenu, {x: storymenu.x - howMuchGoConfirm}, fuckingDURation, {ease: epicEasing2});
			FlxTween.tween(freeplay, {x: freeplay.x - howMuchGoConfirm}, fuckingDURation, {ease: epicEasing2});
			FlxTween.tween(achievements, {x: achievements.x - howMuchGoConfirm}, fuckingDURation, {ease: epicEasing2});
		}
		else if (which == 4)
		{
			//FlxTween.tween(achievements, {"scale.y": streech, y: achievements.y + coolYfix - 0.1}, fuckingDURation, {ease: epicEasing});
			//FlxTween.tween(achievements, {y: achievements.y - howMuchGo}, fuckingDURation, {ease: epicEasing2, startDelay: fuckingDELAY});
		}
	}
}