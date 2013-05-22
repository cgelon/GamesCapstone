package attacks 
{
	/**
	 * ...
	 * @author ...
	 */
	public class WeakNormalAttack extends WeakAttack
	{
		public static const WEAK_NORMAL_ATTACK_DAMAGE : Number = 1;
		public static const WEAK_NORMAL_ATTACK_WIDTH : Number = 30;
		public static const WEAK_NORMAL_ATTACK_HEIGHT : Number = 20;
		
		public function WeakNormalAttack()
		{
			super(WEAK_NORMAL_ATTACK_WIDTH, WEAK_NORMAL_ATTACK_HEIGHT, WEAK_NORMAL_ATTACK_DAMAGE, AttackType.NORMAL);
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