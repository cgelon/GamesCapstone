package util
{
	import managers.Manager;
	import managers.PlayerManager;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxText;
	import people.players.PlayerStats;
	import states.GameState;
	
	/**
	 * An overlay used for when the game is paused.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class PauseOverlay extends FlxGroup
	{
		
		private var _reset : Boolean;
		
		public function PauseOverlay() 
		{
			super();
			var screen : FlxSprite = new FlxSprite();
			screen.makeGraphic(FlxG.width, FlxG.height, Color.BLACK);
			screen.alpha = 0.6;
			screen.scrollFactor = new FlxPoint();
			
			var text : FlxText = new FlxText(0, FlxG.height / 2 - 20, FlxG.width, "Paused", true);
			text.setFormat(null, 24, Color.BLUE, "center", Color.BLACK);
			text.scrollFactor = new FlxPoint();
			
			// Create the fading text to tell the player what to press.
			var fadingText : FadingText = new FadingText(FlxG.width / 4, 200, FlxG.width / 2, "Press [R] to reset room!", true);
			fadingText.setFormat(null, 8, Color.WHITE, "center");
			
			add(screen);
			add(text);
			add(fadingText);
			
			_reset = false;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!_reset && FlxG.keys.pressed("R"))
			{
				FlxG.music.fadeOut(1);
				FlxG.fade(Color.BLACK, 1, function() : void
				{
					(Manager.getManager(PlayerManager) as PlayerManager).player.health = PlayerStats.MAX_HEALTH;
					Registry.playerStats.health = PlayerStats.MAX_HEALTH;
					FlxG.paused = false;
					(FlxG.state as GameState).resetRoom();
				});
				_reset = true;
			}
		}
	}
}