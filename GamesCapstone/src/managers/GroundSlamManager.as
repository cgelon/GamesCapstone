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
	 * ...
	 * @author ...
	 */
	public class GroundSlamManager extends EnemyAttackManager
	{
		private var attackTimer : FlxTimer;
		
		public function GroundSlamManager() 
		{
			attackTimer = new FlxTimer();
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
	}

}