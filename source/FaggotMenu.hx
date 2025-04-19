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
			tags.x -= 110;
			add(tags);
		};
	}
}