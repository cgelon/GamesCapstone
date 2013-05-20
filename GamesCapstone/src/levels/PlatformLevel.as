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
	public class PlatformLevel extends Level
	{
		[Embed(source = "../../assets/mapCSV_Platform_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_Platform_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function PlatformLevel ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			parsePlayer(playerCSV, tilePNG);

			add(map);
		}
	}
}