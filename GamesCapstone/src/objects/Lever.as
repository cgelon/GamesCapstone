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
		// TODO: add player interaction
	}	
}