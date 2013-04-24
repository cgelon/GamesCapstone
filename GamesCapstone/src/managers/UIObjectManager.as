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
		public function addHealthBar(owner : Actor, x : Number, y : Number, width : Number, height : Number, onParent : Boolean) : void
		{
			var healthBar : FlxBar = new FlxBar(x, y, FlxBar.FILL_LEFT_TO_RIGHT, width, height, owner, "health", 0, owner._maxHealth, false);
			
			if (onParent)
			{
				healthBar.trackParent((owner.width - width) / 2, -(height + 1));
			}
			else
			{
				healthBar.scrollFactor.x = 0;
				healthBar.scrollFactor.y = 0;
			}
				
			healthBar.createFilledBar(0x7F005100, 0xFF00F400, true); 
			healthBar.killOnEmpty = true;
			
			add(healthBar);
		}
		
	}

}