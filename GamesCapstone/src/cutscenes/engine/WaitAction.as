package cutscenes.engine 
{
	import org.flixel.FlxTimer;
	
	/**
	 * WaitAction waits a certain amount of time.
	 * 
	 * @author Chris Gelon
	 */
	public class WaitAction extends Action 
	{
		private var _time : Number;
		private var _callback : Function;
		
		public function WaitAction(time : Number)
		{
			_time = time;
		}
		
		override public function run(callback : Function) : void
		{
			_callback = callback;
			wait(_time);
		}
		
		public function wait(time : Number) : void
		{
			var timer : FlxTimer = new FlxTimer();
			timer.start(time, 1, afterWait);
		}
		
		private function afterWait(timer : FlxTimer) : void
		{
			_callback();
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_time = 0;
			_callback = null;
		}
	}
}