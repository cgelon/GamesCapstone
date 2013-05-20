package levels
{
	import items.Environmental.Background.Acid;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class StartingAcidLevel extends Level
	{
		[Embed(source = "../../assets/mapCSV_StartingAcid_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_StartingAcid_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_StartingAcid_Background.csv", mimeType = "application/octet-stream")] public var backgroundCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function StartingAcidLevel ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			parsePlayer(playerCSV, tilePNG);
			parseBackground(backgroundCSV, tilePNG);
			
			loadMessage = "What is that green stuff? Is that...ACID?! Why would anyone want to make that?";
			
			add(map);
		}
	}
}