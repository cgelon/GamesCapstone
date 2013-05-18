package attacks
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import util.Color;
	
	/**
	 * A super attack.
	 * 
	 * @author Chris Gelon
	 */
	public class StrongAttack extends Attack
	{
		public function StrongAttack(attackWidth : Number, attackHeight : Number, damage : Number, type : AttackType)
		{
			super(attackWidth, attackHeight, damage, type);
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
	}
}