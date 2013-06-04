package cutscenes.engine 
{
	import org.flixel.FlxTimer;
	/**
	 * An action to wait for other actions.
	 * 
	 * @author Chris Gelon
	 */
	public class WaitForAction extends Action 
	{
		private var _callback : Function;
		public var cutscene : Cutscene;
		
		override public function run(callback:Function):void 
		{
			_callback = callback;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (_callback != null && cutscene != null && cutscene.numActionsRunning == 0)
			{
				_callback();
				exists = false;
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();

			_callback = null;
			cutscene = null;
		}
	}
}