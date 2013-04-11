package managers
{
	import attacks.Attack;
	import attacks.SuperAttack;
	import org.flixel.FlxGroup;
	
	/**
	 * Manages all of the attacks made by the player.
	 * 
	 * @author Chris Gelon
	 */
	public class AttackManager extends Manager 
	{
		public function attack(x : Number, y : Number) : void
		{
			var attack : Attack = recycle( Attack ) as Attack;
			attack.initialize(x, y);
		}
		
		public function superAttack(x : Number, y : Number) : void
		{
			var attack : SuperAttack = recycle( SuperAttack ) as SuperAttack;
			attack.initialize(x, y);
		}
	}
}