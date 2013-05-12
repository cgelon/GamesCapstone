package cutscenes.engine 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxCamera;
	import org.flixel.FlxPoint;
	
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
		private var _object : FlxObject;
		private var _point : FlxPoint;
		private var _zoom : Number;
		
		public function CameraAction(action : String, object : FlxObject, point : FlxPoint, zoom : Number)
		{
			_action = action;
			_object = object;
			_point = point;
			_zoom = zoom;
		}
		
		override public function run(callback : Function):void 
		{
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
			callback();
		}
		
		public function follow(object : FlxObject) : void
		{
			FlxG.camera.follow(object, FlxCamera.STYLE_LOCKON);
		}
		
		public function focus(point : FlxPoint) : void
		{
			FlxG.camera.focusOn(point);
		}
		
		public function zoom(zoom : Number) : void
		{
			FlxG.camera.zoom = zoom;
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_action = null;
			_object = null;
			_point = null;
			_zoom = 0;
		}
	}
}