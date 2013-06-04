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
			parseObjects(ObjectsCSV, tilePNG);
			// Add the Forcefields and Generators 
			environmentalCircuits.push(true);
			
			parseBackground(BackgroundCSV, tilePNG);
			// Add the Acidflow and its lever
			backgroundCircuits.push(false);
			
			add(map);
			
			name = "ForceFieldAndAcid";
		}
		
		override public function checkInformant():void 
		{
			super.checkInformant();
			
			if (_informantTalked[0] == null)
			{
				informant.talk("Hmm... it seems like there is a regeneration panel in every sliding door. Very convenient! Dying is a thing of the past.");
				_informantTalked[0] = true;
			}
			
		}
	}
}