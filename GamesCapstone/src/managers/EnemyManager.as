package managers 
{
	import org.flixel.FlxGroup;
	import people.enemies.Enemy;
	import people.enemies.Jock;
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
		public function addEnemy(location : FlxPoint) : void
		{			
			var jock : Jock = recycle( Jock ) as Jock;
			jock.initialize(location.x, location.y);
			add(jock);
		}
	}
}