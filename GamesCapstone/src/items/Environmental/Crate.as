package items.Environmental
{
	import managers.ObjectManager;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import people.Actor;

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
			drag.x = maxVelocity.x;
		}
		
		override public function collideWith(actor:Actor):void 
		{
			if (FlxG.keys.justPressed("J"))
			{
				velocity.x = ((x - actor.x < 0) ? -1 : 1) * maxVelocity.x * 4;
			}
		}
	}
}