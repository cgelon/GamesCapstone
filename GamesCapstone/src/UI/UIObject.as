package UI
{
	import org.flixel.FlxSprite;
	/**
	 * Base class for all objects in the user interface.
	 * 
	 * @author ...
	 */
	public class UIObject extends FlxSprite
	{
		/*
		 * Base class for all objects in the user interface.
		 */
		public function UIObject() {}
		
		/**
		 * Get the UIObject ready to enter the world.
		 * 
		 * @param	x	X-coordinate of the UIObject
		 * @param	y	Y-coordinate of the UIObject
		 */
		public function initialize(x : Number, y : Number) : void
		{
			this.x = x;
			this.y = y;
		}
		
		override public function destroy() : void
		{
			super.destroy();
		}
	}

}