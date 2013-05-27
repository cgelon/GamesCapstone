package people.enemies 
{
	import attacks.StrongAirAttack;
	import attacks.StrongAttack;
	import managers.EnemyAttackManager;
	import org.flixel.FlxG;
	import org.flixel.FlxTimer;
	import org.flixel.FlxObject;
	import util.Color;
	import people.states.ActorState
	import people.states.ActorAction;
	import attacks.Attack;
	import attacks.GroundSlam;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BossEnemy extends Enemy
	{
		private var _phase : int;
		
		public function BossEnemy() 
		{
			width = 30;
			height = 40;
			
			makeGraphic(width, height, Color.RED, true);
			FlxG.clearBitmapCache();
		}
		
		override public function initialize(x : Number, y : Number, health : Number = 6) : void
		{
			super.initialize(x, y, health);
			state = ActorState.IDLE;
			_phase = 1;
		}
		
		override public function update():void 
		{
			velocity.x = -20;
			velocity.y = 0;
			//immovable = true;
			//moves = true;
			var playerDirection : uint = (player.x - x > 0 ? FlxObject.RIGHT : FlxObject.LEFT);
			switch (state)
			{
				case ActorState.IDLE:
					velocity.x = -10;
					if (!actionTimer.running)
					{
						actionTimer.start(3, 1, function(timer : FlxTimer) : void {
							if (state == ActorState.IDLE)
							{
								var randNum : Number = Math.random();
								if (randNum < 0.33)
									state = ActorState.COMPUTER;
								else if (randNum < 0.67)
									state = ActorState.BLOCKING;
								else
									state = ActorState.ATTACKING;
							}
						});
					}
					break;
				case ActorState.BLOCKING:
					velocity.x = 0;
					attackManager.throwHat(x, y, playerDirection);
					state = ActorState.IDLE;
					break;
				case ActorState.COMPUTER:
					velocity.x = 0;
					attackManager.fireLaser(x, y, playerDirection);
					state = ActorState.IDLE;
					break;
				case ActorState.ATTACKING:
					velocity.x = 0;
					attackManager.groundSlam(x, y + height - GroundSlam.SLAM_HEIGHT, playerDirection);
					state = ActorState.IDLE;
					break;
			}
		}
		
		override public function getHit(attack : Attack) : void
		{
			// Bosses don't get knocked back.
			dealDamage(attack.damage);
		}
		
	}

}