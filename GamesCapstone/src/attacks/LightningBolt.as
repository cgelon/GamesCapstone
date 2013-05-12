package attacks 
{
	import util.Color;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LightningBolt extends ProjectileAttack 
	{
		public static const LIGHTNING_WIDTH : Number = 15;
		public static const LIGHTNING_HEIGHT : Number = 3;
		public static const LIGHTNING_DAMAGE : Number = 2;
		public static const LIGHTNING_SPEED : Number = 100;
		
		public function LightningBolt() 
		{
			super(LIGHTNING_WIDTH, LIGHTNING_HEIGHT, LIGHTNING_DAMAGE);
		}
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0, duration : int = 3, attackVelocity : FlxPoint = null) : void
		{
			this.x = x;
			this.y = y;
			
			revive();
			
			if (attackVelocity == null)
				velocity = new FlxPoint(0, 0);
			else
				velocity = attackVelocity;
			
			_duration = duration;
			_totalDamage = _baseDamage + bonusDamage;
			_counter = 0;
			makeGraphic(width, height, Color.YELLOW, true);
			alpha = 1; //visible = true;
			FlxG.clearBitmapCache();
		}
	}

}