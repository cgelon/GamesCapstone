package cutscenes.engine 
{
	import org.flixel.FlxGroup;
	/**
	 * The cutscene engine runs actions for things to happen.
	 * Wrapper class for all actions.
	 * 
	 * @author Chris Gelon
	 */
	public class Action extends FlxGroup 
	{ 
		public function run(callback : Function) : void
		{
			throw Error("Override this method!");
		}
	}
}