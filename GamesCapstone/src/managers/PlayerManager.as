package managers 
{
	import attacks.Attack;
	import attacks.EnemyAttack;
	import attacks.GroundSlam;
	import attacks.HatThrow;
	import attacks.LaserAttack;
	import levels.EndLevel;
	import org.flixel.FlxText;
	import people.players.Player;
	import org.flixel.FlxPoint;
	import managers.UIObjectManager;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import people.states.ActorState;
	import states.GameState;
	

	/**
	 * Manages all aspects of the player.
	 * 
	 * @author Chris Gelon
	 */
	public class PlayerManager extends Manager 
	{
		/** The current player. */
		public var player : Player;
		
		public function addPlayer(location : FlxPoint) : void
		{
			player = new Player();
			player.initialize(location.x, location.y);
			add(player);
		}
		
		/**
		 * Hurts the player with the given attack.
		 * 
		 * @param	attack	The attack to hurt the player with.
		 */
		public function HurtPlayer(attack : Attack) : void
		{
			// Check that the player can be hit, because this function will get called multiple times as the player is
			// moving out of the attack's hitbox.
			if (!(player.state == ActorState.ROLLING || (player.state == ActorState.HURT /**&& !((getManager(LevelManager) as LevelManager).level is EndLevel)*/) || player.state == ActorState.DEAD))
			{
				if (attack is GroundSlam)
				{
					player.velocity.y = -player.maxVelocity.y / 2;
				}
				else if (attack is LaserAttack || attack is HatThrow)
				{
					player.velocity.y = -player.maxVelocity.y / 4;
					player.velocity.x = player.maxVelocity.x;
					if (attack.velocity.x < 0)
						player.velocity.x = -player.velocity.x;
				}
				else
				{
					player.acceleration.x = 0;
					player.velocity.x = ((player.x - attack.x < 0) ? -1 : 1) * player.maxVelocity.x * 2;
					
					// If the player is pinned against a wall, make the fly the other direction.
					if ((player.isTouching(FlxObject.RIGHT) && player.velocity.x > 0)
						|| (player.isTouching(FlxObject.LEFT) && player.velocity.x < 0))
					{
						player.velocity.x = -player.velocity.x;
					}
				}
				
				
				player.acceleration.x = 0;
				player.hurt(attack.damage);
			}
		}
	}
}