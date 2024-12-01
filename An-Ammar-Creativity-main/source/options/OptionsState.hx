package options;

import flixel.input.mouse.FlxMouseEvent;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = [/*'Note Colors', */#if desktop 'Controls',#end 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay'];
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	function openSelectedSubstate(label:String) {
		switch(label) {
			case 'Note Colors':
				openSubState(new options.NotesSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;

	var downButton:FlxSprite;
	var upButton:FlxSprite;
	var acceptButton:FlxSprite;
	
	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFea71fd;
		bg.updateHitbox();

		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true);
			optionText.screenCenter();
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);

			#if MOBILE
			FlxMouseEvent.add(null, function(option:Alphabet){
				curSelected = options.indexOf(option.text);
				openSelectedSubstate(options[curSelected]);
			});
			#end
		}

		selectorLeft = new Alphabet(0, 0, '>', true);
		selectorRight = new Alphabet(0, 0, '<', true);
		#if !MOBILE
		add(selectorLeft);
		add(selectorRight);
		#end

		downButton = new FlxSprite().loadGraphic(Paths.image('mobile/right'));
        downButton.setGraphicSize(Std.int(downButton.width * 0.5)); downButton.updateHitbox();
        downButton.x = 0; downButton.y = 720 - downButton.height;
        downButton.alpha = 0.4;
		downButton.angle = 90;
		
		upButton = new FlxSprite().loadGraphic(Paths.image('mobile/right'));
        upButton.setGraphicSize(Std.int(upButton.width * 0.5)); upButton.updateHitbox();
        upButton.x = 0; upButton.y = 0;
        upButton.alpha = 0.4;
		upButton.angle = -90;
		
		acceptButton = new FlxSprite().loadGraphic(Paths.image('mobile/accept'));
        acceptButton.setGraphicSize(Std.int(acceptButton.width * 0.5)); acceptButton.updateHitbox();
        acceptButton.x = 0; acceptButton.screenCenter(Y);
        acceptButton.alpha = 0.4;
		
		#if MOBILE
        add(downButton);
        add(upButton);
        add(acceptButton);

		FlxMouseEvent.add(downButton, null, function(_){
			changeSelection(1);
		}, null, null, false, true, false);
		FlxMouseEvent.add(upButton, null, function(_){
			changeSelection(-1);
		}, null, null, false, true, false);
		FlxMouseEvent.add(acceptButton, null, function(_){
			openSelectedSubstate(options[curSelected]);
		}, null, null, false, true, false);
		#end

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function closeSubState() {
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UI_UP_P) {
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P) {
			changeSelection(1);
		}

		if (controls.BACK #if android || FlxG.android.justReleased.BACK #end) {
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuStateAmmar());
		}

		if (controls.ACCEPT) {
			openSelectedSubstate(options[curSelected]);
		}
	}
	
	function changeSelection(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}