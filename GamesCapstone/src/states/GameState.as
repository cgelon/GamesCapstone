package states 
{
	import managers.Manager;
	import org.flixel.FlxState;
	
	/**
	 * Base class for all game states.
	 * 
	 * @author Chris Gelon
	 */
	public class GameState extends FlxState 
	{
		/**
		 * Add a manager to the game state.
		 */
		public function addManager(manager : Manager) : void
		{
			add(manager);
		}
		
		/**
		 * @return	The manager class specified.  Will return null if no such manager exists.
		 */
		public function getManager(c : Class) : Manager
		{
			var i : uint = 0;
			for each (var object : Object in members)
			{
				if (object != null && object is c)
				{
					return object as Manager;
				}
			}
			return null;
		}
	}
}