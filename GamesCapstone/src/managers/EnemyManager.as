package managers 
{
	import org.flixel.FlxGroup;
	import people.enemies.Enemy;
	import people.enemies.Jock;
	import org.flixel.FlxG;
	
	/**
	 * Handles all interactions with enemies.
	 * 
	 * @author Chris Gelon
	 */
	public class EnemyManager extends Manager
	{
		public function EnemyManager() 
		{
			var jock : Jock = recycle( Jock ) as Jock;
			jock.initialize(FlxG.width / 2, FlxG.height / 5);
			add(jock);
		}
	}
}