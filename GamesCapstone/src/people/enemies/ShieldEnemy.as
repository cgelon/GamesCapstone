package people.enemies 
{
	import attacks.StrongAirAttack;
	import attacks.StrongAttack;
	import org.flixel.FlxG;
	import org.flixel.FlxTimer;
	import org.flixel.FlxObject;
	import util.Color;
	import people.states.ActorState
	import people.states.ActorAction;
	import attacks.Attack;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShieldEnemy extends Enemy
	{
		/** Time that the shield enemy is hurt/vulnerable for. */
		private static const VULNERABLE_TIME : Number = 1;
		
		public function ShieldEnemy() 
		{
			width = 30;
			height = 50;
			
			makeGraphic(width, height, Color.BLUE, true);
			FlxG.clearBitmapCache();
		}
		
		override public function initialize(x : Number, y : Number, health : Number = 6) : void
		{
			super.initialize(x, y, health);
			state = ActorState.BLOCKING;
		}
		
		override public function update():void 
		{
			switch (state)
			{
				case ActorState.BLOCKING:
					velocity.x = 0;
					break;
				case ActorState.HURT:
					velocity.x = 0;
					if (!actionTimer.running)
					{
						actionTimer.start(VULNERABLE_TIME, 1, function(timer : FlxTimer) : void {
							if (state == ActorState.HURT)
							{
								state = ActorState.BLOCKING;
							}
						});
					}
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
		
		override public function getHit(attack : Attack) : void
		{
			if (state != ActorState.BLOCKING || attack is StrongAttack)
			{
				super.getHit(attack);
			}
			else
			{
				velocity.x = (player.x - x > 0 ? 1 : -1) * maxVelocity.x / 2;
			}
		}
		
	}

}