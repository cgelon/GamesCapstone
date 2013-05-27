package attacks 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxTimer;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LaserAttack extends Attack
	{
		public static const LASER_WIDTH : Number = 200;
		public static const LASER_HEIGHT : Number = 3;
		public static const LASER_DAMAGE : Number = 2;
		
		public static const LASER_WINDUP_DURATION : Number = 0.75;
		public static const LASER_FIRE_DURATION : Number = 0.25;
		
		private var _phase : uint;
		
		private var _laserTimer : FlxTimer;
		
		public function LaserAttack() 
		{
			super(LASER_WIDTH, LASER_HEIGHT, LASER_DAMAGE, AttackType.NORMAL);
			_laserTimer = new FlxTimer();
		}
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0, duration : int = 3, attackVelocity : FlxPoint = null) : void
		{
			super.initialize(x, y, bonusDamage, duration, attackVelocity);
			
			_phase = 1;
		}
		
		override public function update() : void
		{
			switch (_phase)
			{
				case 1:
					makeGraphic(width, height, 0x55CC0000, true);
					FlxG.clearBitmapCache();
					if (!_laserTimer.running)
					{
						allowCollisions = FlxObject.NONE;
						_laserTimer.start(LASER_WINDUP_DURATION, 1 , function(timer : FlxTimer) : void
						{
							_phase = 2;
						});
					}
					break;
				case 2:
					makeGraphic(width, height, 0xFFFF0000, true);
					FlxG.clearBitmapCache();
					if (!_laserTimer.running)
					{
						allowCollisions = FlxObject.ANY;
						_laserTimer.start(LASER_FIRE_DURATION, 1 , function(timer : FlxTimer) : void
						{
							kill();
						});
					}
					break;
			}
		}
		
	}

}