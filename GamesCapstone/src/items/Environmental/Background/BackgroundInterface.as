package items.Environmental.Background 
{
	import managers.BackgroundManager;
	import org.flixel.FlxBasic;
	
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public interface BackgroundInterface 
	{
		function playStart() : void;
		/** informs the background manager of circuit triggers and reactors */
		function track(manager: BackgroundManager) : void;
		function addTo(manager: BackgroundManager) : void;
	}
	
}