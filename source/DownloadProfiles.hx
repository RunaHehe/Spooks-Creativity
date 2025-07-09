import funkin.backend.utils.DiscordUtil.DUser;
import haxe.Json;
import haxe.Http;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.utils.ByteArray;
import sys.FileSystem;
import sys.io.File;
import lime.system.ThreadPool;

class DownloadProfiles
{
	public static var tp:ThreadPool;
	// static var numThreads:Int;

	public static function downloadAsync(userData:Array<Dynamic>, forceDownload:Bool = true, maxThreads:Int)
	{
		trace('Downloading avatars...');

		var folderPath:String = "mods/Spook's Creativity/images/profiles/";
		if (!FileSystem.exists(folderPath))
			FileSystem.createDirectory(folderPath);

		tp = new ThreadPool(0, maxThreads);

		for (data in userData)
		{
			if (data[0] == '0')
				continue;
			var imagePath:String = getImagePath(data[1]);

			if (!FileSystem.exists(imagePath) || forceDownload)
			{
				tp.queue((_:Dynamic) -> downloadPFPAsync(data[0], data[1], data[2]));

			}
		}
		tp.onComplete.add((_) ->
		{
			trace('downloads complete i guess Uwu');
		});
	}

	// downloads the profiles and... stuff.

	static function downloadPFPAsync(userId:String, fileName:String, spriteName:String)
	{
		trace("hello! this trace is to tell you that this is being called correctly");
		var userInfoUrl = "https://profiledownloaders.vercel.app/v1/user/" + userId;
		var http = new Http(userInfoUrl);

		http.onData = function(response:String)
		{
			try
			{
				var userDataParsed = Json.parse(response).raw;
				var avatarId:String = userDataParsed.avatar;
				var avatarURL = 'https://cdn.discordapp.com/avatars/$userId/$avatarId.png?size=128';

				// download avatar :3
				var avatarHttp = new Http(avatarURL);

				avatarHttp.onBytes = function(bytes:haxe.io.Bytes)
				{
					try
					{
						var byteArray = ByteArray.fromBytes(bytes);
						var bitmapData = BitmapData.fromBytes(byteArray);

						saveBitmap(bitmapData, fileName);
						trace('+ Installed profile | ' + fileName + ".png");
					}
					catch (err)
					{
						trace('[Bitmap Error] Failed to decode avatar image: ' + err);
					}
				}

				avatarHttp.onError = function(err)
				{
					trace('[Avatar Error] Couldn\'t fetch avatar image: ' + err);
				}

				avatarHttp.request(); // start avatar download
			}
			catch (e)
			{
				trace('[Download Error] Failed to parse user data for ' + userId + ': ' + e);
			}
		}

		http.onError = function(error:String)
		{
			trace('[Download Error] Couldn\'t fetch user info: ' + error);
		}

		http.request(); // start user info request
	}

	static function saveBitmap(image:BitmapData, fileName:String)
	{
		var path = "mods/Spook's Creativity/images/profiles/" + fileName + ".png";
		var bytes:ByteArray = image.encode(image.rect, new PNGEncoderOptions());
		File.saveBytes(path, bytes);
	}

	static function getImagePath(fileName:String):String
	{
		return "mods/Spook's Creativity/images/profiles/" + fileName + ".png";
	}
}
