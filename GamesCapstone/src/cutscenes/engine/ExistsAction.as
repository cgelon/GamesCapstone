package cutscenes.engine 
{
	import org.flixel.FlxObject;
	
	/**
	 * Changes the existance of an object.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class ExistsAction extends Action
	{
		private var _object : FlxObject;
		private var _exist : Boolean;
		
		public function ExistsAction(object : FlxObject, exist : Boolean)
		{
			_object = object;
			_exist = exist;
		}
		
		override public function run(callback : Function) : void
		{
			_object.exists = _exist;
			callback();
		}
	}
}