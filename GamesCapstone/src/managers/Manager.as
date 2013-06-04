package managers 
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import states.GameState;
	
	/**
	 * Base class for all managers.
	 * 
	 * @author Chris Gelon
	 */
	public class Manager extends FlxGroup 
	{
		public function Manager() 
		{
			
		}
		
		/**
		 * Returns the first instance of the specified class in this manager, or null if none exist.
		 */
		public function getFirstOfClass(c : Class) : FlxBasic
		{
			for (var i : int = 0; i < members.length; i++)
			{
				var basic : FlxBasic = members[i];
				if (basic != null && basic.exists && basic.alive && basic is c)
				{
					return basic;
				}
			}
			return null;
		}
		
		/**
		 * Returns the manager of the given manager class.
		 * 
		 * @param	c	Manager class to retrieve.
		 * @return	The manager of class c.
		 */
		public static function getManager(c : Class) : Manager
		{
			return (FlxG.state as GameState).getManager(c);
		}
	}
}