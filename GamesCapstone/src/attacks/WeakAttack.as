package attacks
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import util.Color;
	
	/**
	 * A basic attack.
	 * 
	 * @author Chris Gelon
	 */
	public class WeakAttack extends Attack
	{ 
		public function WeakAttack (attackWidth : Number, attackHeight : Number, damage : Number, type : AttackType)
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