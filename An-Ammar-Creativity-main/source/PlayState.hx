package;

import MainMenuStateAmmar.MenuText;
import flixel.graphics.FlxGraphic;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import Note.EventNote;
import openfl.events.KeyboardEvent;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxSave;
import animateatlas.AtlasFrameMaker;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;
import Conductor.Rating;
import modchart.*;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end

#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

#if sys
import sys.FileSystem;
import sys.io.File;
#end

#if VIDEOS_ALLOWED
//import vlc.MP4Handler;
import hxvlc.flixel.FlxVideo;
import hxvlc.flixel.FlxVideoSprite;
#end
#if MODCHARTS_EDWHAK 
import modcharting.ModchartFuncs;
import modcharting.NoteMovement;
import modcharting.PlayfieldRenderer;
#end

import Vocals.VocalsData;
import stagesprite.DiscordMembers;
import stagesprite.DiscordChannels;
import stagesprite.DiscordUser;
import stagesprite.AttachedNormalText;

import mobile.HitboxControl;

using StringTools;

class PlayState extends MusicBeatState
{
	#if MODCHARTS 
	public var modManager:ModManager; 
	public var notesToSpawn:Array<Array<Note>> = []; // too lazy to redo all unspawnNotes code so this'll handle the spawning and thats it lol
	#end
	public var useModchart:Bool = false;

	public static var STRUM_X = 55;
	public static var STRUM_X_MIDDLESCROLL = -265;

	public static var ratingStuff:Array<Dynamic> = [
		['WHAT', 0.1], //From 0% to 9%
		['How', 0.2], //From 10% to 19%
		['Bad', 0.4], //From 20% to 39%
		['Uncool', 0.5], //From 40% to 49%
		['Cool', 0.6], //From 50% to 59%
		['Nice', 0.69], //From 60% to 68%
		['Good', 0.7], //69%
		['Great', 0.8], //From 70% to 79%
		['Sick!', 0.9], //From 80% to 89%
		['Awesome!!', 0.99], //From 90% to 99%
		['Perfect!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];

	//event variables
	private var isCameraOnForcedPos:Bool = false;

	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	public var variables:Map<String, Dynamic> = new Map();
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, ModchartText> = new Map<String, ModchartText>();
	public var modchartSaves:Map<String, FlxSave> = new Map<String, FlxSave>();
	#else
	public var boyfriendMap:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	public var modchartTweens:Map<String, FlxTween> = new Map();
	public var modchartSprites:Map<String, ModchartSprite> = new Map();
	public var modchartTimers:Map<String, FlxTimer> = new Map();
	public var modchartSounds:Map<String, FlxSound> = new Map();
	public var modchartTexts:Map<String, ModchartText> = new Map();
	public var modchartSaves:Map<String, FlxSave> = new Map();
	#end

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;

	public var playbackRate(default, set):Float = ClientPrefs.getGameplaySetting('songspeed', 1);

	public var boyfriendGroup:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;
	public static var curStage:String = '';
	public static var isPixelStage:Bool = false;
	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyName:String = '';
	public static var storyDifficulty:Int = 1;


	public var vocals:FlxSound;
	public var opponentVocals:FlxSound;
	public var separateVocals:Bool = false;

	public var dad:Character = null;
	public var gf:Character = null;
	public var boyfriend:Boyfriend = null;


	//NOTES
	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<EventNote> = [];
	public var spawnTime:Float = 1500;

	public var songSpeedTween:FlxTween;
	public var songSpeed(default, set):Float = 1;
	public var songSpeedType:String = "multiplicative";
	public var noteKillOffset:Float = 350;

	private var strumLine:FlxSprite;

	public var camFollow:FlxPoint;
	public var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	public var grpNoteHoldSplashes:FlxTypedGroup<NoteHoldSplash>;

	public var camZooming:Bool = false;
	public var camZoomingMult:Float = 1;
	public var camZoomingDecay:Float = 1;
	private var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;

	private var healthBarBG:FlxSprite;
	public var healthBar:FlxBar;
	private var healthBarOverlay:AttachedSprite;
	var songPercent:Float = 0;

	private var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;

	public var ratingsData:Array<Rating> = [];
	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;
	public var comboSpr:FlxSprite; public var comboSprY:Float = -30;
	public var comboNumSpr:FlxSprite;
	public var comboSprTween:FlxTween;
	public var comboNumSprTween:FlxTween;

	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	public var startingSong:Bool = false;
	private var updateTime:Bool = true;
	public static var changedDifficulty:Bool = false;
	public static var chartingMode:Bool = false;

	//Gameplay settings
	public var healthGain:Float = 1;
	public var healthLoss:Float = 1;
	public var instakillOnMiss:Bool = false;
	public var cpuControlled:Bool = false;
	public var practiceMode:Bool = false;

	public var haveUsePractice:Bool = false;
	public var haveUseBotplay:Bool = false;

	public var botplaySine:Float = 0;
	public var botplayTxt:FlxText;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	public var cameraSpeed:Float = 1;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialogueJson:DialogueFile = null;

	var dadbattleBlack:BGSprite;
	var dadbattleLight:BGSprite;
	var dadbattleSmokes:FlxSpriteGroup;

	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;
	var songScoreLerp:Float = 0;
	var timeTxt:FlxText;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;

	public var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;
	private var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var inCutscene:Bool = false;
	public var skipCountdown:Bool = false;
	var songLength:Float = 0;

	public var boyfriendCameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	//Achievement shit
	var keysPressed:Array<Bool> = [];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	//Android Controls
	public var mobileControls:FlxTypedGroup<HitboxControl>;

	// Lua shit
	public static var instance:PlayState;
	public var luaArray:Array<FunkinLua> = [];
	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	public var introSoundsSuffix:String = '';

	// Debug buttons
	private var debugKeysChart:Array<FlxKey>;
	private var debugKeysCharacter:Array<FlxKey>;

	// Less laggy controls
	private var keysArray:Array<Dynamic>;
	private var controlArray:Array<String>;

	var precacheList:Map<String, String> = new Map<String, String>();
	
	// stores the last judgement object
	public static var lastRating:FlxSprite;
	// stores the last combo sprite object
	public static var lastCombo:FlxSprite;
	// stores the last combo score objects in an array
	public static var lastScore:Array<FlxSprite> = [];

	// SOCIAL MEDIA STUFF
	//public var camFront:FlxCamera;
	//public var camBack:FlxCamera;
	public var VOCALS:Array<VocalsData> = [];
	// Discord Stage
	var discordBG:BGSprite;
	var discordTopBar:BGSprite;
	var discordMessage:BGSprite;
	var discordChannels:DiscordChannels;
	var discordMembers:DiscordMembers;
	var discordPlayer:DiscordUser;
	var discordOpponent:DiscordUser;

	var redOverlay:BGSprite; //shut up song
	var glitchy:FlxSprite;
	// Youtube Stage
	var ytBG:BGSprite;
	var ytBGVideo:BGSprite;
	var ytBGVideoTitle:BGSprite;
	var ytTopBar:BGSprite;
	var ytBGTopBar:BGSprite;
	var ytComments:FlxText;

	var oldTelevisionShader:shaders.OldTelevision;
	var glitchingShader:shaders.Glitching;

	// Void Stage
	var backGlow:BGSprite;
	var backGlowOver:BGSprite;
	var downGlow:BGSprite;
	var voidParticles:FlxEmitter;

	//? HUD
	public var ratePrefix:String = "RATING: ";
	public var scorePrefix:String = "SCORES: ";
	public var missPrefix:String = "MISSES: ";
	public var comboPrefix:String = "COMBOS: ";

	public var lives:Int = 0; var curLives:Int = 0;
	public var iconSpeed:Int = 1;  //lower the slower
	var lerpHealth:Float = 1;

	var hudStyle:String = '';
	public var discordHealthText:AttachedNormalText;
	public var newHealthSystem:Bool = false;

	public var HUDtoRight:Bool = false;

	var lightHUD:FlxSprite;
	var lightHUDTween:FlxTween;
	var noteColor:Array<FlxColor> = [0xFFC24B99,0xFF00FFFF,0xFF12FA05,0xFFF9393F];
	public var enableCoolLightNote:Bool = false;
	//?
	//SONG INTRO
	public var songTitle:FlxText;
	public var songLogo:FlxSprite;
	public var songDesc:FlxText;
	public var songDiff:FlxText;

	public var countdownText:FlxText;
	public var countdownTween:FlxTween;
	public var countdownTweenColor:FlxTween;

	public var introTimer:FlxTimer;
	//

	override public function create()
	{
		//trace('Playback Rate: ' + playbackRate);
		Paths.clearStoredMemory();

		// for lua
		instance = this;

		debugKeysChart = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		debugKeysCharacter = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));
		PauseSubState.songName = null; //Reset to default

		keysArray = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
		];

		controlArray = [
			'NOTE_LEFT',
			'NOTE_DOWN',
			'NOTE_UP',
			'NOTE_RIGHT'
		];
		

		//Ratings
		ratingsData.push(new Rating('sick')); //default rating

		var rating:Rating = new Rating('good');
		rating.ratingMod = 0.7;
		rating.score = 200;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('bad');
		rating.ratingMod = 0.4;
		rating.score = 100;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('shit');
		rating.ratingMod = 0;
		rating.score = 50;
		rating.noteSplash = false;
		ratingsData.push(rating);

		// For the "Just the Two of Us" achievement
		for (i in 0...keysArray.length)
		{
			keysPressed.push(false);
		}

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// Gameplay settings
		healthGain = ClientPrefs.getGameplaySetting('healthgain', 1);
		healthLoss = ClientPrefs.getGameplaySetting('healthloss', 1);
		instakillOnMiss = ClientPrefs.getGameplaySetting('instakill', false);
		practiceMode = ClientPrefs.getGameplaySetting('practice', false);
		cpuControlled = ClientPrefs.getGameplaySetting('botplay', false);

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		
		// camFront = new FlxCamera();
		// camBack = new FlxCamera();
		// camFront.bgColor.alpha = 0;
		// camBack.bgColor.alpha = 0;

		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		//Social cams
		// FlxG.cameras.add(camBack, false);
		// FlxG.cameras.add(camFront, false);
		//
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		grpNoteHoldSplashes = new FlxTypedGroup<NoteHoldSplash>();

		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		FlxTransitionableState.skipNextTransIn = false;
		CustomFadeTransition.nextCamera = camOther;
		CustomFadeTransition.newLoading = true;

		persistentUpdate = true;
		persistentDraw = true;

		createMobileControls();

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		#if desktop
		storyDifficultyText = CoolUtil.difficulties[storyDifficulty];

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
			detailsText = "Story Mode: " + storyName;
		else
			detailsText = "Freeplay";
		

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		#end

		GameOverSubstate.resetVariables();
		var songName:String = Paths.formatToSongPath(SONG.song);

		trace(SONG.introAtStep);
		curStage = SONG.stage;

		if(SONG.stage == null || SONG.stage.length < 1) {
			switch (songName) // DONT FORGET StageData.hx !!!! AND PROJECT.hx
			{
				default:
					curStage = 'stage';
			}
		}
		SONG.stage = curStage;

		var stageData:StageFile = StageData.getStageFile(curStage);
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,

				boyfriend: [770, 100],
				girlfriend: [400, 130],
				opponent: [100, 100],
				hide_girlfriend: false,

				camera_boyfriend: [0, 0],
				camera_opponent: [0, 0],
				camera_girlfriend: [0, 0],
				camera_speed: 1
			};
		}

		defaultCamZoom = stageData.defaultZoom;
		isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		if(stageData.camera_speed != null)
			cameraSpeed = stageData.camera_speed;

		boyfriendCameraOffset = stageData.camera_boyfriend;
		if(boyfriendCameraOffset == null) //Fucks sake should have done it since the start :rolling_eyes:
			boyfriendCameraOffset = [0, 0];

		opponentCameraOffset = stageData.camera_opponent;
		if(opponentCameraOffset == null)
			opponentCameraOffset = [0, 0];

		girlfriendCameraOffset = stageData.camera_girlfriend;
		if(girlfriendCameraOffset == null)
			girlfriendCameraOffset = [0, 0];

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);


		switch (curStage)
		{
			case 'stage': //Week 1
				var bg:BGSprite = new BGSprite('stage/stageback', -600, -200, 0.9, 0.9);
				add(bg);

				var stageFront:BGSprite = new BGSprite('stage/stagefront', -650, 600, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				add(stageFront);
				if(!ClientPrefs.lowQuality) {
					var stageLight:BGSprite = new BGSprite('stage/stage_light', -125, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					add(stageLight);
					var stageLight:BGSprite = new BGSprite('stage/stage_light', 1225, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					stageLight.flipX = true;
					add(stageLight);

					var stageCurtains:BGSprite = new BGSprite('stage/stagecurtains', -500, -300, 1.3, 1.3);
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					add(stageCurtains);
				}
				dadbattleSmokes = new FlxSpriteGroup(); //troll'd
			
			/*
			case 'discord' :
				var fontName:String = "Discord/ggsans-Medium.ttf";

				discordBG = new BGSprite(null, -50, -50, 0, 0);
				discordBG.makeGraphic(Std.int(1280*1.2),Std.int(720*1.2), "FFFFFF");
				discordBG.updateHitbox();
				discordBG.cameras = [camBack];
				discordBG.screenCenter();
				discordBG.color = 0xFF36393F;
				add(discordBG);

				discordTopBar = new BGSprite('topBar', 0, 0, 0, 0);
				discordTopBar.setGraphicSize(Std.int(discordTopBar.width*1.05));
				discordTopBar.updateHitbox();
				discordTopBar.cameras = [camFront];
				discordTopBar.screenCenter(X);

				discordMessage = new BGSprite('messageBar', 0, 640, 0, 0);
				discordMessage.cameras = [camFront];
				discordMessage.screenCenter(X);

				discordChannels = new DiscordChannels(-5, 50);
				discordChannels.cameras = [camFront];
				discordChannels.defaultX = discordChannels.x;
			
				discordMembers = new DiscordMembers(0, 0);
				discordMembers.setPosition(
					1280 - discordMembers.width + 5,
					720 - discordMembers.height + 5
				);
				discordMembers.defaultX = discordMembers.x;
				discordMembers.cameras = [camFront];

				add(discordMembers);
				for (member in discordMembers.members) {
					add(member);
					member.cameras = [camFront];
				}
				for (category in discordMembers.categories) {
					add(category);
					category.cameras = [camFront];
				}

				add(discordChannels);
				add(discordMessage);
				add(discordTopBar);

				VOCALS = vocalsSetup();

				var playerChar:String = SONG.player1.toLowerCase();
				var enemyChar:String = SONG.player2.toLowerCase();

				discordPlayer = new DiscordUser(false, playerChar);
				add(discordPlayer);
				add(discordPlayer.message);

				discordOpponent = new DiscordUser(true, enemyChar);
				add(discordOpponent);
				add(discordOpponent.message);

				discordPlayer.otherUser = discordOpponent;
				discordOpponent.otherUser = discordPlayer;
				
				discordPlayer.cameras = [camBack];
				discordPlayer.message.cameras = [camBack];

				discordOpponent.cameras = [camBack];
				discordOpponent.message.cameras = [camBack];

				lightHUD = new FlxSprite().loadGraphic(Paths.image('Effects/HUDLight'));
				add(lightHUD);
				lightHUD.alpha = 0;

				var curSong:String = Paths.formatToSongPath(SONG.song);
				if (curSong == 'shut-up') {
					redOverlay = new BGSprite(null, 0, 0, 0, 0);
					redOverlay.makeGraphic(Std.int(FlxG.width * 1.2), Std.int(FlxG.height * 1.2), FlxColor.RED);
					redOverlay.blend = BlendMode.MULTIPLY;
					add(redOverlay);
					redOverlay.cameras = [camOther];
					redOverlay.alpha = 0;

					glitchy = new FlxSprite(0, 0);
					glitchy.frames = Paths.getSparrowAtlas('glitch');
					glitchy.animation.addByPrefix('glitch', 'g', 16, true);
					glitchy.animation.play('glitch', true);
					glitchy.blend = BlendMode.ADD;
					add(glitchy);
					glitchy.cameras = [camOther];
					glitchy.screenCenter();
					glitchy.alpha = 0;
				}

				hudStyle = 'discord';

				if (curSong == 'depression') {
					oldTelevisionShader = new shaders.OldTelevision();
					camBack.setFilters([new ShaderFilter(oldTelevisionShader.shader)]);
					camFront.setFilters([new ShaderFilter(oldTelevisionShader.shader)]);
				}
				
			case 'youtube' :
				ytBG = new BGSprite(null, 0 ,0);
				ytBG.makeGraphic(1400, 900, 0xFFFFFFFF);
				ytBG.screenCenter();
				ytBG.cameras = [camBack];
				ytBG.color = 0xFF0F0F0F;
				add(ytBG);

				ytBGVideo = new BGSprite(null, 0 ,0);
				ytBGVideo.makeGraphic(1400, 620, 0xFF000000);
				ytBGVideo.cameras = [camBack];
				add(ytBGVideo);

				ytBGVideoTitle = new BGSprite('infoYoutube', 50 ,620.5);
				ytBGVideoTitle.setGraphicSize(Std.int(1280 * 0.95));
				ytBGVideoTitle.cameras = [camBack];
				add(ytBGVideoTitle);

				ytTopBar = new BGSprite('TopBar', 0 ,0);
				ytTopBar.setGraphicSize(Std.int(1280));
				ytTopBar.cameras = [camBack];
				add(ytTopBar);

				ytComments = new FlxText(55, 875, 200, '100 Comments', 14);
				ytComments.setFormat(Paths.font('Youtube/YoutubeSansMedium.otf'), 14, 0xFFDDDDDD, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE_FAST, 0x0);
				ytComments.cameras = [camBack];
				add(ytComments);

			case 'void' :
				backGlow = new BGSprite('GreenGradientMiddle', -1200, -1200, 0.6, 0.6);
				backGlow.setGraphicSize(Std.int(backGlow.width*3), Std.int(backGlow.height*1.5));
				backGlow.updateHitbox();
				add(backGlow);
				backGlow.alpha = 0.05;

				downGlow = new BGSprite('GreenGradientBottom', 0, 0, 0, 0);
				downGlow.setGraphicSize(Std.int(downGlow.width*2), Std.int(downGlow.height*1.1));
				downGlow.updateHitbox();
				add(downGlow);
				downGlow.cameras = [camBack];
				downGlow.alpha = 0;
				downGlow.blend = BlendMode.ADD;

				backGlowOver = new BGSprite('GreenGradientMiddle', -1200, -1200, 0.6, 0.6);
				backGlowOver.setGraphicSize(Std.int(backGlowOver.width*3), Std.int(backGlowOver.height*1.25));
				backGlowOver.updateHitbox();
				add(backGlowOver);
				backGlowOver.alpha = 0.05;
				backGlowOver.blend = BlendMode.ADD;

				voidParticles = new FlxEmitter(-900, 850, 400);
				voidParticles.makeParticles(12, 12, FlxColor.LIME, 400);
				voidParticles.width = 3170;
				voidParticles.height = 50;
				voidParticles.launchMode = FlxEmitterMode.CIRCLE;
				voidParticles.launchAngle.set(-90 - 5, 90 + 5);
				voidParticles.alpha.set(1, 1, 0, 0);
				add(voidParticles);
				voidParticles.start(false, 0.1);
			*/
			}

		if(isPixelStage) 
			introSoundsSuffix = '-pixel';
		

		add(gfGroup); //Needed for blammed lights


		add(dadGroup);
		add(boyfriendGroup);

		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

		
		// "GLOBAL" SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [];
		
		#if MODS_ALLOWED
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/scripts/'));
		#end
		//android crash

		
		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
	
		#end

		// STAGE SCRIPTS
		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'stages/' + curStage + '.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}

		if(doPush)
			luaArray.push(new FunkinLua(luaFile));
		#end

		var gfVersion:String = SONG.gfVersion;
		if(gfVersion == null || gfVersion.length < 1)
		{
			switch (curStage)
			{
				case 'limo':
					gfVersion = 'gf-car';
				case 'mall' | 'mallEvil':
					gfVersion = 'gf-christmas';
				case 'school' | 'schoolEvil':
					gfVersion = 'gf-pixel';
				case 'tank':
					gfVersion = 'gf-tankmen';
				default:
					gfVersion = 'gf';
			}

			switch(Paths.formatToSongPath(SONG.song))
			{
				case 'stress':
					gfVersion = 'pico-speaker';
			}
			SONG.gfVersion = gfVersion; //Fix for the Chart Editor
		}

		if (!stageData.hide_girlfriend)
		{
			gf = new Character(0, 0, gfVersion);
			startCharacterPos(gf);
			gf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(gf);
			startCharacterLua(gf.curCharacter);
		}

		dad = new Character(0, 0, SONG.player2);
		startCharacterPos(dad, true);
		dadGroup.add(dad);
		startCharacterLua(dad.curCharacter);

		boyfriend = new Boyfriend(0, 0, SONG.player1);
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);
		startCharacterLua(boyfriend.curCharacter);

		var camPos:FlxPoint = new FlxPoint(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
		if(gf != null)
		{
			camPos.x += gf.getGraphicMidpoint().x + gf.cameraPosition[0];
			camPos.y += gf.getGraphicMidpoint().y + gf.cameraPosition[1];
		}

		if(dad.curCharacter.startsWith('gf')) {
			dad.setPosition(GF_X, GF_Y);
			if(gf != null)
				gf.visible = false;
		}

		var file:String = Paths.json(songName + '/dialogue'); //Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file)) {
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
		}

		var file:String = Paths.txt(songName + '/' + songName + 'Dialogue'); //Checks for vanilla/Senpai dialogue
		if (OpenFlAssets.exists(file)) {
			dialogue = CoolUtil.coolTextFile(file);
		}
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = startNextDialogue;
		doof.skipDialogueThing = skipDialogue;

		Conductor.songPosition = -5000 / Conductor.songPosition;

		strumLine = new FlxSprite(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if (!useModchart)
			if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;

		strumLine.scrollFactor.set();

		var showTime:Bool = (ClientPrefs.timeBarType != 'Disabled');
		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = showTime;
		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 44;

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.text = SONG.song;
		}
		updateTime = showTime;

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = showTime;
		timeBarBG.color = FlxColor.BLACK;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;
		//add(timeBarBG);

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		timeBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
		timeBar.alpha = 0;
		timeBar.visible = showTime;
		//add(timeBar);
		//add(timeTxt);
		timeBarBG.sprTracker = timeBar;

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		#if !MODCHARTS_EDWHAK add(grpNoteSplashes); #end

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.size = 24;
			timeTxt.y += 3;
		}

		var splash:NoteSplash = new NoteSplash(-100, 100, 0);
		grpNoteSplashes.add(splash);
		NoteSplash.scrollX = 1; NoteSplash.scrollY = 1;
		splash.alpha = 0.0;

		var holdsplash:NoteHoldSplash = new NoteHoldSplash(-100, 100, 0);
		grpNoteHoldSplashes.add(holdsplash);
		NoteHoldSplash.scrollX = 1; NoteHoldSplash.scrollY = 1;
		holdsplash.alpha = 0.0;
		new FlxTimer().start(1, function(tmr:FlxTimer){
			holdsplash.endHold(true);
		});

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();

		//?STARTING HUD
		var songsInfo:Map<String, Array<String>> = [
			'discord-annoyer' => ['discord', 'COVER SONG'],
			'shut-up' => ['discord', 'CUSTOM SONG'],
			'depression' => ['discord', 'COVER SONG'],
			'moderator' => ['discord', 'CUSTOM SONG'],

			'hate-comment' => ['youtube', 'COVER SONG'],
			'twitter-argument' => ['twitter', 'COVER SONG'],
			'google' => ['google', 'CUSTOM SONG'],
			'big-problem' => ['youtube', 'CUSTOM SONG'],

			'no-debug' => ['ammar', 'COVER SONG'],
			'myself' => ['ammar', 'COVER SONG'],
			'furry-femboy' => ['ammar', 'COVER SONG'],

			'furry-appeared' => ['', 'CUSTOM SONG'],
			'protogen' => ['', 'COVER SONG']
		];
		var diffColor:Map<String, FlxColor> = [
			'hard' => 0xFFFF0000,
			'easy' => 0xFF0077FF,
			'insane' => 0xFF8C00FF
		];
		var songName:String = Paths.formatToSongPath(SONG.song);
		var songArray:Array<String> = songsInfo[songName] == null ? ['', ''] : songsInfo[songName];
		var path:String = songArray[0];
		var desc:String = songArray[1];
		var color:FlxColor = 0xFFFFFFFF;
		var isNone:Bool = false;
		if (path == null) path = 'discord';
		if (path == '') {
			isNone = true;
			path = 'discord';
		}
		if (desc == null) desc = '';
		if (diffColor[ClientPrefs.aDifficulty.toLowerCase()] != null) color = diffColor[ClientPrefs.aDifficulty.toLowerCase()];
		songLogo = new FlxSprite(0, 0);
		if (FileSystem.exists(Paths.mods("An Ammar's Creativity" + '/images/intro/'+path+'.png'))) {
			songLogo.visible = true;
			songLogo.loadGraphic(Paths.image('intro/'+path));
		} else {
			songLogo.visible = false;
		}
		add(songLogo);
		songLogo.alpha = 0;
		songLogo.setGraphicSize(Std.int(songLogo.width*0.4));
		songLogo.screenCenter(); songLogo.x += 600;
		if (isNone) songLogo.visible = false;
		
		songTitle = new FlxText(0, 0, 0, 32, false);
		songTitle.setFormat(Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf"), 48, 0xFFFFFFFF, FlxTextAlign.CENTER);
		songTitle.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 6);
		songTitle.text = (PlayState.SONG.song).replace('-', ' ');
		add(songTitle);
		songTitle.screenCenter();
		songTitle.alpha = 0;

		songDesc = new FlxText(0, 0, 0, 32, false);
		songDesc.setFormat(Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf"), 32, 0xFFFFFFFF, FlxTextAlign.CENTER);
		songDesc.setBorderStyle(FlxTextBorderStyle.SHADOW, 0x85000000, 4);
		songDesc.text = desc;
		add(songDesc);
		songDesc.screenCenter();
		songDesc.y += 50;
		songDesc.alpha = 0;

		songDiff = new FlxText(0, 0, 0, 32, false);
		songDiff.setFormat(Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf"), 32, color, FlxTextAlign.CENTER);
		songDiff.setBorderStyle(FlxTextBorderStyle.SHADOW, 0x85000000, 4);
		songDiff.text = ClientPrefs.aDifficulty.toUpperCase();
		add(songDiff);
		songDiff.screenCenter();
		songDiff.y -= 50;
		songDiff.alpha = 0;
		songDiff.visible = ClientPrefs.aDifficulty.toLowerCase() != 'normal';
		//?
		// startCountdown();

		generateSong(SONG.song);
		#if MODCHARTS 
		modManager = new ModManager(this); 
		#end
		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys())
		{
			#if MODS_ALLOWED
			var luaToLoad:String = Paths.modFolders('custom_notetypes/' + notetype + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
			#elseif sys
			var luaToLoad:String = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
			if(OpenFlAssets.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			#end
		}
		for (event in eventPushedMap.keys())
		{
			#if MODS_ALLOWED
			var luaToLoad:String = Paths.modFolders('custom_events/' + event + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_events/' + event + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
			#elseif sys
			var luaToLoad:String = Paths.getPreloadPath('custom_events/' + event + '.lua');
			if(OpenFlAssets.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			#end
		}
		#end
		
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		#if MODCHARTS_EDWHAK
		playfieldRenderer = new PlayfieldRenderer(strumLineNotes, notes, this);
		playfieldRenderer.cameras = [camHUD];
		add(playfieldRenderer);
		add(grpNoteSplashes);
		#end

		// After all characters being loaded, it makes then invisible 0.01s later so that the player won't freeze when you change characters
		// add(strumLine);

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		moveCameraSection();

		createHUD();

		strumLineNotes.cameras = [camHUD];
		grpNoteHoldSplashes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		if (hudStyle == 'discord') {
			// healthBarBG.cameras = [camFront];
			// discordHealthText.cameras = [camFront];
			// iconP1.cameras = [camFront];
			// iconP2.cameras = [camFront];
		} else {
			healthBarBG.cameras = [camHUD];
			discordHealthText.cameras = [camHUD];
			iconP1.cameras = [camHUD];
			iconP2.cameras = [camHUD];
		}
		if (healthBarOverlay != null) healthBarOverlay.cameras = [camHUD];

		scoreTxt.cameras = [camHUD];
		missTxt.cameras = [camHUD];
		rateTxt.cameras = [camHUD];
		comboTxt.cameras = [camHUD];
		
		countdownText.cameras = [camHUD];

		botplayTxt.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		songLogo.cameras = [camHUD];
		songTitle.cameras = [camHUD];
		songDesc.cameras = [camHUD];
		songDiff.cameras = [camHUD];

		if (lightHUD != null) {
			lightHUD.cameras = [camOther];
			lightHUD.screenCenter();
		}

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		// SONG SPECIFIC SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('data/' + Paths.formatToSongPath(SONG.song) + '/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('data/' + Paths.formatToSongPath(SONG.song) + '/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/data/' + Paths.formatToSongPath(SONG.song) + '/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/data/' + Paths.formatToSongPath(SONG.song) + '/' ));// using push instead of insert because these should run after everything else
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end

		var daSong:String = Paths.formatToSongPath(curSong);
		if (isStoryMode && !seenCutscene)
		{
			switch (daSong)
			{
				default:
					startCountdown();
			}
			seenCutscene = true;
		}
		else
		{
			startCountdown();
		}
		RecalculateRating();

		//PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND FUCK THEM UP IDK HOW HAXE WORKS
		if(ClientPrefs.hitsoundVolume > 0) precacheList.set('hitsound', 'sound');
		precacheList.set('missnote1', 'sound');
		precacheList.set('missnote2', 'sound');
		precacheList.set('missnote3', 'sound');

		if (PauseSubState.songName != null) {
			precacheList.set(PauseSubState.songName, 'music');
		} else if(ClientPrefs.pauseMusic != 'None') {
			precacheList.set(Paths.formatToSongPath(ClientPrefs.pauseMusic), 'music');
		}

		precacheList.set('alphabet', 'image');
	
		#if desktop
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		#end

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		#if MODCHARTS 
			if (useModchart) 
				modManager.modchartEnable = true;
		#end
		#if MODCHARTS_EDWHAK
			ModchartFuncs.loadLuaFunctions();
		#end
		callOnLuas('onCreatePost', []);

		super.create();

		cacheCountdown();
		cachePopUpScore();
		for (key => type in precacheList)
		{
			//trace('Key $key is type $type');
			switch(type)
			{
				case 'image':
					Paths.image(key);
				case 'sound':
					Paths.sound(key);
				case 'music':
					Paths.music(key);
			}
		}
		Paths.clearUnusedMemory();
		
		CustomFadeTransition.nextCamera = camOther;
	}

	public var scoreTxt:FlxText;
	public var rateTxt:FlxText;
	public var comboTxt:FlxText;
	public var missTxt:FlxText; // HIDE when Zero

	var scoreTxtTween:FlxTween;
	var rateTxtTween:FlxTween;
	var comboTxtTween:FlxTween;
	var missTxtTween:FlxTween;

	var barOffset:Array<Array<Float>> = [[0, 0], [0, 0], [0, 0]]; // BG, bar, overlay
	var lerpShakeBar:Float = 0;

	function createHUD():Void {

		var bgHUDName:String = 'healthBar';
		if (hudStyle == 'discord') {
			bgHUDName = 'HUD/discord/HealthBarBG';
			Paths.image('HUD/discord/HealthBarBG-Light');
		}
		healthBarBG = new FlxSprite(0, 0).loadGraphic(Paths.image(bgHUDName));
		healthBarBG.y = ClientPrefs.downScroll ? 0.11 * FlxG.height - 10 : FlxG.height * 0.89 + 30;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = !ClientPrefs.hideHud;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'lerpHealth', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.alpha = ClientPrefs.healthBarAlpha;
		healthBar.numDivisions = 500;
		//?healthBar.visible = !ClientPrefs.hideHud;

		healthBarOverlay = new AttachedSprite('HUD/healthBar');
		healthBarOverlay.y = FlxG.height * 0.89 + 30;
		healthBarOverlay.screenCenter(X);
		healthBarOverlay.scrollFactor.set();
		healthBarOverlay.visible = !ClientPrefs.hideHud;
		healthBarOverlay.xAdd = -4;
		healthBarOverlay.yAdd = -4;

		healthBar.scale.x = healthBarBG.scale.x = healthBarOverlay.scale.x = 0;

		var healthText:String = (CoolUtil.multiply('_ ', 24) + CoolUtil.multiply('O ', 24)).substr(0, 48*2-1);
		discordHealthText = new AttachedNormalText(healthText, Std.int(570 * 1.2), 18);
		discordHealthText.font = Paths.font('Discord/ggsans-Medium.ttf');
		discordHealthText.sprTracker = healthBarBG;
		discordHealthText.offsetX = 18;
		discordHealthText.offsetY = 28;
		
		if (hudStyle != 'discord') {
			add(healthBar);
			add(healthBarOverlay);
		} else {
			healthBarBG.setGraphicSize(Std.int(healthBarBG.width*1.2));
			healthBarBG.updateHitbox();
			healthBarBG.y = FlxG.height * 0.89 - 80;
			healthBarBG.screenCenter(X);
			add(healthBarBG);
			add(discordHealthText);
		}

		healthBarOverlay.sprTracker = healthBar;

		barOffset = [
			[healthBarBG.offset.x, healthBarBG.offset.y], 
			[healthBar.offset.x, healthBar.offset.y], 
			[healthBarOverlay.offset.x, healthBarOverlay.offset.y]
		];


		final borderOffset:Float = 20;
		final tx:Float = (HUDtoRight ? 1280-borderOffset : borderOffset);
		final daFont:String = "HUD/gaposiss.ttf";
		final space:Float = 30;
		final borderSi = 3;
		final align:FlxTextAlign = (HUDtoRight ? FlxTextAlign.RIGHT : FlxTextAlign.LEFT);

		scoreTxt = new FlxText(tx, 700 - borderOffset, 0, scorePrefix+'0');
		scoreTxt.setFormat(Paths.font(daFont), 20, FlxColor.WHITE, align , FlxTextBorderStyle.OUTLINE, 0xFF121212);
		scoreTxt.scrollFactor.set();
		//?scoreTxt.visible = !ClientPrefs.hideHud;
		scoreTxt.antialiasing = false;
		scoreTxt.origin.x = (HUDtoRight ? scoreTxt.width : 0);
		//if (HUDtoRight) scoreTxt.x -= scoreTxt.width;
		scoreTxt.borderSize = borderSi;
		scoreTxt.borderQuality = 0;
		add(scoreTxt);
		scoreTxt.x = tx;

		rateTxt = new FlxText(tx, 700 - borderOffset - space, 0, ratePrefix+'?');
		rateTxt.setFormat(Paths.font(daFont), 20, FlxColor.WHITE, align, FlxTextBorderStyle.OUTLINE, 0xFF121212);
		rateTxt.scrollFactor.set();
		rateTxt.x = tx;
		//?rateTxt.visible = !ClientPrefs.hideHud;
		rateTxt.antialiasing = false;
		rateTxt.origin.x = (HUDtoRight ? rateTxt.width : 0);
		//if (HUDtoRight) rateTxt.x -= rateTxt.width;
		rateTxt.borderSize = borderSi;
		rateTxt.borderQuality = 0;
		add(rateTxt);

		scoreTxt.x += (HUDtoRight ? 400 : -400);
		rateTxt.x += (HUDtoRight ? 400 : -400);

		missTxt = new FlxText(tx, 700 - borderOffset - (space*2), 0, missPrefix+'?');
		missTxt.setFormat(Paths.font(daFont), 20, FlxColor.WHITE, align, FlxTextBorderStyle.OUTLINE, 0xFF121212);
		missTxt.scrollFactor.set();
		missTxt.x = tx;
		//?missTxt.visible = !ClientPrefs.hideHud;
		missTxt.antialiasing = false;
		missTxt.origin.x = (HUDtoRight ? missTxt.width : 0);
		//if (HUDtoRight) missTxt.x -= missTxt.width;
		missTxt.borderSize = borderSi;
		missTxt.borderQuality = 0;
		add(missTxt);
		missTxt.visible = false;

		comboTxt = new FlxText(tx, 700 - borderOffset - (space*2), 0, comboPrefix+'?');
		comboTxt.setFormat(Paths.font(daFont), 20, FlxColor.WHITE, align, FlxTextBorderStyle.OUTLINE, 0xFF121212);
		comboTxt.scrollFactor.set();
		comboTxt.x = tx;
		//?comboTxt.visible = !ClientPrefs.hideHud;
		comboTxt.antialiasing = false;
		comboTxt.origin.x = (HUDtoRight ? comboTxt.width : 0);
		//if (HUDtoRight) comboTxt.x -= comboTxt.width;
		comboTxt.borderSize = borderSi;
		comboTxt.borderQuality = 0;
		add(comboTxt);
		comboTxt.alpha = 0;

		botplayTxt = new FlxText(400, timeBarBG.y + 55, FlxG.width - 800, "BOTPLAY", 32);
		botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.25;
		botplayTxt.visible = cpuControlled;
		add(botplayTxt);
		if(ClientPrefs.downScroll) {
			botplayTxt.y = timeBarBG.y - 78;
		}

		if (lives > 0) {
			missTxt.visible = true;
			comboTxt.y -= space;

			curLives = lives;
			missTxt.text = "LIVES: " + curLives + "/" + lives;
		} 

		//ICONS

		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - 95;
		iconP1.visible = !ClientPrefs.hideHud;
		iconP1.alpha = ClientPrefs.healthBarAlpha;
		add(iconP1);

		iconP2 = new HealthIcon(dad.healthIcon, false);
		iconP2.y = healthBar.y - 95;
		iconP2.visible = !ClientPrefs.hideHud;
		iconP2.alpha = ClientPrefs.healthBarAlpha;
		add(iconP2);

		if (hudStyle == 'discord') {
			iconP1.y = iconP2.y -= 70;
		}

		countdownText = new FlxText(0, 0, 0, '');
		countdownText.setFormat(Paths.font("Discord/uni-sans-heavy.otf"), 128, 0xffffffff, CENTER, FlxTextBorderStyle.OUTLINE, 0x90000000);
		countdownText.borderSize = 2;
		countdownText.alignment = FlxTextAlign.CENTER;
		countdownText.scrollFactor.set();
		countdownText.alpha = 0;
		if (curStage.toLowerCase() == 'discordstage')
			add(countdownText);

		reloadHealthBarColors();

		comboSpr = new FlxSprite();
		comboSpr.frames = Paths.getSparrowAtlas('ComboSprite');
		comboSpr.animation.addByPrefix('sick', 'SICK', 30, false);
		comboSpr.animation.addByPrefix('good', 'GOOD', 30, false);
		comboSpr.animation.addByPrefix('bad', 'BAD', 30, false);
		comboSpr.animation.addByPrefix('shit', 'WORST', 30, false);
		comboSpr.animation.play('sick', true);
		comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.55));
		comboSpr.screenCenter(X); 
		comboSpr.cameras = [camHUD];
		comboSpr.visible = (!ClientPrefs.hideHud);
		comboSpr.antialiasing = ClientPrefs.globalAntialiasing;
		comboSpr.alpha = 0;
		if (ClientPrefs.downScroll && !ClientPrefs.middleScroll) comboSprY = 720 - (comboSpr.frameHeight) + 36;
		if (ClientPrefs.middleScroll && !ClientPrefs.downScroll) comboSprY = 720 - (comboSpr.frameHeight) + 36;
		// if (ClientPrefs.middleScroll) comboSprY = (720/2) - (comboSpr.frameHeight/2) - 10;
		comboSpr.y = comboSprY;
		comboSpr.x += 8;
		add(comboSpr);

	}

	function sortByTimeVocals(Obj1:VocalsData, Obj2:VocalsData):Int
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.time, Obj2.time);

	function vocalsSetup():Array<VocalsData> {

		var daVocals:Array<VocalsData> = []; // [strumTime, vocalData, isOpponent]
		if (SONG.vocals == null) {
			for (section in SONG.notes)
				for (songNotes in section.sectionNotes)
				{
					var output:VocalsData = {
						time: songNotes[0],
						data: Std.int(songNotes[1] % 4)
					};
					daVocals.push(output);
				}
			daVocals.sort(sortByTimeVocals);
			return daVocals;
		};


		for (vocal in SONG.vocals) {
			var mustPress:Bool = vocal[2];
			var data:Int = Std.int(vocal[1]); 
			// AA EE OO EEH to
			// EE OO AA EEH
			if (data == 0) data = 2;
			else if (data == 1) data = 0;
			else if (data == 2) data = 1;
			
			var output:VocalsData = {
				time: vocal[0],
				data: data
			};

			daVocals.push(output);
		}


		daVocals.sort(sortByTimeVocals);
		return daVocals;

	}

	function createMobileControls():Void {
		#if MOBILE
			mobileControls = new FlxTypedGroup<HitboxControl>();
			add(mobileControls);
			for (i in 0...4) {
				var hitbox:HitboxControl = new HitboxControl(i);
				mobileControls.add(hitbox);
			}

			mobileControls.camera = camOther;
		#end
	}

	#if (!flash && sys)
	public var runtimeShaders:Map<String, Array<String>> = new Map<String, Array<String>>();
	public function createRuntimeShader(name:String):FlxRuntimeShader
	{
		if(!ClientPrefs.shaders) return new FlxRuntimeShader();

		#if (!flash && MODS_ALLOWED && sys)
		if(!runtimeShaders.exists(name) && !initLuaShader(name))
		{
			FlxG.log.warn('Shader $name is missing!');
			return new FlxRuntimeShader();
		}

		var arr:Array<String> = runtimeShaders.get(name);
		return new FlxRuntimeShader(arr[0], arr[1]);
		#else
		FlxG.log.warn("Platform unsupported for Runtime Shaders!");
		return null;
		#end
	}

	public function initLuaShader(name:String, ?glslVersion:Int = 120)
	{
		if(!ClientPrefs.shaders) return false;

		if(runtimeShaders.exists(name))
		{
			FlxG.log.warn('Shader $name was already initialized!');
			return true;
		}

		var foldersToCheck:Array<String> = [Paths.mods('shaders/')];
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/shaders/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/shaders/'));
		
		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				var frag:String = folder + name + '.frag';
				var vert:String = folder + name + '.vert';
				var found:Bool = false;
				if(FileSystem.exists(frag))
				{
					frag = File.getContent(frag);
					found = true;
				}
				else frag = null;

				if (FileSystem.exists(vert))
				{
					vert = File.getContent(vert);
					found = true;
				}
				else vert = null;

				if(found)
				{
					runtimeShaders.set(name, [frag, vert]);
					//trace('Found shader $name!');
					return true;
				}
			}
		}
		FlxG.log.warn('Missing shader $name .frag AND .vert files!');
		return false;
	}
	#end

	function set_songSpeed(value:Float):Float
	{
		if(generatedMusic)
		{
			var ratio:Float = value / songSpeed; //funny word huh
			for (note in notes) note.resizeByRatio(ratio);
			for (note in unspawnNotes) note.resizeByRatio(ratio);
		}
		songSpeed = value;
		noteKillOffset = 350 / songSpeed;
		return value;
	}

	function set_playbackRate(value:Float):Float
	{
		if(generatedMusic)
		{
			if(vocals != null) vocals.pitch = value;
			if (separateVocals && opponentVocals != null) {
				opponentVocals.pitch = value;
			}
			FlxG.sound.music.pitch = value;
		}
		playbackRate = value;
		Conductor.safeZoneOffset = (ClientPrefs.safeFrames / 60) * 1000 * value;
		setOnLuas('playbackRate', playbackRate);
		return value;
	}

	public function addTextToDebug(text:String, color:FlxColor) {
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText) {
			spr.y += 20;
		});

		if(luaDebugGroup.members.length > 34) {
			var blah = luaDebugGroup.members[34];
			blah.destroy();
			luaDebugGroup.remove(blah);
		}
		luaDebugGroup.insert(0, new DebugLuaText(text, luaDebugGroup, color));
		#end
	}

	public function reloadHealthBarColors() {
		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));

		healthBar.updateBar();
	}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Boyfriend = new Boyfriend(0, 0, newCharacter);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					startCharacterLua(newBoyfriend.curCharacter);
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					startCharacterLua(newDad.curCharacter);
				}

			case 2:
				if(gf != null && !gfMap.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					startCharacterLua(newGf.curCharacter);
				}
		}
	}

	function startCharacterLua(name:String)
	{
		#if LUA_ALLOWED
		var doPush:Bool = false;
		var luaFile:String = 'characters/' + name + '.lua';
		#if MODS_ALLOWED
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}
		#else
		luaFile = Paths.getPreloadPath(luaFile);
		if(Assets.exists(luaFile)) {
			doPush = true;
		}
		#end

		if(doPush)
		{
			for (script in luaArray)
			{
				if(script.scriptName == luaFile) return;
			}
			luaArray.push(new FunkinLua(luaFile));
		}
		#end
	}

	public function getLuaObject(tag:String, text:Bool=true):FlxSprite {
		if(modchartSprites.exists(tag)) return modchartSprites.get(tag);
		if(text && modchartTexts.exists(tag)) return modchartTexts.get(tag);
		if(variables.exists(tag)) return variables.get(tag);
		return null;
	}

	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
			char.danceEveryNumBeats = 2;
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public var videoCutscene:FlxVideoSprite;
	public function startVideo(name:String)
	{
		#if VIDEOS_ALLOWED
		inCutscene = true;

		var filepath:String = Paths.video(name);
		#if sys
		if(!FileSystem.exists(filepath))
		#else
		if(!OpenFlAssets.exists(filepath))
		#end
		{
			FlxG.log.warn('Couldnt find video file: ' + name);
			startAndEnd();
			return;
		}

		videoCutscene = new FlxVideoSprite(0, 0);
		videoCutscene.antialiasing = true;
		videoCutscene.bitmap.onFormatSetup.add(function():Void
			{
				videoCutscene.setGraphicSize(FlxG.width, FlxG.height);
				videoCutscene.updateHitbox();
				videoCutscene.screenCenter();
			});
			videoCutscene.bitmap.onEndReached.add(function(){
			videoCutscene.destroy();
			startAndEnd();
		}
		);
		videoCutscene.load(filepath);
		videoCutscene.cameras = [camOther];
		videoCutscene.bitmap.mute = false;
		videoCutscene.bitmap.volume = 1;
		videoCutscene.autoVolumeHandle = true;

		new FlxTimer().start(0.5, function(tmr:FlxTimer){
			videoCutscene.play();
			add(videoCutscene);
		});
		#else
		FlxG.log.warn('Platform not supported!');
		startAndEnd();
		return;
		#end
	}

	function startAndEnd()
	{
		if(endingSong)
			endSong();
		else
			startCountdown();
	}

	var dialogueCount:Int = 0;
	public var psychDialogue:DialogueBoxPsych;
	//You don't have to add a song, just saying. You can just do "startDialogue(dialogueJson);" and it should work
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{
		// TO DO: Make this more flexible, maybe?
		if(psychDialogue != null) return;

		if(dialogueFile.dialogue.length > 0) {
			inCutscene = true;
			precacheList.set('dialogue', 'sound');
			precacheList.set('dialogueClose', 'sound');
			psychDialogue = new DialogueBoxPsych(dialogueFile, song);
			psychDialogue.scrollFactor.set();
			if(endingSong) {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					endSong();
				}
			} else {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					startCountdown();
				}
			}
			psychDialogue.nextDialogueThing = startNextDialogue;
			psychDialogue.skipDialogueThing = skipDialogue;
			psychDialogue.cameras = [camHUD];
			add(psychDialogue);
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			if(endingSong) {
				endSong();
			} else {
				startCountdown();
			}
		}
	}

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var countdownReady:FlxSprite;
	public var countdownSet:FlxSprite;
	public var countdownGo:FlxSprite;
	public static var startOnTime:Float = 0;

	function cacheCountdown()
	{
		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		introAssets.set('default', ['ready', 'set', 'go']);
		introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

		var introAlts:Array<String> = introAssets.get('default');
		if (isPixelStage) introAlts = introAssets.get('pixel');
		
		for (asset in introAlts)
			Paths.image(asset);
		
		Paths.sound('intro3' + introSoundsSuffix);
		Paths.sound('intro2' + introSoundsSuffix);
		Paths.sound('intro1' + introSoundsSuffix);
		Paths.sound('introGo' + introSoundsSuffix);
	}

	public function startCountdown():Void
	{
		if(startedCountdown) {
			callOnLuas('onStartCountdown', []);
			return;
		}

		inCutscene = false;
		var ret:Dynamic = callOnLuas('onStartCountdown', [], false);
		if(ret != FunkinLua.Function_Stop) {
			if (skipCountdown || startOnTime > 0) skipArrowStartTween = true;

			generateStaticArrows(0);
			generateStaticArrows(1);
			for (i in 0...playerStrums.length) {
				setOnLuas('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defaultPlayerStrumY' + i, playerStrums.members[i].y);
			}
			for (i in 0...opponentStrums.length) {
				setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				//if(ClientPrefs.middleScroll) opponentStrums.members[i].visible = false;
			}

			#if MODCHARTS_EDWHAK
			NoteMovement.getDefaultStrumPos(this);
			#end

			#if MODCHARTS 
			if (useModchart) {
				modManager.receptors = [playerStrums.members, opponentStrums.members];
				modManager.registerDefaultModifiers();
			}
			#end

			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;
			setOnLuas('startedCountdown', true);
			callOnLuas('onCountdownStarted', []);

			FlxTween.tween(rateTxt, {x: rateTxt.x + (HUDtoRight ? -400 : 400)}, Conductor.crochet/1000*2, {ease:FlxEase.quadOut, startDelay: Conductor.crochet/1000});
			FlxTween.tween(scoreTxt, {x: scoreTxt.x + (HUDtoRight ? -400 : 400)}, Conductor.crochet/1000*2, {ease:FlxEase.quadOut});

			FlxTween.tween(healthBar.scale, {x: 1}, Conductor.crochet/1000*2, {ease:FlxEase.quadOut, startDelay: Conductor.crochet/1000*2});
			FlxTween.tween(healthBarBG.scale, {x: 1}, Conductor.crochet/1000*2, {ease:FlxEase.quadOut, startDelay: Conductor.crochet/1000*2});
			FlxTween.tween(healthBarOverlay.scale, {x: 1}, Conductor.crochet/1000*2, {ease:FlxEase.quadOut, startDelay: Conductor.crochet/1000*2});

			var swagCounter:Int = 0;

			if(startOnTime < 0) startOnTime = 0;

			if (startOnTime > 0) {
				clearNotesBefore(startOnTime);
				setSongTime(startOnTime - 350);
				return;
			}
			else if (skipCountdown)
			{
				setSongTime(0);
				return;
			}

			startTimer = new FlxTimer().start(Conductor.crochet / 1000 / playbackRate, function(tmr:FlxTimer)
			{
				if (gf != null && tmr.loopsLeft % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
				{
					gf.dance();
				}
				if (tmr.loopsLeft % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
				{
					boyfriend.dance();
				}
				if (tmr.loopsLeft % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
				{
					dad.dance();
				}

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', 'set', 'go']);
				introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

				var introAlts:Array<String> = introAssets.get('default');
				var antialias:Bool = ClientPrefs.globalAntialiasing;
				if(isPixelStage) {
					introAlts = introAssets.get('pixel');
					antialias = false;
				}

				switch (swagCounter)
				{
					case 0:
						FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
					case 1:
						if (curStage.toLowerCase() == 'discordstage') {
							countdownText.alpha = 1;
							countdownText.text = 'READY?'; countdownText.screenCenter();
							countdownTweenColor = FlxTween.color(countdownText, Conductor.crochet/1000, 0xFFBCC6FF, 0xFF6078FF, {ease: FlxEase.quadOut});
							countdownText.scale.set(1.2,1.2);
							countdownTween = FlxTween.tween(countdownText.scale, {x: 1, y:1}, Conductor.crochet/1000, {ease:FlxEase.quadOut});
			
						} else {
							countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
							countdownReady.cameras = [camHUD];
							countdownReady.scrollFactor.set();
							countdownReady.updateHitbox();

							if (PlayState.isPixelStage)
								countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));

							countdownReady.screenCenter();
							countdownReady.antialiasing = antialias;
							insert(members.indexOf(notes), countdownReady);
							FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									remove(countdownReady);
									countdownReady.destroy();
								}
							});
						}
						FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);

						
					case 2:
						if (curStage.toLowerCase() == 'discordstage') {
							if (countdownTween != null) countdownTween.cancel();
							if (countdownTweenColor != null) countdownTweenColor.cancel();
							countdownText.text = 'SET'; countdownText.screenCenter();
							countdownTweenColor = FlxTween.color(countdownText, Conductor.crochet/1000, 0xFFBCC6FF, 0xFF6078FF, {ease: FlxEase.quadOut});
							countdownText.scale.set(1.2,1.2);
							countdownTween = FlxTween.tween(countdownText.scale, {x: 1, y:1}, Conductor.crochet/1000, {ease:FlxEase.quadOut});
							
						} else {
							countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
							countdownSet.cameras = [camHUD];
							countdownSet.scrollFactor.set();

							if (PlayState.isPixelStage)
								countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));

							countdownSet.screenCenter();
							countdownSet.antialiasing = antialias;
							insert(members.indexOf(notes), countdownSet);
							FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									remove(countdownSet);
									countdownSet.destroy();
								}
							});
						}
						FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
					case 3:
						if (curStage.toLowerCase() == 'discordstage') {
							if (countdownTween != null) countdownTween.cancel();
							if (countdownTweenColor != null) countdownTweenColor.cancel();
							countdownText.text = 'TEXT!'; countdownText.screenCenter();
							countdownTweenColor = FlxTween.color(countdownText, Conductor.crochet/1000, 0xFFBCC6FF, 0x006078FF, {ease: FlxEase.expoOut, onComplete: function(twn:FlxTween){
								remove(countdownText);
							}});
							countdownText.scale.set(1.2,1.2);
							countdownTween = FlxTween.tween(countdownText.scale, {x: 1, y:1}, Conductor.crochet/1000, {ease:FlxEase.quadOut});
						} else {
							countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
							countdownGo.cameras = [camHUD];
							countdownGo.scrollFactor.set();

							if (PlayState.isPixelStage)
								countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));

							countdownGo.updateHitbox();

							countdownGo.screenCenter();
							countdownGo.antialiasing = antialias;
							insert(members.indexOf(notes), countdownGo);
							FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
								ease: FlxEase.cubeInOut,
								onComplete: function(twn:FlxTween)
								{
									remove(countdownGo);
									countdownGo.destroy();
								}
							});
						}
						FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
					case 4:
				}

				notes.forEachAlive(function(note:Note) {
					if(ClientPrefs.opponentStrums || note.mustPress)
					{
						note.copyAlpha = false;
						note.alpha = note.multAlpha;
						if(ClientPrefs.middleScroll && !note.mustPress) {
							note.alpha *= 0.35;
						}
					}
				});
				callOnLuas('onCountdownTick', [swagCounter]);

				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	}

	public function addBehindGF(obj:FlxObject)
	{
		insert(members.indexOf(gfGroup), obj);
	}
	public function addBehindBF(obj:FlxObject)
	{
		insert(members.indexOf(boyfriendGroup), obj);
	}
	public function addBehindDad (obj:FlxObject)
	{
		insert(members.indexOf(dadGroup), obj);
	}

	public function clearNotesBefore(time:Float)
	{
		var i:Int = unspawnNotes.length - 1;
		while (i >= 0) {
			var daNote:Note = unspawnNotes[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				unspawnNotes.remove(daNote);
				daNote.destroy();
			}
			--i;
		}

		i = notes.length - 1;
		while (i >= 0) {
			var daNote:Note = notes.members[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			--i;
		}
	}

	public function updateScore(miss:Bool = false)
	{
		rateTxt.text = '${ratePrefix}${Highscore.floorDecimal(ratingPercent * 100, 1)}%' /*ratingName*/;  
		comboTxt.text = comboPrefix + combo;  
		
		if (lives > 0)
			missTxt.text = "LIVES: " + curLives + "/" + lives;
		else
			missTxt.text = missPrefix + songMisses;  


		if(ClientPrefs.scoreZoom && !cpuControlled)
		{
			if (!miss) {
				if(scoreTxtTween != null) 
					scoreTxtTween.cancel();

				if(comboTxtTween != null) 
					comboTxtTween.cancel();
				
				scoreTxt.scale.x = (miss ? 0.95 : 1.05);
				comboTxt.scale.x = (miss ? 0.95 : 1.05);
				comboTxt.alpha = 1;
				
				//scoreTxt.origin.x = (HUDtoRight ? scoreTxt.width : 0);
				//comboTxt.origin.x = (HUDtoRight ? comboTxt.width : 0);

				scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1}, 0.5, {
					onComplete: function(twn:FlxTween) {
						scoreTxtTween = null;
					}
				});

				comboTxtTween = FlxTween.tween(comboTxt, {"scale.x": 1, alpha: 0}, 0.5, {
					onComplete: function(twn:FlxTween) {
						comboTxtTween = null;
					}
				});


			} else {
				if(missTxtTween != null) 
					missTxtTween.cancel();

				missTxt.scale.x = 1.05;

				if (!missTxt.visible) 
					comboTxt.y -= 30;
				missTxt.visible = true;

				missTxtTween = FlxTween.tween(missTxt.scale, {x: 1}, 0.5, {
					onComplete: function(twn:FlxTween) {
						missTxtTween = null;
					}
				});
			}
		}

		callOnLuas('onUpdateScore', [miss]);
	}

	public function setSongTime(time:Float)
	{
		if(time < 0) time = 0;

		FlxG.sound.music.pause();
		vocals.pause();
		if (separateVocals)
			opponentVocals.pause();

		FlxG.sound.music.time = time;
		FlxG.sound.music.pitch = playbackRate;
		FlxG.sound.music.play();

		if (Conductor.songPosition <= vocals.length)
		{
			vocals.time = time;
			vocals.pitch = playbackRate;
			if (separateVocals) {
				opponentVocals.time = time;
				opponentVocals.pitch = playbackRate;
			}
		}
		vocals.play();
		if (separateVocals)
			opponentVocals.play();
		Conductor.songPosition = time;
		songTime = time;
	}

	function startNextDialogue() {
		dialogueCount++;
		callOnLuas('onNextDialogue', [dialogueCount]);
	}

	function skipDialogue() {
		callOnLuas('onSkipDialogue', [dialogueCount]);
	}

	var previousFrameTime:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;

		var instPath:String = PlayState.SONG.song;
		var hardInst:Bool = (ClientPrefs.aDifficulty.toLowerCase() == 'hard');
		if (!Paths.instExist(instPath, '-hard')) {
			hardInst = false;
			trace('cant find hard inst');
        }  else {
			trace('can find hard inst');
		}
		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song, hardInst ? '-hard' : ''), 1, false);
		FlxG.sound.music.looped = false; 
		FlxG.sound.music.pitch = playbackRate;
		FlxG.sound.music.onComplete = finishSong.bind();
		vocals.play();
		if (separateVocals) 
			opponentVocals.play();

		if(startOnTime > 0)
		{
			setSongTime(startOnTime - 500);
		}
		startOnTime = 0;

		if(paused) {
			//trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			vocals.pause();
			if (separateVocals) 
				opponentVocals.pause();
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength);
		#end
		setOnLuas('songLength', songLength);
		callOnLuas('onSongStart', []);

		var startIntro:Int = SONG.introAtStep;
		introTimer = new FlxTimer().start(startIntro * Conductor.stepCrochet * 0.001, function(tmr:FlxTimer) {
			songTitle.scale.set(1.4, 1.4);
			songDesc.scale.set(0.6, 0.6);
			songDiff.scale.set(0.6, 0.6);
			FlxTween.tween(songTitle, {alpha: 1}, 1);
			FlxTween.tween(songTitle, {alpha: 0}, 1, {startDelay: 2.5});
			FlxTween.tween(songTitle.scale, {x: 1, y: 1}, 2, {ease: FlxEase.expoOut});
	
			FlxTween.tween(songDesc, {alpha: 1}, 1);
			FlxTween.tween(songDesc, {alpha: 0}, 1, {startDelay: 2.5});
			FlxTween.tween(songDesc.scale, {x: 1, y: 1}, 2, {ease: FlxEase.expoOut});
			FlxTween.tween(songDiff, {alpha: 1}, 1);
			FlxTween.tween(songDiff, {alpha: 0}, 1, {startDelay: 2.5});
			FlxTween.tween(songDiff.scale, {x: 1, y: 1}, 2, {ease: FlxEase.expoOut});
			songLogo.angle = 15;
			FlxTween.tween(songLogo, {x: FlxG.width/2 - songLogo.width/2, alpha: 1}, 1, {ease: FlxEase.quadOut});
			FlxTween.tween(songLogo, {x: FlxG.width/2 - songLogo.width/2 - 600, alpha: 0}, 1, {ease: FlxEase.quadIn, startDelay: 2.5});
	
			//ANGLE
			FlxTween.tween(songLogo, {angle: 2}, 1, {ease: FlxEase.quadOut});
			FlxTween.tween(songLogo, {angle: -2}, 1.5, {ease: FlxEase.linear, startDelay: 1});
			FlxTween.tween(songLogo, {angle: -15}, 1, {ease: FlxEase.quadIn, startDelay: 2.5});
		});
	}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();
	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());
		songSpeedType = ClientPrefs.getGameplaySetting('scrolltype','multiplicative');

		switch(songSpeedType)
		{
			case "multiplicative":
				songSpeed = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1);
			case "constant":
				songSpeed = ClientPrefs.getGameplaySetting('scrollspeed', 1);
		}

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices) {
			var hardVocals:Bool = (ClientPrefs.aDifficulty.toLowerCase() == 'hard');
			var foundHardModeVoice:Bool = false;
			if(Paths.voicesExist(PlayState.SONG.song) || Paths.voicesExist(PlayState.SONG.song, '-hard')) {
				if (!hardVocals) {
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song)); 
					trace('normal voice');
				} else if (hardVocals && (Paths.voicesExist(PlayState.SONG.song, '-hard'))) {
				vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song, '-hard')); 
				trace('hard voice');
				foundHardModeVoice = true;
				} else if (hardVocals) {
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song)); 
					trace('normal voice 2');
				}
			} else
				vocals = new FlxSound();
			
			if(!foundHardModeVoice && Paths.voicesExist(PlayState.SONG.song, '-opponent')) {
				if(Paths.voicesExist(PlayState.SONG.song, '-player')) {
					trace('saperate Voices!!');
					opponentVocals = new FlxSound().loadEmbedded(Paths.voicesOpponent(PlayState.SONG.song));
					vocals = new FlxSound().loadEmbedded(Paths.voicesPlayer(PlayState.SONG.song));
					separateVocals = true;
				}
			}
			if (true) {
				if (hardVocals) {
					if (!Paths.voicesExist(PlayState.SONG.song, '-opponent-hard') || !Paths.voicesExist(PlayState.SONG.song, '-player-hard')) {
						trace('no hard saperate voices song found ');
						hardVocals = false;
					} else if (Paths.voicesExist(PlayState.SONG.song, '-opponent-hard') && Paths.voicesExist(PlayState.SONG.song, '-player-hard')) {
						trace('saperate Hard Mode Voices!!');
						separateVocals = true;
						opponentVocals = new FlxSound().loadEmbedded(Paths.voicesOpponent(PlayState.SONG.song, '-hard'));
						vocals = new FlxSound().loadEmbedded(Paths.voicesPlayer(PlayState.SONG.song, '-hard'));
					}
				} 
			}
		}
		else
			vocals = new FlxSound();

		if (separateVocals) {
			opponentVocals.pitch = playbackRate;
			FlxG.sound.list.add(opponentVocals);
		}
		vocals.pitch = playbackRate;
		FlxG.sound.list.add(vocals);

		var hardInst:Bool = (ClientPrefs.aDifficulty.toLowerCase() == 'hard');
		if (hardInst && !Paths.instExist(PlayState.SONG.song, '-hard')) {
            trace('no hard song found ' + '${Paths.formatToSongPath(PlayState.SONG.song)}/Inst-hard');
			hardInst = false;
        } else {
			trace('hard song inst');
		}
		
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song, hardInst ? '-hard' : '')));

		notes = new FlxTypedGroup<Note>();
		add(notes);
		add(grpNoteHoldSplashes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var songName:String = Paths.formatToSongPath(SONG.song);
		var file:String = Paths.json(songName + '/events');
		#if MODS_ALLOWED
		if (FileSystem.exists(Paths.modsJson(songName + '/events')) || FileSystem.exists(file)) {
		#else
		if (OpenFlAssets.exists(file)) {
		#end
			var eventsData:Array<Dynamic> = Song.loadFromJson('events', songName).events;
			for (event in eventsData) //Event Notes
			{
				for (i in 0...event[1].length)
				{
					var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
					var subEvent:EventNote = {
						strumTime: newEventNote[0] + ClientPrefs.noteOffset,
						event: newEventNote[1],
						value1: newEventNote[2],
						value2: newEventNote[3]
					};
					subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
					eventNotes.push(subEvent);
					eventPushed(subEvent);
				}
			}
		}

		VOCALS = vocalsSetup();

		#if MODCHARTS
		if (useModchart)
			for(i in 0...4)
				notesToSpawn[i] = [];
		#end
		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.mustPress = gottaHitNote;
				swagNote.sustainLength = songNotes[2];
				swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
				swagNote.noteType = songNotes[3];
				if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts
				swagNote.scrollFactor.set();

				var repeatCount:Int = 0;
				var singData:Int = -1;
				for (item in VOCALS) {
					if (item.time >= (daStrumTime)) {
						singData = item.data%4;
						break;
					}
				}
				swagNote.singData = singData;
				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);
				#if MODCHARTS
				if (useModchart) {
					if(notesToSpawn[swagNote.noteData]==null)
						notesToSpawn[swagNote.noteData] = [];

					notesToSpawn[swagNote.noteData].push(swagNote);
				}
				#end

				var floorSus:Int = Math.floor(susLength);
				if(floorSus > 0) {
					for (susNote in 0...floorSus+1)
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2)), daNoteData, oldNote, true);
						sustainNote.mustPress = gottaHitNote;
						sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
						sustainNote.noteType = swagNote.noteType;
						sustainNote.scrollFactor.set();
						swagNote.tail.push(sustainNote);
						sustainNote.parent = swagNote;
						sustainNote.singData = singData;
						unspawnNotes.push(sustainNote);
						#if MODCHARTS
						if (useModchart)
							notesToSpawn[swagNote.noteData].push(sustainNote);
						#end

						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
						else if(ClientPrefs.middleScroll)
						{
							sustainNote.x += 310;
							if(daNoteData > 1) //Up and Right
							{
								sustainNote.x += FlxG.width / 2 + 25;
							}
						}
					}
				}

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else if(ClientPrefs.middleScroll)
				{
					swagNote.x += 310;
					if(daNoteData > 1) //Up and Right
					{
						swagNote.x += FlxG.width / 2 + 25;
					}
				}

				if(!noteTypeMap.exists(swagNote.noteType)) {
					noteTypeMap.set(swagNote.noteType, true);
				}
			}
			daBeats += 1;
		}
		for (event in songData.events) //Event Notes
		{
			for (i in 0...event[1].length)
			{
				var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
				var subEvent:EventNote = {
					strumTime: newEventNote[0] + ClientPrefs.noteOffset,
					event: newEventNote[1],
					value1: newEventNote[2],
					value2: newEventNote[3]
				};
				subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
				eventNotes.push(subEvent);
				eventPushed(subEvent);
			}
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		if(eventNotes.length > 1) { //No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}
		checkEventNote();
		generatedMusic = true;
	}

	function eventPushed(event:EventNote) {
		switch(event.event) {
			case 'Change Character':
				var charType:Int = 0;
				switch(event.value1.toLowerCase()) {
					case 'gf' | 'girlfriend' | '1':
						charType = 2;
					case 'dad' | 'opponent' | '0':
						charType = 1;
					default:
						charType = Std.parseInt(event.value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event.value2;
				addCharacterToList(newCharacter, charType);

			case 'Dadbattle Spotlight':
				dadbattleBlack = new BGSprite(null, -800, -400, 0, 0);
				dadbattleBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				dadbattleBlack.alpha = 0.25;
				dadbattleBlack.visible = false;
				add(dadbattleBlack);

				dadbattleLight = new BGSprite('stage/spotlight', 400, -400);
				dadbattleLight.alpha = 0.375;
				dadbattleLight.blend = ADD;
				dadbattleLight.visible = false;

				dadbattleSmokes.alpha = 0.7;
				dadbattleSmokes.blend = ADD;
				dadbattleSmokes.visible = false;
				add(dadbattleLight);
				add(dadbattleSmokes);

				var offsetX = 200;
				var smoke:BGSprite = new BGSprite('stage/smoke', -1550 + offsetX, 660 + FlxG.random.float(-20, 20), 1.2, 1.05);
				smoke.setGraphicSize(Std.int(smoke.width * FlxG.random.float(1.1, 1.22)));
				smoke.updateHitbox();
				smoke.velocity.x = FlxG.random.float(15, 22);
				smoke.active = true;
				dadbattleSmokes.add(smoke);
				var smoke:BGSprite = new BGSprite('stage/smoke', 1550 + offsetX, 660 + FlxG.random.float(-20, 20), 1.2, 1.05);
				smoke.setGraphicSize(Std.int(smoke.width * FlxG.random.float(1.1, 1.22)));
				smoke.updateHitbox();
				smoke.velocity.x = FlxG.random.float(-15, -22);
				smoke.active = true;
				smoke.flipX = true;
				dadbattleSmokes.add(smoke);
		}

		if(!eventPushedMap.exists(event.event)) {
			eventPushedMap.set(event.event, true);
		}
	}

	function eventNoteEarlyTrigger(event:EventNote):Float {
		var returnedValue:Float = callOnLuas('eventEarlyTrigger', [event.event]);
		if(returnedValue != 0) {
			return returnedValue;
		}

		switch(event.event) {
			case 'Kill Henchmen': //Better timing so that the kill sound matches the beat intended
				return 280; //Plays 280ms before the actual position
		}
		return 0;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	#if MODCHARTS
	function sortByOrderNote(wat:Int, Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.zIndex, Obj2.zIndex);
	}

	function sortByOrderStrumNote(wat:Int, Obj1:StrumNote, Obj2:StrumNote):Int
	{
		return FlxSort.byValues(FlxSort.DESCENDING, Obj1.zIndex, Obj2.zIndex);
	}
	#end

	function sortByTime(Obj1:EventNote, Obj2:EventNote):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public var skipArrowStartTween:Bool = false; //for lua
	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var targetAlpha:Float = 1;
			if (player < 1)
			{
				if(!ClientPrefs.opponentStrums) targetAlpha = 0;
				else if(ClientPrefs.middleScroll) targetAlpha = 0.35;
			}

			var babyArrow:StrumNote = new StrumNote(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i, player);
			babyArrow.downScroll = ClientPrefs.downScroll;
			if (!isStoryMode && !skipArrowStartTween)
			{
				//babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {/*y: babyArrow.y + 10,*/ alpha: targetAlpha}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			else
			{
				babyArrow.alpha = targetAlpha;
			}

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				if(ClientPrefs.middleScroll)
				{
					babyArrow.x += 310;
					if(i > 1) { //Up and Right
						babyArrow.x += FlxG.width / 2 + 25;
					}
				}
				opponentStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);
			babyArrow.postAddedToGroup();
			babyArrow.defaultPosition = babyArrow.getPosition();
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				if (separateVocals) 
					opponentVocals.pause();
				vocals.pause();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = false;
			if (songSpeedTween != null)
				songSpeedTween.active = false;

			if (discordChannels != null) {
				if (discordChannels.beatTween != null)
					discordChannels.beatTween.active = false;
				if (discordChannels.scrollTween != null)
					discordChannels.scrollTween.active = false;
			}

			if (discordMembers != null) {
				if (discordMembers.beatTween != null)
					discordMembers.beatTween.active = false;
				if (discordMembers.scrollTween != null)
					discordMembers.scrollTween.active = false;
			}
			
			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = false;
				}
			}

			for (tween in modchartTweens) {
				tween.active = false;
			}
			for (timer in modchartTimers) {
				timer.active = false;
			}

			if (comboSprTween != null) comboSprTween.active = false;

			if (introTimer != null) introTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = true;
			if (songSpeedTween != null)
				songSpeedTween.active = true;

			if (discordChannels != null) {
				if (discordChannels.beatTween != null)
					discordChannels.beatTween.active = true;
				if (discordChannels.scrollTween != null)
					discordChannels.scrollTween.active = true;
			}

			if (discordMembers != null) {
				if (discordMembers.beatTween != null)
					discordMembers.beatTween.active = true;
				if (discordMembers.scrollTween != null)
					discordMembers.scrollTween.active = true;
			}

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = true;
				}
			}

			for (tween in modchartTweens) {
				tween.active = true;
			}
			for (timer in modchartTimers) {
				timer.active = true;
			}

			if (introTimer != null) introTimer.active = true;

			if (comboSprTween != null) comboSprTween.active = true;

			paused = false;
			callOnLuas('onResume', []);

			#if desktop
			if (startTimer != null && startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
		}
		callOnLuas('onFocus', []);
		#end
		

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		}
		callOnLuas('onFocusLost', []);
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if(finishTimer != null) return;

		if (separateVocals) 
			opponentVocals.pause();
		vocals.pause();

		FlxG.sound.music.play();
		FlxG.sound.music.pitch = playbackRate;
		Conductor.songPosition = FlxG.sound.music.time;
		if (Conductor.songPosition <= vocals.length)
		{
			vocals.time = Conductor.songPosition;
			vocals.pitch = playbackRate;
			if (separateVocals) {
				opponentVocals.time = vocals.time;
				opponentVocals.pitch = vocals.pitch;
			}
		}
		if (separateVocals) 
			opponentVocals.play();
		vocals.play();
	}

	public var paused:Bool = false;
	public var canReset:Bool = true;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var limoSpeed:Float = 0;

	override public function update(elapsed:Float)
	{
		callOnLuas('onUpdate', [elapsed]);

		//songUpdateEvent();

		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed * playbackRate, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			if(!startingSong && !endingSong && boyfriend.animation.curAnim != null && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
			if (lerpShakeBar != 0) {
				lerpShakeBar = FlxMath.lerp(lerpShakeBar, 0, elapsed*8);
				var shakeRandom:Float = (lerpShakeBar * (FlxG.random.bool(50) ? 1 : -1));
				healthBarOverlay.offset.y = barOffset[2][1] + shakeRandom;  
				healthBar.offset.y = barOffset[1][1] + shakeRandom;  
				healthBarBG.offset.y = barOffset[0][1] + shakeRandom;  
			}
		}

		if (!haveUsePractice && practiceMode) {
			haveUsePractice = true;
			trace('use practice');
		}
		if (!haveUseBotplay && cpuControlled) {
			haveUseBotplay = true;
			trace('use botplay');
		}
		

		super.update(elapsed);

		setOnLuas('curDecStep', curDecStep);
		setOnLuas('curDecBeat', curDecBeat);
		songScoreLerp = FlxMath.lerp(songScoreLerp, songScore, CoolUtil.boundTo(elapsed * 12 * playbackRate, 0, 1));
		scoreTxt.text = scorePrefix + Std.int(Math.ceil(songScoreLerp));

		if(botplayTxt.visible) {
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}

		if (!inCutscene && controls.PAUSE && startedCountdown && canPause)
		{
			var ret:Dynamic = callOnLuas('onPause', [], false);
			if(ret != FunkinLua.Function_Stop) {
				openPauseMenu();
			}
		}
		if (inCutscene) {
			if (videoCutscene != null && controls.PAUSE) {
				videoCutscene.destroy();
				startAndEnd();
			}
		}

		if (FlxG.keys.anyJustPressed(debugKeysChart) && !endingSong && !inCutscene #if !debug && ClientPrefs.developer #end)
		{
			openChartEditor();
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (Conductor.stepCrochet/10 * elapsed) / Math.pow(iconSpeed, 0.75), 0, 1));
		iconP1.scale.set(mult, mult);
		if (hudStyle != 'discord')
			if (healthBar.flipX) 
				iconP1.origin.set(75-40, 110);
			else
				iconP1.origin.set(75+40, 110);
		//iconP1.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (Conductor.stepCrochet/10 * elapsed) / Math.pow(iconSpeed, 0.75), 0, 1));
		iconP2.scale.set(mult, mult);
		if (hudStyle != 'discord')
			if (healthBar.flipX) 
				iconP1.origin.set(75+40, 110);
			else
				iconP1.origin.set(75-40, 110);
		//iconP2.updateHitbox();

		var iconOffset:Int = 26;

		health = FlxMath.bound(health, 0, 2);
		lerpHealth = FlxMath.lerp(lerpHealth, health, FlxMath.bound(elapsed*8, 0, 1));
		

		if (healthBar.flipX) {
			iconP2.x = healthBar.x + (healthBar.width * ((lerpHealth/2))) + (150 * iconP1.scale.x - 150) / 2 - iconOffset + 5 + iconP1.sprOffsetX;
			iconP1.x = healthBar.x + (healthBar.width * ((lerpHealth/2))) - (150 * iconP2.scale.x) / 2 - iconOffset * 2 - 5 + iconP1.sprOffsetX;
		} else {
			iconP1.x = healthBar.x + (healthBar.width * (1-(lerpHealth/2))) + (150 * iconP1.scale.x - 150) / 2 - iconOffset + 5 + iconP1.sprOffsetX;
			iconP2.x = healthBar.x + (healthBar.width * (1-(lerpHealth/2))) - (150 * iconP2.scale.x) / 2 - iconOffset * 2 - 5 + iconP1.sprOffsetX;
		}
		

		if (health <= 0.4) {//! LOW HEALTH WARNING
			healthBar.colorTransform.redOffset = Math.abs(Math.sin(Conductor.songPosition/200) * 250);
			healthBar.colorTransform.greenOffset = -Math.abs(Math.sin(Conductor.songPosition/200) * 150);
			healthBar.colorTransform.blueOffset = -Math.abs(Math.sin(Conductor.songPosition/200) * 150);
		} else {
			healthBar.colorTransform.redOffset = 0;
			healthBar.colorTransform.greenOffset = 0;
			healthBar.colorTransform.blueOffset = 0;
		}

		if (health*50 < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (health*50 > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		if (FlxG.keys.anyJustPressed(debugKeysCharacter) && !endingSong && !inCutscene #if !debug && ClientPrefs.developer #end) {
			persistentUpdate = false;
			paused = true;
			cancelMusicFadeTween();
			MusicBeatState.switchState(new CharacterEditorState(SONG.player2));
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000 * playbackRate;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000 * playbackRate;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if(updateTime) {
					var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var songCalc:Float = (songLength - curTime);
					if(ClientPrefs.timeBarType == 'Time Elapsed') songCalc = curTime;

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					if(ClientPrefs.timeBarType != 'Song Name')
						timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				}
				if (Conductor.songPosition >= (songLength - 500)) {
					trace('no way ammar code fix end song');
					finishSong();
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay * playbackRate), 0, 1));
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay * playbackRate), 0, 1));
			//new
			// camBack.zoom = FlxMath.lerp(1, camBack.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay * playbackRate), 0, 1));
			// camFront.zoom = FlxMath.lerp(1, camFront.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay * playbackRate), 0, 1));
		}

		if (FlxG.debugger.visible) {
			FlxG.watch.addQuick("Section", curSection);
			FlxG.watch.addQuick("Beat", curBeat);
			FlxG.watch.addQuick("Step", curStep);
			FlxG.watch.addQuick("Notes Amount", notes.length);
		}

		// RESET = Quick Game Over Screen
		if (!ClientPrefs.noReset && controls.RESET && canReset && !inCutscene && startedCountdown && !endingSong)
		{
			health = 0;
			trace("RESET = True");
		}
		doDeathCheck();
		#if MODCHARTS
		if (useModchart) {
			modManager.updateTimeline(curDecStep);
			modManager.update(elapsed);
		}
		#end

		if (unspawnNotes[0] != null)
		{
			var time:Float = spawnTime;
			/*if(songSpeed < 1) */time /= songSpeed;
			/*if(unspawnNotes[0].multSpeed < 1) */time /= unspawnNotes[0].multSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);
				dunceNote.spawned=true;
				callOnLuas('onSpawnNote', [notes.members.indexOf(dunceNote), dunceNote.noteData, dunceNote.noteType, dunceNote.isSustainNote]);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		#if MODCHARTS
		if (useModchart) {
			opponentStrums.forEachAlive(function(strum:StrumNote)
			{
				var pos = modManager.getPos(0, 0, 0, curDecBeat, strum.noteData, 1, strum, [], strum.vec3Cache);
				modManager.updateObject(curDecBeat, strum, pos, 1);
				strum.x = pos.x;
				strum.y = pos.y;
				strum.z = pos.z;
			});
		
			playerStrums.forEachAlive(function(strum:StrumNote)
			{
				var pos = modManager.getPos(0, 0, 0, curDecBeat, strum.noteData, 0, strum, [], strum.vec3Cache);
				modManager.updateObject(curDecBeat, strum, pos, 0);
				strum.x = pos.x;
				strum.y = pos.y;
				strum.z = pos.z;
			});

			strumLineNotes.sort(sortByOrderStrumNote);
		}
		#end

		if (generatedMusic && startedCountdown)
		{
			if (!inCutscene) {
				if(!cpuControlled) {
					keyShit();
				} else if(boyfriend.animation.curAnim != null && boyfriend.holdTimer > Conductor.stepCrochet * (0.0011 / FlxG.sound.music.pitch) * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss')) {
					boyfriend.dance();
					//boyfriend.animation.curAnim.finish();
				}
			}

			var isModchart:Bool = false;
			#if MODCHARTS
			if (useModchart)
				isModchart = true;
			#end


			var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
			#if MODCHARTS if (isModchart) notes.sort(sortByOrderNote); #end
			notes.forEachAlive(function(daNote:Note)
				{
					var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
					if(!daNote.mustPress) strumGroup = opponentStrums;
					
					var strumX:Float = strumGroup.members[daNote.noteData].x;
					var strumY:Float = strumGroup.members[daNote.noteData].y;
					var strumAngle:Float = strumGroup.members[daNote.noteData].angle;
					var strumDirection:Float = strumGroup.members[daNote.noteData].direction;
					var strumAlpha:Float = strumGroup.members[daNote.noteData].alpha;
					var strumScroll:Bool = strumGroup.members[daNote.noteData].downScroll;
					
					strumX += daNote.offsetX;
					strumY += daNote.offsetY;
					strumAngle += daNote.offsetAngle;
					strumAlpha *= daNote.multAlpha;
					
					#if MODCHARTS
					if (isModchart) {
						var allSpeed:Float = songSpeed * daNote.multSpeed;
						var pN:Int = daNote.mustPress ? 0 : 1;
						var pos = modManager.getPos(daNote.strumTime, modManager.getVisPos(Conductor.songPosition, daNote.strumTime, allSpeed),
							daNote.strumTime - Conductor.songPosition, curDecBeat, daNote.noteData, pN, daNote, [], daNote.vec3Cache);

						modManager.updateObject(curDecBeat, daNote, pos, pN);
						pos.x += daNote.offsetX;
						pos.y += daNote.offsetY;
						daNote.x = pos.x;
						daNote.y = pos.y;
						daNote.z = pos.z;
						daNote.alpha = strumAlpha;
						if (daNote.isSustainNote)
						{
							var futureSongPos = Conductor.songPosition + 75;
							var diff = daNote.strumTime - futureSongPos;
							var vDiff = modManager.getVisPos(futureSongPos, daNote.strumTime, allSpeed);

							var nextPos = modManager.getPos(daNote.strumTime, vDiff, diff, Conductor.getStep(futureSongPos) / 4, daNote.noteData, pN, daNote, [],
								daNote.vec3Cache);
							nextPos.x += daNote.offsetX;
							nextPos.y += daNote.offsetY;
							var diffX = (nextPos.x - pos.x);
							var diffY = (nextPos.y - pos.y);
							var rad = Math.atan2(diffY, diffX);
							var deg = rad * (180 / Math.PI);
							if (deg != 0)
								daNote.mAngle = (deg + 90);
							else
								daNote.mAngle = 0;
						}
					} else { #end
						daNote.distance = 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed * daNote.multSpeed;
						var distance:Float = daNote.distance * (strumScroll ? 1 : -1);

						var angleDir = strumDirection * Math.PI / 180;
						if (daNote.copyAngle)
							daNote.angle = -strumDirection + 90 + strumAngle;

						if(daNote.copyAlpha)
							daNote.alpha = strumAlpha;

						if(daNote.copyX)
							daNote.x = strumX + Math.cos(angleDir) * distance;

						if(daNote.copyY)
						{
							daNote.y = strumY + Math.sin(angleDir) * distance;

							//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
							if(strumScroll && daNote.isSustainNote)
							{
								if (daNote.animation.curAnim.name.endsWith('end')) {
									daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * songSpeed + (46 * (songSpeed - 1));
									daNote.y -= 46 * (1 - (fakeCrochet / 600)) * songSpeed;
									if(PlayState.isPixelStage) {
										daNote.y += 8 + (6 - daNote.originalHeightForCalcs) * PlayState.daPixelZoom;
									} else {
										daNote.y -= 19;
									}
								}
								daNote.y += (Note.swagWidth / 2) - (60.5 * (songSpeed - 1));
								daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (songSpeed - 1);
							}
						}
					#if MODCHARTS } #end

					if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
					{
						opponentNoteHit(daNote);
					}

					if(!daNote.blockHit && daNote.mustPress && cpuControlled && daNote.canBeHit) {
						if(daNote.isSustainNote) {
							if(daNote.canBeHit) {
								goodNoteHit(daNote);
								if (onHoldSplash[daNote.noteData] != null) {
									onHoldSplash[daNote.noteData].setPos(playerStrums.members[daNote.noteData].x, playerStrums.members[daNote.noteData].y);
									if (daNote.animation.curAnim.name.endsWith('holdend')) {
										var holdSplash:NoteHoldSplash = onHoldSplash[daNote.noteData];
										onHoldSplash[daNote.noteData].alpha = 1;
										holdSplash.endHold(true);
										onHoldSplash[daNote.noteData] = null;
									}
								}
							}
						} else if(daNote.strumTime <= Conductor.songPosition || daNote.isSustainNote) {
							goodNoteHit(daNote);
						}
					}

					if (!isModchart) {
						var center:Float = strumY + Note.swagWidth / 2;
						if(strumGroup.members[daNote.noteData].sustainReduce && daNote.isSustainNote && (daNote.mustPress || !daNote.ignoreNote) &&
							(!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
						{
							if (strumScroll)
							{
								if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center)
								{
									var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
									swagRect.height = (center - daNote.y) / daNote.scale.y;
									swagRect.y = daNote.frameHeight - swagRect.height;

									daNote.clipRect = swagRect;
								}
							}
							else
							{
								if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
								{
									var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
									swagRect.y = (center - daNote.y) / daNote.scale.y;
									swagRect.height -= swagRect.y;

									daNote.clipRect = swagRect;
								}
							}
						}
					}

					#if MODCHARTS
					if (isModchart) {
						if(daNote.garbage){
							daNote.active = false;
							daNote.visible = false;
		
							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}else{ 
							if (Conductor.songPosition > noteKillOffset + daNote.strumTime && daNote.active)
							{
								if (daNote.mustPress && !cpuControlled && !daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit))
								{
									noteMiss(daNote);
								}
		
								daNote.active = false;
								daNote.visible = false;
		
								daNote.kill();
								notes.remove(daNote, true);
								daNote.destroy();
							}
						} 
					} else { #end
						// Kill extremely late notes and cause misses
						if (Conductor.songPosition > noteKillOffset + daNote.strumTime)
						{
							if (daNote.mustPress && !cpuControlled &&!daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit)) {
								noteMiss(daNote);
							}

							daNote.active = false;
							daNote.visible = false;

							daNote.kill();
							notes.remove(daNote, true);
							daNote.destroy();
						}
					#if MODCHARTS } #end
				});
			
		}
		checkEventNote();

		#if debug
		if(!endingSong && !startingSong) {
			if (FlxG.keys.justPressed.ONE) {
				KillNotes();
				FlxG.sound.music.onComplete();
			}
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				setSongTime(Conductor.songPosition + 10000);
				clearNotesBefore(Conductor.songPosition);
			}
		}
		#end

		setOnLuas('cameraX', camFollowPos.x);
		setOnLuas('cameraY', camFollowPos.y);
		setOnLuas('botPlay', cpuControlled);
		callOnLuas('onUpdatePost', [elapsed]);
	}

	function openPauseMenu()
	{
		persistentUpdate = false;
		persistentDraw = true;
		paused = true;

		if(FlxG.sound.music != null) {
			FlxG.sound.music.pause();
			if (separateVocals)
				opponentVocals.pause();
			vocals.pause();
		}
		openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

		#if desktop
		DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		#end
	}

	function openChartEditor()
	{
		persistentUpdate = false;
		paused = true;
		cancelMusicFadeTween();
		MusicBeatState.switchState(new ChartingState());
		chartingMode = true;

		#if desktop
		DiscordClient.changePresence("Chart Editor", null, null, true);
		#end
	}

	public var isDead:Bool = false; //Don't mess with this on Lua!!!
	function doDeathCheck(?skipHealthCheck:Bool = false) {
		if (((skipHealthCheck && instakillOnMiss) || health <= 0) && !practiceMode && !isDead)
		{
			var ret:Dynamic = callOnLuas('onGameOver', [], false);
			if(ret != FunkinLua.Function_Stop) {
				boyfriend.stunned = true;
				deathCounter++;

				paused = true;

				if (separateVocals)
					opponentVocals.stop();
				vocals.stop();
				FlxG.sound.music.stop();

				persistentUpdate = false;
				persistentDraw = false;
				for (tween in modchartTweens) {
					tween.active = true;
				}
				for (timer in modchartTimers) {
					timer.active = true;
				}
				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x - boyfriend.positionArray[0], boyfriend.getScreenPosition().y - boyfriend.positionArray[1], camFollowPos.x, camFollowPos.y));

				// MusicBeatState.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
				isDead = true;
				return true;
			}
		}
		return false;
	}

	public function checkEventNote() {
		while(eventNotes.length > 0) {
			var leStrumTime:Float = eventNotes[0].strumTime;
			if(Conductor.songPosition < leStrumTime) {
				break;
			}

			var value1:String = '';
			if(eventNotes[0].value1 != null)
				value1 = eventNotes[0].value1;

			var value2:String = '';
			if(eventNotes[0].value2 != null)
				value2 = eventNotes[0].value2;

			triggerEventNote(eventNotes[0].event, value1, value2);
			eventNotes.shift();
		}
	}

	public function getControl(key:String) {
		var pressed:Bool = Reflect.getProperty(controls, key);
		//trace('Control result: ' + pressed);
		return pressed;
	}

	public function triggerEventNote(eventName:String, value1:String, value2:String) {
		switch(eventName) {
			case 'Dadbattle Spotlight':
				var val:Null<Int> = Std.parseInt(value1);
				if(val == null) val = 0;

				switch(Std.parseInt(value1))
				{
					case 1, 2, 3: //enable and target dad
						if(val == 1) //enable
						{
							dadbattleBlack.visible = true;
							dadbattleLight.visible = true;
							dadbattleSmokes.visible = true;
							defaultCamZoom += 0.12;
						}

						var who:Character = dad;
						if(val > 2) who = boyfriend;
						//2 only targets dad
						dadbattleLight.alpha = 0;
						new FlxTimer().start(0.12, function(tmr:FlxTimer) {
							dadbattleLight.alpha = 0.375;
						});
						dadbattleLight.setPosition(who.getGraphicMidpoint().x - dadbattleLight.width / 2, who.y + who.height - dadbattleLight.height + 50);

					default:
						dadbattleBlack.visible = false;
						dadbattleLight.visible = false;
						defaultCamZoom -= 0.12;
						FlxTween.tween(dadbattleSmokes, {alpha: 0}, 1, {onComplete: function(twn:FlxTween)
						{
							dadbattleSmokes.visible = false;
						}});
				}

			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				var time:Float = Std.parseFloat(value2);
				if(Math.isNaN(time) || time <= 0) time = 0.6;

				if(value != 0) {
					if(dad.curCharacter.startsWith('gf')) { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					} else if (gf != null) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = time;
					}
				}
				if(value != 1) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = time;
				}

			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if(Math.isNaN(value) || value < 1) value = 1;
				gfSpeed = value;

			case 'Add Camera Zoom':
				if(ClientPrefs.camZooms && FlxG.camera.zoom < 1.35) {
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(camZoom)) camZoom = 0.015;
					if(Math.isNaN(hudZoom)) hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;

					var frontZoom:Float = Std.parseFloat(value2);
					var backZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(frontZoom)) frontZoom = 0.02;
					if(Math.isNaN(backZoom)) backZoom = 0.04;

					// camFront.zoom += frontZoom;
					// camBack.zoom += backZoom;
				}

			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;

						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.playAnim(value1, true);
					char.specialAnim = true;
				}

			case 'Camera Follow Pos':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 0;
				if(Math.isNaN(val2)) val2 = 0;

				isCameraOnForcedPos = false;
				if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
					camFollow.x = val1;
					camFollow.y = val2;
					isCameraOnForcedPos = true;
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase().trim()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
				}

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = 0;
					var intensity:Float = 0;
					if(split[0] != null) duration = Std.parseFloat(split[0].trim());
					if(split[1] != null) intensity = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}

			case 'Change Character':
				var charType:Int = 0;
				switch(value1.toLowerCase().trim()) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend.alpha = 0.00001;
							boyfriend = boyfriendMap.get(value2);
							boyfriend.alpha = lastAlpha;
							iconP1.changeIcon(boyfriend.healthIcon);
						}
						setOnLuas('boyfriendName', boyfriend.curCharacter);

					case 1:
						if(dad.curCharacter != value2) {
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							var lastAlpha:Float = dad.alpha;
							dad.alpha = 0.00001;
							dad = dadMap.get(value2);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf && gf != null) {
									gf.visible = true;
								}
							} else if(gf != null) {
								gf.visible = false;
							}
							dad.alpha = lastAlpha;
							iconP2.changeIcon(dad.healthIcon);
						}
						setOnLuas('dadName', dad.curCharacter);

					case 2:
						if(gf != null)
						{
							if(gf.curCharacter != value2)
							{
								if(!gfMap.exists(value2))
								{
									addCharacterToList(value2, charType);
								}

								var lastAlpha:Float = gf.alpha;
								gf.alpha = 0.00001;
								gf = gfMap.get(value2);
								gf.alpha = lastAlpha;
							}
							setOnLuas('gfName', gf.curCharacter);
						}
				}
				reloadHealthBarColors();

			case 'Change Scroll Speed':
				if (songSpeedType == "constant")
					return;
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 1;
				if(Math.isNaN(val2)) val2 = 0;

				var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * val1;

				if(val2 <= 0)
				{
					songSpeed = newValue;
				}
				else
				{
					songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, val2, {ease: FlxEase.linear, onComplete:
						function (twn:FlxTween)
						{
							songSpeedTween = null;
						}
					});
				}

			case 'Set Property':
				var killMe:Array<String> = value1.split('.');
				if(killMe.length > 1) {
					FunkinLua.setVarInArray(FunkinLua.getPropertyLoopThingWhatever(killMe, true, true), killMe[killMe.length-1], value2);
				} else {
					FunkinLua.setVarInArray(this, value1, value2);
				}
		
			case 'Remove Message':
				var val:Null<Int> = Std.parseInt(value1);
				if(val == null) val = 0;
				//0 = BF, 1 = OPPONENT
				if (val == 1)
					if (discordOpponent != null) discordOpponent.deleteMessage();
				else 
					if (discordPlayer != null) discordPlayer.deleteMessage();
		
		}
		callOnLuas('onEvent', [eventName, value1, value2]);
	}

	function moveCameraSection():Void {
		if(SONG.notes[curSection] == null) return;

		if (gf != null && SONG.notes[curSection].gfSection)
		{
			camFollow.set(gf.getMidpoint().x, gf.getMidpoint().y);
			camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
			camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
			tweenCamIn();
			callOnLuas('onMoveCamera', ['gf']);
			return;
		}

		if (!SONG.notes[curSection].mustHitSection)
		{
			moveCamera(true);
			callOnLuas('onMoveCamera', ['dad']);
		}
		else
		{
			moveCamera(false);
			callOnLuas('onMoveCamera', ['boyfriend']);
		}
	}

	var cameraTwn:FlxTween;
	public function moveCamera(isDad:Bool)
	{
		if(isDad)
		{
			camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
			camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
			tweenCamIn();
		}
		else
		{
			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
			camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];

			if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1)
			{
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
					function (twn:FlxTween)
					{
						cameraTwn = null;
					}
				});
			}
		}

		if (discordPlayer != null)
			discordPlayer.myTurn = !isDad;

		if (discordOpponent != null)
			discordOpponent.myTurn = isDad;
	}

	function tweenCamIn() {
		if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1.3) {
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	public var doneFinishSong:Bool = false;
	public function finishSong(?ignoreNoteOffset:Bool = false):Void
	{
		//var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.
		if (doneFinishSong) return;
		doneFinishSong = true;
		trace('runningFinishSongFunction');

		updateTime = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		vocals.pause();
		if (separateVocals && opponentVocals != null) {
			opponentVocals.volume = 0;
			opponentVocals.pause();
		}
		if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
			endSong();
		} else {
			finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
				endSong();
			});
		}
	}


	public var transitioning = false;
	public function endSong():Void //! EXTREME BUG : SOMETIME SONG END DOESN'T RUN endSong()
	{
		trace("START OF THE END SONG IS HERE");
		//Should kill you if you tried to cheat
		if(!startingSong) {
			notes.forEach(function(daNote:Note) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			});
			for (daNote in unspawnNotes) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			}

			if(doDeathCheck()) {
				return;
			}
		}

		canPause = false;
		endingSong = true;
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		deathCounter = 0;
		seenCutscene = false;

		var isCheat:Bool = haveUsePractice || haveUseBotplay || healthGain > 1 || healthLoss < 1 || !ClientPrefs.getGameplaySetting('mechanics', true) || !ClientPrefs.getGameplaySetting('specialnotes', true) || !ClientPrefs.getGameplaySetting('modchart', true);
		var ret:Dynamic = callOnLuas('onEndSong', [], false);
		if(ret != FunkinLua.Function_Stop && !transitioning) {
			if (SONG.validScore && !chartingMode && !isCheat)
			{
				#if !switch
				var percent:Float = ratingPercent;
				if(Math.isNaN(percent)) percent = 0;
				Highscore.saveScore(SONG.song, storyDifficulty, songScore, percent, songMisses);

				Highscore.calculateProgress();
				#end
			}
			playbackRate = 1;

			if (chartingMode)
			{
				openChartEditor();
				return;
			}

			if(!isCheat) {
				var songName:String = Paths.formatToSongPath(SONG.song);
				if (songName == 'furry-femboy')
					Highscore.getBadge('ammarfurry');
				if (songName == 'myself' && !ClientPrefs.ghostTapping)
					Highscore.getBadge('myselfghost');
				if (songName == 'discord-annoyer' && ClientPrefs.aDifficulty.toLowerCase() == 'easy')
					Highscore.getBadge('relaxsong');
				if (songName == 'google' && ClientPrefs.aDifficulty.toLowerCase() == 'hard')
					Highscore.getBadge('darkgoogle');
				if (songName == 'twitter-argument' && ClientPrefs.aDifficulty.toLowerCase() == 'hard')
					Highscore.getBadge('twitterhard');
			} else {
				trace('cheating');
			}

			if (isStoryMode)
			{
				trace('story song ended');
				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					WeekData.loadTheFirstEnabledMod();
					FlxG.sound.playMusic(Paths.music('freakyMenu'));

					cancelMusicFadeTween();
					CustomFadeTransition.newLoading = true;
					if(FlxTransitionableState.skipNextTransIn) {
						CustomFadeTransition.nextCamera = null;
					}

					if (!isCheat) {
						trace('no Way!!1 didnt cheating');
						if (storyName.toLowerCase() == 'discord annoyer') 
							Highscore.getBadge('social');
						else if (storyName.toLowerCase() == 'hating problem') 
							Highscore.getBadge('hater');
						else if (storyName.toLowerCase() == 'debug') 
							Highscore.getBadge('ammar');
						else if (storyName.toLowerCase() == 'kaiju paradise') 
							Highscore.getBadge('furry');
					}

					
					// if ()
					if(!isCheat) {
		
						if (SONG.validScore)
							Highscore.saveWeekScore(storyName, campaignScore, storyDifficulty);
						
						//FlxG.save.data.weekCompleted = StoryMenuState.weekCompleted; //! THIS LITERALLY REMOVE SAVE DATA ON CUTE MOTE
						FlxG.save.flush();
					}
					storyName = '';
					changedDifficulty = false;
					MusicBeatState.switchState(new MainMenuStateAmmar());
				}
				else
				{
					var difficulty:String = CoolUtil.getDifficultyFilePath();

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

					if (!ClientPrefs.developer)
						antidebug.DebugSave.updateFolder(Paths.formatToSongPath(PlayState.storyPlaylist[0]));

					var winterHorrorlandNext = (Paths.formatToSongPath(SONG.song) == "eggnog");
					if (winterHorrorlandNext)
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					CustomFadeTransition.newLoading = false;
					//FlxTransitionableState.skipNextTransIn = true;
					//FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if(winterHorrorlandNext) {
						new FlxTimer().start(1.5, function(tmr:FlxTimer) {
							cancelMusicFadeTween();
							LoadingState.loadAndSwitchState(new PlayState());
						});
					} else {
						cancelMusicFadeTween();
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				WeekData.loadTheFirstEnabledMod();
				cancelMusicFadeTween();
				if(FlxTransitionableState.skipNextTransIn) {
					CustomFadeTransition.nextCamera = null;
				}
				MusicBeatState.switchState(new MainMenuStateAmmar());
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				changedDifficulty = false;
			}
			transitioning = true;
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	var achievementObj:AchievementObject = null;
	function startAchievement(achieve:String) {
		achievementObj = new AchievementObject(achieve, camOther);
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve);
	}
	function achievementEnd():Void
	{
		achievementObj = null;
		if(endingSong && !inCutscene) {
			endSong();
		}
	}
	#end

	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	public var totalPlayed:Int = 0;
	public var totalNotesHit:Float = 0.0;

	public var showCombo:Bool = false;
	public var showComboNum:Bool = false;
	public var showRating:Bool = false;

	public var ratingPosition:Array<Float> = [0, 0];
	public var comboPosition:Array<Float> = [0, 0];

	private function cachePopUpScore()
	{
		var pixelShitPart1:String = '';
		var pixelShitPart2:String = '';
		if (isPixelStage)
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		Paths.image(pixelShitPart1 + "sick" + pixelShitPart2);
		Paths.image(pixelShitPart1 + "good" + pixelShitPart2);
		Paths.image(pixelShitPart1 + "bad" + pixelShitPart2);
		Paths.image(pixelShitPart1 + "shit" + pixelShitPart2);
		Paths.image(pixelShitPart1 + "combo" + pixelShitPart2);
		
		for (i in 0...10) {
			Paths.image('numCombo/' + pixelShitPart1 + 'num' + i + pixelShitPart2);
		}
	}

	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
		//trace(noteDiff, ' ' + Math.abs(note.strumTime - Conductor.songPosition));

		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		//tryna do MS based judgment due to popular demand
		var daRating:Rating = Conductor.judgeNote(note, noteDiff / playbackRate);

		totalNotesHit += daRating.ratingMod;
		note.ratingMod = daRating.ratingMod;
		if(!note.ratingDisabled) daRating.increase();
		note.rating = daRating.name;
		score = daRating.score;
		if ((daRating.name == 'shit' || daRating.name == 'bad') && newHealthSystem) {
			health -= 0.02;
		}

		if(daRating.noteSplash && !note.noteSplashDisabled)
		{
			spawnNoteSplashOnNote(note);
		}

		if(!practiceMode && !cpuControlled) {
			songScore += score;
			if(!note.ratingDisabled)
			{
				songHits++;
				totalPlayed++;
				RecalculateRating(false);
			}
		}

		if (!cpuControlled) {
			comboSpr.alpha = 1;
			comboSpr.animation.play(daRating.name, true);

			if (comboSprTween != null) comboSprTween.cancel();
			comboSpr.y = comboSprY;
			comboSprTween = FlxTween.tween(comboSpr, {alpha: 0, y: comboSprY - (ClientPrefs.downScroll ? -10 : 10)}, 0.2, {ease: FlxEase.quadIn ,startDelay: 0.2});
		}
	}

	public var strumsBlocked:Array<Bool> = [];
	private function onKeyPress(event:KeyboardEvent = null):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		
		var mobileMode:Bool = #if MOBILE true #else false #end;
		//trace('Pressed: ' + eventKey);

		if (!cpuControlled && startedCountdown && !paused && key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || ClientPrefs.controllerMode || mobileMode))
		{
			if(!boyfriend.stunned && generatedMusic && !endingSong)
			{
				//more accurate hit time for the ratings?
				var lastTime:Float = Conductor.songPosition;
				Conductor.songPosition = FlxG.sound.music.time;

				var canMiss:Bool = !ClientPrefs.ghostTapping;

				// heavily based on my own code LOL if it aint broke dont fix it
				var pressNotes:Array<Note> = [];
				//var notesDatas:Array<Int> = [];
				var notesStopped:Bool = false;

				var sortedNotesList:Array<Note> = [];
				notes.forEachAlive(function(daNote:Note)
				{
					if (strumsBlocked[daNote.noteData] != true && daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && !daNote.blockHit)
					{
						if(daNote.noteData == key)
						{
							sortedNotesList.push(daNote);
							//notesDatas.push(daNote.noteData);
						}
						canMiss = true;
					}
				});
				sortedNotesList.sort(sortHitNotes);

				if (sortedNotesList.length > 0) {
					for (epicNote in sortedNotesList)
					{
						for (doubleNote in pressNotes) {
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
								doubleNote.kill();
								notes.remove(doubleNote, true);
								doubleNote.destroy();
							} else
								notesStopped = true;
						}

						// eee jack detection before was not super good
						if (!notesStopped) {
							goodNoteHit(epicNote);
							pressNotes.push(epicNote);
						}

					}
				}
				else{
					callOnLuas('onGhostTap', [key]);
					if (canMiss) {
						noteMissPress(key);
					}
				}

				// I dunno what you need this for but here you go
				//									- Shubs

				// Shubs, this is for the "Just the Two of Us" achievement lol
				//									- Shadow Mario
				keysPressed[key] = true;

				//more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
				Conductor.songPosition = lastTime;
			}

			var spr:StrumNote = playerStrums.members[key];
			if(strumsBlocked[key] != true && spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyPress', [key]);
		}
		//trace('pressed: ' + controlArray);
	}

	function sortHitNotes(a:Note, b:Note):Int
	{
		if (a.lowPriority && !b.lowPriority)
			return 1;
		else if (!a.lowPriority && b.lowPriority)
			return -1;

		return FlxSort.byValues(FlxSort.ASCENDING, a.strumTime, b.strumTime);
	}

	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		if(!cpuControlled && startedCountdown && !paused && key > -1)
		{
			var spr:StrumNote = playerStrums.members[key];
			if(spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyRelease', [key]);
		}
		//trace('released: ' + controlArray);
	}

	private function getKeyFromEvent(key:FlxKey):Int
	{
		if(key != NONE)
		{
			for (i in 0...keysArray.length)
			{
				for (j in 0...keysArray[i].length)
				{
					if(key == keysArray[i][j])
					{
						return i;
					}
				}
			}
		}
		return -1;
	}

	// Hold notes
	private function keyShit():Void
	{
		// HOLDING
		var parsedHoldArray:Array<Bool> = parseKeys();

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var parsedArray:Array<Bool> = parseKeys('_P');
			if(parsedArray.contains(true))
			{
				for (i in 0...parsedArray.length)
				{
					if(parsedArray[i] && strumsBlocked[i] != true)
						onKeyPress(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, -1, keysArray[i][0]));
				}
			}

		}

		#if MOBILE
		for (hitbox in mobileControls.members) {
			var noteData:Int = hitbox.noteData;
			if(hitbox.onJustPress && strumsBlocked[noteData] != true)
				onKeyPress(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, -1, keysArray[noteData][0]));
			if(hitbox.onJustRelease && strumsBlocked[noteData] != true)
				onKeyRelease(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, -1, keysArray[noteData][0]));
		}
		#end

		// FlxG.watch.addQuick('asdfa', upP);
		if (startedCountdown && !boyfriend.stunned && generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (strumsBlocked[daNote.noteData] != true && daNote.isSustainNote && parsedHoldArray[daNote.noteData] && daNote.canBeHit
				&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.blockHit) {
					goodNoteHit(daNote);
					if (onHoldSplash[daNote.noteData] != null) {
						if (daNote.animation.curAnim.name.endsWith('holdend')) {
							var holdSplash:NoteHoldSplash = onHoldSplash[daNote.noteData];
							onHoldSplash[daNote.noteData].alpha = 1;
							holdSplash.endHold(true);
							onHoldSplash[daNote.noteData] = null;
						}
					}
				}
			});


			for (i in 0...4)
				//holdSplash.setPos(playerStrums.members[daNote.noteData].x, playerStrums.members[daNote.noteData].y);
				if (onHoldSplash[i] != null && onHoldSplash[i].animation.curAnim.name == 'in'){
					if (!parsedHoldArray[i])
						onHoldSplash[i].alpha = 0;
					else 
						onHoldSplash[i].setPos(playerStrums.members[i].x, playerStrums.members[i].y);
						
				}

			if (parsedHoldArray.contains(true) && !endingSong) {
				#if ACHIEVEMENTS_ALLOWED
				var achieve:String = checkForAchievement(['oversinging']);
				if (achieve != null) {
					startAchievement(achieve);
				}
				#end
			}
			else if (boyfriend.animation.curAnim != null && boyfriend.holdTimer > Conductor.stepCrochet * (0.0011 / FlxG.sound.music.pitch) * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.dance();
				//boyfriend.animation.curAnim.finish();
			}
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode || strumsBlocked.contains(true))
		{
			var parsedArray:Array<Bool> = parseKeys('_R');
			if(parsedArray.contains(true))
			{
				for (i in 0...parsedArray.length)
				{
					if(parsedArray[i] || strumsBlocked[i] == true)
						onKeyRelease(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, -1, keysArray[i][0]));
				}
			}
		}

	}

	private function parseKeys(?suffix:String = ''):Array<Bool>
	{
		var ret:Array<Bool> = [];
		for (i in 0...controlArray.length)
		{
			ret[i] = Reflect.getProperty(controls, controlArray[i] + suffix);
		}
		#if MOBILE
		for (i in 0...controlArray.length)
			{
				if (ret[i] == false) {
					var target:HitboxControl = mobileControls.members[i];
					if (suffix == '_R') {
						ret[i] = target.onJustRelease;
					} else if (suffix == '_P') {
						ret[i] = target.onJustPress;
						trace('press');
					} else {
						ret[i] = target.onPress;
					}
				}
			}
		#end
		return ret;
	}

	function noteMiss(daNote:Note):Void { //You didn't hit the key and let it go offscreen, also used by Hurt Notes
		//Dupe note remove
		notes.forEachAlive(function(note:Note) {
			if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 1) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});
		combo = 0;
		health -= daNote.missHealth * healthLoss;
		
		if(instakillOnMiss)
		{
			vocals.volume = 0;
			doDeathCheck(true);
		}

		//For testing purposes
		//trace(daNote.missHealth);
		songMisses++;
		vocals.volume = 0;
		if(!practiceMode) songScore -= 10;
		lerpShakeBar = (2 - health) * 5; // 0 - 10

		totalPlayed++;
		RecalculateRating(true);

		var char:Character = boyfriend;
		if(daNote.gfNote) {
			char = gf;
		}

		if(char != null && !daNote.noMissAnimation && char.hasMissAnimations)
		{
			var animToPlay:String = singAnimations[Std.int(Math.abs(daNote.noteData))] + 'miss' + daNote.animSuffix;
			char.playAnim(animToPlay, true);
		}

		if (daNote.isSustainNote && !daNote.blockHit && !daNote.ignoreNote) {
			for (note in daNote.parent.tail) {
				note.blockHit = true;
				note.ignoreNote = true;
				note.colorSwap.brightness = -0.5;
			}
			if (onHoldSplash[daNote.noteData] != null) {
				var holdSplash:NoteHoldSplash = onHoldSplash[daNote.noteData];
				holdSplash.endHold(false);
				onHoldSplash[daNote.noteData] = null;
			}
		}

		callOnLuas('noteMiss', [notes.members.indexOf(daNote), daNote.noteData, daNote.noteType, daNote.isSustainNote]);
	}

	function noteMissPress(direction:Int = 1):Void //You pressed a key when there was no notes to press for this key
	{
		if(ClientPrefs.ghostTapping) return; //fuck it

		if (!boyfriend.stunned)
		{
			health -= 0.05 * healthLoss;
			if(instakillOnMiss)
			{
				vocals.volume = 0;
				doDeathCheck(true);
			}

			if (combo > 5 && gf != null && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;

			if(!practiceMode) songScore -= 10;
			if(!endingSong) {
				songMisses++;
			}
			totalPlayed++;
			RecalculateRating(true);

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			/*boyfriend.stunned = true;

			// get stunned for 1/60 of a second, makes you able to
			new FlxTimer().start(1 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});*/

			if(boyfriend.hasMissAnimations) {
				boyfriend.playAnim(singAnimations[Std.int(Math.abs(direction))] + 'miss', true);
			}
			vocals.volume = 0;
		}
		callOnLuas('noteMissPress', [direction]);
	}

	function opponentNoteHit(note:Note):Void
	{
		if (Paths.formatToSongPath(SONG.song) != 'tutorial')
			camZooming = true;

		if (discordOpponent != null)
			discordOpponent.addText(note);

		if(note.noteType == 'Hey!' && dad.animOffsets.exists('hey')) {
			dad.playAnim('hey', true);
			dad.specialAnim = true;
			dad.heyTimer = 0.6;
		} else if(!note.noAnimation) {
			var altAnim:String = note.animSuffix;

			if (SONG.notes[curSection] != null)
			{
				if (SONG.notes[curSection].altAnim && !SONG.notes[curSection].gfSection) {
					altAnim = '-alt';
				}
			}

			var char:Character = dad;
			var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))] + altAnim;
			if(note.gfNote) {
				char = gf;
			}

			if(char != null)
			{
				char.playAnim(animToPlay, true);
				char.holdTimer = 0;
			}
		}

		if (SONG.needsVoices)
			vocals.volume = 1;

		var time:Float = 0.15;
		if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
			time += 0.15;
		}
		StrumPlayAnim(true, Std.int(Math.abs(note.noteData)), time);
		note.hitByOpponent = true;

		callOnLuas('opponentNoteHit', [notes.members.indexOf(note), Math.abs(note.noteData), note.noteType, note.isSustainNote]);

		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	public var onHoldSplash:Array<NoteHoldSplash> = [null, null, null, null];
	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;

			if (ClientPrefs.hitsoundVolume > 0 && !note.hitsoundDisabled)
			{
				FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
			}

			if(note.hitCausesMiss) {
				noteMiss(note);
				if(!note.noteSplashDisabled && !note.isSustainNote) {
					spawnNoteSplashOnNote(note);
				}

				if(!note.noMissAnimation)
				{
					switch(note.noteType) {
						case 'Hurt Note': //Hurt note
							if(boyfriend.animation.getByName('hurt') != null) {
								boyfriend.playAnim('hurt', true);
								boyfriend.specialAnim = true;
							}
							FlxG.sound.play(Paths.sound('missnote'+FlxG.random.int(1, 3)), 0.3);
					}
				}

				note.wasGoodHit = true;
				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}

			if (discordPlayer != null)
				discordPlayer.addText(note);
			if (lightHUD != null && enableCoolLightNote) { 
				if (lightHUDTween != null) lightHUDTween.cancel();
				lightHUD.color = noteColor[note.noteData%4];
				lightHUD.alpha = 0.75;
				lightHUDTween = FlxTween.tween(lightHUD, {alpha: 0}, 1, {onComplete: function(tw:FlxTween){lightHUDTween = null;}});
			}

			if (!note.isSustainNote)
			{
				combo += 1;
				if(combo > 9999) combo = 9999;
				popUpScore(note);
			} else {
				if (!note.prevNote.isSustainNote)
					spawnNoteSplashOnNote(note);
			}
			health += note.hitHealth * healthGain * (newHealthSystem ? (Math.min(1, combo/10)) : 1);

			if(!note.noAnimation) {
				var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];

				if(note.gfNote)
				{
					if(gf != null)
					{
						gf.playAnim(animToPlay + note.animSuffix, true);
						gf.holdTimer = 0;
					}
				}
				else
				{
					boyfriend.playAnim(animToPlay + note.animSuffix, true);
					boyfriend.holdTimer = 0;
				}

				if(note.noteType == 'Hey!') {
					if(boyfriend.animOffsets.exists('hey')) {
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.6;
					}

					if(gf != null && gf.animOffsets.exists('cheer')) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
					}
				}
			}

			if(cpuControlled) {
				var time:Float = 0.15;
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
					time += 0.15;
				}
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)), time);
			} else {
				var spr = playerStrums.members[note.noteData];
				if(spr != null)
				{
					spr.playAnim('confirm', true);
				}
			}

			if (note.isSustainNote) { // glow
				for (daNote in note.parent.tail) {
					daNote.colorSwap.brightness = 1 + (Math.sin(FlxG.game.ticks/1000 * 18) * 0.8);
				}
			}

			note.wasGoodHit = true;
			vocals.volume = 1;

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	public function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null) {
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null):Void {
		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;

		var hue:Float = 0; var sat:Float = 0; var brt:Float = 0;
		if (data > -1 && data < ClientPrefs.arrowHSV.length)
		{
			hue = ClientPrefs.arrowHSV[data][0] / 360;
			sat = ClientPrefs.arrowHSV[data][1] / 100;
			brt = ClientPrefs.arrowHSV[data][2] / 100;
			if(note != null) {
				skin = note.noteSplashTexture;
				hue = note.noteSplashHue;
				sat = note.noteSplashSat;
				brt = note.noteSplashBrt;
			}
		}

		if (note.isSustainNote) {
			if (onHoldSplash[note.noteData] == null) {
				var holdsplash:NoteHoldSplash = grpNoteHoldSplashes.recycle(NoteHoldSplash);
				holdsplash.setup(x, y, data, skin, hue, sat, brt);
				grpNoteHoldSplashes.add(holdsplash);

				onHoldSplash[note.noteData] = holdsplash;
				}
		} else {
			var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
			splash.setupNoteSplash(x, y, data, skin, hue, sat, brt);
			grpNoteSplashes.add(splash);
		}
	}

	override function destroy() {
		for (lua in luaArray) {
			lua.call('onDestroy', []);
			lua.stop();
		}
		luaArray = [];

		#if hscript
		if(FunkinLua.hscript != null) FunkinLua.hscript = null;
		#end

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		FlxG.sound.music.pitch = 1;
		super.destroy();
	}

	public static function cancelMusicFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	var lastStepHit:Int = -1;
	override function stepHit()
	{
		super.stepHit();
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > (20 * playbackRate)
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > (20 * playbackRate)))
		{
			resyncVocals();
		}

		if(curStep == lastStepHit) {
			return;
		}

		for (i in lastStepHit+1...curStep+1) {
			callOnLuas('onStepEvent', [i]); // no miss when skip time
		}

		//songStepEvent();

		lastStepHit = curStep;
		setOnLuas('curStep', curStep);
		callOnLuas('onStepHit', []);
	}

	var lastBeatHit:Int = -1;

	override function beatHit()
	{
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			return;
		}

		if (generatedMusic)
		{
			// TODO: do this by note.z
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		// 4 = 1
		// 2 = 2
		// 0 = stop
		if (iconSpeed != 0)
		if (curBeat % (iconSpeed) == 0) {
			iconP1.scale.set(1.2, 1.2);
			iconP2.scale.set(1.2, 1.2);
		}

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (gf != null && curBeat % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
		{
			gf.dance();
		}
		if (curBeat % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
		{
			boyfriend.dance();
		}
		if (curBeat % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
		{
			dad.dance();
		}

		lastBeatHit = curBeat;

		setOnLuas('curBeat', curBeat); 
		callOnLuas('onBeatHit', []);
	}

	override function sectionHit()
	{
		super.sectionHit();

		if (SONG.notes[curSection] != null)
		{
			if (generatedMusic && !endingSong && !isCameraOnForcedPos)
			{
				moveCameraSection();
			}

			if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms)
			{
				FlxG.camera.zoom += 0.015 * camZoomingMult;
				camHUD.zoom += 0.03 * camZoomingMult;

				// camBack.zoom += 0.04 * camZoomingMult;
				// camFront.zoom += 0.02 * camZoomingMult;
			}

			if (SONG.notes[curSection].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[curSection].bpm);
				setOnLuas('curBpm', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}
			setOnLuas('mustHitSection', SONG.notes[curSection].mustHitSection);
			setOnLuas('altAnim', SONG.notes[curSection].altAnim);
			setOnLuas('gfSection', SONG.notes[curSection].gfSection);
		}
		
		setOnLuas('curSection', curSection);
		callOnLuas('onSectionHit', []);
	}

	public function callOnLuas(event:String, args:Array<Dynamic>, ignoreStops = true, exclusions:Array<String> = null):Dynamic {
		var returnVal:Dynamic = FunkinLua.Function_Continue;
		#if LUA_ALLOWED
		if(exclusions == null) exclusions = [];
		for (script in luaArray) {
			if(exclusions.contains(script.scriptName))
				continue;

			var ret:Dynamic = script.call(event, args);
			if(ret == FunkinLua.Function_StopLua && !ignoreStops)
				break;
			
			// had to do this because there is a bug in haxe where Stop != Continue doesnt work
			var bool:Bool = ret == FunkinLua.Function_Continue;
			if(!bool) {
				returnVal = cast ret;
			}
		}
		#end
		//trace(event, returnVal);
		return returnVal;
	}

	public function setOnLuas(variable:String, arg:Dynamic) {
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			luaArray[i].set(variable, arg);
		}
		#end
	}

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = opponentStrums.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	public var ratingName:String = '?';
	public var ratingPercent:Float;
	public var ratingFC:String;
	public function RecalculateRating(badHit:Bool = false) {
		setOnLuas('score', songScore);
		setOnLuas('misses', songMisses);
		setOnLuas('hits', songHits);

		var ret:Dynamic = callOnLuas('onRecalculateRating', [], false);
		if(ret != FunkinLua.Function_Stop)
		{
			if(totalPlayed < 1) //Prevent divide by 0
				ratingName = '?';
			else
			{
				// Rating Percent
				ratingPercent = Math.min(1, Math.max(0, totalNotesHit / totalPlayed));
				//trace((totalNotesHit / totalPlayed) + ', Total: ' + totalPlayed + ', notes hit: ' + totalNotesHit);

				// Rating Name
				if(ratingPercent >= 1)
				{
					ratingName = ratingStuff[ratingStuff.length-1][0]; //Uses last string
				}
				else
				{
					for (i in 0...ratingStuff.length-1)
					{
						if(ratingPercent < ratingStuff[i][1])
						{
							ratingName = ratingStuff[i][0];
							break;
						}
					}
				}
			}

			// Rating FC
			ratingFC = "";
			if (sicks > 0) ratingFC = "SFC";
			if (goods > 0) ratingFC = "GFC";
			if (bads > 0 || shits > 0) ratingFC = "FC";
			if (songMisses > 0 && songMisses < 10) ratingFC = "SDCB";
			else if (songMisses >= 10) ratingFC = "Clear";
		}
		updateScore(badHit); // score will only update after rating is calculated, if it's a badHit, it shouldn't bounce -Ghost
		setOnLuas('rating', ratingPercent);
		setOnLuas('ratingName', ratingName);
		setOnLuas('ratingFC', ratingFC);
	}

	#if ACHIEVEMENTS_ALLOWED
	private function checkForAchievement(achievesToCheck:Array<String> = null):String
	{
		if(chartingMode) return null;

		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		for (i in 0...achievesToCheck.length) {
			var achievementName:String = achievesToCheck[i];
			if(!Achievements.isAchievementUnlocked(achievementName) && !cpuControlled) {
				var unlock:Bool = false;
				switch(achievementName)
				{
					case 'week1_nomiss' | 'week2_nomiss' | 'week3_nomiss' | 'week4_nomiss' | 'week5_nomiss' | 'week6_nomiss' | 'week7_nomiss':
						if(isStoryMode && campaignMisses + songMisses < 1 && CoolUtil.difficultyString() == 'HARD' && storyPlaylist.length <= 1 && !changedDifficulty && !usedPractice)
						{
							var weekName:String = WeekData.getWeekFileName();
							switch(weekName) //I know this is a lot of duplicated code, but it's easier readable and you can add weeks with different names than the achievement tag
							{
								case 'week1':
									if(achievementName == 'week1_nomiss') unlock = true;
								case 'week2':
									if(achievementName == 'week2_nomiss') unlock = true;
								case 'week3':
									if(achievementName == 'week3_nomiss') unlock = true;
								case 'week4':
									if(achievementName == 'week4_nomiss') unlock = true;
								case 'week5':
									if(achievementName == 'week5_nomiss') unlock = true;
								case 'week6':
									if(achievementName == 'week6_nomiss') unlock = true;
								case 'week7':
									if(achievementName == 'week7_nomiss') unlock = true;
							}
						}
					case 'ur_bad':
						if(ratingPercent < 0.2 && !practiceMode) {
							unlock = true;
						}
					case 'ur_good':
						if(ratingPercent >= 1 && !usedPractice) {
							unlock = true;
						}
					case 'roadkill_enthusiast':
						if(Achievements.henchmenDeath >= 100) {
							unlock = true;
						}
					case 'oversinging':
						if(boyfriend.holdTimer >= 10 && !usedPractice) {
							unlock = true;
						}
					case 'hype':
						if(!boyfriendIdled && !usedPractice) {
							unlock = true;
						}
					case 'two_keys':
						if(!usedPractice) {
							var howManyPresses:Int = 0;
							for (j in 0...keysPressed.length) {
								if(keysPressed[j]) howManyPresses++;
							}

							if(howManyPresses <= 2) {
								unlock = true;
							}
						}
					case 'toastie':
						if(/*ClientPrefs.framerate <= 60 &&*/ ClientPrefs.lowQuality && !ClientPrefs.globalAntialiasing) {
							unlock = true;
						}
					case 'debugger':
						if(Paths.formatToSongPath(SONG.song) == 'test' && !usedPractice) {
							unlock = true;
						}
				}

				if(unlock) {
					Achievements.unlockAchievement(achievementName);
					return achievementName;
				}
			}
		}
		return null;
	}
	#end

	//shut up variables
	var beatHardSnares:Bool = false;
	var zoomMultiply:Float = 1;
	var opponentHitDistract:Bool = false;
	var shakeNote:Float = 0;
	function songStepEvent():Void {
		switch (Paths.formatToSongPath(SONG.song)) {
			case 'discord-annoyer':
				switch (curStep) {
					case 1520:
						enableCoolLightNote = true;
					case 1776:
						enableCoolLightNote = false;
				}

			if (enableCoolLightNote && curStep%4 == 0)
				triggerEventNote('Add Camera Zoom', '0.015', '0.03');

			case 'shut-up':
				switch (curStep) {
					case 128:
						beatHardSnares = true;
					case 252:
						FlxTween.tween(redOverlay, {alpha: 0.75}, Conductor.crochet/1000, {ease: FlxEase.expoIn});
					case 256:
						zoomMultiply = 1.5;
						camOther.flash(FlxColor.RED, 1.5, null, true);
					case 512:
						zoomMultiply = 1;
						beatHardSnares = false;
						redOverlay.alpha = 0;
						camOther.flash(FlxColor.WHITE, 0.75, null, true);
						//camBack.angle = 0;
						camHUD.angle = 0;
						glitchy.alpha = 0;
					case 768:
						opponentHitDistract = true;
					case 1024:
						opponentHitDistract = false;
				}
	
				
				if (beatHardSnares)
					if (curStep % 8 == 0)
						triggerEventNote('Add Camera Zoom', Std.string(0.015 * zoomMultiply), Std.string(0.03 * zoomMultiply));
					else if (curStep % 8 == 4)
						triggerEventNote('Add Camera Zoom', Std.string(-0.015 * zoomMultiply), Std.string(-0.03 * zoomMultiply));
		
				if (opponentHitDistract) {
					if (curStep % 8 == 0) {
						for (i in (0...4)) {
							var arrow:StrumNote = strumLineNotes.members[i];
							modchartTweens.set('noteComeIn$i', FlxTween.tween(arrow, {x : arrow.defaultPosition.x + 350}, Conductor.crochet/1000, {ease: FlxEase.expoIn,
								onComplete: function(twn:FlxTween) {modchartTweens.remove('noteComeIn$i');}}));
						}
					} else if (curStep % 8 == 4) { // HIT
						for (i in (0...4)) {
							var arrow:StrumNote = strumLineNotes.members[i];
							modchartTweens.set('noteComeIn$i', FlxTween.tween(arrow, {x : arrow.defaultPosition.x}, Conductor.crochet/1000, {ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween) {modchartTweens.remove('noteComeIn$i');}}));
						}
						shakeNote = 75;
						modchartTweens.set('notesShake', FlxTween.tween(this, {shakeNote: 0}, Conductor.crochet/1000*1.5, {ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween) {
								modchartTweens.remove('notesShake');
								for (i in (4...8)) {
									var arrow:StrumNote = strumLineNotes.members[i];
									arrow.setPosition(arrow.defaultPosition.x, arrow.defaultPosition.y);
								}
							}, onUpdate: function(twn:FlxTween) {
								for (i in (4...8)) {
									var arrow:StrumNote = strumLineNotes.members[i];
									arrow.setPosition(
										arrow.defaultPosition.x + FlxG.random.float(-shakeNote, shakeNote),
										arrow.defaultPosition.y + FlxG.random.float(-shakeNote, shakeNote)
									);
								}
							}}));
						camOther.flash(0x46FFE9E9, 0.2, null, true);
						// camFront.shake(0.01, Conductor.crochet/2000, null, true);
						// camBack.shake(0.012, Conductor.crochet/2000, null, true);
						camHUD.shake(0.007, Conductor.crochet/2000, null, true);

						glitchy.alpha = 0.3;
						FlxTween.tween(glitchy, {alpha: 0}, Conductor.crochet/1000, {ease: FlxEase.expoIn});
						health -= 0.075;
					}
				}
			case 'depression':
				// if (curStep == 256) {
				// 	game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("oldTvEffect").shader)]);
				// }
		}
	}

	function songUpdateEvent():Void {
		switch (Paths.formatToSongPath(SONG.song)) {
			case 'shut-up':
				if (curStep >= 256 && curStep < 512) {
					if (FlxG.random.bool(96))
						//camBack.angle = CoolUtil.continuous_sin(curDecBeat/2) * 8;
					if (FlxG.random.bool(96))
						camHUD.angle = CoolUtil.continuous_sin(curDecBeat/4) * -6;
					camHUD.shake(0.01, 0.1, null, true);
					// camBack.shake(0.015, 0.1, null, true);
					// camFront.shake(0.0075, 0.1, null, true);
					camOther.shake(0.001, 0.1, null, true);

					glitchy.alpha = FlxG.random.float(0.25, 0.5);
					if (FlxG.random.bool(5))
						glitchy.flipY = !glitchy.flipY;
					if (FlxG.random.bool(5))
						glitchy.flipX = !glitchy.flipX;
				}
		}
	}
}
