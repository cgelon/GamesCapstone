package attacks
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import util.Color;
	
	/**
	 * A weak air attack.
	 */
	public class WeakAirAttack extends WeakAttack
	{
		public static const WEAK_AIR_ATTACK_DAMAGE : Number = 1;
		public static const WEAK_AIR_ATTACK_WIDTH : Number = 30;
		public static const WEAK_AIR_ATTACK_HEIGHT : Number = 20;
		
		public function WeakAirAttack()
		{
			super(WEAK_AIR_ATTACK_WIDTH, WEAK_AIR_ATTACK_HEIGHT, WEAK_AIR_ATTACK_DAMAGE, AttackType.AIR);
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