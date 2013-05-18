package attacks 
{
	/**
	 * ...
	 * @author ...
	 */
	public class StrongAirAttack extends StrongAttack
	{
		public static const STRONG_AIR_ATTACK_DAMAGE : Number = 2;
		public static const STRONG_AIR_ATTACK_WIDTH : Number = 40;
		public static const STRONG_AIR_ATTACK_HEIGHT : Number = 20;
		
		public function StrongAirAttack() 
		{
			super(STRONG_AIR_ATTACK_WIDTH, STRONG_AIR_ATTACK_HEIGHT, STRONG_AIR_ATTACK_DAMAGE, AttackType.AIR);
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
	}

}