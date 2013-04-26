package managers 
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.plugin.photonstorm.FlxBar;
	import UI.Bars.HealthBar;
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
		
	}

}