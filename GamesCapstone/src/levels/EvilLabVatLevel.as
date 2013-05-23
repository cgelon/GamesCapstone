package levels
{
	import items.Environmental.Background.Acid;
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.Lever;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.LightningRobot;
	import people.enemies.Robot;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class EvilLabVatLevel extends Level 
	{
		[Embed(source = "../../assets/mapCSV_EvilLabVat_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_EvilLabVat_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_EvilLabVat_Enemies.csv", mimeType = "application/octet-stream")] public var enemyCSV : Class;
		[Embed(source = "../../assets/mapCSV_EvilLabVat_Background.csv", mimeType = "application/octet-stream")] public var backgroundCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
			
		
		public function EvilLabVatLevel() 
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			parsePlayer(playerCSV, tilePNG);
			// Stores the player start points
			parseEnemies(enemyCSV, tilePNG);
			// Stores the enemy start points
			parseBackground(backgroundCSV, tilePNG);
			// TODO: make this an array traversal
			backgroundCircuits.push(false);
			backgroundCircuits.push(false);
			backgroundCircuits.push(false);
			backgroundCircuits.push(false);
			
			loadMessage = "Acid, acid, and more acid. This obsession with acid is getting a little out of control.";
			
			// Stores the acid locations for the floor
			//doorLocs[0] = new FlxPoint(16, 112);
			//doorLocs[1] = new FlxPoint(2112, 48);
			// Stores the door locations for this level
			add(map);
		}
	}
}