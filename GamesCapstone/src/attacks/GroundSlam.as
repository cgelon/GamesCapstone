package attacks 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author ...
	 */
	public class GroundSlam extends ProjectileAttack
	{
		public static const SLAM_WIDTH : Number = 8;
		public static const SLAM_HEIGHT : Number = 25;
		public static const SLAM_DAMAGE : Number = 2;
		public static const SLAM_SPEED : Number = 150;
		public static const SLAM_DURATION : Number = 1.25;
		
		public function GroundSlam() 
		{
			super(SLAM_WIDTH, SLAM_HEIGHT, SLAM_DAMAGE);
		}
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0, duration : int = 3, attackVelocity : FlxPoint = null) : void
		{
			super.initialize(x, y, bonusDamage, duration, attackVelocity);
			
			makeGraphic(width, height, 0xFF00FFFF, true);
			alpha = 1;
			FlxG.clearBitmapCache();
		}
		
	}

}