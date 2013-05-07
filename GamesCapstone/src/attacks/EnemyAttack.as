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
		private const ENEMY_ATTACK_DAMAGE : Number = 1;
		private const ENEMY_ATTACK_WIDTH : Number = 20;
		private const ENEMY_ATTACK_HEIGHT : Number = 60;
		
		public function EnemyAttack()
		{
			super(ENEMY_ATTACK_WIDTH, ENEMY_ATTACK_HEIGHT, ENEMY_ATTACK_DAMAGE);
		}
		
		override public function initialize(x : Number, y : Number, bonusDamage : Number = 0) : void
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