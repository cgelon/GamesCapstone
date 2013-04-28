package managers
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import states.GameState;
	
	/**
	 * @author Lydia Duncan
	 */
	
	public class ObjectManager extends Manager 
	{
		
		public function addObject (location: FlxPoint, object:Class) : void
		{
			var obj : FlxObject = new object(location.x, location.y) as FlxObject;
			add(obj);
		}
		// TODO: differentiate between objects I want the player drawn behind and objects I want the player
		// drawn in front of
	}	
}