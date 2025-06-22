import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import haxe.crypto.Md5;
import StringTools;
import haxe.ds.StringMap;
import Reflect;
import sys.io.Process;
import lime.app.Application;

class ScriptIntegrityChecker {
    public static var HASH_FILE:String = "mods/script_hashes.json";

    public static function check():Void {
        try {
            if (!FileSystem.exists(HASH_FILE)) {
                trace("script_hashes.json not found, skipping integrity check.");
                return;
            }

            var content = File.getContent(HASH_FILE);
            var raw = Json.parse(content);

            if (raw == null) {
                trace("script_hashes.json is empty or malformed, skipping integrity check");
                return;
            }

            var expected = new StringMap<String>();
            for (key in Reflect.fields(raw)) {
                expected.set(key, Reflect.field(raw, key));
            }

            var current = new StringMap<String>();

            function scan(dir:String) {
                for (f in FileSystem.readDirectory(dir)) {
                    var file:String = cast f;
                    var path = dir + "/" + file;
                    if (FileSystem.isDirectory(path)) {
                        scan(path);
                    } else if (StringTools.endsWith(file, ".lua")) {
                        var content = File.getContent(path);
                        var hash = Md5.encode(content);
                        current.set(path, hash);
                    }
                }
            }

            scan("mods");
            scan("assets");

            for (key in expected.keys()) {
                if (!current.exists(key)) {
                    crash("script deleted: " + key);
                } else if (expected.get(key) != current.get(key)) {
                    crash("script modified: " + key);
                }
            }

            for (key in current.keys()) {
                if (!expected.exists(key)) {
                    crash("script added: " + key);
                }
            }
        } catch (e:Dynamic) {
            trace("uh oh: " + e);
        }
    }

    static function crash(reason:String):Void {
        trace("ALERT ALERT " + reason);
        Application.current.window.alert(
            "EDITED SCRIPT DETECTED:\n" + reason + "\n\nDO NOT EDIT FILES",
            "meow i close game now"
        );
        Sys.exit(1);
    }
}
