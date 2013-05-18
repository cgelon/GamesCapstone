package attacks 
{
	/**
	 * ...
	 * @author ...
	 */
	public class StrongLowAttack extends StrongAttack
	{
		public static const STRONG_LOW_ATTACK_DAMAGE : Number = 2;
		public static const STRONG_LOW_ATTACK_WIDTH : Number = 40;
		public static const STRONG_LOW_ATTACK_HEIGHT : Number = 20;
		
		public function StrongLowAttack() 
		{
			super(STRONG_LOW_ATTACK_WIDTH, STRONG_LOW_ATTACK_HEIGHT, STRONG_LOW_ATTACK_DAMAGE, AttackType.LOW);
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
	}

}