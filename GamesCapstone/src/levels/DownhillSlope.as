package levels
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class DownhillSlope extends Level
	{
		[Embed(source = "../../assets/mapCSV_Downhill_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_Downhill_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_Downhill_Enemies.csv", mimeType = "application/octet-stream")] public var enemiesCSV : Class;
		[Embed(source = "../../assets/mapCSV_Downhill_Objects.csv", mimeType = "application/octet-stream")] public var objectsCSV : Class;
		[Embed(source = "../../assets/mapCSV_Downhill_Background.csv", mimeType = "application/octet-stream")] public var backgroundCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function DownhillSlope ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map

			parsePlayer(playerCSV, tilePNG);
			parseEnemies(enemiesCSV, tilePNG);
			parseObjects(objectsCSV, tilePNG);
			environmentalCircuits.push(true);
			environmentalCircuits.push(true);
			
			parseBackground(backgroundCSV, tilePNG);
			
			add(map);
			
			name = "DownhillSlope";
		}
	}
}