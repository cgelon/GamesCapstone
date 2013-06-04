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
	public class LaserAttack extends ProjectileAttack
	{
		public static const LASER_WIDTH : Number = 32;
		public static const LASER_HEIGHT : Number = 4;
		public static const LASER_DAMAGE : Number = 1;
		
		public static const LASER_SPEED : Number = 275;
		public static const LASER_DURATION : Number = .75;
		
		private var _laserTimer : FlxTimer;
		
		[Embed(source = '../../assets/laser.png')] private var laserPNG : Class;
		
		public function LaserAttack() 
		{
			super(LASER_WIDTH, LASER_HEIGHT, LASER_DAMAGE);
			
			loadGraphic(laserPNG, true, false, LASER_WIDTH, LASER_HEIGHT);
			addAnimation("fire", [0, 1], 16, true);
			_laserTimer = new FlxTimer();
		}
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0, duration : int = 3, attackVelocity : FlxPoint = null) : void
		{
			super.initialize(x, y, bonusDamage, duration, attackVelocity);
			
			play("fire");
		}
		
		/*
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
		*/
		
	}

}