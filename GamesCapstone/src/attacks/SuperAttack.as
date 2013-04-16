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
		private var _counter : Number = 0;
		
		override public function initialize(x : Number, y : Number) : void
		{
			this.x = x;
			this.y = y;
			
			revive();
			
			makeGraphic(40, 40, Color.WHITE, true);
			FlxG.clearBitmapCache();
		}
		
		override public function update() : void 
		{
			super.update();
			if (_counter > 3)
			{
				kill();
			}
			_counter++;
		}
		
		override public function kill() : void
		{
			super.kill();
			_counter = 0;
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
	}
}