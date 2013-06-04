package cutscenes.engine 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxCamera;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTimer;
	import org.flixel.plugin.photonstorm.FlxVelocity;
	
	/**
	 * Actions to interact with the camera.
	 * 
	 * @author Chris Gelon
	 */
	public class CameraAction extends Action
	{	
		public static const FOLLOW : String = "follow";
		public static const FOCUS : String = "focus";
		public static const ZOOM : String = "zoom";
		
		private var _action : String;
		private var _object : FlxSprite;
		private var _imaginaryObject : FlxSprite;
		private var _time : Number;
		private var _point : FlxPoint;
		private var _zoom : Number;
		
		private var _callback : Function;
		
		private var _timer : FlxTimer;
		
		public function CameraAction(action : String, object : FlxSprite, time : Number, point : FlxPoint, zoom : Number)
		{
			_action = action;
			_object = object;
			_imaginaryObject = new FlxSprite();
			_imaginaryObject.width = _object.frameWidth;
			_imaginaryObject.height = _imaginaryObject.frameHeight;
			_imaginaryObject.origin = _object.origin;
			_imaginaryObject.visible = false;
			_imaginaryObject.allowCollisions = FlxObject.NONE;
			add(_imaginaryObject);
			_time = time;
			_point = point;
			_zoom = zoom;
		}
		
		override public function run(callback : Function):void 
		{
			_callback = callback;
			switch(_action)
			{
				case FOLLOW:
					follow(_object);
					break;
				case FOCUS:
					focus(_point);
					break;
				case ZOOM:
					zoom(_zoom);
					break;
				default:
					throw Error(_action + " not a defined action!");
			}
		}
		
		public function follow(object : FlxSprite) : void
		{
			var current : FlxSprite = FlxG.camera.target as FlxSprite;
			_imaginaryObject.x = current.x - current.offset.x;
			_imaginaryObject.y = current.y - current.offset.y;
			FlxG.camera.follow(_imaginaryObject, FlxCamera.STYLE_LOCKON);
			var midpoint : FlxPoint = object.getMidpoint();
			FlxVelocity.moveTowardsPoint(_imaginaryObject, midpoint, 0, _time * 1000 + 20);
			_timer = new FlxTimer();
			_timer.start(_time, 1, stopMovement);
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		/**
		 * Callback for when the movement should be stopped.
		 */
		private function stopMovement(timer : FlxTimer) : void
		{
			_imaginaryObject.velocity = new FlxPoint(0, 0);
			FlxG.camera.follow(_object, FlxCamera.STYLE_LOCKON);
			if (_callback != null)
			{
				_callback();
			}
		}
		
		public function focus(point : FlxPoint) : void
		{
			FlxG.camera.focusOn(point);
			if (_callback != null) 
			{
				_callback();
			}
		}
		
		public function zoom(zoom : Number) : void
		{
			FlxG.camera.zoom = zoom;
			if (_callback != null) 
			{
				_callback();
			}
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_action = null;
			_object = null;
			_imaginaryObject = null;
			_point = null;
			
			_callback = null;
			
			if (_timer != null)
			{
				_timer.destroy();
			}
			_timer = null;
		}
	}
}