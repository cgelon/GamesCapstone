package util 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * A space block is used when we want to indicate that the player can hit space.
	 * 
	 * @author Chris Gelon (cgelon)
	 */
	public class SpaceBlock extends FlxSprite 
	{
		/** The PNG for space. */
		[Embed(source = '../../assets/letters/space.png')] private static var spacePNG : Class;
		
		/** The target to follow. */
		private var _target : FlxSprite;
		
		/** The offset from the target that this block will be placed. */
		private var _offset : FlxPoint;
		
		public function SpaceBlock(target : FlxSprite, offset : FlxPoint) 
		{
			super();
			
			loadGraphic(spacePNG);
			
			_target = target;
			_offset = offset;
			
			allowCollisions = FlxObject.NONE;
		}
		
		override public function postUpdate() : void
		{
			super.postUpdate();
			
			x = _target.x + _offset.x;
			y = _target.y + _offset.y;
		}
		
		override public function destroy():void 
		{
			super.destroy();
			
			_target = null;
			_offset = null;
		}
	}
}