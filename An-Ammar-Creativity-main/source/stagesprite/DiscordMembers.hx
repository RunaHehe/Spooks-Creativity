package stagesprite;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import AttachedSprite;

using StringTools;

class DiscordMembers extends FlxSprite
{
    public var daMembers:Array<String> =
    ["Ammar", "Ams", "An Ammar Plumber", "Annoyer", "Asser", "Danny14", "IdiotXD", "NotAlpha", 
    "Pakachi", "Professor", "Random Girl", "Random", "Sirnotify", "Spook", "Swordsy", "Tabbee", 
    "Vander", "Virus"];
    public var members:Array<AttachedSprite> = [];
    public var categories:Array<AttachedSprite> = [];

    private var ownerList:Array<String> = ['Ammar'];
    private var modList:Array<String> = ['Professor', 'Sirnotify'];
    private var boosterList:Array<String> = ['Tabbee'];

    private var organizeMembers:Array<String> = [];

    private var index:Int = 0;
    private var space:Float = 40;
    private var offsetX:Float = 7;
    private var categoryOffX:Float = 16 + 7;

    public var defaultX:Float = 0;
    var distanceScroll:Float = 0;
    public function new(x:Float, y:Float)
    {
        super(x,y);

        //Da BG!!
        loadGraphic(Paths.image("MembersListBG"));
        setGraphicSize(Std.int(width*0.85));
        updateHitbox();
        scrollFactor.set(0, 0);

        distanceScroll = height - 720; 

        daMembers.sort(sortAlphabet);
        for (item in ownerList) if (daMembers.contains(item)) organizeMembers.push(item);
        for (item in modList) if (daMembers.contains(item)) organizeMembers.push(item);
        for (item in boosterList) if (daMembers.contains(item)) organizeMembers.push(item);
        for (item in daMembers) if (!organizeMembers.contains(item)) organizeMembers.push(item);
        
        //Add Loading Users when less users display
        if (organizeMembers.length <= 12)
            for (item in 0...(17 - organizeMembers.length))
                organizeMembers.push("User" + FlxG.random.int(1,3));

        for (item in organizeMembers) {
            if (item == "Ammar" || item == "Professor" || item == "Tabbee" || item == "Ams") // New Category
                space += 40;

            var member = new AttachedSprite('members/'+item);
            member.setGraphicSize(Std.int(member.width * 0.75));
            member.updateHitbox();
            member.yAdd = index * 66 + space;
            member.xAdd = offsetX;
            member.sprTracker = this;
            index += 1;
            members.push(member);
            
            Paths.image('members/'+item+" L");
    
            if (item == "Ammar") 
                addCategory("Content Creator", member); //! OWNER NOT CONTENT CREATOR
            else if (item == "Professor")
                addCategory("Moderator", member);
            else if (item == "Tabbee")
                addCategory("Server Booster", member);
            else if (item == "Ams")
                addCategory("Member", member);
        }
    }

    private function addCategory(pathName:String, nextMember:AttachedSprite) {
        var category = new AttachedSprite('category/$pathName'); //! OWNER NOT CONTENT CREATOR
        category.setGraphicSize(Std.int(category.width * 0.75));
        category.updateHitbox();
        category.yAdd = nextMember.yAdd - 18;
        category.xAdd = categoryOffX;
        category.sprTracker = this;
        categories.push(category);

        Paths.image('category/$pathName L');
    }

    private function sortAlphabet(a:String, b:String):Int
    {
        a = a.toUpperCase();
        b = b.toUpperCase();
      
        if (a < b) {
          return -1;
        }
        else if (a > b) {
          return 1;
        } else {
          return 0;
        }
    }

    public var beatTween:FlxTween;
    public var scrollTween:FlxTween;
    public var beatPhase(default, set):Int = 1; // 1 = Beat, 2 = Moving Up and Down FAST
    public var intensity:Float = 16;
    public function stepHit(step:Int):Void {
        if (step % 8 == 2) {
            if (beatTween != null)
                beatTween.cancel();
            beatTween = FlxTween.tween(this, {x: defaultX + intensity}, Conductor.crochet/1000/2, {ease: FlxEase.circIn, onComplete: function(tw:FlxTween){beatTween = null;}});
        }
        if (step % 8 == 4) {
            if (beatTween != null)
                beatTween.cancel();
            beatTween = FlxTween.tween(this, {x: defaultX}, Conductor.crochet/1000, {ease: FlxEase.quadOut, onComplete: function(tw:FlxTween){beatTween = null;}});
        }

        //Scroll
        if (step % 64 == 0) {
            if (scrollTween != null)
                scrollTween.cancel();
            var targetY:Float = step%128 == 64 ? 50 : 50 - distanceScroll;
            scrollTween = FlxTween.tween(this, {y: targetY}, Conductor.crochet/1000*12, {ease: FlxEase.sineInOut, onComplete: function(tw:FlxTween){scrollTween = null;}});
        }
    }

    private function set_beatPhase(value:Int):Int {
        if (value != beatPhase && value == 2)
            if (scrollTween != null)
                scrollTween.cancel();

        beatPhase = value;
		return value;
    }
}