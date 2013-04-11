package managers 
{
	import org.flixel.FlxGroup;
	import people.enemies.Enemy;
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
			var enemy : Enemy = recycle( Enemy ) as Enemy;
			enemy.initialize(FlxG.width / 2, FlxG.height / 5);
			add(enemy);
		}
	}
}