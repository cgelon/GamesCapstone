package attacks 
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxText;
	import org.flixel.FlxTimer;
	import util.Convert;
	
	/**
	 * ...
	 * @author ...
	 */
	public class HatThrow extends ProjectileAttack
	{
		public static const HAT_WIDTH : Number = 17;
		public static const HAT_HEIGHT : Number = 14;
		public static const HAT_DAMAGE : Number = 1;
		public static const HAT_SPEED : Number = 275;
		
		public static const PHASE_TIME : Number = .25;
		
		/** Direction that the hat is flying initially. */
		private var _direction : uint;
		
		/** What phase of the hat throw attack is currently in.
		 *  Phase 1: Hat goes out.
		 *  Phase 2: Hat slows down and reverses direction.
		 *  Phase 3: Hat comes back.
		 */ 
		private var _phase : uint;
		
		private var _initVelocity : FlxPoint;
		
		private var phaseTimer : FlxTimer;
		
		[Embed(source = '../../assets/hat.png')] private var hatPNG : Class;
		
		public function HatThrow() 
		{
			super(HAT_WIDTH, HAT_HEIGHT, HAT_DAMAGE);
			phaseTimer = new FlxTimer();
			
			loadGraphic(hatPNG, false, false, 17, 14);
			
			_killOnHit = false;
		}
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0, duration : int = 3, attackVelocity : FlxPoint = null) : void
		{
			maxVelocity = new FlxPoint(Math.abs(attackVelocity.x), Math.abs(attackVelocity.y));
			super.initialize(x, y, bonusDamage, duration, attackVelocity);
			
			if (attackVelocity == null || attackVelocity.x < 0)
				_direction = FlxObject.LEFT;
			else
				_direction = FlxObject.RIGHT;
			
			_phase = 1;
			_initVelocity = new FlxPoint(attackVelocity.x, attackVelocity.y);
		}
		
		override public function update() : void
		{
			super.update();
			
			switch (_phase)
			{
				case 1:
					if (!phaseTimer.running)
					{
						phaseTimer.start(PHASE_TIME, 1, function(timer : FlxTimer) : void {
							_phase = 2;
						});
					}
					break;
				case 2:
					velocity.x += -(_initVelocity.x * 2) / Convert.secondsToFrames(PHASE_TIME);
					if (!phaseTimer.running)
					{
						phaseTimer.start(PHASE_TIME, 1, function(timer : FlxTimer) : void {
							_phase = 3;
						});
					}
					break;
				case 3:
					acceleration.x = 0;
					if (!phaseTimer.running)
					{
						phaseTimer.start(PHASE_TIME, 1, function(timer : FlxTimer) : void {
							kill();
						});
					}
					break;
			}
		}
		
		public function get vel() : String
		{
			return "<" + velocity.x + ", " + velocity.y + ">";
		}
		
		public function get phase() : uint
		{
			return _phase;
		}
	}

}