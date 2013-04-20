package people 
{
	import managers.Manager;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import states.GameState;
	
	/**
	 * Base class for all people in the game.
	 * 
	 * @author Chris Gelon
	 */
	public class Actor extends FlxSprite 
	{
		public var _health : Number; // The amount of health points the actor has left.
		
		/**
		 * The current state of the actor.
		 */
		public var state : ActorState;
		
		/**
		 * Initialize the actor, readying it to enter the game world.
		 * @param	x	The x coordinate to start the actor at.
		 * @param	y	The y coordinate to start the actor at.
		 */
		public function initialize(x : Number, y : Number, health : Number = 5) : void
		{
			this.x = x;
			this.y = y;
			
			_health = health;
		}
		
		/**
		 * @return	The manager class specified.  Will return null if no such manager exists.
		 */
		public function getManager(c : Class) : Manager
		{
			return (FlxG.state as GameState).getManager(c);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			state = null;
		}
	}
}