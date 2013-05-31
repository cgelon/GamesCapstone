package levels
{
	import items.Environmental.Background.AcidFlow;
	import items.Environmental.Background.Lever;
	import items.Environmental.ForceField;
	import items.Environmental.Generator;
	import managers.Manager;
	import managers.PlayerManager;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxTilemap;
	import people.enemies.Robot;
	
	/**
	 * ...
	 * @author Lydia Duncan
	 */
	public class ForceFieldClimb extends Level
	{
		[Embed(source = "../../assets/mapCSV_ForcefieldClimb_Map.csv", mimeType = "application/octet-stream")] public var mapCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldClimb_Player.csv", mimeType = "application/octet-stream")] public var playerCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldClimb_Objects.csv", mimeType = "application/octet-stream")] public var ObjectsCSV : Class;
		[Embed(source = "../../assets/mapCSV_ForcefieldClimb_Enemies.csv", mimeType = "application/octet-stream")] public var EnemiesCSV : Class;
		[Embed(source = "../../assets/lab tile arrange.png")] public var tilePNG : Class;
		
		public function ForceFieldClimb ()
		{
			super();
			
			map.loadMap(new mapCSV(), tilePNG, 16, 16, 0, 0, 1, 352);
			
			width = map.width;
			height = map.height;
			// Initializes the map
			parsePlayer(playerCSV, tilePNG);
			// Stores the player start points
			parseEnemies(EnemiesCSV, tilePNG);
			parseObjects(ObjectsCSV, tilePNG);
			// Add the Forcefields and Generators 
			environmentalCircuits.push(true);
			environmentalCircuits.push(true);
			
			add(map);
		}
		
		override public function checkInformant():void 
		{
			if (_informantTalked[0] == null && (Manager.getManager(PlayerManager) as PlayerManager).player.x >  224) {
				informant.talk("You can put your soccer skills to the test by attacking [J or K] while crouching");
				_informantTalked[0] = true;
			} 
			else if (_informantTalked[1] == null && 
					 (Manager.getManager(PlayerManager) as PlayerManager).player.x < 512 &&
					 (Manager.getManager(PlayerManager) as PlayerManager).player.y < 256) 
			{
				informant.talk("You can also attack from above when you're falling");
				_informantTalked[1] = true;
			}
		}
	}
}