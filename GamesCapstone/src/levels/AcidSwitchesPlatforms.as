package levels
{
	import items.Environmental.Background.Acid;
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.Lever;
	import managers.Manager;
	import managers.PlayerManager;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Michael Zhou
	 */
	public class AcidSwitchesPlatforms extends Level
	{
		[Embed(source = "../../assets/mapCSV_AcidSwitchesPlatforms_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_AcidSwitchesPlatforms_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_AcidSwitchesPlatforms_Background.csv", mimeType = "application/octet-stream")] public var backgroundCSV : Class;
		[Embed(source = "../../assets/mapCSV_AcidSwitchesPlatforms_Objects.csv", mimeType = "application/octet-stream")] public var objectsCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function AcidSwitchesPlatforms ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			
			parsePlayer(playerCSV, tilePNG);
			parseBackground(backgroundCSV, tilePNG);
			backgroundCircuits.push(true);
			parseObjects(objectsCSV, tilePNG);
			
			add(map);
			
			name = "AcidSwitchesPlatforms";
		}
		
		override public function checkInformant():void 
		{
			super.checkInformant();
			
			if (_informantTalked[0] == null && (Manager.getManager(PlayerManager) as PlayerManager).player.x > 600) {
				informant.talk("Switches? This McToggle guy doesn't know how to design evil labs...");
				_informantTalked[0] = true;
			}
		}
	}
}