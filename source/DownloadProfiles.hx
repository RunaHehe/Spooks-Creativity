import funkin.backend.utils.DiscordUtil.DUser;
import haxe.Json;
import haxe.Http;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.utils.ByteArray;
import sys.FileSystem;
import sys.io.File;

class DownloadProfiles
{
	public static function downloadAsync(userData:Array<Dynamic>, forceDownload:Bool = false)
	{
		trace('Downloading avatars...');

		var folderPath:String = "mods/Spook's Creativity/images/profiles/";
		if (!FileSystem.exists(folderPath))
			FileSystem.createDirectory(folderPath);

		for (data in userData)
		{
			if (data[0] == '0') continue;

			var imagePath:String = getImagePath(data[1]);

			if (!FileSystem.exists(imagePath) || forceDownload)
			{
				downloadPFPAsync(data[0], data[1], data[2]);
			}
		}
	}
	//downloads the profiles and... stuff.
	//you not even sure what it does
	//yesiam
	//no
	//yes
	//no
	//yes
	//i love u
	//stop making me blush

	static function downloadPFPAsync(userId:String, fileName:String, spriteName:String)
	{
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