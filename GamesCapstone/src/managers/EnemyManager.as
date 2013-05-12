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
	}
}