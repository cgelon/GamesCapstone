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
		private var _object : FlxSprite;
		private var _endPosition : FlxPoint;
		private var _time : Number;
		private var _callback : Function;
		
		public function MoveAction(object : FlxSprite, endPosition : FlxPoint, time : Number) : void
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
		public function move(object : FlxSprite, endPosition : FlxPoint, time : Number, callback : Function = null) : void
		{
			// Because the way FlxVelocity works.... need to add the origin to the end position.
 			FlxVelocity.moveTowardsPoint(object, 
					new FlxPoint(endPosition.x + object.origin.x, _endPosition.y + object.origin.y), 
					0, 
					time * 1000 + 20);
			_timer = new FlxTimer();
			_timer.start(time, 1, stopMovement);
		}
		
		/**
		 * Callback for when the movement should be stopped.
		 */
		private function stopMovement(timer : FlxTimer) : void
		{
			_object.velocity = new FlxPoint(0, 0);
			if (_callback != null)
			{
				_callback();
			}
		}
		
		override public function skip() : void
		{
			_object.velocity.x = _object.velocity.y = 0;
			_object.x = _endPosition.x;
			_object.y = _endPosition.y;
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_object = null;
			if (_timer != null)
			{
				_timer.destroy();
			}
			_timer = null;
			_endPosition = null;
			_callback = null;
		}
	}

}