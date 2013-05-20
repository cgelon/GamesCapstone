package levels
{
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.Robot;
	
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public class EnemyPlatforms extends Level
	{
		[Embed(source = "../../assets/mapCSV_EnemyPlatforms_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_EnemyPlatforms_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_EnemyPlatforms_Enemies.csv", mimeType = "application/octet-stream")] public var enemiesCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function EnemyPlatforms ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map

			parsePlayer(playerCSV, tilePNG);
			parseEnemies(enemiesCSV,  tilePNG);
			
			loadMessage = "Did you know that attacking while crouching or jumping results in special moves?";
			
			add(map);
		}
	}
}