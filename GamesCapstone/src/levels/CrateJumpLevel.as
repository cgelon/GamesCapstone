package levels
{
	import items.Environmental.Crate;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public class CrateJumpLevel extends Level
	{	
		[Embed(source = "../../assets/mapCSV_CrateJump_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_CrateJump_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_CrateJump_Objects.csv", mimeType = "application/octet-stream")] public var objectsCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function CrateJumpLevel ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			parsePlayer(playerCSV, tilePNG);
			parseObjects(objectsCSV, tilePNG);
			
			add(map);
		}
		
		override public function checkInformant():void 
		{
			if (_informantTalked[0] == null) {
				informant.talk("You might be able to move crates by pressing [SPACE]... if you're strong enough.");
				_informantTalked[0] = true;
			}
		}
	}
}