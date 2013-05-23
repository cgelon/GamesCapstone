package levels
{
	import items.Environmental.ForceField;
	import items.Environmental.Generator;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.LightningRobot;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class ForceFieldSwitches extends Level
	{
		[Embed(source = "../../assets/mapCSV_ForcefieldSwitches_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldSwitches_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldSwitches_Objects.csv", mimeType = "application/octet-stream")] public var objectCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldSwitches_Enemies.csv", mimeType = "application/octet-stream")] public var enemiesCSV : Class;		
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function ForceFieldSwitches ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			parsePlayer(playerCSV, tilePNG);
			parseEnemies(enemiesCSV, tilePNG);
			parseObjects(objectCSV, tilePNG);	
			environmentalCircuits.push(true);
			environmentalCircuits.push(true);
			
			loadMessage = "That generator seems to be powering the forcefield, maybe your fists could break it... Actually, that's a ridiculous notion.";
			
			add(map);
		}
	}
}