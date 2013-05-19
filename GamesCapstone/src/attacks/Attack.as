package attacks
{
	import flash.utils.Dictionary;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import people.Actor;
	import util.Color;
	import attacks.AttackType;
	import managers.Manager;
	import managers.LevelManager;
	
	/**
	 * The base class for attacks.
	 * 
	 * @author Chris Gelon
	 */
	public class Attack extends FlxSprite
	{
		public static const PROJECTILE_DURATION : int = -1;
		
		/** How many frames the attack has been alive for. */
		protected var _counter : uint;
		/** How many frames the attack should be alive for. */
		protected var _duration : uint;
		/** How much damage the attack does. */
		protected var _baseDamage : Number;
		
		protected var _totalDamage : Number = 0;		
		public function get damage() : Number { return _totalDamage; }
		
		private var _type : AttackType;
		public function get type() : AttackType { return _type; }
		
		private var _actorsHit : Array;
		
		public function Attack (attackWidth : Number, attackHeight : Number, damage : Number, type : AttackType)
		{
			width = attackWidth;
			height = attackHeight;
			_baseDamage = damage;
			_type = type;
		}
		
		public function initialize(x : Number, y : Number, bonusDamage : Number = 0, duration : int = 3, attackVelocity : FlxPoint = null) : void
		{
			this.x = x;
			this.y = y;
			
			revive();
			
			if (attackVelocity == null)
				velocity = new FlxPoint(0, 0);
			else
				velocity = attackVelocity;
			
			_actorsHit = new Array();
			_duration = duration;
			_totalDamage = _baseDamage + bonusDamage;
			_counter = 0;
		}
		
		/**
		 * Records that this attack has hit the given actor.
		 * 
		 * @param	actor	The actor that the attack hit.
		 */
		public function hitActor(actor : Actor) : void
		{
			if (_actorsHit.indexOf(actor) == -1)
				_actorsHit.push(actor);
		}
		
		/**
		 * Checks whether or not this attack has hit the given actor.
		 * 
		 * @param	actor	The actor to check.
		 * @return	True if the given actor has been hit by this attack, false otherwise.
		 */
		public function hasHitActor(actor : Actor) : Boolean
		{
			return _actorsHit.indexOf(actor) != -1;
		}
		
		override public function update() : void 
		{
			super.update();
			
			if (_counter > _duration)
			{
				kill();
			}
			_counter++;
		}
		
		override public function kill() : void
		{
			super.kill();
			_counter = 0;
			_totalDamage = 0;
			_duration = 0;
			_actorsHit = null;
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
	}
}