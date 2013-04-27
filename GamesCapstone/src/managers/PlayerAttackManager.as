package managers
{
	import attacks.BasicAttack;
	import attacks.SuperAttack;
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
			var attack : BasicAttack = recycle( BasicAttack ) as BasicAttack;
			attack.initialize(x, y, (getManager(PlayerManager) as PlayerManager).player.getPlayerBonusDamage());
		}
		
		public function superAttack(x : Number, y : Number) : void
		{
			var attack : SuperAttack = recycle( SuperAttack ) as SuperAttack;
			attack.initialize(x, y, (getManager(PlayerManager) as PlayerManager).player.getPlayerBonusDamage());
		}
	}
}