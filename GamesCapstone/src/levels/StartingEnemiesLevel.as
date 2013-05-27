package levels
{
	import items.Environmental.BlastDoor;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.Robot;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class StartingEnemiesLevel extends Level
	{
		[Embed(source = "../../assets/mapCSV_StartingEnemiesLevel_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_StartingEnemiesLevel_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_StartingEnemiesLevel_Enemies.csv", mimeType = "application/octet-stream")] public var enemiesCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function StartingEnemiesLevel ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map

			parsePlayer(playerCSV, tilePNG);
			parseEnemies(enemiesCSV,  tilePNG);
			
			loadMessage = "Robots... such a buzzkill! Perform weak attacks with J, strong attacks with K, block with L, and dodge with P. Have fun!";
			
			add(map);
		}
	}
}