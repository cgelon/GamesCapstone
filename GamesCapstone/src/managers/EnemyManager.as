package managers 
{
	import org.flixel.FlxGroup;
	import people.enemies.Enemy;
	import people.enemies.Jock;
	import people.enemies.LightningRobot;
	import people.enemies.Robot;
	import people.players.Player;
	import org.flixel.FlxPoint;
	import attacks.Attack;
	import people.states.ActorState;
	
	/**
	 * Handles all interactions with enemies.
	 * 
	 * @author Chris Gelon
	 */
	public class EnemyManager extends Manager
	{		
		public function addEnemy(location : FlxPoint, Object: Class) : void
		{			
			var jock : Enemy = recycle( (Object) ) as Enemy;
			jock.initialize(location.x, location.y);
			add(jock);
		}
		
		public function allEnemiesDead() : Boolean
		{
			for each (var enemy : Enemy in members)
			{
				if (enemy != null && enemy.health > 0)
					return false;
			}
			return true;
		}
		
		/**
		 * Set's the "immovable" flag for all enemies to the given value.
		 * 
		 * @param	flag	Boolean value that every enemy's immovable flag is set to.
		 */
		public function setAllImmovable(flag : Boolean) : void
		{
			for each (var enemy : Enemy in members)
			{
				if (enemy != null)
				{
					enemy.immovable = flag;
				}
			}
		}
	}
}