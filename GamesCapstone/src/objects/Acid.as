package objects
{
	import managers.ObjectManager;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	/**
	 * @author Lydia Duncan
	 */
	public class Acid extends FlxSprite 
	{
		[Embed(source = '../../assets/lab tile arrange.png')] private var tileset: Class;
		
		function Acid(X:Number=0,Y:Number=0) : void 
		{
			super(X, Y);
			
			loadGraphic(tileset, true, false, 16, 16, false);
			
			addAnimation("slosh", [454, 455], 1, true);
			
			immovable = true;
			play("slosh");
		}
	}
}