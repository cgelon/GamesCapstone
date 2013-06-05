package util
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import states.CreditState;
	import states.MainMenuState;
	
	public class ScreenOverlay extends FlxGroup 
	{
		private var _screen : FlxSprite;
		private var _text : FlxText;
		private var _otherText : FlxText;
		private var _newText : FlxText;
		private var _oldText : FlxText;
		private var _fadingText : FlxText;
		private var _reset : Boolean;
		
		public function ScreenOverlay() 
		{
			super();
			_screen = new FlxSprite();
			_screen.makeGraphic(FlxG.width, FlxG.height, Color.BLACK);
			_screen.alpha = 0;
			_screen.scrollFactor = new FlxPoint();
			
			_text = new FlxText(0, 40, FlxG.width, "Thanks for playing!", true);
			_text.setFormat(null, 24, Color.WHITE, "center", Color.DARK_GRAY);
			_text.alpha = 0;
			_text.scrollFactor = new FlxPoint();
			
			add(_screen);
			add(_text);
			
			if (SpeedRunTime.time != 0)
			{
				var time : Number = Registry.getInstance().time;
				var minutes : uint = Registry.getInstance().time / 60;
				var seconds : uint = Registry.getInstance().time % 60;
				var milliseconds : uint = (Registry.getInstance().time * 100) % 100;
				var newString : String = "New Time: " + minutes + ":" + ((seconds < 10) ? "0" : "") + seconds + ":" + (milliseconds < 10 ? "0" : "") + milliseconds;
				var oldTime : Number = SpeedRunTime.time;
				var oldMinutes : uint = SpeedRunTime.time / 60;
				var oldSeconds : uint = SpeedRunTime.time % 60;
				var oldMilliseconds : uint = (SpeedRunTime.time * 100) % 100;
				var oldString : String = "Old Time: " + oldMinutes + ":" + ((oldSeconds < 10) ? "0" : "") + oldSeconds + ":" + (oldMilliseconds < 10 ? "0" : "") + oldMilliseconds;
				_oldText = new FlxText(0, 100, FlxG.width, oldString, true);
				_oldText.setFormat(null, 16, Color.RED, "center", Color.DARK_GRAY);
				_oldText.alpha = 0;
				_oldText.scrollFactor.x = _oldText.scrollFactor.y = 0;
				_newText = new FlxText(0, FlxG.height / 2, FlxG.width, newString, true);
				_newText.setFormat(null, 16, Color.GREEN, "center", Color.DARK_GRAY);
				_newText.alpha = 0;
				_newText.scrollFactor.x = _newText.scrollFactor.y = 0;
				_otherText = new FlxText(0, FlxG.height / 2 + 40, FlxG.width, (time < oldTime) ? "Congratulations! Keep up the good work!" : "Try better next time... :(", true);
				_otherText.setFormat(null, 8, Color.WHITE, "center", Color.DARK_GRAY);
				_otherText.alpha = 0;
				_otherText.scrollFactor.x = _otherText.scrollFactor.y = 0;
				add(_oldText);
				add(_newText);
				add(_otherText);
			}
			else
			{
				_otherText = new FlxText(0, FlxG.height / 2, FlxG.width, "Congratulations, you've unlocked the clock! With this tool, you will be able to see how long you've played in a session. Try to beat your best time!", true);
				_otherText.setFormat(null, 8, Color.WHITE, "center", Color.DARK_GRAY);
				_otherText.alpha = 0;
				_otherText.scrollFactor.x = _otherText.scrollFactor.y = 0;
				add(_otherText);
			}
			
			// Create the fading text to tell the player what to press.
			_fadingText = new FadingText(FlxG.width / 4, 200, FlxG.width / 2, "Press [ENTER] to continue!", true);
			_fadingText.setFormat(null, 8, Color.WHITE, "center");
			_fadingText.exists = false;
			add(_fadingText);
			
			_reset = false;
		}
		
		override public function update():void 
		{
			super.update();
			_screen.alpha += 0.015;
			_text.alpha += 0.015;
			
			if (_oldText == null && _text.alpha >= 1)
			{
				_otherText.alpha += 0.03;
			}
			if (_oldText != null && _text.alpha >= 1)
			{
				_oldText.alpha += 0.03;
			}
			if (_oldText != null && _oldText.alpha >= 1)
			{
				_newText.alpha += 0.03;
			}
			if (_newText != null && _newText.alpha >= 1)
			{
				_otherText.alpha += 0.03;
			}
			if (_otherText.alpha >= 1 && !_fadingText.exists)
			{
				_fadingText.exists = true;
			}
			
			if (_fadingText.exists && !_reset && FlxG.keys.justPressed("ENTER"))
			{
				FlxG.music.fadeOut(1);
				FlxG.fade(Color.BLACK, 1, function() : void
				{
					Registry.reset();
					FlxG.cutscene = false;
					FlxG.switchState(new CreditState());
				});
				_reset = true;
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_screen = null;
			_text = null;
			_otherText = null;
			_newText = null;
			_oldText = null;
			_fadingText = null;
		}
	}
}