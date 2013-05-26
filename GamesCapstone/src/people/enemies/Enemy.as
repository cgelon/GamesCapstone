package people.enemies 
{
	import attacks.Attack;
	import attacks.AttackType;
	import attacks.StrongAttack;
	import attacks.WeakAttack;
	import managers.PlayerManager;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import people.Actor;
	import people.players.Player;
	import people.states.ActorState;
	import util.Color;
	import managers.EnemyAttackManager;

	/**
	 * A basic enemy.
	 * 
	 * @author Chris Gelon
	 */
	public class Enemy extends Actor 
	{
		public var hurtType : Class;
		
		public function Enemy() 
		{
			super();

			// Load the player.png into this sprite.
			makeGraphic(20, 40, Color.GREEN, true);

			maxVelocity = new FlxPoint(200, 500);
			acceleration.y = 500;
			facing = FlxObject.RIGHT;
		}

		override public function update() : void
		{
			super.update();
			if (isTouching(FlxObject.FLOOR))
			{
				drag.x = maxVelocity.x * 4;
			}
			else
			{
				drag.x = 0;
			}
		}

		public function getHit(attack : Attack) : void
		{
			if (state != ActorState.DEAD)
			{
				if (attack is StrongAttack)
				{
					if (attack.type == AttackType.NORMAL)
					{
						velocity.x = ((x - player.x < 0) ? -1 : 1) * maxVelocity.x;
						velocity.y = -maxVelocity.y / 8;
					}
					else if (attack.type == AttackType.LOW)
					{
						velocity.y = -maxVelocity.y / 4;
					}
					else if (attack.type == AttackType.AIR)
					{
						velocity.y = maxVelocity.y / 4;
						velocity.x = ((x - player.x < 0) ? -1 : 1) * maxVelocity.x;
					}
					
				}
				else
				{
					if (attack.type == AttackType.NORMAL)
					{
						velocity.x = ((x - player.x < 0) ? -1 : 1) * maxVelocity.x / 2;
						velocity.y = -maxVelocity.y / 8;
					}
					else if (attack.type == AttackType.LOW)
					{
						velocity.y = -maxVelocity.y / 8;
					}
					else if (attack.type == AttackType.AIR)
					{
						velocity.y = maxVelocity.y / 8;
						velocity.x = ((x - player.x < 0) ? -1 : 1) * maxVelocity.x / 2;
					}
				}
				hurt(attack.damage)
				hurtType = attack is StrongAttack ? StrongAttack : WeakAttack;
			}
			
		}

		override public function destroy() : void
		{
			kill();
			super.destroy();
		}

		public function distanceToPlayer() : Number
		{
			var deltaX : Number = x - player.x;
			var deltaY : Number = y - player.y;
			return Math.sqrt(deltaX * deltaX + deltaY * deltaY);
		}

		public function get player() : Player
		{
			return (getManager(PlayerManager) as PlayerManager).player;
		}
		
		
		protected function get attackManager() : EnemyAttackManager
		{
			return getManager(EnemyAttackManager) as EnemyAttackManager;
		}
	}
}