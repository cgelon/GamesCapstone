package cutscenes.engine 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	
	/**
	 * Applies velocity to an object.
	 * 
	 * @author Chris Gelon
	 */
	public class VelocityAction extends Action 
	{
		private var _object : FlxObject;
		private var _velocity : FlxPoint;
		
		public function VelocityAction(object : FlxObject, velocity : FlxPoint)
		{
			_object = object;
			_velocity = velocity;
		}
		
		override public function run(callback : Function) : void
		{
			apply(_object, _velocity);
			if (callback != null) 
			{
				callback();
			}
		}
		
		public function apply(object : FlxObject, velocity : FlxPoint) : void
		{
			object.velocity = velocity;
		}
		
		override public function destroy() : void
		{
			super.destroy();
			
			_object = null;
			_velocity = null;
		}
	}
}