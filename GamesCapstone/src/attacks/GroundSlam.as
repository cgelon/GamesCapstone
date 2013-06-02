package attacks 
{
	import managers.LevelManager;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	import org.flixel.FlxTilemap;
	/**
	 * ...
	 * @author ...
	 */
	public class GroundSlam extends ProjectileAttack
	{
		public static const SLAM_WIDTH : Number = 5;
		public static const SLAM_HEIGHT : Number = 45;
		public static const SLAM_DAMAGE : Number = 1;
		public static const SLAM_SPEED : Number = 100;
		public static const SLAM_DURATION : Number = 1;
		
		/** Delay (in seconds) between parts of the slam attack. */
		public static const SLAM_DELAY : Number = .1;
		/** Number of slams in the slam attack. */
		public static const NUMBER_SLAMS : int = 10;
		
		private static const _frameHeights : Array = [12, 16, 21, 27, 37, 45, 37, 27, 21, 16, 12];
		
		private var _prevFrame : int;
		private var _initHeight : Number;
		private var _initVelocity : FlxPoint;
		
		[Embed(source = '../../assets/slam.png')] private var slamPNG : Class;
		
		public function get xVel() : Number { return _curFrame; }
		
		public function GroundSlam() 
		{
			super(SLAM_WIDTH, SLAM_HEIGHT, SLAM_DAMAGE);
			
			addAnimation("rise", [0, 1, 2, 3, 4, 5, 4, 3, 2, 1, 0], 11 / SLAM_DURATION, false);
			
			loadGraphic(slamPNG, true, false, 16, 46);
			width = SLAM_WIDTH;
			
			_killOnHit = false;
			_killOnLevelCollide = false;
			
			drag.x = 0;
			FlxG.watch(this, "xVel", "xVel");
		}
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0, duration : int = 3, attackVelocity : FlxPoint = null) : void
		{
			super.initialize(x, y - SLAM_HEIGHT, bonusDamage, duration, attackVelocity);
			
			height = _frameHeights[0];
			_initHeight = y;
			//_initVelocity = attackVelocity;
			
			offset.y = SLAM_HEIGHT - height + 1;
			this.y += SLAM_HEIGHT - _frameHeights[0];
			
			play("rise");
			_prevFrame = _curFrame;
			
			allowCollisions = FlxObject.RIGHT | FlxObject.LEFT;
		}
		
		override public function update() : void
		{
			super.update();
			
			if (_prevFrame != _curFrame)
			{
				height = _frameHeights[_curFrame];
				y -= _frameHeights[_curFrame] - _frameHeights[_prevFrame];
				offset.y -= _frameHeights[_curFrame] - _frameHeights[_prevFrame];
				
				_prevFrame = _curFrame;
			}
		}
		
		override public function kill() : void
		{
			super.kill();
		}
		
	}

}