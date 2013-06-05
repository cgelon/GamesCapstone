package states
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTimer;
	import util.Color;
	import util.FadingText;
	import util.ScreenOverlay;
	import util.Sounds;
	import util.SpeedRunTime;
	
	/**
	 * Main menu state for playing the game.
	 */
	public class MainMenuState extends FlxState
	{
		/** The title of the game. */
		private var _title : FlxText;
		/** The subtitle of the game. */
		private var _subtitle : FlxText;
		
		/** True if space has already been pressed, false otherwise. */
		private var _spacePressed : Boolean;
		
		/** The image that represents a filled star for speed time. */
		[Embed(source = '../../assets/speedrun/star_filled.png')] private var starFilledPNG : Class;
		
		/** The image that represents an unfilled star for speed time. */
		[Embed(source = '../../assets/speedrun/star_unfilled.png')] private var starUnfilledPNG : Class;
		
		override public function create() : void
		{
			super.create();
			
			// Create the huge game title text.
			_title = new FlxText(0, -100, FlxG.width, "Billionaire Bash", true);
			_title.setFormat(null, 32, Color.WHITE, "center", Color.DARK_GRAY);
			_title.velocity.y = 150;
			_title.moves = true;
			add(_title);
			// Create the subtitle for the title text.
			_subtitle = new FlxText(0, -60, FlxG.width, "Legend of the Robot Arm", true);
			_subtitle.setFormat(null, 16, Color.ORANGE, "center", Color.DARK_GRAY);
			_subtitle.velocity.y = 150;
			_subtitle.moves = true;
			add(_subtitle);
			
			// Create the fading text to tell the player what to press.
			var fadingText : FadingText = new FadingText(FlxG.width / 4, 210, FlxG.width / 2, "Press [SPACE] to start!", true);
			fadingText.setFormat(null, 8, Color.WHITE, "center");
			add(fadingText);
			// Create the fading text to tell the player what to press.
			var fadingCreditText : FadingText = new FadingText(FlxG.width / 4, 220, FlxG.width / 2, "Press [C] for credits!", true);
			fadingCreditText.setFormat(null, 8, Color.WHITE, "center");
			add(fadingCreditText);
			
			// Create the time text.
			if (SpeedRunTime.time > 0)
			{
				// Create stars based on time.
				for (var i : int = 0; i < 5; i ++)
				{
					var star : FlxSprite = new FlxSprite(30 + i * 52, 120, (SpeedRunTime.stars > i) ? starFilledPNG : starUnfilledPNG);
					add(star);
				}
				
				if (SpeedRunTime.stars < 5)
				{
					var starMinutes : uint = SpeedRunTime.secondsUntilNextStar / 60;
					var starSeconds : uint = SpeedRunTime.secondsUntilNextStar % 60;
					var starMilliseconds : uint = (SpeedRunTime.secondsUntilNextStar * 100) % 100;
					var starText : FlxText = new FlxText(0, 170, FlxG.width, "Time for Next Star: " + starMinutes + ":" + ((starSeconds < 10) ? "0" : "") + starSeconds + ":" + (starMilliseconds < 10 ? "0" : "") + starMilliseconds, true);
					starText.setFormat(null, 8, Color.WHITE, "center", Color.DARK_GRAY);
					add(starText);
				}
				var minutes : uint = SpeedRunTime.time / 60;
				var seconds : uint = SpeedRunTime.time % 60;
				var milliseconds : uint = (SpeedRunTime.time * 100) % 100;
				var timeText : FlxText = new FlxText(0, (SpeedRunTime.stars < 5) ? 180 : 170, FlxG.width, "Personal Best: " + minutes + ":" + ((seconds < 10) ? "0" : "") + seconds + ":" + (milliseconds < 10 ? "0" : "") + milliseconds, true);
				timeText.setFormat(null, (SpeedRunTime.stars < 5) ? 8 : 16, Color.WHITE, "center", Color.DARK_GRAY);
				add(timeText);
			}
			
			_spacePressed = false;
		}
		
		override public function update() : void
		{
			super.update();
			
			// If the player presses space, play a sound, fade out, and then go to the first room.
			if (!_spacePressed && FlxG.keys.justPressed("SPACE"))
			{
				FlxG.fade(Color.BLACK, 2, function() : void
				{
					FlxG.switchState(new GameState(Registry.roomFlow.getCurrentRoom()));
				});
				_spacePressed = true;
				FlxG.play(Sounds.MAIN_MENU_LONG, 0.3);
			}
			if (!_spacePressed && FlxG.keys.justPressed("C"))
			{
				FlxG.fade(Color.BLACK, 1, function() : void
				{
					FlxG.switchState(new CreditState());
				});
				_spacePressed = true;
				FlxG.play(Sounds.MAIN_MENU_LONG, 0.3);
			}
			
			// Keep scrolling the text until it reaches a certain point.
			if (_title.velocity.y != 0 && _title.y > FlxG.height / 2 - 70)
			{
				_title.velocity.y = 0;
				_subtitle.velocity.y = 0;
				FlxG.play(Sounds.MAIN_MENU_SHORT, 0.4);
			}
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_title = null;
			_subtitle = null;
		}
	}
}