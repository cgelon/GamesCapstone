package items.Environmental
{
	import managers.ObjectManager;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import people.Actor;
	import states.State;

	/**
	 * @author Lydia Duncan
	 */
	public class Crate extends EnvironmentalItem 
	{
		[Embed(source = '../../../assets/crate.png')] private var tileset: Class;
		
		function Crate(X: Number = 0, Y:Number = 0) : void
		{
			super("crate");
			initialize(X, Y);
			
			loadGraphic(tileset, true, false, 32, 32, false);
			
			maxVelocity = new FlxPoint(150, 750);
			acceleration.y = 1000;
			drag.x = maxVelocity.x;
		}
	}
}