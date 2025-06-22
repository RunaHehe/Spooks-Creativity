import haxe.crypto.Md5;
import sys.io.File;
import sys.FileSystem;
import haxe.Json;
import StringTools;

class ScriptHashBuilder {
    public static function generateHashes():Void {
        var hashMap:Map<String, String> = new Map();

        function scan(dir:String) {
            for (f in FileSystem.readDirectory(dir)) {
                var file:String = cast f;
                var path = dir + "/" + file;
                if (FileSystem.isDirectory(path)) {
                    scan(path);
                } else if (StringTools.endsWith(file, ".lua")) {
                    var content = File.getContent(path);
                    var hash = Md5.encode(content);
                    hashMap.set(path, hash);
                }
            }
        }

        scan("mods");
        scan("assets");

        var json:String = Json.stringify(hashMap, null, "  ");
        File.saveContent("mods/script_hashes.json", json);
        trace("Script hashes saved to mods/script_hashes.json");
    }
}
