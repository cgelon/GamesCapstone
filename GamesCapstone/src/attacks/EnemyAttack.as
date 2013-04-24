package attacks
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import util.Color;
	
	/**
	 * A standard enemy attack.
	 * 
	 * @author Chris Gelon
	 */
	public class EnemyAttack extends Attack
	{
		private var _counter : Number = 0;
		
		public function EnemyAttack()
		{
			super(30, 60, 1);
		}
		
		override public function initialize(x : Number, y : Number) : void
		{
			super.initialize(x, y);
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