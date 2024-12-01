package antidebug;

import openfl.utils.Assets;
import flixel.util.FlxSave;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import flixel.util.FlxTimer;
import openfl.utils.AssetType;

using StringTools;

class DebugSave {

    public static var folderInSongData:Array<String> = [];
    public static var filesInStages:Array<String> = [];
    public static var anticheat:Bool = false;
    public static function loadAntiDebug() {
        reloadFilesOnSource();

        // openfl.Lib.current.stage.application.onExit.add(function(code) {
        //     trace('Anti-Debug Save');
        // });
    }
    public static function reloadFilesOnSource():Void  {
        #if (sys && desktop)
        if (!anticheat) return;
        folderInSongData = []; filesInStages = [];
        var allembed:Array<String> = Assets.list(AssetType.TEXT);
        var newArrayEmbed:Array<String> = [];
        for (file in allembed) {
            if (file.startsWith('songdata/')) {
                newArrayEmbed.push(file);
            } else if (file.startsWith('stages_embed/')) {
                filesInStages.push(file);
            }
        }
        folderInSongData = newArrayEmbed;
        #end


        
    }
    /* It Impossible
    public static function saveFilesOnSource(_songName:String = 'discord-annoyer'):Void  {
        final songName:String = Paths.formatToSongPath(_songName);
        final path:String = 'assets/data/$songName';
        var filesInFolder:Array<String> = FileSystem.readDirectory(path);

        var filesInFolderOG:Array<String> = []; // with assets/songdata/.../
        for (file in folderInSongData) {
            if (file.startsWith('songdata/$songName')) filesInFolderOG.push(file);
        }

        for (file in filesInFolder) {
            File.copy('$path/$file', 'songdata/$songName/$file');
            //File.copy(daPath, '$path/$file');
            
        }


    }*/
    public static function updateFolder(_songName:String = 'discord-annoyer'):Void {
        if (ClientPrefs.developer || !anticheat) return;
        #if (sys && desktop)
        final songName:String = Paths.formatToSongPath(_songName);
        final pathOG:String = 'songdata/$songName';
        final path:String = 'assets/data/$songName';

        trace('replacing... $songName at $path');


        var filesInFolder:Array<String> = FileSystem.readDirectory(path);
        var filesInFolderOG:Array<String> = []; // with assets/songdata/.../
        for (file in folderInSongData) {
            if (file.startsWith('songdata/$songName')) filesInFolderOG.push(file);
        }

        for (file in filesInFolder) {
            final daPath:String = '$path/$file';
            FileSystem.deleteFile(daPath);
        }
        try {
            for (file in filesInFolderOG) {
                final text:String = Assets.getText(file);
                File.saveContent(file.replace('songdata', 'assets/data'), text);
                
            }
        } catch (e:Dynamic) {
           trace(e);
        }

        trace('replaced $songName\'s successfully');
        updateScriptsMod();
        updateStages();
        #end
    }

    public static final scriptPath:String = 'mods/An Ammar\'s Creativity/scripts';
    public static final scripts:Array<String> = ['0_LibraryPath.lua', 'death.lua'];
    public static final scriptsModule:Array<String> = ['Beat.lua', 'SpriteUtil.lua', 'Timer.lua', 'TweenModule.lua'];
    public static function updateScriptsMod():Void {
        #if (sys && desktop)
        var filesInFolder:Array<String> = FileSystem.readDirectory(scriptPath);
        //delete files first
        for (file in filesInFolder) {
            final daPath:String = '$scriptPath/$file';
            if (FileSystem.isDirectory(daPath)) {
                var filesInFolder2:Array<String> = FileSystem.readDirectory(daPath);
                for (file2 in filesInFolder2) {
                    FileSystem.deleteFile('$daPath/$file2');
                }
            } else {
                FileSystem.deleteFile(daPath);
            }
        }

        for (file in scripts) { //save scripts folder
            final text:String = Assets.getText('scripts_embed/$file');
            File.saveContent('$scriptPath/$file', text);
        }
        for (file in scriptsModule) { //save module folder
            final text:String = Assets.getText('scripts_embed/modules/$file');
            File.saveContent('$scriptPath/modules/$file', text);
        }

        trace('- Replace Scripts');
        #end
    }

    public static final stagesPath:String = 'mods/An Ammar\'s Creativity/stages';
    public static final stages:Array<String> = ['ammarvoid', 'demonbg', 'discordStage', 'hackerstage', 'HQ', 'kaijuparadise', 'malfunction', 'scratch', 'twitterStage', 'youtubeStage'];
    public static function updateStages():Void {
        #if (sys && desktop)
        var filesInFolder:Array<String> = FileSystem.readDirectory(stagesPath);
        for (file in filesInFolder) {
            final daPath:String = '$stagesPath/$file';
            FileSystem.deleteFile(daPath);
        }

        for (file in filesInStages) { //save module folder
            final text:String = Assets.getText(file);
            File.saveContent(file.replace('stages_embed', 'mods/An Ammar\'s Creativity/stages'), text);
        }
        
        trace('- Replace Stages');
        #end
    }
}