package attacks
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import util.Color;
	
	/**
	 * A low weak attack.
	 */
	public class WeakLowAttack extends Attack
	{
		public static const WEAK_LOW_ATTACK_DAMAGE : Number = 1;
		public static const WEAK_LOW_ATTACK_WIDTH : Number = 30;
		public static const WEAK_LOW_ATTACK_HEIGHT : Number = 20;
		
		public function WeakLowAttack()
		{
			super(WEAK_LOW_ATTACK_WIDTH, WEAK_LOW_ATTACK_HEIGHT, WEAK_LOW_ATTACK_DAMAGE, AttackType.LOW);
		}
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0) : void
		{
			super.initialize(x, y, bonusDamage);
		}
		
		override public function update() : void 
		{
			super.update();
		}
		
		override public function kill() : void
		{
			super.kill();
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
	}
}