package  
{
	import org.flixel.system.FlxPreloader;
	
	/**
	 * Preloader for the game.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class Preloader extends FlxPreloader 
	{
		public function Preloader() 
		{
			className = "Main";
            super();
		}
	}
}