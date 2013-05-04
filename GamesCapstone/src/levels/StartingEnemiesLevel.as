package levels
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class StartingEnemiesLevel extends Level
	{
		[Embed(source = "../../assets/mapCSV_Group2_Flat_corridor.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
		
		public function StartingEnemiesLevel ()
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			playerStart = new FlxPoint(16, 192);
			// Stores the player start points
			
			enemyStarts[0] = new FlxPoint(450, 176);
			enemyStarts[1] = new FlxPoint(1000, 176);
			enemyStarts[2] = new FlxPoint(1550, 176);
			
			// Stores the acid locations for the floor
			doorLocs[0] = new FlxPoint(16, 176);
			doorLocs[1] = new FlxPoint(2096, 176);
			
			add(map);
		}
	}
}