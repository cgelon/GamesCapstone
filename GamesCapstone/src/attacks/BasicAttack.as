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
		public function BasicAttack()
		{
			super(20, 40, 1);
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