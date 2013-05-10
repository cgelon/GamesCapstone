package managers 
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.plugin.photonstorm.FlxBar;
	import people.players.Player;
	import people.players.PlayerStats;
	import UI.Bars.HealthBar;
	import UI.PlayerHud;
	import UI.UIObject;
	import people.Actor;
	import org.flixel.FlxPoint;
	
	/**
	 * Handles all of the interactions with UIObjects.
	 * 
	 * @author ...
	 */
	public class UIObjectManager extends Manager
	{
		public function createPlayerHud() : void
		{
			var hud : PlayerHud = new PlayerHud();
			add(hud);
		}
		
		/**
		 * Add a health bar that monitors the health attribute of the given actor.
		 * 
		 * @param	owner		The Actor that the health bar is monitoring.
		 * @param	x			The x-coordinate of the health bar. Ignored if onParent is true.
		 * @param	y			The y-coordinate of the health bar. Ignored if onParent is true.
		 * @param	width		The width of the health bar.
		 * @param	height		The height of the health bar.
		 * @param	onParent	Whether or not the health bar should be above the Actor in question. 
		 * 						If true, centers itself right on top of the Actor.
		 */
		public function addHealthBar(owner : Actor, x : Number, y : Number, width : Number, height : Number, onParent : Boolean, fadeBar : Boolean) : void
		{
			var healthBar : HealthBar = new HealthBar(owner, x, y, width, height, onParent, fadeBar);
			
			add(healthBar);
		}
		
		public function addStaminaBar(owner : Player, x : Number, y : Number, width : Number, height : Number, onParent : Boolean) : void
		{
			var staminaBar : FlxBar = new FlxBar(x, y, FlxBar.FILL_LEFT_TO_RIGHT, width, height, owner, "stamina", 0, PlayerStats.MAX_STAMINA, false);
			
			if (onParent)
			{
				staminaBar.trackParent((owner.width - width) / 2, -(height + 1));
			}
			else
			{
				staminaBar.scrollFactor.x = 0;
				staminaBar.scrollFactor.y = 0;
			}
			
			staminaBar.createFilledBar(0x7F005100, 0xFF00F400, true);
			
			add(staminaBar);
		}
	}
}