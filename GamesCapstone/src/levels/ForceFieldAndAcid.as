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
	public class ForceFieldAndAcid extends Level
	{
		[Embed(source = "../../assets/mapCSV_ForcefieldsAndAcid_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldsAndAcid_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldsAndAcid_Enemies.csv", mimeType = "application/octet-stream")] public var enemiesCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldsAndAcid_Background.csv", mimeType = "application/octet-stream")] public var BackgroundCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldsAndAcid_Objects.csv", mimeType = "application/octet-stream")] public var ObjectsCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function ForceFieldAndAcid ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			parsePlayer(playerCSV, tilePNG);
			// Stores the player start points
			parseEnemies(enemiesCSV, tilePNG); /*
			enemyStarts[0] = new FlxPoint(528, 50);
			enemyTypes[0] = Robot; */
			parseObjects(ObjectsCSV, tilePNG);
			// Add the Forcefields and Generators 
			/*
			objectStarts[0] = null;
			objectTypes[0] = new ForceField([true, true, false, true], 288, 256, 5, 9);
			
			objectStarts[1] = new FlxPoint(352, 304);
			objectTypes[1] = Generator;
			environmentalCircuits.push(true);
			
			objectStarts[2] = null;
			objectTypes[2] = new ForceField([false, true, true, true], 288, 16, 16, 9);
			
			objectStarts[3] = new FlxPoint(352, 304);
			objectTypes[3] = Generator; */
			environmentalCircuits.push(true);
			
			parseBackground(BackgroundCSV, tilePNG);
			// Add the Acidflow and its lever
			backgroundCircuits.push(false);
			
			add(map);
		}
	}
}