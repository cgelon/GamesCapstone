package levels
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class Level extends FlxGroup 
	{
		
		public var map : FlxTilemap;
		public var width : int;
		public var height : int;
		public var playerStart: FlxPoint;
		public var enemyStarts: Array;
		public var backgroundStarts: Array;
		public var backgroundTypes: Array;
		public var objectStarts: Array;
		public var objectTypes: Array;
		public var doorLocs: Array;
		public var backgroundCircuits: Array;
		public var environmentalCircuits: Array;
		
		public var loadMessage : String;
		
		public function Level() 
		{
			super();
			
			map = new FlxTilemap();
			enemyStarts = new Array();
			backgroundStarts = new Array();
			backgroundTypes = new Array();
			objectStarts = new Array();
			objectTypes = new Array();
			doorLocs = new Array();
			backgroundCircuits = new Array();
			environmentalCircuits = new Array();
			
			loadMessage = "You've entered a new level!";
		}
	}
}