package stagesprite;

import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import stagesprite.AttachedNormalText;
import Note;
import Vocals.VocalsData;

class DiscordUser extends FlxSprite {
    public static var vocals:Array<VocalsData>;

    public var message:AttachedNormalText;
    public var myTurn:Bool = true;
    public var otherUser:DiscordUser;

    //EE, OO, AA, EAH
    public var lyrics:Array<Array<Array<String>>> = [
        [['e'], ['e'], ['']], 
        [['o'], ['o'], ['']],
        [['a'], ['a'], ['h']], 
        [['e'], ['e'], ['h']]
    ];

    public var emptyText:String = '...';
    public var typingText:String = '(The person is typing...)';

    public var timer:Float = 0;
    public var noteIsNear:Bool = false;

    public var curCharacter:String = '';
    var chars:Map<String, String> = [
        'ammar-happy' => 'Ammar',
        'annoyer-happy' => 'Annoying User',
        'annoyer-sad' => 'Annoying User',
        'deleted-user' => 'Deleted User Dark',
        'deleted-user-insane' => 'Deleted User',
        'mod-happy' => 'Moderator',
        'mod-neutral' => 'Moderator',
        'random-girl' => 'Random Girl'
    ];

    private var isOpponent:Bool = false;
    private var deletingMsg:Bool = false;
    
    public function new(isOpponent:Bool = false, imageName:String) {
        super(0, 0);
        
        curCharacter = chars[imageName];

        loadGraphic(Paths.image('chars/$curCharacter'));
        setGraphicSize(Std.int(649*0.625), Std.int(146*0.625));
        updateHitbox();
        antialiasing = ClientPrefs.globalAntialiasing;
        scrollFactor.set(0, 0);

        message = new AttachedNormalText(emptyText, 505, 24);
        message.font = Paths.font('Discord/ggsans-Medium.ttf');

        message.sprTracker = this;
        message.offsetX = 103;
        message.offsetY = 40;

        this.isOpponent = isOpponent;
    }

    var targetY:Float = 0;
    var discordSpace:Float = 10;
    var game:PlayState = PlayState.instance;
    override function update(elapsed:Float) {
        targetY = (myTurn ? (720/2)+discordSpace : (720/2)-discordSpace-height-((message.textField.numLines -1 ) * 33));
        x = 320;
        y = FlxMath.lerp(y, targetY, FlxMath.bound(elapsed*7, 0, 1));

        if (!isNotAMessage()) {
            if (timer >= 1) {
                deletingMsg = true;
                message.text = message.text.substr(0, message.text.length- (1+Math.floor(elapsed)));
                if (message.text.length < 3) {
                    message.text = emptyText;
                    deletingMsg = false;
                }
            } else {
                timer += elapsed;
                deletingMsg = false;
            }
        }

        //Check Note Near
        if (game.notes.length >= 1) {
            for (i in 0...(game.notes.length-1)) {
                var daNote:Note = game.notes.members[(game.notes.length-1) - i];
                noteIsNear = (daNote != null && ((!isOpponent && daNote.mustPress) || (isOpponent && !daNote.mustPress)) && daNote.distance < 200);
            }
        } else {
            noteIsNear = false;
        }

        if (noteIsNear) {
            if (message.text == emptyText)
                message.text = typingText;
        } else {
            if (message.text == typingText)
                message.text = emptyText;
        }

        super.update(elapsed);
    }

    var lastNotes:Array<Note> = []; //Double, Triple Note Checker 
    public function addText(note:Note) {
        if (isNotAMessage() || deletingMsg)
            message.text = '';
        var additionText:String = '';

        if (!isSameStrumTime(note)) {
            while (lastNotes.length > 3)
                lastNotes.pop();

            if (message.textField.numLines > 5) message.text = '';
            var isNextSus:Bool = false;
            if (note != null && note.nextNote != null) isNextSus = note.nextNote.isSustainNote;
            var endSustain:Bool = isNextSus && note.isSustainNote;
            var singArray:Array<String> = lyrics[note.singData][(endSustain ? 2 : (note.isSustainNote ? 1 : 0))];
            additionText = (message.text.length <= 0 || note.isSustainNote ? '' : ' ') + singArray[FlxG.random.int(0, singArray.length-1)];
            lastNotes.push(note);

            timer = 0;
        }
        
        message.text += additionText;
    }
    public function deleteMessage():Void {
        timer = 5;
    }
    public function changeChar(charName:String):Void {
        curCharacter = chars[charName];

        loadGraphic(Paths.image('chars/$curCharacter'));
        setGraphicSize(Std.int(649*0.625), Std.int(146*0.625));
        updateHitbox();
    }

    private function isSameStrumTime(note:Note):Bool {
        if (lastNotes.length <= 0) return false;
        for (prevNote in lastNotes) {
            if (prevNote.strumTime == note.strumTime)
                return true;
        }

        return false;
    }
    private function isNotAMessage():Bool {
        return (message.text == typingText || message.text == emptyText);
    }

}