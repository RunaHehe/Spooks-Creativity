local questions = {
   {"11 + 14 = ?", "25", "23", "27", "26",    "25"},  --question, [options 1, 2, 3, 4], Answer
   {"75 + 7 = ?", "82", "72", "84", "81",    "82"},
   {"Who made this mod?", "An Ammar", "SirDusterBuster", "Rorutop", "YingYang48", "An Ammar"},
   {"What engine this mod use?", "Kade Engine", "Yoshi Engine", "Psych Engine", "Andromeda Engine",  "Psych Engine"},
   {"Who is the Main Programmer of this engine?", "Shadow Mario", "Shubs", "bb-panzu", "ninjamuffin99", "Shadow Mario"}, 
   {"98 + 12 = ?", "111", "109", "108", "110", "110"},
   {"How many letters are there in the alphabet?", "26", "24", "28", "22", "26"},
   {"Which is hotter?", "Active Lightbulb", "Active computer box", "Boiling water", "Steam", "Steam"},
   {"How many Toes does average cat have?", "18", "10", "12", "16", "18"},
   {"When Covid-19 Start?", "2019", "2020", "2021", "2018", "2019"},
   {"What month does FNF release?", "October", "August", "March", "December", "October"}
}

local usedQuestion = {}
questionTimer = 0;

textGroup = {"answerA", "answerB", "answerC", "answerD", "questionText", "timerText"}
local mechanic = false
function onCreatePost()
   mechanic = getDataFromSave("ammarc", "mechanic")
   makeText("timerText", "", 220);
   makeText("questionText", "", -160)
   makeText("answerA", "", -10)
   makeText("answerB", "", -10 + (1 * 60))
   makeText("answerC", "", -10 + (2 * 60))
   makeText("answerD", "", -10 + (3 * 60))
end

function makeText(tag, text, yOff)
   makeLuaText(tag, text, 700, 0, 0)
   setTextAlignment(tag, "center")
   setTextSize(tag, 50)
   screenCenter(tag)
   setProperty(tag .. ".y", getProperty(tag .. ".y") + yOff)
   addLuaText(tag)
end

function onStepHit()
   if curStep == 1 then 
      --askQuestion(questions[getQuestionNum(1, #questions)], 12, 95.7)
   end
   if curStep == 800 then 
      makeAnswerNoteSlower("unspawnNotes")
      makeAnswerNoteSlower("notes")
   end
   if curStep == 896 then 
      askQuestion(questions[getQuestionNum(1, #questions)], 12, 95.7)
      
      makeAnswerNoteSlower("unspawnNotes")
      makeAnswerNoteSlower("notes")
   end
   if curStep == 960 then 
      askQuestion(questions[getQuestionNum(1, #questions)], 12, 102.2)
   end
   if curStep == 1024 then 
      askQuestion(questions[getQuestionNum(1, #questions)], 12, 108.7)
   end
   if curStep == 1088 then 
      askQuestion(questions[getQuestionNum(1, #questions)], 12, 115.18)
   end
end

function onBeatHit()
   if questionTimer > 0 then 
      questionTimer = questionTimer - 1
   end
end

function onUpdate(elapsed)
   if questionTimer > 0 then 
      setTextString("timerText", questionTimer)

      for i = 1, #textGroup do 
         setProperty(textGroup[i] .. ".alpha", 1)
         cancelTween(textGroup[i] .. "Goning")
      end
   else 
      setTextString("", questionTimer)

      if getProperty(textGroup[1] .. ".alpha") > 0 then
         for i = 1, #textGroup do 
            doTweenAlpha(textGroup[i] .. "Goning", textGroup[i], 0, 1)
         end
      end
   end
end

function getQuestionNum(min, max)
   local questionNum = 1
   local isUsed = true
   while isUsed do
      questionNum =  getRandomInt(min, max)
      isUsed = false;

      for i = 1, #usedQuestion do 
         if questions[questionNum][1] == usedQuestion[i] then 
            isUsed = true;
            break;
         end
      end
   end

   return questionNum;
end


answerNoteData = 0;
function askQuestion(arrayQuestion, _timer, answerNoteTime)  -- timer goes down every beat
   local text = arrayQuestion[1]
   local time = _timer;

   local answer = arrayQuestion[6]
   local question = {arrayQuestion[2], arrayQuestion[3], arrayQuestion[4], arrayQuestion[5]}

   
   local numDone = {}
   local answerText = {"answerA", "answerB", "answerC", "answerD"} --fixed badwards bug by sort it backward
   local option = {"A. ", "B. ", "C. ", "D. "}
   local answers = {}
   for i =1, 4 do 
      randomNum = getRandomInt(1, #question, table.concat(numDone, ','))
      setTextString(answerText[i], option[i] .. question[randomNum])
      table.insert(numDone , randomNum )
      table.insert(answers , question[randomNum] )
   end
   setTextString("questionText", text)

   questionTimer = _timer;
   answerNoteData = 0;

   for i =0 , 3 do 
      if answers[i + 1] == answer then 
         answerNoteData = i;
         break;
      end
   end

   table.insert( usedQuestion, text)

   for note = 0, getProperty("unspawnNotes.length")-1 do
      local strumTime = getPropertyFromGroup("unspawnNotes", note, "strumTime") / 1000
      local noteData = getPropertyFromGroup("unspawnNotes", note, "noteData") % 4
      local noteType = getPropertyFromGroup("unspawnNotes", note, "noteType")
      if math.abs(strumTime - answerNoteTime) < 1 then 
         if noteType == "Answer Note" then
            if noteData == answerNoteData then 
               setPropertyFromGroup('unspawnNotes', note, 'hitHealth', '0.023'); --Default value is: 0.023, health gained on hit
               setPropertyFromGroup('unspawnNotes', note, 'missHealth', '2'); --Default value is: 0.0475, health lost on miss
               setPropertyFromGroup('unspawnNotes', note, 'hitCausesMiss', false);
      
               setPropertyFromGroup('unspawnNotes', note, 'ignoreNote', false); --Miss has no penalties
            else
               setPropertyFromGroup('unspawnNotes', note, 'hitHealth', '0'); --Default value is: 0.023, health gained on hit
               setPropertyFromGroup('unspawnNotes', note, 'missHealth', '2'); --Default value is: 0.0475, health lost on miss
               setPropertyFromGroup('unspawnNotes', note, 'hitCausesMiss', true);
      
               setPropertyFromGroup('unspawnNotes', note, 'ignoreNote', true); --Miss has no penalties
            end
         end
      end
   end

   for note = 0, getProperty("notes.length")-1 do
      local strumTime = getPropertyFromGroup("notes", note, "strumTime") / 1000
      local noteData = getPropertyFromGroup("notes", note, "noteData") % 4
      local noteType = getPropertyFromGroup("notes", note, "noteType")
      if math.abs(strumTime - answerNoteTime) < 1 then 
         if noteType == "Answer Note" then
            if noteData == answerNoteData then 
               setPropertyFromGroup('notes', note, 'hitHealth', '0.023'); --Default value is: 0.023, health gained on hit
               setPropertyFromGroup('notes', note, 'missHealth', '2'); --Default value is: 0.0475, health lost on miss
               setPropertyFromGroup('notes', note, 'hitCausesMiss', false);
      
               setPropertyFromGroup('notes', note, 'ignoreNote', false); --Miss has no penalties
            else
               setPropertyFromGroup('notes', note, 'hitHealth', '0'); --Default value is: 0.023, health gained on hit
               setPropertyFromGroup('notes', note, 'missHealth', '2'); --Default value is: 0.0475, health lost on miss
               setPropertyFromGroup('notes', note, 'hitCausesMiss', true);
      
               setPropertyFromGroup('notes', note, 'ignoreNote', true); --Miss has no penalties
            end
         end
      end
   end
end

function makeAnswerNoteSlower(Array)
   for note = 0, getProperty(Array .. ".length")-1 do
      local noteType = getPropertyFromGroup(Array, note, "noteType")
      if noteType == "Answer Note" then
         setPropertyFromGroup(Array, note, "multSpeed", 0.4)
         setPropertyFromGroup(Array, note, "multAlpha", 0.5)
         
      end
   end
end

