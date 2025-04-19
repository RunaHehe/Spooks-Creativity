// lock tf in bros
// hi runa, me go rn cause i has do something :wavey:

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
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxBackdrop;

class FaggotMenu extends MusicBeatState
{
	var fuckasseryBG:FlxSprite;
	var grid:FlxBackdrop;

	var storymenu:FlxSprite;
	var freeplay:FlxSprite;
	var settings:FlxSprite;

	var runa:FlxSprite;
	var runaCharacter:Array<String> = [
		"StoryMenuSpook",
		"FreePlaySpook",
		"SettingsSpook",
	];

	var itemsOriginalPos:Int = -211 - 50;

	override function create()
	{
		#if desktop
            DiscordClient.changePresence("In Spook's Creatiivty Menu", null);
        #end

		fuckasseryBG = new FlxSprite().loadGraphic(Paths.image("runa/bg/gradient"));
		add(fuckasseryBG);

		grid = new FlxBackdrop(FlxGridOverlay.createGrid(40, 40, 80, 80, true, 0x775419FF, 0x335419FF));
		grid.velocity.set(40, 40);
		add(grid);

		runa = new FlxSprite().loadGraphic(Paths.image("runa/" + runaCharacter[0]));
		add(runa);

		storymenu = new FlxSprite().loadGraphic(Paths.image("runa/StoryMenu"));
		freeplay = new FlxSprite().loadGraphic(Paths.image("runa/Freeplay"));
		settings = new FlxSprite().loadGraphic(Paths.image("runa/Settings"));
		var menuTags:Array<FlxSprite> = [storymenu, freeplay, settings];

		for (tags in menuTags)
		{
			tags.antialiasing = true;
			tags.scale.set(0.6, 0.6);
			tags.x = itemsOriginalPos;
			add(tags);
		};

		menuTags[0].y -= 50;
		menuTags[1].y = menuTags[0].y + 150;
		menuTags[2].y = menuTags[1].y + 150;
	}

	override function update(elapsed:Float) {
		mouseHover();
	}

	// Tween
	var storymenuHover:FlxTween;
	var freeplayHover:FlxTween;
	var settingsHover:FlxTween;

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

		var mouseX = FlxG.mouse.x;
		var mouseY = FlxG.mouse.y;

		if (storymenuHover != null) storymenuHover.cancel();
		if (freeplayHover != null) freeplayHover.cancel();
		if (settingsHover != null) settingsHover.cancel();

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
	}
}