package levels
{
	import items.Environmental.Background.Acid;
	import items.Environmental.Background.AcidFlow;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class AcidPlatformLevel extends Level
	{
		[Embed(source = "../../assets/mapCSV_Group2_Acid_Platforms.csv", mimeType = "application/octet-stream")] public var CSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var PNG : Class;
		
		public function AcidPlatformLevel ()
		{
			super();
			
			map.loadMap(new CSV(), PNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			playerStart = new FlxPoint(16, 312);
			playerEnd = new FlxPoint(2096, 312);
			// Stores the player start points
			
			// Stores the acid locations for the floor
			//doorLocs[0] = new FlxPoint(16, 288);
			//doorLocs[1] = new FlxPoint(2096, 288);
			

			var acidLocs : Array = [240, 528, 816];
			for (var i : int = 0; i < acidLocs.length; i++)
			{
				for (var j: int = 0; j < 8; j++)
				{
					backgroundStarts[i*8 + j] = new FlxPoint(acidLocs[i] + 16 * j, 352);
					backgroundTypes[i*8 + j] = Acid;					
				}
			}
			
			var acidFlows : Array = [288, 576, 864];
			for (var k : int = 0; k < acidFlows.length; k++)
			{
				backgroundStarts[acidLocs.length * 8 + k] = new FlxPoint(acidFlows[k], 288);
				backgroundTypes[acidLocs.length * 8 + k] = AcidFlow;
			}
			add(map);
		}
	}
}