package UI 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import UI.Bars.PlayerHealthBar;
	import UI.Bars.PlayerStaminaBar;
	
	/**
	 * The HUD that is used to display player stats.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class PlayerHud extends FlxGroup 
	{
		/** The PNG for the bar. */
		[Embed(source = '../../assets/hud/hud.png')] private var hudPNG : Class;
		
		public function PlayerHud() 
		{
			var stamina : PlayerStaminaBar = new PlayerStaminaBar(22, 17);
			add(stamina);
			
			var hud : FlxSprite = new FlxSprite(0, 0, hudPNG);
			hud.scrollFactor = new FlxPoint(0, 0);
			add(hud);
			
			var health : PlayerHealthBar = new PlayerHealthBar(8, 6);
			add(health);
		}
	}
}