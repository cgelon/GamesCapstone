package attacks
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import util.Color;
	import org.flixel.FlxPoint;
	
	
	/**
	 * A standard enemy attack.
	 * 
	 * @author Chris Gelon
	 */
	public class EnemyAttack extends Attack
	{
		private const ENEMY_ATTACK_DAMAGE : Number = 1;
		private const ENEMY_ATTACK_WIDTH : Number = 20;
		private const ENEMY_ATTACK_HEIGHT : Number = 60;
		
		public function EnemyAttack()
		{
			super(ENEMY_ATTACK_WIDTH, ENEMY_ATTACK_HEIGHT, ENEMY_ATTACK_DAMAGE, AttackType.NORMAL);
		}
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0, duration : int = 3, attackVelocity : FlxPoint = null) : void
		{
			super.initialize(x, y, bonusDamage, duration, attackVelocity);
			makeGraphic(width, height, Color.WHITE, true);
			alpha = 0;
			FlxG.clearBitmapCache();
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