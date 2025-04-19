import funkin.backend.utils.DiscordUtil.DUser;
import funkin.backend.utils.HttpUtil;
import haxe.Json;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.utils.ByteArray;
import sys.FileSystem;
import sys.io.File;

class DownloadProfiles
{
	public static function download(userData:Array<Dynamic>, forceDownload:Bool = false)
	{
		trace('Downloading...');
		var modFolder:String = Paths.getAssetsRoot();
		for (data in userData)
		{
			if (data[0] == '0')
				continue;
			var imagePath:String = getImageMod("profiles/" + data[1]);
			if (!FileSystem.exists(imagePath) || forceDownload)
			{
				var imagePFP:BitmapData = getUserPFP(data[0], 128);
				saveBitmap(imagePFP, modFolder + "/stages/discord/images/profiles/" + data[1]);
				trace('+ Installed | ' + data[1] + ".png");
				PlayState.instance.scripts.set("__installedProfiles", [data[2], imagePFP]);
			}
		}
	}

	static function getUserPFP(userId:String, size = 256):BitmapData
	{
		var userDataParsed = Json.parse(HttpUtil.requestText("https://discordlookup.mesalytic.moe/v1/user/" + userId)).raw;
		var daUser = new DUser();
		daUser.userId = userId;
		daUser.avatar = userDataParsed.avatar;
		return daUser.getAvatar(size);
	}

	static function saveBitmap(image:BitmapData, path:String)
	{
		var bytes:ByteArray = image.encode(image.rect, new PNGEncoderOptions());
		File.saveBytes(path + ".png", bytes);
	}

	static function getImageMod(path:String):String
	{
		return Paths.getAssetsRoot() + "/stages/discord/images/" + path + ".png";
	}
}