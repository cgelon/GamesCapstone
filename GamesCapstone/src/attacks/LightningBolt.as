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
		public static const LIGHTNING_SPEED : Number = 225;
		
		public static const LIGHTNING_DURATION : Number = 1.5;
		
		public function LightningBolt() 
		{
			super(LIGHTNING_WIDTH, LIGHTNING_HEIGHT, LIGHTNING_DAMAGE);
		}
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0, duration : int = 3, attackVelocity : FlxPoint = null) : void
		{
			super.initialize(x, y, bonusDamage, duration, attackVelocity);
			
			makeGraphic(width, height, Color.YELLOW, true);
			alpha = 1; //visible = true;
			FlxG.clearBitmapCache();
		}
	}

}