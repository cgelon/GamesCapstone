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
	
	/**
	 * Main menu state for playing the game.
	 */
	public class MainMenuState extends FlxState
	{
		/** The title of the game. */
		private var _title : FlxText;
		
		/** The fading text that tells the player to press space. */
		private var _fadingText : FadingText;
		
		override public function create() : void
		{
			super.create();
			
			// Create the huge game title text
			_title = new FlxText(0, - 80, FlxG.width, "PartySpace", true);
			_title.setFormat(null, 32, Color.WHITE, "center", Color.DARK_GRAY);
			_title.velocity.y = 150;
			_title.moves = true;
			
			_fadingText = new FadingText(FlxG.width / 4, 200, FlxG.width / 2, "Press [SPACE] to start!", true);
			_fadingText.setFormat(null, 8, Color.WHITE, "center");
			
			add(_title);
			add(_fadingText);
		}
		
		override public function update() : void
		{
			super.update();
			
			if (FlxG.keys.justPressed("SPACE"))
			{
				add(new ScreenOverlay(false));
				var timer : FlxTimer = new FlxTimer();
				timer.start(3, 1, function() : void
				{
					FlxG.switchState(new GameState(Registry.roomFlow.getCurrentRoom()));
				});
			}
			
			if (_title.velocity.y != 0 && _title.y > FlxG.height / 2 - 50)
			{
				_title.velocity.y = 0;
			}
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_title = null;
			_fadingText = null;
		}
	}
}