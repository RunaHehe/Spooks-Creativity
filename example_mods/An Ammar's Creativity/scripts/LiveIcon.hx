import objects.HealthIcon;

var newIconP1:HealthIcon; //Player
var newIconP2:HealthIcon; // Opponent
var idleTimerP1:Float = 0;
var idleTimerP2:Float = 0;

var newIcons:Map<String, Array<String>> = [
    "annoyer" => ["Annoyer", "Annoyer"],
    "ammar" => ["AnAmmar", "Ammar"],
];
var directions:Array<String> = ['left', 'down', 'up', 'right'];
var directionsFlip:Array<String> = ['right', 'down', 'up', 'left'];

function onCreatePost():Void
{
    if (newIcons.exists(game.boyfriend.healthIcon)) {
        final data = newIcons.get(game.boyfriend.healthIcon);
        newIconP1 = new FlxSprite(0, 0);
        newIconP1.frames = Paths.getSparrowAtlas("icons/animated/" + data[0]);
        newIconP1.y = game.healthBar.y - 75;

        newIconP1.visible = !ClientPrefs.data.hideHud;
        newIconP1.alpha = ClientPrefs.data.healthBarAlpha;

        addAnimation(newIconP1, data[1]);
        newIconP1.animation.play('idle', true);
        newIconP1.flipX = true;
        game.uiGroup.add(newIconP1);

        game.iconP1.visible = false;
    }

    if (newIcons.exists(game.dad.healthIcon)) {
        final data = newIcons.get(game.dad.healthIcon);
        newIconP2 = new FlxSprite(0, 0);
        newIconP2.frames = Paths.getSparrowAtlas("icons/animated/" + data[0]);
        newIconP2.y = game.healthBar.y - 75;

        newIconP2.visible = !ClientPrefs.data.hideHud;
        newIconP2.alpha = ClientPrefs.data.healthBarAlpha;

        addAnimation(newIconP2, data[1]);
        newIconP2.animation.play('idle', true);
        game.uiGroup.add(newIconP2);

        game.iconP2.visible = false;
    }
}

function onBeatHit()
{
    if (newIconP1 != null && idleTimerP1 <= 0) 
        newIconP1.animation.play(((game.health / 2 * 100) < 20 ? "lose" : 'idle'), true);

    if (newIconP2 != null && idleTimerP2 <= 0) 
        newIconP2.animation.play(((game.health / 2 * 100) > 80 ? "lose" : 'idle'), true);
    
}

function addAnimation(sprite:FlxSprite, prefix:String):Void
{
    sprite.animation.addByPrefix('idle', prefix + ' Idle');
    sprite.animation.addByPrefix('lose', prefix + ' Lose');
    sprite.animation.addByPrefix('left', prefix + ' Left');
    sprite.animation.addByPrefix('right', prefix + ' Right');
    sprite.animation.addByPrefix('down', prefix + ' Down');
    sprite.animation.addByPrefix('up', prefix + ' Up');
}

function onUpdatePost(elapsed:Float):Void
{
    if (newIconP1 != null) {
        newIconP1.setPosition(game.iconP1.x, game.iconP1.y);
        newIconP1.scale = game.iconP1.scale;
        idleTimerP1 -= elapsed;
    }
    if (newIconP2 != null) {
        newIconP2.setPosition(game.iconP2.x, game.iconP2.y);
        newIconP2.scale = game.iconP2.scale;
        idleTimerP2 -= elapsed;
    }
}

function goodNoteHit(note:Note):Void
{
    if (newIconP1 != null) {
        newIconP1.animation.play(directionsFlip[note.noteData % 4], true);
        idleTimerP1 = Conductor.crochet / 1000;
    }
}

function opponentNoteHit(note:Note):Void
{
    if (newIconP2 != null) {
        newIconP2.animation.play(directions[note.noteData % 4], true);
        idleTimerP2 = Conductor.crochet / 1000;
    }
}