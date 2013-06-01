package managers
{
	import attacks.Attack;
	import attacks.EnemyAttack;
	import attacks.HatThrow;
	import attacks.LaserAttack;
	import attacks.GroundSlam;
	import attacks.ProjectileAttack;
	import attacks.LightningBolt;
	import flash.globalization.LastOperationStatus;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	import org.flixel.FlxTimer;
	import util.Convert;
	
	/**
	 * Manages all of the attacks made by the enemies.
	 * 
	 * @author MichaelZhou
	 */
	public class EnemyAttackManager extends Manager 
	{
		private var attackTimer : FlxTimer;
		
		public function EnemyAttackManager()
		{
			attackTimer = new FlxTimer();
		}
		
		public function attack(x : Number, y : Number) : void
		{
			var attack : EnemyAttack = recycle( EnemyAttack ) as EnemyAttack;
			attack.initialize(x, y);
		}
		
		public function lightningBoltAttack(x : Number, y : Number, direction : FlxPoint) : void
		{
			var attack : LightningBolt = recycle ( LightningBolt ) as LightningBolt;
			var attackVelocity : FlxPoint = scaleNorm(direction, LightningBolt.LIGHTNING_SPEED);
			attack.initialize(x, y, 0, Convert.secondsToFrames(LightningBolt.LIGHTNING_DURATION), attackVelocity);
		}
		
		public function throwHat(x : Number, y : Number, direction : uint) : void
		{
			var attack : HatThrow = recycle( HatThrow ) as HatThrow;
			var attackVelocity : FlxPoint = new FlxPoint(1, 0);
			if (direction == FlxObject.LEFT)
				attackVelocity.x = -1;
			attackVelocity = scaleNorm(attackVelocity, HatThrow.HAT_SPEED);
			attack.initialize(x, y, 0, Attack.PROJECTILE_DURATION, attackVelocity);
		}
		
		public function fireLaser(x : Number, y : Number, direction : uint) : void
		{
			var attack : LaserAttack = recycle ( LaserAttack ) as LaserAttack;
			var newX : Number = (direction == FlxObject.LEFT ? x - LaserAttack.LASER_WIDTH : x);
			var attackVelocity : FlxPoint = new FlxPoint(1, 0);
			if (direction == FlxObject.LEFT)
				attackVelocity.x = -1;
				
			attackVelocity = scaleNorm(attackVelocity, LaserAttack.LASER_SPEED);
			attack.initialize(newX, y, 0, Convert.secondsToFrames(LaserAttack.LASER_DURATION), attackVelocity);
		}
		
		public function groundSlam(x : Number, y : Number, direction : uint) : void
		{
			var attack : GroundSlam = recycle( GroundSlam ) as GroundSlam;
			var attackVelocity : FlxPoint = new FlxPoint(1, 0);
			if (direction == FlxObject.LEFT)
				attackVelocity.x = -1;
			attackVelocity = scaleNorm(attackVelocity, GroundSlam.SLAM_SPEED);
			attack.initialize(x, y, 0, Convert.secondsToFrames(GroundSlam.SLAM_DURATION), attackVelocity);
			
			if (!attackTimer.running)
			{
				attackTimer.start(GroundSlam.SLAM_DELAY, GroundSlam.NUMBER_SLAMS - 1, function(timer : FlxTimer) : void {
					var newAttack : GroundSlam = recycle( GroundSlam ) as GroundSlam;
					newAttack.initialize(x, y, 0, Convert.secondsToFrames(GroundSlam.SLAM_DURATION), attackVelocity);
				});
			}
		}
		
		//public function createSlam
		
		/**
		 * Takes a vector (FlxPoint), and scales it such that
		 *  it's Euclidian norm becomes the given value. If
		 *  no value is given, the vector is normalized
		 * 
		 * @param	vec			Vector to sacle
		 * @param	normVal		Value to scale the norm to.
		 */
		private function scaleNorm(vec : FlxPoint, normVal : Number = 1) : FlxPoint
		{
			var oldNorm : Number = Math.sqrt(vec.x * vec.x + vec.y * vec.y);
			var newVec : FlxPoint = new FlxPoint();
			newVec.x = vec.x * normVal / oldNorm;
			newVec.y = vec.y * normVal / oldNorm;
			return newVec;
		}
	}
}