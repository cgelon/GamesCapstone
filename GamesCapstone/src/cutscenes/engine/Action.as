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
		/**
		 * Runs this action.
		 * @param	callback	The callback for when this action completes.
		 */
		public function run(callback : Function) : void
		{
			throw Error("Override this method!");
		}
		
		/**
		 * Completes the action as if it were skipped.
		 */
		public function skip() : void { }
	}
}