package attacks
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import util.Color;
	
	/**
	 * The base class for attacks.
	 * 
	 * @author Chris Gelon
	 */
	public class Attack extends FlxSprite
	{
		/** How many frames the attack has been alive for. */
		private var _counter : Number;
		
		/** How much damage the attack does. */
		private var _damage : Number;		
		public function get damage() : Number { return _damage; }
		
		public function Attack (attackWidth : Number, attackHeight : Number, damage : Number)
		{
			width = attackWidth;
			height = attackHeight;
			_damage = damage;
		}
		
		public function initialize(x : Number, y : Number) : void
		{
			this.x = x;
			this.y = y;
			
			revive();
			
			_counter = 0;
			makeGraphic(width, height, Color.WHITE, true);
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