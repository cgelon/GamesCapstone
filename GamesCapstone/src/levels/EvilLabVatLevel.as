package levels
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxPoint;
	
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
			
			playerStart = new FlxPoint(40, 120);
			// Stores the player start points
			
			enemyStarts[0] = new FlxPoint(672, 120);
			enemyStarts[1] = new FlxPoint(1312, 120);
			// Stores the enemy start points
			
			var vatLocs : Array = [224, 640, 1056, 1472, 1888];
			
			for (var i: int = 0; i < vatLocs.length; i++) 
			{
				for (var j: int = 0; j < 5; j++) 
				{
					objectStarts[i * 5 + j] = new FlxPoint(vatLocs[i] + (j * 16), 192);
				}
			}
			// Stores the acid locations within the vats
			
			for (var k: int = 0; k < (width / 16) - 2; k++) 
			{
				objectStarts[vatLocs.length * 5 + k] = new FlxPoint(16 + (k * 16), height - 16);
			}
			add(map);
		}
	}
}