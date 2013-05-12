package managers
{
	import attacks.Attack;
	import attacks.EnemyAttack;
	import attacks.LightningBolt;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	
	/**
	 * Manages all of the attacks made by the enemies.
	 * 
	 * @author MichaelZhou
	 */
	public class EnemyAttackManager extends Manager 
	{
		public function attack(x : Number, y : Number) : void
		{
			var attack : EnemyAttack = recycle( EnemyAttack ) as EnemyAttack;
			attack.initialize(x, y);
		}
		
		public function lightningBoltAttack(x : Number, y : Number, direction : FlxPoint) : void
		{
			var attack : LightningBolt = recycle ( LightningBolt ) as LightningBolt;
			var attackVelocity : FlxPoint = scaleNorm(direction, LightningBolt.LIGHTNING_SPEED);
			attack.initialize(x, y, 0, Attack.PROJECTILE_DURATION, attackVelocity);
		}
		
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