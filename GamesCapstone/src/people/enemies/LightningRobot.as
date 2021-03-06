package people.enemies 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTimer;
	import people.states.ActorAction;
	import people.states.ActorState;
	import util.Convert;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LightningRobot extends Robot
	{
		/** Frames of windup before a lightning bolt attack. */
		private static const LIGHTNING_WINDUP_FRAMES : Number = Convert.framesToSeconds(15);
		/** Frames of delay after a lightning bolt attack. */
		private static const LIGHTNING_DELAY_FRAMES : Number = Convert.framesToSeconds(15);
		
		
		private static const GREEN_NATURAL : uint = 0xFF00FF00;
		private static const GREEN_GLOWING : uint = 0xFF007700;
		
		private var _attackType : int;
		private var _glowCount : uint;
		
		public function LightningRobot() 
		{
			super();
			color = GREEN_NATURAL;
		}
		
		override public function initialize(x : Number, y : Number, health : Number = 6) : void
		{
			super.initialize(x, y, health);
			state = ActorState.IDLE;
			_glowCount = 0;
		}
		
		override public function update():void 
		{
			super.update();
			if (player.state != ActorState.DEAD)
			{
				switch(state)
				{
					case ActorState.RUNNING:
						if (distanceToPlayer() <= _attackRange)
						{
							facePlayer();
							attack();
						}
						else if (distanceToPlayer() < _seekRange / 2 && distanceToPlayer() > _attackRange * 1.5)
						{
							facePlayer();
							throwLightning();
						}
						else
						{
							move();
						}
						
						if (distanceToPlayer() > _seekRange) 
						{
							executeAction(ActorAction.STOP, ActorState.IDLE);
						}
						break;
					case ActorState.ATTACKING:
						if (lastAction == ActorAction.WINDUP && _attackType == 1)
						{
							_glowCount = (_glowCount + 1) % 10;
							if (_glowCount < 5)
								color = GREEN_NATURAL;
							else
								color = GREEN_GLOWING;
						}
						acceleration.x = 0;
						velocity.x = 0;
						break;
				}
			}
		}
		
		private function throwLightning() : void
		{
			_attackType = 1;
			if (!(player.state == ActorState.HURT || player.state == ActorState.DEAD))
			{
				var windupPlayerX : Number = player.x; // x-coordinate of player when windup started.
				executeAction(ActorAction.WINDUP, ActorState.ATTACKING);
				actionTimer.start(LIGHTNING_WINDUP_FRAMES, 1, function(timer : FlxTimer) : void
				{
					color = GREEN_NATURAL;
					if (state == ActorState.ATTACKING) 
					{
						// Offset so that the lightning bolt comes out of the front side of the enemy.
						var offsetX : Number = facing == FlxObject.LEFT ? 0 : width;
						
						attackManager.lightningBoltAttack(x  + offsetX, y  + height / 2, new FlxPoint(windupPlayerX - x, 0));
						executeAction(ActorAction.ATTACK, ActorState.ATTACKING);
						actionTimer.start(LIGHTNING_DELAY_FRAMES, 1, function(timer : FlxTimer) : void
						{
							if (state == ActorState.ATTACKING) executeAction(ActorAction.STOP, ActorState.IDLE);
						});
					}
				});
			}
		}
		
		override protected function attack() : void
		{
			super.attack();
			_attackType = 0;
		}
		
	}

}