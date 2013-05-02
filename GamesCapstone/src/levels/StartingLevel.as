package levels
{
	import items.Environmental.Crate;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class StartingLevel extends Level
	{
		[Embed(source = "../../assets/mapCSV_Group2_Flat_corridor.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
		
		public function StartingLevel ()
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			playerStart = new FlxPoint(16, 192);
			// Stores the player start points
			
			// Stores the acid locations for the floor
			doorLocs[0] = new FlxPoint(16, 176);
			doorLocs[1] = new FlxPoint(2096, 176);
			
			objectStarts[0] = new FlxPoint(448, 208);
			objectTypes[0] = Crate;
			
			add(map);
		}
	}
}