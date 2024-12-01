package;

import flixel.util.FlxSort;
import flixel.input.mouse.FlxMouseEvent;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.ui.FlxBar;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end

import flixel.util.FlxSpriteUtil;
import openfl.media.Sound;
import openfl.display.BlendMode;
import WeekData;
import Highscore;
import Song;

import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.text.FlxTypeText;
import options.OptionsState;

//import Controls;

using StringTools;

class MainMenuStateAmmar extends MusicBeatState
{

    public static var sounds:Map<String, Sound> = [
        "scroll" => Paths.sound("ammar/menu/scroll"),
        "locked" =>  Paths.sound("ammar/menu/locked"),
        "impact" => Paths.sound("ammar/menu/impact")
    ];
    var curSelected:Int = 0;
    var menuItems:FlxTypedGroup<MenuText>;
    var menuItemChecks:FlxTypedGroup<CheckSprite>;
    var menuIcons:FlxTypedGroup<MenuSprite>;
    var menuChecks:FlxTypedGroup<Checkbox>;

    var bg:FlxSprite;
    var dots:FlxBackdrop;
    var ammar:FlxSprite;
    var border:FlxSprite;
    var ammarTalkingTween:FlxTween;
    var borderTween:FlxTween;

    var songBGDesc:FlxSprite;
    var songBGDescTween:FlxTween;

    var diffBGDesc:FlxSprite;

    var songDescTxt:FlxText;

    var weeksSprites:FlxTypedGroup<StorySprite>;
    
    var weekDiscordAnnoyer:Array<StorySprite> = [];
    var weekKaijuParadise:Array<StorySprite> = [];
    var weekDebug:Array<StorySprite> = [];
    var weekHatingProblem:Array<StorySprite> = [];

    var weeks:Array<Array<StorySprite>> = [];

    var difficulty:String = "Normal"; //1
    var difficultySprite:FlxSprite; var diffSpriteTween:FlxTween; var hoverDifficulty:Bool = false;
    var difficultyLeft:FlxSprite; var diffLOffset:Float = 0; var diffLTween:FlxTween;
    var difficultyRight:FlxSprite; var diffROffset:Float = 0; var diffRTween:FlxTween;
    public static var difficultyArray:Array<String> = ['easy', 'normal', 'hard', 'insane'];
    var diffSelect:Int = 1; //normal
    var diffLock:FlxSprite; var diffLockYOffset:Float = 0; var diffLockTween:FlxTween;

    var menuColor:Map<String, FlxColor> = [
        "main" => 0xFF90db27,
        "story" => 0xFF003d0d,
        "freeplay" => 0xFFffc43d,
        "options" => 0xFFa6a6a6,
        "badge" => 0xFF6bff97
    ];

    var menuList:Array<Array<String>> = [
		['Story Mode', "Let's Begin the Story!"],
		['Freeplay', 'Play any song you like!'],
		['Badges', 'Get the Achievements and become cool!'], 
		['Options', "Change the game's mechanics."]
	];

    var optionsMode:Array<String> = [
        "Mod Options", "Engine Options"
    ];
    var optionsList:Array<Array<String>> = [
        //['Mechanics', 'Changes Notes Skins, Modcharts, health Drain and etc.', 'mechanics'],
        //['Special Notes', 'Hurt Notes, Question Notes and etc.', 'specialNotes'],
        ['Filter Curses', 'Censored Bad Words. You must turn this on!11!1!', 'filterCurses'],
        ['Reduce Shakiness', 'Reduce the screen shake Intensity. Useful for People who can easily have motion sickness', 'reduceShakiness'],
        ['Silly Bounce', 'Making The whole menu bopping to the music', 'sillybop'],
        ['Disable Promotion', 'Hide My Discord Server invite link', 'nopromotion'],
        ['Developer Mode', 'Enable developer Mode. Have access to Chart Editor, Change Scripts\' Code', 'developer'],
        ['Cute :3', '????? What is this setting? I never added this into the source code. Hmmmmmmmmmmmmmm. I wonder what is dis for...', 'cute'],
        ['Hide Unused', 'Literally Hide Unused Song in Freeplay', 'hideunused'],
        ['Erase Save Data', 'Hold To Delete Your Save Files. However, this will still keep your developer mode enable.', 'delete']
        //['Hard Mode', 'Enable HARD MODE!!1! Increase Difficulty and new mechanics. This might sound FUN', 'hardMode'],
    ];

    public static var songsList:Array<Map<String, Dynamic>> = [
        //['song' => '' ,'icon' => "", 'desc' => ""]
        ['song' => 'Discord Annoyer'   ,'icon' => ""            , 'week' => "Discord Annoyer"],
        ['song' => 'Shut Up'              ,'icon' => ""            , 'week' => "Discord Annoyer"],
        ['song' => 'Depression'          ,'icon' => ""            , 'week' => "Discord Annoyer"],
        ['song' => 'Moderator'           ,'icon' => ""            , 'week' => "Discord Annoyer", 'unlocked' => ['Discord Annoyer', 'Shut Up', 'Depression', 'Moderator']],

        ['song' => 'Hate Comment'        ,'icon' => ""           , 'week' => "Hating Problem"],
        ['song' => 'Twitter Argument'   ,'icon' => ""            , 'week' => "Hating Problem"],
        ['song' => 'Google'                ,'icon' => ""            , 'week' => "Hating Problem"],
        ['song' => 'Big Problem'          ,'icon' => ""            , 'week' => "Hating Problem", 'unlocked' => ['Big Problem']],

        //['song' => 'Chaos'                 ,'icon' => ""           , 'week' => "Practice"],
        //['song' => 'Owen Was Her'        ,'icon' => ""           , 'week' => "Practice"],
        //['song' => 'Death By Notes'      ,'icon' => ""           , 'week' => "Practice"],

        ['song' => 'No Debug'             ,'icon' => ""           , 'week' => "Debug",  'unlocked' => ['No Debug'], 'hidden' => true],
        ['song' => 'Myself'                ,'icon' => ""           , 'week' => "Debug",  'unlocked' => ['Myself'], 'hidden' => true],
        
        ['song' => 'Furry Appeared'    ,'icon' => ""            , 'week' => "Kaiju Paradise",  'unlocked' => ['Furry Appeared'], 'hidden' => true],
        ['song' => 'Protogen'    ,      'icon' => ""            , 'week' => "Kaiju Paradise",  'unlocked' => ['Protogen'], 'hidden' => true],

        ['song' => 'Furry Femboy'    ,'icon' => ""            , 'week' => "Furry Femboy"],

        ['song' => 'Programming An Ammar'    ,'icon' => ""            , 'week' => "Ammar Showdown"],
        ['song' => 'Identity Crisis'    ,'icon' => ""            , 'week' => "Ammar Showdown"]
    ];
    var songsDifficulty:Map<String, Array<Int>> = [
        'Discord Annoyer'    => [1, 2, 2],
        'Shut Up'            => [3, 4, 7],
        'Depression'         => [4, 5, 6],
        'Moderator'          => [4, 5, 6],

        'Hate Comment'       => [7, 8, 8],
        'Twitter Argument'   => [7, 9, 10],
        'Google'             => [5, 6, 6],
        'Big Problem'        => [7, 8, 8],

        'Chaos'              => [0, 0, 0],
        'Owen Was Her'       => [0, 0, 0],
        'Death By Notes'     => [0, 0, 0],

        'No Debug'           => [4, 6, 6],
        'Myself'             => [8, 9, 10],

        'Furry Appeared'     => [2, 3, 4],
        'Protogen'           => [8, 9, 10],

        'Furry Femboy'       => [7, 8, 8],

        'Programming An Ammar'       => [5, 7, 9],
        'Identity Crisis'       => [5, 7, 9],
    ];

    /**
        Discord Annoyer <  Furry Appeared < Shut Up <= Moderator < Programming An Ammar < Depression < Google < No Debug < Myself < Hate Comment < Twitter Arguement < Big Problem < Protogen
        
        Discord Annoyer is the Easiest Song
        Shut Up > Discord Annoyer
        Depression > Shut Up (Slightly)
        Moderator = Shut Up (The reason is the modchart)

        Hate Comment > Depression
        Twitter Arguement > Hate Comment
        Google < Hate Comment (Slightly)
        Big Problem > Twitter Arguement

        Furry Appeared > Discord Annoyer
        Protogen > All

        No Debug > Google
        Myself > No Debug

        Programming An Ammar > Moderator
        
    **/

    var weeksList:Array<String> = ['Discord Annoyer', 'Hating Problem', 'Debug', 'Kaiju Paradise'];

    var badgesList:Array<Array<Dynamic>> = [ //Name,  Save Data, Descriptions [Before Got, After Got]
        ["Social Expert", "social", ['Complete the Discord Annoyer Week', 'Completed the Discord Annoyer Week']],
        ["Hater Beater", "hater", ['Complete the Hating Problem Week', 'Completed the Hating Problem Week']],
        ["Debug Access", "ammar", ['Have access to Debug', 'Successfully have access to debug']],
        ["Furry Conversation", "furry", ['The suspicious option', "Completed the Kaiju Paradise Week"]],
        //v4.2
        ["Unloseable", "myselfghost", ['Complete Myself without ghost tapping on Normal Difficulty', "Completed Myself without ghost tapping on Normal Difficulty"]],
        ["Relaxing Song", "relaxsong", ['Complete The Easiest Song With Easy Difficulty', "Completed The Easiest Song (Discord Annoyer) With Easy Difficulty"]],
        ["Dark Google", "darkgoogle", ['Complete Google on Hard Difficulty', "Completed Google on Hard Difficulty"]],
        ["Unbeatable User", "twitterhard", ['Complete Twitter Argument on Hard Difficulty', "Completed Twitter Argument on Hard Difficulty.\nwowwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww"]],
        ["Ammar is a Furry", "ammarfurry", ['Ammar Furry', "Completed Furry Femboy song"]]
    ];

    var curPage:String = "main";

    var difficultyChart:FlxSprite;
    var difficultyChartTween:FlxTween;
    var difficultyPoint:Int = 0;
    var difficultyPointLerp:Float = 0;
    var lastDiffPoint:Int = 0;

    private var camBG:FlxCamera;
    private var camHUD:FlxCamera;
    public var camOther:FlxCamera;
    private var bgFollow:FlxObject;
    private var hudFollow:FlxObject;

    var ammarText:FlxTypeText;
    var bgColorTween:FlxTween;

    var progressTxt:FlxText;
    var progressBar:FlxBar;
    var progressBG:AttachedSprite;

    var modifierBG:FlxSprite;
    var modifierText:FlxText;

    var selectedSomething:Bool = true;
    static public var difficultyChosen:Bool = false;

    var progress:Float = 0;

    var holdOptionTime:Float = 0;

    var locked:FlxSprite;
    var requiredText:FlxText;

    var openWithCute:Bool = false;
    var cheatText:FlxText;

    //MOBILE
    var exitButton:FlxSprite;
    var mobileButtons:FlxTypedGroup<FlxSprite>;
    var storyMobileButtons:Array<FlxSprite>;

    override function create()
    {

        #if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

        // Updating Discord Rich Presence
		#if desktop
		DiscordClient.changePresence("In the "+(ClientPrefs.cute ? 'Cute ' : '')+"Menus", null);
		#end

        Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
        WeekData.reloadWeekFiles(true);
        Highscore.calculateProgress();
        progress = FlxG.save.data.progress;
        openWithCute = FlxG.save.data.cute;

        if (ClientPrefs.cute) {
            menuColor['main'] = 0xFFF8A8F8;
            optionsList[5][1] = 'I added this!';
        }
        if (!ClientPrefs.developer) {
            //Hide Unused
            for (i in 0...optionsList.length-1) {
                if (optionsList[i][2] == 'hideunused')
                    optionsList.remove(optionsList[i]);
            }
        }
        if (FlxG.save.data.prevVersion != '4.2') { //reset scores for some song LOL 
            //Highscore.resetSong('Myself', 2);
            trace('Old Version detected');
            //FlxG.save.data.prevVersion = '4.2';
		    //FlxG.save.flush();
        }


        camBG = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camBG);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);
		FlxG.cameras.setDefaultDrawTarget(camBG, true);

        bgFollow = new FlxObject(0, 0, 1, 1);
		bgFollow.setPosition(1280/2, 720/2);
        hudFollow = new FlxObject(0, 0, 1, 1);
		hudFollow.setPosition(1280/2, 720/2);
        camBG.follow(bgFollow, LOCKON, 1);
        camHUD.follow(hudFollow, LOCKON, 1);
        CustomFadeTransition.nextCamera = camHUD;

		persistentUpdate = persistentDraw = true;

        progressBG = new AttachedSprite();
        progressBG.makeGraphic(800 + 10, 10 + 10, 0xFF000000);
		progressBG.scrollFactor.set();
		progressBG.xAdd = -5;
		progressBG.yAdd = -5;
        progressBG.camera = camHUD;
        add(progressBG);

        progressBar = new FlxBar(0, -50, LEFT_TO_RIGHT, 800, 10, null,'', 0, 1);
        progressBar.scrollFactor.set();
        progressBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
        progressBar.numDivisions = 300;
		progressBar.alpha = 1;
        progressBar.percent = 0;
        add(progressBar);
        progressBar.screenCenter(X);
        progressBar.camera = camHUD;

        progressBar.colorTransform.redMultiplier = 1;
        progressBar.colorTransform.greenMultiplier = 0;
        progressBar.colorTransform.blueMultiplier = 0;

        progressTxt = new FlxText(0, 0, 400, 'Game Progress');
        progressTxt.setFormat(Paths.font("gaposiss.ttf"), 20, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        progressTxt.borderSize = 2;
        progressTxt.scrollFactor.set();
        add(progressTxt);
        progressTxt.setPosition(progressBar.x, progressBar.y -24);
        progressTxt.camera = camHUD;

        progressBG.sprTracker = progressBar;

        if (progress <= 0) {
            progressBG.visible = false;
            progressBar.visible = false;
            progressTxt.visible = false;
        }

        transProgress(true);

        bg = new FlxSprite(-80).makeGraphic(1300, 800, 0xFFFFFFFF);
        bg.scrollFactor.set(0, 0);
		bg.screenCenter();
        bg.color = menuColor["main"];
        bg.cameras = [camBG];
		add(bg);

        dots = new FlxBackdrop(Paths.image("ammar/blackDots"), X);
        dots.velocity.x = 24;
		dots.screenCenter();
        dots.alpha = 0.25;
        dots.y = 200;
        dots.cameras = [camBG];
        dots.scrollFactor.set(1, 3.5);
		add(dots);

        ammar = new FlxSprite(1400, 227);
        ammar.frames = Paths.getSparrowAtlas('ammar/ammar'+(ClientPrefs.cute ? 'Cute' : ''));
        //
        ammar.animation.addByPrefix('idle', 'idle', 6, true);
        ammar.animation.addByPrefix('talking', 'talking', (ClientPrefs.cute ? 20 : 20), true);
		ammar.animation.play('idle');
        if (ClientPrefs.cute) ammar.setGraphicSize(Std.int(ammar.width * 0.9));
		ammar.updateHitbox();
        if (ClientPrefs.cute) {
            ammar.screenCenter();
            ammar.x += 60;
            ammar.y -= 200;
        }
        //
		ammar.scrollFactor.set(0.4, 0.4);
        ammar.alpha = (ClientPrefs.cute ? 0.7 : 0.8);
        ammar.cameras = [camBG];
		add(ammar);

        border = new FlxSprite(-700, -1);
        border.frames = Paths.getSparrowAtlas('ammar/barder');
        //
        border.animation.addByPrefix('loop', 'barder', 4, true);
		border.animation.play('loop');
		border.updateHitbox();
        //
		border.scrollFactor.set(0.8, 0.8);
        border.alpha = 0.8;
        border.cameras = [camBG];
        border.scale.y = 1.05;
        border.screenCenter(Y);
		add(border);

        if (!ClientPrefs.cute)
            FlxTween.tween(ammar, {x : 860}, 1, {ease : FlxEase.expoOut, startDelay: 0.5});
        borderTween = FlxTween.tween(border, {x : ((1280/2) - (border.width/2))}, 1, {ease : FlxEase.expoOut, startDelay: 0.2});

        weeksSprites = new FlxTypedGroup<StorySprite>();
        add(weeksSprites);

        songBGDesc = new FlxSprite(800).makeGraphic(400, 300, FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawRoundRect(songBGDesc, 0, 0, 400, 300, 20, 20, FlxColor.BLACK);
        songBGDesc.scrollFactor.set(0, 0);
        songBGDesc.cameras = [camHUD];
        songBGDesc.alpha = 0.5;
        songBGDesc.screenCenter(Y);
		add(songBGDesc); //1300 - 450

        diffBGDesc = new FlxSprite(1500).makeGraphic(480, 94, FlxColor.TRANSPARENT, true);
        FlxSpriteUtil.drawRoundRect(diffBGDesc, 0, 0, 480, 94, 20, 20, FlxColor.BLACK);
        diffBGDesc.scrollFactor.set(0, 0);
        diffBGDesc.cameras = [camHUD];
        diffBGDesc.alpha = 0.5;
		add(diffBGDesc); //1300 - 450

        difficultySprite = new FlxSprite(songBGDesc.x + (songBGDesc.width/2), songBGDesc.y + songBGDesc.height + 20);
        difficultySprite.frames = Paths.getSparrowAtlas('ammar/difficulty');
        difficultySprite.animation.addByPrefix('easy', 'Difficulty0000', 0, false);
        difficultySprite.animation.addByPrefix('normal', 'Difficulty0001', 0, false);
        difficultySprite.animation.addByPrefix('hard', 'Difficulty0002', 0, false);
        difficultySprite.animation.addByPrefix('insane', 'Difficulty0003', 0, false);
        difficultySprite.animation.play('normal', true);
        difficultySprite.cameras = [camHUD];
        add(difficultySprite);
        difficultySprite.x -= (difficultySprite.width/2);

        #if MOBILE
        FlxMouseEvent.add(difficultySprite, function(_){
            difficultySprite.alpha = 0.75;
        }, function(_){
            if (!selectedSomething && curPage == 'freeplay')
                playSong();
            difficultySprite.alpha = 1;
        });
        #end

        difficultyLeft = new FlxSprite().loadGraphic(Paths.image('ammar/diffLeft'));
        difficultyLeft.cameras = [camHUD];
        add(difficultyLeft);
        difficultyLeft.setGraphicSize(Std.int(difficultyLeft.width*0.5)); difficultyLeft.updateHitbox();
        difficultyLeft.setPosition(difficultySprite.x - difficultyLeft.width - 25, difficultySprite.y + (difficultySprite.height/2) - (difficultyLeft.height/2));

        difficultyRight = new FlxSprite().loadGraphic(Paths.image('ammar/diffRight'));
        difficultyRight.cameras = [camHUD];
        add(difficultyRight);
        difficultyRight.setGraphicSize(Std.int(difficultyRight.width*0.5)); difficultyRight.updateHitbox();
        difficultyRight.setPosition(difficultySprite.x + difficultySprite.width + 25, difficultySprite.y + (difficultySprite.height/2) - (difficultyRight.height/2));

        diffLOffset = difficultyLeft.offset.x;
        diffROffset = difficultyRight.offset.x;

        #if MOBILE
        FlxMouseEvent.add(difficultyLeft, function(_){
            difficultyLeft.alpha = 0.75;
        }, function(_){
            if (!selectedSomething && curPage == 'freeplay')
                changeDiff(-1);
            difficultyLeft.alpha = 1;
        });

        
        FlxMouseEvent.add(difficultyRight, function(_){
            difficultyRight.alpha = 0.75;
        }, function(_){
            if (!selectedSomething && curPage == 'freeplay')
                changeDiff(1);
            difficultyRight.alpha = 1;
        });
        #end
        
        diffLock = new FlxSprite(1900, 100).loadGraphic(Paths.image('ammar/Lock'));
        diffLock.cameras = [camHUD];
        add(diffLock);
        diffLock.setGraphicSize(Std.int(diffLock.width)); diffLock.updateHitbox();
        diffLock.alpha = 0;
        diffLock.antialiasing = ClientPrefs.globalAntialiasing;

        diffLockYOffset = diffLock.offset.y;
        diffLock.offset.y += 30;

        difficultySprite.scrollFactor.set(0, 0);
        difficultyLeft.scrollFactor.set(0, 0);
        difficultyRight.scrollFactor.set(0, 0);
        diffLock.scrollFactor.set(0, 0);

        difficultyChart = new FlxSprite(2000);
        difficultyChart.frames = Paths.getSparrowAtlas('ammar/difficultyBar');
        difficultyChart.animation.addByPrefix('chart', 'Difficulty', 0, false);
        difficultyChart.animation.play('chart', true);
        add(difficultyChart);
        difficultyChart.cameras = [camHUD];
        difficultyChart.scrollFactor.set(0, 0);

        songBGDesc.x += 550;

        menuItems = new FlxTypedGroup<MenuText>();
		add(menuItems);

        menuItemChecks = new FlxTypedGroup<CheckSprite>();
		add(menuItemChecks);

        menuIcons = new FlxTypedGroup<MenuSprite>();
		add(menuIcons);

        menuChecks = new FlxTypedGroup<Checkbox>();
		add(menuChecks);

        ammarText = new FlxTypeText(780, 510+300, 400, "");
        ammarText.setFormat(Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf"), 24, 0xFFFFFFFF, FlxTextAlign.CENTER);
        ammarText.setBorderStyle(FlxTextBorderStyle.SHADOW, 0xFF000000, 2);
        add(ammarText);
        ammarText.cameras = [camHUD];
        var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("ammar/ammarDialogue"));
        sound.volume = 0.25;
        ammarText.sounds = [sound];
        ammarText.delay = 0.02;
        talking("");

        modifierBG = new FlxSprite().makeGraphic(1300, 25, 0xFF000000);
        modifierBG.alpha = 0.5;
        modifierBG.cameras = [camHUD];
        add(modifierBG);
        modifierBG.y = 720 - 25;
        modifierBG.screenCenter(X);
        modifierBG.scrollFactor.set(0,0);

        modifierText = new FlxText(1400, 0, 0, "PRESS CTRL TO ADD MODIFIERS", 20);
        modifierText.setFormat(Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf"), 20, 0xFFFFFFFF, FlxTextAlign.CENTER);
        add(modifierText);
        modifierText.screenCenter(X);
        modifierText.y = 720 - 25;
        modifierText.cameras = [camHUD];
        modifierText.scrollFactor.set(0,0);

        modifierBG.alpha = modifierText.alpha = 0;

        songDescTxt = new FlxText(1400, 0, 600, "TEST", 24);
        songDescTxt.setFormat(Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf"), 28, 0xFFFFFFFF, FlxTextAlign.CENTER);
        songDescTxt.setBorderStyle(FlxTextBorderStyle.SHADOW, 0xFF000000, 2);
        add(songDescTxt);
        songDescTxt.cameras = [camHUD];
        songDescTxt.scrollFactor.set(0,0);

        cheatText = new FlxText(0, 600, 600, "Scores will not save\ndue to cheating", 24);
        cheatText.setFormat(Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf"), 28, 0xFFFFFFFF, FlxTextAlign.CENTER);
        cheatText.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2);
        cheatText.screenCenter(X);
        add(cheatText);
        cheatText.alpha = 0;
        cheatText.cameras = [camHUD];
        cheatText.scrollFactor.set(0,0);

        locked = new FlxSprite(0, 0).loadGraphic(Paths.image('ammar/locked'));
        add(locked);
        locked.cameras = [camHUD];
        locked.setGraphicSize(Std.int(locked.width * 0.8));
        locked.updateHitbox();
        locked.screenCenter();
        locked.y -= 50;
        locked.scrollFactor.set(0,0);
        locked.alpha = 0;

        requiredText = new FlxText(1400, 0, 500, "", 24);
        requiredText.setFormat(Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf"), 24, 0xFFFFFFFF, FlxTextAlign.CENTER);
        requiredText.setBorderStyle(FlxTextBorderStyle.SHADOW, 0xFF000000, 2);
        requiredText.screenCenter();
        add(requiredText);
        requiredText.cameras = [camHUD];
        requiredText.scrollFactor.set(0,0);
        //------------MOBILE------------//
        mobileButtons = new FlxTypedGroup<FlxSprite>();
        mobileButtons.camera = camOther;
        add(mobileButtons);
        #if MOBILE
        exitButton = new FlxSprite().loadGraphic(Paths.image('mobile/exit'));
        exitButton.setGraphicSize(Std.int(exitButton.width * 0.4)); exitButton.updateHitbox();
        exitButton.setPosition(FlxG.width-exitButton.width, 0);
        mobileButtons.add(exitButton);
        exitButton.alpha = 0.4;
        exitButton.scrollFactor.set();

        FlxMouseEvent.add(exitButton, null, function(_){
            if (!selectedSomething) {
                if (curPage == "main") {
                    FlxG.sound.play(Paths.sound('cancelMenu'));
                    MusicBeatState.switchState(new TitleState());
                } else {
                    if (curPage == 'story menu') {
                        trace('quit story');
                        changeStoryScene(-1);
                    }
                    backItem();
                }
            }
        });

        var leftStoryButton:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mobile/left'));
        leftStoryButton.setGraphicSize(Std.int(leftStoryButton.width * 0.5)); leftStoryButton.updateHitbox();
        leftStoryButton.x = 0 + 50; leftStoryButton.screenCenter(Y);
        leftStoryButton.alpha = 0.4;
        mobileButtons.add(leftStoryButton);

        var rightStoryButton:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mobile/right'));
        rightStoryButton.setGraphicSize(Std.int(rightStoryButton.width * 0.5)); rightStoryButton.updateHitbox();
        rightStoryButton.x = FlxG.width - rightStoryButton.width - 50; rightStoryButton.screenCenter(Y);
        rightStoryButton.alpha = 0.4;
        mobileButtons.add(rightStoryButton);

        var acceptStoryButton:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mobile/accept'));
        acceptStoryButton.setGraphicSize(Std.int(acceptStoryButton.width * 0.5)); acceptStoryButton.updateHitbox();
        acceptStoryButton.y = 530; acceptStoryButton.screenCenter(X);
        acceptStoryButton.alpha = 0.4;
        mobileButtons.add(acceptStoryButton);

        storyMobileButtons = [leftStoryButton, rightStoryButton, acceptStoryButton];
        for (i in storyMobileButtons) {
            i.visible = false;
        }

        FlxMouseEvent.add(leftStoryButton, null, function(_){
            if (!selectedSomething && leftStoryButton.visible) {
                FlxG.sound.play(sounds["scroll"]);
                changeItem(-1);
            }
        });

        FlxMouseEvent.add(rightStoryButton, null, function(_){
            if (!selectedSomething && rightStoryButton.visible) {
                FlxG.sound.play(sounds["scroll"]);
                changeItem(1);
            }
        });

        FlxMouseEvent.add(acceptStoryButton, null, function(_){
            if (!selectedSomething && acceptStoryButton.visible) {
                playStory();
                for (i in storyMobileButtons) {
                    i.visible = false;
                }
            }
        });

        #end
        //------------------------------//
        if (dragEnable)
            lastHoldPos = FlxPoint.get(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY);

        setSongDesc("
        [ SONG NAME ]
        SCORES: !123456!
        MISSES: !10!
        ACCURACY: !90%!
        ");

        createMenu();
        createStorySprites();
        changeItem(0);

        super.create();
        CustomFadeTransition.nextCamera = camHUD;
        CustomFadeTransition.newLoading = true;

        //Difficulty.list = ["Normal"];
        CoolUtil.difficulties = ['Easy', 'Normal', 'Hard', 'Insane'];

        FlxG.console.registerFunction("talking", talking);
        Conductor.changeBPM(102);
    }

    override function destroy() {
        FlxMouseEvent.removeAll();
        FlxMouseEvent.globalManager.removeAll();
        super.destroy();
    }
    
    function transProgress(inTrans:Bool = true):Void {
        var rcolor:Float = 1-progress;
        var gcolor:Float = progress;
        if (inTrans) {
            FlxTween.tween(progressBar, {y : 50}, 0.5, {ease: FlxEase.quadOut});
            FlxTween.tween(progressTxt, {y : 50 - 24}, 0.5, {ease: FlxEase.quadOut});
            FlxTween.tween(progressBar, {percent : progress*100}, 0.5, {ease: FlxEase.quadOut});
            FlxTween.tween(progressBar.colorTransform, {greenMultiplier : gcolor, redMultiplier: rcolor}, 0.5, {ease: FlxEase.quadOut});
        } else {
            FlxTween.tween(progressBar, {y : -50}, 0.5, {ease: FlxEase.quadIn});
            FlxTween.tween(progressTxt, {y : -50 - 24}, 0.5, {ease: FlxEase.quadIn});
            FlxTween.tween(progressBar, {percent : 0}, 0.5, {ease: FlxEase.quadIn});
            FlxTween.tween(progressBar.colorTransform, {greenMultiplier : 0, redMultiplier: 0}, 0.5, {ease: FlxEase.quadIn});
        }
    }

    function setSongDesc(text:String):Void {
        var redFormat:FlxTextFormat = new FlxTextFormat(0xFFFBFF00, true);
        var red = new FlxTextFormatMarkerPair(redFormat, "!");
        songDescTxt.applyMarkup(text, [red]);

        var formatt:FlxTextFormat = new FlxTextFormat();
        formatt.leading = -10;
        songDescTxt.addFormat(formatt);
        songDescTxt.screenCenter(Y);
    }

    var prevTalk:String = "";
    function talking(text:String, noRepeat:Bool = false, textSpeedMul:Float = 1):Void 
    {
        if (openWithCute && text != '') {
            var redexcute =  ~/r/g;
            text = redexcute.replace(text, 'w') + ' ' + (FlxG.random.bool(50) ? 'UwU' : (FlxG.random.bool(75) ? 'OwO' : ''));
        }
        if (text == "") {
            ammarText.text = "";
            ammar.animation.play("idle", true);
            prevTalk = "";
            return;
        }
        if (!noRepeat || prevTalk != text) {
            ammar.animation.play("talking", true);
            @:privateAccess
            ammarText._finalText = text;
            ammarText.text = text;
            var sound:FlxSound = new FlxSound().loadEmbedded(Paths.sound("ammar/ammarDialogue"));
            sound.volume = 0.25;
            ammarText.sounds = [sound];
            ammarText.start(0.05 / textSpeedMul, true, false, null, function(){
                ammar.animation.play("idle", true);
            });
        }
        prevTalk = text;
    }

    function createMenu():Void 
    {
        transProgress(true);
        curPage = 'main';
        #if MOBILE
            for (i in storyMobileButtons) {
                i.visible = false;
            }
        #end
        if (bg.color != menuColor["main"]) 
        {
            if (bgColorTween != null && bgColorTween.active)
                bgColorTween.cancel();
            bgColorTween = FlxTween.color(bg, 1, bg.color, menuColor["main"]);
        }
        
        var idd:Int = 0;
        for (menu in menuList)
            {
                var menuName:String = menu[0];
                var menuDesc:String = menu[1];

                var redexcute =  ~/r/g;
                var menuItem:MenuText = new MenuText(-800, 110 + (idd*130), 0, ClientPrefs.cute ? redexcute.replace(menuName, 'w') : menuName, 100);
                menuItem.font = Paths.font("Phantomuff/PhantomMuff Difficult Font.ttf");
                menuItem.antialiasing = ClientPrefs.globalAntialiasing;
                menuItem.color = (idd == curSelected ? 0xFFFFFFFF : 0xFFA0A0A0);
                menuItem.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xA0000000, 5, 1);
                menuItem.alignment = LEFT;
                menuItem.origin.x = 5;
                menuItem.objectID = idd;
                menuItem.partOf = "main";
                menuItem.extraData["desc"] = menuDesc;
                menuItems.add(menuItem);
                menuItems.cameras = [camHUD];

                #if MOBILE 
                FlxMouseEvent.add(menuItem, function(_){
                    menuItem.extraData.set('on', true);
                }, function(_){
                    if (menuItem.extraData.get('on') && !selectedSomething) {
                        if (menuItem.objectID != curSelected) {
                            curSelected = menuItem.objectID;
                            changeItem(0);
                        } else {
                            selectItem();
                        }
                    }

                }, null, null, false, true, false);
                #end
                
                var menuIcon:MenuSprite = new MenuSprite(1300, 0, Paths.image("ammar/icon/"+menuName.toLowerCase()));
                menuIcon.partner = menuItem;
                menuIcon.objectID = idd;
                menuIcon.scale.set(0.8, 0.8);
                menuIcon.updateHitbox();
                menuIcon.screenCenter(Y);
                menuIcon.y -= 50;
                menuIcon.partOf = "main";
                menuIcons.add(menuIcon);
                menuIcon.cameras = [camHUD];
                
                menuItem.partner = menuIcon;

                menuItem.noMove = true;
                FlxTween.tween(menuItem, {x : 50 + (idd == curSelected ? 40 : 0)}, 0.5, {ease : FlxEase.backOut, startDelay: 0.5 + idd*0.1, onComplete: function(tween:FlxTween){
                    menuItem.noMove = false;
                }});

                idd++;
            }

            selectedSomething = true;
            new FlxTimer().start(1, function(tmr:FlxTimer)
				{
                    changeItem(0);
					selectedSomething = false;
				});
        
    }

    function createFreeplay():Void
    {
        curPage = "freeplay";
        if (bg.color != menuColor["freeplay"]) 
            {
                if (bgColorTween != null && bgColorTween.active)
                    bgColorTween.cancel();
                bgColorTween = FlxTween.color(bg, 1, bg.color, menuColor["freeplay"]);
            }

        var newSongsList = songsList.copy();
        var unusedWeekName:String = 'Unused (DEV)';
        if (ClientPrefs.developer && songsList.length < 14) {
            //['song' => 'Protogen'    ,'icon' => ""            , 'week' => "Kaiju Paradise",  'unlocked' => ['Protogen'], 'hidden' => true]
            var newSongNeedToAdd:Array<Map<String, Dynamic>> = [
                ['song' => 'Chaos'                 ,'icon' => ""           , 'week' => unusedWeekName],
                ['song' => 'Owen Was Her'        ,'icon' => ""           , 'week' => unusedWeekName],
                ['song' => 'Death By Notes'      ,'icon' => ""           , 'week' => unusedWeekName],

                ['song' => 'Banned'      ,'icon' => ""           , 'week' => unusedWeekName],
                ['song' => 'Voice Faceoff'      ,'icon' => ""           , 'week' => unusedWeekName]
            ];
            for (item in newSongNeedToAdd) {
                newSongsList.push(item);
            }
        }
        for (item in newSongsList) {
            if (item['week'] == 'Furry Femboy') {
                if (ClientPrefs.cute && checkSongFinish('myself')) {
                    trace('yes furry femboy');
                } else {
                    trace('no furry femboy');
                    newSongsList.remove(item);
                }
                break;
            }
        }
        var idd:Int = 0;
        var addedWeek:Array<String> = [];
        for (songArray in newSongsList)
            {
                final songName:String = songArray["song"];
                final icon:String = songArray["icon"];
                final week:String = songArray["week"];
                if (unusedWeekName == week && ClientPrefs.hideunused) continue;
                var hidden:Bool = songArray["hidden"]; if (songArray["hidden"] == null) hidden = false;
                var songNeeded:Array<String> = songArray['unlocked'];
                var isSongUnlocked:Bool = songNeeded == null || songNeeded == [];
                if (!isSongUnlocked) {
                    isSongUnlocked = true;
                    for (song in songNeeded) {
                        if (!checkSongFinish(song)) {
                            isSongUnlocked = false;
                            break;
                        }
                    }
                }

                if (!isSongUnlocked && hidden)
                    continue;

                if (!addedWeek.contains(week)) {
                    addedWeek.push(week);
                    var weekItem:MenuText = new MenuText(1280, (360-50) + (idd - curSelected)*80, 0, "<- " + week.toUpperCase() + " ->", 50);
                    weekItem.font = Paths.font("Phantomuff/PhantomMuff Empty Letters.ttf");
                    weekItem.antialiasing = ClientPrefs.globalAntialiasing;
                    weekItem.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xA0000000, 6, 1);
                    weekItem.alignment = LEFT;
                    weekItem.origin.x = 5;
                    weekItem.objectID = idd;
                    weekItem.partOf = "freeplay";
                    menuItems.add(weekItem);
                    weekItem.cameras = [camHUD];
    
                    weekItem.extraData.set("week", week);
                    weekItem.extraData.set("isTitle", true);

                    weekItem.noMove = true;
                    FlxTween.tween(weekItem, {x : 140 + (idd == curSelected ? 40 : 0) + -Math.abs(20 * (idd-curSelected))}, 0.5, {ease : FlxEase.backOut, startDelay: 0.5 + idd*(0.5/menuItems.length), onComplete: function(tween:FlxTween){
                        weekItem.noMove = false;
                    }});


                    idd++;
                }

                var redex =  ~/[a-zA-Z0-9_.-]/g;//"[a-zA-Z0-9_.-]";
                var redexcute =  ~/r/g;
                var menuItem:MenuText = new MenuText(1280, (360-50) + (idd - curSelected)*80, 0, (isSongUnlocked ? (ClientPrefs.cute ? redexcute.replace(songName, 'w') : songName) : redex.replace(songName, "?")), 50);
                menuItem.font = Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf");
                menuItem.antialiasing = ClientPrefs.globalAntialiasing;
                menuItem.color = (idd == curSelected ? 0xFFFFFFFF : 0xFFA0A0A0);
                menuItem.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xA0000000, 5, 1);
                menuItem.alignment = LEFT;
                menuItem.origin.x = 5;
                menuItem.objectID = idd;
                menuItem.partOf = "freeplay";
                menuItems.add(menuItem);
                menuItems.cameras = [camHUD];

                menuItem.extraData.set("song", songName);
                menuItem.extraData.set("icon", icon);
                menuItem.extraData.set("week", week);
                menuItem.extraData.set("locked", !isSongUnlocked);
                menuItem.extraData.set("isTitle", false);

                menuItem.noMove = true;
                FlxTween.tween(menuItem, {x : 140 + (idd == curSelected ? 40 : 0) + -Math.abs(20 * (idd-curSelected))}, 0.5, {ease : FlxEase.backOut, startDelay: 0.5 + idd*(0.5/(songsList.length + 3)), onComplete: function(tween:FlxTween){
                    menuItem.noMove = false;
                }});

                if (checkSongFinish(songName, 0) || checkSongFinish(songName, 1) || checkSongFinish(songName, 2))
                for (i in 0...3)
                {
                    if (checkSongFinish(songName, i)) {
                        var check:CheckSprite = new CheckSprite(0, 0, i);
                        check.partner = menuItem;
                        check.followPartner = true;
                        check.setGraphicSize(Std.int(check.width*0.75));
                        check.addX = menuItem.width + 25 + (60 * i);
                        check.addY = (menuItem.height / 2) - (check.height/2);
                        menuItem.checks.push(check);
                        menuItemChecks.add(check);
                    }
                }
 
                
                idd++;
            }

        selectedSomething = true;
        talking(" ", true, 5);
        new FlxTimer().start(0.75, function(tmr:FlxTimer)
            {
                changeItem(0);
                selectedSomething = false;
                ammarText.text = "";
            });
        ammarText.text = "";

        if (songBGDescTween != null && songBGDescTween.active)
            songBGDescTween.cancel();

        songBGDescTween = FlxTween.tween(songBGDesc, {x : 800}, 0.5, {ease : FlxEase.backOut, onComplete: function(tween:FlxTween){
            songBGDescTween = null;
        }});

        if (ClientPrefs.developer) {
            modifierBG.alpha = 0.5;
            modifierText.alpha = 1;
        }
    }

    function createOptions(page:Int = 0):Void
    {
        curPage = "options"+page;
        if (bg.color != menuColor["options"]) 
            {
                if (bgColorTween != null && bgColorTween.active)
                    bgColorTween.cancel();
                bgColorTween = FlxTween.color(bg, 1, bg.color, menuColor["options"]);
            }

        var idd:Int = 0;
        if (page == 0) { 
            for (option in optionsMode)
                {
                    var menuItem:MenuText = new MenuText(1280, 270 + (idd * 100), 0, option, 60);
                    menuItem.font = Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf");
                    menuItem.antialiasing = ClientPrefs.globalAntialiasing;
                    #if !MOBILE
                    menuItem.color = (idd == curSelected ? 0xFFFFFFFF : 0xFFA0A0A0);
                    #end
                    menuItem.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xA0000000, 5, 1);
                    menuItem.alignment = LEFT;
                    menuItem.origin.x = 5;
                    menuItem.objectID = idd;
                    menuItem.partOf = "options0";
                    menuItems.add(menuItem);
                    menuItems.cameras = [camHUD];
    
                    menuItem.noMove = true;
                    FlxTween.tween(menuItem, {x : 80 + (idd == curSelected ? 40 : 0) + -Math.abs(20 * (idd-curSelected))}, 0.5, {ease : FlxEase.backOut, startDelay: 0.5 + idd*(0.3/optionsMode.length), onComplete: function(tween:FlxTween){
                        menuItem.noMove = false;
                    }});

                    #if MOBILE
                    FlxMouseEvent.add(menuItem, null, function(_){
                        if (Math.abs(swipeDistance) <= 30 && !menuItem.noMove) {
                            if (menuItem.text == "Mod Options")
                                curSelected = 0;
                            else
                                curSelected = 1;
                            selectItem();
                        }
                    });
                    
                    #end
                    
                    idd++;
                }
        } else if (page == 1) {
            for (option in optionsList)
                {
                    var optionName:String = option[0];
                    var optionDesc:String = option[1];
                    var menuItem:MenuText = new MenuText(1280, (360-50) + (idd - curSelected)*80, 0, optionName, 50);
                    menuItem.font = Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf");
                    menuItem.antialiasing = ClientPrefs.globalAntialiasing;
                    menuItem.color = (idd == curSelected ? 0xFFFFFFFF : 0xFFA0A0A0);
                    menuItem.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xA0000000, 5, 1);
                    menuItem.alignment = LEFT;
                    menuItem.origin.x = 5;
                    menuItem.objectID = idd;
                    menuItem.partOf = "options1";
                    menuItem.extraData["desc"] = optionDesc;
                    menuItem.extraData["save"] = option[2];
                    menuItems.add(menuItem);
                    menuItems.cameras = [camHUD];
                    if (option[2] == "cute")
                        menuItem.color = (idd == curSelected ? 0xFFE200F7 : 0xFF9900A7);

                    #if MOBILE
                    if (option[2] == 'delete') {
                        FlxMouseEvent.add(menuItem, null, null, function(_){
                            menuItem.extraData["mouseOver"] = true;  
                        }, function(_){
                            menuItem.extraData["mouseOver"] = false; 
                        });
                    }
                    #end

                    var checkbox:Checkbox = new Checkbox(0, 0, Reflect.getProperty(ClientPrefs, option[2]));
                    checkbox.sprTracker = menuItem;
                    checkbox.offsetX = menuItem.width + 250;
                    checkbox.offsetY = -(menuItem.height);
                    if (option[2] != 'delete')
                        menuChecks.add(checkbox);
                    checkbox.objectID = idd;
                    
                    #if MOBILE
                    FlxMouseEvent.add(checkbox, function(_){
                        checkbox.isPressingOnMe = true;
                        checkbox.alpha = 0.75;
                    }, function(_){
                        if (checkbox.isPressingOnMe && Math.abs(swipeDistance) <= 30) 
                            selectOption(checkbox.objectID);
                        checkbox.isPressingOnMe = false;
                        checkbox.alpha = 1;

                        for (check in menuChecks) check.alpha = 1;
                    });
                    #end
                    
                    menuItem.noMove = true;
                    FlxTween.tween(menuItem, {x : 80 + (idd == curSelected ? 40 : 0) + -Math.abs(20 * (idd-curSelected))}, 0.5, {ease : FlxEase.backOut, startDelay: 0.5 + idd*(1/optionsList.length), onComplete: function(tween:FlxTween){
                        menuItem.noMove = false;
                    }});
                    
                    idd++;
                }
        }

        selectedSomething = true;
        new FlxTimer().start(1, function(tmr:FlxTimer)
            {
                changeItem(0);
                selectedSomething = false;
            });
    }

    function createBadges():Void 
    {
        curPage = "badges";
        if (bg.color != menuColor["badge"]) 
            {
                if (bgColorTween != null && bgColorTween.active)
                    bgColorTween.cancel();
                bgColorTween = FlxTween.color(bg, 1, bg.color, menuColor["badge"]);
            }

        var idd:Int = 0;
        for (badgeGroup in badgesList)
            {
                var badgeName:String = badgeGroup[0];
                var badgeSave:String = badgeGroup[1];
                var badgeDesc:Array<String> = badgeGroup[2];
                var badgeGot:Bool = ClientPrefs.badges.contains(badgeSave);
                var redex =  ~/[a-zA-Z0-9_.-]/g;//"[a-zA-Z0-9_.-]";

                var menuItem:MenuText = new MenuText(1280, (360-50) + (idd - curSelected)*80, 0, (badgeGot ? badgeName : redex.replace(badgeName, "?")), 50);
                menuItem.font = Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf");
                menuItem.antialiasing = ClientPrefs.globalAntialiasing;
                menuItem.color = (idd == curSelected ? 0xFFFFFFFF : 0xFFA0A0A0);
                menuItem.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xA0000000, 5, 1);
                menuItem.alignment = LEFT;
                menuItem.origin.x = 5;
                menuItem.objectID = idd;
                menuItem.partOf = "badges";
                menuItem.extraData.set('desc', badgeDesc[badgeGot ? 1 : 0]);
                menuItems.add(menuItem);
                menuItems.cameras = [camHUD];

                var imagePath:String = (badgeGot ? ((badgeSave == 'ammarfurry' || badgeSave == 'furry') ? "badgeGotCute" : "badgeGot") : "badgeNotGot");
                
                var menuIcon:MenuSprite = new MenuSprite(1300, 0, Paths.image("ammar/"+imagePath));
                menuIcon.partner = menuItem;
                menuIcon.objectID = idd;
                menuIcon.scale.set(0.35, 0.35);
                menuIcon.updateHitbox();
                menuIcon.followPartner = true;
                menuIcon.addX = menuItem.width + 20;
                menuIcon.addY = -(menuIcon.height / 4);
                menuIcon.partOf = "badges";
                menuIcons.add(menuIcon);
                menuIcon.cameras = [camHUD];
                
                menuItem.partner = menuIcon;

                menuItem.noMove = true;
                FlxTween.tween(menuItem, {x : 50 + (idd == curSelected ? 40 : 0)}, 0.5, {ease : FlxEase.backOut, startDelay: 0.5 + idd*0.1, onComplete: function(tween:FlxTween){
                    menuItem.noMove = false;
                }});

                idd++;
            }

            selectedSomething = true;
            new FlxTimer().start(1, function(tmr:FlxTimer)
                {
                    changeItem(0);
                    selectedSomething = false;
                });
    }

    override function update(elapsed:Float) 
    {
        if (FlxG.sound.music.volume < 0.8)
            {
                FlxG.sound.music.volume += 0.5 * elapsed;
                if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
            }

        if (FlxG.sound.music != null) 
            Conductor.songPosition = FlxG.sound.music.time;


        dragSystem();

        var intensity:Float = (curSelected - (menuItems.length/2)) * ((1 / menuItems.length)*4);
        FlxG.watch.addQuick("Camera BG Y", intensity);
        songDescTxt.x = songBGDesc.x - 158;
        diffBGDesc.x = songBGDesc.x + (songBGDesc.width/2) - (diffBGDesc.width/2);
        diffBGDesc.y = songBGDesc.y + (songBGDesc.height) + 10;
        difficultyChart.setPosition(songBGDesc.x + (songBGDesc.width/2) - (songBGDesc.width/2) + 5, songBGDesc.y - (difficultyChart.height) - 10);

        difficultyDraw();

        displayList();

        if ((curPage == 'freeplay' || curPage == 'story') && (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false)
            || ClientPrefs.getGameplaySetting('healthgain', 1) > 1 || ClientPrefs.getGameplaySetting('healthloss', 1) < 1 
            || !ClientPrefs.getGameplaySetting('mechanics', true) || !ClientPrefs.getGameplaySetting('specialnotes', true) || !ClientPrefs.getGameplaySetting('modchart', true)))
                cheatText.alpha = 1;
        else {
            cheatText.alpha = 0; 
        }
       
        hudFollow.y = FlxMath.lerp(hudFollow.y, (720/2) + intensity, elapsed*8);
        if (ClientPrefs.sillybop) {
            bgFollow.y = (720/2) + Math.abs(Math.sin( ((curDecBeat/2)%1) * 2 * Math.PI)) * 6;
        } else {
            bgFollow.y = FlxMath.lerp(bgFollow.y, (720/2) + (intensity/2), elapsed*8);
        }

        buttonControls();

        super.update(elapsed);
    }

    function backItem():Void {
        FlxG.sound.play(Paths.sound('cancelMenu'));
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

        menuItems.forEachAlive(function(member:MenuText){
            member.noMove = true;
            var targetX:Float = (member.partOf == "freeplay" ? member.x + 1100 : member.x - 400 - member.width);
            FlxMouseEvent.remove(member);
            FlxTween.cancelTweensOf(member);
            FlxTween.tween(member, {x : targetX}, 0.5, {ease : FlxEase.backIn, startDelay: member.objectID*(0.5/menuItems.length), onComplete: function(tween:FlxTween){
                menuItems.remove(member, true);
                member.destroy();
            }});
        });

        menuChecks.forEachAlive(function(member:Checkbox){
            member.sprTracker = null;
            var targetX:Float = member.x + 1100;
            FlxTween.cancelTweensOf(member);
            FlxTween.tween(member, {x : targetX}, 0.5, {ease : FlxEase.backIn, startDelay: member.objectID*(0.5/menuItems.length), onComplete: function(tween:FlxTween){
                menuChecks.remove(member, true);
                member.destroy();
            }});
        });

        if (curPage == "freeplay") {
            if (songBGDescTween != null && songBGDescTween.active)
                songBGDescTween.cancel();

            songBGDescTween = FlxTween.tween(songBGDesc, {x : 800 + 550}, 0.5, {ease : FlxEase.backIn, onComplete: function(tween:FlxTween){
                songBGDescTween = null;
            }});
        }

        menuIcons.forEach(function(daMem:MenuSprite) {
            if (daMem.partOf == 'badges') daMem.destroy();
        });

        if (curPage == "options1") {
            createOptions(0);
            ClientPrefs.saveSettings();
        } else {
            ClientPrefs.saveSettings();
            #if desktop
                DiscordClient.changePresence("In the "+(ClientPrefs.cute ? 'Cute ' : '')+"Menu", null);
            #end

            ammarText.visible = true; ammarText.alpha = 1;
            createMenu();
        }

        changeItem((-curSelected), true, false);

        modifierBG.alpha = modifierText.alpha = 0;

        if (borderTween != null && borderTween.active)
            borderTween.cancel();
        border.x = -80;
        borderTween = FlxTween.tween(border, {x : ((1280/2) - (border.width/2))}, 1, {ease : FlxEase.expoOut});
        
    }

    function holdOption():Void {
        var targetMember:MenuText = menuItems.members[curSelected];
        var saveName:String = optionsList[targetMember.objectID][2];
       
        if (saveName == 'delete') {
            holdOptionTime += FlxG.elapsed;
            camBG.shake(holdOptionTime/100, 0.1);
            camHUD.shake(holdOptionTime/100, 0.1);
            FlxG.sound.music.volume = 1-(holdOptionTime/2.5);
            holdOptionPass = 0;
            if (holdOptionTime >= 3) {
                FlxG.sound.play(Paths.sound('cancelMenu'));
                TitleState.initialized = false;
                TitleState.closedState = false;
                FlxG.sound.music.stop();
                FlxG.sound.music = null;
                ClientPrefs.resetSaves();
                FlxG.resetGame();
                trace('Delete Save Files 😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨😨');
            }
        }
    }

    var haveToReset:Bool = false;
    function selectOption(select:Int):Void {
        var targetMember:MenuText = menuItems.members[select];
        var saveName:String = optionsList[targetMember.objectID][2];
        if (optionsList[targetMember.objectID][2] == "cute") {
            if (checkSongFinish('discord-annoyer') && checkSongFinish('shut-up') && checkSongFinish('depression') && checkSongFinish('moderator')) {
                //empty
            } else {
                popLocked('Beat Discord Annoyer first before accessing the cute option. OvO');
                FlxG.sound.play(sounds["locked"]);
                return;
            }

        }
        if (optionsList[targetMember.objectID][2] == "developer") {
            #if !debug
            if (checkSongFinish('no-debug') && checkSongFinish('myself')) {
                //empty
            } else {
                popLocked('Beat Debug first before becoming developer');
                FlxG.sound.play(sounds["locked"]);
                return;
            }
            #end
            if (Reflect.getProperty(ClientPrefs, saveName)) return;
        }
        if (saveName == 'delete') return;
        var targetCheck:Checkbox =  menuChecks.members[targetMember.objectID];

        FlxG.sound.play(sounds["scroll"]);

        Reflect.setProperty(ClientPrefs, saveName, !Reflect.getProperty(ClientPrefs, saveName));
        targetCheck.daValue = Reflect.getProperty(ClientPrefs, saveName);

        if (optionsList[targetMember.objectID][2] == "cute") {
            haveToReset = openWithCute != ClientPrefs.cute;
            ClientPrefs.saveSettings();
        }
    }

    function selectItem():Void {
        //FlxG.sound.play(Paths.sound('confirmMenu'));
        

        var selectedButton:String = "";
        if (curPage != 'freeplay' && curPage != 'story menu' && curPage != 'badges') {
            selectedSomething = true;
            itemMove();
        }
        //curSelected = 0;
        //changeItem(0);

        if (curPage == "freeplay") {
            playSong();
        } else if (curPage == "story menu") {
            CustomFadeTransition.nextCamera = camHUD;
            selectedSomething = true;
            playStory();

        } else if (curPage == "main") {
            transProgress(false);
            selectedButton = menuList[curSelected][0].toLowerCase().trim();
            FlxG.sound.play(Paths.sound('confirmMenu'));
            switch (selectedButton) {
                case 'story mode':
                    curPage = 'story menu';
                    #if desktop
                        DiscordClient.changePresence("In the "+(ClientPrefs.cute ? 'Cute ' : '')+"Story Mode", null);
                    #end
                    #if MOBILE
                    for (i in storyMobileButtons) i.visible = true;
                    #end
                    ammarText.visible = false; ammarText.alpha = 0;
                    new FlxTimer().start(0.5, function(tmr:FlxTimer)
                        {
                            curSelected = 0;
                            changeStoryScene(0);
                            talking("", true);
                            selectedSomething = false;
                            for (week in weeks) {
                                for (sprite in week) {
                                    sprite.alpha = 1;
                                }
                            }
                        });
                case 'freeplay':
                    createFreeplay();
                    #if desktop
                        DiscordClient.changePresence("In the "+(ClientPrefs.cute ? 'Cute ' : '')+"Freeplay", null);
                    #end
                case 'badges':
                    createBadges();
                    #if desktop
                        DiscordClient.changePresence("In the "+(ClientPrefs.cute ? 'Cute ' : '')+"Badges", null);
                    #end
                case 'options':
                    createOptions(0);
                    #if desktop
                        DiscordClient.changePresence("In the "+(ClientPrefs.cute ? 'Cute ' : '')+"Options", null);
                    #end
                
            }
        } else if (curPage == "badges") {
            trace('badge');
        } else if (curPage == "options0") {
            if (menuItems.members[curSelected].text == "Mod Options") {
                createOptions(1);
            } else {
                FlxMouseEvent.removeAll();
                CustomFadeTransition.nextCamera = camHUD;
                LoadingState.loadAndSwitchState(new OptionsState());
                if (PlayState.SONG != null)
                {
                    PlayState.SONG.arrowSkin = null;
                    PlayState.SONG.splashSkin = null;
                }
                
            }
            ClientPrefs.saveSettings();
        }
       
        if (curPage != 'freeplay' && curPage != 'story menu' && curPage != 'badges')
            changeItem((-curSelected), true, false);

        if (borderTween != null && borderTween.active)
            borderTween.cancel();
        border.x = -80;
        borderTween = FlxTween.tween(border, {x : ((1280/2) - (border.width/2))}, 1, {ease : FlxEase.expoOut});

    }

    function itemMove():Void {
        menuItems.forEachAlive(function(member:MenuText){
            member.noMove = true;
            var targetX:Float = member.x - 400 - member.width;
            FlxTween.cancelTweensOf(member);
            if (member.partOf == "main" && member.objectID == curSelected) {
                FlxTween.tween(member, {"scale.x" : 1.3, "scale.y" : 1.3, x : member.x + 50}, 0.5, {ease : FlxEase.elasticOut});
                FlxTween.tween(member, {x : targetX}, 0.4, {ease : FlxEase.backIn, startDelay: 0.4, onComplete: function(tween:FlxTween){
                    menuItems.remove(member, true);
                    member.destroy();
                }});
            } else
            if ((member.objectID != curSelected && member.partOf == 'freeplay') || member.partOf != 'freeplay')
                FlxTween.tween(member, {x : targetX}, 0.5, {ease : FlxEase.backIn, onComplete: function(tween:FlxTween){
                    menuItems.remove(member, true);
                    member.destroy();
                }});

            if (member.partner != null && member.partOf == "main") {
                member.partner.noMove = true;
                FlxTween.tween(member.partner, {x : member.partner.x + 600}, 0.5, {ease : FlxEase.backIn, onComplete: function(tween:FlxTween){
                    member.partner.destroy();
                }});
            }
            if (member.checks != null) {
                for (item in member.checks) {
                    menuItemChecks.remove(item, true);
                    item.destroy();
                }
            }
        });
    }

    function changeStoryScene(select:Int = 0):Void {
        if (weeks[select] != null && select != -1)
            for (spr in weeks[select]) {
                if (spr.tween != null) spr.tween.cancel();
                spr.tween = FlxTween.tween(spr, {x: spr.centerx}, 0.4, {ease: FlxEase.quadInOut});
                if (spr.alphatween != null) spr.alphatween.cancel();
                spr.alphatween = FlxTween.tween(spr, {alpha: 1}, 0.1);
            }

        for (i in 0...weeks.length) {
            if (select != i) {
                for (spr in weeks[i]) {
                    if (spr.tween != null) spr.tween.cancel();
                    spr.tween = FlxTween.tween(spr, {x: spr.centerx + (1280 * (spr.ID % 2 == 0 ? 1 : -1))}, 0.4, {ease: FlxEase.quadInOut});
                    if (spr.alphatween != null) spr.alphatween.cancel();
                    spr.alphatween = FlxTween.tween(spr, {alpha: 0}, 0.1, {startDelay:0.3});
                } 
            }
        }
    }

    private function createStorySprites():Void {
        var folder:String = 'ammar/weeks';
        // WEEK 1 - Discord Annoyer
        var bg:StorySprite = new StorySprite(0,5, '$folder/discordAnnoyer/bg', null, 0); weeksSprites.add(bg); bg.zoomSin = true;
        var user:StorySprite = new StorySprite(0,5, '$folder/discordAnnoyer/user', null, 2); weeksSprites.add(user); user.sinY = true;
        var title:StorySprite = new StorySprite(0,0, '$folder/discordAnnoyer/title', null, 10); weeksSprites.add(title); title.sinY = true; title.sinOff = 0.75;
        weekDiscordAnnoyer.push(title);
        weekDiscordAnnoyer.push(user);
        weekDiscordAnnoyer.push(bg);

        // WEEk 2 - Hate Comment
        var bg:StorySprite = new StorySprite(0,5, '$folder/hatingProblem/bg', null, 0); weeksSprites.add(bg); bg.zoomSin = true;
        var body:StorySprite = new StorySprite(0,5, '$folder/hatingProblem/body', null, 2); weeksSprites.add(body); body.sinY = true;
        var rgbbody:StorySprite = new StorySprite(0,0, '$folder/hatingProblem/rgbbody', null, 3); weeksSprites.add(rgbbody);
        rgbbody.blend = BlendMode.ADD;
        var vignette:StorySprite = new StorySprite(0,0, '$folder/hatingProblem/vignette', null, 5); weeksSprites.add(vignette);
        var rgbhead:StorySprite = new StorySprite(0,0, '$folder/hatingProblem/rgbhead', null, 6); weeksSprites.add(rgbhead);
        rgbhead.blend = BlendMode.ADD;
        var head:StorySprite = new StorySprite(0,5, '$folder/hatingProblem/head', null, 7); weeksSprites.add(head); head.sinY = true;
        var redVignette:StorySprite = new StorySprite(0,0, '$folder/hatingProblem/redVignette', null, 8); weeksSprites.add(redVignette); redVignette.zoomSin = true;
        var rgbtitle:StorySprite = new StorySprite(0,0, '$folder/hatingProblem/rgbtitle', null, 9); weeksSprites.add(rgbtitle); rgbtitle.sinY = true; rgbtitle.sinOff = 0.25;
        rgbtitle.blend = BlendMode.ADD;
        var title:StorySprite = new StorySprite(0,0, '$folder/hatingProblem/title', null, 10); weeksSprites.add(title); title.sinY = true; title.sinOff = 0.25;
        weekHatingProblem.push(bg);
        weekHatingProblem.push(body);
        weekHatingProblem.push(rgbbody);
        weekHatingProblem.push(vignette);
        weekHatingProblem.push(rgbhead);
        weekHatingProblem.push(head);
        weekHatingProblem.push(redVignette);
        weekHatingProblem.push(rgbtitle);
        weekHatingProblem.push(title);

        // WEEK 3 - Debug
        var bg:StorySprite = new StorySprite(0,5, '$folder/debug/bg', null, 0); weeksSprites.add(bg); bg.zoomSin = true;
        var pattern:StorySprite = new StorySprite(0,5, '$folder/debug/pattern', 1.05, 1); weeksSprites.add(pattern); pattern.sinY = true;
        var particle:StorySprite = new StorySprite(0,5, '$folder/debug/particle', 1.04, 2); weeksSprites.add(particle); particle.sinY = true; particle.sinOff = 0.5;
        particle.blend = BlendMode.ADD;
        var title:StorySprite = new StorySprite(0,0, '$folder/debug/title', null, 10); weeksSprites.add(title); title.sinY = true; title.sinOff = 0.75;
        weekDebug.push(title);
        weekDebug.push(pattern);
        weekDebug.push(particle);
        weekDebug.push(bg);

        // WEEK 4 - Kaiju Paradise
        var bg:StorySprite = new StorySprite(0,5, '$folder/paradise/bg', null, 0); weeksSprites.add(bg); bg.zoomSin = true;
        var char:StorySprite = new StorySprite(0,5, '$folder/paradise/char', null, 2); weeksSprites.add(char); char.sinY = true;
        var title:StorySprite = new StorySprite(0,0, '$folder/paradise/title', null, 10); weeksSprites.add(title); title.sinY = true; title.sinOff = 0.75;
        weekKaijuParadise.push(title);
        weekKaijuParadise.push(char);
        weekKaijuParadise.push(bg);
        

        if (ClientPrefs.cute)
            weeks = [weekDiscordAnnoyer, weekHatingProblem, weekDebug, weekKaijuParadise];
        else 
            weeks = [weekDiscordAnnoyer, weekHatingProblem, weekDebug];

        weeksSprites.sort(sortByOrder);

        weeksSprites.forEachAlive(function(spr:StorySprite){
            spr.alpha = 0;
            spr.x = spr.centerx + (1280 * (spr.ID % 2 == 0 ? 1 : -1));
        });
    }
    
    function sortByOrder(Order ,Obj1:StorySprite, Obj2:StorySprite):Int
    {
        return FlxSort.byValues(Order, Obj1.daOrder, Obj2.daOrder);
    }


    function playSong():Void {
        if (((difficulty.toLowerCase() == 'hard' && !checkSongFinish(menuItems.members[curSelected].extraData.get("song"), 1)) || menuItems.members[curSelected].extraData.get("locked")) #if debug && !FlxG.keys.pressed.NUMPADFIVE #end) {
            FlxG.sound.play(sounds["locked"], 0.5);
            popLocked('You need to complete The Week first');
            return;
        }
        itemMove();

        changeDiff(0);
        var songLowercase:String = Paths.formatToSongPath(menuItems.members[curSelected].extraData.get("song"));

        if (!ClientPrefs.developer)
            antidebug.DebugSave.updateFolder(songLowercase);

        ClientPrefs.aDifficulty = difficulty;
        FlxG.sound.play(sounds["impact"], 0.5);
        FlxG.sound.play(Paths.sound('confirmMenu'));
        camHUD.flash(0x85FFFFFF, 1);

        persistentUpdate = false;
        var pathName:String = songLowercase;
        if (!(difficulty.toLowerCase() == 'normal')) pathName += '-' + difficulty.toLowerCase();
        var songName:String = Paths.formatToSongPath(pathName); //Highscore.formatSong(songLowercase, 0); // there is no FNF difficulty 
        if (!Paths.fileExists( 'data/'+songLowercase+'/'+pathName+'.json', TEXT)) {
            trace('no '+difficulty+' found : ' + 'data/'+songLowercase+'/'+pathName+'.json');
            songName = songLowercase;
        }


        trace(difficulty);
        trace(songName);
        try
        {
            CoolUtil.difficulties = ['Easy', 'Normal', 'Hard', 'Insane'];
            trace('-------- $songName --------');
            PlayState.SONG = Song.loadFromJson(songName, songLowercase);
            PlayState.isStoryMode = false;
            PlayState.storyDifficulty = diffSelect;

            FlxSpriteUtil.flicker(menuItems.members[curSelected], 1, 0.08, true);
            menuItems.forEachAlive(function(member:MenuText){
                if (member.objectID != curSelected) {
                    FlxSpriteUtil.flicker(member, 0.3, 0.04, false);
                }
            });
            selectedSomething = true;
            FlxG.sound.music.fadeOut(1, 0);
            new FlxTimer().start(1, function(tmr:FlxTimer)
				{
                    LoadingState.loadAndSwitchState(new PlayState());
				});
          
            //FlxG.sound.music.volume = 0;
            //trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
        }
        catch(e:Dynamic)
        {
            CoolUtil.showPopUp(e, "ERROR!");
        }
       
                
        
    }

    function playStory():Void {
        FlxG.sound.play(sounds["impact"], 0.5);
        FlxG.sound.play(Paths.sound('confirmMenu'));
        camHUD.flash(0x85FFFFFF, 1, null, true);

        FlxG.sound.music.fadeOut(1, 0);
        var songArray:Array<String> = [];
        for (song in songsList) {
            if (song['week'] == weeksList[curSelected]) {
                songArray.push(song['song']);
            }
        }

        if (!ClientPrefs.developer)
            antidebug.DebugSave.updateFolder(songArray[0]);
        
        CoolUtil.difficulties = ['Easy', 'Normal', 'Hard', 'Insane'];
        PlayState.storyPlaylist = songArray;
        PlayState.isStoryMode = true;
        PlayState.storyName = weeksList[curSelected];
        PlayState.storyWeek = curSelected;
        
        var curDiff:Int = 1; //diffSelect
        var diffic = CoolUtil.getDifficultyFilePath(curDiff); if(diffic == null) diffic = '';
        ClientPrefs.aDifficulty = CoolUtil.difficulties[curDiff];

        PlayState.storyDifficulty = curDiff;

        PlayState.campaignScore = 0;
        PlayState.campaignMisses = 0;
        PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase()); //songdata, folder song
        new FlxTimer().start(1, function(tmr:FlxTimer)
        {
            LoadingState.loadAndSwitchState(new PlayState(), true);
        });
    }

    function changeItem(amount:Int = 0, noChangeColor:Bool = false, canTalk:Bool = true):Void
    {
        var prevSelect:Int = curSelected;
        curSelected += amount;
        if (curPage != "story menu")
            curSelected = FlxMath.wrap(curSelected, 0, menuItems.length-1);
        else {
            curSelected = FlxMath.wrap(curSelected, 0, weeks.length-1);
            changeStoryScene(curSelected);
            talking("", true);
            return;
        }
        var curMember:MenuText = menuItems.members[curSelected];
        if (curMember.partOf == "freeplay" && curMember.extraData.get("isTitle")) {
            curSelected += (amount < 0 ? -1 : 1);
            curSelected = FlxMath.wrap(curSelected, 0, menuItems.length-1);
        }
       

        menuItems.forEachAlive(function(member:MenuText){
            
            if (!noChangeColor)
                if (member.partOf == "options1" && optionsList[member.objectID][2] == "cute")
                    member.color = (member.objectID == curSelected ? 0xFFE200F7 : 0xFF9900A7);
                else #if MOBILE if (member.partOf != 'options0') #end
                    member.color = ((member.objectID == curSelected || (member.partOf == "freeplay" && member.extraData.get("isTitle"))) ? 0xFFFFFFFF : 0xFFA0A0A0);
            if (member.partOf == "main" && !member.partner.noMove) {
                if (member.objectID == curSelected) {
                    FlxTween.cancelTweensOf(member.partner);
                    FlxTween.tween(member.partner, {x : 800, alpha:1}, 0.5, {ease : FlxEase.expoOut});
                } else {
                    FlxTween.cancelTweensOf(member.partner);
                    FlxTween.tween(member.partner, {x : 1300, alpha:0}, 0.25, {ease : FlxEase.quadIn});
                }
            }
                
        });

        FlxTween.cancelTweensOf(ammarText);
        if (curPage == "main") 
           FlxTween.tween(ammarText, {x : 780, y: 510}, 1, {ease : FlxEase.expoOut});

        ammar.y = 237 + (openWithCute ? -150 : 0);
        if (ammarTalkingTween != null && ammarTalkingTween.active)
            ammarTalkingTween.cancel();

        ammarTalkingTween = FlxTween.tween(ammar, {y : 227 + (openWithCute ? -150 : 0)}, 0.5, {ease : FlxEase.quadOut});

        //FREEPLAY DESC
        if (curMember.partOf == "freeplay" && !curMember.extraData.get("isTitle")) {
            var songName:String = (curMember.extraData.get("song")).toUpperCase();
            var scores:Float = Highscore.getScore(songName, diffSelect);
            var misses:Float = Highscore.getMiss(songName, diffSelect);
            var accuracy:Float = Highscore.floorDecimal(Highscore.getRating(songName, diffSelect) * 100, 2);
            if (curMember.extraData.get("locked")) songName = '???';
            setSongDesc('
                [ $songName ]
                SCORES: !$scores!
                MISSES: !$misses!
                ACCURACY: !$accuracy%!
            ');
        }
        if (curMember.partOf == "freeplay") {
            var getSong:Array<Int> = songsDifficulty[curMember.extraData.get("song")];
            if (getSong != null)
                difficultyPoint = getSong[diffSelect];
        }
        //Talking
        if (canTalk) {
            if (curMember.partOf == "options1")
                talking(optionsList[curSelected][1], true, 2);
            else if (curMember.partOf == "main")
                talking(menuList[curMember.objectID][1], true, 1);
            else if (curPage == "badges")
                talking(curMember.extraData.get('desc'), true, 1);
            else if (curPage == "freeplay")
                ammarText.text = "";
            else {
                ammarText.text = "";
                talking(" ", true);
            }
        }
        
        if (amount != 0) changeDiff(0);
    }

    function changeDiff(amount:Int = 0):Void
    {
        diffSelect += amount;
        diffSelect = FlxMath.wrap(diffSelect, 0, 2);
       // if (!checkSongFinish(menuItems.members[curSelected].extraData.get("song"), 2) && diffSelect >= 3) diffSelect = 0; 
        //if (!checkSongFinish(menuItems.members[curSelected].extraData.get("song"), 2) && diffSelect < 0) diffSelect = 2; 

        difficulty = difficultyArray[diffSelect];

        var hardSongLocked:Bool = difficulty.toLowerCase() == 'hard' && !checkSongFinish(menuItems.members[curSelected].extraData.get("song"), 1); // not unlock mean

        var targetArrow:FlxSprite = (amount < 0 ? difficultyLeft : difficultyRight);
        if (amount != 0) {
        if (amount < 0) {
                if(diffLTween!=null) diffLTween.cancel(); }
            else {
                if(diffRTween!=null) diffRTween.cancel(); }
            targetArrow.offset.x = (amount < 0 ? diffLOffset : diffROffset) + (amount < 0 ? 10 : -10);
            if (amount < 0)
                diffLTween = FlxTween.tween(difficultyLeft.offset, {x: diffLOffset}, 0.5, {ease:FlxEase.quadOut});
            else
                diffRTween = FlxTween.tween(difficultyRight.offset, {x: diffROffset}, 0.5, {ease:FlxEase.quadOut});
        }

        if (diffSpriteTween != null) diffSpriteTween.cancel();
        difficultySprite.scale.set(1.1, 1.1);
        diffSpriteTween = FlxTween.tween(difficultySprite, {'scale.x': 1, 'scale.y': 1}, 1, {ease:FlxEase.expoOut});

        difficultySprite.animation.play(difficulty, true);
        difficultySprite.x = songBGDesc.x + (songBGDesc.width/2) - (difficultySprite.width/2);

        if (diffLockTween != null) diffLockTween.cancel();
        if (hardSongLocked) {
            difficultySprite.color = 0xFF505050;
            diffLockTween = FlxTween.tween(diffLock, {alpha: 1, 'offset.y': diffLockYOffset}, 0.2, {ease:FlxEase.quadOut});
        } else {
            difficultySprite.color = 0xFFFFFFFF;
            diffLockTween = FlxTween.tween(diffLock, {alpha: 0, 'offset.y': diffLockYOffset + 30}, 0.2, {ease:FlxEase.quadIn});
        }

        changeItem(0);
    }

    function checkSongFinish(songName:String = 'discord-annoyer', diff:Int = 1):Bool 
    {
        return Highscore.getScore(songName,diff) >= 100;
    }

    override function beatHit()
    {
        super.beatHit();
        dots.velocity.x = 24 + 20;
        FlxTween.tween(dots.velocity, {x: 24}, Conductor.crochet/1000, {ease : FlxEase.quadOut});
    }

    var lockedTween:FlxTween;
    var lockedTextTween:FlxTween;
    function popLocked(text:String = ''):Void {
        if (lockedTween != null) lockedTween.cancel();
        if (lockedTextTween != null) lockedTextTween.cancel();
        locked.alpha = 1;
        requiredText.text = text; requiredText.alpha = 1;

        lockedTween = FlxTween.tween(locked, {alpha : 0}, 1);
        lockedTextTween = FlxTween.tween(requiredText, {alpha : 0}, 1);
    }

    //? --- SYSTEM --- //?

    private function difficultyDraw():Void {
        if (curPage == 'freeplay') {
            //ifficultyPointLerp = FlxMath.roundDecimal(FlxMath.lerp(difficultyPoint, difficultyPointLerp, elapsed * 5), 8);
            if (difficultyPoint > difficultyPointLerp)
                difficultyPointLerp += FlxG.elapsed*10;
            else if (difficultyPoint < difficultyPointLerp)
                difficultyPointLerp -= FlxG.elapsed*10;
            if (Math.floor(difficultyPointLerp) == difficultyPoint) difficultyPointLerp = difficultyPoint;
            if (lastDiffPoint != Math.floor(difficultyPointLerp)) {
                if (difficultyChartTween != null) difficultyChartTween.cancel();
                difficultyChart.scale.y = 1.05;
                //difficultyChart.colorTransform.redMultiplier = 2;
                //difficultyChart.colorTransform.greenMultiplier = 2;
                //difficultyChart.colorTransform.blueMultiplier = 2;
                difficultyChartTween = FlxTween.tween(difficultyChart, {'scale.y':1}, 0.5, {ease: FlxEase.quadOut});
                FlxG.sound.play(sounds["scroll"], 0.4);
                difficultyChart.animation.frameIndex = Math.floor(difficultyPointLerp);
            }
            lastDiffPoint = difficultyChart.animation.frameIndex;

            if (difficultyPointLerp <= 4) {
                difficultyChart.color = 0xFF66FF52;
            } else if (difficultyPointLerp <= 9) {
                difficultyChart.color = 0xFFF3FF4A;
            } else {
                difficultyChart.color = 0xFFFF5252;
            }
        }
            
        var intensity:Int = (difficulty == 'insane' ? 15 : 5);
        var shakeX:Float = (difficulty == 'hard' || difficulty == 'insane') ? FlxG.random.float(-intensity, intensity) : 0;
        var shakeY:Float = (difficulty == 'hard' || difficulty == 'insane') ? FlxG.random.float(-intensity, intensity) : 0;
        difficultySprite.x = diffBGDesc.x + (diffBGDesc.width/2) - (difficultySprite.width/2) + shakeX;
        difficultySprite.y = songBGDesc.y + songBGDesc.height + 20 + shakeY;

        difficultyLeft.setPosition(difficultySprite.x - difficultyLeft.width - 25 - shakeX, difficultySprite.y + (difficultySprite.height/2) - (difficultyLeft.height/2) - shakeY);
        difficultyRight.setPosition(difficultySprite.x + difficultySprite.width + 25 - shakeX, difficultySprite.y + (difficultySprite.height/2) - (difficultyRight.height/2) - shakeY);

        diffLock.x = difficultySprite.x + (difficultySprite.width/2) - (diffLock.width/2) - shakeX;
        diffLock.y = difficultySprite.y + (difficultySprite.height/2) - (diffLock.height/2) - shakeY;
    }

    private var lastCurSelect:Int = 0;
    private function displayList():Void {
        var elapsed:Float = FlxG.elapsed;
        menuItems.forEachAlive(function(member:MenuText){
            var space:Int = member.partOf == "freeplay" ? 80 : 140;
            var posX:Float = 0;
            if (!member.noMove) {
                if (member.partOf == "main") {
                    var scale:Float = FlxMath.lerp(member.scale.x, (member.objectID == curSelected ? 1.1 : 1), FlxMath.bound(elapsed*13, 0, 1));
                    var shakeX:Float = (ClientPrefs.cute && member.text.toLowerCase() == 'stowy mode' && !(checkSongFinish('furry-appeared') && checkSongFinish('protogen')) ? FlxG.random.float(-10, 10) : 0);
                    member.x = FlxMath.lerp(member.x, 50 + (member.objectID == curSelected ? 40 : 0), FlxMath.bound(elapsed*13, 0, 1)) + posX + shakeX;
                    member.scale.set(scale, scale);
                    member.partner.angle = Math.sin(FlxG.sound.music.time/1000)*5;
                }
                if (member.partOf == "freeplay" || member.partOf == "badges") {
                    if (getSwipeEnable()) {
                        //insert swiping here
                        member.y = member.lastPos.y + swipeDistance;
                        if (!member.extraData.get("isTitle") && Math.abs(member.getGraphicMidpoint().y - (FlxG.height/2)) <= 40)  {
                            curSelected = member.objectID;
                            if (lastCurSelect != curSelected) {
                                FlxG.sound.play(sounds["scroll"]);
                            }
                            lastCurSelect = curSelected;
                        }
                        member.x = FlxMath.lerp(member.x, 140 + (member.objectID == curSelected ? 40 : 0) + -Math.abs(20 * (member.objectID-curSelected)), FlxMath.bound(elapsed*12, 0, 1)) + posX;
                        
                        member.color = ((member.objectID == curSelected || (member.partOf == "freeplay" && member.extraData.get("isTitle"))) ? 0xFFFFFFFF : 0xFFA0A0A0);
                        
                    } else {
                    member.x = FlxMath.lerp(member.x, 140 + (member.objectID == curSelected ? 40 : 0) + -Math.abs(20 * (member.objectID-curSelected)), FlxMath.bound(elapsed*12, 0, 1)) + posX;
                    member.y = FlxMath.lerp(member.y, (360-50) + (member.objectID - curSelected)*space, FlxMath.bound(elapsed*9, 0, 1));
                    }
                }
                if (member.partOf.startsWith('options')) {
                    if (getSwipeEnable() && member.partOf == "options1") {
                        member.y = member.lastPos.y + swipeDistance;
                        member.x = FlxMath.lerp(member.x, 80 + (member.objectID == curSelected ? 40 : 0) + -Math.abs(20 * (member.objectID-curSelected)), FlxMath.bound(elapsed*11, 0, 1)) + posX;
                        if (Math.abs(member.getGraphicMidpoint().y - (FlxG.height/2)) <= 40)  {
                            curSelected = member.objectID;
                            if (lastCurSelect != curSelected) {
                                FlxG.sound.play(sounds["scroll"]);
                            }
                            lastCurSelect = curSelected;
                        }
                        if (optionsList[member.objectID][2] == "cute")
                            member.color = (member.objectID == curSelected ? 0xFFE200F7 : 0xFF9900A7);
                        else
                            member.color = ((member.objectID == curSelected) ? 0xFFFFFFFF : 0xFFA0A0A0);
                    
                    } else {
                        member.x = FlxMath.lerp(member.x, 80 + (member.objectID == curSelected ? 40 : #if MOBILE 40 #else 0 #end) + -Math.abs(20 * (member.objectID-curSelected)), FlxMath.bound(elapsed*11, 0, 1)) + posX;
                        if (member.partOf == "options1")
                            member.y = FlxMath.lerp(member.y, (360-50) + (member.objectID - curSelected)*(member.partOf == "options0" ? 110 : 100), FlxMath.bound(elapsed*8, 0, 1));
                    }
                }
            }
        });
        #if MOBILE
        if (menuItems.members[curSelected] != null && menuItems.members[curSelected].extraData.get('save') == 'delete') {
            var mouseOver:Bool = menuItems.members[curSelected].extraData.get('mouseOver');
            if (FlxG.mouse.pressed && mouseOver && Math.abs(swipeDistance) <= 40) {
                holdOption();
            }
        }
        #end
    }

    private var holdOptionPass:Int = 0;
    private function buttonControls():Void {
        holdOptionPass += 1;
        if (!selectedSomething) {
            if (curPage == 'story menu') {
                if (controls.UI_LEFT_P)
                    {
                        FlxG.sound.play(sounds["scroll"]);
                        changeItem(-1);
                    }
                    if (controls.UI_RIGHT_P)
                    {
                        FlxG.sound.play(sounds["scroll"]);
                        changeItem(1);
                    }
            } else {
                if (controls.UI_UP_P)
                {
                    FlxG.sound.play(sounds["scroll"]);
                    changeItem(-1);
                }
                if (controls.UI_DOWN_P)
                {
                    FlxG.sound.play(sounds["scroll"]);
                    changeItem(1);
                }
                if (curPage == 'freeplay') {
                    if (controls.UI_LEFT_P)
                    {
                        FlxG.sound.play(sounds["scroll"]);
                        changeDiff(-1);
                    }
                    if (controls.UI_RIGHT_P)
                    {
                        FlxG.sound.play(sounds["scroll"]);
                        changeDiff(1);
                    }
                    if(ClientPrefs.developer && FlxG.keys.justPressed.CONTROL)
                    {
                        persistentUpdate = false;
                        openSubState(new GameplayChangersSubstate());
                    }
                }
            }
            if (controls.BACK #if android || FlxG.android.justReleased.BACK #end)
            {
                if (curPage == "main") {
                    FlxG.sound.play(Paths.sound('cancelMenu'));
                    MusicBeatState.switchState(new TitleState());
                } else {
                    if (curPage == 'story menu') {
                        trace('quit story');
                        changeStoryScene(-1);
                    }
                    backItem();
                }
            }
            if (controls.ACCEPT)
                if (menuItems.members[curSelected] != null && menuItems.members[curSelected].partOf == "options1")
                    selectOption(curSelected);
                else
                    selectItem();
            
            if (curPage == 'options1') {
                if (FlxG.keys.pressed.ENTER) {
                    if (menuItems.members[curSelected] != null) 
                        holdOption();
                }
             

                if (holdOptionTime != 0 && holdOptionPass >= 5) {
                    holdOptionTime = 0;
                    FlxG.sound.music.volume = 1;
                }
                
            }

            if (difficultyChosen) {
                difficultyChosen = false;
                playSong();
            }
        }
    }

    private var mouseJustClick:Bool = false;
    private var swipeDistance:Float = 0;
    private var lastSelect:Int = 0;
    private var isSwiping:Bool = false;
    private var dragEnable:Bool = #if MOBILE true #else false #end; //MOBILE
    private var lastHoldPos:FlxPoint;
    private var swipeAvaiable:Array<String> = ['freeplay', 'badges', 'options1', 'options2'];
    private function dragSystem():Void 
    {
        if (!dragEnable) return;
        var pos:FlxPoint = FlxG.mouse.getScreenPosition(FlxG.cameras.list[FlxG.cameras.list.length-1]);
        if (!mouseJustClick && FlxG.mouse.justPressed) {
            mouseJustClick = true;
            lastHoldPos.set(pos.x, pos.y);
            lastSelect = curSelected;
            isSwiping = true;
            menuItems.forEachAlive(function(member:MenuText){
                if (member.partOf.contains(curPage)) {
                    member.setLastPos();
                }
            });
        } else if (mouseJustClick && FlxG.mouse.released) {
            isSwiping = false;
            mouseJustClick = false;
            lastHoldPos.set(Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY);
            if (curPage == 'options1')  for (check in menuChecks) check.alpha = 1;
            changeItem(0);
        }
        if (FlxG.mouse.pressed) {
            swipeDistance = pos.y - lastHoldPos.y; // SWIPE ONLY FOR Y
        }
        FlxG.watch.addQuick("Swipe Distances", swipeDistance);
        FlxG.watch.addQuick("Is Swiping", isSwiping);
    }

    private function getSwipeEnable():Bool {
        #if MOBILE
        return dragEnable && swipeAvaiable.contains(curPage.toLowerCase()) && isSwiping;
        #else
        return false;
        #end
    }

    override function closeSubState() {
		persistentUpdate = true;
		super.closeSubState();
	}
}

class MenuSprite extends FlxSprite
{
    public var objectID:Int = 0;
    public var partner:MenuText;

    public var followPartner:Bool = false;
    public var addX:Float = 0;
    public var addY:Float = 0;

    public var partOf:String = '';
    public var noMove:Bool = false;
	public function new(X:Float = 0, Y:Float = 0, ?SimpleGraphic:Null<flixel.system.FlxAssets.FlxGraphicAsset>)
	{
		super(X, Y, SimpleGraphic);
        antialiasing = ClientPrefs.globalAntialiasing;
	}

    override function update(elapsed:Float)
        {
            super.update(elapsed);
            if (partner != null && followPartner) {
                x = partner.x + addX;
                y = partner.y + addY;
            }
        }
}

class MenuText extends FlxText
{
    public var objectID:Int = 0;
    public var partner:MenuSprite;

    public var partOf:String = '';
    public var noMove:Bool = false;
    public var extraData:Map<String, Dynamic> = new Map<String, Dynamic>();

    public var lastPos:FlxPoint;

    public var checks:Array<CheckSprite> = [];
	public function new(X:Float = 0, Y:Float = 0, FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true)
	{
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
        borderSize = 0.5;
        lastPos = FlxPoint.get(0, 0);
	}

    public function setLastPos():Void {
        lastPos.set(x, y);
    }
}

class Checkbox extends FlxSprite
{
	public var sprTracker:MenuText;
	public var daValue(default, set):Bool;
	public var copyAlpha:Bool = false;
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
    public var objectID:Int = 0;

    public var isPressingOnMe:Bool = false;
	public function new(x:Float = 0, y:Float = 0, ?checked = false) {
		super(x, y);

		frames = Paths.getSparrowAtlas('checkboxanim');
		animation.addByPrefix("unchecked", "checkbox0", 24, false);
		animation.addByPrefix("unchecking", "checkbox anim reverse", 24, false);
		animation.addByPrefix("checking", "checkbox anim0", 24, false);
		animation.addByPrefix("checked", "checkbox finish", 24, false);

		antialiasing = ClientPrefs.globalAntialiasing;
		setGraphicSize(Std.int(0.9 * width));
		updateHitbox();

		animationFinished(checked ? 'checking' : 'unchecking');
		animation.finishCallback = animationFinished;
		daValue = checked;
	}

	override function update(elapsed:Float) {
		if (sprTracker != null) {
			setPosition(sprTracker.x - 130 + offsetX, sprTracker.y + 30 + offsetY);
			if(copyAlpha) {
				alpha = sprTracker.alpha;
			}
		}
		super.update(elapsed);
	}

	private function set_daValue(check:Bool):Bool {
		if(check) {
			if(animation.curAnim.name != 'checked' && animation.curAnim.name != 'checking') {
				animation.play('checking', true);
				offset.set(34, 25);
			}
		} else if(animation.curAnim.name != 'unchecked' && animation.curAnim.name != 'unchecking') {
			animation.play("unchecking", true);
			offset.set(25, 28);
		}
		return check;
	}

	private function animationFinished(name:String)
	{
		switch(name)
		{
			case 'checking':
				animation.play('checked', true);
				offset.set(3, 12);

			case 'unchecking':
				animation.play('unchecked', true);
				offset.set(0, 2);
		}
	}
}

class DifficultyOption extends MusicBeatSubstate
{
    var diff:Array<String> = ['Newbie', 'Classic', 'Challenging'];
    var select:Int = 1;
    var sounds:Map<String, Sound> = MainMenuStateAmmar.sounds;
    var items:Array<FlxText> = [];
    var cooldown:Float = 0.5;
    public function new(camera:FlxCamera)
        {
            super();
            
            var bg:FlxSprite = new FlxSprite().makeGraphic(1300, 800, 0xFF000000);
            bg.cameras = [camera];
            bg.screenCenter();
            add(bg);
            bg.alpha = 0;

            var canvas:FlxSprite = new FlxSprite().makeGraphic(1280, 720, 0x00);
            canvas.cameras = [camera];
            canvas.screenCenter();
            add(canvas);
            FlxSpriteUtil.drawLine(canvas, 0, (720/2) - 50, 1280, (720/2) - 50, {thickness: 5, color: 0x7AFFFFFF});
            FlxSpriteUtil.drawLine(canvas, 0, (720/2) + 50, 1280, (720/2) + 50, {thickness: 5, color: 0x7AFFFFFF});

            canvas.x += 1280;
            FlxTween.tween(canvas, {x: canvas.x - 1280}, 0.5, {ease: FlxEase.quadOut});
            FlxTween.tween(bg, {alpha: 0.75}, 0.5);

            var id:Int = 0;
            for (item in diff) {
                var text:FlxText = new FlxText(0, 0, 400, item, 48, false);
                text.setFormat(Paths.font("Phantomuff/aPhantomMuff Full Letters.ttf"), 48, 0xFFFFFFFF, FlxTextAlign.CENTER);
                var color:FlxColor = 0x900066FF;
                if (item.toLowerCase() == 'newbie') color = 0x90FFD000;
                else if (item.toLowerCase() == 'challenging') color = 0x90FF3300;
                text.setBorderStyle(OUTLINE, color, 4, 1);
                text.cameras = [camera];
                text.screenCenter();
                text.ID = id;
                add(text);
                items.push(text);
                id++;
            }
        }

    override function update(elapsed:Float) {
        if (cooldown > 0)
            cooldown -= elapsed;
        if (controls.BACK) {
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}
        if (controls.UI_UP_P)
            changeItem(-1);
        
        if (controls.UI_DOWN_P)
            changeItem(1);
        
        if (controls.ACCEPT && cooldown <= 0) {
            MainMenuStateAmmar.difficultyChosen = true;
            ClientPrefs.aDifficulty = diff[select].toLowerCase();
            ClientPrefs.saveSettings();
            close();
        }

        for (item in items) {
            var targetY:Float = (720/2) - (item.height/2) + ((item.ID - select) * 80);
            item.y = FlxMath.lerp(item.y, targetY, FlxMath.bound(elapsed*10, 0, 1));
        }
    }

    function changeItem(amount:Int):Void {
        FlxG.sound.play(sounds["scroll"]);
        select += amount;
        select = Std.int(FlxMath.bound(select, 0, diff.length-1));
    }
}

class StorySprite extends FlxSprite
{
    public var tween:FlxTween;
    public var alphatween:FlxTween;
    public var centerx:Float = 0;
    public var centery:Float = 0;
    public var sinY:Bool = false;
    public var sinOff:Float = 0;
    public var zoomSin:Bool = false;
    public var daOrder:Int = 0;

    public function new(x:Float, y:Float, path:String, scaleMultiply:Float = null, orda:Int = 0)
    {
        super(x, y);
        loadGraphic(Paths.image(path));
        if (scaleMultiply != null) {
            setGraphicSize(Std.int(width*scaleMultiply));
            updateHitbox();
        }
        screenCenter();
        centerx = x;
        centery = y;
        daOrder = orda;
    }

    override function update(elapsed:Float):Void {
        if (sinY)
            y = centery + Math.sin((FlxG.game.ticks/800) + sinOff) * 5;
        if (zoomSin) {
            var scal:Float = 1.11 + (Math.sin((sinOff + (FlxG.game.ticks/780))) * 0.1);
            scale.set(scal, scal);
        }
    }
}

class CheckSprite extends FlxSprite
{
    public var objectID:Int = 0;
    public var partner:MenuText;

    public var followPartner:Bool = false;
    public var addX:Float = 0;
    public var addY:Float = 0;

    public var partOf:String = '';
    public var noMove:Bool = false;
    
	public function new(X:Float = 0, Y:Float = 0, difficulty:Int = 1)
	{
		super(X, Y);
        antialiasing = ClientPrefs.globalAntialiasing;

        var path:String = 'ammar/' + MainMenuStateAmmar.difficultyArray[difficulty] +'Tick';
        frames = Paths.getSparrowAtlas(path);
        animation.addByPrefix('idle', 'Checkmark', 10, true);
        animation.play('idle', true);
	}

    override function update(elapsed:Float)
        {
            super.update(elapsed);
            if (followPartner && partner != null) {
                x = partner.x + addX;
                y = partner.y + addY;
            }
        }
}