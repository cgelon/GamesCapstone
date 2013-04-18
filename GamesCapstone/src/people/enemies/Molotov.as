package people.enemies 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxObject;
	import people.Actor;
	import util.Color;
	
	/**
	 * The jock's molotov cocktail.
	 * 
	 * @author Michael Zhou
	 */
	public class Molotov extends Enemy 
	{
		/** The PNG for the jock. */
		[Embed(source = '../../../assets/molotov.png')] private var molotovPNG : Class;
		/** How long it takes the molotov to blow up */
		private var _bombDelay : Number = 60 * 30;
		/** The timer that tracks the attack timer. */
		private var _bombTimer : FlxDelay;
		
		public function Molotov() 
		{
			super();
			
			// Load the molotov.png into this sprite.
			loadGraphic(molotovPNG, true, true, 16, 32, true);

			// Set the bounding box for the sprite.
			width = 10;
			height = 31;
			
			// Offset the sprite image's bounding box.
			offset.x = 4;
			offset.y = 16;
			
			// Create the animations we need.
			addAnimation("idle", [0, 1, 2], 0, true);
			addAnimation("shatter", [4, 5, 6], 10, false);
			
			// Set physics constants
			maxVelocity = new FlxPoint(200, 2000);
			acceleration.y = 500;
			facing = FlxObject.LEFT;
			drag.x = maxVelocity.x * 4;
			
			// Set up the attack variables.
			_bombTimer = new FlxDelay(_bombDelay);
			_bombTimer.callback = function() : void
			{
				this.kill();
			}
		}
		
		override public function initialize(x : Number, y : Number) : void
		{
			super.initialize(x, y);
		}
	}

}