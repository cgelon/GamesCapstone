package levels
{
	import items.Environmental.Background.Acid;
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Crate;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public class AcidCrates extends Level
	{
		[Embed(source = "../../assets/mapCSV_AcidCrates_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_AcidCrates_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_AcidCrates_Background.csv", mimeType = "application/octet-stream")] public var backgroundCSV : Class;
		[Embed(source = "../../assets/mapCSV_AcidCrates_Objects.csv", mimeType = "application/octet-stream")] public var objectsCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function AcidCrates ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;

			parsePlayer(playerCSV, tilePNG);
			parseBackground(backgroundCSV, tilePNG);
			parseObjects(objectsCSV, tilePNG);
			
			add(map);
			name = "AcidCrates";
		}
		
		override public function checkInformant():void 
		{
			super.checkInformant();
			
			if (_informantTalked[0] == null) {
				informant.talk("Here's a little known fact: crates resist highly corrosive acid. Who knew?");
				_informantTalked[0] = true;
			}
		}
	}
}