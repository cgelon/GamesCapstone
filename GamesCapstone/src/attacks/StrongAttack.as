package attacks
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import util.Color;
	
	/**
	 * A super attack.
	 * 
	 * @author Chris Gelon
	 */
	public class StrongAttack extends Attack
	{
		private const STRONG_ATTACK_DAMAGE : Number = 2;
		private const STRONG_ATTACK_WIDTH : Number = 40;
		private const STRONG_ATTACK_HEIGHT : Number = 40;
		
		public function StrongAttack()
		{
			super(STRONG_ATTACK_WIDTH, STRONG_ATTACK_HEIGHT, STRONG_ATTACK_DAMAGE);
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