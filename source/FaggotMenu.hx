// lock tf in bros
// hi runa, me go rn cause i has do something :wavey:
// ok

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;

class FaggotMenu extends MusicBeatState
{
	var fuckasseryBG:FlxSprite;
	var grid:FlxBackdrop;

	var storymenu:FlxSprite;
	var freeplay:FlxSprite;
	var settings:FlxSprite;
	var achievements:FlxSprite;

	var runa:FlxSprite;
	var runaCharacter:Array<String> = [
		"StoryModeSpook",
		"FreePlaySpook",
		"SettingsSpook",
	];

	var itemsOriginalPos:Int = -165 - 50;

	override function create()
	{
		#if desktop
            DiscordClient.changePresence("In Runa's Cute Menu >:3", null);
        #end

		fuckasseryBG = new FlxSprite().loadGraphic(Paths.image("runa/bg/gradient"));
		add(fuckasseryBG);

		grid = new FlxBackdrop(FlxGridOverlay.createGrid(40, 40, 80, 80, true, 0x775419FF, 0x335419FF));
		grid.velocity.x = 24;
		grid.alpha = 1;
		grid.scrollFactor.set(1, 3.5);
		add(grid);

		runa = new FlxSprite().loadGraphic(Paths.image("runa/" + runaCharacter[0]));
		runa.scale.set(0.5, 0.5);
		runa.x += 350;
		runa.y += 0;
		add(runa);

		storymenu = new FlxSprite().loadGraphic(Paths.image("runa/StoryMenu"));
		freeplay = new FlxSprite().loadGraphic(Paths.image("runa/Freeplay"));
		settings = new FlxSprite().loadGraphic(Paths.image("runa/Settings"));
		achievements = new FlxSprite().loadGraphic(Paths.image("runa/Achievements"));
		var menuTags:Array<FlxSprite> = [storymenu, freeplay, settings, achievements];

		for (tags in menuTags)
		{
			tags.antialiasing = true;
			tags.scale.set(0.6, 0.6);
			tags.x = itemsOriginalPos;
			add(tags);
		};

		menuTags[0].y += 30;
		menuTags[1].y = menuTags[0].y + 200; 
		menuTags[2].y = menuTags[1].y + 200; 
		menuTags[3].y = 30;

		menuTags[3].x = 800;
	}

	// haveToReset doesnt have a var btw faggot :3
	var haveToReset:Bool = true;
	function backItem():Void {
		if (haveToReset) {
			TitleState.initialized = false;
			TitleState.closedState = false;
			FlxG.sound.music.fadeOut(0.3);
			FlxG.camera.fade(FlxColor.BLACK, 0.5, false, function() {
				FlxG.sound.music.stop();
				FlxG.sound.music = null;
				FlxG.resetGame();
			}, true);
			return;
		}
	}

	override function update(elapsed:Float) {
		mouseHover();
		if (controls.BACK) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
		buttonControls();
	}

	override function beatHit()
	{
		// im gay
		super.beatHit();
		grid.velocity.x = 24 + 20;
		FlxTween.tween(grid.velocity, {x: 24}, Conductor.crochet/1000, {ease : FlxEase.quadOut});
	}
	private function buttonControls():Void {
		if (controls.BACK) {
			MusicBeatState.switchState(new TitleState()); // youre welcome :catUm:
		}
	}

	// Tween
	var storymenuHover:FlxTween;
	var freeplayHover:FlxTween;
	var settingsHover:FlxTween;
	var achievementsHover:FlxTween;

	var curSelect = 0;
	function mouseHover():Void {
		var storymenuX = storymenu.x;
    	var storymenuY = storymenu.y;
    	var storymenuWidth = storymenu.width;
    	var storymenuHeight = storymenu.height;

		var freeplayX = freeplay.x;
    	var freeplayY = freeplay.y;
    	var freeplayWidth = freeplay.width;
    	var freeplayHeight = freeplay.height;

		var settingsX = settings.x;
    	var settingsY = settings.y;
    	var settingsWidth = settings.width;
    	var settingsHeight = settings.height;

		var achievementsX = achievements.x;
		var achievementsY = achievements.y;
		var achievementsWidth = 374;
		var achievementsHeight = 422;

		var mouseX = FlxG.mouse.x;
		var mouseY = FlxG.mouse.y;

		if (storymenuHover != null) storymenuHover.cancel();
		if (freeplayHover != null) freeplayHover.cancel();
		if (settingsHover != null) settingsHover.cancel();
		if (achievementsHover != null) achievementsHover.cancel();

		// resets itself lmao!!!
		curSelect = 0;

		// <---- STORY MENU ---->
		if (mouseX > storymenuX && mouseX < storymenuX + storymenuWidth &&
			mouseY > storymenuY && mouseY < storymenuY + storymenuHeight) {
				storymenuHover = FlxTween.tween(storymenu, {x: itemsOriginalPos + 30}, 0.1);
				runa.loadGraphic(Paths.image("runa/" + runaCharacter[0]));
				curSelect = 1;
		} else {
			storymenuHover = FlxTween.tween(storymenu, {x: itemsOriginalPos}, 0.1);
		}

		// <---- FREEPLAY ---->
		if (mouseX > freeplayX && mouseX < freeplayX + freeplayWidth &&
			mouseY > freeplayY && mouseY < freeplayY + freeplayHeight) {
				freeplayHover = FlxTween.tween(freeplay, {x: itemsOriginalPos + 30}, 0.1);
				runa.loadGraphic(Paths.image("runa/" + runaCharacter[1]));
				curSelect = 2;
		} else {
			freeplayHover = FlxTween.tween(freeplay, {x: itemsOriginalPos}, 0.1);
		}

		// <---- SETTINGS ---->
		if (mouseX > settingsX && mouseX < settingsX + settingsWidth &&
			mouseY > settingsY && mouseY < settingsY + settingsHeight) {
				settingsHover = FlxTween.tween(settings, {x: itemsOriginalPos + 30}, 0.1);
				runa.loadGraphic(Paths.image("runa/" + runaCharacter[2]));
				curSelect = 3;
		} else {
			settingsHover = FlxTween.tween(settings, {x: itemsOriginalPos}, 0.1);
		}

		// <---- ACHIEVEMENTS ---->
		if (mouseX > achievementsX && mouseX < achievementsX + achievementsWidth && 
			mouseY > achievementsY && mouseY < achievementsY + achievementsHeight) {
				achievementsHover = FlxTween.tween(achievements, {y: itemsOriginalPos + 120}, 0.2);
				curSelect = 4;
		} else {
			// i think that ur gay :broken_heart: -runa
			achievementsHover = FlxTween.tween(achievements, {y: itemsOriginalPos}, 0.2);
		}
	}
}