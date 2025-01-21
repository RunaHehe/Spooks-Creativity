function onCreate()
   addHaxeLibrary("NumTween", "flixel.tweens.misc")
   addHaxeLibrary("FlxTween", "flixel.tweens")
   addHaxeLibrary("FlxEase", "flixel.tweens")

   runHaxeCode([[
      getEase = function(easeName){
         var findEase = easeName.toLowerCase();
         var chosenEase;
         if (findEase == 'backin') chosenEase = FlxEase.backIn;
         else if (findEase == 'backinout') chosenEase = FlxEase.backInOut;
         else if (findEase == 'backout') chosenEase = FlxEase.backOut;
         else if (findEase == 'bouncein') chosenEase = FlxEase.bounceIn;
         else if (findEase == 'bounceinout') chosenEase = FlxEase.bounceInOut;
         else if (findEase == 'bounceout') chosenEase = FlxEase.bounceOut;
         else if (findEase == 'circin') chosenEase = FlxEase.circIn;
         else if (findEase == 'circinout') chosenEase = FlxEase.circInOut;
         else if (findEase == 'circout') chosenEase = FlxEase.circOut;
         else if (findEase == 'cubein') chosenEase = FlxEase.cubeIn;
         else if (findEase == 'cubeinout') chosenEase = FlxEase.cubeInOut;
         else if (findEase == 'cubeout') chosenEase = FlxEase.cubeOut;
         else if (findEase == 'elasticin') chosenEase = FlxEase.elasticIn;
         else if (findEase == 'elasticinout') chosenEase = FlxEase.elasticInOut;
         else if (findEase == 'elasticout') chosenEase = FlxEase.elasticOut;
         else if (findEase == 'expoin') chosenEase = FlxEase.expoIn;
         else if (findEase == 'expoinout') chosenEase = FlxEase.expoInOut;
         else if (findEase == 'expoout') chosenEase = FlxEase.expoOut;
         else if (findEase == 'quadin') chosenEase = FlxEase.quadIn;
         else if (findEase == 'quadinout') chosenEase = FlxEase.quadInOut;
         else if (findEase == 'quadout') chosenEase = FlxEase.quadOut;
         else if (findEase == 'quartin') chosenEase = FlxEase.quartIn;
         else if (findEase == 'quartinout') chosenEase = FlxEase.quartInOut;
         else if (findEase == 'quartout') chosenEase = FlxEase.quartOut;
         else if (findEase == 'quintin') chosenEase = FlxEase.quintIn;
         else if (findEase == 'quintinout') chosenEase = FlxEase.quintInOut;
         else if (findEase == 'quintout') chosenEase = FlxEase.quintOut;
         else if (findEase == 'sinein') chosenEase = FlxEase.sineIn;
         else if (findEase == 'sineinout') chosenEase = FlxEase.sineInOut;
         else if (findEase == 'sineout') chosenEase = FlxEase.sineOut;
         else if (findEase == 'smoothstepin') chosenEase = FlxEase.smoothStepIn;
         else if (findEase == 'smoothstepinout') chosenEase = FlxEase.smoothStepInOut;
         else if (findEase == 'smoothstepout') chosenEase = FlxEase.smoothStepInOut;
         else if (findEase == 'smootherstepin') chosenEase = FlxEase.smootherStepIn;
         else if (findEase == 'smootherstepinout') chosenEase = FlxEase.smootherStepInOut;
         else if (findEase == 'smootherstepout') chosenEase = FlxEase.smootherStepOut;
         else chosenEase = FlxEase.linear;

         return chosenEase;
      }
   ]])
end


--callScript("data/milf/test", "varTween", {"varTweening2", "testVar2", 1, 10, 3, "quadout", scriptName})
function varTween(_tag, _var, fromValue ,toValue, duration, _ease, _scriptName)
   if (_tag == nil or _var == nil) then return; end
   local tag = _tag
   local varName = _var
   local aScriptName = (_scriptName or scriptName)
   local ease = (_ease or "linear")

   runHaxeCode([[
      var variableName = "]]..varName..[[";
      var fromValue = ]]..fromValue..[[;
      var toValue = ]]..toValue..[[;
      var duration = ]]..duration..[[;
      var chosenEase = "]]..ease..[[";
      var varrrr;
      for (luaInstance in game.luaArray)
      {
         if(luaInstance.scriptName == "]]..aScriptName..[[")
         {
            varrrr = luaInstance;
         }

      }
      
      var findEase = chosenEase;
      chosenEase = getEase(chosenEase);
        
      ]]..tag..[[Tween = FlxTween.num(fromValue, toValue, duration, {ease: chosenEase, onUpdate: function(twn)
			{
           
				varrrr.set(variableName, twn.value);
			}, onComplete: function(twn) {
            varrrr.set(variableName, twn.value);
            ]]..tag..[[Tween = null;
         }
		});

   ]])
end

function cancelVarTween(_tag)
   local tag = _tag
   runHaxeCode([[
      //]]..tag..[[Tween.cancel();
      ]]..tag..[[Tween = null;
   ]])
end