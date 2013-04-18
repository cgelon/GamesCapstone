package managers 
{
	import org.flixel.FlxGroup;
	import people.enemies.Enemy;
	import people.enemies.Jock;
	import org.flixel.FlxPoint;
	
	/**
	 * Handles all interactions with enemies.
	 * 
	 * @author Chris Gelon
	 */
	public class EnemyManager extends Manager
	{		
		public function addEnemy(location : FlxPoint)  : void
		{			
			var jock : Jock = recycle( Jock ) as Jock;
			jock.initialize(location.x, location.y);
			add(jock);
		}
	}
}