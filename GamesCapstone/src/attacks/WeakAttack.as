package attacks
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import util.Color;
	import org.flixel.FlxPoint;
	
	/**
	 * A basic attack.
	 * 
	 * @author Chris Gelon
	 */
	public class WeakAttack extends Attack
	{ 
		public function WeakAttack (attackWidth : Number, attackHeight : Number, damage : Number, type : AttackType)
		{
			super(attackWidth, attackHeight, damage, type);
		}
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0, duration : int = 3, attackVelocity : FlxPoint = null) : void
		{
			super.initialize(x, y, bonusDamage, duration, attackVelocity);
			makeGraphic(width, height, Color.WHITE, true);
			alpha = 0;
			FlxG.clearBitmapCache();
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
	}
}