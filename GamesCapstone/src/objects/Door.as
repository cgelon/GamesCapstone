package objects
{
	import managers.ObjectManager;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;

	/**
	 * @author Lydia Duncan
	 */
	public class Door extends FlxSprite 
	{
		[Embed(source = '../../assets/door.png')] private var tileset: Class;
		
		function Door(X: Number = 0, Y:Number = 0) : void
		{
			super(X, Y);
			
			loadGraphic(tileset, true, false, 32, 64, false);
			addAnimation("open", [0, 1, 2, 3, 4], 5, false);
			addAnimation("close", [4, 3, 2, 1, 0], 5, false);
			
			immovable = true;
		}
		
		// TODO: call this on the last door when all enemies in the level are dead
		public function open() : void
		{
			play("open");
		}
		
		public function close() : void
		{
			play("close");
		}
	}
}