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
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;

class RunaState extends MusicBeatState
{
	var path = "runa/story/";
	var bgpath = "runa/backgrou/";
	var charpath = "runa/charace t/";

	var fuckingBACKGROUND:FlxSprite;
	var vignettttttttttttttttttte:FlxSprite;
	var blackDOOOOOOOT:FlxSprite;
	var checkher:FlxSprite;

	var charactEEEEEEEEEErs:FlxSprite;

	var options:Array<String> = ["storymenu", "freeplay", "settings", "achievements"];

	var items:FlxTypedGroup<FlxSprite>;

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
	var defaultScale:Float = 0.6;

	var select:Bool = false;

	var fuckingOriginalCharacterX:Int = 425;
	var OHMYGODIMKILLINGMYSELF:Int = 25;

	override function create()
	{
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

		items = new FlxTypedGroup<FlxSprite>();
		add(items);

		// button
		for (i in 0...options.length)
		{
			var shit = options[i];
			var menuItem:FlxSprite = new FlxSprite().loadGraphic(Paths.image(path + shit));
			menuItem.ID = i;
			menuItem.scale.set(defaultScale, defaultScale);
			menuItem.updateHitbox();
			menuItem.x = defaultX;
			menuItem.y += (i * spacing) + 85;
			if (shit == "achievements")
			{
				menuItem.x = FlxG.width/2+200;
				menuItem.y = defaultY;
			}
			items.add(menuItem);
		}

		add(vignettttttttttttttttttte);

		super.create();
	}

	// var lerp:Float = 0.1;

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (controls.BACK)
			FlxG.switchState(new TitleState());

		if (!select)
		{
			for (i in items)
			{
				if (i.ID != 3)
				{
					var x:Float = i.x;
					if (FlxG.mouse.overlaps(i))
						i.x = i.x + (2 - i.x) / 4;
					else
						i.x = i.x + (defaultX - i.x) / 4;
				}
				else
				{
					if (FlxG.mouse.overlaps(i))
						i.y = i.y + (2 - i.y) / 4;
					else
						i.y = i.y + (defaultY - i.y) / 4;
				}

				if (FlxG.mouse.overlaps(i))
				{
					mouseSelect = 0;
					mouseSelect = i.ID + 1;

					if (FlxG.mouse.justPressed)
					{
						items.forEach(function(spr:FlxSprite)
						{
							if (spr.ID != 3)
							{
								FlxTween.tween(spr, {x: -600}, 0.6, {
									ease: FlxEase.backIn,
									onComplete: function(twn:FlxTween)
									{
										spr.kill();
										switchState(i.ID);
									}
								});
							}else{
								FlxTween.tween(spr, {y: (2*defaultY)}, 0.6, {
									ease: FlxEase.backIn,
									onComplete: function(twn:FlxTween)
									{
										spr.kill();
									}
								});
							}
						});
					}
				}
			}
		}

		var thecharrrractersssssssGAYYY:Array<String> = ["RunaStory", "DuckFreeplay", "RunaOptions", "RunaAchievements"];

		if (mouseSelect > 0)
		{
			charactEEEEEEEEEErs.loadGraphic(Paths.image(charpath + thecharrrractersssssssGAYYY[mouseSelect - 1]));
			// charactEEEEEEEEEErs.y = 10*Math.sin(charactEEEEEEEEEErs.y); //buggy as hell
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

	function switchState(state)
	{
		var curSelected = options[state];
		switch (curSelected)
		{
			case "storymenu":
				MusicBeatState.switchState(new MainMenuStateAmmar());
			case "freeplay":
				MusicBeatState.switchState(new RunaState());
			case "settings":
				MusicBeatState.switchState(new options.OptionsState());
			case "achievements":
				MusicBeatState.switchState(new AchievementsMenuState());
		}
	}
}
