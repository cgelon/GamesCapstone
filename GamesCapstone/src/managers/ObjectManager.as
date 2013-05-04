package managers
{
	import items.Environmental.EnvironmentalItem;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import states.GameState;
	
	/**
	 * @author Lydia Duncan
	 */
	
	public class ObjectManager extends Manager 
	{
		
		public function addObject (location: FlxPoint, object:Class) : void
		{
			var obj : EnvironmentalItem = new object(location.x, location.y) as EnvironmentalItem;
			add(obj);
		}
		
		
	}	
}