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
		
		public function ProjectileAttack(attackWidth : Number, attackHeight : Number, damage : Number, attackVelocity : FlxPoint) 
		{
			super(attackWidth, attackHeight, damage, AttackType.PROJECTILE);
			velocity = attackVelocity;
		}
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0, duration : int = 3) : void
		{
			this.x = x;
			this.y = y;
			
			//revive();
			
			_duration = duration;
			_totalDamage = _baseDamage + bonusDamage;
			_counter = 0;
			makeGraphic(width, height, Color.WHITE, true);
			alpha = 1; //visible = true;
			FlxG.clearBitmapCache();
		}
		
		/*
		override public function update() : void
		{
			
		}
		*/
	}

}