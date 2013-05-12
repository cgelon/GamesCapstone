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
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0, duration : int = 3, attackVelocity : FlxPoint = null) : void
		{
			this.x = x;
			this.y = y;
			
			revive();
			
			if (attackVelocity == null)
				velocity = new FlxPoint(0, 0);
			else
				velocity = attackVelocity;
			
			_duration = duration;
			_totalDamage = _baseDamage + bonusDamage;
			_counter = 0;
			makeGraphic(width, height, Color.WHITE, true);
			alpha = 1; //visible = true;
			FlxG.clearBitmapCache();
		}
	}

}