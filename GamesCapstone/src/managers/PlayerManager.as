package managers 
{
	import attacks.Attack;
	import attacks.EnemyAttack;
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
		
		public function PlayerManager(location : FlxPoint) 
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
		public function HurtPlayer(attack : EnemyAttack) : void
		{
			// Check that the player can be hit, because this function will get called multiple times as the player is
			// moving out of the attack's hitbox.
			if (!(player.state == ActorState.ROLLING || player.state == ActorState.HURT || player.state == ActorState.DEAD))
			{
				player.acceleration.x = 0;
				player.velocity.x = ((player.x - attack.x < 0) ? -1 : 1) * player.maxVelocity.x * 2;
				
				// If the player is pinned against a wall, make the fly the other direction.
				if ((player.isTouching(FlxObject.RIGHT) && player.velocity.x > 0)
					|| (player.isTouching(FlxObject.LEFT) && player.velocity.x < 0))
				{
					player.velocity.x = -player.velocity.x;
				}
				
				if (player.state != ActorState.BLOCKING)
					player.hurt(attack.damage);
				else
				{
					player.stamina -= 5;
					FlxG.log("Stamina lowered!");
				}
			}
		}
	}
}