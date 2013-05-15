package states
{
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTimer;
	import util.Color;
	import util.FadingText;
	import util.ScreenOverlay;
	import util.Sounds;
	
	/**
	 * Main menu state for playing the game.
	 */
	public class MainMenuState extends FlxState
	{
		/** The title of the game. */
		private var _title : FlxText;
		/** The subtitle of the game. */
		private var _subtitle : FlxText;
		
		/** The fading text that tells the player to press space. */
		private var _fadingText : FadingText;
		
		/** True if space has already been pressed, false otherwise. */
		private var _spacePressed : Boolean;
		
		override public function create() : void
		{
			super.create();
			
			// Create the huge game title text.
			_title = new FlxText(0, -100, FlxG.width, "Billionaire Bash", true);
			_title.setFormat(null, 32, Color.WHITE, "center", Color.DARK_GRAY);
			_title.velocity.y = 150;
			_title.moves = true;
			// Create the subtitle for the title text.
			_subtitle = new FlxText(0, -60, FlxG.width, "Legend of the Robot Arm", true);
			_subtitle.setFormat(null, 16, Color.ORANGE, "center", Color.DARK_GRAY);
			_subtitle.velocity.y = 150;
			_subtitle.moves = true;
			
			// Create the fading text to tell the player what to press.
			_fadingText = new FadingText(FlxG.width / 4, 200, FlxG.width / 2, "Press [SPACE] to start!", true);
			_fadingText.setFormat(null, 8, Color.WHITE, "center");
			
			// Add all the texts!
			add(_title);
			add(_subtitle);
			add(_fadingText);
			
			_spacePressed = false;
		}
		
		override public function update() : void
		{
			super.update();
			
			// If the player presses space, play a sound, fade out, and then go to the first room.
			if (!_spacePressed && FlxG.keys.justPressed("SPACE"))
			{
				FlxG.fade(Color.BLACK, 3, function() : void
				{
					FlxG.switchState(new GameState(Registry.roomFlow.getCurrentRoom()));
				});
				_spacePressed = true;
				FlxG.play(Sounds.MAIN_MENU_LONG, 0.5);
			}
			
			// Keep scrolling the text until it reaches a certain point.
			if (_title.velocity.y != 0 && _title.y > FlxG.height / 2 - 70)
			{
				_title.velocity.y = 0;
				_subtitle.velocity.y = 0;
				FlxG.play(Sounds.MAIN_MENU_SHORT, 0.75);
			}
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_title = null;
			_subtitle = null;
			_fadingText = null;
		}
	}
}