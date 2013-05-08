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
		
		/**
		 * Hurts an enemy with the given attack.
		 * 
		 * @param	damage	The amount of damage to deal to the enemy.
		 */
		public function HurtEnemy(enemy : Enemy, attack : Attack) : void
		{
			if (!(enemy.state == ActorState.HURT || enemy.state == ActorState.DEAD))
			{
				var player : Player = (getManager(PlayerManager) as PlayerManager).player;
				enemy.velocity.x = ((enemy.x - player.x < 0) ? -1 : 1) * enemy.maxVelocity.x;
				enemy.hurt(attack.damage);
			}
		}
	}
}