package people.enemies 
{
	import managers.EnemyManager;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxObject;
	import people.Actor;
	import util.Color;
	
	/**
	 * A basic enemy.
	 * 
	 * @author Chris Gelon
	 */
	public class Jock extends Enemy 
	{
		/** The PNG for the jock. */
		[Embed(source = '../../../assets/jock.png')] private var jockPNG : Class;
		
		public function Jock() 
		{
			super();
			
			// Load the jock.png into this sprite.
			loadGraphic(jockPNG, true, true, 64, 64, true);

			// Set the bounding box for the sprite.
			width = 20;
			height = 60;
			
			// Offset the sprite image's bounding box.
			offset.x = 22;
			offset.y = 2;
			
			// Create the animations we need.
			addAnimation("idle", [0], 0, false);
			addAnimation("throw", [4, 5, 6, 7], 20, false);
			addAnimation("die", [8, 9], 20, false);
			
			maxVelocity = new FlxPoint(200, 500);
			acceleration.y = 500;
			facing = FlxObject.RIGHT;
			drag.x = maxVelocity.x * 4;
		}
		
		override public function destroy() : void
		{
			kill();
			super.destroy();
		}
	}

}