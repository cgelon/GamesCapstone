package cutscenes.engine 
{
	import org.flixel.FlxObject;
	
	/**
	 * Changes the visibility of an object.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class VisibilityAction extends Action
	{
		private var _object : FlxObject;
		private var _visible : Boolean;
		
		public function VisibilityAction(object : FlxObject, visibile : Boolean)
		{
			_object = object;
			_visible = visible;
		}
		
		override public function run(callback : Function) : void
		{
			_object.visible = _visible;
			if (callback != null) 
			{
				callback();
			}
		}
		
		override public function skip():void 
		{
			run(null);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_object = null;
		}
	}
}