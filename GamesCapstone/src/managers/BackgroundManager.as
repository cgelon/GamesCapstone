package managers
{
	
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
			obj.playStart();
			add(obj);
		}
	}	
}