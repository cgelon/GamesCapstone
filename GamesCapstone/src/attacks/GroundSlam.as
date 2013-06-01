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
		public static const SLAM_WIDTH : Number = 5;
		public static const SLAM_HEIGHT : Number = 45;
		public static const SLAM_DAMAGE : Number = 2;
		public static const SLAM_SPEED : Number = 125;
		public static const SLAM_DURATION : Number = 1;
		
		/** Delay (in seconds) between parts of the slam attack. */
		public static const SLAM_DELAY : Number = .1;
		/** Number of slams in the slam attack. */
		public static const NUMBER_SLAMS : int = 10;
		
		private static const _frameHeights : Array = [12, 16, 21, 27, 37, 45, 37, 27, 21, 16, 12];
		
		private var _prevFrame : int;
		private var _initHeight : Number;
		
		[Embed(source = '../../assets/slam.png')] private var slamPNG : Class;
		
		public function GroundSlam() 
		{
			super(SLAM_WIDTH, SLAM_HEIGHT, SLAM_DAMAGE);
			
			addAnimation("rise", [0, 1, 2, 3, 4, 5, 4, 3, 2, 1, 0], 11 / SLAM_DURATION, false);
			
			loadGraphic(slamPNG, true, false, 16, 46);
			width = SLAM_WIDTH;
			
			_killOnHit = false;
			
			//FlxG.watch(this, "finished", "finished");
		}
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0, duration : int = 3, attackVelocity : FlxPoint = null) : void
		{
			super.initialize(x, y + SLAM_HEIGHT - _frameHeights[0], bonusDamage, duration, attackVelocity);
			
			height = _frameHeights[0];
			_prevFrame = 0;
			_initHeight = y;
			offset.y = SLAM_HEIGHT - height;
			//y = _initHeight; // + SLAM_HEIGHT; // - _frameHeights[0];
			play("rise");
		}
		
		override public function update() : void
		{
			super.update();
			
			if (_prevFrame != _curFrame)
			{
				height = _frameHeights[_curFrame];
				offset.y -= _frameHeights[_curFrame] - _frameHeights[_prevFrame];
				//y = _initHeight + SLAM_HEIGHT - _frameHeights[_curFrame];
				y -= _frameHeights[_curFrame] - _frameHeights[_prevFrame];
				_prevFrame = _curFrame;
			}
			
		}
		
		override public function kill() : void
		{
			_prevFrame = 0;
		}
		
	}

}