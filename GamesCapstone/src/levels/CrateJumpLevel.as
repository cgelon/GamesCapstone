package levels
{
	import items.Environmental.Crate;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public class CrateJumpLevel extends Level
	{
		[Embed(source = "../../assets/mapCSV_Group2_CrateJump.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
		
		public function CrateJumpLevel ()
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			playerStart = new FlxPoint(16, 232);
			playerEnd = new FlxPoint(1344, 136);
			// Stores the player start points
			
			objectStarts[0] = new FlxPoint(226, 115);
			objectTypes[0] = Crate;

			add(map);
		}
	}
}