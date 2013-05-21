package levels
{
	import items.Environmental.Background.Acid;
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.Lever;
	import org.flixel.FlxPoint;
	import people.enemies.LightningRobot;
	
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public class AcidSwitches extends Level
	{
		[Embed(source = "../../assets/mapCSV_AcidSwitches_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_AcidSwitches_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_AcidSwitches_Background.csv", mimeType = "application/octet-stream")] public var backgroundCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function AcidSwitches ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			parsePlayer(playerCSV, tilePNG);
			parseBackground(backgroundCSV, tilePNG);
			backgroundCircuits.push(true);
			backgroundCircuits.push(true);
			
			add(map);
		}
	}
}