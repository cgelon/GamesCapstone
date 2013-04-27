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
	public class SuperAttack extends Attack
	{
		private const SUPER_ATTACK_DAMAGE : Number = 2;
		private const SUPER_ATTACK_WIDTH : Number = 40;
		private const SUPER_ATTACK_HEIGHT : Number = 40;
		
		public function SuperAttack()
		{
			super(SUPER_ATTACK_WIDTH, SUPER_ATTACK_HEIGHT, SUPER_ATTACK_DAMAGE);
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