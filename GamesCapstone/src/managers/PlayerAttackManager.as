package managers
{
	import attacks.StrongAttack;
	import attacks.WeakAttack;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import people.players.Player;
	
	/**
	 * Manages all of the attacks made by the player.
	 * 
	 * @author Chris Gelon
	 */
	public class PlayerAttackManager extends Manager 
	{
		public function attack(facing : uint) : void
		{
			var attack : WeakAttack = recycle( WeakAttack ) as WeakAttack;
			
			var player : Player = (getManager(PlayerManager) as PlayerManager).player;
			var x : Number;
			
			if (facing == FlxObject.LEFT)
				x = player.x - 20;
			else
				x = player.x + player.width;
			
			attack.initialize(x, player.y, (getManager(PlayerManager) as PlayerManager).player.getPlayerBonusDamage());
		}
		
		public function strongAttack(facing : uint) : void
		{
			var attack : StrongAttack = recycle( StrongAttack ) as StrongAttack;
			
			var player : Player = (getManager(PlayerManager) as PlayerManager).player;
			var x : Number;
			
			if (facing == FlxObject.LEFT)
				x = player.x - 40;
			else
				x = player.x + player.width;
				
			attack.initialize(x, player.y, (getManager(PlayerManager) as PlayerManager).player.getPlayerBonusDamage());
		}
	}
}