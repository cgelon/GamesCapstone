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
			
			add(map);
		}
		
		override public function checkInformant():void 
		{
			if (_informantTalked[0] == null && (Manager.getManager(PlayerManager) as PlayerManager).player.x > 600) {
				informant.talk("Try hitting [SPACE] near the switch, that might trigger something.");
				_informantTalked[0] = true;
			}
		}
	}
}