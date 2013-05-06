package UI.Bars
{
	import managers.PlayerManager;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import states.GameState;
	
	/**
	 * A bar to represent the player's current stamina.
	 *
	 * @author Chris Gelon (cgelon)
	 */
	public class PlayerStaminaBar extends FlxGroup
	{
		/** 
		 * The player's stamina in the previous frame. Used to check 
		 * against the current frame to update the bar.
		 */
		private var _previousStamina : Number;
		
		/** The initial x the bar is placed. */
		private var _initialX : Number;
		
		/** The image represents the player's stamina. */
		[Embed(source = '../../../assets/hud/stamina_bar.png')] private var staminaBarPNG : Class;
		/** A bar to be displayed behind the stamina so it isn't just transparent. */
		[Embed(source = '../../../assets/hud/stamina_bar_back.png')] private var staminaBarBackPNG : Class;
		
		public function PlayerStaminaBar(x : Number, y : Number) 
		{
			super();
			
			var staminaBarBack : FlxSprite = new FlxSprite(x - 2, y - 1, staminaBarBackPNG);
			staminaBarBack.scrollFactor = new FlxPoint(0, 0);
			add(staminaBarBack);
			
			var staminaBar : FlxSprite = new FlxSprite(x, y, staminaBarPNG);
			staminaBar.scrollFactor = new FlxPoint(0, 0);
			add(staminaBar);
			
			_initialX = x;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (stamina != _previousStamina)
			{
				// The stamina bar is the second element in members (0-indexed) because it was added second.
				var percentage : Number = Math.min(Math.max(1 - stamina / maxStamina, 0), 1);
				(members[1] as FlxSprite).x = _initialX - (members[1] as FlxSprite).width * percentage;
				_previousStamina = stamina;
			}
		}
		
		/**
		 * The current stamina of the player.
		 */
		private function get stamina() : Number
		{
			return ((FlxG.state as GameState).getManager(PlayerManager) as PlayerManager).player.stamina;
		}
		
		/**
		 * The current stamina of the player.
		 */
		private function get maxStamina() : Number
		{
			return ((FlxG.state as GameState).getManager(PlayerManager) as PlayerManager).player.maxStamina;
		}
	}
}