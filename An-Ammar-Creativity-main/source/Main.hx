package;

import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.display.StageScaleMode;
import mobile.StorageUtil;

//crash handler stuff
#if CRASH_HANDLER
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
import Discord.DiscordClient;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end
import flixel.system.FlxAssets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import mobile.CopyState;

using StringTools;

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var fpsVar:FPS;
	

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
		// #if FLX_SOUND_TRAY
		// _customSoundTray = FlxFunkSoundTray;
		// #end
	}

	public function new()
	{
		super();
		
		#if mobile
		#if android
		StorageUtil.requestPermissions();
		#end
		Sys.setCwd(StorageUtil.getStorageDirectory());
		#end

		#if windows
		@:functionCode("
		#include <windows.h>
		#include <winuser.h>
		setProcessDPIAware() // allows for more crisp visuals
		DisableProcessWindowsGhosting() // lets you move the window and such if it's not responding
		")
		#end

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}
	
		ClientPrefs.loadDefaultKeys();
		addChild(new GameMain(gameWidth, gameHeight, #if (mobile && MODS_ALLOWED) CopyState.checkExistingFiles() ? initialState : CopyState #else initialState #end, framerate, framerate, skipSplash, startFullscreen));

		#if !mobile
		fpsVar = new FPS(10, 3, 0x7CFFFFFF);
		Main.fpsVar.defaultTextFormat = new openfl.text.TextFormat('assets/fonts/vcr.ttf', 14, -1);
		addChild(fpsVar);
		Lib.current.stage.align = "tl";
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		FlxG.game.stage.quality = openfl.display.StageQuality.LOW;
		if(fpsVar != null) {
			fpsVar.visible = ClientPrefs.showFPS;
		}
		#end

		FlxG.stage.window.title = "Friday Night Funkin': An Ammar Creativity V4";
		#if debug FlxG.stage.window.title += " - DEBUG"; #end

		FlxG.game.focusLostFramerate = #if mobile 30 #else 60 #end;
		#if mobile
		//LimeSystem.allowScreenTimeout = ClientPrefs.data.screensaver; 		
		FlxG.scaleMode = new mobile.MobileScaleMode();
		#end

		// shader coords fix
		FlxG.signals.gameResized.add(function (w, h) {
		     if (FlxG.cameras != null) {
			   for (cam in FlxG.cameras.list) {
				@:privateAccess
				if (cam != null && cam._filters != null)
					resetSpriteCache(cam.flashSprite);
			    }
			}

			if (FlxG.game != null)
				resetSpriteCache(FlxG.game);
		});

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
		
		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end
	}

	static function resetSpriteCache(sprite:Sprite) {
		@:privateAccess {
		    sprite.__cacheBitmap = null;
			sprite.__cacheBitmapData = null;
		}
	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "PsychEngine_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error;

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		Application.current.window.alert(errMsg, "Error!");
		DiscordClient.shutdown();
		Sys.exit(1);
	}
	#end
}

class GameMain extends FlxGame
	{
		public function new(gameWidth:Int = 0, gameHeight:Int = 0, ?initialState:Class<FlxState>, updateFramerate:Int = 60, drawFramerate:Int = 60, skipSplash:Bool = false, startFullscreen:Bool = false)
		{
			super(gameWidth, gameHeight, initialState, updateFramerate, drawFramerate, skipSplash, startFullscreen);
			#if FLX_SOUND_TRAY
			_customSoundTray = FlxFunkSoundTray;
			#end
		}
	}

class FlxFunkSoundTray extends flixel.system.ui.FlxSoundTray
{
	var _bar:Bitmap;
	
	public function new() {
		super();
		removeChildren();
		
		final bg = new Bitmap(new BitmapData(80, 25, false, 0xff3f3f3f));
		addChild(bg);

		_bar = new Bitmap(new BitmapData(75, 25, false, 0xffffffff));
		_bar.x = 2.5;
		addChild(_bar);

		final tmp:Bitmap = new Bitmap(openfl.Assets.getBitmapData("assets/images/soundtray.png", false), null, true);
		addChild(tmp);
		screenCenter();
		
		tmp.scaleX = 0.5;
		tmp.scaleY = 0.5;
		tmp.x -= tmp.width * 0.2;
		tmp.y -= 5;

		y = -height;
		visible = false;
	}
	
	override function update(elapsed:Float) {
		super.update(elapsed / 4 ); // hack, sound tray is slow
	}

	override function show(up:Bool = false) {
		if (!silent) {
			#if desktop
			final sound = FlxAssets.getSound("assets/sounds/scrollMenu");
			if (sound != null)
				FlxG.sound.load(sound).play();
			#end
		}

		_timer = 0.25;
		y = 0;
		visible = active = true;
		_bar.scaleX = FlxG.sound.muted ? 0 : FlxG.sound.volume;
	}

	override function screenCenter() {
		_defaultScale = Math.min(FlxG.stage.stageWidth / FlxG.width, FlxG.stage.stageHeight / FlxG.height) * 2;
		super.screenCenter();
	}
}		