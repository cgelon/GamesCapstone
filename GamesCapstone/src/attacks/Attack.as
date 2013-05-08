package attacks
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import people.Actor;
	import util.Color;
	import attacks.AttackType;
	
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
		private var _baseDamage : Number;
		
		private var _totalDamage : Number = 0;		
		public function get damage() : Number { return _totalDamage; }
		
		
		private var _type : AttackType;
		public function get type() : AttackType { return _type; }
		
		public function Attack (attackWidth : Number, attackHeight : Number, damage : Number, type : AttackType)
		{
			width = attackWidth;
			height = attackHeight;
			_baseDamage = damage;
			_type = type;
		}
		
		public function initialize(x : Number, y : Number, bonusDamage : Number = 0) : void
		{
			this.x = x;
			this.y = y;
			
			revive();
			
			_totalDamage = _baseDamage + bonusDamage;
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
			_totalDamage = 0;
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
	}
}