package managers
{
	
	import items.Environmental.Background.BackgroundGroup;
	import items.Environmental.Background.BackgroundItem;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import states.GameState;
	
	/**
	 * @author Lydia Duncan
	 */
	
	public class BackgroundManager extends Manager 
	{
		
		public function addObject (location: FlxPoint, object:Class) : void
		{
			var obj : BackgroundItem = new object(location.x, location.y) as BackgroundItem;
			if (obj != null)
			{
				// If the object provided is a BackgroundItem, add it straight to the level
				obj.playStart();
				add(obj);
			}
			else 
			{				
				var obj2 : BackgroundGroup = new object(location.x, location.y) as BackgroundGroup;
				if (obj2 != null)
				{
					// If the object provided is a BackgroundGroup, also add it straight to the level
					obj2.playStart();
					add(obj2);
				}
			}
		}
	}	
}