package levels
{
	import items.Environmental.Background.Acid;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class StartingAcidLevel extends Level
	{
		[Embed(source = "../../assets/mapCSV_Group2_Flat_corridor_with_acid.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
		
		public function StartingAcidLevel ()
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			loadMessage = "What is that green stuff? Is that...ACID?!";
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			playerStart = new FlxPoint(16, 192);
			// Stores the player start points
			
			// Stores the acid locations for the floor
			doorLocs[0] = new FlxPoint(16, 176);
			doorLocs[1] = new FlxPoint(2096, 176);
			

			var acidLocs : Array = [432, 448, 464, 720, 736, 752, 768, 784, 800, 1104, 1120, 1136, 1152, 1168, 1184, 1200, 1216];
			for (var i : int = 0; i < acidLocs.length; i++)
			{
				backgroundStarts[i] = new FlxPoint(acidLocs[i], 240);
				backgroundTypes[i] = Acid;
			}
			add(map);
		}
	}
}