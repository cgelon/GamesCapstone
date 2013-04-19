package managers
{
	import attacks.EnemyAttack;
	import org.flixel.FlxGroup;
	
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
	}
}