#if (!macro) 
import Paths;
import flixel.*;

#if android
import android.content.Context as AndroidContext;
import android.widget.Toast as AndroidToast;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;i have
import android.Settings as AndroidSettings;
import android.Tools as AndroidTools;
import android.os.BatteryManager as AndroidBatteryManager;
#end

#if sys
import sys.FileSystem;
import sys.io.File;
#end
import Section.SwagSection;
import Song;
import MusicBeatSubstate;
#end
//meow i love importing meow rub my chin and pat my ears meow meow

#if LEATHER
import states.PlayState;
import game.Song;
import game.Section.SwagSection;
import game.Note;
import ui.FlxScrollableDropDownMenu;
import ui.FlxUIDropDownMenuCustom;
import game.Conductor;
import utilities.CoolUtil;
import game.StrumNote;
import utilities.NoteVariables;
import states.LoadingState;
import states.MusicBeatState;
import substates.MusicBeatSubstate;
#elseif (PSYCH && PSYCHVERSION >= "0.7")
import flixel.addons.ui.FlxUIDropDownMenu;
import backend.Section.SwagSection;
import states.PlayState;
import backend.CoolUtil;
import backend.Conductor;
import backend.ClientPrefs;
import backend.Paths;
import states.LoadingState;
import backend.Difficulty;
#if SCEmodchart.modchartingTools
import substates.MusicBeatSubstate;
#else
import backend.MusicBeatSubstate;
#end
import objects.Note;
#if SCEmodchart.modchartingTools
import objects.StrumArrow;
#else
import objects.StrumNote;
#end
import backend.Song;
#else
#end
#if (PSYCH && PSYCHVERSION >= "0.7")
#if LUA_ALLOWED
import psychlua.FunkinLua;
import psychlua.HScript as FunkinHScript;
#end
#end