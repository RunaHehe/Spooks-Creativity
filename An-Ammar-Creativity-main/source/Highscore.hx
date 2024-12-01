package;

import flixel.FlxG;

using StringTools;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map();
	public static var songRating:Map<String, Float> = new Map();
	public static var songMisses:Map<String, Int> = new Map();
	#else
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songRating:Map<String, Float> = new Map<String, Float>();
	public static var songMisses:Map<String, Int> = new Map(String, Int);
	#end

	#if (haxe >= "4.0.0")
	public static var songHighscore:Map<String, Map<String, Float>> = new Map();
	public static var weekHighscore:Map<String, Map<String, Float>> = new Map();
	#else
	public static var songHighscore:Map<String, Map<String, Float>> = new Map<String, Map<String, Float>>();
	public static var weekHighscore:Map<String, Map<String, Float>> = new Map<String, Map<String, Float>>();
	#end
	// song(-difficulty) -> songData

	public static function resetSong(song:String, diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		if (!songHighscore.exists(daSong)) 
		{
			createNewSongData(song, diff);
		}

		setScore(daSong, 0);
		setRating(daSong, 0);
		setMiss(daSong, 0);
	}

	public static function resetWeek(week:String, diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0);
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if(decimals < 1)
		{
			return Math.floor(value);
		}

		var tempMult:Float = 1;
		for (i in 0...decimals)
		{
			tempMult *= 10;
		}
		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	public static function saveScore(song:String, diff:Int = 0, score:Int = 0, ?rating:Float = -1, ?misses:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songHighscore.exists(daSong)) 
		{
			var songData = songHighscore.get(daSong);
			if (songData.get('score') < score) {
				setScore(daSong, score);
				if(rating >= 0) setRating(daSong, rating);
				setMiss(daSong, misses);
			}
		} else {
			createNewSongData(song, diff);
			setScore(daSong, score);
			setRating(daSong, rating);
			setMiss(daSong, misses);
		}

		/*if (songScores.exists(daSong)) {
			if (songScores.get(daSong) < score) {
				setScore(daSong, score);
				if(rating >= 0) setRating(daSong, rating);
				setMiss(daSong, misses);
			}
		}
		else {
			setScore(daSong, score);
			if(rating >= 0) setRating(daSong, rating);
			setMiss(daSong, misses);
		}*/
	}

	public static function saveWeekScore(week:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);

		if (weekHighscore.exists(daWeek))
		{
			if (weekHighscore[daWeek].get('score') < score)
				setWeekScore(daWeek, score);
		}
		else {
			weekHighscore.set(daWeek, ['score' => 0]);
			trace(daWeek);
			setWeekScore(daWeek, score);
		}
	}

	static function  createNewSongData(songName:String, diff:Int = 1):Void {
		songHighscore.set(formatSong(songName, diff), ['score' => 0, 'miss' => 0, 'rating' => 0]);
	}


	static function setScore(song:String, score:Int, diff:Int = 1):Void
	{
		(songHighscore.get(song)).set('score', score);
		FlxG.save.data.songHighscore = songHighscore;
		FlxG.save.flush();
	}
	static function setWeekScore(week:String, score:Int):Void
	{
		(weekHighscore.get(week)).set('score', score);
		FlxG.save.data.weekHighscore = weekHighscore;
		FlxG.save.flush();
	}
	static function setRating(song:String, rating:Float, diff:Int = 1):Void
	{
		(songHighscore.get(song)).set('rating', rating);
		FlxG.save.data.songHighscore = songHighscore;
		FlxG.save.flush();
	}
	static function setMiss(song:String, miss:Int, diff:Int = 1):Void
	{
		(songHighscore.get(song)).set('miss', miss);
		FlxG.save.data.songHighscore = songHighscore;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		return Paths.formatToSongPath(song) + CoolUtil.getDifficultyFilePath(diff);
	}

	public static function getScore(song:String, diff:Int):Int
	{
		var daSong:String = formatSong(song, diff);
		if (!songHighscore.exists(daSong))
			createNewSongData(song, diff);

		return Std.int((songHighscore.get(daSong)).get('score'));
	}

	public static function getRating(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songHighscore.exists(daSong))
			createNewSongData(song, diff);

		return (songHighscore.get(daSong)).get('rating');
	}

	public static function getWeekScore(week:String, diff:Int):Int
	{
		var daWeek:String = formatSong(week, diff);
		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0);

		return weekScores.get(daWeek);
	}

	public static function getMiss(song:String, diff:Int):Int
		{
			var daSong:String = formatSong(song, diff);
			if (!songHighscore.exists(daSong))
				createNewSongData(song, diff);

			return Std.int((songHighscore.get(daSong)).get('miss'));
		}

	public static function load():Void
	{
		if (FlxG.save.data.songHighscore != null)
			songHighscore = FlxG.save.data.songHighscore;

		if (FlxG.save.data.weekHighscore != null)
			weekHighscore = FlxG.save.data.weekHighscore;

		/*
		if (FlxG.save.data.weekScores != null)
		{
			weekScores = FlxG.save.data.weekScores;
		}
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songRating != null)
		{
			songRating = FlxG.save.data.songRating;
		}
		if (FlxG.save.data.songMisses != null)
		{
			songMisses = FlxG.save.data.songMisses;
		}*/
	}

	public static function getBadge(name:String):Void
		{
			var badges:Array<String> = ClientPrefs.badges;
			badges.push(name);
			ClientPrefs.badges = badges;

			FlxG.save.flush();
		}

	
	
	public static function calculateProgress():Void {
		var songs:Array<String> = [];
		for (songArray in MainMenuStateAmmar.songsList) {
			if (songArray['song'] != 'Furry Appeared' && songArray['song'] != 'Protogen' && songArray['song'] != 'Furry Femboy')
			songs.push(songArray['song']);
		}
		var progress:Float = 0;
		final totalSongs:Int = songs.length;
		var songsFinished:Int = 0;

		for (song in songs) {
			if (songHighscore.exists(formatSong(song, 1))) {
				if (songHighscore[formatSong(song, 1)].get('score') >= 1000) {
					songsFinished += 1;
				}
			}
		}

		progress = songsFinished / totalSongs;
		FlxG.save.data.progress = progress;
		FlxG.save.flush();
	}

}