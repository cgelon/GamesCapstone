package managers
{
	import attacks.StrongAttack;
	import attacks.WeakAttack;
	import org.flixel.FlxGroup;
	
	/**
	 * Manages all of the attacks made by the player.
	 * 
	 * @author Chris Gelon
	 */
	public class PlayerAttackManager extends Manager 
	{
		public function attack(x : Number, y : Number) : void
		{
			var attack : WeakAttack = recycle( WeakAttack ) as WeakAttack;
			attack.initialize(x, y, (getManager(PlayerManager) as PlayerManager).player.damageBonus);
		}
		
		public function strongAttack(x : Number, y : Number) : void
		{
			var attack : StrongAttack = recycle( StrongAttack ) as StrongAttack;
			attack.initialize(x, y, (getManager(PlayerManager) as PlayerManager).player.damageBonus);
		}
	}
}