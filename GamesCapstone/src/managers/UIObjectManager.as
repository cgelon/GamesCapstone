package managers 
{
	import org.flixel.FlxGroup;
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
		
		public function addHealthBar(owner : Actor, x : Number, y : Number, width : Number, height : Number) : void
		{
			var healthBar : HealthBar = new HealthBar(owner, width, height);
			healthBar.initialize(x, y);
			healthBar.scrollFactor.x = 0;
			healthBar.scrollFactor.y = 0;
			add(healthBar);
		}
		
	}

}