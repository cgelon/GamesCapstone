package attacks
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import util.Color;
	
	/**
	 * A standard attack.
	 * 
	 * @author Chris Gelon
	 */
	public class Attack extends FlxSprite
	{
		private var _counter : Number = 0;
		
		public function initialize(x : Number, y : Number) : void
		{
			this.x = x;
			this.y = y;
			
			revive();
			
			makeGraphic(20, 40, Color.WHITE, true);
			alpha = 0;
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