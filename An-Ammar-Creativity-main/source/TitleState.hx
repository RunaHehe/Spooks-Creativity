package;

import openfl.display.BlendMode;
#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
#if MOBILE
import flixel.input.touch.FlxTouch;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
//import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFrame;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;

#if cpp
import hxvlc.flixel.FlxVideo;
import hxvlc.flixel.FlxVideoSprite;
#end

using StringTools;
typedef TitleData =
{

	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}
class TitleState extends MusicBeatState
{
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	#if cpp
	var video:FlxVideoSprite;
	#end
	
	var titleTextColors:Array<FlxColor> = [0xFF33FFFF, 0xFF3333CC];
	var titleTextAlphas:Array<Float> = [1, .64];

	var curWacky:Array<String> = [];

	public static var updateVersion:String = '';

	override public function create():Void
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();

		//curWacky = FlxG.random.getObject(getIntroTextShit());

		swagShader = new ColorSwap();
		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99/AnAmmar');
		ClientPrefs.loadPrefs();
		Highscore.load();


		if(!initialized)
		{
			if(FlxG.save.data != null && FlxG.save.data.fullscreen)
			{
				FlxG.fullscreen = FlxG.save.data.fullscreen;
				//trace('LOADED FULLSCREEN SETTING!!');
			}
			persistentUpdate = true;
			persistentDraw = true;
		}

		if (FlxG.save.data.weekCompleted != null)
			StoryMenuState.weekCompleted = FlxG.save.data.weekCompleted;
		

		FlxG.mouse.visible = true;
		#if !desktop
		FlxG.mouse.visible = false;
		#end

		if(FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
			
		} else {
			#if desktop
			if (!DiscordClient.isInitialized)
			{
				DiscordClient.initialize();
				Application.current.onExit.add (function (exitCode) {
					DiscordClient.shutdown();
				});
			}
			#end

			if (initialized)
				startIntro();
			else
			{
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					startIntro();
				});
			}
		}
		
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var swagShader:ColorSwap = null;

	//Ammar
	var bg:FlxSprite;
	var fnf:FlxSprite;
	var anammar:FlxSprite;
	var creativity:FlxSprite;

	var checks:FlxBackdrop;
	var checksDark:FlxBackdrop;
	var dotsGradient:FlxBackdrop;
	var logoCanBeat:Bool = false;

	function startIntro()
	{
		if (!initialized)
		{
			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			}
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		antidebug.DebugSave.loadAntiDebug();

		bg = new FlxSprite(0, -1500).loadGraphic(Paths.image("ammar/introBG"));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.setGraphicSize(Std.int(1280 * 1.05));
		bg.updateHitbox();
		bg.screenCenter(X);
		//bg.color = 0xFF40C701;
		bg.alpha = 1;
		add(bg);

		checksDark = new FlxBackdrop(Paths.image("ammar/Head"), XY);
		checksDark.antialiasing = ClientPrefs.globalAntialiasing;
		checksDark.setGraphicSize(Std.int(checksDark.width*2.9));
		checksDark.updateHitbox();
		checksDark.screenCenter();
        checksDark.velocity.set(20 * 0.7, -15 * 0.7);
        checksDark.alpha = 0; //0.14
		checksDark.color = 0xFF000000;
		add(checksDark);

		checks = new FlxBackdrop(Paths.image("ammar/Head"), XY);
		checks.antialiasing = ClientPrefs.globalAntialiasing;
		checks.setGraphicSize(Std.int(checks.width*2.9));
		checks.updateHitbox();
		checks.screenCenter();
        checks.velocity.set(20, -15);
        checks.alpha = 0; //0.3
		add(checks);

		checks.blend = BlendMode.SCREEN;
		checksDark.blend = BlendMode.MULTIPLY;

		dotsGradient = new FlxBackdrop(Paths.image("ammar/blackDots"), X);
		dotsGradient.antialiasing = ClientPrefs.globalAntialiasing;
		dotsGradient.setGraphicSize(Std.int(1280*1.04));
		dotsGradient.updateHitbox();
		dotsGradient.screenCenter();
        dotsGradient.velocity.set(30, 0);
        dotsGradient.alpha = 0; //0.3
		dotsGradient.y += 125;
		add(dotsGradient);

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
		logoBl.antialiasing = ClientPrefs.globalAntialiasing;

		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();

		fnf = new FlxSprite(0, 0).loadGraphic(Paths.image("ammar/FNF"));
		fnf.antialiasing = ClientPrefs.globalAntialiasing;
		fnf.screenCenter();
		fnf.alpha = 0;

		anammar = new FlxSprite(0, 0).loadGraphic(Paths.image("ammar/An Ammar"));
		anammar.antialiasing = ClientPrefs.globalAntialiasing;
		anammar.screenCenter();
		anammar.alpha = 0;

		creativity = new FlxSprite(0, 0).loadGraphic(Paths.image("ammar/Creativity"));
		creativity.antialiasing = ClientPrefs.globalAntialiasing;
		creativity.screenCenter();
		creativity.alpha = 0;

		add(fnf);
		add(anammar);
		add(creativity);
		fnf.scale.set(3, 3);
		anammar.scale.set(3, 3);
		creativity.scale.set(3, 3);	

		swagShader = new ColorSwap();
		gfDance = new FlxSprite(512, 40);

		var easterEgg:String = FlxG.save.data.psychDevsEasterEgg;
		if(easterEgg == null) easterEgg = ''; //html5 fix

		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = ClientPrefs.globalAntialiasing;

		//add(gfDance);
		//gfDance.shader = swagShader.shader;
		//add(logoBl);
		//logoBl.shader = swagShader.shader;

		titleText = new FlxSprite(100+40, 576);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		var animFrames:Array<FlxFrame> = [];
		@:privateAccess {
			titleText.animation.findByPrefix(animFrames, "ENTER IDLE");
			titleText.animation.findByPrefix(animFrames, "ENTER FREEZE");
		}
		
		if (animFrames.length > 0) {
			newTitle = true;
			
			titleText.animation.addByPrefix('idle', "ENTER IDLE", 24);
			titleText.animation.addByPrefix('press', ClientPrefs.flashing ? "ENTER PRESSED" : "ENTER FREEZE", 24);
		}
		else {
			newTitle = false;
			
			titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
			titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		}
		
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		//titleText.screenCenter(X);
		add(titleText);
		titleText.alpha = 0;

		#if cpp
		video = new FlxVideoSprite(0, 0);
		video.bitmap.onFormatSetup.add(function():Void
		{
			video.setGraphicSize(FlxG.width, FlxG.height);
			video.updateHitbox();
			video.screenCenter();
		});
		video.bitmap.onEndReached.add(video.destroy);
		video.autoPause = true;
		//video.load(Paths.video('Intro'));
		video.load(Paths.video('Intro'));
		video.antialiasing = false;
		video.autoVolumeHandle = false;
		video.bitmap.mute = true;
		add(video);
		#end
		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();
		
		credTextShit = new Alphabet(0, 0, "", true);
		credTextShit.screenCenter();
		
		// credTextShit.alignment = CENTER;
		
		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = ClientPrefs.globalAntialiasing;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (initialized)
			skipIntro();
		else {
			initialized = true;
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(4, 0, 0.7);
			trace('----------------- Aku Sayang Aku juga sayang ---------------');
			#if cpp
			if (video != null) {
				video.play();
				video.bitmap.mute = true;
			}
			#end
		}

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;
	private static var playJingle:Bool = false;
	
	var newTitle:Bool = false;
	var titleTimer:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		FlxG.camera.zoom =  FlxMath.lerp(FlxG.camera.zoom, 1, FlxMath.bound((elapsed * 7), 0, 1));
		FlxG.camera.angle =  FlxMath.lerp(FlxG.camera.angle, 0, FlxMath.bound((elapsed * 7), 0, 1));
		if (checks != null) {
			checks.angle =  FlxMath.lerp(checks.angle, 0, FlxMath.bound((elapsed * 6), 0, 1));
			checksDark.angle =  FlxMath.lerp(checksDark.angle, 0, FlxMath.bound((elapsed * 6), 0, 1));
		}
		if (logoCanBeat)
			{
				var fnfsizeLerp:Float = FlxMath.lerp(fnf.scale.x, 1, FlxMath.bound((elapsed * 7.5), 0, 1));
				var ansizeLerp:Float = FlxMath.lerp(anammar.scale.x, 1, FlxMath.bound((elapsed * 7.5), 0, 1));
				var crsizeLerp:Float = FlxMath.lerp(creativity.scale.x, 1, FlxMath.bound((elapsed * 7.5), 0, 1));
				fnf.scale.set(fnfsizeLerp, fnfsizeLerp);
				anammar.scale.set(ansizeLerp, ansizeLerp);
				creativity.scale.set(crsizeLerp, crsizeLerp);
			}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if MOBILE
		for (movement in FlxG.touches.list) {
			if (movement.justPressed) {
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}
		
		if (newTitle) {
			titleTimer += CoolUtil.boundTo(elapsed, 0, 1);
			if (titleTimer > 2) titleTimer -= 2;
		}

		// EASTER EGG

		if (initialized && !transitioning && skippedIntro)
		{
			if (newTitle && !pressedEnter)
			{
				var timer:Float = titleTimer;
				if (timer >= 1)
					timer = (-timer) + 2;
				
				timer = FlxEase.quadInOut(timer);
				
				titleText.color = FlxColor.interpolate(titleTextColors[0], titleTextColors[1], timer);
				titleText.alpha = FlxMath.lerp(titleTextAlphas[0], titleTextAlphas[1], timer);
			}
			
			if(pressedEnter)
			{
				titleText.color = FlxColor.WHITE;
				titleText.alpha = 1;
				
				if(titleText != null) titleText.animation.play('press');

				FlxG.camera.flash(ClientPrefs.flashing ? FlxColor.WHITE : 0x4CFFFFFF, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				transitioning = true;
				// FlxG.sound.music.stop();

				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					MusicBeatState.switchState(new MainMenuStateAmmar());
					
					closedState = true;
				});
				// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
			}
		}

		if (initialized && pressedEnter && !skippedIntro && ClientPrefs.progress >= 0)
		{
			skipIntro();
			FlxG.camera.flash(FlxColor.WHITE, 4);
		}

		if(swagShader != null)
		{
			if(controls.UI_LEFT) swagShader.hue -= elapsed * 0.1;
			if(controls.UI_RIGHT) swagShader.hue += elapsed * 0.1;
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>, ?offset:Float = 0)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true);
			money.screenCenter(X);
			money.y += (i * 60) + 200 + offset;
			if(credGroup != null && textGroup != null) {
				credGroup.add(money);
				textGroup.add(money);
			}
		}
	}

	function addMoreText(text:String, ?offset:Float = 0)
	{
		if(textGroup != null && credGroup != null) {
			var coolText:Alphabet = new Alphabet(0, 0, text, true);
			coolText.screenCenter(X);
			coolText.y += (textGroup.length * 60) + 200 + offset;
			credGroup.add(coolText);
			textGroup.add(coolText);
		}
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	private var sickBeats:Int = 0; //Basically curBeat but won't be skipped if you hold the tab or resize the screen
	public static var closedState:Bool = false;
	override function beatHit()
	{
		super.beatHit();

		if(logoBl != null)
			logoBl.animation.play('bump', true);

		if(gfDance != null) {
			danceLeft = !danceLeft;
			if (danceLeft)
				gfDance.animation.play('danceRight');
			else
				gfDance.animation.play('danceLeft');
		}

		if (curBeat >= 32) {
			FlxG.camera.zoom = (curBeat % 2 == 0 ? 1.03 : 1.01);
		}
		if (skippedIntro)
			FlxG.camera.angle = (curBeat%2 == 0 ? 1 : -1);
		if (logoCanBeat)
		{
			fnf.scale.set(1.06, 1.06);
			anammar.scale.set(1.1, 1.1);
			creativity.scale.set(1.13, 1.13);

			if (checks != null) {
				checks.angle = (curBeat%2 == 0 ? 15 : -15);
				checksDark.angle = (curBeat%2 == 0 ? -15 : 15);
			}
		}

		if(!closedState) {
			if (curBeat < 32 && video != null && video.bitmap != null) {
				video.pause();
				video.bitmap.time = Std.int(Conductor.songPosition);
				video.play();
			}
			switch (curBeat)
			{
				case 1:
					// //FlxG.sound.music.stop();
					// FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
					// FlxG.sound.music.fadeIn(4, 0, 0.7);
					// if (video != null) {
					// 	video.play();
					// 	video.alpha = 1;
					// }
				/*case 2:
					#if PSYCH_WATERMARKS
					createCoolText(['Unique Mod'], 40);
					#else
					createCoolText(['Yeah']);
					#end
				// credTextShit.visible = true;
				case 4:
					addMoreText('An Ammar', 40);
				// credTextShit.text += '\npresent...';
				// credTextShit.addText();
				case 5:
					deleteCoolText();
				// credTextShit.visible = false;
				// credTextShit.text = 'In association \nwith';
				// credTextShit.screenCenter();
				case 6:
					createCoolText(['Check out'], -40);
				case 8:
					addMoreText('my YT', -40);
					ngSpr.visible = true;
				// credTextShit.text += '\nNewgrounds';
				case 9:
					deleteCoolText();
					ngSpr.visible = false;
				// credTextShit.visible = false;

				// credTextShit.text = 'Shoutouts Tom Fulp';
				// credTextShit.screenCenter();
				case 10:
					createCoolText([curWacky[0]]);
				// credTextShit.visible = true;
				case 12:
					addMoreText(curWacky[1]);
				// credTextShit.text += '\nlmao';
				case 13:
					deleteCoolText();
				// credTextShit.visible = false;
				// credTextShit.text = "Friday";
				// credTextShit.screenCenter();*/
				case 28:
					createCoolText(['FNF']);
				// credTextShit.visible = true;
				case 29:
					addMoreText('Spooks');
				// credTextShit.text += '\nNight';
				case 30:
					addMoreText('Creativity'); // credTextShit.text += '\nFunkin';

				case 31:
					addMoreText('V1'); // credTextShit.text += '\nFunkin';

				case 32:
					skipIntro();
					FlxG.camera.flash(FlxColor.WHITE, 4);
			}
		}
	}

	var skippedIntro:Bool = false;
	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);
			remove(credGroup);

			titleText.alpha = 1;

			FlxTween.tween(bg, {y:((720/2) - (bg.height/2))}, 1, {ease: FlxEase.expoOut, startDelay: 0.4});
			FlxTween.tween(fnf, {"scale.x":1, "scale.y":1, alpha:1}, 1, {ease: FlxEase.expoOut, startDelay: 0.3});
			FlxTween.tween(anammar, {"scale.x":1, "scale.y":1, alpha:1}, 1, {ease: FlxEase.expoOut, startDelay: 0.4});
			FlxTween.tween(creativity, {"scale.x":1, "scale.y":1, alpha:1}, 1, {ease: FlxEase.expoOut, startDelay: 0.5});

			FlxTween.tween(checks, {alpha:0.3}, 1, {ease: FlxEase.quadOut, startDelay: 0.5});
			FlxTween.tween(checksDark, {alpha:0.14}, 1, {ease: FlxEase.quadOut, startDelay: 0.5});
			FlxTween.tween(dotsGradient, {alpha:0.3}, 1, {ease: FlxEase.quadOut, startDelay: 0.6});

			#if cpp
			if (video != null) {
				video.stop();
				video.destroy();
				video.alpha = 0;
			}
			#end
		
			var timer:FlxTimer = new FlxTimer().start(1.5, function(tmr:FlxTimer) {
				logoCanBeat = true;
				fnf.origin.y = 283;
				anammar.origin.y = 283;
				creativity.origin.y = 283;
			});

			
			skippedIntro = true;
		}
	}

	var songsToCache:Array<String> = [
		'discord-annoyer', 'shut-up', 'depression', 'moderator',
		'hate-comment', 'twitter-argument', 'google', 'big-problem',
		'no-debug', 'myself'
	];
	function cacheSongs():Void 
	{
		trace('loading song');
		for (song in songsToCache) {
			Paths.inst(song);
			Paths.voices(song);
		}
		trace('done loaded');
	}
}
