package levels
{
	import items.Environmental.Background.Acid;
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.Lever;
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
			var acidFlowLocs : Array = [256, 672, 1088, 1504, 1920];
			for (var i: int = 0; i < leverLocs.length; i++) {
				backgroundStarts[2 * i] = new FlxPoint(leverLocs[i], 128);
				backgroundTypes[2 * i] = Lever;
				backgroundStarts[2 * i + 1] = new FlxPoint(acidFlowLocs[i], 129);
				backgroundTypes[2 * i + 1] = AcidFlow;
			}
			
			for (i = 0; i < leverLocs.length; i++) {
				backgroundCircuits.push(false);
			}
			// Store the location of the levers
			
			var vatLocs : Array = [224, 640, 1056, 1472, 1888];
			
			for (var j: int = 0; j < vatLocs.length; j++) 
			{
				for (var k: int = 0; k < 5; k++) 
				{
					backgroundStarts[backgroundCircuits.length * 2 + j * 5 + k] = new FlxPoint(vatLocs[j] + (k * 16), 192);
					backgroundTypes[backgroundCircuits.length * 2 + j * 5 + k] = Acid;
				}
			}
			// Stores the acid locations within the vats
			
			for (var l: int = 0; l < (width / 16) - 2; l++) 
			{
				backgroundStarts[backgroundCircuits.length * 2 + vatLocs.length * 5 + l] = new FlxPoint(16 + (l * 16), height - 32);
				backgroundTypes[backgroundCircuits.length * 2 + vatLocs.length * 5 + l] = Acid;
			}
			// Stores the acid locations for the floor
			doorLocs[0] = new FlxPoint(16, 112);
			doorLocs[1] = new FlxPoint(2112, 48);
			// Stores the door locations for this level
			
			add(map);
		}
	}
}