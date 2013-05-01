package levels
{
	import objects.Acid;
	import objects.Door;
	import objects.Lever;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class EvilLabVatLevel extends Level 
	{
		[Embed(source = "../../assets/mapCSV_Group2_Vats_-_Pipes_behind(Regular).csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
			
		
		public function EvilLabVatLevel() 
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			playerStart = new FlxPoint(16, 136);
			// Stores the player start points
			
			enemyStarts[0] = new FlxPoint(672, 120);
			enemyStarts[1] = new FlxPoint(1312, 120);
			// Stores the enemy start points
			
			var leverLocs : Array = [160, 576, 992, 1408, 1824];
			for (var i: int = 0; i < leverLocs.length; i++)
			{
				objectStarts[i] = new FlxPoint(leverLocs[i], 128);
				objectTypes[i] = Lever;
			}
			// Store the location of the levers
			
			var vatLocs : Array = [224, 640, 1056, 1472, 1888];
			
			for (var j: int = 0; j < vatLocs.length; j++) 
			{
				for (var k: int = 0; k < 5; k++) 
				{
					objectStarts[leverLocs.length + j * 5 + k] = new FlxPoint(vatLocs[j] + (k * 16), 192);
					objectTypes[leverLocs.length + j * 5 + k] = Acid;
				}
			}
			// Stores the acid locations within the vats
			
			for (var l: int = 0; l < (width / 16) - 2; l++) 
			{
				objectStarts[leverLocs.length + vatLocs.length * 5 + l] = new FlxPoint(16 + (l * 16), height - 32);
				objectTypes[leverLocs.length + vatLocs.length * 5 + l] = Acid;
			}
			// Stores the acid locations for the floor
			doorLocs[0] = new FlxPoint(16, 112);
			doorLocs[1] = new FlxPoint(2112, 48);
			
			add(map);
		}
	}
}