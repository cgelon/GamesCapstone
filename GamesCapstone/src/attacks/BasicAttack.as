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
	public class BasicAttack extends Attack
	{
		private const BASIC_ATTACK_DAMAGE : Number = 1;
		private const BASIC_ATTACK_WIDTH : Number = 20;
		private const BASIC_ATTACK_HEIGHT : Number = 40;
		
		public function BasicAttack()
		{
			super(BASIC_ATTACK_WIDTH, BASIC_ATTACK_HEIGHT, BASIC_ATTACK_DAMAGE);
		}
		
		override public function initialize(x : Number, y : Number) : void
		{
			super.initialize(x, y);
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