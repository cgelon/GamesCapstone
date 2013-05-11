package attacks
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import util.Color;
	
	/**
	 * A basic attack.
	 * 
	 * @author Chris Gelon
	 */
	public class WeakAttack extends Attack
	{
		public static const WEAK_ATTACK_DAMAGE : Number = 1;
		public static const WEAK_ATTACK_WIDTH : Number = 20;
		public static const WEAK_ATTACK_HEIGHT : Number = 20;
		
		public function WeakAttack()
		{
			super(WEAK_ATTACK_WIDTH, WEAK_ATTACK_HEIGHT, WEAK_ATTACK_DAMAGE, AttackType.NORMAL);
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