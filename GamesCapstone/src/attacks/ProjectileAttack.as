package attacks 
{
	import levels.Level;
	import managers.LevelManager;
	import managers.Manager;
	import org.flixel.FlxPoint;
	import org.flixel.FlxG;
	import org.flixel.FlxTilemap;
	import people.Actor;
	import util.Color;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ProjectileAttack extends Attack
	{
		protected var _killOnLevelCollide : Boolean;
		public function get killOnLevelCollide() : Boolean { return _killOnLevelCollide; }
		
		public function ProjectileAttack(attackWidth : Number, attackHeight : Number, damage : Number) 
		{
			super(attackWidth, attackHeight, damage, AttackType.PROJECTILE);
			_killOnLevelCollide = true;
		}
	}

}