package UI 
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import UI.Bars.BossHealthBar;
	
	/**
	 * The HUD that is used to display boss stats.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class BossHud extends FlxGroup 
	{
		/** The PNG for the bar. */
		[Embed(source = '../../assets/hud/boss_hud.png')] private var hudPNG : Class;
		
		public function BossHud() 
		{
			var hud : FlxSprite = new FlxSprite(0, 0, hudPNG);
			hud.x = FlxG.width - hud.width;
			hud.scrollFactor = new FlxPoint(0, 0);
			add(hud);
			
			var health : BossHealthBar = new BossHealthBar(FlxG.width - 10, 6);
			add(health);
		}
	}
}