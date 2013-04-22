package cutscenes 
{
	/**
	 * WaitAction waits a certain amount of time.
	 * 
	 * @author Chris Gelon
	 */
	public class WaitAction extends Action 
	{
		private var _time : Number;
		private var _callback : Function;
		
		public function WaitAction(time : Number, callback : Function = null)
		{
			_time = time;
			_callback = callback;
		}
		
		override public function run(callback : Function) : void
		{
			_callback = callback;
			wait(_time, _callback);
		}
		
		public function wait(time : Number, callback : Function = null) : void
		{
			var timer = new FlxTimer();
			timer.start(time, 1, callback);
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_time = 0;
			_callback = null;
		}
	}
}