package objects
{
	import managers.ObjectManager;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	/**
	 * @author Lydia Duncan
	 */
	public class Lever extends FlxSprite 
	{
		[Embed(source = '../../assets/switch.png')] private var lever: Class;
		
		function Lever(X:Number = 0, Y:Number = 0) : void 
		{
			super(X, Y);
			loadGraphic(lever, false, false, 32, 32, true);
			
			addAnimation("down", [4, 3, 2, 1, 0], 20, false);
			addAnimation("up", [0, 1, 2, 3, 4], 20, false);
			
			immovable = true;
			
		}
		
		/**
		 * When the "E" key is pressed while the player is overlapping with a lever,
		 * the lever changes positions from up to down, or from down to up
		 * 
		 * TODO: have up cause acid to flow
		 */
		public function moved() : void
		{
			if (_curIndex == 4)
			{
				play("down");
			}
			else
			{
				play("up");
			}
		}
	}	
}