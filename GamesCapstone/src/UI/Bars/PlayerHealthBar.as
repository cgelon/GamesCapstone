package UI.Bars
{
	import managers.PlayerManager;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import states.GameState;
	
	/**
	 * Represents the player's health in the HUD.
	 * 
	 * @author Chris Gelon
	 */
	public class PlayerHealthBar extends FlxGroup
	{
		/** 
		 * The player's health in the previous frame. Used to check 
		 * against the current frame to update the bar.
		 */
		private var _previousHealth : Number;
		
		/** The image that represents one health. */
		[Embed(source = '../../../assets/hud/health_block.png')] private var healthBlockPNG : Class;
		
		public function PlayerHealthBar(x : Number, y : Number) 
		{
			super();
			
			for (var i : int = 0; i < 10; i++)
			{
				var healthBlock : FlxSprite = new FlxSprite(x + i * 7, y, healthBlockPNG);
				healthBlock.scrollFactor = new FlxPoint(0, 0);
				add(healthBlock);
			}
		}
		
		override public function update():void 
		{
			super.update();
			
			if (health != _previousHealth)
			{
				for (var i : int = 0; i < 10; i++)
				{
					(members[i] as FlxSprite).visible = (i < health) ? true : false;
				}
				_previousHealth = health;
			}
		}
		
		/**
		 * The current health of the player.
		 */
		private function get health() : Number
		{
			return ((FlxG.state as GameState).getManager(PlayerManager) as PlayerManager).player.health;
		}
	}
}