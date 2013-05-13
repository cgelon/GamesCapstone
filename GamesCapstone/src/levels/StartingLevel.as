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
			playerEnd = new FlxPoint(2112, 200);
			// Stores the player start points
			
			// Stores the acid locations for the floor
			//doorLocs[0] = new FlxPoint(16, 176);
			//doorLocs[1] = new FlxPoint(2096, 176);
			

			var boxLocs : Array = [448, 704, 736, 1104, 1136, 1472, 1504];
			for (var i : int = 0; i < boxLocs.length; i++)
			{
				objectStarts[i] = new FlxPoint(boxLocs[i], 208);
				objectTypes[i] = Crate;
			}
			var layerTwo : Array = [736, 1104, 1472, 1504];
			for (var j : int = 0; j < layerTwo.length; j++)
			{
				objectStarts[boxLocs.length + j] = new FlxPoint(layerTwo[j], 176);
				objectTypes[boxLocs.length + j] = Crate;
			}
			add(map);
		}
	}
}