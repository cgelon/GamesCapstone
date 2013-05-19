package attacks 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	import people.Actor;
	import util.Color;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ProjectileAttack extends Attack
	{
		
		public function ProjectileAttack(attackWidth : Number, attackHeight : Number, damage : Number) 
		{
			super(attackWidth, attackHeight, damage, AttackType.PROJECTILE);
		}
		
	}

}