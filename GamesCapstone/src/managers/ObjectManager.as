package managers
{
	import objects.Acid;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import states.GameState;
	
	/**
	 * @author Lydia Duncan
	 */
	
	public class ObjectManager extends Manager 
	{
		
		public function addObject (location: FlxPoint) : void
		{
			var acid : Acid = new Acid(location.x, location.y);
			add(acid);
		
		}
	}	
}