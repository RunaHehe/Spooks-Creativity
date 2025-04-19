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

class FaggotMenu extends MusicBeatState
{
	var fuckasseryBG:FlxSprite;

	var storymenu:FlxSprite;
	var freeplay:FlxSprite;
	var settings:FlxSprite;

	override function create()
	{
		fuckasseryBG = new FlxSprite().loadGraphic(Paths.image("runa/bg/gradient"));
		add(fuckasseryBG);

		storymenu = new FlxSprite().loadGraphic(Paths.image("runa/StoryMenu"));
		freeplay = new FlxSprite().loadGraphic(Paths.image("runa/Freeplay"));
		settings = new FlxSprite().loadGraphic(Paths.image("runa/Settings"));
		var menuTags:Array<FlxSprite> = [storymenu, freeplay, settings];

		for (tags in menuTags)
		{
			tags.antialiasing = true;
			tags.scale.set(0.6, 0.6);
			add(tags);
		};

		/*
		storymenu = new FlxSprite().loadGraphic(Paths.images("runa/" + menuImages[0]));
		storymenu.antialiasing = false;
		storymenu.scale.set(0.6, 0.6);
		add(storymenu);

		freeplay = new FlxSprite().loadGraphic(Paths.images("runa/" + menuImages[1]));
		freeplay.antialiasing = false;
		freeplay.scale.set(0.6, 0.6);
		add(freeplay);

		settings = new FlxSprite().loadGraphic(Paths.images("runa/" + menuImages[2]));
		settings.antialiasing = false;
		settings.scale.set(0.6, 0.6);
		add(settings);
		*/
	}
}