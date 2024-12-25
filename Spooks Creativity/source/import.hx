#if (!macro) 
import Paths;
import flixel.*;

#if android
import android.content.Context as AndroidContext;
import android.widget.Toast as AndroidToast;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
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