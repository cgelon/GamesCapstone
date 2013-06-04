package levels
{
	import items.Environmental.ForceField;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.Robot;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class ForceFieldIntro extends Level
	{
		[Embed(source = "../../assets/mapCSV_ForcefieldIntro_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldIntro_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldIntro_Objects.csv", mimeType = "application/octet-stream")] public var objectsCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function ForceFieldIntro ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			parsePlayer(playerCSV, tilePNG);
			// Stores the player start points
			parseObjects(objectsCSV, tilePNG);
			environmentalCircuits.push(true);

			add(map);
			
			name = "ForceFieldIntro";
		}
		
		override public function checkInformant():void 
		{
			super.checkInformant();
			
			if (_informantTalked[0] == null) {
				informant.talk("Red forcefields, how original... why not purple, or magenta?");
				_informantTalked[0] = true;
			}
		}
	}
}