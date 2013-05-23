package people.enemies 
{
	import org.flixel.FlxG;
	import org.flixel.FlxTimer;
	import org.flixel.FlxObject;
	import util.Color;
	import people.states.ActorState;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Rat extends Enemy
	{
		/** Amount of time (in seconds) between moving. */
		private static const MOVE_INTERVAL : Number = 1;
		
		private var _moveDir : Number;
		
		public function Rat() 
		{
			width = 30;
			height = 20;
			
			makeGraphic(width, height, Color.GREEN, true);
			FlxG.clearBitmapCache();
		}
		
		override public function initialize(x : Number, y : Number, health : Number = 6) : void
		{
			super.initialize(x, y, health);
			state = ActorState.IDLE;
		}
		
		override public function update():void 
		{
			switch (state)
			{
				case ActorState.IDLE:
					velocity.x = 0;
					if (!actionTimer.running)
					{
						actionTimer.start(MOVE_INTERVAL, 1, function(timer : FlxTimer) : void {
							if (state == ActorState.IDLE)
							{
								state = ActorState.RUNNING;
							}
						});
					}
					break;
				case ActorState.RUNNING:
					if (!actionTimer.running)
					{
						//velocity.x = maxVelocity.x / 2 * (Math.random() > 0.5 ? -1 : 1);
						_moveDir = Math.random() > 0.5 ? -1 : 1;
						actionTimer.start(MOVE_INTERVAL, 1, function(timer : FlxTimer) : void {
							if (state == ActorState.RUNNING)
							{
								state = ActorState.IDLE;
							}
						});
					}
					velocity.x = _moveDir * maxVelocity.x / 2;
					break;
				case ActorState.HURT:
					state = ActorState.IDLE;
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
		
		
	}

}