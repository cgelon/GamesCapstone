package attacks 
{
	/**
	 * ...
	 * @author ...
	 */
	public class StrongNormalAttack extends StrongAttack
	{
		public static const STRONG_NORMAL_ATTACK_DAMAGE : Number = 2;
		public static const STRONG_NORMAL_ATTACK_WIDTH : Number = 40;
		public static const STRONG_NORMAL_ATTACK_HEIGHT : Number = 20;
		
		public function StrongNormalAttack()
		{
			super(STRONG_NORMAL_ATTACK_WIDTH, STRONG_NORMAL_ATTACK_HEIGHT, STRONG_NORMAL_ATTACK_DAMAGE, AttackType.NORMAL);
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
		
	}

}