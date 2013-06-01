package levels
{
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.Lever;
	import items.Environmental.ForceField;
	import items.Environmental.Generator;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.Robot;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class AcidDeath extends Level
	{
		[Embed(source = "../../assets/mapCSV_AcidKills_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_AcidKills_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_AcidKills_Background.csv", mimeType = "application/octet-stream")] public var BackgroundCSV : Class;
		[Embed(source = "../../assets/mapCSV_AcidKills_Objects.csv", mimeType = "application/octet-stream")] public var ObjectsCSV : Class;
		[Embed(source = "../../assets/mapCSV_AcidKills_Enemies.csv", mimeType = "application/octet-stream")] public var enemiesCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function AcidDeath ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			parsePlayer(playerCSV, tilePNG);
			// Stores the player start points
			parseEnemies(enemiesCSV, tilePNG);
			parseObjects(ObjectsCSV, tilePNG);
			environmentalCircuits.push(true);
			
			parseBackground(BackgroundCSV, tilePNG);
			// Add the Acidflow and its lever
			backgroundCircuits.push(false);
			backgroundCircuits.push(false);
			
			add(map);
		}
	}
}