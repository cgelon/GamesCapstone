package managers 
{
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