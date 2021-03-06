package levels
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class LightningIntro extends Level
	{
		[Embed(source = "../../assets/mapCSV_LightningIntro_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_LightningIntro_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_LightningIntro_Enemies.csv", mimeType = "application/octet-stream")] public var enemiesCSV : Class;
		[Embed(source = "../../assets/mapCSV_LightningIntro_Objects.csv", mimeType = "application/octet-stream")] public var objectsCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function LightningIntro ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map

			parsePlayer(playerCSV, tilePNG);
			parseEnemies(enemiesCSV, tilePNG);
			parseObjects(objectsCSV, tilePNG);
			
			add(map);
			
			name = "LightningIntro";
		}
		
		override public function checkInformant():void 
		{
			super.checkInformant();
			
			if (_informantTalked[0] == null) {
				informant.talk("Warning: new enemy ahead! What, they shoot lightning? How is that humanly possible? Oh wait...");
				_informantTalked[0] = true;
			}
		}
	}
}