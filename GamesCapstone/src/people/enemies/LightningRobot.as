package people.enemies 
{
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
		
		public function LightningRobot() 
		{
			super();
			color = 0xFF00FF00;
		}
		
		override public function update():void 
		{
			super.update();
			switch(state)
			{
				case ActorState.IDLE:
					acceleration.x = 0;
					velocity.x = 0;
					if (distanceToPlayer() <= _attackRange) 
					{
						facePlayer();
						attack();
					} 
					else if (distanceToPlayer() < _seekRange) 
					{
						executeAction(ActorAction.RUN, ActorState.RUNNING);
					}
					break;
				case ActorState.HURT:
					if (!actionTimer.running)
					{
						actionTimer.start(0.2, 1, function() : void
						{
							executeAction(ActorAction.STOP, ActorState.IDLE);
						});
					}
					break;
				case ActorState.RUNNING:
					if (distanceToPlayer() <= _attackRange)
					{
						attack();
					}
					else if (distanceToPlayer() < _seekRange / 2 && distanceToPlayer() > _attackRange * 1.5)
					{
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
					acceleration.x = 0;
					velocity.x = 0;
					break;
				case ActorState.DEAD:
					acceleration.x = 0;
					velocity.x = 0;
					if (!actionTimer.running)
					{
						actionTimer.start(0.5, 1, function() : void
						{
							kill();
						});
					}
					break;
			}
		}
		
		private function throwLightning() : void
		{
			executeAction(ActorAction.WINDUP, ActorState.ATTACKING);
			actionTimer.start(LIGHTNING_WINDUP_FRAMES, 1, function(timer : FlxTimer) : void
			{
				if (state == ActorState.ATTACKING) 
				{
					attackManager.lightningBoltAttack(x  + width / 2, y  + height / 2, new FlxPoint(player.x - x, 0));
					executeAction(ActorAction.ATTACK, ActorState.ATTACKING);
					actionTimer.start(LIGHTNING_DELAY_FRAMES, 1, function(timer : FlxTimer) : void
					{
						if (state == ActorState.ATTACKING) executeAction(ActorAction.STOP, ActorState.IDLE);
					});
				}
			});
		}
		
	}

}