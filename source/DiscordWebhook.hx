import openfl.net.URLRequest;
import openfl.net.URLRequestMethod;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;

class DiscordWebhook
{
    public static function send(content:String, webhookUrl:String):Void
    {
        var request = new URLRequest(webhookUrl);
        request.method = URLRequestMethod.POST;
        request.contentType = "application/json";

        var payload = {
            content: content
        };

        request.data = haxe.Json.stringify(payload);

        var loader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.TEXT;
        loader.load(request);
    }
}