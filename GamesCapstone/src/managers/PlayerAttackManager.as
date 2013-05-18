package managers
{
	import attacks.Attack;
	import attacks.AttackType;
	import attacks.ProjectileAttack;
	import attacks.StrongAirAttack;
	import attacks.StrongAttack;
	import attacks.StrongLowAttack;
	import attacks.StrongNormalAttack;
	import attacks.WeakAttack;
	import attacks.WeakLowAttack;
	import attacks.WeakAirAttack;
	import attacks.WeakNormalAttack;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import people.players.Player;
	
	/**
	 * Manages all of the attacks made by the player.
	 * 
	 * @author Chris Gelon
	 */
	public class PlayerAttackManager extends Manager 
	{
		public function weakAttack(facing : uint, type : AttackType) : void
		{
			var attack : Attack;
			var y : Number;
			var x : Number;
			if (type == AttackType.NORMAL)
			{
				attack = recycle( WeakNormalAttack ) as WeakNormalAttack;
				y = player.y;
				x = facing == FlxObject.LEFT ? player.x - WeakNormalAttack.WEAK_NORMAL_ATTACK_WIDTH + player.width / 2 : player.x + player.width / 2;
			}
			else if (type == AttackType.LOW)
			{
				attack = recycle( WeakLowAttack ) as WeakLowAttack;
				y = player.y + player.height - WeakLowAttack.WEAK_LOW_ATTACK_HEIGHT;
				x = facing == FlxObject.LEFT ? player.x - WeakLowAttack.WEAK_LOW_ATTACK_WIDTH + player.width / 2 : player.x + player.width / 2;
			}
			else if (type == AttackType.AIR)
			{
				attack = recycle ( WeakAirAttack ) as WeakAirAttack;
				y = player.y + player.height - WeakAirAttack.WEAK_AIR_ATTACK_HEIGHT / 2;
				x = player.x + player.width / 2 - (WeakAirAttack.WEAK_AIR_ATTACK_WIDTH / 2);
			}
			
			attack.initialize(x, y, player.damageBonus);
		}
		
		public function strongAttack(facing : uint, type : AttackType) : void
		{
			var attack : Attack;
			var y : Number;
			var x : Number;
			if (type == AttackType.NORMAL)
			{
				attack = recycle( StrongNormalAttack ) as StrongNormalAttack;
				y = player.y;
				x = facing == FlxObject.LEFT ? player.x - StrongNormalAttack.STRONG_NORMAL_ATTACK_WIDTH + player.width / 2 : player.x + player.width / 2;
			}
			else if (type == AttackType.LOW)
			{
				attack = recycle( StrongLowAttack ) as StrongLowAttack;
				y = player.y + player.height - StrongLowAttack.STRONG_LOW_ATTACK_HEIGHT;
				x = facing == FlxObject.LEFT ? player.x - StrongLowAttack.STRONG_LOW_ATTACK_WIDTH + player.width / 2 : player.x + player.width / 2;
			}
			else if (type == AttackType.AIR)
			{
				attack = recycle ( StrongAirAttack ) as StrongAirAttack;
				y = player.y + player.height - StrongAirAttack.STRONG_AIR_ATTACK_HEIGHT / 2;
				x = player.x + player.width / 2 - (StrongAirAttack.STRONG_AIR_ATTACK_WIDTH / 2);
			}
			
			attack.initialize(x, y, player.damageBonus);
		}
		
		public function get player() : Player
		{
			return (getManager(PlayerManager) as PlayerManager).player;
		}
	}
}