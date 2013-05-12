package cutscenes.engine 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	
	/**
	 * Moves an object a certain distance over a set amount of time.
	 * 
	 * @author Chris Gelon
	 */
	public class MoveAction extends Action 
	{
		private var _timer : FlxTimer;
		private var _object : FlxObject;
		private var _endPosition : FlxPoint;
		private var _time : Number;
		private var _callback : Function;
		
		public function VelocityAction(object : FlxObject, endPosition : FlxPoint, time : Number) : void
		{
			_object = object;
			_endPosition = endPosition;
			_time = time;
		}
		
		override public function run(callback : Function) : void
		{
			_callback = callback;
			move(_object, _endPosition, _time, _callback);
		}
		
		/**
		 * Move an object to a position in a certain amount of time.
		 * @param	object	The object to move.
		 * @param	endPosition	The end position.
		 * @param	time	The time it will take to get there.
		 */
		public function move(object : FlxObject, endPosition : FlxPoint, time : Number, callback : Function = null) : void
		{
			FlxVelocity.moveTowardsPoint(object, endPosition, 0, time * 1000);
			_object = object;
			_timer = new FlxTimer();
			_timer.start(time, 1, stopMovement);
		}
		
		public function stopMovement(timer : FlxTimer) : void
		{
			_object.velocity = new FlxPoint(0, 0);
			if (_callback != null)
			{
				_callback();
			}
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_object = null;
			_timer.destroy();
			_timer = null;
			_callback = null;
		}
	}

}